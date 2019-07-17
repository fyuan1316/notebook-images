REGISTRY?=index.alauda.cn
OWNER?=alaudak8s
GPUTag?=10.0-cudnn7-runtime
BASE_GPU_RUNTIME?=nvidia/cuda:${GPUTag}
GPU=-gpu
BaseNotebook=base-notebook
MinimalNotebook=minimal-notebook
ScipyNotebook=scipy-notebook
gitrepo=docker-stacks-master
#
PytorchNotebook=pytorch-notebook
TensorflowNotebook=tensorflow-notebook
#
TF_VERSION=1.14
KERAS_VERSION=2.2

PYTORCH_VERSION=1.1

init:
	wget --no-check-certificate https://github.com/jupyter/docker-stacks/archive/master.tar.gz && tar zxvf master.tar.gz && rm -rf master.tar.gz

base-notebook:
	docker tag jupyter/base-notebook ${REGISTRY}/${OWNER}/${BaseNotebook}
base-notebook-gpu: init 
	docker build --build-arg BASE_CONTAINER=${BASE_GPU_RUNTIME} \
	-t ${REGISTRY}/${OWNER}/${BaseNotebook}${GPU}:${GPUTag} \
	-f ${gitrepo}/${BaseNotebook}/Dockerfile ${gitrepo}/${BaseNotebook}

minimal-notebook:
	docker tag jupyter/minimal-notebook ${REGISTRY}/${OWNER}/${MinimalNotebook}
minimal-notebook-gpu: init
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${BaseNotebook}${GPU}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${MinimalNotebook}${GPU}:${GPUTag} \
	-f ${gitrepo}/${MinimalNotebook}/Dockerfile ${gitrepo}/${MinimalNotebook}

scipy-notebook:
	docker tag jupyter/scipy-notebook ${REGISTRY}/${OWNER}/${ScipyNotebook}
scipy-notebook-gpu: init
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${MinimalNotebook}${GPU}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} \
	-f ${gitrepo}/${ScipyNotebook}/Dockerfile ${gitrepo}/${ScipyNotebook}

pytorch-notebook:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook} \
	-f pytorch/Dockerfile.cpu pytorch

pytorch-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}:${GPUTag} \
	-f pytorch/Dockerfile.gpu pytorch

tensorflow-notebook:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook}\
	--build-arg TF_VERSION=${TF_VERSION} \
	--build-arg KERAS_VERSION=${KERAS_VERSION} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}-${TF_VERSION} \
	-f tensorflow/Dockerfile.cpu tensorflow

tensorflow-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} \
	--build-arg TF_VERSION=${TF_VERSION} \
	--build-arg KERAS_VERSION=${KERAS_VERSION} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-${TF_VERSION}:${GPUTag} \
	-f tensorflow/Dockerfile.gpu tensorflow

prepare-tf-tutorial:clean-tf
	curl --user yuanfang@alauda.io -L -O http://bitbucket.org/mathildetech/aml-demo/get/master.tar.gz && mkdir tf-demo && tar zxvf master.tar.gz -C tf-demo --strip-components 1 && rm -rf master.tar.gz && mv tf-demo tensorflow/

tf-gpu-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-${TF_VERSION}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-${TF_VERSION}-tutorial:${GPUTag} \
	-f tensorflow/Dockerfile.demo tensorflow

tf-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${TensorflowNotebook}-${TF_VERSION} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}-${TF_VERSION}-tutorial \
	-f tensorflow/Dockerfile.demo tensorflow

prepare-pytorch-tutorial:clean-tf
	curl --user yuanfang@alauda.io -L -O https://bitbucket.org/mathildetech/pytorch-demo/get/master.tar.gz && mkdir pytorch-demo && tar zxvf master.tar.gz -C pytorch-demo --strip-components 1 && rm -rf master.tar.gz && mv pytorch-demo pytorch/

pytorch-gpu-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}-${PYTORCH_VERSION}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}-${PYTORCH_VERSION}-tutorial:${GPUTag} \
	-f tensorflow/Dockerfile.demo pytorch

pytorch-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${PytorchNotebook}-${PYTORCH_VERSION} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook}-${PYTORCH_VERSION}-tutorial \
	-f tensorflow/Dockerfile.demo pytorch



clean-tf:
	rm -rf tensorflow/tf-demo
cleanAll:
	rm master.tar.gz && rm -rf ${gitrepo} 
