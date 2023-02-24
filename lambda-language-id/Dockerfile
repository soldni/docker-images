# REPO:   ecr://896129387501.dkr.ecr.us-west-2.amazonaws.com/aws-lambda-ft-lang-id
# VERS:   2.0.0
# ARCH:   linux/amd64

FROM public.ecr.aws/lambda/python:3.8

# RUN yum -y groupinstall "Development tools"  && \
#     yum -y install gcc-c++ libcurl-devel cmake3 git && \
#     pip3 install awscli && \
#     git clone https://github.com/awslabs/aws-lambda-cpp.git && \
#     cd aws-lambda-cpp && \
#     mkdir build && \
#     cd /aws-lambda-cpp/build && \
#     cmake3 .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF \
#         -DCMAKE_INSTALL_PREFIX=/out -DCMAKE_CXX_COMPILER=g++ && \
#     make && \
#     make install && \
#     cd .. && \
#     rm -rf aws-lambda-cpp && \
#     pip install --upgrade pip && \
#     pip install fasttext && \
#     wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin \
#         -O ${LAMBDA_TASK_ROOT}/lid.176.bin


# yum -y install gcc-c++ libcurl-devel cmake3 git wget python3-devel.x86_64 && \
# pip install --upgrade pip && \
# pip install --upgrade pybind11>=2.2 && \

RUN yum -y groupinstall "Development tools"  && \
    yum -y install libcurl-devel git wget && \
    pip install --upgrade pip && \
    pip install fasttext-wheel --use-pep517 && \
    wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin \
        -O ${LAMBDA_TASK_ROOT}/lid.176.bin


COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
