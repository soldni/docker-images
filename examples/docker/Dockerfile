# REPO:   docker://soldni/test
# VERS:   1.1.1
# ARCH:   linux/amd64,linux/arch64

FROM alpine

WORKDIR /tmp

RUN apk add --no-cache python3 py3-pip
COPY requirements.txt .
RUN pip install -r requirements.txt

CMD ["/bin/sh"]
