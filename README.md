# iStoreOS Docker

这个项目提供了一个自动化工具，用于检查和更新 iStoreOS 的最新版本，并构建 Docker 镜像。

## 最新版本

- 最新的 iStoreOS 镜像 URL:\nhttps://dl.istoreos.com/iStoreOS/x86_64_efi/istoreos-24.10.2-2025070410-x86-64-squashfs-combined-efi.img.gz
- 更新日期: 2025070410

## Docker 镜像

Docker Hub: https://hub.docker.com/xkand/istoreos

可用标签:
- `latest`: 始终指向最新版本
- `2025070410`: 特定版本的时间戳

## 使用方法

latest: Pulling from xkand/istoreos
04f6b82af385: Pulling fs layer
04f6b82af385: Download complete
04f6b82af385: Pull complete
Digest: sha256:1d8bae3c0a382008bb387f774f58f721f8c297c94bee31e21f34211f6fbc9a39
Status: Downloaded newer image for xkand/istoreos:latest
docker.io/xkand/istoreos:latest
6e821c3b0a2a5be305c11bd8766e4b7f20ee7c064a65d2e2af50b870067ce9f5

## 功能

- 自动检查 iStoreOS 的最新版本
- 当检测到新版本时，自动构建 Docker 镜像
- 自动发布到 GitHub Releases 和 Docker Hub
