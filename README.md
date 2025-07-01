# iStoreOS 自动更新与构建工具

这个工具可以自动获取最新的 iStoreOS 镜像文件 (img.gz)，并更新构建配置，以便自动构建最新的 Docker 镜像。

## 功能特点

- 自动获取 iStoreOS 官方网站上最新的 img.gz 文件
- 自动更新 istoreos.yml 配置文件中的下载链接和文件名
- 支持定时执行，确保始终使用最新的镜像文件
- 可选择性地触发 GitHub Actions 工作流来构建 Docker 镜像

## 文件说明

- `update_istoreos_image.sh`: 主脚本，用于获取最新镜像并更新配置
- `crontab_config.txt`: crontab 配置示例，用于设置定时任务
- `istoreos.yml`: GitHub Actions 工作流配置文件（已存在）

## 使用方法

### 1. 准备工作

确保你的 Linux 系统已安装以下工具：

```bash
sudo apt-get update
sudo apt-get install -y curl grep sed
```

### 2. 设置脚本权限

```bash
chmod +x update_istoreos_image.sh
```

### 3. 手动运行脚本

```bash
./update_istoreos_image.sh
```

如果你想在更新后自动触发构建（需要配置 GitHub CLI 或 API 访问权限）：

```bash
./update_istoreos_image.sh --build
```

### 4. 设置定时任务

编辑 crontab：

```bash
crontab -e
```

添加以下内容（根据你的需求选择频率）：

```
# 每天凌晨 2 点执行更新脚本
0 2 * * * cd /path/to/your/istoreos/directory && ./update_istoreos_image.sh >> /var/log/update_istoreos.log 2>&1
```

保存并退出编辑器。

或者，你可以使用提供的 crontab_config.txt 文件：

```bash
crontab crontab_config.txt
```

记得将文件中的路径 `/path/to/your/istoreos/directory` 替换为实际的目录路径。

### 5. 查看日志

```bash
tail -f /var/log/update_istoreos.log
```

## 与 Docker 构建集成

如果你想在本地构建 Docker 镜像，可以在脚本执行后添加 Docker 构建命令：

```bash
# 在 update_istoreos_image.sh 中添加
if [ "$1" == "--docker-build" ]; then
    echo "构建 Docker 镜像..."
    docker build -t your-docker-username/istoreos:latest .
    
    if [ "$2" == "--push" ]; then
        echo "推送 Docker 镜像到 Docker Hub..."
        docker push your-docker-username/istoreos:latest
    fi
fi
```

然后你可以这样运行：

```bash
./update_istoreos_image.sh --docker-build --push
```

## GitHub Actions 自动化

本项目已配置 GitHub Actions 工作流，可以自动检查和构建最新的 iStoreOS 镜像。

### 工作流文件

- `.github/workflows/check_update.yml`: 定时检查最新镜像并触发构建
- `istoreos.yml`: Docker 镜像构建工作流

### 自动化流程

1. 每天凌晨 2 点（UTC 时间，即北京时间 10 点）自动运行检查脚本
2. 检查是否有新版本的 iStoreOS 镜像
3. 如果发现新版本，自动更新 `istoreos.yml` 文件中的下载链接和文件名
4. 提交更改并推送到仓库
5. 触发 Docker 镜像构建工作流

### 手动触发

你也可以在 GitHub 仓库页面手动触发检查和构建：

1. 进入仓库的 "Actions" 标签页
2. 选择 "Check and Build iStoreOS Image" 工作流
3. 点击 "Run workflow" 按钮

### 注意事项

- 确保仓库设置了正确的权限，允许 GitHub Actions 提交更改
- 如果你的仓库是私有的，确保 GitHub Actions 分钟数足够使用

## 自动化工作流建议

1. **服务器自动化**：
   - 设置 crontab 定时任务获取最新镜像
   - 使用 Docker 自动构建并推送到私有仓库

2. **CI/CD 集成**：
   - 将脚本集成到 Jenkins、GitLab CI 或其他 CI/CD 系统
   - 设置触发条件，如定时触发或代码变更触发

3. **监控与通知**：
   - 添加通知功能，当有新镜像可用时发送邮件或消息
   - 监控构建过程，在失败时发送警报

## 注意事项

- 确保你有足够的磁盘空间来下载和处理镜像文件
- 如果你的网络连接不稳定，可能需要在脚本中添加重试逻辑
- 定期检查日志文件，确保脚本正常运行
- 考虑设置日志轮转，防止日志文件过大

## 故障排除

如果脚本无法获取最新的镜像链接，请检查：

1. 网站 URL 是否更改
2. 网页结构是否更改
3. 网络连接是否正常
4. 是否有足够的权限访问和修改文件

如果遇到其他问题，请查看日志文件获取详细信息。