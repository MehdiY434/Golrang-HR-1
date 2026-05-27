#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: ./recreate-pr.sh <new-branch-name>"
  echo "Example: ./recreate-pr.sh feature/recreate-pr-$(date +%Y%m%d)"
  exit 1
fi

BRANCH="$1"

git rev-parse --is-inside-work-tree >/dev/null

echo "[1/5] Creating branch: $BRANCH"
git checkout -b "$BRANCH"

echo "[2/5] Creating marker file to ensure new diff"
mkdir -p .pr
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "recreate_pr_at=$TS" > .pr/recreate-pr-marker.txt

echo "[3/5] Commiting marker"
git add .pr/recreate-pr-marker.txt
git commit -m "chore: enable recreate PR flow ($TS)"

echo "[4/5] Pushing branch"
git push -u origin "$BRANCH"

echo "[5/5] Done"
echo "Now open GitHub and click: Compare & pull request"
