#!/usr/bin/env bash


if [ -z ${GITHUB_OAUTH} ]; then
	echo '$GITHUB_OAUTH is not set'
	exit 1
fi

if [-z ${GITHUB_USER}]; then
	echo '$GITHUB_USER is not set'
	exit 1
fi

if [-z ${GITHUB_DEST}]; then
	echo '$GITHUB_DEST is not set'
	exit 1
fi

if [-z ${SSH_KEY_PATH}]; then
	echo '$SSH_KEY_PATH is not set'
	exit 1
fi


###############################

set -x

CURRENT=`pwd`
PYTHON_GET_URL_REPO='
import json
import sys

data = json.loads("\n".join(ln for ln in sys.stdin))

for repo in data:
    print("{};{};{}".format(repo["ssh_url"], repo["owner"]["login"], repo["name"]))
'

PYTHON_GET_URL_GIST='
import json
import sys

data = json.loads("\n".join(ln for ln in sys.stdin))

for gist in data:
    print("{};{};{}".format(gist["git_push_url"], "_gists", gist["id"]))
'


function clone_update () {
	REPOS="${1}"
	for REPO_INFO in $REPOS; do
    	IFS=';' read -r URL GITHUB_USER NAME <<< "$REPO_INFO"
    	mkdir -p "${GITHUB_DEST}/${GITHUB_USER}"
    	printf "Checking ${GITHUB_USER}/${NAME}... "
    	if [ -d "${GITHUB_DEST}/${GITHUB_USER}/${NAME}" ]; then
        	cd  "${GITHUB_DEST}/${GITHUB_USER}/${NAME}"
        	git pull
        	cd "${CURRENT}"
    	else
        	echo "${GITHUB_DEST}/${GITHUB_USER}/${NAME}"
        	git clone $URL "${GITHUB_DEST}/${GITHUB_USER}/${NAME}"
    	fi
    	printf "\n"
	done
}

# add ssh key to ssh agent so we can clone private repos
ssh-add ${SSH_KEY_PATH}

PAGE=1
while true; do
    CONTRIB=$(curl -H "Authorization: token ${GITHUB_OAUTH}" -s "https://api.github.com/gists?type=all&page=${PAGE}" | python3 -c "${PYTHON_GET_URL_GIST}")
	if [ -z "${CONTRIB}" ]; then
		break
	else
		clone_update "${CONTRIB}"
		PAGE=$((PAGE + 1))
	fi
done

PAGE=1
while true; do
	CONTRIB=$(curl -H "Authorization: token ${GITHUB_OAUTH}" -s "https://api.github.com/user/repos?type=all&page=${PAGE}" | python3 -c "${PYTHON_GET_URL_REPO}")
	if [ -z "${CONTRIB}" ]; then
		break
	else
		clone_update "${CONTRIB}"
		PAGE=$((PAGE + 1))
	fi
done
