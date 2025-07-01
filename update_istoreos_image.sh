#!/bin/bash

# 设置工作目录
WORK_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$WORK_DIR"

echo "正在获取最新的 iStoreOS 镜像..."

# 获取网页内容并提取最新的 img.gz 文件链接
LATEST_IMG_GZ=$(curl -s https://fw.koolcenter.com/iStoreOS/x86_64_efi/ | 
                grep -o 'href="[^"]*img\.gz"' | 
                sed 's/href="//;s/"$//' | 
                sort -r | 
                head -n 1)

if [ -z "$LATEST_IMG_GZ" ]; then
    echo "错误：无法获取最新的 img.gz 文件链接"
    exit 1
fi

# 构建完整的 URL
FULL_URL="https://fw.koolcenter.com/iStoreOS/x86_64_efi/$LATEST_IMG_GZ"
echo "找到最新的镜像：$FULL_URL"

# 从 URL 中提取日期部分（假设格式为 istoreos-版本号-日期-其他部分）
DATE=$(echo "$LATEST_IMG_GZ" | grep -oE '[0-9]{10}')
if [ -z "$DATE" ]; then
    echo "警告：无法从 URL 中提取日期部分"
    # 使用当前日期作为备用
    DATE=$(date +"%Y%m%d%H")
fi

echo "提取的日期：$DATE"

# 检查当前工作流文件中的日期
CURRENT_DATE=""
if [ -f ".github/workflows/istoreos.yml" ]; then
    CURRENT_DATE=$(grep -oE 'istoreos-[0-9\.]+-([0-9]{10})-' .github/workflows/istoreos.yml | grep -oE '[0-9]{10}' | head -n 1)
    echo "当前工作流文件中的日期：$CURRENT_DATE"
else
    echo "警告：找不到 .github/workflows/istoreos.yml 文件"
    ls -la .github/workflows/
fi

# 检查是否需要更新
if [ "$CURRENT_DATE" = "$DATE" ]; then
    echo "当前工作流文件已经是最新的镜像日期，无需更新"
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "updated=false" >> $GITHUB_OUTPUT
    else
        echo "::set-output name=updated::false"
    fi
    exit 0
fi

echo "发现新版本镜像，需要更新工作流文件"
if [ -n "$GITHUB_OUTPUT" ]; then
    echo "updated=true" >> $GITHUB_OUTPUT
else
    echo "::set-output name=updated::true"
fi

# 更新 istoreos.yml 文件
if [ -f "istoreos.yml" ]; then
    echo "更新 istoreos.yml 文件中的镜像 URL..."
    
    # 备份原文件
    cp istoreos.yml istoreos.yml.bak
    
    # 更新文件中的 URL 和文件名
    # 使用兼容不同系统的 sed 命令
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|url: https://fw.koolcenter.com/iStoreOS/x86_64_efi/.*img\.gz|url: $FULL_URL|g" istoreos.yml
        sed -i '' "s|filename: istoreos-.*-x86_64-efi-squashfs\.img\.gz|filename: $LATEST_IMG_GZ|g" istoreos.yml
    else
        # Linux 和其他系统
        sed -i "s|url: https://fw.koolcenter.com/iStoreOS/x86_64_efi/.*img\.gz|url: $FULL_URL|g" istoreos.yml
        sed -i "s|filename: istoreos-.*-x86_64-efi-squashfs\.img\.gz|filename: $LATEST_IMG_GZ|g" istoreos.yml
    fi
    
    echo "更新完成。"
    
    # 显示差异
    echo "文件更改内容："
    diff istoreos.yml.bak istoreos.yml || true
else
    echo "错误：找不到 istoreos.yml 文件，无法更新"
    exit 1
fi

# 更新 .github/workflows/istoreos.yml 文件中的 URL 和日期
sed -i "s|wget https://fw.*img\.gz|wget $FULL_URL|g" .github/workflows/istoreos.yml
sed -i "s|URL=\"https://fw.*img\.gz\"|URL=\"$FULL_URL\"|g" .github/workflows/istoreos.yml

# 更新文件名部分
OLD_FILENAME=$(grep -o "istoreos-.*-x86-64-squashfs-combined-efi\.img" .github/workflows/istoreos.yml | head -n 1)
NEW_FILENAME=$(echo "$LATEST_IMG_GZ" | sed 's/\.gz$//')

if [ -n "$OLD_FILENAME" ] && [ -n "$NEW_FILENAME" ]; then
    sed -i "s|$OLD_FILENAME|$NEW_FILENAME|g" .github/workflows/istoreos.yml
    echo "已更新文件名：$OLD_FILENAME -> $NEW_FILENAME"
else
    echo "警告：无法更新文件名"
fi

echo "istoreos.yml 文件已更新"

# # 如果设置了自动构建，则触发 GitHub Actions 工作流
# if [ "$1" == "--build" ]; then
#     echo "触发 GitHub Actions 工作流..."
#     # 这里需要使用 GitHub CLI 或 API 来触发工作流
#     # 例如：gh workflow run "Build iStoreOS Scratch Docker Image and Push to Docker Hub"
#     # 或者使用 curl 调用 GitHub API
# fi

# echo "完成！"