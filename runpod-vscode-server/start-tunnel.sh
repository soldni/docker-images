#! /usr/bin/env bash

# Check if GITHUB_TOKEN is set, otherwise raise an error
if [ -z "${GITHUB_TOKEN}" ]; then
    echo "GITHUB_TOKEN is not set. Please set the GITHUB_TOKEN environment variable."
    exit 1
fi

# Setup Git to use the provided GitHub token
gh auth setup-git

# Log into GitHub to us tunnel
code tunnel user login --provider "github" --access-token "${GITHUB_TOKEN}"

# Start the tunnel
code tunnel --name "${RUNPOD_POD_HOSTNAME:0:20}" --accept-server-license-terms
