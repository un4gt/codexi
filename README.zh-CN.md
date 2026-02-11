# codexi

`codexi` 是一个极简、低依赖的安装器，用于从 GitHub Releases 下载并安装 `codex` 二进制文件（默认 Linux；Termux 通过第三方构建支持）。

- 不依赖 npm/homebrew（使用 `curl` 或 `wget`）
- 默认优先选择 **musl** 构建（并在需要时回退到 **gnu**），提升跨发行版兼容性
- 在 Termux（Android ARM64）上会自动检测并从 `DioNanos/codex-termux` 的 Releases 安装
- 提供 `self` 子命令用于更新/卸载 `codexi` 本身

> 说明：本项目为社区维护，并非 OpenAI 官方安装方式。

## 快速开始

安装 `codexi`：

```bash
mkdir -p ~/.local/bin
curl -fsSL https://github.com/un4gt/codexi/releases/latest/download/codexi -o ~/.local/bin/codexi
chmod +x ~/.local/bin/codexi
```

在 Termux 上，建议直接安装到 `$PREFIX/bin`（默认在 `PATH` 中）：

```bash
curl -fsSL https://github.com/un4gt/codexi/releases/latest/download/codexi -o "$PREFIX/bin/codexi"
chmod +x "$PREFIX/bin/codexi"
```

提示：确认你正在运行的是预期的二进制：

```bash
command -v codexi
codexi --version
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
- Termux 支持（Android ARM64）：会通过 GitHub API 解析 `.tgz` 资产名；可选设置 `CODEXI_GITHUB_TOKEN`（或 `GITHUB_TOKEN`）以避免 API 限流
  - 需要 64 位 Android 用户态（存在 `/system/bin/linker64`）。部分设备即使是 64 位用户态也可能显示 `uname -m=armv8l`；若系统缺少 `linker64`，通常意味着系统为 32 位，Termux 的 codex 二进制无法运行。

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
- `CODEXI_INSTALL_DIR`（默认：`~/.local/bin` | Termux：`$PREFIX/bin`）
- `CODEXI_BIN_PATH`（默认：`<install_dir>/codex`）
- `CODEXI_LIBC`（`auto|gnu|musl`，默认：`auto`）
- `CODEXI_PLATFORM`（覆盖完整平台字符串，例如 `unknown-linux-gnu`）
- `CODEXI_NO_PROGRESS=1`：关闭下载进度输出

Termux（自动检测）相关变量：
- `CODEXI_TERMUX_REPO`（默认：`DioNanos/codex-termux`）
- `CODEXI_TERMUX_CHANNEL`（默认：`termux`，可选：`termux|lts`）
- `CODEXI_EXEC_BIN_PATH`（默认：`<install_dir>/codex-exec`）
- `CODEXI_GITHUB_TOKEN`（可选）或 `GITHUB_TOKEN`：避免 GitHub API 限流

自更新相关变量：
- `CODEXI_SELF_REPO`（默认：`un4gt/codexi`）
- `CODEXI_SELF_URL`（覆盖下载 URL）
- `CODEXI_SELF_BIN_PATH`（覆盖 `codexi` 安装路径）

## 常见问题
- 提示 `GLIBC_2.xx not found`：执行 `CODEXI_LIBC=musl codexi update`（或先更新到最新版 `codexi` 再重试）。
- 提示 `Found a .zst asset but zstd is not installed`：安装 `zstd`（或选择存在 `.tar.gz` 的平台）。
- Termux 提示 `Unsupported Termux architecture: armv8l`：你的 Android 可能是 32 位构建（没有 `/system/bin/linker64`），而 `DioNanos/codex-termux` 仅提供 ARM64 二进制。
- Termux 提示 `No suitable Termux asset found`：GitHub API 返回中没有匹配到预期的 `.tgz` 资产。可以尝试设置 `CODEXI_GITHUB_TOKEN`（或 `GITHUB_TOKEN`）、用 `CODEXI_TAG=vX.Y.Z-termux` 固定版本，或检查 `DioNanos/codex-termux` 的 Releases 是否调整了资产命名/结构。
- `codexi --version` 仍显示旧版本：通常是 `PATH` 上命中了另一个 `codexi`。用 `command -v codexi`（以及 `type -a codexi`）确认路径，并删除旧的那个。

## 发布说明（维护者）
推送类似 `v0.1.2` 的 tag 会触发 GitHub Actions 自动创建 Release 并上传 `codexi` 资产。

## License
详见 `LICENSE`。
