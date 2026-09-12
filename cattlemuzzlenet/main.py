import torch
import json
import random
import time
import numpy as np
from pathlib import Path
from PIL import Image
from collections import defaultdict
from torch.utils.data import Dataset, DataLoader, Sampler
from torchvision import transforms
from losses import ContrastiveLoss
from models import DeployEncoder, SiameseNet
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score


# ImageNet stats, nao derivadas do dataset: assim CFID, CMPD300 e as fotos do
# produtor compartilham o mesmo espaco de entrada, e trocar de dataset nao muda
# o pre-processamento. Mudar estes valores exige retreinar.
MEAN = [0.485, 0.456, 0.406]
STD = [0.229, 0.224, 0.225]


# ============================================================================
# PRE-PROCESSAMENTO
# ============================================================================

class Preprocess:
    def __init__(self, size=128, train=False):
        if train:
            steps = [
                transforms.RandomResizedCrop(size, scale=(0.8, 1.0)),
                transforms.RandomRotation(15),
                transforms.ColorJitter(brightness=0.2, contrast=0.2),
            ]
        else:
            steps = [transforms.Resize((size, size))]

        steps += [
            transforms.ToTensor(),
            transforms.Normalize(mean=MEAN, std=STD),
        ]
        self.transform = transforms.Compose(steps)

    def __call__(self, img):
        return self.transform(img)


# ============================================================================
# DADOS
# ============================================================================

class ManifestImages:
    """Substitui o ImageFolder: a divisao vem de splits/<dataset>.json, nao de pastas.

    Expoe .samples como [(path, label)], que e' o que o PairSampler consome.
    """

    IMG_EXT = {".jpg", ".jpeg", ".png", ".bmp", ".tif", ".tiff"}

    def __init__(self, root, manifest, split, subset, transform=None):
        root = Path(root)
        spec = json.loads(Path(manifest).read_text(encoding="utf-8"))["splits"][split]
        if subset not in spec:
            raise KeyError(f"subset '{subset}' nao existe em {manifest}:{split} "
                           f"(tem: {list(spec)})")
        self.classes = sorted(spec[subset])
        self.transform = transform
        self.samples = []
        for label, cow in enumerate(self.classes):
            files = sorted(f for f in (root / cow).iterdir()
                           if f.suffix.lower() in self.IMG_EXT)
            self.samples += [(f, label) for f in files]

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, i):
        path, label = self.samples[i]
        img = Image.open(path).convert("RGB")
        return (self.transform(img) if self.transform else img), label


class MuzzlePairDataset(Dataset):
    def __init__(self, root, manifest, split, subset, transform=None):
        self.dataset = ManifestImages(root, manifest, split, subset, transform)

    def __len__(self):
        return len(self.dataset)

    def __getitem__(self, pair):
        i, j, target = pair
        img1, _ = self.dataset[i]
        img2, _ = self.dataset[j]
        return img1, img2, torch.tensor(float(target))


class PairSampler(Sampler):
    def __init__(self, dataset, seed=42, shuffle=True):
        self.sample_labels = [label for _, label in dataset.dataset.samples]
        self.by_label = defaultdict(list)
        for idx, label in enumerate(self.sample_labels):
            self.by_label[label].append(idx)
        self.labels = list(self.by_label)
        self.seed = seed
        self.shuffle = shuffle
        self.epoch = 0

    def set_epoch(self, epoch):
        self.epoch = epoch

    def __len__(self):
        return len(self.sample_labels)

    def __iter__(self):
        rng = np.random.default_rng(np.random.SeedSequence([self.seed, self.epoch]))
        order = list(range(len(self.sample_labels)))
        if self.shuffle:
            rng.shuffle(order)
        for i in order:
            label = self.sample_labels[i]
            same = rng.random() < 0.5
            if same:
                options = [k for k in self.by_label[label] if k != i] or self.by_label[label]
                j = int(rng.choice(options))
            else:
                other = int(rng.choice([l for l in self.labels if l != label]))
                j = int(rng.choice(self.by_label[other]))
            yield (i, j, int(same))


