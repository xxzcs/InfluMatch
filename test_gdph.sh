#!/usr/bin/env bash
set -euo pipefail

# Evaluate EMA latest checkpoints. Use the same folds/seeds used in training.
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
USB_ROOT=${USB_ROOT:?Set USB_ROOT to the pinned USB checkout.}
FOLDS=${FOLDS:-"0"}
DATA_DIR=${DATA_DIR:-"${ROOT_DIR}/data/GDPH_SYSUCC"}
CHECKPOINT_GLOB=${CHECKPOINT_GLOB:-"${ROOT_DIR}/saved_models/influ_match_gdph_20pct_fold{fold}_seed*/latest_model.pth"}
SUMMARY=${SUMMARY:-"${ROOT_DIR}/results/gdph_influmatch_20pct_latest_pooled.csv"}
FOLDMEAN=${FOLDMEAN:-"${ROOT_DIR}/results/gdph_influmatch_20pct_latest_foldmean.csv"}

cd "${ROOT_DIR}"
mkdir -p results

PYTHONPATH="${ROOT_DIR}:${USB_ROOT}${PYTHONPATH:+:${PYTHONPATH}}" \
    python "${ROOT_DIR}/eval_sup_cv.py" \
    --load_glob_template "${CHECKPOINT_GLOB}" \
    --folds ${FOLDS} \
    --dataset gdph --num_classes 2 --net resnet18 --model_key ema_model \
    --data_dir "${DATA_DIR}" \
    --label_ratio 0.2 --num_labels 384 \
    --batch_size 16 --num_workers 0 --eval_dest eval \
    --summary_csv "${SUMMARY}" --foldmean_csv "${FOLDMEAN}" \
    --method_suffix latest
