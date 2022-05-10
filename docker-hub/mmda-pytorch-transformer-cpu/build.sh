#! /usr/bin/env bash

# get script directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it
  # relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
CURRENT_DIR="$(pwd)"

cd $SCRIPT_DIR

function script_exit () {
    code=$1
    if [ -z "$code" ]; then
        code=0
    fi
    cd $CURRENT_DIR
    exit $code
}

function get_attr () (
    attr_name=$1
    tag_str="# ${attr_name}: "
    while read -r data; do
        attr_value=$(echo ${data} | grep -P "^${tag_str}([^\s])+$" | sed "s/${tag_str}//g")
        if [ ! -z ${attr_value} ]; then
            echo ${attr_value}
        fi
    done
)

has_docker=$(which docker 2>/dev/null)
if [ -z ${has_docker} ]; then
    echo "[ERROR] Docker not installed" > /dev/stderr
    script_exit 1
fi

if [ ! -f "Dockerfile" ]; then
    echo "[ERROR] Dockerfile not found" > /dev/stderr
    script_exit 1
fi

REPOSITORY=$(cat Dockerfile | get_attr REPOSITORY)
if [ -z ${REPOSITORY} ]; then
    echo "[ERROR] '# REPOSITORY: ' declaration missing" > /dev/stderr
    script_exit 1
fi

TAG=$(cat Dockerfile | get_attr TAG)
if [ -z ${TAG} ]; then
    echo "[ERROR] '# TAG: ' declaration missing" > /dev/stderr
    script_exit 1
fi

ARCH=$(cat Dockerfile | get_attr ARCH)
if [ -z ${TAG} ]; then
    echo "[ERROR] '# ARCH: ' declaration missing" > /dev/stderr
    script_exit 1
fi

BUILDER_NAME=$(echo "$REPOSITORY:$TAG" | sed "s/[\/:]/_/g")

set -ex

# Create builder
docker buildx create --name $BUILDER_NAME --use

# build and push
docker buildx build --platform $ARCH -t "$REPOSITORY:$TAG" --push .

# delete builder
docker buildx rm $BUILDER_NAME

# # Build image
# docker image build --tag "$REPOSITORY:$TAG" .

# # Push to hub
# docker image push "$REPOSITORY:$TAG"

set +ex

cd $CURRENT_DIR