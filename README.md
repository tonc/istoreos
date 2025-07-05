# iStoreOS Docker

这个项目提供了一个自动化工具，用于检查和更新 iStoreOS 的最新版本。

## 最新版本

最新的 iStoreOS 镜像 URL: https://fw0.koolcenter.com/iStoreOS/x86_64_efi/istoreos-24.10.2-2025070410-x86-64-squashfs-combined-efi.img.gz
更新日期: 2025070410

## 功能

- 自动检查 iStoreOS 的最新版本
- 当检测到新版本时，自动更新版本信息
- 支持通过 GitHub Actions 自动运行或手动触发

## 文件说明

- `update_istoreos_image.sh`: 检查 iStoreOS 最新版本的脚本
- `.github/workflows/check_update.yml`: GitHub Actions 工作流配置

## 使用方法

### 自动检查更新

工作流程已配置为每天自动运行。无需手动干预，系统会自动检查更新并更新版本信息。

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
- 脚本依赖于 iStoreOS 官方网站的 URL 结构，如果官方网站更改了 URL 结构，可能需要更新脚本
