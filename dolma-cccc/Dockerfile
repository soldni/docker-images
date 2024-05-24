# REPO:   docker://soldni/dolma-cccc
# VERS:   1.0.0
# ARCH:   linux/amd64

FROM python:3.11-slim-bullseye

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=TRUE

WORKDIR /tmp

CMD ["/bin/bash"]

# install rust and other environment dependencies
RUN apt-get update &&\
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg awscli curl git make automake apt-utils build-essential pkg-config zlib1g-dev cmake &&\
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh &&\
    sh rust.sh -y &&\
    apt-get clean

# set home for rust and other environment variables
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
ENV LIBRARY_PATH="/usr/local/opt/zlib/lib"
ENV C_INCLUDE_PATH="/usr/local/opt/zlib/include"

# install dolma
RUN git clone https://github.com/allenai/dolma.git &&\
    cd dolma &&\
    git checkout soldni/backoff &&\
    git reset --hard 36c18d21b7130a9534f1f27cd22913d100abc821 &&\
    pip install maturin &&\
    maturin build --release &&\
    pip install "$(find target/wheels -name '*.whl' | head -n 1)"[resiliparse,trafilatura] &&\
    cd .. &&\
    rm -rf dolma
