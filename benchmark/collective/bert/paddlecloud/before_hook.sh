
set -exu

echo "starting hook"

train_bert() {
    unset http_proxy
    unset https_proxy
    export FLAGS_enable_parallel_graph=0
    export FLAGS_sync_nccl_allreduce=1
    export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
    export FLAGS_eager_delete_tensor_gb=0
    export FLAGS_fuse_parameter_memory_size=32 #MB
    export FLAGS_fuse_parameter_groups_size=50

    is_distributed="--is_distributed true"
    SAVE_STEPS=320000
    BATCH_SIZE=4096
    LR_RATE=1e-4
    WEIGHT_DECAY=0.01

    TRAIN_DATA_DIR=./data/train/wikipedia_small
    CONFIG_PATH=./data/demo_config/bert_config.json
    VOCAB_PATH=./data/demo_config/vocab.txt

    #python -m paddle.distributed.launch --cluster_node_ips ${PADDLE_TRAINERS} --node_ip ${POD_IP} --log_dir mylog \
    #python -m paddle.distributed.launch --log_dir mylog \
    python -m paddle.distributed.launch --cluster_node_ips ${PADDLE_TRAINERS} --node_ip ${POD_IP} --log_dir mylog \
       train_bert.py ${is_distributed}\
        --use_cuda true\
        --weight_sharing true\
        --batch_size ${BATCH_SIZE} \
        --data_dir ${TRAIN_DATA_DIR} \
        --validation_set_dir  ""\
        --bert_config_path ${CONFIG_PATH} \
        --vocab_path ${VOCAB_PATH} \
        --generate_neg_sample true\
        --checkpoints ./output \
        --save_steps ${SAVE_STEPS} \
        --learning_rate ${LR_RATE} \
        --weight_decay ${WEIGHT_DECAY:-0} \
        --skip_steps 20 \
        --num_iteration_per_drop_scope 10 \
        --num_train_steps 32000000 \
        --use_fp16 false \
        --loss_scaling 8.0 \
        --epoch 100 \
        --max_seq_len 128

}

# prepare code and data
pushd thirdparty

echo "list folder $PWD"
ls

filelist=(Python-2.7.14.tgz cuda-9.2.tgz cudnn742c92.tgz nccl237c92.tgz)
for file in ${filelist[@]}; do
  tar zxf $file
  rm $file
done

sed -i '1s/.*/#!\/usr\/bin\/env python/' Python-2.7.14/bin/pip

mkdir /opt/compiler
mv gcc-4.8.2.tgz /opt/compiler
cd /opt/compiler
tar zxf gcc-4.8.2.tgz
rm gcc-4.8.2.tgz
cd -

export PATH=$PWD/Python-2.7.14/bin:/opt/compiler/gcc-4.8.2/lib64:$PATH
export LD_LIBRARY_PATH=$PWD/cuda-9.2/lib64:$PWD/cudnn742c92/lib64:$PWD/nccl237c92/lib:$LD_LIBRARY_PATH

pkg=paddlepaddle_gpu-0.0.0-cp27-cp27mu-linux_x86_64.whl

if [ -f $pkg ]; then
    echo "pip install new paddle"
    pip uninstall -y paddlepaddle-gpu
    pip uninstall -y paddlepaddle-cpu
    pip install $pkg
fi

tar -xzf BERT.tar.gz
mv BERT/* ../

hadoop fs -D fs.default.name=afs://xingtian.afs.baidu.com:9902  -D hadoop.job.ugi=mlarch,Fv1M87 \
-get /user/feed/mlarch/sequence_generator/dongdaxiang/fast_bert/wikipedia_book_corpus_small_seq128 ./data/train/wikipedia_small

popd

train_bert

echo "finish hook"

