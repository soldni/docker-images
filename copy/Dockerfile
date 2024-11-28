# REPO:   docker://soldni/copy
# VERS:   1.0.0
# ARCH:   linux/amd64


# Use Alpine Linux as minimal base image
FROM alpine:3.19

# Define environment variables for source and destination paths
ENV SRC=""
ENV DST=""

# Create a working directory
WORKDIR /data

# Create entrypoint script
COPY <<EOF /entrypoint.sh
#!/bin/sh
set -e

if [ -z "\${SRC}" ] || [ -z "\${DST}" ]; then
    echo "Error: Both SRC and DST environment variables must be set"
    echo "Usage: docker run -e SRC=/source/path -e DST=/dest/path -v /host/path:/container/path image-name"
    exit 1
fi

if [ ! -e "\${SRC}" ]; then
    echo "Error: Source path '\${SRC}' does not exist"
    echo "Make sure the path is mounted from host system"
    exit 1
fi

if [ ! -d "\$(dirname "\${DST}")" ]; then
    echo "Error: Destination parent directory does not exist"
    echo "Make sure the destination path is mounted from host system"
    exit 1
fi

echo "Copying files from \${SRC} to \${DST}..."
cp -rpv "\${SRC}" "\${DST}"
EOF

# Make script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint to our validation script
ENTRYPOINT ["/entrypoint.sh"]
