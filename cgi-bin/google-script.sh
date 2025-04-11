#!/usr/bin/env sh

debug=
headers=$(mktemp)
body=$(mktemp)
remote_host=$(echo "$REMOTE_ADDR" | cut -d: -f1)
user_agent=$(echo "$HTTP_USER_AGENT" | cut -d' ' -f1)
deployment_id=${HTTP_SECRET}
query=$QUERY_STRING
path=$PATH_INFO
url="https://script.google.com/macros/s/${deployment_id}/exec?\$REMOTE_ADDRESS=${remote_host}&\$USER_AGENT=${user_agent}&\$REQUEST_URI=${path}&${query}"

if [ "$REQUEST_METHOD" != "POST" ]; then
  curl -s -L -D "$headers" -o "$body" -X GET "${url}"
else
  curl -L "${url}" --data @- --compressed -D "$headers" -o "$body" \
    -H 'Host: script.google.com' \
    -H 'User-Agent: SOMETHING' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en,en-US;q=0.5' \
    -H 'Referer: SOMETHING' \
    -H 'DNT: 1' \
    -H 'Connection: keep-alive' \
    -H 'Upgrade-Insecure-Requests: 1'
fi

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo ""
  echo "Error: curl command failed with exit code $exit_code"
  exit $exit_code
fi

if [ -z "$debug" ]; then
  if [ "$REQUEST_METHOD" != "POST" ]; then
    header_stop=$(grep -n '^HTTP/' "$headers" | tail -n 1 | cut -d: -f1)
    sed -n "$((header_stop+1)),\$p" "$headers"
    cat "$body"
  else
    echo "Content-Type: application/json"
    echo ""
    cat "$body"
  fi
else
  echo ""
  echo "URL:"
  echo "$url"
  echo "ENV:"
  printenv
  echo "HEADERS:"
  echo "STOP: $header_stop"
  cat "$headers"
  echo "BODY:"
  cat "$body"
fi

rm -f "$headers" "$body" >/dev/null 2>&1
