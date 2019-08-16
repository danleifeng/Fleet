#!/bin/bash
source ./cloudenv/env.sh

echo "LD_LIBRARY_PATH:" ${LD_LIBRARY_PATH}

if [[ "${NCCL_VERSION}x" == "2.4x" ]] ; then
    export LD_LIBRARY_PATH="${BASE_PATH}/nccl_2.4.2.1_cuda9.0/lib/:$LD_LIBRARY_PATH"
fi

if [[ ${FUSE} == "True" ]]; then
    export FLAGS_fuse_parameter_memory_size=16 #MB
    export FLAGS_fuse_parameter_groups_size=50
fi

set -x

distributed_args=""
if [[ ${NUM_CARDS} == "1" ]]; then
    distributed_args="--selected_gpus 0"
fi

node_ips=${PADDLE_TRAINERS}
if [[ "${node_ips}x" == "x" ]] ; then
    node_ips=${POD_IP}
else
    distributed_args="${distributed_args} --cluster_node_ips ${node_ips} --node_ip ${POD_IP}"
fi


python -m paddle.distributed.launch ${distributed_args} --log_dir log \
       ./train_with_fleet.py \
       --model=ResNet50 \
       --batch_size=${BATCH_SIZE} \
       --total_images=1281167 \
       --data_dir=./ImageNet \
       --class_dim=1000 \
       --image_shape=3,224,224 \
       --model_save_dir=output/ \
       --with_mem_opt=False \
       --lr_strategy=piecewise_decay \
       --lr=0.2\
       --num_epochs=${NUM_EPOCHS} \
       --l2_decay=1e-4 \
       --scale_loss=1.0 \
       --fuse=${FUSE} \
       --num_threads=${NUM_THREADS} \
       --nccl_comm_num=${NCCL_COMM_NUM} \
       --use_hierarchical_allreduce=${USE_HIERARCHICAL_ALLREDUCE} \
       --fp16=${USE_FP16}



