#!/usr/bin/env bash
set -euo pipefail

# Reproduce GDPH FixMatch+InfluMatch. Defaults run one fold/seed; set
# FOLDS="0 1 2 3 4" SEEDS="1 2 3 4 5" for the complete 5x5 protocol.
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
USB_ROOT=${USB_ROOT:?Set USB_ROOT to the pinned USB checkout.}
FOLDS=${FOLDS:-"0"}
SEEDS=${SEEDS:-"1"}
CONFIG=${CONFIG:-"${ROOT_DIR}/configs/gdph/fixmatch_influmatch_20pct.yaml"}
DATA_DIR=${DATA_DIR:-"${ROOT_DIR}/data/GDPH_SYSUCC"}

cd "${ROOT_DIR}"
mkdir -p saved_models logs config/generated

set_yaml() {
    local file=$1 key=$2 value=$3
    if grep -qE "^${key}:" "${file}"; then
        sed -i "s|^${key}:.*|${key}: ${value}|" "${file}"
    else
        printf '%s: %s\n' "${key}" "${value}" >> "${file}"
    fi
}

for fold in ${FOLDS}; do
    for seed in ${SEEDS}; do
        name="influ_match_gdph_20pct_fold${fold}_seed${seed}"
        cfg="config/generated/${name}.yaml"
        cp "${CONFIG}" "${cfg}"
        set_yaml "${cfg}" save_name "${name}"
        set_yaml "${cfg}" save_dir "./saved_models"
        set_yaml "${cfg}" load_path "./saved_models/${name}/latest_model.pth"
        set_yaml "${cfg}" data_dir "${DATA_DIR}"
        set_yaml "${cfg}" fold "${fold}"
        set_yaml "${cfg}" seed "${seed}"

        echo "[$(date)] Training ${name}"
        PYTHONPATH="${ROOT_DIR}:${USB_ROOT}${PYTHONPATH:+:${PYTHONPATH}}" \
            USB_ROOT="${USB_ROOT}" python "${ROOT_DIR}/train_influmatch.py" --c "${cfg}"
    done
done
