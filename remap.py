#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
import logging
import os
import re
import shutil
import sys

from abc import ABC, ABCMeta, abstractmethod


logging.basicConfig(level=logging.DEBUG)
_logger = logging.getLogger(__name__)

gvars = {}

# available since 3.4
# import importlib.util
# if importlib.util.find_spec('dotenv'):
# deprecated since 3.12
# import pkgutil
# if pkgutil.find_loader('dotenv'):
try:
    import dotenv
    gvars.update(dotenv.dotenv_values(".env.shared"))
    gvars.update(dotenv.dotenv_values(".env"))
# else:
except ModuleNotFoundError:
    _logger.warning("module 'dotenv' not installed, dotenv files will not be loaded")

gvars.update(os.environ)
if 'DOTMY' not in gvars:
    gvars['DOTMY'] = (os.path.dirname(os.path.realpath(__file__)))

is_sudo = os.geteuid() == 0


def string_substitute(s: str):
    # s = s.replace('{', '{{{{')
    # s = s.replace('}', '}}}}')

    def fn_sub_wrapped(matched: re.Match[str]):
        return '{{{}}}'.format(matched.group(0)[2:-1])
    s = re.sub(r'\${[A-Za-z0-9_]+}', fn_sub_wrapped, s)

    def fn_sub(matched: re.Match[str]):
        # print(repr(matched))
        return '{{{}}}'.format(matched.group(0)[1:])
    s = re.sub(r'\$[A-Za-z0-9_]+', fn_sub, s)

    return s.format_map(gvars)


class ItemDef():

    def __init__(self):
        self.dst = ''
        self.src = ''
        self.attrs = {}

        self.need_copy = False
        self.need_sudo = False
        self.src_is_dir = False
        self.dst_is_exist = False
        self.dst_is_link = False
        self.target = None
        self.target_is_broken = False
        self.target_is_expected = False

    @staticmethod
    def from_tuple(t: tuple[str, str, dict|None]):
        item = ItemDef()
        item.dst = t[0]
        item.src = t[1]
        if len(t) > 2:
            item.attrs = t[2]
        return item

    def __repr__(self):
        return '"{}" <- "{}" {}'.format(
            self.dst,
            self.src,
            self.attrs
        )

    def __str__(self):
        return '"{}" <- "{}"'.format(
            self.dst,
            self.src
        )

    def path_normalize(self, curdir: str):
        # variable apply
        src = string_substitute(self.src)
        dst = string_substitute(self.dst)

        if len(src) == 0:
            _logger.warning('EmptySrc', self.src)
            return None

        if src == '/':
            _logger.warning('RootMapping', self.src)
            return None

        # *nix won't care about link source type
        src_is_dir = src[-1:] == '/'
        # if true, add lastname of src
        dst_in_dir = dst[-1:] == '/'

        # rel to abs
        if src[0] != '/':
            src = os.path.abspath(os.path.join(curdir, src))
            # print(src)

        if not os.path.islink(src):
            if src_is_dir:
                if not os.path.isdir(src):
                    _logger.error('SrcNotADir: "{}"'.format(src))
                    return None
            else:
                if not os.path.isfile(src):
                    _logger.error('SrcNotAFile: "{}"'.format(src))
                    return None
        else:
            _logger.info('SrcIsALink: "{}"'.format(src))

        if dst_in_dir:
            lastname = os.path.basename(src)
            dst = os.path.join(dst, lastname)

        # print(src_is_dir, src, dst)
        self.src, self.dst, self.src_is_dir = src, dst, src_is_dir
        return self

    def check_status(self):

        self.need_copy = self.attrs.get('copy', False)
        self.need_sudo = self.attrs.get('sudo', False)

        # Python treats broken link as not-exist, so we need to check islink first
        self.dst_is_link = os.path.islink(self.dst)
        if not self.dst_is_link:
            self.dst_is_exist = os.path.exists(self.dst)
            return
        self.dst_is_exist = True

        self.target = os.path.realpath(self.dst)
        self.target_is_broken = not os.path.exists(self.target)

        norm_target = self.target
        if not self.target_is_broken and os.path.isdir(self.target) and norm_target[-1:] != '/':
            norm_target += '/'

        norm_src = self.src
        # already checked in path_normalize
        # if self.src_is_dir and norm_src[-1:] != '/':
        #     norm_src += '/'

        self.target_is_expected = (norm_src == norm_target)

    def apply(self):
        if is_sudo != self.need_sudo:
            _logger.error('Unexpected. SudoMismatch: {}'.format(self))
            return

        try:
            dst_dir = os.path.dirname(self.dst)
            if not os.path.exists(dst_dir):
                os.makedirs(dst_dir, exist_ok=False)

            if self.dst_is_exist:
                os.unlink(self.dst)

            if self.need_copy:
                shutil.copy2(self.src, self.dst)
                _logger.info('Copy {}'.format(str(self)))
            else:
                os.symlink(self.src, self.dst, target_is_directory=self.src_is_dir)
                _logger.info('Link {}'.format(str(self)))
        except PermissionError as exc:
            _logger.error('NoPerm: "{}"'.format(self.dst), exc_info=exc)