# ============================================================================
# TREINO
# ============================================================================

class Trainer:
    def __init__(self, model, criterion, optimizer, scheduler, device, threshold=0.5):
        self.device = device
        self.model = model
        self.criterion = criterion
        self.optimizer = optimizer
        self.scheduler = scheduler
        self.threshold = threshold
        self.scaler = torch.amp.GradScaler()

    def train_epoch(self, loader):
        self.model.train()
        total = 0.0
        for img1, img2, label in loader:
            img1, img2, label = img1.to(self.device), img2.to(self.device), label.to(self.device)
            self.optimizer.zero_grad()
            with torch.autocast(device_type=self.device):
                d = self.model(img1, img2)
                loss = self.criterion(d, label)
            self.scaler.scale(loss).backward()
            self.scaler.step(self.optimizer)
            self.scaler.update()
            total += loss.item()
        return total / len(loader)

    def validate(self, loader):
        self.model.eval()
        preds, gts = [], []
        with torch.no_grad(), torch.autocast(device_type=self.device):
            for img1, img2, label in loader:
                d = self.model(img1.to(self.device), img2.to(self.device))
                preds += (d < self.threshold).float().cpu().tolist()
                gts += label.tolist()
        return (accuracy_score(gts, preds),
                precision_score(gts, preds, zero_division=0),
                recall_score(gts, preds, zero_division=0),
                f1_score(gts, preds, zero_division=0))

    def fit(self, train_loader, test_loader, epochs,
            ckpt_path="checkpoint.pth", best_path="model_best.pth", resume=False):
        start_epoch, best_f1 = 1, 0.0
        if resume and Path(ckpt_path).exists():
            start_epoch, best_f1 = self.load_checkpoint(ckpt_path)
            print(f"resumed at epoch {start_epoch} (best f1 {best_f1:.3f})")

        for epoch in range(start_epoch, epochs + 1):
            start = time.time()
            train_loader.sampler.set_epoch(epoch)
            loss = self.train_epoch(train_loader)
            self.scheduler.step()
            acc, prec, rec, f1 = self.validate(test_loader)

            is_best = f1 > best_f1
            if is_best:
                best_f1 = f1
                torch.save(self.model.state_dict(), best_path)
            self.save_checkpoint(ckpt_path, epoch, best_f1)

            print(f"epoch {epoch:03d} | {time.time() - start:5.1f}s | "
                  f"lr {self.scheduler.get_last_lr()[0]:.6f} | "
                  f"loss {loss:.4f} | acc {acc:.3f} prec {prec:.3f} rec {rec:.3f} f1 {f1:.3f}"
                  f"{' *' if is_best else ''}")

    def save(self, path):
        torch.save(self.model.state_dict(), path)

    def save_checkpoint(self, path, epoch, best_f1):
        torch.save({
            "epoch": epoch,
            "best_f1": best_f1,
            "model": self.model.state_dict(),
            "optimizer": self.optimizer.state_dict(),
            "scheduler": self.scheduler.state_dict(),
            "scaler": self.scaler.state_dict(),
        }, path)

    def load_checkpoint(self, path):
        ckpt = torch.load(path)
        self.model.load_state_dict(ckpt["model"])
        self.optimizer.load_state_dict(ckpt["optimizer"])
        self.scheduler.load_state_dict(ckpt["scheduler"])
        self.scaler.load_state_dict(ckpt["scaler"])
        return ckpt["epoch"] + 1, ckpt["best_f1"]

    def export_onnx(self, path, size):
        model = DeployEncoder(self.model.encoder, MEAN, STD).to(self.device).eval()
        dummy = torch.rand(1, 3, size, size, device=self.device) * 255
        torch.onnx.export(
            model, dummy, path,
            input_names=["image"], output_names=["embedding"],
            opset_version=17,
        )

    def verify_onnx(self, path, size, n=1):
        import onnxruntime as ort
        model = DeployEncoder(self.model.encoder, MEAN, STD).to(self.device).eval()
        x = torch.rand(n, 3, size, size, device=self.device) * 255
        with torch.no_grad():
            ref = model(x).cpu().numpy()
        sess = ort.InferenceSession(path, providers=["CPUExecutionProvider"])
        out = sess.run(["embedding"], {"image": x.cpu().numpy()})[0]
        diff = float(np.abs(ref - out).max())
        print(f"onnx max abs diff: {diff:.2e} (batch={n})")
        return diff


