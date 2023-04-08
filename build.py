#! /usr/bin/env python3

"""
Build A docker image, push it to a image repository.
(docker hub or beaker supported).

Author: Luca Soldaini
Email:  luca@soldaini.net
"""

import argparse
from pathlib import Path
import re
from subprocess import call, PIPE, DEVNULL, run
from urllib.parse import urlparse


def cleanup_multiline(ml: str) -> str:
    return '\n'.join(ln.strip() for ln in ml.strip().split('\n'))


def parse_options():
    desc = '''
    Build A docker image, push it to a image repository.
    To use this script, create a Dockerfile with the following tags:

        # REPO: {repository}://{image}
        # VERS: {image version}
        # ARCH: {architectures}

    where:
        - `repository` is either `beaker` or `docker`
        - `image` is `{username}/{repository}` if uploading to docker,
          `{workspace}/{image name}` or simply `{image name} if uploading
          to beaker.
        - `{image version}` is a full-stop-separated list of integers
          representing the semantic version of this image.
        - `{architectures}` is a list of comma separated architectures,
          e.g. linux/amd64,linux/arm64. Note that, when uploading to beaker
          only one architecture is supported.
    '''

    ap = argparse.ArgumentParser(usage=cleanup_multiline(desc))
    ap.add_argument(
        'root',
        help='Directory to build an image from; Must contain a Dockerfile.',
        type=Path
    )
    ap.add_argument(
        '-d', '--dryrun',
        help='Print commands instead of running them.',
        action='store_true'
    )

    opts = ap.parse_args()
    return opts


def get_docker_image_id_by_name(name: str) -> str:
    output = run('docker image ls --format="{{.Repository}} {{.ID}}"',
                 shell=True,
                 stderr=DEVNULL,
                 stdout=PIPE)
    all_images = output.stdout.decode('utf-8').strip().split('\n')
    for im in all_images:
        im_name, id_ = im.split()
        if name == im_name:
            return id_
    raise ValueError(f'Image {name} not found')


def check_binary_exists(bin_name: str) -> bool:
    return call(f'which {bin_name}',
                shell=True,
                stdout=DEVNULL,
                stderr=DEVNULL) < 1


def parse_tag(df_path: Path, tag_name: str):
    tag_re = re.compile(rf'^#\s*{tag_name}:')

    with open(df_path, 'r', encoding='utf-8') as f:
        for ln in f:
            if tag_re.match(ln):
                _, tag_value = ln.split(':', 1)
                return tag_value.strip()

    raise ValueError(f'Tag {tag_name} not found in {df_path}')


def run_commands(*cmds, dryrun: bool = False, stop_on_error: bool = True):
    for cmd in cmds:
        if dryrun:
            print(f'DRYRUN: {cmd}')
        else:
            out = call(cmd, shell=True)
            if out > 0 and stop_on_error:
                raise RuntimeError(f'{cmd} failed')


