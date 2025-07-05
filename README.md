# iStoreOS Docker

这个项目提供了一个自动化工具，用于检查和更新 iStoreOS 的最新版本，并构建 Docker 镜像。

## 最新版本

- 最新的 iStoreOS 镜像 URL:
  https://dl.istoreos.com/iStoreOS/x86_64_efi/istoreos-24.10.2-2025070410-x86-64-squashfs-combined-efi.img.gz
- 更新日期: 2025070410

## Docker 镜像

Docker Hub: https://hub.docker.com/xkand/istoreos

可用标签:
- `latest`: 始终指向最新版本
- `2025070410`: 特定版本的时间戳

## 使用方法

latest: Pulling from xkand/istoreos
04f6b82af385: Pulling fs layer
04f6b82af385: Verifying Checksum
04f6b82af385: Download complete
04f6b82af385: Pull complete
Digest: sha256:9a1099c05832b8606df38a79d80fcc6c6eb78a96e03ee270d5c9c9ca7f0bcf56
Status: Downloaded newer image for xkand/istoreos:latest
docker.io/xkand/istoreos:latest
e6476d25eb5cd39ef6345c6983abce88a35fc2c6dd2ec297c19dacf4a90c8e98

## 功能

- 自动检查 iStoreOS 的最新版本
- 当检测到新版本时，自动构建 Docker 镜像
- 自动发布到 GitHub Releases 和 Docker Hub
