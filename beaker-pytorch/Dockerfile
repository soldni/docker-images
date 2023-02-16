# REPO:   beaker://python39_torch121
# VERS:   8
# ARCH:   linux/amd64

FROM ghcr.io/allenai/cuda:11.5-ubuntu20.04

WORKDIR /tmp

RUN apt-get update && apt-get clean;


# install vscode server
RUN  wget -O vscode-server-setup.sh \
    https://aka.ms/install-vscode-server/setup.sh && \
    sudo bash vscode-server-setup.sh

# copy requirements file
COPY requirements.txt .

# Install python dependencies
RUN conda install python=3.8 && \
    echo "Running $(conda --version)" && \
    echo "Running $(python --version)" && \
    echo "Running $(pip --version)" && \
    pip install cython && \
    pip install pip --upgrade && \
    pip install pyopenssl --upgrade && \
    pip install -r requirements.txt \
    --extra-index-url https://download.pytorch.org/whl/cu116

# make sure miniconda can be modified in interactive moode
RUN chmod 777 -R /opt/miniconda3

ENTRYPOINT [ "/bin/bash", "-l" ]
