# REPO:   beaker://pyterrier
# VERS:   1.2
# ARCH:   linux/amd64

FROM ghcr.io/allenai/cuda:11.3-cudnn8-dev-ubuntu20.04-v0.0.15

WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless && \
    apt-get install -y openjdk-11-jdk-headless && \
    apt-get clean;

COPY requirements.txt .

RUN conda update conda && \
    conda install python=3.8 && \
    echo "Running $(conda --version)" && \
    echo "Running $(python --version)" && \
    echo "Running $(pip --version)" && \
    pip install cython && \
    pip install -r requirements.txt \
        --extra-index-url https://download.pytorch.org/whl/cu113

RUN chmod 777 -R /opt/miniconda3

ENTRYPOINT [ "/bin/bash", "-l" ]
