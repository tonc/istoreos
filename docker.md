# 使用方法

## 1. 拉取镜像
```bash
docker pull xkand/istoreos:latest
```

或者

```bash
docker pull ghcr.nju.edu.cn/tonc/istoreos:latest
```

## 2. 创建macvlan网络

```bash
# 开启网卡混杂模式
ip link set eth0 promisc on
```

```bash
# eth0 代表网卡名称 根据ip link show查看 macnet为自定义网络名称
docker network create -d macvlan \
  --subnet=10.0.0.0/24 \
  --gateway=10.0.0.1 \
  --subnet=fd00::/64 \
  -o parent=eth0 \
  macnet
```
- [具体原理请参考](https://club.fnnas.com/forum.php?mod=viewthread&tid=2614&highlight=)

```bash
## 简单来说就是添加一张网卡做为路由中转

ip link add TTTTT link eth0 type macvlan mode bridge
# TTTTT为网卡名 随意就好，eth0网卡名称根据实际情况更改

ip addr add 10.0.0.199/24 dev TTTTT
# ip地址 设置一个你局域网其他不冲突的任何地址

ip link set TTTTT up
# 启动网卡

```

- 开机自启方法

```bash
cat <<EOF >"/etc/systemd/system/setup-network.service"
[Unit]
Description=Setup Network for macvlan
After=network.target

[Service]
ExecStart=/usr/local/bin/setup_network.sh
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
```

```bash
cat <<EOF >"/usr/local/bin/setup_network.sh"
#!/bin/bash
set -e
# 检查是否已存在
if ! ip link show TTTTT > /dev/null 2>&1; then
    ip link add TTTTT link eth0 type macvlan mode bridge
    ip addr add 10.0.0.199/24 dev TTTTT
    ip link set TTTTT up
fi
EOF
```

```bash
chmod +x /usr/local/bin/create-macvlan-shim.sh
systemctl daemon-reload
systemctl enable setup-network.service
systemctl start macvlan-shim
```

## 3. 启动容器
 - docker cli

```bash
docker run -d \
  --name iStoreOS \
  --restart always \
  --privileged \
  -v /lib/modules:/lib/modules:ro \
  -v /dev:/dev \
  --cap-add NET_ADMIN \
  --cap-add SYS_MODULE \
  --device /dev/net/tun \
  --network macnet \
  xkand/istoreos:latest \
  /sbin/init
```

 - docker compose

```bash
cat <<EOF >docker-compose.yml
services:
  iStoreOS:
    image: xkand/istoreos:latest
    container_name: iStoreOS
    restart: always
    privileged: true
    volumes:
      - /lib/modules:/lib/modules:ro
      - /dev:/dev
    command: /sbin/init

    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    devices:
      - /dev/net/tun
    networks:
      - macnet

networks:
  macnet:
    external: true
EOF
```

```bash
docker-compose up -d
```