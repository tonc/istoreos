# 使用方法

## 1. 拉取镜像
```bash
docker pull xkand/istoreos:latest
```

或者

```bash
docker pull ghcr.nju.edu.cn/tonc/istoreos:latest
```

## 2. 运行容器
 - 创建macvlan网络

```bash
# end0 代表网卡名称 根据上述ip link show查看 macnet为自定义网络名称
docker network create -d macvlan \
  --subnet=192.168.66.0/24 \
  --gateway=192.168.66.1 \
  -o parent=end0 \
  macnet
```