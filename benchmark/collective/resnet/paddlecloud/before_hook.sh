shdir=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

pwd
pushd ./thirdparty
pwd

echo "we are running before_hook.sh"
echo "list folder ============="
ls

pkg=${WHL_NAME}
echo "pip install new paddle  ============="
pip uninstall -y paddlepaddle-gpu
pip uninstall -y paddlepaddle-cpu

pip install -i  https://pypi.org/simple x86cpu PyTurboJPEG py-cpuinfo==5.0.0
pip uninstall -y requests

if [[ ! -f ${pkg} ]]; then
    echo "can't find whl package:${pkg}"
    exit 1
fi

export https_proxy=http://172.19.57.45:3128/
export http_proxy=http://172.19.57.45:3128/
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,.cdn.bcebos.com,.baidu.com"
pip install -i https://pypi.org/simple $pkg
unset https_proxy http_proxy

popd

mv thirdparty/image_classify_third.tgz .
tar -xzf image_classify_third.tgz

set -xe

HADOOP="/root/paddlejob/hadoop-client/hadoop/bin/hadoop"
FS="afs://xingtian.afs.baidu.com:9902"
UGI="NLP_KM_Data,NLP_km_2018"

if [[ "${DATASET_PATH}x" == "x" ]]; then
    echo "please set your dataset_path"
    exit 1
fi

$HADOOP fs -Dfs.default.name=$FS \
    -Dhadoop.job.ugi=$UGI \
    -get ${DATASET_PATH} .

tar -xf ImageNet.tar
rm -f ImagetNet.tar

mkdir -p log

echo "finish all ==================="

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${PWD}



