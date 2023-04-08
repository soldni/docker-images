# REPO:   docker://soldni/github-backup
# VERS:   1.0.0
# ARCH:   linux/arm64,linux/amd64

FROM alpine:latest

ARG GITHUB_OAUTH
ARG GITHUB_USER
ARG GITHUB_DEST="/backup/"
ARG SSH_KEY_PATH="/config/id_rsa"
ARG GITHUB_TIME="00:00"

ENV GITHUB_USER=$GITHUB_USER
ENV SSH_KEY_PATH=$SSH_KEY_PATH
ENV GITHUB_OAUTH=$GITHUB_OAUTH
ENV GITHUB_DEST=$GITHUB_DEST
ENV GITHUB_TIME=$GITHUB_TIME
ENV APP_NAME="GitHub Backup"

WORKDIR /

COPY backup-github.sh backup-github.sh
COPY run.sh run.sh

RUN set -ex &&\
    apk --no-cache add sudo bash unzip curl git python3 py3-pip &&\
    chmod +x backup-github.sh && \
    chmod +x run.sh

ENTRYPOINT bash run.sh backup-github.sh $GITHUB_TIME
