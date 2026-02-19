#!/bin/bash
# One-command dev environment setup.
#
# Configures the smudge/clean filter and pre-push hook so that:
# - Working tree has local file:// URLs (for testing)
# - Committed content has remote GitHub URLs (for distribution)
#
# Usage:
#   bash setup.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Configuring local-url smudge/clean filter..."
git -C "$REPO_DIR" config filter.local-url.clean 'scripts/url-filter.sh clean'
git -C "$REPO_DIR" config filter.local-url.smudge 'scripts/url-filter.sh smudge'

echo "Configuring pre-push hook..."
git -C "$REPO_DIR" config core.hooksPath .githooks

echo "Re-checking out filtered files..."
cd "$REPO_DIR"
git checkout -- install.tbxc README.md 2>/dev/null

echo "Done! Dev environment is ready."
