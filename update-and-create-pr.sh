#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: ./update-and-create-pr.sh <new-branch-name> [base-branch] [commit-message]"
  echo "Example: ./update-and-create-pr.sh feature/hr-ui-refresh main \"feat: update HR dashboard\""
  exit 1
fi

NEW_BRANCH="$1"
BASE_BRANCH="${2:-main}"
COMMIT_MSG="${3:-chore: update code and enable new PR}"

git rev-parse --is-inside-work-tree >/dev/null

if [[ -n "$(git status --porcelain)" ]]; then
  echo "❌ Working tree is not clean. Please commit/stash your changes first."
  exit 1
fi

echo "[1/8] Fetching remote"
git fetch origin

echo "[2/8] Checkout base branch: $BASE_BRANCH"
git checkout "$BASE_BRANCH"

echo "[3/8] Sync with origin/$BASE_BRANCH"
git pull --ff-only origin "$BASE_BRANCH"

echo "[4/8] Create new branch: $NEW_BRANCH"
git checkout -b "$NEW_BRANCH"

echo "[5/8] Create update marker (guaranteed diff)"
mkdir -p .pr
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat > .pr/update-pr-marker.txt <<EOF
updated_at=$TS
branch=$NEW_BRANCH
base=$BASE_BRANCH
EOF

echo "[6/8] Stage changes"
git add .pr/update-pr-marker.txt

echo "[7/8] Commit changes"
git commit -m "$COMMIT_MSG"

echo "[8/8] Push branch"
git push -u origin "$NEW_BRANCH"

echo "Done ✅"
echo "Now open GitHub and click: Compare & pull request"
