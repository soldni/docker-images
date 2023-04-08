#!/usr/bin/env bash

# Description: Run a script at a specific time every day
# Usage: run.sh <script to run> <target time>
# Author: Luca Soldaini <luca@soldaini.net>

# path to script to run; if not provided, print usage and exit
SCRIPT_TO_RUN=${1}

# check if script to run is provided and it exists
if [[ -z "${SCRIPT_TO_RUN}" ]] || [[ ! -f "${SCRIPT_TO_RUN}" ]]; then
    echo "Usage: ${0} <script to run> <target time>"
    exit 1
fi

TARGET_TIME=${2}

#check if target time is provided and is a valid hour or hour:minute
if [[ -z "${TARGET_TIME}" ]] || [[ ! "${TARGET_TIME}" =~ ^([0-1]?[0-9]|2[0-3])(:[0-5][0-9])?$ ]]; then
    echo "Usage: ${0} ${SCRIPT_TO_RUN} <target time>"
    exit 1
fi

# if target time is provided as hour, add :00
if [[ "${TARGET_TIME}" =~ ^([0-1]?[0-9]|2[0-3])$ ]]; then
    TARGET_TIME="${TARGET_TIME}:00"
fi


# run the script once now
echo "Running ${SCRIPT_TO_RUN} now"
. ${SCRIPT_TO_RUN}

# run the script once every 24 hours
while true; do

    # get the delta between now and next time target time occurs
    # if target time is in the past, add 24 hours
    DELTA=$(($(date -d "${TARGET_TIME}" +%s) - $(date +%s)))
    if [[ ${DELTA} -le 0 ]]; then
        DELTA=$((DELTA + 86400))
    fi

    # sleep until target time
    echo "Sleeping for ${DELTA} seconds until ${TARGET_TIME}"
    sleep ${DELTA}

    # time how long it takes to run the script
    START_TIME=$(date +%s)

    # run the script
    echo "Running ${SCRIPT_TO_RUN} now"
    . ${SCRIPT_TO_RUN}

    # get how long it took to run the script
    END_TIME=$(date +%s)
    RUN_TIME=$((END_TIME - START_TIME))

done
