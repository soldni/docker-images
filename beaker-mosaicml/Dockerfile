# REPO:   beaker://python39_mosaiclm
# VERS:   1
# ARCH:   linux/amd64

# start from base image
FROM ghcr.io/allenai/cuda:11.5-cudnn8-dev-ubuntu20.04


# build in temporary directory
WORKDIR /tmp


# install vscode server
RUN  wget -O vscode-server-setup.sh \
    https://aka.ms/install-vscode-server/setup.sh && \
    sudo bash vscode-server-setup.sh && \
    rm -rf vscode-server-setup.sh

# Install all dependencies, clean caches
RUN apt-get update  && \
    conda install python=3.9 && \
    echo "Running $(conda --version)" && \
    echo "Running $(python --version)" && \
    echo "Running $(pip --version)" && \
    pip install cython && \
    pip install pip --upgrade && \
    pip install pyopenssl --upgrade && \
    pip install torch --extra-index-url https://download.pytorch.org/whl/cu116 && \
    pip install 'mosaicml[nlp,tensorboard,wandb]' && \
    pip install springs mypy ipython ipdb black flake8 isort && \
    apt-get clean && \
    pip cache purge && \
    conda clean -a -y 

# make sure miniconda can be modified in interactive moode
RUN chmod 777 -R /opt/miniconda3

ENTRYPOINT [ "/bin/bash", "-l" ]
