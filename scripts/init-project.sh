#!/bin/bash

cd ..

source .env

FILE="docker-compose.yaml"
if [ -f "$FILE" ]; then
  docker compose up -d
else
  echo "The docker compose file doesn't exist."
  exit 1
fi

terraform init

terraform plan

terraform apply -auto-approve
