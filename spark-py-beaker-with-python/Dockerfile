# REPO:   beaker://apache-py
# VERS:   1.0
# ARCH:   linux/amd64

FROM apache/spark-py
USER root

RUN apt-get update && apt-get install -y curl

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

RUN apt-get -qqy update && apt-get install -qqy \
        curl \
        gcc \
        wget \
        python3-dev \
        python-setuptools \
        apt-transport-https \
        lsb-release \
        openssh-client \
        git \
        gnupg \
        ca-certificates

RUN dir -s 

RUN python3 -m pip --no-cache-dir install --upgrade \
    "pip<20.3" \
    setuptools    

# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python    

ARG TF_PACKAGE=tensorflow
ARG TF_PACKAGE_VERSION=2.9.0
RUN python3 -m pip install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}


# COPY bashrc /etc/bash.bashrc
# RUN chmod a+rwx /etc/bash.bashrc

RUN python3 -m pip install --no-cache-dir tensorflow_datasets

# downgrade protobuf to 3.20 to avoid issues with tensorflow
RUN python3 -m pip install --no-cache-dir protobuf==3.20.0 --upgrade

# gcloud 
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \ 
        | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \ 
        | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && \ 
        apt-get install google-cloud-cli -y

WORKDIR /tmp        

ENTRYPOINT [ "/bin/bash", "-l" ]
