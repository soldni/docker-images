# REPO:   docker://soldni/runpod-vscode-server-pytorch
# VERS:   2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04-r2
# ARCH:   linux/amd64


FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

WORKDIR /tmp

COPY start-tunnel.sh /usr/bin/start-tunnel.sh

RUN apt-get update && \
    apt-get install -y git curl && \
    apt-get clean && \
    curl -sL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" \
        --output /tmp/vscode-cli.tar.gz && \
    tar -xf /tmp/vscode-cli.tar.gz -C /usr/bin && \
    rm /tmp/vscode-cli.tar.gz && \
    chmod +x /usr/bin/code && \
    chmod +x /usr/bin/start-tunnel.sh

CMD [ "/usr/bin/start-tunnel.sh" ]
