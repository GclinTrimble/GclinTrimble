#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# deploy.sh — one-shot deploy of the blueprint README to GclinTrimble/GclinTrimble
#
# Run this from THIS folder (the one that contains README.md, assets/, .github/).
# It will:
#   1. clone your profile repo into ./_GclinTrimble (or reuse it if already there)
#   2. copy README.md, assets/blueprint-header.svg, and .github/workflows/* in
#   3. commit and push to origin/main
#
# Prereqs: git installed and authenticated to GitHub (HTTPS or SSH — either works)
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO_URL="https://github.com/GclinTrimble/GclinTrimble.git"
CLONE_DIR="_GclinTrimble"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "▸ Source folder: $SRC_DIR"

# 1. Clone (or pull) the profile repo
if [ ! -d "$CLONE_DIR/.git" ]; then
  echo "▸ Cloning $REPO_URL into $CLONE_DIR ..."
  git clone "$REPO_URL" "$CLONE_DIR"
else
  echo "▸ Repo already cloned, pulling latest main ..."
  git -C "$CLONE_DIR" checkout main
  git -C "$CLONE_DIR" pull --ff-only origin main
fi

# 2. Copy files in (overwriting old README and adding new assets)
echo "▸ Copying files ..."
mkdir -p "$CLONE_DIR/assets"
mkdir -p "$CLONE_DIR/.github/workflows"
cp "$SRC_DIR/README.md"                            "$CLONE_DIR/README.md"
cp "$SRC_DIR/assets/blueprint-header.svg"          "$CLONE_DIR/assets/blueprint-header.svg"
cp "$SRC_DIR/.github/workflows/snake.yml"          "$CLONE_DIR/.github/workflows/snake.yml"
cp "$SRC_DIR/.github/workflows/metrics.yml"        "$CLONE_DIR/.github/workflows/metrics.yml"

# 3. Commit and push
cd "$CLONE_DIR"
git add README.md assets/blueprint-header.svg .github/workflows/
if git diff --cached --quiet; then
  echo "▸ No changes to commit — repo is already up to date."
  exit 0
fi

git commit -m "feat: blueprint-themed README with federated digital twin storytelling

- New blueprint construction theme (navy + cyan + drafting amber)
- Custom blueprint-header.svg with drafting elements, survey points, isometric building
- New section dedicated to the Federated Digital Twin in civil construction & surveying
- Added activity graph, profile summary cards, full metrics SVG, Spotify now-playing
- Added .github/workflows/snake.yml and metrics.yml for self-updating dashboards
- Restructured sections as drafting spec references (§ 01 through § 08)"

echo "▸ Pushing to origin/main ..."
git push origin main

echo ""
echo "✓ Done. Visit https://github.com/GclinTrimble to see it live."
echo ""
echo "Next steps (one-time setup, see SETUP.md):"
echo "  · Actions tab → run 'Generate Snake Animation' once"
echo "  · Settings → Secrets → add METRICS_TOKEN, then run 'Generate Metrics Dashboard'"
echo "  · Authenticate Spotify at https://spotify-github-profile.kittinanx.com/"
