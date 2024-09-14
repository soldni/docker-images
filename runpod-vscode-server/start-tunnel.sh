#! /usr/bin/env bash

# Configuration
PERSISTENT_DIR="/workspace"
CLI_DATA_DIR="${PERSISTENT_DIR}/.vscode-server/cli-data"
SERVER_DATA_DIR="${PERSISTENT_DIR}/.vscode-server/server-data"
EXTENSIONS_DIR="${PERSISTENT_DIR}/.vscode-server/extensions"
IDENTITY_PROVIDER="github"

# Check if directory $PERSISTENT_DIR exists; if not; error out
if [ ! -d "${PERSISTENT_DIR}" ]; then
    echo "Directory ${PERSISTENT_DIR} does not exist."
    exit 1
fi

# Check if the user is logged in by checking if "code tunnel user show" reuturns "not logged in"
if [ "$(code tunnel user show)" == "not logged in" ]; then
    code tunnel login --cli-data-dir "${CLI_DATA_DIR}" --provider "${IDENTITY_PROVIDER}"
fi

# Start the tunnel
code tunnel \
    --server-data-dir "${SERVER_DATA_DIR}" \
    --extensions-dir "${EXTENSIONS_DIR}" \
    --name "${RUNPOD_POD_HOSTNAME}" \
    --accept-server-license-terms \
    --cli-data-dir "${CLI_DATA_DIR}"
