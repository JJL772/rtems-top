#!/usr/bin/env python3

"""
Utility script to configure RTEMS and related packages for building.
After packages are configured, they can be built and installed using waf.

BSP features are loosely defined by bsps.toml, that lives next to this script.

Example usage:

  # Configure RTEMS for build
  ./configure.py --project rtems

  # Configure libbsd for build
  ./configure.py --project libbsd
  
  # Configure RTEMS and install to rtems_p2 directory
  ./configure.py --project rtems --dest-subdir rtems_p2
  
"""

import tomllib
import argparse
import os
import subprocess
from typing import TypedDict, Callable


parser = argparse.ArgumentParser()
parser.add_argument('--project', required=True, type=str, help=f'Project to configure. Must be one of: rtems, rtems-libbsd, rtems-net-legacy, rtems-net-services')
parser.add_argument('--top', dest='TOP', type=str, default=f'{os.path.dirname(__file__)}', help='Location of the topdir')
parser.add_argument('--dest-subdir', dest='SUBDIR', type=str, default='rtems', help='Destination subdir within target directory')
args = parser.parse_args()

#PREFIX="$PWD/../../target/rtems"

class ConfigEntry(TypedDict):
    bsp: str
    arch: str
    config: str
    networking: str
    net_services: bool

class ConfigRoot(TypedDict):
    entries: list[ConfigEntry]

def _get_rtems_top() -> str:
    """
    Top of the RTEMS install location
    """
    return args.TOP

def _get_prefix() -> str:
    """
    Returns the installation prefix for RTEMS build products
    """
    return f'{_get_rtems_top()}/target/{args.SUBDIR}'

def _get_host_prefix() -> str:
    """
    Returns the location of tools that run on the host
    """
    return f'{_get_rtems_top()}/host/linux-x86_64'

def _get_srcdir() -> str:
    """
    Returns the source dir
    """
    return f'{_get_rtems_top()}/src'

def _transform_key(key: str) -> tuple[str, str]:
    """
    Transforms a key from the form <ARCH>-<BSP> to a tuple of (ARCH, BSP)
    """
    arch = key.split('-')[0]
    return (arch, key.replace(f'{arch}-', ''))

def _load_config() -> ConfigRoot:
    """
    Loads the bsps.toml config file
    
    Returns
    -------
        The root config
    """
    d = {}
    with open('bsps.toml', 'rb') as fp:
        d = tomllib.load(fp)
    
    r: ConfigRoot = {'entries': []}
    for k, v in d.items():
        t = _transform_key(k)
        r['entries'].append({
            'arch': t[0],
            'bsp': t[1],
            'config': v['config'] if 'config' in v else f'configs/rtems-config.{t[1]}.ini',
            'networking': v['networking'],
            'net_services': v['net_services']
        })
    return r

def _get_bsps_for(config: ConfigRoot, pred: Callable[[ConfigEntry], bool]) -> str:
    return ','.join([f'{x["arch"]}/{x["bsp"]}' for x in config['entries'] if pred(x)])

def _all_bsps(config: ConfigRoot) -> str:
    return ','.join([f'{x["arch"]}/{x["bsp"]}' for x in config['entries']])

def _gen_rtems_config(outpath: str, inputs: list[str]) -> None:
    """
    Generate an RTEMS config from a list of inputs.
    This essentially just concatenates the files together
    """
    with open(outpath, 'w') as fp:
        for f in inputs:
            with open(f, 'r') as ifp:
                fp.write(ifp.read())

def _conf_rtems(config: ConfigRoot) -> bool:
    _gen_rtems_config(f'{_get_srcdir()}/rtems/config.ini', [x['config'] for x in config['entries']])
    #./waf configure --rtems-bsps="$ALL_TARGETS" --prefix="$PREFIX" --rtems-tools="$PWD/../../host/linux-x86_64"
    CMD = ['./waf', 'configure', f'--rtems-bsps={_all_bsps(config)}', f'--prefix={_get_prefix()}', f'--rtems-tools={_get_host_prefix()}']
    print(' '.join(CMD))
    return subprocess.run(
        CMD, cwd=f'{_get_srcdir()}/rtems'
    ).returncode == 0

def _conf_libbsd(config: ConfigRoot) -> bool:
    #./waf configure --prefix="$PREFIX" --rtems-tools="$PWD/../../host/linux-x86_64" --rtems="$PREFIX" --buildset=buildset/default.ini
    CMD = [
        './waf', 'configure', f'--prefix={_get_prefix()}', f'--rtems-tools={_get_host_prefix()}', f'--rtems={_get_prefix()}',
        '--buildset=buildset/default.ini', f'--rtems-bsps={_get_bsps_for(config, lambda x : x["networking"] == "bsd")}'
    ]
    print(' '.join(CMD))
    return subprocess.run(
        CMD, shell=True, cwd=f'{_get_srcdir()}/rtems-libbsd'
    ).returncode == 0

def _conf_net_legacy(config: ConfigRoot) -> bool:
    CMD = [
        './waf', 'configure', f'--prefix={_get_prefix()}', f'--rtems-tools={_get_host_prefix()}', f'--rtems={_get_prefix()}',
        f'--rtems-bsps={_get_bsps_for(config, lambda x : x["networking"] == "legacy")}'
    ]
    print(' '.join(CMD))
    return subprocess.run(
        CMD, cwd=f'{_get_srcdir()}/rtems-net-legacy'
    ).returncode == 0

def _conf_net_services(config: ConfigRoot) -> bool:
    CMD = [
        './waf', 'configure', f'--prefix={_get_prefix()}', f'--rtems-tools={_get_host_prefix()}', f'--rtems={_get_prefix()}',
        f'--rtems-bsps={_get_bsps_for(config, lambda x : x["net_services"] == True)}'
    ]
    print(' '.join(CMD))
    return subprocess.run(
        CMD, cwd=f'{_get_srcdir()}/rtems-net-services'
    ).returncode == 0


PROJECTS = {
    'rtems': _conf_rtems,
    'rtems-libbsd': _conf_libbsd,
    'rtems-net-legacy': _conf_net_legacy,
    'rtems-net-services': _conf_net_services,
}

def main():
    os.chdir(os.path.dirname(__file__))
    
    c = _load_config()
    if args.project == 'all':
        for k,v in PROJECTS.items():
            if not v(c):
                print(f'Failed to configure {k}')
                exit(1)
    else:
        try:
            if not PROJECTS[args.project](c):
                print(f'Failed to configure {args.project}')
                exit(1)
        except Exception as e:
            print(f'No such project {args.project}')
            raise e

if __name__ == '__main__':
    main()
    