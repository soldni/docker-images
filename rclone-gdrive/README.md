# Google Drive Dockerfile Backup

Ths container backs up Google Drive.

First, set up a client ID and secret. See [here](https://rclone.org/drive/#making-your-own-client-id) for instructions.

Then, create a new rclone config by running the following command.

```bash
export RCLONE_CLIENT_ID="..."
export RCLONE_CLIENT_SECRET="..."
export RCLONE_CONFIG="..."
rclone --config ${RCLONE_CONFIG} \
    config create google-drive drive \
    client_id ${RCLONE_CLIENT_ID} \
    client_secret ${RCLONE_CLIENT_SECRET} \
    scope drive
```

Then, run the container with arguments `RCLONE_CONFIG`, `RCLONE_DEST`, and
`RCLONE_TIME` to indicate the location of the rclone config, the destination
to backup to, and the time to run the backup, respectively.

```bash
 docker run \
    -e RCLONE_TIME=00:00 \
    -v /path/to/config:/config \
    -v /path/to/backup:/backup \
    --name rclone-gdrive \
    soldni/rclone-gdrive:latest
```
