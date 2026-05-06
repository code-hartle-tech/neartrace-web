#!/usr/bin/env bash
# NearTrace Enrollment Kit — bootstrap installer
# Usage: curl -fsSL https://neartrace.app/install.sh | bash
set -euo pipefail

REPO="code-hartle-tech/neartrace-enroll"
BINARY="enroll"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'
RST='\033[0m'

info()  { printf "${CYN}[neartrace]${RST} %s\n" "$*"; }
ok()    { printf "${GRN}[neartrace]${RST} %s\n" "$*"; }
die()   { printf "${RED}[neartrace] ERROR:${RST} %s\n" "$*" >&2; exit 1; }

# ── OS / arch detection ────────────────────────────────────────────────────────
OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
  Darwin)  OS_KEY="darwin" ;;
  Linux)   OS_KEY="linux"  ;;
  *)       die "Unsupported OS: $OS (Windows users: download the .zip from https://github.com/$REPO/releases/latest)" ;;
esac

case "$ARCH" in
  x86_64|amd64)          ARCH_KEY="amd64" ;;
  arm64|aarch64|armv8*)  ARCH_KEY="arm64" ;;
  *)                     die "Unsupported architecture: $ARCH" ;;
esac

info "Platform: ${OS_KEY}/${ARCH_KEY}"

# ── Latest release ─────────────────────────────────────────────────────────────
info "Fetching latest release from github.com/$REPO..."

VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep '"tag_name"' \
  | sed 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/')

if [ -z "$VERSION" ]; then
  die "Could not determine latest release version"
fi

info "Latest version: v${VERSION}"

# ── Download ───────────────────────────────────────────────────────────────────
ARCHIVE="neartrace-enroll_${VERSION}_${OS_KEY}_${ARCH_KEY}.tar.gz"
URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ARCHIVE}"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

info "Downloading ${ARCHIVE}..."
curl -fsSL "$URL" -o "${TMPDIR}/${ARCHIVE}" || die "Download failed: $URL"

# ── Extract + install ──────────────────────────────────────────────────────────
tar -xzf "${TMPDIR}/${ARCHIVE}" -C "$TMPDIR"

EXTRACTED_BINARY=$(find "$TMPDIR" -name "$BINARY" -type f | head -1)
if [ -z "$EXTRACTED_BINARY" ]; then
  die "Binary '${BINARY}' not found in archive"
fi

chmod +x "$EXTRACTED_BINARY"

if [ -w "$INSTALL_DIR" ]; then
  mv "$EXTRACTED_BINARY" "${INSTALL_DIR}/${BINARY}"
else
  info "Installing to ${INSTALL_DIR} (requires sudo)..."
  sudo mv "$EXTRACTED_BINARY" "${INSTALL_DIR}/${BINARY}"
fi

# ── Verify ────────────────────────────────────────────────────────────────────
INSTALLED_VERSION=$("${INSTALL_DIR}/${BINARY}" version 2>/dev/null || echo "unknown")
ok "Installed: ${INSTALL_DIR}/${BINARY} (${INSTALLED_VERSION})"
ok ""
ok "Run 'enroll --help' to get started."
