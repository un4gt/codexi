# codexi

Minimal, dependency-light installer for the `codex` Linux binaries published on GitHub Releases.

- Installs `codex` without npm/homebrew (uses `curl` or `wget`)
- Works across common Linux distros by defaulting to the **musl** build (with **gnu** fallback)
- Includes `self` commands to update/uninstall `codexi` itself

> Note: This project is community-maintained and is not an official OpenAI installer.

## Quick Start

Install `codexi`:

```bash
mkdir -p ~/.local/bin
curl -fsSL https://github.com/un4gt/codexi/releases/latest/download/codexi -o ~/.local/bin/codexi
chmod +x ~/.local/bin/codexi
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
- Optional: `zstd` (only needed if a release is available as `.zst` but not `.tar.gz`)

## How Linux Compatibility Works
Some `*-unknown-linux-gnu` binaries require newer glibc than older distributions provide (e.g. Ubuntu 22.04).
In `CODEXI_LIBC=auto` mode, `codexi` prefers **musl** assets first and falls back to **gnu** if needed.

Override if you know what you want:

```bash
CODEXI_LIBC=gnu  codexi install
CODEXI_LIBC=musl codexi install
```

## Configuration

Common environment variables:
- `CODEXI_REPO` (default: `openai/codex`)
- `CODEXI_TAG` (default: latest)
- `CODEXI_BIN_PATH` (default: `~/.local/bin/codex`)
- `CODEXI_LIBC` (`auto|gnu|musl`, default: `auto`)
- `CODEXI_PLATFORM` (override full platform string, e.g. `unknown-linux-gnu`)
- `CODEXI_NO_PROGRESS=1` to disable download progress output

Self-update variables:
- `CODEXI_SELF_REPO` (default: `un4gt/codexi`)
- `CODEXI_SELF_URL` (override download URL)
- `CODEXI_SELF_BIN_PATH` (override installed `codexi` path)

## Troubleshooting
- `GLIBC_2.xx not found`: run `CODEXI_LIBC=musl codexi update` (or upgrade to latest `codexi` and retry).
- `Found a .zst asset but zstd is not installed`: install `zstd` (or choose a `.tar.gz`-available platform).

## Release Process (Maintainers)
Pushing a tag like `v0.1.2` triggers GitHub Actions to create a Release and upload the `codexi` asset.

## License
See `LICENSE`.
