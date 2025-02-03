# REPO:   docker://soldni/llama-cpp-python
# VERS:   1.0.0
# ARCH:   linux/amd64

# Define the image argument and provide a default value
ARG IMAGE=python:3-slim-bookworm

# Use the image as specified
FROM ${IMAGE}

# Re-declare the ARG after FROM
ARG IMAGE

# Update and upgrade the existing packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    ninja-build \
    curl \
    libopenblas-dev \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN python3 -m pip install --upgrade pip

RUN python3 -m pip install --upgrade pip pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings starlette-context

RUN pip install llama-cpp-python==0.3.7 --verbose;

# Set environment variable for the host
ENV HOST=0.0.0.0
ENV PORT=8000

# Expose a port for the server
EXPOSE 8000

# Run the server start script
CMD ["/bin/sh", "/app/docker/simple/run.sh"]
