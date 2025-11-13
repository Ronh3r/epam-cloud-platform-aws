#!/bin/bash

set -e

cd ..

echo "Destroying all resources"
terraform destroy -auto-approve

echo "Turn off localstack"
docker compose down

echo "Deleting files and directories"
rm -rf .terraform .aws-sam-iacs 
rm -f .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup 

echo "Remove AWS_*** envvar"
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
