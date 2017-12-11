arch=$(shell arch)

ifeq ($(arch),x86_64)
	arch=amd64
endif

DOCKER_REPO = cwpearson/2017fa_ece408_mxnet_docker
DOCKER_TAG_PREFIX = $(arch)-gpu-profile
COMMIT = `git rev-parse --short HEAD`

all: build_gpu build_cpu build_profile

build: build_cpu build_gpu

build_and_push: build_and_push_cpu build_and_push_gpu

.PHONY: build_gpu build_cpu
build_gpu:
	docker build . -f Dockerfile.$(arch)_gpu -t cwpearson/2017fa_ece408_mxnet_docker:$(arch)-gpu-latest

build_cpu:
	docker build . -f Dockerfile.$(arch)_cpu -t cwpearson/2017fa_ece408_mxnet_docker:$(arch)-cpu-latest

build_profile:
	docker build . -f Dockerfile.$(arch)_gpu_profile -t $(DOCKER_REPO):$(DOCKER_TAG_PREFIX)-latest

build_and_push_cpu: build_cpu
	docker push cwpearson/2017fa_ece408_mxnet_docker:$(arch)-cpu-latest

build_and_push_gpu: build_gpu
	docker push cwpearson/2017fa_ece408_mxnet_docker:$(arch)-gpu-latest

build_and_push_profile: build_profile
	docker tag $(DOCKER_REPO):$(DOCKER_TAG_PREFIX)-latest $(DOCKER_REPO):$(DOCKER_TAG_PREFIX)-$(COMMIT)
	docker push $(DOCKER_REPO):$(DOCKER_TAG_PREFIX)-latest
	docker push $(DOCKER_REPO):$(DOCKER_TAG_PREFIX)-$(COMMIT)