#!/usr/bin/env bash
set -euo pipefail

# codexi.sh - bootstrap installer for codexi itself (Linux)
# Prefer using GitHub Releases asset: https://github.com/un4gt/codexi/releases/latest/download/codexi

PROG="codexi.sh"
log() { printf '%s: %s\n' "$PROG" "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

[[ "$(uname -s 2>/dev/null || true)" == "Linux" ]] || die "This installer supports Linux only"

INSTALL_DIR="${CODEXI_INSTALL_DIR:-$HOME/.local/bin}"
DEST="${CODEXI_SELF_BIN_PATH:-$INSTALL_DIR/codexi}"
REPO="${CODEXI_SELF_REPO:-un4gt/codexi}"
ASSET="${CODEXI_SELF_ASSET:-codexi}"
URL="${CODEXI_SELF_URL:-https://github.com/${REPO}/releases/latest/download/${ASSET}}"

mkdir -p "$(dirname "$DEST")"

tmp="${DEST}.tmp.$$.$RANDOM"
rm -f "$tmp"

if have curl; then
  if [[ "${CODEXI_NO_PROGRESS:-0}" == "1" ]]; then
    curl -fsSL --retry 3 --connect-timeout 10 --max-time 600 -o "$tmp" "$URL" || die "Download failed: $URL"
  else
    curl --fail --location --show-error --progress-bar --retry 3 --connect-timeout 10 --max-time 600 -o "$tmp" "$URL" || die "Download failed: $URL"
  fi
elif have wget; then
  if [[ "${CODEXI_NO_PROGRESS:-0}" == "1" ]]; then
    wget -q -O "$tmp" -t 3 -T 10 "$URL" || die "Download failed: $URL"
  else
    wget -O "$tmp" -t 3 -T 10 "$URL" || die "Download failed: $URL"
  fi
else
  die "curl or wget is required for downloads"
fi

[[ -s "$tmp" ]] || die "Downloaded file is empty: $URL"
chmod 0755 "$tmp"
mv -f "$tmp" "$DEST"

log "Installed: $DEST"
log "Next: $DEST --help"
