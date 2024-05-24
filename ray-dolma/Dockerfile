# REPO:   docker://soldni/ray-dolma
# VERS:   1.0.0
# ARCH:   linux/amd64

FROM rayproject/ray:2.23.0-py311-cpu

WORKDIR /tmp

CMD ["/bin/bash"]

# install rust and other environment dependencies
RUN sudo apt-get update &&\
    sudo apt-get install -y curl make automake apt-utils build-essential pkg-config zlib1g-dev cmake &&\
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh &&\
    sh rust.sh -y &&\
    sudo apt-get clean

# set home for rust and other environment variables
ENV PATH="${HOME}/.cargo/bin:${PATH}"
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
    cd /tmp
