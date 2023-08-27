#!/bin/bash

set -e

here=$(cd $(dirname $0); pwd)
echo $here
REPO_NAME=scherbertlemon/python-poetry
TAG_VERSION=1.1
PYTHON_VERSION=3.11.4
POETRY_VERSION=1.6.1

archs=("amd64" "arm64")
# (unused) got the hashes per architecture from 'docker manifest inspect -verbose python:3.11.4-slim-bullseye'
# digests=("@sha256:1226f32ad1c1c36e0b6e79706059761c58ada308f4a1ad798e55dab346e10e91" "@sha256:295605814c6beef84ee8d2bc80e42348ba4c4d0bb01425c6d5262c3849d3ba48")
# equivalently look up https://hub.docker.com/_/python/tags?page=1&name=3.11.4
platforms=("linux/amd64" "linux/arm64/v8")

echo "Python ${PYTHON_VERSION}, poetry ${POETRY_VERSION}"
for i in ${!archs[@]}
do
    echo "Build ${archs[i]} with digest ${digests[i]}"
    image_name="${REPO_NAME}:${PYTHON_VERSION}-${archs[i]}"
    docker build -t $image_name \
        --platform ${platforms[i]} \
        --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
        --build-arg POETRY_VERSION=${POETRY_VERSION} \
        -f $here/Dockerfile \
        --target baseimage .

    docker push $image_name
done

# from https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
docker manifest create $REPO_NAME:$PYTHON_VERSION-$TAG_VERSION \
    --amend $REPO_NAME:$PYTHON_VERSION-amd64 \
    --amend $REPO_NAME:$PYTHON_VERSION-arm64

docker manifest push $REPO_NAME:$PYTHON_VERSION-$TAG_VERSION