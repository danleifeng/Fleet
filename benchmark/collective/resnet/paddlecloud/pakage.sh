#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR/..

tar_name=image_classify_third.tgz
tar -czvf ${tar_name} *.py cloudenv *.sh scripts models utils

third_path=/user/NLP_KM_Data/fengdanlei/image_classify/thirdparty

hadoop fs -Dhadoop.job.ugi=NLP_KM_Data,NLP_km_2018 -fs afs://xingtian.afs.baidu.com:9902  -rm \
    ${third_path}/${tar_name}

hadoop fs -Dhadoop.job.ugi=NLP_KM_Data,NLP_km_2018 -fs afs://xingtian.afs.baidu.com:9902 -put \
    ${tar_name} ${third_path}/${tar_name}


