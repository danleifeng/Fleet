#!/bin/bash
set -e
whl_name=paddlepaddle_gpu-0.0.0-cp27-cp27mu-linux_x86_64.whl
nccl_comm_num=1
num_epochs=10
profile=False
use_hierarchical_allreduce=False
batch_size=32
lr=0.001
#dataset_path=/user/NLP_KM_Data/gongweibao/image_classify/dataset/ImageNet/large/ImageNet.tar
dataset_path=/user/NLP_KM_Data/gongweibao/image_classify/dataset/ImageNet/small/ImageNet.tar
echo "test ${num_trainers} whl_name:{$whl_name}"

#trainers 1
num_trainers=4
nccl_comm_num=1
./run_job.sh \
    -num_trainers ${num_trainers}\
    -job resnet_n${num_trainers}_fuse_thread2_001 \
    -fuse True \
    -nccl_comm_num 1 \
    -num_threads 2 \
    -lr ${lr}
    -whl_name ${whl_name} \
    -use_hierarchical_allreduce False \
    -profile ${profile} \
    -batch_size ${batch_size} \
    -num_epochs ${num_epochs} \
    -dataset_path ${dataset_path}
