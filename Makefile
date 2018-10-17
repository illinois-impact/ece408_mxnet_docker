arch=$(shell arch)

ifeq ($(arch),x86_64)
	arch=amd64
endif

DOCKER_REPO = illinoisimpact/ece408_mxnet_docker
COMMIT = $(shell git rev-parse --short HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

REPO_PREFIX = $(DOCKER_REPO):$(arch)

GPU_LATEST = $(REPO_PREFIX)-gpu-latest
GPU_BRANCH_LATEST = $(REPO_PREFIX)-gpu-$(BRANCH)-latest
GPU_COMMIT = $(REPO_PREFIX)-gpu-$(COMMIT)
CPU_LATEST = $(REPO_PREFIX)-cpu-latest
CPU_BRANCH_LATEST = $(REPO_PREFIX)-cpu-$(BRANCH)-latest
CPU_COMMIT = $(REPO_PREFIX)-cpu-$(COMMIT)

BUILD_FLAGS = #--no-cache

all: build

build: build_cpu build_gpu

build_and_push: build_and_push_cpu build_and_push_gpu

.PHONY: build_gpu
build_gpu:
	docker pull carml/base:$(arch)-gpu-latest
	docker build $(BUILD_FLAGS) . -f Dockerfile.$(arch)_gpu -t $(GPU_LATEST)
	docker tag $(GPU_LATEST) $(GPU_BRANCH_LATEST)
	docker tag $(GPU_LATEST) $(GPU_COMMIT)

.PHONY: build_cpu
build_cpu:
	docker pull carml/go-mxnet:$(arch)-cpu-latest
	docker build $(BUILD_FLAGS) . -f Dockerfile.$(arch)_cpu -t $(CPU_LATEST)
	docker tag $(CPU_LATEST) $(CPU_BRANCH_LATEST)
	docker tag $(CPU_LATEST) $(CPU_COMMIT)

build_and_push_cpu: build_cpu
	docker push $(CPU_LATEST)
	docker push $(CPU_BRANCH_LATEST)
	docker push $(CPU_COMMIT)

build_and_push_gpu: build_gpu
	docker push $(GPU_LATEST)
	docker push $(GPU_BRANCH_LATEST)
	docker push $(GPU_COMMIT)
