#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Use: $0 <API_URL_ENDPOINT> <DYNAMODB_TABLE_NAME>"
    exit 1
fi

API_URL_ENDPOINT="$1"
DYNAMODB_TABLE_NAME="$2"

curl -sX POST $API_URL_ENDPOINT \
    -H 'Content-Type: application/json' \
    -d '{
        "title": "This Is How You Lose the Time War",
        "author": "Amal El-Mohtar",
        "isbn": "9781534431003"
    }'
echo -e "\n"

curl -sX POST $API_URL_ENDPOINT \
    -H 'Content-Type: application/json' \
    -d '{
        "title": "Chapter house, Dune",
        "author": "Frank Herbert",
        "isbn": "0399130276"
    }'
echo -e "\n"

curl -sX POST $API_URL_ENDPOINT \
    -H 'Content-Type: application/json' \
    -d '{
        "title": "Sadako and the Thousand Paper Cranes",
        "author": "Eleanor Coerr",
        "isbn": "044080177X"
    }'
echo -e "\n"

sleep 10

echo "--------------------------------------------------------"

aws dynamodb scan \
    --table-name "$DYNAMODB_TABLE_NAME" \
    --query 'Items[*]' \
    --endpoint-url http://localhost:4566 \
    --output json | \
jq -r '
    ( "bookId", "title", "author", "first_publish_year" ),
    (.[] | .bookId.S, .title.S, .author.S, .first_publish_year.N)
' | column -t -s $'\t'

echo "--------------------------------------------------------"