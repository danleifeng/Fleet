#!/bin/bash
set -e
pwd
cd ..
rm -rf BERT.tar.gz
tar -czvf BERT.tar.gz ./* --exclude=./paddlecloud

new_whl_path=/user/Paddle_Data/fengdanlei/bert/thirdparty/

#hadoop fs -Dhadoop.job.ugi=Paddle_Data,Paddle_gpu@2017 -fs afs://xingtian.afs.baidu.com:9902 -rm \
#    ${new_whl_path}/BERT.tar.gz
hadoop fs -Dhadoop.job.ugi=Paddle_Data,Paddle_gpu@2017 -fs afs://xingtian.afs.baidu.com:9902 -put \
    ./BERT.tar.gz ${new_whl_path}/BERT.tar.gz
hadoop fs -Dhadoop.job.ugi=Paddle_Data,Paddle_gpu@2017 -fs afs://xingtian.afs.baidu.com:9902 -ls \
    ${new_whl_path}
