#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
import os
import re
import shutil
import sys

from abc import ABC, ABCMeta, abstractmethod


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
    print("module 'dotenv' not installed, dotenv files will not be loaded")

gvars.update(os.environ)
if 'DOTMY' not in gvars:
    gvars['DOTMY'] = (os.path.dirname(os.path.realpath(__file__)))


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

    def path_normalize(self, curdir: str):
        # variable apply
        src = string_substitute(self.src)
        dst = string_substitute(self.dst)

        if len(src) == 0:
            print('WARN  EmptySrc', self.src)
            return None

        if src == '/':
            print('WARN  RootMapping', self.src)
            return None

        # *nix won't care about link source type
        src_is_dir = src[-1:] == '/'
        # if true, add lastname of src
        dst_in_dir = dst[-1:] == '/'

        # rel to abs
        if src[0] != '/':
            src = os.path.abspath(os.path.join(curdir, src))

        if not os.path.islink(src):
            if src_is_dir:
                if not os.path.isdir(src):
                    print('ERROR SrcNotADir: "{}"'.format(src))
                    return None
            else:
                if not os.path.isfile(src):
                    print('ERROR SrcNotAFile: "{}"'.format(src))
                    return None
        else:
            print('INFO  SrcIsALink: "{}"'.format(src))

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
        is_sudo = os.geteuid() == 0
        if is_sudo != self.need_sudo:
            print('INFO  Ignored: "{}" sudo={}'.format(self.dst, self.need_sudo))
            return

        try:
            dst_dir = os.path.dirname(self.dst)
            if not os.path.exists(dst_dir):
                os.makedirs(dst_dir, exist_ok=False)

            if self.dst_is_exist:
                os.unlink(self.dst)

            if self.need_copy:
                shutil.copy2(self.src, self.dst)
                print('INFO  Copied: "{}" => "{}"'.format(self.dst, self.src))
            else:
                os.symlink(self.src, self.dst, target_is_directory=self.src_is_dir)
                print('INFO  Linked: "{}" => "{}"'.format(self.dst, self.src))
        except PermissionError:
            print('ERROR NoPerm: "{}"'.format(self.dst))


class IMappingDefs(ABC):

    @property
    @abstractmethod
    def declares(self) -> tuple[str, str, dict]:
        pass

    @property
    @abstractmethod
    def includes(self) -> list[str]:
        pass


class Engine:

    def __init__(self, cmdargs):
        self.cmdargs = cmdargs
        self.items = [] # type: list[ItemDef]
        self.dsts = set()

    def _parse_defs(self, input: IMappingDefs, curdir: str):
        if hasattr(input, 'declares'):
            for dec in input.declares:
                item = ItemDef.from_tuple(dec).path_normalize(curdir)
                if item is None:
                    continue
                if item.dst in self.dsts:
                    print('DEBUG DefDup: "{}"'.format(item.dst))
                    continue

                item.check_status()
                if item.dst_is_exist:
                    if not item.dst_is_link:
                        if item.need_copy:
                            print('DEBUG DstFileExist: "{}" (copy src "{}")'.format(item.dst, item.src))
                        else:
                            print('ERROR DstNotALink: "{}"'.format(item.dst))
                        continue

                    if item.target_is_expected:
                        if item.target_is_broken:
                            print('WARN  LinkExist.Broken: "{}" => "{}"'.format(item.dst, item.src))
                        else:
                            print('DEBUG LinkExist: "{}" => "{}"'.format(item.dst, item.src))
                        continue

                    if item.target_is_broken:
                        print('WARN  LinkOther.Broken: "{}" => "{}" (expect "{}")'.format(item.dst, item.src, item.target))
                        if not self.cmdargs.fix_other and not self.cmdargs.fix_broken:
                            continue
                    else:
                        print('WARN  LinkOther: "{}" => "{}" (expect "{}")'.format(item.dst, item.src, item.target))
                        if not self.cmdargs.fix_other:
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
            target = 'mapping'
        elif isinstance(input, tuple):
            map_file, target = input
        else:
            print('ERROR InvalidInclude', input)
            return

        map_file = string_substitute(map_file)

        if map_file[0] != '/':
            map_file = os.path.abspath(os.path.join(curdir, map_file))

        if os.path.isdir(map_file):
            map_file = os.path.join(map_file, 'mapping.py')

        if not os.path.exists(map_file):
            print('ERROR IncNotExist: "{}"'.format(map_file))
            return

        map_file_dir = os.path.dirname(map_file)
        # print(map_file, map_file_dir)

        my_vars = {}
        exec(open(map_file).read(), my_vars)
        # print(my_vars)

        target = my_vars[target]
        # print(target)
        self.include(target, map_file_dir)

    def start(self):
        self.include(self.cmdargs.map_file, os.path.curdir)

        if not self.cmdargs.dry_run:
            if os.geteuid() == 0:
                # print(sys.argv)
                confirm = input('run as root, continue? [Yy]')
                if not confirm or confirm not in ['Y', 'y']:
                    print('User cancelled')
                    return

        for item in self.items:
            if self.cmdargs.dry_run:
                print('INFO  DryRun: "{}" => "{}"'.format(item.dst, item.src))
            else:
                item.apply()


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--map-file', type=str, required=False, default='$DOTMY/profiles/current/mapping.py')
    parser.add_argument('--dry-run', action='store_true', default=False)
    parser.add_argument('--fix-broken', action='store_true', default=False)
    parser.add_argument('--fix-other', action='store_true', default=False)
    cmdargs = parser.parse_args()
    Engine(cmdargs).start()
