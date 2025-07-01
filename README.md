# iStoreOS Docker 镜像自动更新

这个项目自动检查 iStoreOS 的最新版本，并构建 Docker 镜像推送到 Docker Hub。

## 功能特点

- 自动检测 iStoreOS 的最新版本
- 自动更新工作流配置文件
- 自动构建 Docker 镜像并推送到 Docker Hub
- 支持手动触发和定时触发

## 工作流程

1. **检查更新工作流** (check_update.yml)
   - 每4小时运行一次
   - 检查 iStoreOS 是否有新版本
   - 如果有新版本，更新工作流配置文件并创建 Pull Request
   - 触发构建工作流

2. **构建镜像工作流** (istoreos.yml)
   - 下载最新的 iStoreOS 镜像
   - 提取 squashfs 文件系统
   - 构建 Docker 镜像
   - 推送到 Docker Hub

## 使用方法

### 手动触发检查更新

1. 进入 GitHub 仓库
2. 点击 "Actions" 标签
3. 选择 "Check and Build iStoreOS Image" 工作流
4. 点击 "Run workflow" 按钮

### 手动触发构建镜像

1. 进入 GitHub 仓库
2. 点击 "Actions" 标签
3. 选择 "Build iStoreOS Scratch Docker Image and Push to Docker Hub" 工作流
4. 点击 "Run workflow" 按钮

### 使用 Docker 镜像

```bash
docker pull <your-dockerhub-username>/istoreos:latest
```

## 本地测试

### Windows

使用 PowerShell 脚本检查更新：

```powershell
.\Update-IStoreOSImage.ps1
```

### Linux/macOS

使用 Bash 脚本检查更新：

```bash
chmod +x update_istoreos_image.sh
./update_istoreos_image.sh
```

## 配置

### GitHub Secrets

需要在 GitHub 仓库设置中添加以下 Secrets：

- `DOCKER_USERNAME`: Docker Hub 用户名
- `DOCKER_PASSWORD`: Docker Hub 密码或访问令牌
- `WORKFLOW_TOKEN`: GitHub 个人访问令牌，用于创建 Pull Request

## 许可证

MIT