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

## Releases 同步更新 可用于 pve-lxc容器

[使用方法](./docker.md)

## 功能

- 自动检查 iStoreOS 的最新版本
- 当检测到新版本时，自动构建 Docker 镜像
- 自动发布到 GitHub Releases 和 Docker Hub
