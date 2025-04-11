#!/usr/bin/env sh

deployment_id=

# /macros/s/{http.request.header.SECRET}/exec?$REMOTE_ADDRESS={remote_host}&$USER_AGENT={http.request.header.User-Agent}&$REQUEST_URI={path}&{query}
headers=$(mktemp)
body=$(mktemp)

url="https://${HTTP_HOST}${PATH_INFO}?${QUERY_STRING}"

# curl -L 'https://script.google.com/macros/s/AKfycby5gk18nlsrcXE4myjqzWmO6HxG_RrRU1iUb12xlJufDgkDt5TdDrKidXqCPCKxhbT70w/exec' -H 'Host: script.google.com' -H 'User-Agent: SOMETHING' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en,en-US;q=0.5' --compressed -H 'Referer: SOMETHING' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data '{"a":1}'

if [ "$REQUEST_METHOD" != "POST" ]; then
  curl -s -L -D "$headers" -o "$body" \
    -X "${REQUEST_METHOD}" \
    "${url}" \
    ${post_data}
else
  curl -s -L -D "$headers" -o "$body" \
    -X "${REQUEST_METHOD}" \
    "${url}" \
    ${post_data}
fi


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
