REGISTRY?=index.alauda.cn
OWNER?=alaudak8s
GPUTag?=10.0-cudnn7-runtime
BASE_GPU_RUNTIME?=nvidia/cuda:${GPUTag}
GPU=-gpu
BaseNotebook=base-notebook
MinimalNotebook=minimal-notebook
ScipyNotebook=scipy-notebook
gitrepo=docker-stacks
#
PytorchNotebook=pytorch-notebook
TensorflowNotebook=tensorflow-notebook
#
TF_VERSION=1.14

base-notebook:
	docker tag jupyter/base-notebook ${REGISTRY}/${OWNER}/${BaseNotebook}
base-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${BASE_GPU_RUNTIME} -t ${REGISTRY}/${OWNER}/${BaseNotebook}${GPU}:${GPUTag} -f ${gitrepo}/${BaseNotebook}/Dockerfile ${gitrepo}/${BaseNotebook}

minimal-notebook:
	docker tag jupyter/minimal-notebook ${REGISTRY}/${OWNER}/${MinimalNotebook}
minimal-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${BaseNotebook}${GPU}:${GPUTag} -t ${REGISTRY}/${OWNER}/${MinimalNotebook}${GPU}:${GPUTag} -f ${gitrepo}/${MinimalNotebook}/Dockerfile ${gitrepo}/${MinimalNotebook}

scipy-notebook:
	docker tag jupyter/scipy-notebook ${REGISTRY}/${OWNER}/${ScipyNotebook}
scipy-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${MinimalNotebook}${GPU}:${GPUTag} -t ${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} -f ${gitrepo}/${ScipyNotebook}/Dockerfile ${gitrepo}/${ScipyNotebook}

pytorch-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} -t ${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}:${GPUTag} -f pytorch/Dockerfile.gpu pytorch

tensorflow-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} \
	--build-arg TF_VERSION=${TF_VERSION} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-${TF_VERSION}:${GPUTag} \
	-f tensorflow/Dockerfile.gpu tensorflow

tf-gpu-tutorial:
	URL=https://bitbucket.org/mathildetech/aml-demo/src/master/
	git clone ${URL}
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-${TF_VERSION}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-${TF_VERSION}-tutorial:${GPUTag} \
	-f tensorflow/Dockerfile.demo tensorflow