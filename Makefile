arch=$(shell arch)

ifeq ($(arch),x86_64)
	carml_arch=amd64
endif
ifeq ($(arch),ppc64le)
	carml_arch=ppc64le
endif

all: build_gpu build_cpu

.PHONY: build_gpu build_cpu
build_gpu:
	docker build . -f Dockerfile.$(arch)_gpu -t cwpearson/2017fa_ece408_mxnet_docker:$(arch)-gpu-latest

build_cpu:
	docker build . -f Dockerfile.$(arch)_cpu -t cwpearson/2017fa_ece408_mxnet_docker:$(arch)-cpu-latest

build_and_push_cpu: build_cpu
	docker push cwpearson/2017fa_ece408_mxnet_docker:$(arch)-cpu-latest

build_and_push_gpu: build_gpu
	docker push cwpearson/2017fa_ece408_mxnet_docker:$(arch)-gpu-latest