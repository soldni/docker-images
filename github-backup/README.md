# Server Backups

First, obtain a GitHub token [here](https://github.com/settings/tokens).

Then, create an SSH key pair and add the public key to GitHub [here](https://github.com/settings/keys).

Finally, start the container with the following arguments:

```bash
export GITHUB_OAUTH="<your token>"
export GITHUB_USER="<your username>"

 docker run \
    -e GITHUB_TIME=00:00 \
    -e GITHUB_OAUTH=$GITHUB_OAUTH \
    -e GITHUB_USER=$GITHUB_USER \
    -v /path/to/config:/config \
    -v /path/to/backup:/backup \
    --name github-backup \
    soldni/github-backup:latest
```
