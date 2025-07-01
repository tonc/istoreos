#!/bin/bash

# 设置变量
WORKFLOW_FILE=".github/workflows/istoreos.yml"
DATE=$(date +%Y%m%d)
GITHUB_OUTPUT=${GITHUB_OUTPUT:-/dev/null}

# 获取最新的 iStoreOS 镜像 URL
echo "获取最新的 iStoreOS 镜像 URL..."
LATEST_URL=$(curl -s https://fw0.koolcenter.com/iStoreOS/x86_64_efi/ | grep -o 'href="[^"]*\.img\.gz"' | grep -o '"[^"]*"' | tr -d '"' | sort -r | head -n 1)
FULL_URL="https://fw0.koolcenter.com/iStoreOS/x86_64_efi/$LATEST_URL"
echo "最新的 URL: $FULL_URL"

# 从工作流文件中获取当前的 URL
CURRENT_URL=$(grep -o 'wget https://fw0.koolcenter.com/iStoreOS/x86_64_efi/[^ ]*' $WORKFLOW_FILE | head -n 1 | cut -d ' ' -f 2)
echo "当前的 URL: $CURRENT_URL"

# 比较 URL
if [ "$FULL_URL" != "$CURRENT_URL" ]; then
    echo "检测到新版本，更新工作流文件..."
    
    # 更新工作流文件中的 URL
    sed -i "s|wget $CURRENT_URL|wget $FULL_URL|g" $WORKFLOW_FILE
    
    # 从 URL 中提取日期部分
    NEW_DATE=$(echo "$FULL_URL" | grep -oE '[0-9]{10}')
    OLD_DATE=$(echo "$CURRENT_URL" | grep -oE '[0-9]{10}')
    
    # 更新工作流文件中的日期引用
    sed -i "s|$OLD_DATE|$NEW_DATE|g" $WORKFLOW_FILE
    
    echo "工作流文件已更新。"
    echo "updated=true" >> $GITHUB_OUTPUT
    
    # 显示更新的详细信息，便于调试
    echo "更新详情:"
    echo "旧 URL: $CURRENT_URL"
    echo "新 URL: $FULL_URL"
    echo "旧日期: $OLD_DATE"
    echo "新日期: $NEW_DATE"
else
    echo "没有检测到新版本，无需更新。"
    echo "updated=false" >> $GITHUB_OUTPUT
fi