# 仓库贡献指南

## 项目结构
- `codexi`：主脚本（bash，可执行），也是 GitHub Release 上传的资产文件。
- `codexi.sh`：bootstrap 脚本（bash），用于通过 `curl`/`wget` 安装或升级 `codexi`。
- `.github/workflows/release.yml`：推送 tag（`v*`）后自动创建 GitHub Release 并上传 `codexi` 资产。
- `README.md` / `README.zh-CN.md`：用户文档（英文/中文）。

## 常用命令
- 语法检查：`bash -n codexi`、`bash -n codexi.sh`
- 安装 `codex`：`./codexi install`
- 更新 `codexi`：`./codexi self update`

## 编码风格
- Bash：保持 `set -euo pipefail`，变量一律加引号，优先小函数 + `local` 变量。
- 保持脚本对常见 Linux 环境可移植：避免依赖 `sudo`/包管理器；下载统一走 `curl`/`wget`。

## 提交与发布
- 建议使用 Conventional Commits（如 `fix:`、`feat:`、`docs:`）。
- 发布：打 tag（如 `v0.1.3`）并 push，workflow 会创建 Release 并上传 `codexi`。
