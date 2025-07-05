#!/bin/bash

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
if [ $? -ne 0 ]; then
    echo "错误: 下载镜像失败"
    exit 1
fi

# 解压镜像
echo "解压镜像..."
# 使用 gunzip -c 将内容输出到新文件，忽略 trailing garbage 警告
# 使用 true 确保即使 gunzip 返回非零退出代码，命令也不会失败
gunzip -c istoreos.img.gz > istoreos.img || true

# 验证解压后的文件
if [ ! -f istoreos.img ] || [ ! -s istoreos.img ]; then
    echo "错误: 解压后的镜像文件不存在或为空"
    exit 1
else
    echo "解压成功，镜像大小: $(du -h istoreos.img | cut -f1)"
fi

# 加载 nbd 模块
echo "加载 nbd 模块..."
modprobe nbd
if [ $? -ne 0 ]; then
    echo "错误: 加载 nbd 模块失败"
    exit 1
fi

# 连接镜像到 nbd 设备
echo "连接镜像到 nbd 设备..."
qemu-nbd -c /dev/nbd0 -f raw istoreos.img
if [ $? -ne 0 ]; then
    echo "错误: 连接镜像到 nbd 设备失败"
    exit 1
fi

# 显示分区信息
echo "分区信息:"
lsblk -f /dev/nbd0
fdisk -l /dev/nbd0
echo "等待分区设备出现..."
sleep 5
ls -la /dev/nbd0*

# 尝试重新扫描分区表
echo "重新扫描分区表..."
partprobe /dev/nbd0
sleep 2
ls -la /dev/nbd0*

# 创建挂载点
echo "创建挂载点..."
mkdir -p /mnt/openwrt
if [ $? -ne 0 ]; then
    echo "错误: 创建挂载点失败"
    # 清理 nbd 设备
    qemu-nbd -d /dev/nbd0
    exit 1
fi

# 尝试确定正确的分区
echo "尝试确定正确的分区..."
ROOT_PARTITION=""
if [ -e "/dev/nbd0p2" ]; then
    ROOT_PARTITION="/dev/nbd0p2"
    echo "找到分区: /dev/nbd0p2"
elif [ -e "/dev/nbd0p1" ]; then
    ROOT_PARTITION="/dev/nbd0p1"
    echo "找到分区: /dev/nbd0p1"
elif [ -e "/dev/nbd01" ]; then
    ROOT_PARTITION="/dev/nbd01"
    echo "找到分区: /dev/nbd01"
elif [ -e "/dev/nbd02" ]; then
    ROOT_PARTITION="/dev/nbd02"
    echo "找到分区: /dev/nbd02"
else
    echo "错误: 无法找到有效的分区"
    # 清理 nbd 设备
    qemu-nbd -d /dev/nbd0
    exit 1
fi

# 挂载分区
echo "挂载分区 $ROOT_PARTITION..."
mount $ROOT_PARTITION /mnt/openwrt
if [ $? -ne 0 ]; then
    echo "错误: 挂载分区失败"
    # 清理 nbd 设备
    qemu-nbd -d /dev/nbd0
    exit 1
fi

# 检查工作目录
echo "检查工作目录..."
WORKSPACE_DIR="/github/workspace"
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "警告: $WORKSPACE_DIR 目录不存在，尝试创建..."
    mkdir -p "$WORKSPACE_DIR"
    if [ $? -ne 0 ]; then
        echo "错误: 无法创建 $WORKSPACE_DIR 目录"
        echo "尝试使用当前目录..."
        WORKSPACE_DIR="."
    fi
fi

echo "检查目录权限..."
touch "$WORKSPACE_DIR/test_write_permission" && rm "$WORKSPACE_DIR/test_write_permission"
if [ $? -ne 0 ]; then
    echo "警告: 无法写入 $WORKSPACE_DIR 目录，尝试使用 /tmp 目录..."
    WORKSPACE_DIR="/tmp"
fi

echo "使用工作目录: $WORKSPACE_DIR"
OUTPUT_FILE="$WORKSPACE_DIR/istoreos.rootfs.tar.gz"

# 打包根文件系统
echo "打包根文件系统到 $OUTPUT_FILE..."
cd /mnt/openwrt
ls -la
echo "开始打包..."
tar -czvf "$OUTPUT_FILE" *
if [ $? -ne 0 ]; then
    echo "错误: 打包根文件系统失败"
    # 清理
    cd /
    umount /mnt/openwrt/ || true
    qemu-nbd -d /dev/nbd0 || true
    exit 1
fi

# 验证文件是否创建
echo "验证文件是否创建..."
if [ ! -f "$OUTPUT_FILE" ] || [ ! -s "$OUTPUT_FILE" ]; then
    echo "错误: 根文件系统打包文件不存在或为空"
    # 清理
    cd /
    umount /mnt/openwrt/ || true
    qemu-nbd -d /dev/nbd0 || true
    exit 1
else
    echo "根文件系统打包成功，大小: $(du -h "$OUTPUT_FILE" | cut -f1)"
    ls -la "$OUTPUT_FILE"
    
    # 如果使用了临时目录，复制到预期位置
    if [ "$WORKSPACE_DIR" != "/github/workspace" ] && [ "$WORKSPACE_DIR" != "." ]; then
        echo "复制文件到预期位置..."
        cp "$OUTPUT_FILE" /github/workspace/ 2>/dev/null || cp "$OUTPUT_FILE" . 2>/dev/null || echo "警告: 无法复制文件到预期位置"
    fi
fi

# 清理
echo "清理..."
cd /
umount /mnt/openwrt/ || true
qemu-nbd -d /dev/nbd0 || true

echo "处理完成!"