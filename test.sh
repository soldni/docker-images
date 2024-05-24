#!/usr/bin/env bash

# get path to directory of dockerfile from command line
if [ -z "$1" ]; then
    echo "Usage: $0 <path to dockerfile>"
    exit 1
fi

set -ex
docker build ${1} -t ${1}
docker run -it --rm ${1}
