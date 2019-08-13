#!/bin/bash
set -e

update_method=nccl2
job_name=$USER-demo
num_trainers=4
card_type=gpu_v100
num_cards=8
enable_dgc=False
image_addr="registry.baidu.com/paddlepaddle-public/distributed_paddle_dgc:cuda9_cudnn7"
user_conf=v100_conf.sh
whl_name="paddlepaddle_gpu_multincclstream-0.0.0.post97-cp27-cp27mu-linux_x86_64.whl"
# fp16=True   #change to false
fp16=False
fuse=False
num_epochs=90
#dataset_path="/app/inf/mpi/bml-guest/paddle-platform/vis/gongwb/dataset/ImageNet/small/ImageNet.tar"
dataset_path="/user/NLP_KM_Data/gongweibao/image_classify/dataset/ImageNet/small/ImageNet.tar"
fake_queue=False
#shuffle_files=True
nccl_comm_num=1
num_threads=1
nccl_version=2.3
use_hierarchical_allreduce=False
profile=True
batch_size=32
lr=0.1

while true ; do
  case "$1" in
    -conf) user_conf="$2" ; shift 2 ;;
    -method) update_method="$2" ; shift 2 ;;
    -job) job_name="$2" ; shift 2 ;;
    -enable_dgc) enable_dgc="$2" ; shift 2 ;;
    -num_trainers) num_trainers="$2" ; shift 2 ;;
    -num_cards) num_cards="$2" ; shift 2 ;;
    -num_epochs) num_epochs="$2" ; shift 2 ;;
    -lr) num_epochs="$2" ; shift 2 ;;
    -card_type) card_type="$2" ; shift 2 ;;
    -whl_name) whl_name="$2" ; shift 2 ;;
    -dataset_path) dataset_path="$2" ; shift 2 ;;
    -fp16) fp16="$2" ; shift 2 ;;
    -fuse) fuse="$2" ; shift 2 ;;
    -fake_queue) fake_queue="$2" ; shift 2 ;;
    #-shuffle_files) shuffle_files="$2" ; shift 2 ;;
    -nccl_version) nccl_version="$2" ; shift 2 ;;
    -nccl_comm_num) nccl_comm_num="$2" ; shift 2 ;;
    -num_threads) num_threads="$2" ; shift 2 ;;
    -use_hierarchical_allreduce) use_hierarchical_allreduce="$2" ; shift 2 ;;
    #-hierarchical_allreduce_inter_nranks) hierarchical_allreduce_inter_nranks="$2" ; shift 2 ;;
    #-enable_backward_op_deps) enable_backward_op_deps="$2" ; shift 2 ;;
    -profile) profile="$2" ; shift 2 ;;
    -batch_size) batch_size="$2" ; shift 2 ;;
    *)
       if [[ ${#1} > 0 ]]; then
          echo "not supported arugments ${1}" ; exit 1 ;
       else
           break
       fi
       ;;
  esac
done

case "${update_method}" in
    #pserver) ;;
    nccl2) ;;
    *) echo "not support argument -method: ${method}" ; exit 1 ;;
esac

case "${enable_dgc}" in 
    True) ;;
    False) ;;
    *) echo "not support argument -method: ${enable_dgc}" ; exit 1 ;;
esac

case "${fp16}" in 
    True) ;;
    False) ;;
    *) echo "not support argument -method: ${fp16}" ; exit 1 ;;
esac
sed -i "s:^\(use_fp16\s*=\s*\).*$:\1${fp16}:" cloud_job_conf.py

case "${fuse}" in 
    True) ;;
    False) ;;
    *) echo "not support argument -method: ${fuse}" ; exit 1 ;;
esac
sed -i "s:^\(fuse\s*=\s*\).*$:\1${fuse}:" cloud_job_conf.py


