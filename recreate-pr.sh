#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: ./recreate-pr.sh <new-branch-name> [base-branch]"
  echo "Example: ./recreate-pr.sh feature/recreate-pr-$(date +%Y%m%d) main"
  exit 1
fi

NEW_BRANCH="$1"
BASE_BRANCH="${2:-$(git rev-parse --abbrev-ref HEAD)}"

git rev-parse --is-inside-work-tree >/dev/null

echo "[1/7] Fetching remote"
git fetch origin

echo "[2/7] Checkout base branch: $BASE_BRANCH"
git checkout "$BASE_BRANCH"

echo "[3/7] Sync with origin/$BASE_BRANCH"
git pull --ff-only origin "$BASE_BRANCH"

echo "[4/7] Create new branch: $NEW_BRANCH"
git checkout -b "$NEW_BRANCH"

echo "[5/7] Create marker diff"
mkdir -p .pr
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "recreate_pr_at=$TS" > .pr/recreate-pr-marker.txt

echo "[6/7] Commit marker"
git add .pr/recreate-pr-marker.txt
git commit -m "chore: enable recreate PR flow ($TS)"

echo "[7/7] Push branch"
git push -u origin "$NEW_BRANCH"

echo "Done ✅"
echo "Open GitHub: Compare & pull request"
