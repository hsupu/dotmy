# 241231
# see https://stackoverflow.com/questions/35412392/how-can-i-use-setuptools-to-create-an-exe-launcher

import logging
import os
import re
import sys

from pip._vendor.distlib.scripts import ScriptMaker


def main(args = None):
    logger = logging.getLogger(__name__)

    # Windows venv 不在 bin/ 子目录
    bindir = os.path.join(sys.exec_prefix, "Scripts")
    # logger.info(bindir)

    regex_shabang = re.compile(r'#!(.+\\python\.exe)')
    regex_entrypoint = re.compile(r'^from (\S+) import (\S+)$', re.MULTILINE)

    sm = ScriptMaker(
        source_dir=None,        # None to using entry spec instead
        target_dir=bindir,      # folder to put
        add_launchers=True,     # True to create .exe, False to create .py
    )

    # 对 Windows 而言 python pythonw 不同
    sm.executable = sys.executable
    if sm.executable.endswith("pythonw.exe") > -1:
        sm.executable = sm.executable.replace("pythonw", "python")

    # create only the main variant (not the one with X.Y suffix)
    sm.variants = [""]

    for filename in os.listdir(bindir):
        if not filename.endswith('.exe'):
            continue

        fullname = os.path.join(bindir, filename)
        logger.info('Open', fullname)
        with open(fullname, 'rb') as f:
            f.seek(0x1A600)
            shabang = f.readline(1024)
            if not shabang.endswith(b'python.exe\n'):
                continue

            shabang = shabang.decode().rstrip()
            match = regex_shabang.match(shabang)
            if not match:
                logger.error(f'Ending with python.exe, but not matched. On another venv?: {filename}\n{shabang}')
                continue
            logger.debug(shabang)

            if match.group(1).casefold() == sys.executable.casefold():
                logger.debug(f'Unchanged: {filename}')
                continue

            if f.read(4) != b'PK\03\04':
                logger.error(f'Magic error: {filename}')
                continue

            if True:
                l = int.from_bytes(f.read(2), 'little')
                metadata = f.read(l)
                logger.debug(l, metadata)
                l = int.from_bytes(f.read(4), 'little')
                pyfilename = f.read(l)  # .decode()
                logger.debug(l, pyfilename)
                l = int.from_bytes(metadata[-4:], 'little')
                content = f.read(l).decode()
                logger.debug(l, content)
                match = regex_entrypoint.search(content)
                if not match:
                    logger.error(f'Entrypoint not matched. This tool is outdated?: {filename}\n{content}')
                    return

                basename, extname = os.path.basename(fullname).rsplit('.', maxsplit=1)
                modulepath, varname = match.group(1), match.group(2)
                spec = f"{basename} = {modulepath}:{varname}"
                logger.warning(spec)

        # return
        # provide an entry specification string here, just like in pyproject.toml
        sm.make(spec)
        # return


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    args = parser.parse_args()
    logging.basicConfig(level=logging.WARNING)
    main(args)
