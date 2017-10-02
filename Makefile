arch=$(shell arch)

ifeq ($(arch),x86_64)
	carml_arch=amd64
endif
ifeq ($(arch),ppc64le)
	carml_arch=ppc64le
endif

all: build

build:
	docker build . -f Dockerfile.$(arch)_gpu -t cwpearson/2017fa_ece408_mxnet_docker:$(arch)-gpu-latest

build_and_push: build
	docker push cwpearson/2017fa_ece408_mxnet_docker
