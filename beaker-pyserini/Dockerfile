# REPO:   beaker://pyserini
# VERS:   1
# ARCH:   linux/amd64

FROM ghcr.io/allenai/cuda:11.3-cudnn8-dev-ubuntu20.04

WORKDIR /tmp

# install java
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless && \
    apt-get install -y openjdk-11-jdk-headless && \
    apt-get clean;

# install vscode server
RUN  wget -O vscode-server-setup.sh \
    https://aka.ms/install-vscode-server/setup.sh && \
    sudo bash vscode-server-setup.sh

# copy requirements file 
COPY requirements.txt .

# install python dependencies
RUN conda install python=3.8 && \
    echo "Running $(conda --version)" && \
    echo "Running $(python --version)" && \
    echo "Running $(pip --version)" && \
    pip install cython && \
    pip install pip --upgrade && \
    pip install pyopenssl --upgrade && \
    pip install -r requirements.txt \
    --extra-index-url https://download.pytorch.org/whl/cu116 && \
    python -m spacy download en_core_web_sm && \
    conda install -c faiss-cpu && \
    echo "done!"

RUN chmod 777 -R /opt/miniconda3

ENTRYPOINT [ "/bin/bash", "-l" ]
