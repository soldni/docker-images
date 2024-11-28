# REPO:   docker://soldni/copy
# VERS:   1.0.2
# ARCH:   linux/amd64


# Use Alpine Linux as minimal base image
FROM alpine:3.19

# Define environment variables for source and destination paths
ENV SRC=""
ENV DST=""

# Create a working directory
WORKDIR /data

# Set the entrypoint to copy files recursively
# -r: recursive
# -p: preserve timestamps and permissions
# -v: verbose output
ENTRYPOINT cp -r $SRC $DST
