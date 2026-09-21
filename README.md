# InfluMatch

InfluMatch adds influence-guided relational consistency to FixMatch for
semi-supervised image classification. This release contains only the GDPH
dataset extension and FixMatch+InfluMatch code. It does not include BUS,
TN5000, internal experiment queues, checkpoints, CSV results, or image data.

## Method

For an unlabeled query, InfluMatch evaluates labeled candidates in the current
mini-batch using a closed-form approximation of last-layer influence. It selects
two proponents and two opponents, fuses the detached influence signal with
cosine similarity, and matches weak- and strong-view relation distributions.
The influence branch determines relation guidance; gradients flow through the
strong-view cosine relation.

## Dependency

InfluMatch is an extension of
[USB](https://github.com/microsoft/Semi-supervised-learning) / SemiLearn. It
does not redistribute USB source code. Install a pinned USB checkout first:

```bash
git clone https://github.com/microsoft/Semi-supervised-learning.git USB
cd USB
git checkout aa9018ca120b1fae082846195f72859cde4d32a6
pip install -r requirements.txt
pip install -e .
```

Then install this repository:

```bash
git clone https://github.com/xxzcs/InfluMatch.git
cd InfluMatch
pip install -e .
export USB_ROOT=/absolute/path/to/USB
```

## GDPH&SYSUCC Data Layout

This code uses the public GDPH&SYSUCC breast-ultrasound dataset released with
[HoVer-Trans](https://github.com/yuhaomo/HoVerTrans). Download the original
release from that repository rather than mirroring its 2,405 medical images
(886 benign and 1,519 malignant) here. This preserves the data provenance and
keeps distribution under the original authors' terms.

After downloading it, place the images and split metadata in the following
layout:

```text
data/GDPH_SYSUCC/
  label.csv      # columns: ID, fold, label
  img/
    <image files>
```

`fold` identifies the held-out fold. The loader uses all other folds for
training, performs class-stratified labeled sampling with `split_seed`, and
uses the remaining training images as unlabeled data.

## Training

Place the data under `data/GDPH_SYSUCC/` as documented in `data/README.md`,
then run:

```bash
USB_ROOT=/absolute/path/to/USB bash train_gdph.sh
```

The default command trains fold 0, seed 1. The configuration uses 20% labeled
data, 50 epochs, a labeled-to-unlabeled batch ratio of 1:30, ResNet-18 without
external pretraining, and the reported FixMatch+InfluMatch relation settings.
For the complete protocol, run:

```bash
USB_ROOT=/absolute/path/to/USB FOLDS="0 1 2 3 4" SEEDS="1 2 3 4 5" bash train_gdph.sh
USB_ROOT=/absolute/path/to/USB FOLDS="0 1 2 3 4" bash test_gdph.sh
```

`test_gdph.sh` loads the EMA latest checkpoint and reports AUC, accuracy,
sensitivity, specificity, and F1 in pooled and fold-mean CSV summaries.

## Attribution

InfluMatch builds on USB. Please cite the USB paper and comply with the USB
license when using its training infrastructure:

```bibtex
@inproceedings{wang2022usb,
  title     = {USB: A Unified Semi-supervised Learning Benchmark for Classification},
  author    = {Wang, Yidong and others},
  booktitle = {NeurIPS},
  year      = {2022}
}
```