if __name__ == "__main__":
    
    SEED = 42
    DATASET = "cfid"           # "cfid" | "cmpd300"
    SPLIT = "debug"            # cfid: "default"|"debug" | cmpd300: "fold_1".."fold_5"|"debug"
    TRAIN_SUBSET, VAL_SUBSET = "train", "val"   # cmpd300 usa "train"/"test"
    IMG_SIZE = 128
    BATCH_SIZE = 32
    EPOCHS = 3                 # debug; o paper usa 200
    LR_INIT = 1e-3
    LR_FINAL = 1e-4
    MARGIN = 1.5
    WORKERS = 0 if SPLIT == "debug" else 4

    DATA_DIR = Path("datasets") / DATASET
    MANIFEST = Path("splits") / f"{DATASET}.json"
    RUN_DIR = Path("runs") / f"{DATASET}_{SPLIT}"
    RUN_DIR.mkdir(parents=True, exist_ok=True)
    
    if not torch.cuda.is_available():
        raise RuntimeError("CUDA not available")
    device = "cuda"
    print("Device:", torch.cuda.get_device_name(0))

    random.seed(SEED)
    torch.manual_seed(SEED)
    torch.cuda.manual_seed_all(SEED)

    train_ds = MuzzlePairDataset(DATA_DIR, MANIFEST, SPLIT, TRAIN_SUBSET,
                                 transform=Preprocess(IMG_SIZE, train=True))
    val_ds = MuzzlePairDataset(DATA_DIR, MANIFEST, SPLIT, VAL_SUBSET,
                               transform=Preprocess(IMG_SIZE, train=False))
    train_sampler = PairSampler(train_ds, seed=SEED, shuffle=True)
    val_sampler = PairSampler(val_ds, seed=SEED, shuffle=False)
    loader_kw = dict(pin_memory=True, num_workers=WORKERS,
                     persistent_workers=WORKERS > 0)
    train_loader = DataLoader(train_ds, batch_size=BATCH_SIZE, sampler=train_sampler, **loader_kw)
    val_loader = DataLoader(val_ds, batch_size=BATCH_SIZE, sampler=val_sampler, **loader_kw)
    print(f"{DATASET}/{SPLIT}: train {len(train_ds)} imgs ({len(train_ds.dataset.classes)} ids) | "
          f"val {len(val_ds)} imgs ({len(val_ds.dataset.classes)} ids)")

    model = SiameseNet().to(device)
    criterion = ContrastiveLoss(m=MARGIN)
    optimizer = torch.optim.Adam(model.parameters(), lr=LR_INIT)
    scheduler = torch.optim.lr_scheduler.LinearLR(
        optimizer, start_factor=1.0, end_factor=LR_FINAL / LR_INIT, total_iters=EPOCHS)

    trainer = Trainer(model, criterion, optimizer, scheduler, device)
    trainer.fit(train_loader, val_loader, EPOCHS,
                ckpt_path=RUN_DIR / "checkpoint.pth",
                best_path=RUN_DIR / "model_best.pth",
                resume=True)
    trainer.save(RUN_DIR / "model.pth")
    onnx_path = RUN_DIR / "cattlemuzzlenet.onnx"
    trainer.export_onnx(onnx_path, IMG_SIZE)
    trainer.verify_onnx(onnx_path, IMG_SIZE, n=1)
    print(f"Saved in {RUN_DIR}: model.pth, model_best.pth, cattlemuzzlenet.onnx")