class IMappingDefs(ABC):

    @property
    @abstractmethod
    def declares(self) -> tuple[str, str, dict]:
        pass

    @property
    @abstractmethod
    def includes(self) -> list[str]:
        pass


class Main:

    def __init__(self, args):
        self.args = args
        self.items = [] # type: list[ItemDef]
        self.dsts = set()

    def _parse_defs(self, input: IMappingDefs, curdir: str):
        if hasattr(input, 'declares'):
            for dec in input.declares:
                item = ItemDef.from_tuple(dec).path_normalize(curdir)
                if item is None:
                    continue
                if item.dst in self.dsts:
                    _logger.debug('DefDup: "{}"'.format(item.dst))
                    continue

                _logger.debug('Add {}'.format(item))
                item.check_status()
                if is_sudo and not item.need_sudo:
                    _logger.debug("SudoMismatch: {}".format(item))
                    continue

                if item.dst_is_exist:
                    if not item.dst_is_link:
                        if item.need_copy:
                            _logger.debug('DstExist: "{}" (copy from "{}")'.format(item.dst, item.src))
                        else:
                            _logger.error('DstNotALink: "{}"'.format(item.dst))
                        continue

                    if item.target_is_expected:
                        if item.target_is_broken:
                            _logger.warning('LinkExist.Broken: {}'.format(item))
                        else:
                            _logger.debug('LinkExist: {}'.format(item))
                        continue

                    if item.target_is_broken:
                        _logger.warning('LinkOther.Broken: "{}" => "{}" (expect "{}")'.format(item.dst, item.target, item.src))
                        if not self.args.fix_other and not self.args.fix_broken:
                            continue
                    else:
                        _logger.warning('LinkOther: "{}" => "{}" (expect "{}")'.format(item.dst, item.target, item.src))
                        if not self.args.fix_other:
                            continue

                self.dsts.add(item.dst)
                self.items.append(item)

        if hasattr(input, 'includes'):
            for inc in input.includes:
                self.include(inc, curdir)

    def include(self, input, curdir: str):
        if hasattr(input, 'declares') or hasattr(input, 'includes'):
            self._parse_defs(input, curdir)
            return

        if isinstance(input, str):
            map_file = input
            target_var = 'mapping'
        elif isinstance(input, tuple):
            map_file, target_var = input
        else:
            _logger.error('InvalidInclude: {}'.format(input))
            return

        map_file = string_substitute(map_file)

        if map_file[0] != '/':
            map_file = os.path.abspath(os.path.join(curdir, map_file))

        if os.path.isdir(map_file):
            map_file = os.path.join(map_file, 'mapping.py')

        if not os.path.exists(map_file):
            _logger.error('IncNotExist: "{}"'.format(map_file))
            return

        map_file_dir = os.path.dirname(map_file)
        # print(map_file, map_file_dir)

        my_vars = {}
        exec(open(map_file).read(), my_vars)
        # print(my_vars)

        target = my_vars[target_var]
        _logger.info("Including {} {}".format(map_file, target_var))
        self.include(target, map_file_dir)

    def start(self):
        self.include(self.args.map_file, os.path.curdir)

        if not self.args.dry_run:
            if os.geteuid() == 0:
                # print(sys.argv)
                confirm = input('run as root, continue? [Yy]')
                if not confirm or confirm not in ['Y', 'y']:
                    _logger.error('User cancelled')
                    return

        for item in self.items:
            if self.args.dry_run:
                _logger.info('DryRun: "{}" => "{}"'.format(item.dst, item.src))
            else:
                item.apply()


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--map-file', type=str, required=False, default='$DOTMY/profiles/current/mapping.py')
    parser.add_argument('--dry-run', action='store_true', default=False)
    parser.add_argument('--fix-broken', action='store_true', default=False)
    parser.add_argument('--fix-other', action='store_true', default=False)
    args = parser.parse_args()
    Main(args).start()
