#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: ./reopen-pr.sh <new-branch-name> [base-branch]"
  echo "Example: ./reopen-pr.sh feature/reopen-pr-$(date +%Y%m%d) main"
  exit 1
fi

NEW_BRANCH="$1"
BASE_BRANCH="${2:-main}"

git rev-parse --is-inside-work-tree >/dev/null

if [[ -n "$(git status --porcelain)" ]]; then
  echo "❌ Working tree is not clean. Please commit or stash your current changes first."
  exit 1
fi

echo "[1/6] Fetch latest from origin"
git fetch origin

echo "[2/6] Checkout base branch: $BASE_BRANCH"
git checkout "$BASE_BRANCH"

echo "[3/6] Pull latest base branch"
git pull --ff-only origin "$BASE_BRANCH"

echo "[4/6] Create new branch: $NEW_BRANCH"
git checkout -b "$NEW_BRANCH"

echo "[5/6] Add guaranteed PR diff marker"
mkdir -p .pr
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat > .pr/reopen-pr-marker.txt <<EOF
reopen_pr_at=$TS
base_branch=$BASE_BRANCH
new_branch=$NEW_BRANCH
EOF

git add .pr/reopen-pr-marker.txt
git commit -m "chore: reopen PR flow marker ($TS)"

echo "[6/6] Push new branch"
git push -u origin "$NEW_BRANCH"

echo "✅ Done. Open GitHub and click: Compare & pull request"
