# Repository Guidelines

## Project Structure & Module Organization
- `codexi`: The main installer script (bash). This is the source of truth and the Release asset.
- `codexi.sh`: Bootstrap script that installs/upgrades `codexi` via `curl`/`wget`.
- `.github/workflows/release.yml`: Tags → GitHub Release, uploads `codexi` asset.
- `.serena/`: Local tool metadata (generally not edited by contributors).
- `LICENSE`: Project license.

This repository is intentionally small. Most changes should be confined to `codexi` plus documentation updates.

## Build, Test, and Development Commands
- `bash codexi.sh`: Downloads the latest Release asset and installs to `~/.local/bin/codexi`.
- `bash -n codexi` / `bash -n codexi.sh`: Fast syntax checks.
- `~/.local/bin/codexi help`: Prints usage and supported environment variables.
- `~/.local/bin/codexi status`: Shows the configured binary path and installed version (if any).
- `~/.local/bin/codexi install|update`: Downloads the latest GitHub Release asset and installs to `~/.local/bin/codex`.
- `~/.local/bin/codexi self update|uninstall|status`: Update/uninstall the `codexi` installer itself.
- `shellcheck codexi.sh` / `shfmt -w codexi.sh`: Lint/format (recommended).

## Coding Style & Naming Conventions
- Bash: keep `set -euo pipefail`, quote variables, and prefer small functions with `local` variables.
- Indentation: 2 spaces; avoid tabs.
- Naming: `cmd_*` for subcommands (e.g. `cmd_status`), verb phrases for helpers (e.g. `download_latest_binary`).

## Testing Guidelines
There is no dedicated automated test suite yet. For each change:
1) run `bash -n codexi` / `bash -n codexi.sh` and `shellcheck codexi`;
2) smoke-test in a disposable Linux environment: `bash codexi.sh && ~/.local/bin/codexi --help`.

## Commit & Pull Request Guidelines
- Git history is currently a single “Initial commit”, so conventions are not established yet.
- Use Conventional Commits going forward (e.g. `fix: handle missing zstd`, `docs: clarify env vars`).
- PRs should include: what changed, how to reproduce/verify, and what distro/arch you tested (e.g. `x86_64 + Debian`).
- Clearly call out anything that performs downloads or changes default install paths. This project does not auto-install system dependencies.

## Security & Configuration Tips
- Network calls go to GitHub Releases. Install dependencies manually if needed (e.g. `zstd` for `.zst` assets).
- Configure via env vars: `CODEXI_REPO`, `CODEXI_TAG`, `CODEXI_INSTALL_DIR`, `CODEXI_BIN_PATH`, `CODEXI_LIBC`, `CODEXI_PLATFORM`.
  Example: `CODEXI_LIBC=musl ~/.local/bin/codexi install`.
