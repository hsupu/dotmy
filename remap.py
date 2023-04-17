#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
import os
import re
import sys

from dotenv import dotenv_values


gvars = {
    **dotenv_values(".env.shared"),
    **dotenv_values(".env"),
    **os.environ,
}
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


# py3.8 doesn't support 'type dict', use higher versions instead if error
def apply(mapping: dict[str, str], curdir: str):
    def normalize(src0: str, dst0: str):
        src = string_substitute(src0)
        dst = string_substitute(dst0)

        if len(src) == 0:
            print('WARN EmptySrc', src0)
            return None

        if src == '/':
            print('WARN RootMapping', src0)
            return None

        src_is_dir = src[-1:] == '/'
        dst_in_dir = dst[-1:] == '/'

        if src[0] != '/':
            src = os.path.abspath(os.path.join(curdir, src))

        if not os.path.islink(src):
            if src_is_dir:
                if not os.path.isdir(src):
                    print('ERROR Src.NotADir: "{}"'.format(src))
                    return None
            else:
                if not os.path.isfile(src):
                    print('ERROR Src.NotAFile: "{}"'.format(src))
                    return None
        else:
            print('INFO Src.IsALink: "{}"'.format(src))

        if dst_in_dir:
            lastname = os.path.basename(src)
            dst = os.path.join(dst, lastname)

        # Python treats broken link as not-exist
        if os.path.islink(dst):
            target = os.path.realpath(dst)
            if src == target:
                # print('INFO Skip: "{}" => "{}"'.format(dst, src))
                return None

            if not os.path.exists(target):
                print('WARN Dst.LinkBroken: "{}" => "{}" (expect "{}")'.format(dst, target, src))
                return None

            print('WARN Dst.LinkOther: "{}" => "{}" (expect "{}")'.format(dst, target, src))
            return None
        elif os.path.exists(dst):
            print('ERROR Dst.NotALink: "{}"'.format(dst))
            return None

        # print(src_is_dir, src, dst)
        return (src, dst, src_is_dir)

    def link(src: str, dst: str, src_is_dir: bool, sudo: bool=False):
        try:
            dst_dir = os.path.dirname(dst)
            if not os.path.exists(dst_dir):
                os.makedirs(dst_dir, exist_ok=False)

            os.symlink(src, dst, target_is_directory=src_is_dir)
            print('INFO Success: "{}" => "{}"'.format(dst, src))
        except PermissionError:
            if not sudo:
                return link(src, dst, src_is_dir, sudo=True)

            print('ERROR NoPerm: "{}"'.format(dst))

    fns = map(lambda x: link(*x),
        filter(lambda x: x is not None,
        map(lambda x: normalize(*x),
        mapping.items())))
    for e in fns:
        pass # force to eval


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--map-file', type=str, required=False, default='$DOTMY/mapping.py')
    cmdargs = parser.parse_args()

    map_file = string_substitute(cmdargs.map_file)
    map_file_dir = os.path.dirname(map_file)
    # print(map_file)

    my_vars = {}
    exec(open(map_file).read(), my_vars)
    # print(my_vars['mapping'])

    apply(my_vars['mapping'], map_file_dir)


if __name__ == '__main__':
    main()
