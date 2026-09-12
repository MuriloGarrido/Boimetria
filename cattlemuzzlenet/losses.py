import torch
from torch import nn


class ContrastiveLoss(nn.Module):
    def __init__(self, m=1.0):
        super().__init__()
        self.m = m

    def forward(self, d, y):
        loss = y * d.pow(2) + (1 - y) * torch.clamp(self.m - d, min=0).pow(2)
        return loss.mean()
