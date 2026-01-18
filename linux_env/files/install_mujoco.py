#!/usr/bin/env python3

import argparse
from packaging.version import parse as parse_version
import os
import subprocess
from shutil import copy, move
import sys

KNOWN_PLATFORMS = ('linux', 'darwin')
DEFAULT_MUJOCO_PATH = '~/.mujoco'


def get_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--mujoco-path', type=str, default=DEFAULT_MUJOCO_PATH)
    parser.add_argument('--versions',
                        type=str,
                        nargs='+',
                        default=('2.00', ))
    return parser


def get_mujoco_zip_name(platform, version):
    past_150 = parse_version(version) <= parse_version("1.50")
    past_200 = parse_version(version) <= parse_version("2.0")
    past_210 = parse_version(version) <= parse_version("2.10")
    basename = "mujoco" if not past_150 else "mjpro"
    print(basename,platform)
    if platform == 'darwin':
        platform_id = 'macos' if not past_150 else 'osx'
    elif platform == 'linux':
        platform_id = 'linux'
    elif 'win' in platform:
        platform_id = platform if past_200 else 'windows'
    else:
        raise ValueError(platform)

    # For example: "mujoco200_linux.zip"
    if past_200:
        zip_name = f"{basename}{version.replace('.', '')}_{platform_id}.zip"
        url = f'www.roboti.us/download/{zip_name}'
    else:
        
        gap = '' if past_210 else '-'
        version_tmp = version.replace('.', '') if past_210 else '.'.join(version.replace('.', ''))
        version =  '.'.join(version.replace('.', ''))
        print(past_210,gap,version_tmp,version)
        if platform_id == 'windows':
            zip_name = f"{basename}{gap}{version_tmp}-windows-x86_64.zip"
        elif platform_id == 'macos':
            zip_name = f"{basename}{gap}{version_tmp}-macos-universal2.dmg"
        elif platform_id == 'linux':
            zip_name = f"{basename}{gap}{version_tmp}-linux-x86_64.tar.gz"
        url = f"github.com/google-deepmind/mujoco/releases/download/{version}/{zip_name}"
    return zip_name,platform_id,url


def download_mujoco(mujoco_path,mujoco_zip_url, url,
                    mujoco_zip_name,platform_id):
    print('URL:', mujoco_zip_url)
    mujoco_zip_url = f"{mujoco_zip_url}{url}"
    subprocess.check_call([
        "wget",
        "--progress=bar:force",
        "--show-progress",
        "--timestamping",
        "--directory-prefix",
        mujoco_path,
        mujoco_zip_url])
    if 'zip' in mujoco_zip_name:
        subprocess.call([
            "unzip",
            "-n",
            os.path.join(mujoco_path, mujoco_zip_name),
            "-d",
            mujoco_path])
    else:
        subprocess.call([
            "tar",
            "-zxvf",
            os.path.join(mujoco_path, mujoco_zip_name),
            "-C",
            mujoco_path])
    subprocess.call(["rm", os.path.join(mujoco_path, mujoco_zip_name)])
    dir_name = mujoco_zip_name[:-1+mujoco_zip_name.find(platform_id)]
    if '200' in mujoco_zip_name:
        move(os.path.join(mujoco_path, '.'.join(mujoco_zip_name.split('.')[:-1])),
             os.path.join(mujoco_path, dir_name))
    if not os.path.exists(f'{mujoco_path}/mjkey.txt'):
        subprocess.check_call([
            "wget",
            "--progress=bar:force",
            "--show-progress",
            "--timestamping",
            "--directory-prefix",
            mujoco_path,
            f"{mujoco_zip_url.split('://')[0]}://roboti.us/file/mjkey.txt"])
    
    copy(f"{mujoco_path}/mjkey.txt",
         f"{mujoco_path}/{dir_name}/mjkey.txt")
    copy(f"{mujoco_path}/mjkey.txt",
         f"{mujoco_path}/{dir_name}/bin/mjkey.txt")

    # if parse_version(version) >= parse_version('2.0'):
    #     subprocess.call([
    #         "ln",
    #         "-s",
    #         os.path.join(mujoco_path, mujoco_dir_name),
    #         os.path.join(mujoco_path, f"mujoco{version.replace('.', '')}"),
    #     ])

def install_mujoco(platform, version, mujoco_path):
    print(f"Installing MuJoCo version {version} to {mujoco_path}")
    print((platform, version, mujoco_path))
    mujoco_zip_name, platform_id,  url = get_mujoco_zip_name(platform, version)
    mujoco_dir_name = os.path.splitext(mujoco_zip_name)[0]
    if os.path.exists(os.path.join(mujoco_path, mujoco_dir_name)):
        print(f"MuJoCo {platform}, {version} already installed.")
        return

    try:
        download_mujoco(mujoco_path,"https://", url,
                    mujoco_zip_name,platform_id)
    except:
        download_mujoco(mujoco_path,"http://", url,
                    mujoco_zip_name,platform_id)



def main():
    parser = get_parser()
    args = parser.parse_args()
    mujoco_path = os.path.expanduser(args.mujoco_path)

    if not os.path.exists(mujoco_path):
        os.makedirs(mujoco_path)

    platform = sys.platform

    assert platform in KNOWN_PLATFORMS, (platform, KNOWN_PLATFORMS)

    for version in args.versions:
        install_mujoco(platform, version, mujoco_path)


if __name__ == '__main__':
    main()
