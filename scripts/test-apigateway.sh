#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Use: $0 <API_URL_ENDPOINT> <DYNAMODB_TABLE_NAME>"
    exit 1
fi

API_GATEWAY_URL="$1"
DYNAMODB_TABLE_NAME="$2"

curl -X POST $API_GATEWAY_URL \
-H 'Content-Type: application/json' \
-d '{
    "title": "The Hitchhikers Guide to the Galaxy",
    "author": "Douglas Adams",
    "isbn": "0345391802"
}'

sleep 10

ITEMS_NUMER=$(
    aws dynamodb describe-table \
        --table-name $DYNAMODB_TABLE_NAME \
        --query 'Table.ItemCount' \
        --endpoint http://localhost:4566
)

echo -e "\nNumber of items in $DYNAMODB_TABLE_NAME: $ITEMS_NUMER"
