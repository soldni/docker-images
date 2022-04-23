# Docker Images

A collection of scripts that build docker images for various use-cases.
Images are roughly organized in `destination/image-name` directory structure.
All images have a `build.sh` script that is responsible for building and  uploading them to the right repository.

Scripts depend on the Docker client being setup and available (duh!);
further, on macOS, you should have GNU grep mapped to `grep` (if you do not want to bother with that, build images from a system where `gnutils` are available).
