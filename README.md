# iStoreOS Docker

这个项目提供了一个自动化工具，用于检查和更新 iStoreOS 的最新版本。

## 功能

- 自动检查 iStoreOS 的最新版本
- 当检测到新版本时，创建 Pull Request 以更新版本信息
- 支持通过 GitHub Actions 自动运行或手动触发

## 工作流程

1. GitHub Actions 工作流每天自动运行（或手动触发）
2. 脚本检查 iStoreOS 的最新版本
3. 如果检测到新版本，创建 Pull Request
4. 合并 Pull Request 后，自动删除临时分支

## 文件说明

- `update_istoreos_image.sh`: 检查 iStoreOS 最新版本的脚本
- `.github/workflows/check_update.yml`: GitHub Actions 工作流配置

## 使用方法

### 自动检查更新

工作流程已配置为每天自动运行。无需手动干预，系统会自动检查更新并创建 Pull Request。

### 手动触发检查

1. 在 GitHub 仓库页面，点击 "Actions" 标签
2. 选择 "Check iStoreOS Update" 工作流
3. 点击 "Run workflow" 按钮
4. 选择 "main" 分支
5. 点击 "Run workflow" 按钮确认

### 本地运行脚本

如果需要在本地运行脚本，可以使用以下命令：

```bash
chmod +x update_istoreos_image.sh
./update_istoreos_image.sh
```

## 注意事项

- 工作流仅在 main 分支上运行
- 需要确保 GitHub Actions 有足够的权限创建 Pull Request
- 脚本依赖于 iStoreOS 官方网站的 URL 结构，如果官方网站更改了 URL 结构，可能需要更新脚本