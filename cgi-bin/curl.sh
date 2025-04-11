#!/usr/bin/env sh

headers=$(mktemp)
body=$(mktemp)
url="https://${HTTP_HOST}:${HTTP_PORT}${PATH_INFO}?${QUERY_STRING}"

if [ "$REQUEST_METHOD" = "POST" ]; then
  post_data="-d @-"
fi

curl -s -L -D "$headers" -o "$body" \
  -X "${REQUEST_METHOD}" \
  "${url}" \
  ${post_data}

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo ""
  echo "Error: curl command failed with exit code $exit_code"
  exit $exit_code
fi

header_stop=$(grep -n '^HTTP/' "$headers" | tail -n 1 | cut -d: -f1)

echo ""
echo "URL:"
echo "$url"
echo "HEADERS:"
cat "$headers"
echo "BODY:"
cat "$body"

sed -n "$((header_stop+1)),\$p" "$headers"
cat "$body"

rm -f "$headers" "$body" >/dev/null 2>&1
