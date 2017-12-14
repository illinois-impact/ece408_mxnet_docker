arch=$(shell arch)

ifeq ($(arch),x86_64)
	arch=amd64
endif

DOCKER_REPO = cwpearson/2017fa_ece408_mxnet_docker
COMMIT = `git rev-parse --short HEAD`

all: build

build: build_cpu build_gpu build_profile

build_and_push: build_and_push_cpu build_and_push_gpu build_and_push_profile

.PHONY: build_gpu build_cpu
build_gpu:
	docker build . -f Dockerfile.$(arch)_gpu -t $(DOCKER_REPO):$(arch)-gpu-latest
	docker tag $(DOCKER_REPO):$(arch)-gpu-latest $(DOCKER_REPO):$(arch)-gpu-$(COMMIT)

build_cpu:
	docker build . -f Dockerfile.$(arch)_cpu -t cwpearson/2017fa_ece408_mxnet_docker:$(arch)-cpu-latest

build_profile:
	docker build . -f Dockerfile.$(arch)_gpu_profile -t $(DOCKER_REPO):$(arch)-gpu-profile-latest
	docker tag $(DOCKER_REPO):$(arch)-gpu-profile-latest $(DOCKER_REPO):$(arch)-gpu-profile-$(COMMIT)

build_and_push_cpu: build_cpu
	docker push cwpearson/2017fa_ece408_mxnet_docker:$(arch)-cpu-latest

build_and_push_gpu: build_gpu
	docker push $(DOCKER_REPO):$(arch)-gpu-latest
	docker push $(DOCKER_REPO):$(arch)-gpu-$(COMMIT)

build_and_push_profile: build_profile
	docker push $(DOCKER_REPO):$(arch)-gpu-profile-latest
	docker push $(DOCKER_REPO):$(arch)-gpu-profile-$(COMMIT)