FROM carml/mxnet:amd64-gpu-latest

RUN apt-get update && apt-get install -y python-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --user quilt

RUN export MXNET_SRC_ROOT="/mxnet"