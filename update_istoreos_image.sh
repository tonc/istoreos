#!/bin/bash

# 获取最新的 iStoreOS 镜像 URL
echo "获取最新的 iStoreOS 镜像 URL..."

# 直接使用 wget 下载网页内容到临时文件
TMP_FILE=$(mktemp)
wget -q -O "$TMP_FILE" https://fw0.koolcenter.com/iStoreOS/x86_64_efi/

# 使用 grep 提取所有 img.gz 文件的链接
LATEST_URL=$(grep -o 'istoreos-[0-9.]*-[0-9]*-x86-64-squashfs-combined-efi.img.gz' "$TMP_FILE" | head -n 1)

# 清理临时文件
rm -f "$TMP_FILE"

if [ -z "$LATEST_URL" ]; then
    echo "无法获取最新的镜像 URL，请检查网络连接或网页结构是否变化。"
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "updated=false" >> $GITHUB_OUTPUT
    fi
    exit 1
fi

FULL_URL="https://fw0.koolcenter.com/iStoreOS/x86_64_efi/$LATEST_URL"
echo "最新的 URL: $FULL_URL"

# 从 URL 中提取日期部分
NEW_DATE=$(echo "$FULL_URL" | grep -o '[0-9]\{10\}')
echo "提取的日期: $NEW_DATE"

# 设置 README 文件路径
README_FILE="README.md"

# 检查 README 文件是否存在
if [ -f "$README_FILE" ]; then
    # 从 README 文件中获取当前的 URL
    CURRENT_URL=$(grep -o 'https://fw0.koolcenter.com/iStoreOS/x86_64_efi/istoreos-[0-9.]*-[0-9]*-x86-64-squashfs-combined-efi.img.gz' "$README_FILE" | head -n 1)
    
    if [ -z "$CURRENT_URL" ]; then
        echo "在 README 文件中未找到当前 URL。"
        # 设置为有更新，因为这是首次运行或 URL 格式已更改
        if [ -n "$GITHUB_OUTPUT" ]; then
            echo "updated=true" >> $GITHUB_OUTPUT
            echo "url=$FULL_URL" >> $GITHUB_OUTPUT
            echo "date=$NEW_DATE" >> $GITHUB_OUTPUT
        fi
        exit 0
    fi

    echo "当前的 URL: $CURRENT_URL"

    # 比较 URL
    if [ "$FULL_URL" != "$CURRENT_URL" ]; then
        echo "检测到新版本。"
        
        # 从当前 URL 中提取日期部分
        OLD_DATE=$(echo "$CURRENT_URL" | grep -o '[0-9]\{10\}')
        
        # 显示更新的详细信息
        echo "更新详情:"
        echo "旧 URL: $CURRENT_URL"
        echo "新 URL: $FULL_URL"
        echo "旧日期: $OLD_DATE"
        echo "新日期: $NEW_DATE"

        # 设置 GitHub Actions 输出
        if [ -n "$GITHUB_OUTPUT" ]; then
            echo "updated=true" >> $GITHUB_OUTPUT
            echo "url=$FULL_URL" >> $GITHUB_OUTPUT
            echo "date=$NEW_DATE" >> $GITHUB_OUTPUT
        fi
    else
        echo "没有检测到新版本。"
        if [ -n "$GITHUB_OUTPUT" ]; then
            echo "updated=false" >> $GITHUB_OUTPUT
        fi
    fi
else
    echo "README 文件不存在。"
    # 设置为有更新，因为这是首次运行
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "updated=true" >> $GITHUB_OUTPUT
        echo "url=$FULL_URL" >> $GITHUB_OUTPUT
        echo "date=$NEW_DATE" >> $GITHUB_OUTPUT
    fi
fi