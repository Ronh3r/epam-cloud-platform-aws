#!/bin/bash

set -e

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

cd ..

echo "Destroying all resources"
terraform destroy -auto-approve

echo "Turn off localstack"
docker compose down

echo "Deleting files and directories"
rm -rf .terraform localstack .aws-sam-iacs 
rm -f .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup 

echo "Remove AWS_*** envvar"
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
