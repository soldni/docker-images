#!/bin/bash

# rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "/home/dave/Documents" "google-drive:LinuxDocs"

if [ -z ${RCLONE_DEST} ]; then
	echo '$RCLONE_DEST is not set'
	exit 1
fi

# check if RCLONE_CONFIG is set and if it exists
if [ -z ${RCLONE_CONFIG} ]; then
	echo "Location of rclone config file not set. Set \$RCLONE_CONFIG"
	exit 1
fi

if [ ! -f ${RCLONE_CONFIG} ]; then
	echo "rclone config file not found at ${RCLONE_CONFIG}"
	exit 1
fi

rclone copy \
	--config ${RCLONE_CONFIG} \
	--update \
	--verbose \
	--transfers 30 \
	--checkers 8 \
	--contimeout 60s \
	--timeout 300s \
	--retries 3 \
	--low-level-retries 10 \
	"google-drive:" ${RCLONE_DEST}
