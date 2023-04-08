# REPO:   docker://soldni/rclone-gdrive
# VERS:   1.0.0
# ARCH:   linux/arm64,linux/amd64

FROM alpine:latest


ARG RCLONE_DEST="/backup/"
ARG RCLONE_TIME="00:00"
ARG RCLONE_CONFIG="/config/rclone.conf"

ENV RCLONE_DEST=$RCLONE_DEST
ENV RCLONE_TIME=$RCLONE_TIME
ENV RCLONE_CONFIG=$RCLONE_CONFIG
ENV APP_NAME="rclone Google Drive Backup"

WORKDIR /

COPY rclone-gdrive.sh rclone-gdrive.sh
COPY run.sh run.sh

RUN set -ex &&\
    apk --no-cache add sudo bash unzip curl git python3 py3-pip &&\
    chmod +x rclone-gdrive.sh && \
    chmod +x run.sh

RUN sudo -v ; curl https://rclone.org/install.sh | sudo bash

ENTRYPOINT bash run.sh rclone-gdrive.sh  $RCLONE_TIME
