#!/usr/bin/env python3

import argparse
import subprocess
import configparser
import os

def main():
    parser = argparse.ArgumentParser(description='Checkout latest of all components', add_help=True)
    parser.parse_args()

    os.chdir(os.path.dirname(__file__))
    p = configparser.ConfigParser()
    p.read('.gitmodules')
    for s in p.sections():
        if 'branch' not in p[s]: continue
        subprocess.run(
            ['git', 'fetch', '--all'],
            capture_output=False,
            cwd=p[s]['path']
        )
        subprocess.run(
            ['git', 'checkout', p[s]['branch']],
            capture_output=False,
            cwd=p[s]['path']
        )
        subprocess.run(
            ['git', 'pull'],
            capture_output=False,
            cwd=p[s]['path']
        )

if __name__ == '__main__':
    main()