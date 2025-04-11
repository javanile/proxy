#!/usr/bin/env sh

headers=$(mktemp)
body=$(mktemp)

curl -L -s -D "$headers" -o "$body" \
  -X "${REQUEST_METHOD}" \
  "https://${HTTP_HOST}${PATH_INFO}?${QUERY_STRING}"

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo ""
  echo "Error: curl command failed with exit code $exit_code"
  exit $exit_code
fi

header_stop=$(grep -n '^HTTP/' "$headers" | tail -n 1 | cut -d: -f1)

sed -n "$((header_stop+1)),\$p" "$headers"
cat "$body"

rm -f "$headers" "$body" >/dev/null 2>&1
