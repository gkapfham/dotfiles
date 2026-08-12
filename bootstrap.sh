#!/usr/bin/env bash
# bootstrap.sh — One-time setup for a new machine.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/gkapfham/configure-dotfiles/main/bootstrap.sh)
#
# Or if you've already cloned the repo:
#   cd ~/configure/dotfiles && ./bootstrap.sh

set -euo pipefail

DOTFILES="$HOME/configure/dotfiles"
REPO_URL="git@github.com:gkapfham/dotfiles.git"

echo " Pi bootstrap — setting up this machine for Pi coding agent"
echo ""

# ── Step 1: Clone dotfiles if not already present ────────────────────
if [[ ! -d "$DOTFILES/.git" ]]; then
  echo " Cloning dotfiles..."
  mkdir -p "$(dirname "$DOTFILES")"
  git clone "$REPO_URL" "$DOTFILES"
else
  echo " Dotfiles already cloned — pulling latest..."
  git -C "$DOTFILES" pull --ff-only
fi

# ── Step 2: Stow everything into place ──────────────────────────────
echo ""
echo " Stowing dotfiles..."
cd "$DOTFILES"
make dotfiles

# ── Step 3: Clone or pull every project repo ─────────────────────────
echo ""
echo " Syncing project repos..."
sync-repos

# ── Step 4: Pull external Zsh plugin submodules ──────────────────────
echo ""
echo " Updating Zsh plugin submodules..."
git submodule update --init --recursive 2>/dev/null || true
# Stow them into place
make stow-external 2>/dev/null || true

echo ""
echo " Done! This machine is ready for Pi."
echo "    Start Pi:  cd ~/configure/dotfiles && pi"
echo "     Tau web:  http://localhost:3001"
