# codexi

`codexi` 是一个极简、低依赖的 Linux 安装器，用于从 GitHub Releases 下载并安装 `codex` 二进制文件。

- 不依赖 npm/homebrew（使用 `curl` 或 `wget`）
- 默认优先选择 **musl** 构建（并在需要时回退到 **gnu**），提升跨发行版兼容性
- 提供 `self` 子命令用于更新/卸载 `codexi` 本身

> 说明：本项目为社区维护，并非 OpenAI 官方安装方式。

## 快速开始

安装 `codexi`：

```bash
mkdir -p ~/.local/bin
curl -fsSL https://github.com/un4gt/codexi/releases/latest/download/codexi -o ~/.local/bin/codexi
chmod +x ~/.local/bin/codexi
```

安装 `codex`：

```bash
codexi install
codex --version
```

更新 `codex`：

```bash
codexi update
```

卸载 `codex`：

```bash
codexi uninstall
```

更新 `codexi` 本身：

```bash
codexi self update
```

## 依赖与前置条件
- Linux
- `bash`、`tar`
- `curl` 或 `wget`
- 可选：`zstd`（仅当目标 release 只有 `.zst` 而没有 `.tar.gz` 时需要）

## Linux 兼容性说明（glibc / musl）
部分 `*-unknown-linux-gnu` 版本的二进制可能依赖更高版本的 glibc（例如 Ubuntu 22.04 会遇到 `GLIBC_2.38/2.39 not found`）。
在 `CODEXI_LIBC=auto` 模式下，`codexi` 会**优先尝试 musl 资产**，找不到时再回退到 gnu。

如果你想手动指定：

```bash
CODEXI_LIBC=gnu  codexi install
CODEXI_LIBC=musl codexi install
```

## 配置

常用环境变量：
- `CODEXI_REPO`（默认：`openai/codex`）
- `CODEXI_TAG`（默认：latest）
- `CODEXI_BIN_PATH`（默认：`~/.local/bin/codex`）
- `CODEXI_LIBC`（`auto|gnu|musl`，默认：`auto`）
- `CODEXI_PLATFORM`（覆盖完整平台字符串，例如 `unknown-linux-gnu`）
- `CODEXI_NO_PROGRESS=1`：关闭下载进度输出

自更新相关变量：
- `CODEXI_SELF_REPO`（默认：`un4gt/codexi`）
- `CODEXI_SELF_URL`（覆盖下载 URL）
- `CODEXI_SELF_BIN_PATH`（覆盖 `codexi` 安装路径）

## 常见问题
- 提示 `GLIBC_2.xx not found`：执行 `CODEXI_LIBC=musl codexi update`（或先更新到最新版 `codexi` 再重试）。
- 提示 `Found a .zst asset but zstd is not installed`：安装 `zstd`（或选择存在 `.tar.gz` 的平台）。

## 发布说明（维护者）
推送类似 `v0.1.2` 的 tag 会触发 GitHub Actions 自动创建 Release 并上传 `codexi` 资产。

## License
详见 `LICENSE`。
