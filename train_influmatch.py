#!/usr/bin/env python3
"""Launch InfluMatch on top of a local USB/SemiLearn checkout.

Set USB_ROOT to the root of the pinned USB checkout. If it is omitted, the
launcher tries to infer the checkout root from the installed ``semilearn``
package. An editable USB installation is therefore recommended.
"""

import os
import runpy
from pathlib import Path

import semilearn

from influmatch import register


register()

usb_root = Path(os.environ.get("USB_ROOT", Path(semilearn.__file__).resolve().parents[1]))
train_entry = usb_root / "train.py"
if not train_entry.is_file():
    raise FileNotFoundError(
        f"Cannot find USB train.py at {train_entry}. Set USB_ROOT to a USB checkout."
    )

runpy.run_path(str(train_entry), run_name="__main__")
