import json
from pathlib import Path

from PIL import Image
from torch.utils.data import Dataset
from torchvision import transforms

from model import MEAN, STD

IMG_EXT = {".jpg", ".jpeg", ".png", ".bmp", ".tif", ".tiff"}


class MuzzleDataset(Dataset):
    """Imagens de um subset (train/val/test) de um fold de um split file.

    Cada dataset e' uma pasta com as imagens e os seus splits:
        datasets/<dataset>/images/<vaca>/*.png
        datasets/<dataset>/splits/<nome>.json
    As imagens sao achadas a partir do proprio split file (../images).
    Labels sao locais ao subset (0..n_vacas-1). O id real da vaca fica em .classes.
    """

    def __init__(self, split_file, fold, subset, transform=None):
        split_file = Path(split_file)
        m = json.loads(split_file.read_text(encoding="utf-8"))
        if fold not in m["folds"]:
            raise KeyError(f"fold '{fold}' not found in {split_file} (available: {list(m['folds'])})")
        self.dataset = m["dataset"]
        root = split_file.parent.parent / "images"
        spec = m["folds"][fold]
        if subset not in spec:
            raise KeyError(f"subset '{subset}' not found in {split_file}:{fold} (available: {list(spec)})")
        self.classes = sorted(spec[subset])
        self.transform = transform
        self.samples = []
        for label, cow in enumerate(self.classes):
            files = sorted(f for f in (root / cow).iterdir() if f.suffix.lower() in IMG_EXT)
            if not files:
                raise FileNotFoundError(f"no images in {root / cow}")
            self.samples += [(f, label) for f in files]
        self.labels = [label for _, label in self.samples]

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, i):
        path, label = self.samples[i]
        img = Image.open(path).convert("RGB")
        return (self.transform(img) if self.transform else img), label


def build_transform(img_size, train=False):
    if train:
        steps = [
            transforms.RandomResizedCrop(img_size, scale=(0.8, 1.0)),
            transforms.RandomRotation(15),
            transforms.ColorJitter(brightness=0.2, contrast=0.2),
        ]
    else:
        steps = [transforms.Resize((img_size, img_size))]
    return transforms.Compose(steps + [transforms.ToTensor(), transforms.Normalize(MEAN, STD)])
