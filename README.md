# codexi

Minimal, dependency-light installer for `codex` binaries published on GitHub Releases (Linux by default; Termux via third-party builds).

- Installs `codex` without npm/homebrew (uses `curl` or `wget`)
- Installs `codex-code-mode-host` beside `codex` when the release provides it
- Works across common Linux distros by defaulting to the **musl** build (with **gnu** fallback)
- On Termux (Android ARM64), auto-detects and installs from `DioNanos/codex-termux` Releases
- Includes `self` commands to update/uninstall `codexi` itself

> Note: This project is community-maintained and is not an official OpenAI installer.

## Quick Start

Install `codexi`:

```bash
mkdir -p ~/.local/bin
curl -fsSL https://github.com/un4gt/codexi/releases/latest/download/codexi -o ~/.local/bin/codexi
chmod +x ~/.local/bin/codexi
```

If `codexi: command not found`, your shell `PATH` may not include `~/.local/bin` (common for `root`). You can:

```bash
# run directly
~/.local/bin/codexi --help

# or add to PATH (bash)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc

# or install to a system-wide location
sudo install -m 0755 ~/.local/bin/codexi /usr/local/bin/codexi
```

On Termux, prefer installing to `$PREFIX/bin` (already on `PATH`):

```bash
curl -fsSL https://github.com/un4gt/codexi/releases/latest/download/codexi -o "$PREFIX/bin/codexi"
chmod +x "$PREFIX/bin/codexi"
```

Tip: ensure you're running the expected binary:

```bash
command -v codexi
codexi --version
```

Install `codex`:

```bash
codexi install
codex --version
```

Update `codex`:

```bash
codexi update
```

Uninstall `codex`:

```bash
codexi uninstall
```

Update `codexi` itself:

```bash
codexi self update
```

## Requirements
- Linux
- `bash`, `tar`
- `curl` or `wget`
- Recommended: `bubblewrap` / `bwrap` for Codex sandboxing (`codexi install|update` can prompt to install it)
- Optional: `zstd` (only needed if a release is available as `.zst` but not `.tar.gz`)
- Termux support (Android ARM64): uses GitHub API to resolve the `.tgz` asset name; optionally set `CODEXI_GITHUB_TOKEN` (or `GITHUB_TOKEN`) to avoid API rate limits
  - Requires 64-bit Android userspace (`/system/bin/linker64`). Some devices report `uname -m=armv8l` even on 64-bit userspace; if `linker64` is missing, you're on a 32-bit Android build and Termux codex binaries won't run.

## How Linux Compatibility Works
Some `*-unknown-linux-gnu` binaries require newer glibc than older distributions provide (e.g. Ubuntu 22.04).
In `CODEXI_LIBC=auto` mode, `codexi` prefers **musl** assets first and falls back to **gnu** if needed.

For current official releases, `codexi` installs both `codex` and `codex-code-mode-host` directly in the configured binary directory. Older releases without a code-mode host asset continue to install only `codex`.

Override if you know what you want:

```bash
CODEXI_LIBC=gnu  codexi install
CODEXI_LIBC=musl codexi install
```

## Configuration

Common environment variables:
- `CODEXI_REPO` (default: `openai/codex`)
- `CODEXI_TAG` (default: latest)
- `CODEXI_INSTALL_DIR` (default: `~/.local/bin` | Termux: `$PREFIX/bin`)
- `CODEXI_BIN_PATH` (default: `<install_dir>/codex`)
- `CODEXI_LIBC` (`auto|gnu|musl`, default: `auto`)
- `CODEXI_PLATFORM` (override full platform string, e.g. `unknown-linux-gnu`)
- `CODEXI_BUBBLEWRAP` (`prompt|install|skip`, default: `prompt`)
- `CODEXI_NO_PROGRESS=1` to disable download progress output
- `CODEXI_YES=1` to auto-confirm interactive prompts (e.g. `codexi update`)

Termux variables (auto-detect):
- `CODEXI_TERMUX_REPO` (default: `DioNanos/codex-termux`)
- `CODEXI_TERMUX_CHANNEL` (default: `termux`, supported: `termux|lts`)
- `CODEXI_EXEC_BIN_PATH` (default: `<install_dir>/codex-exec`)
- `CODEXI_GITHUB_TOKEN` (optional) or `GITHUB_TOKEN` to avoid API rate limits

Self-update variables:
- `CODEXI_SELF_REPO` (default: `un4gt/codexi`)
- `CODEXI_SELF_URL` (override download URL)
- `CODEXI_SELF_BIN_PATH` (override installed `codexi` path)

## Troubleshooting
- `GLIBC_2.xx not found`: run `CODEXI_LIBC=musl codexi update` (or upgrade to latest `codexi` and retry).
- `failed to spawn code-mode host`: upgrade `codexi`, then run `codexi update`; the missing host will be installed beside `codex`.
- `Found a .zst asset but zstd is not installed`: install `zstd` (or choose a `.tar.gz`-available platform).
- `Unsupported Termux architecture: armv8l`: your Android build is likely 32-bit (no `/system/bin/linker64`). `DioNanos/codex-termux` provides ARM64 binaries only.
- `No suitable Termux asset found`: GitHub API response didn't contain the expected `.tgz` asset. Try setting `CODEXI_GITHUB_TOKEN` (or `GITHUB_TOKEN`), pin a version with `CODEXI_TAG=vX.Y.Z-termux`, or check `DioNanos/codex-termux` Releases for changes.
- `codexi --version` shows an older version: you're likely running a different `codexi` on `PATH`. Check `command -v codexi` (and `type -a codexi`) and remove the old one.

## Release Process (Maintainers)
Pushing a tag like `v0.1.2` triggers GitHub Actions to create a Release and upload the `codexi` asset.

## License
See `LICENSE`.
