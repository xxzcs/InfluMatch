"""Register the InfluMatch algorithm and the GDPH dataset extension."""

from semilearn.core.utils import ALGORITHMS

from .fixmatch_ifcf import FixMatchInfluMatch
from .gdph import get_gdph


def _get_dataset_with_gdph(args, algorithm, dataset, num_labels, num_classes,
                           data_dir, lpath, ulpath, include_lb_to_ulb=True):
    if dataset == "gdph":
        lb_dset, ulb_dset, eval_dset, test_dset = get_gdph(
            args, algorithm, dataset, num_labels, num_classes,
            data_dir=data_dir, include_lb_to_ulb=include_lb_to_ulb,
        )
        return {
            "train_lb": lb_dset,
            "train_ulb": ulb_dset,
            "eval": eval_dset,
            "test": test_dset,
        }
    return _UPSTREAM_GET_DATASET(
        args, algorithm, dataset, num_labels, num_classes, data_dir, lpath,
        ulpath, include_lb_to_ulb,
    )


_REGISTERED = False
_UPSTREAM_GET_DATASET = None


def register():
    """Install the plugin into an existing USB/SemiLearn checkout."""
    global _REGISTERED, _UPSTREAM_GET_DATASET
    if _REGISTERED:
        return

    ALGORITHMS["fixmatch_influmatch"] = FixMatchInfluMatch

    import semilearn.algorithms as algorithms
    import semilearn.core.algorithmbase as algorithmbase
    import semilearn.core.utils.build as build
    import semilearn.datasets as datasets

    algorithms.name2alg["fixmatch_influmatch"] = FixMatchInfluMatch
    datasets.get_gdph = get_gdph
    _UPSTREAM_GET_DATASET = build.get_dataset
    build.get_dataset = _get_dataset_with_gdph
    # AlgorithmBase imported get_dataset directly, so patch that binding too.
    algorithmbase.get_dataset = _get_dataset_with_gdph
    _REGISTERED = True
