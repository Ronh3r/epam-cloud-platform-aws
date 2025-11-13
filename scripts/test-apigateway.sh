#!/bin/bash

# Verifica que se pasen los parámetros obligatorios
if [ $# -ne 1 ]; then
    echo "Use: $0 http://your.api.gateway.url"
    exit 1
fi

API_GATEWAY_URL="$1"

curl -X POST $API_GATEWAY_URL \
-H 'Content-Type: application/json' \
-d '{
    "title": "The Hitchhikers Guide to the Galaxy",
    "author": "Douglas Adams",
    "isbn": "0345391802"
}'
