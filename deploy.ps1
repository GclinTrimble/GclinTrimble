# ──────────────────────────────────────────────────────────────────────────────
# deploy.ps1 — one-shot deploy of the blueprint README to GclinTrimble/GclinTrimble
#
# Run this from THIS folder (the one that contains README.md, assets/, .github/).
# Prereqs: git installed and authenticated to GitHub
# Usage:   Open PowerShell here, then: .\deploy.ps1
# ──────────────────────────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$RepoUrl  = "https://github.com/GclinTrimble/GclinTrimble.git"
$CloneDir = "_GclinTrimble"
$SrcDir   = (Get-Location).Path

Write-Host "▸ Source folder: $SrcDir"

# 1. Clone (or pull) the profile repo
if (-not (Test-Path "$CloneDir\.git")) {
    Write-Host "▸ Cloning $RepoUrl into $CloneDir ..."
    git clone $RepoUrl $CloneDir
} else {
    Write-Host "▸ Repo already cloned, pulling latest main ..."
    git -C $CloneDir checkout main
    git -C $CloneDir pull --ff-only origin main
}

# 2. Copy files in
Write-Host "▸ Copying files ..."
New-Item -ItemType Directory -Force -Path "$CloneDir\assets"            | Out-Null
New-Item -ItemType Directory -Force -Path "$CloneDir\.github\workflows" | Out-Null

Copy-Item "$SrcDir\README.md"                       "$CloneDir\README.md"                       -Force
Copy-Item "$SrcDir\assets\blueprint-header.svg"     "$CloneDir\assets\blueprint-header.svg"     -Force
Copy-Item "$SrcDir\.github\workflows\snake.yml"     "$CloneDir\.github\workflows\snake.yml"     -Force
Copy-Item "$SrcDir\.github\workflows\metrics.yml"   "$CloneDir\.github\workflows\metrics.yml"   -Force

# 3. Commit and push
Set-Location $CloneDir
git add README.md assets/blueprint-header.svg .github/workflows/

$diff = git diff --cached --quiet 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "▸ No changes to commit — repo is already up to date."
    exit 0
}

$commitMsg = @"
feat: blueprint-themed README with federated digital twin storytelling

- New blueprint construction theme (navy + cyan + drafting amber)
- Custom blueprint-header.svg with drafting elements, survey points, isometric building
- New section dedicated to the Federated Digital Twin in civil construction & surveying
- Added activity graph, profile summary cards, full metrics SVG, Spotify now-playing
- Added .github/workflows/snake.yml and metrics.yml for self-updating dashboards
- Restructured sections as drafting spec references (§ 01 through § 08)
"@

git commit -m $commitMsg

Write-Host "▸ Pushing to origin/main ..."
git push origin main

Write-Host ""
Write-Host "✓ Done. Visit https://github.com/GclinTrimble to see it live." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps (one-time setup, see SETUP.md):"
Write-Host "  · Actions tab → run 'Generate Snake Animation' once"
Write-Host "  · Settings → Secrets → add METRICS_TOKEN, then run 'Generate Metrics Dashboard'"
Write-Host "  · Authenticate Spotify at https://spotify-github-profile.kittinanx.com/"
