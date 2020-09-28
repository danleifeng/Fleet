<h1 align="center">FleetX</h1>



<p align="center">
    <br>
    <img alt="Fork" src="https://img.shields.io/github/forks/PaddlePaddle/FleetX">
    <img alt="Issues" src="https://img.shields.io/github/issues/PaddlePaddle/FleetX">
    <img alt="License" src="https://img.shields.io/github/license/PaddlePaddle/FleetX">
    <img alt="Star" src="https://img.shields.io/github/stars/PaddlePaddle/FleetX">
    <br>
<p>

<p align="center"> Fully utilize your GPU Clusters with FleetX for your model pre-training. </p>

<h2 align="center">What is it?</h2>

- **FleetX** is an out-of-the-box pre-trained model training toolkit for cloud users. It can be viewed as an extension package for `Paddle's` High-Level Distributed Training API `paddle.distributed.fleet`. 

<h2 align="center">Key Features</h2>

- **Pre-defined Models for Training**
    - define a Bert-Large or GPT-2 with one line code, which is commonly used self-supervised training model.
- **Friendly to User-defined Dataset**
    - plugin user-defined dataset and do training without much effort.
- **Distributed Training Best Practices**
    - the most efficient way to do distributed training is provided.

<h2 align="center">Installation</h2>

``` bash
pip install fleet-x
```

<h2 align="center">A Distributed Resnet50 Training Example</h2>

``` python

import paddle
import paddle.distributed.fleet as fleet
import fleetx as X

configs = X.parse_train_configs()
model = X.applications.Resnet50()

downloader = X.utils.Downloader()
local_path = downloader.download_from_bos(local_path='./data')
loader = model.get_train_loader(local_path, batch_size=32)

fleet.init(is_collective=True)
dist_strategy = fleet.DistributedStrategy()
dist_strategy.amp = True

optimizer = paddle.fluid.optimizer.SGD(learning_rate=configs.lr)
optimizer = fleet.distributed_optimizer(optimizer, strategy=dist_strategy)
optimizer.minimize(model.loss)

trainer = X.MultiGPUTrainer()
trainer.fit(model, loader, epoch=10)

```

<h2 align="center">How to launch your task</h2>

- Multiple cards

``` shell
fleetrun --gpus 0,1,2,3,4,5,6,7 resnet50_app.py
```
<h2 align="center">Community</h2>

### Slack

To connect with other users and contributors, welcome to join our [Slack channel](https://fleetx.slack.com/archives/CUBPKHKMJ)

### Contribution

If you want to contribute code to Paddle Serving, please reference [Contribution Guidelines](doc/CONTRIBUTE.md)

### Feedback

For any feedback or to report a bug, please propose a [GitHub Issue](https://github.com/PaddlePaddle/FleetX/issues).

### License

[Apache 2.0 License](https://github.com/PaddlePaddle/FleetX/blob/develop/LICENSE)
