# REPOSITORY: soldni/mmda-pytorch-transformer-cpu
# TAG: 1.2

FROM python:3.9.7

# setup rust compiler
WORKDIR /tmp
RUN curl https://sh.rustup.rs -sSf > rustup.sh
RUN chmod 755 rustup.sh
RUN ./rustup.sh -y --default-toolchain 1.59
RUN rm /tmp/rustup.sh
ENV PATH="/root/.cargo/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y curl ffmpeg libsm6 libxext6 poppler-utils

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel
COPY requirements.txt .
RUN pip install -r requirements.txt

# download small spacy model 
RUN python -m spacy download en_core_web_sm

# These git repo must be installed AFTER requirements.txt deps
RUN pip install git+https://github.com/facebookresearch/detectron2.git@v0.4
RUN pip install git+https://github.com/allenai/mmda.git@lucas/fix-float-bboxes

CMD ["bash"]
