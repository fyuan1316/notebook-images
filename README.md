```bash
--- command to gen noteboobook images ---
* 0. make init
    it will download https://github.com/jupyter/docker-stacks.git

1. make base-notebook-gpu

2. make minimal-notebook-gpu

3. make scipy-notebook-gpu

4. make pytorch-notebook-gpu

* before build tutorials , do 
    make prepare-pytorch-tutorial firstly

5. make pytorch-gpu-tutorial

--- command to gen training and serving images ---

#training#
make sync-tf

make sync-tf-gpu

make sync-pytorch (cpu and gpu use same image)

#serving#
make sync-tfserving

make sync-tfserving-gpu
```