def main():
    opts = parse_options()

    if not opts.root.exists():
        raise ValueError('`{opts.root}` does not exists.')

    if not (opts.root / 'Dockerfile').exists():
        raise ValueError('`{opts.root}` does not contain a Dockerfile.')

    if not check_binary_exists('docker'):
        raise RuntimeError('Docker is not available on this system.')

    # PARSE COMMANDS
    repo_name = urlparse(parse_tag(opts.root / 'Dockerfile', 'REPO'))
    version = parse_tag(opts.root / 'Dockerfile', 'VERS')
    architectures = parse_tag(opts.root / 'Dockerfile', 'ARCH')
    repository, name = repo_name.scheme, f'{repo_name.netloc}{repo_name.path}'


    # RUNNING SOME CHECKS
    if repository == 'beaker':
        *workspace, name = name.split('/')
        workspace = '/'.join(workspace) if workspace else None

        if ',' in architectures:
            msg = ('Cannot provided multiple architectures when '
                   'uploading to Beaker.')
            raise ValueError(msg)

        if not check_binary_exists('beaker'):
            raise RuntimeError('Beaker client not available on this system.')

    elif repository == 'docker':
        workspace = None
    elif repository == 'ecr':
        workspace = name.lstrip('ecr://') + f':{version}'
        _, name = name.rsplit('/', 1)
    else:
        raise ValueError(f'Repository `{repository}` not recognized.')

    report_card = f'''
        ------------ REPORT CARD ------------
        Directory:     {opts.root}
        Repository:    {repository}
        Workspace:     {workspace}
        Name:          {name}
        Version:       {version}
        Architectures: {architectures}
        -------------------------------------
    '''
    print(cleanup_multiline(report_card))

    # CREATE BUILDER
    builder_name = f'{name.replace("/", "_")}_{version.replace("/", "_")}'
    cmd = f'docker buildx create --name {builder_name} --use'
    if opts.dryrun:
        print(f'DRYRUN: {cmd}')
    else:
        out = call(cmd, shell=True)
        if out > 0:
            raise RuntimeError('Could not create builder.')

    # this is only used during dryrun
    image_id = '{image_id}'

    try:
        if repository == 'docker':
            # CREATE IMAGES AND IMMEDIATELY PUSH TO DOCKER HUB
            cmd = ('docker buildx build '
                   f'--platform {architectures} '
                   f'-t "{name}:{version}" '
                   f'-t "{name}:latest" '
                   '--push '
                   f'{str(opts.root)}')
            if opts.dryrun:
                print(f'DRYRUN: {cmd}')
            else:
                out = call(cmd, shell=True)
                if out > 0:
                    raise RuntimeError('Could not create or push image.')

        elif repository == 'ecr':
            # remove old image
            run_commands(
                f'docker buildx rm {name}:{version}',
                f'docker image rm {name}:{version}',
                dryrun=opts.dryrun,
                stop_on_error=False   
            )

            # create new image and load into docker
            run_commands(
                (
                   'docker buildx build '
                   f'--platform {architectures} '
                   f'-t "{name}:{version}" '
                   '--load '
                   f'{str(opts.root)}'
                ), 
                dryrun=opts.dryrun, 
                stop_on_error=True
            )

            if not opts.dryrun:
                image_id = get_docker_image_id_by_name(name)

            run_commands(f'docker tag {image_id} {workspace}', dryrun=opts.dryrun)
            run_commands(f'docker push {workspace}', dryrun=opts.dryrun)

        elif repository == 'beaker':
            
            # CREATE IMAGE
            cmd = ('docker buildx build '
                   f'--platform {architectures} '
                   f'-t "{name}:{version}" '
                   '--load '
                   f'{str(opts.root)}')
            if opts.dryrun:
                print(f'DRYRUN: {cmd}')
            else:
                out = call(cmd, shell=True)
                if out > 0:
                    raise RuntimeError('Could not create image.')

            # UPLOAD TO BEAKER
            cmd = ' '.join(('beaker image create',
                            f'-n {name}-{version}',
                            (f'-w {workspace}' if workspace else ''),
                            '{image_id}'))
            if opts.dryrun:
                print(f'DRYRUN: {cmd}')
            else:
                image_id = get_docker_image_id_by_name(name)
                out = call(cmd.format(image_id=image_id), shell=True)
                if out > 0:
                    raise RuntimeError('Could upload image to beaker.')

            # REMOVE IMAGE FROM LOCAL STORE
            cmd = 'docker image rm {image_id}'
            if opts.dryrun:
                print(f'DRYRUN: {cmd}')
            else:
                image_id = get_docker_image_id_by_name(name)
                out = call(cmd.format(image_id=image_id), shell=True)
                if out > 0:
                    raise RuntimeError('Could remove image.')

    finally:
        # REMOVE BUILDER
        cmd = f'docker buildx rm {builder_name}'
        if opts.dryrun:
            print(f'DRYRUN: {cmd}')
        else:
            out = call(cmd, shell=True)
            if out > 0:
                raise RuntimeError('Could not remove builder.')


if __name__ == '__main__':
    main()
