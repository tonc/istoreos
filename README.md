# iStoreOS Docker

这个项目提供了一个自动化工具，用于检查和更新 iStoreOS 的最新版本，并构建 Docker 镜像。

## 最新版本

- 最新的 iStoreOS 镜像 URL: https://dl.istoreos.com/iStoreOS/x86_64_efi/istoreos-24.10.2-2025070410-x86-64-squashfs-combined-efi.img.gz
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
Digest: sha256:ae522ceb065e9b73d4e6a53884a39240036f86879691060681bfa7622b3f9116
Status: Downloaded newer image for xkand/istoreos:latest
docker.io/xkand/istoreos:latest
c3c0ec12bb7d2f5d5df2573cfd945a573b544c2e9fc7729b7d7d99bd3cf521ad

## 功能

- 自动检查 iStoreOS 的最新版本
- 当检测到新版本时，自动构建 Docker 镜像
- 自动发布到 GitHub Releases 和 Docker Hub
