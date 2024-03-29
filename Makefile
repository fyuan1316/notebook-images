REGISTRY?=index.alauda.cn
OWNER?=alaudaorg
GPUTag?=10.0-cudnn7-runtime
BASE_GPU_RUNTIME?=nvidia/cuda:${GPUTag}
GPU=
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

#prepare
init:
	wget --no-check-certificate https://github.com/jupyter/docker-stacks/archive/master.tar.gz && tar zxvf master.tar.gz && rm -rf master.tar.gz


base-notebook:
	docker build --build-arg BASE_CONTAINER=jupyter/base-notebook \
	-t ${REGISTRY}/${OWNER}/${BaseNotebook} \
	-f sync/Dockerfile sync
push-base-notebook:
	docker push ${REGISTRY}/${OWNER}/${BaseNotebook}

base-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${BASE_GPU_RUNTIME} \
	-t ${REGISTRY}/${OWNER}/${BaseNotebook}${GPU}:${GPUTag} \
	-f ${gitrepo}/${BaseNotebook}/Dockerfile ${gitrepo}/${BaseNotebook}
push-base-notebook-gpu:
	docker push ${REGISTRY}/${OWNER}/${BaseNotebook}${GPU}:${GPUTag}

minimal-notebook:
	docker build --build-arg BASE_CONTAINER=jupyter/minimal-notebook \
	-t ${REGISTRY}/${OWNER}/${MinimalNotebook} \
	-f sync/Dockerfile sync
push-minimal-notebook:
	docker push ${REGISTRY}/${OWNER}/${MinimalNotebook}

minimal-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${BaseNotebook}${GPU}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${MinimalNotebook}${GPU}:${GPUTag} \
	-f ${gitrepo}/${MinimalNotebook}/Dockerfile ${gitrepo}/${MinimalNotebook}
push-minimal-notebook-gpu:
	docker push ${REGISTRY}/${OWNER}/${MinimalNotebook}${GPU}:${GPUTag}

scipy-notebook:
	docker build --build-arg BASE_CONTAINER=jupyter/scipy-notebook \
	-t ${REGISTRY}/${OWNER}/${ScipyNotebook} \
	-f sync/Dockerfile sync
push-scipy-notebook:
	docker push ${REGISTRY}/${OWNER}/${ScipyNotebook}

scipy-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${MinimalNotebook}${GPU}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} \
	-f ${gitrepo}/${ScipyNotebook}/Dockerfile ${gitrepo}/${ScipyNotebook}
push-scipy-notebook-gpu:
	docker push ${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag}

pytorch-notebook:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook}:${PYTORCH_VERSION} \
	-f pytorch/Dockerfile.cpu pytorch
push-pytorch-notebook:
	docker push ${REGISTRY}/${OWNER}/${PytorchNotebook}:${PYTORCH_VERSION}

pytorch-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}:${PYTORCH_VERSION}-${GPUTag} \
	-f pytorch/Dockerfile.gpu pytorch
push-pytorch-notebook-gpu:
	docker push ${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}:${PYTORCH_VERSION}-${GPUTag}

tensorflow-notebook:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook} \
	--build-arg TF_VERSION=${TF_VERSION} \
	--build-arg KERAS_VERSION=${KERAS_VERSION} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}:${TF_VERSION} \
	-f tensorflow/Dockerfile.cpu tensorflow
push-tensorflow-notebook:
	docker push ${REGISTRY}/${OWNER}/${TensorflowNotebook}:${TF_VERSION}

tensorflow-notebook-gpu:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${ScipyNotebook}${GPU}:${GPUTag} \
	--build-arg TF_VERSION=${TF_VERSION} \
	--build-arg KERAS_VERSION=${KERAS_VERSION} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}:${TF_VERSION}-${GPUTag} \
	-f tensorflow/Dockerfile.gpu tensorflow
push-tensorflow-notebook-gpu:
	docker push ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}:${TF_VERSION}-${GPUTag}

#prepare
prepare-tf-tutorial:clean-tf
	curl --user yuanfang@alauda.io -L -O http://bitbucket.org/mathildetech/aml-demo/get/master.tar.gz && mkdir tf-demo && tar zxvf master.tar.gz -C tf-demo --strip-components 1 && rm -rf master.tar.gz && mv tf-demo tensorflow/

