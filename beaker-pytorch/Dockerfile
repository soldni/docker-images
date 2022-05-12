# REPO:   beaker://python39_torch11
# VERS:   1.0
# ARCH:   linux/amd64

FROM ghcr.io/allenai/cuda:11.3-cudnn8-dev-ubuntu20.04-v0.0.14

WORKDIR /tmp

COPY requirements.txt .
RUN pip install -r requirements.txt

ENTRYPOINT [ "/bin/bash", "-l" ]
