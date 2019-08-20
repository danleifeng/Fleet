#!/bin/bash
set -e

#cuda10-cudnn7
#whl=/ssd1/fengdanlei/Paddle/build/python/dist/paddlepaddle_gpu-0.0.0-cp27-cp27mu-linux_x86_64.whl
whl=/ssd1/fengdanlei/new_paddle/Paddle/build/build_cent_develop_release_gpu_y_grpc/python/dist/paddlepaddle_gpu-0.0.0-cp27-cp27mu-linux_x86_64.whl
new_whl_name=paddlepaddle_gpu-0.0.0-cp27-cp27mu-linux_x86_64.whl
#cp ${whl} ${new_whl_name}
new_whl_path=/user/Paddle_Data/fengdanlei/bert/thirdparty/

hadoop fs -Dhadoop.job.ugi=Paddle_Data,Paddle_gpu@2017 -fs afs://xingtian.afs.baidu.com:9902 -rm \
    ${new_whl_path}/${new_whl_name}
hadoop fs -Dhadoop.job.ugi=Paddle_Data,Paddle_gpu@2017 -fs afs://xingtian.afs.baidu.com:9902 -put \
    ${whl} ${new_whl_path}/${new_whl_name}
hadoop fs -Dhadoop.job.ugi=Paddle_Data,Paddle_gpu@2017 -fs afs://xingtian.afs.baidu.com:9902 -ls \
    ${new_whl_path}
