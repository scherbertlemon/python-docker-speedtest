# python-poetry-docker

Running a few experiments on

* building for multiple architectures (``amd64`` and ``arm64/v8``)
* creating a manifest list, a tag on a docker hub repo containing multiple architectures, so the right one is picked for the pulling client
* building a python environment with [poetry](https://python-poetry.org/) on top of each architecture image
* comparing speed for running ``amd64`` images on Apple M1 in emulation mode (qemu or Rosetta) vs. native ``arm64`` image

## Links

* Dockerhub repo used: https://hub.docker.com/repository/docker/scherbertlemon/python-poetry
* This repository: https://github.com/scherbertlemon/python-poetry-docker

## Setup

### Building multi-arch images

Run the script ``build_push_base_images/multi-arch-build.sh`` to build images for architectures

* ``linux/amd64``
* ``linux/arm64``

and then combine them in a manifest list for the Dockerhub repository identified by ``REPO_NAME`` (default: ``scherbertlemon/python-poetry:3.11.4-1.1``). The ``REPO_NAME`` variable needs to be adapted to a Dockerhub repository with push permission, if you want to run this script by yourself.

### Building a python environment for different architectures based on image ``scherbertlemon/python-poetry:3.11.4-1.1``

From the root of this repository, run

```bash
docker build -t python-poetry:amd64 --platform linux/amd64 -f Dockerfile .
docker build -t python-poetry:arm64 --platform linux/arm64/v8 -f Dockerfile .
```

### Building a python environments for different architectures based on image ``python:3.11.4-slim-bullseye``

From the root of this repository, run

```bash
docker build -t python-poetry:amd64 --platform linux/amd64 -f build_push_base_images/Dockerfile --target environment .
docker build -t python-poetry:arm64 --platform linux/arm64/v8 -f build_push_base_images/Dockerfile --target environment .
```

## Usage

This project contains a simple script that runs some matrix multiplications with ``numpy.matmul``. If you have built either of the above images, it can be run from the command line:

```bash
$ docker run --rm -it python-poetry:amd64 run-matmul --help
usage: run-matmul [-h] [-n N] [-s S]

cli script to run some matrix multiplications of square matrices with a given size and random numbers

options:
  -h, --help  show this help message and exit
  -n N        amount of matrix multiplications to do
  -s S        size of the matrices to multiply (s x s)
```

To run some comparisons, try on a Mac with M1

```bash
docker run --rm -it python-poetry:arm64 run-matmul -n 10 -s 1000
docker run --rm -it python-poetry:amd64 run-matmul -n 10 -s 1000
```

and compare the time that is printed.