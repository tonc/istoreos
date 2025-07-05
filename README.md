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
Digest: sha256:22c899d1c73d9db3285dbd9b80139366e5efc2c3c8df237bdba30268c4a8536f
Status: Downloaded newer image for xkand/istoreos:latest
docker.io/xkand/istoreos:latest
135fcc45b75ebf01f9c95de1a59da044c245b14fe480453d24407662f800b57a

## 功能

- 自动检查 iStoreOS 的最新版本
- 当检测到新版本时，自动构建 Docker 镜像
- 自动发布到 GitHub Releases 和 Docker Hub
