# REPO:   beaker://python39_torch121
# VERS:   2
# ARCH:   linux/amd64

FROM ghcr.io/allenai/cuda:11.3-cudnn8-dev-ubuntu20.04-v0.0.15

WORKDIR /tmp

COPY requirements.txt .
RUN pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu113

RUN chmod 777 -R /opt/miniconda3

ENTRYPOINT [ "/bin/bash", "-l" ]