sed -i "s:^\(nodes\s*=\s*\).*$:\1${num_trainers}:" cloud_job_conf.py
#sed -i "s:^\(shuffle_files\s*=\s*\).*$:\1${shuffle_files}:" cloud_job_conf.py
sed -i "s:^\(nccl_comm_num\s*=\s*\).*$:\1${nccl_comm_num}:" cloud_job_conf.py
echo "num_threads:${num_threads}"
sed -i "s:^\(num_threads\s*=\s*\).*$:\1${num_threads}:" cloud_job_conf.py
sed -i "s:^\(nccl_version\s*=\s*\).*$:\1${nccl_version}:" cloud_job_conf.py
sed -i "s:^\(use_hierarchical_allreduce\s*=\s*\).*$:\1${use_hierarchical_allreduce}:" cloud_job_conf.py
#sed -i "s:^\(hierarchical_allreduce_inter_nranks\s*=\s*\).*$:\1${hierarchical_allreduce_inter_nranks}:" cloud_job_conf.py
#sed -i "s:^\(enable_backward_op_deps\s*=\s*\).*$:\1${enable_backward_op_deps}:" cloud_job_conf.py
sed -i "s:^\(profile\s*=\s*\).*$:\1${profile}:" cloud_job_conf.py
sed -i "s:^\(num_cards\s*=\s*\).*$:\1${num_cards}:" cloud_job_conf.py
sed -i "s:^\(num_epochs\s*=\s*\).*$:\1${num_epochs}:" cloud_job_conf.py
sed -i "s:^\(batch_size\s*=\s*\).*$:\1${batch_size}:" cloud_job_conf.py
sed -i "s:^\(lr\s*=\s*\).*$:\1${lr}:" cloud_job_conf.py

case "$card_type" in 
    gpu_v100) 
        image_addr=registry.baidu.com/paddlepaddle-public/distributed_paddle_dgc:cuda9_cudnn7
        ;;
    gpu_p40) 
        image_addr=registry.baidu.com/paddlepaddle-public/distributed_paddle_dgc:centos6u3-cuda8-cudnn7
        user_conf=p40_conf.sh
        ;;
    *) echo "not supported argument -card_type: ${card_type}" ; exit 1 ;;
esac

re='^[0-9]+$'
if ! [[ ${num_epochs} =~ $re ]] ; then
   echo "error: ${num_epochs} Not a number" >&2; exit 1
fi

source ${user_conf}

if [[ ${whl_name} != "" ]]; then
    echo "set whl_name:" ${whl_name}
    sed -i "s/^\(whl_name\s*=\s*\).*$/\1${whl_name}/" cloud_job_conf.py
fi

if [[ ${dataset_path} != "" ]]; then
    echo "set dataset_path:" ${dataset_path}
    sed -i "s:^\(dataset_path\s*=\s*\).*$:\1${dataset_path}:" cloud_job_conf.py
fi


set -xe
k8s_wall_time="96:00:00"

distribute=" --k8s-not-local --distribute-job-type NCCL2 "
if [[ $num_trainers == "1" ]]; then
    distribute=""
    enable_dgc=False
fi


./package.sh

set -x

if (( ${num_cards} < 8 )); then
    num_cards=8
fi

paddlecloud job \
    --server ${server} \
    --port ${port} \
    --user-ak ${user_ak} \
    --user-sk ${user_sk} \
    train --job-version paddle-fluid-custom \
    --k8s-gpu-type baidu/${card_type} \
    --cluster-name paddle-jpaas-ai00-gpu \
    --k8s-gpu-cards ${num_cards} \
    --k8s-priority high \
    --k8s-wall-time ${k8s_wall_time} \
    --k8s-memory 190Gi \
    --job-name ${job_name} \
    --start-cmd "bash cloudenv/train_pretrain.sh" \
    --job-conf cloud_job_conf.py \
    --files  before_hook.sh end_hook.sh \
    --k8s-trainers ${num_trainers} ${distribute} \
    --k8s-cpu-cores 35 \
    --image-addr "${image_addr}"




