
from pip._vendor.distlib.scripts import ScriptMaker

import sys


sm = ScriptMaker(
    source_dir=None,        # using entry spec instead
    target_dir=".",         # folder to put
    add_launchers=False,    # whether to create .exe or .py
)

# 对 Windows 而言 python pythonw 不同
sm.executable = sys.executable
if sm.executable.index("pythonw") > -1:
    sm.executable = sm.executable.replace("pythonw", "python")

# create only the main variant (not the one with X.Y suffix)
sm.variants = [""]

# provide an entry specification string here, just like in pyproject.toml
sm.make("yolo = ultralytics.cfg:entrypoint")
