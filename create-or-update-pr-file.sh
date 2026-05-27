#!/usr/bin/env bash
set -euo pipefail

PR_FILE="${1:-PR_MESSAGE.md}"
TITLE="${2:-chore: update pull request details}"
SCOPE="${3:-عمومی}"

DATE_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cat > "$PR_FILE" <<EOF
# ${TITLE}

## Motivation
- به‌روزرسانی توضیحات PR برای تغییرات جدید.
- شفاف‌سازی هدف و دامنه تغییرات (${SCOPE}).

## Description
- خلاصه تغییرات انجام‌شده را اینجا بنویسید.
- فایل‌های اصلی درگیر را اینجا لیست کنید.
- اثرات فنی/عملیاتی را اینجا توضیح دهید.

## Testing
- [ ] تست دستی انجام شد
- [ ] تست خودکار انجام شد
- [ ] نیاز به تست بیشتر

## Metadata
- Updated At (UTC): ${DATE_UTC}
- Scope: ${SCOPE}
EOF

echo "✅ PR file created/updated: ${PR_FILE}"
