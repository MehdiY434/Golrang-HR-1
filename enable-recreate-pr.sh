#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: ./enable-recreate-pr.sh <new-branch-name> [base-branch]"
  echo "Example: ./enable-recreate-pr.sh feature/recreate-pr-$(date +%Y%m%d) main"
  exit 1
fi

NEW_BRANCH="$1"
BASE_BRANCH="${2:-main}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running PR recreation flow..."
"$SCRIPT_DIR/reopen-pr.sh" "$NEW_BRANCH" "$BASE_BRANCH"
