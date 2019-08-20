#!/bin/bash
#!/bin/bash
# 线上环境
server="paddlecloud.baidu-int.com"
port=80

user_ak="eeafeb9d899450289ad876c9bd599d81"
user_sk="906d135e72cf59a69cbb6cb6a4352086"
# 作业参数
job_prefix=bert_benchmark
card_type=gpu_v100
num_trainers=1
num_cards=8
total_cards=$((num_cards*num_trainers))
job_name=${job_prefix}_N${num_trainers}C${total_cards}

k8s_wall_time="96:00:00"

run_cmd="echo hello world"
image_addr=registry.baidu.com/paddlepaddle-public/distributed_paddle_dgc:cuda9_cudnn7
distribute=" --k8s-not-local --distribute-job-type NCCL2 "
if [[ $num_trainers == "1" ]]; then
    distribute=""
    enable_dgc=False
fi
paddlecloud job \
    --server ${server} \
    --port ${port} \
    --user-ak ${user_ak} \
    --user-sk ${user_sk} \
    train --job-version paddle-fluid-custom \
    --k8s-gpu-type baidu/${card_type} \
    --cluster-name v100-16-0-cluster \
    --k8s-gpu-cards ${num_cards} \
    --k8s-priority high \
    --k8s-wall-time ${k8s_wall_time} \
    --k8s-memory 190Gi \
    --job-name ${job_name} \
    --start-cmd run_cmd \
    --job-conf config.ini \
    --files  before_hook.sh \
    --k8s-trainers ${num_trainers} ${distribute} \
    --k8s-cpu-cores 35 \
    --image-addr "${image_addr}"

