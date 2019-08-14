#!/bin/bash
export BASE_PATH="$PWD"

#NCCL
export NCCL_DEBUG=INFO
export NCCL_IB_GID_INDEX=3
export NCCL_IB_RETRY_CNT=0

#PADDLE
export FLAGS_fraction_of_gpu_memory_to_use=0.98
export FLAGS_sync_nccl_allreduce=1
export FLAGS_eager_delete_tensor_gb=0.0

#Cudnn
export FLAGS_sync_nccl_allreduce=1
export FLAGS_cudnn_exhaustive_search=1

#proxy
unset https_proxy http_proxy

# GLOG
export GLOG_v=1
#export GLOG_vmodule=fused_all_reduce_op_handle=10,all_reduce_op_handle=10,alloc_continuous_space_op=10,fuse_all_reduce_op_pass=10,alloc_continuous_space_for_grad_pass=10,fast_threaded_ssa_graph_executor=10,threaded_ssa_graph_executor=10,backward_op_deps_pass=10,graph=10
#export GLOG_vmodule=fast_threaded_ssa_graph_executor=10,parallel_executor=10
#export GLOG_vmodule=nccl_helper=30,init=30,device_context=30,buddy_allocator=30
export GLOG_logtostderr=1