tf-gpu-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}:${TF_VERSION}-${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-tutorial:${TF_VERSION}-${GPUTag} \
	-f tensorflow/Dockerfile.demo tensorflow
push-tf-gpu-tutorial:
	docker push ${REGISTRY}/${OWNER}/${TensorflowNotebook}${GPU}-tutorial:${TF_VERSION}-${GPUTag}

tf-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${TensorflowNotebook}:${TF_VERSION} \
	-t ${REGISTRY}/${OWNER}/${TensorflowNotebook}-tutorial:${TF_VERSION} \
	-f tensorflow/Dockerfile.demo tensorflow
push-tf-tutorial:
	docker push ${REGISTRY}/${OWNER}/${TensorflowNotebook}-tutorial:${TF_VERSION}

#prepare
prepare-pytorch-tutorial:clean-tf
	curl --user yuanfang@alauda.io -L -O https://bitbucket.org/mathildetech/pytorch-demo/get/master.tar.gz && mkdir pytorch-demo && tar zxvf master.tar.gz -C pytorch-demo --strip-components 1 && rm -rf master.tar.gz && mv pytorch-demo pytorch/

pytorch-gpu-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}:${PYTORCH_VERSION}-${GPUTag} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}-tutorial:${PYTORCH_VERSION}-${GPUTag} \
	-f pytorch/Dockerfile.demo pytorch
push-pytorch-gpu-tutorial:
	docker push ${REGISTRY}/${OWNER}/${PytorchNotebook}${GPU}-tutorial:${PYTORCH_VERSION}-${GPUTag}

pytorch-tutorial:
	docker build --build-arg BASE_CONTAINER=${REGISTRY}/${OWNER}/${PytorchNotebook}:${PYTORCH_VERSION} \
	-t ${REGISTRY}/${OWNER}/${PytorchNotebook}-tutorial:${PYTORCH_VERSION} \
	-f pytorch/Dockerfile.demo pytorch
push-pytorch-tutorial:
	docker push ${REGISTRY}/${OWNER}/${PytorchNotebook}-tutorial:${PYTORCH_VERSION}

TRAINING_TF_VERSION=1.14.0
TRAINING_PYTORCH_VERSION=1.1.0
TRAINING_PYTORCH_TAG=1.1.0-cuda10.0-cudnn7.5-runtime 
PYTHON_VERSION=-py3

sync-tf:
	docker build --build-arg BASE_CONTAINER=tensorflow/tensorflow:${TRAINING_TF_VERSION}${PYTHON_VERSION}  \
	-t ${REGISTRY}/${OWNER}/tensorflow:${TRAINING_TF_VERSION} \
	-f sync/Dockerfile sync
push-tf:
	docker push ${REGISTRY}/${OWNER}/tensorflow:${TRAINING_TF_VERSION}

sync-tf-gpu:
	docker build --build-arg BASE_CONTAINER=tensorflow/tensorflow:${TRAINING_TF_VERSION}-gpu${PYTHON_VERSION}  \
	-t ${REGISTRY}/${OWNER}/tensorflow:${TRAINING_TF_VERSION}-${GPUTag} \
	-f sync/Dockerfile sync
push-tf-gpu:
	docker push ${REGISTRY}/${OWNER}/tensorflow:${TRAINING_TF_VERSION}-gpu

sync-pytorch:
	docker build --build-arg BASE_CONTAINER=pytorch/pytorch:${TRAINING_PYTORCH_TAG} \
	-t ${REGISTRY}/${OWNER}/pytorch:${TRAINING_PYTORCH_TAG} \
	-f sync/Dockerfile sync
push-pytorch:
	docker push ${REGISTRY}/${OWNER}/pytorch:${TRAINING_PYTORCH_TAG}

SERVING_TF_VERSION=1.13

sync-tfserving:
	docker build --build-arg BASE_CONTAINER=tensorflow/serving:${SERVING_TF_VERSION} \
	-t ${REGISTRY}/${OWNER}/tensorflow-serving:${SERVING_TF_VERSION} \
	-f sync/Dockerfile sync
push-tfserving:
	docker push ${REGISTRY}/${OWNER}/tensorflow-serving:${SERVING_TF_VERSION}

sync-tfserving-gpu:
	docker build --build-arg BASE_CONTAINER=tensorflow/serving:${SERVING_TF_VERSION}-gpu \
	-t ${REGISTRY}/${OWNER}/tensorflow-serving:${SERVING_TF_VERSION}-gpu \
	-f sync/Dockerfile sync
push-tfserving-gpu:
	docker push ${REGISTRY}/${OWNER}/tensorflow-serving:${SERVING_TF_VERSION}-gpu


#clean 
clean-tf:
	rm -rf tensorflow/tf-demo
cleanAll:
	rm master.tar.gz && rm -rf ${gitrepo} 

