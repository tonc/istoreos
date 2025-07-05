#!/bin/bash
set -e

# 获取镜像 URL
IMAGE_URL="$1"
if [ -z "$IMAGE_URL" ]; then
    echo "错误: 未提供镜像 URL"
    exit 1
fi

echo "处理镜像: $IMAGE_URL"

# 下载镜像
echo "下载镜像..."
wget "$IMAGE_URL" -O istoreos.img.gz

# 解压镜像
echo "解压镜像..."
# 使用 gunzip -c 将内容输出到新文件，避免 trailing garbage 问题
gunzip -c istoreos.img.gz > istoreos.img || { echo "解压失败"; exit 1; }

# 验证解压后的文件
if [ ! -f istoreos.img ] || [ ! -s istoreos.img ]; then
    echo "错误: 解压后的镜像文件不存在或为空"
    exit 1
fi
echo "解压成功，镜像大小: $(du -h istoreos.img | cut -f1)"

# 加载 nbd 模块
echo "加载 nbd 模块..."
modprobe nbd

# 连接镜像到 nbd 设备
echo "连接镜像到 nbd 设备..."
qemu-nbd -c /dev/nbd0 -f raw istoreos.img

# 显示分区信息
echo "分区信息:"
lsblk -f /dev/nbd0

# 创建挂载点
echo "创建挂载点..."
mkdir -p /mnt/openwrt

# 挂载分区
echo "挂载分区..."
mount /dev/nbd0p2 /mnt/openwrt

# 打包根文件系统
echo "打包根文件系统..."
cd /mnt/openwrt && tar -czvf /github/workspace/istoreos.rootfs.tar.gz *

# 验证文件是否创建
echo "验证文件是否创建..."
ls -la /github/workspace/istoreos.rootfs.tar.gz

# 清理
echo "清理..."
cd /
umount /mnt/openwrt/
qemu-nbd -d /dev/nbd0

echo "处理完成!"