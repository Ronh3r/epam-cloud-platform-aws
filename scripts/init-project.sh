#!/bin/bash

cd ..

source .env

docker compose up -d

terraform init

terraform plan

terraform apply -auto-approve

# sam local start-api 
    # --region us-east-1 \
    # --docker-network host \
    # --host 0.0.0.0 \
    # --skip-pull-image \
    # --hook-name terraform