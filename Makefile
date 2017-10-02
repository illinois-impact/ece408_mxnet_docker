all: build

build:
	docker build . -f Dockerfile.ppc64le_gpu -t cwpearson/2017fa_ece408_mxnet_docker:ppc64le-gpu-latest
