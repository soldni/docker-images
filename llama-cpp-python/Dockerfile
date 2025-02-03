# REPO:   docker://soldni/llama-cpp-python
# VERS:   0.3.7r2
# ARCH:   linux/amd64

# Use the image as specified
FROM ghcr.io/abetlen/llama-cpp-python:v0.3.5


# Update and upgrade the existing packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    curl \
    git \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /app

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade \
    pytest \
    cmake \
    scikit-build \
    setuptools \
    fastapi \
    uvicorn \
    sse-starlette \
    pydantic-settings \
    starlette-context \
    && pip install llama-cpp-python==0.3.7 --verbose

# Set environment variable for the host
ENV HOST=0.0.0.0
ENV PORT=8000

# Expose a port for the server
EXPOSE 8000

# Run the server start script
CMD ["/bin/sh", "/app/docker/simple/run.sh"]
