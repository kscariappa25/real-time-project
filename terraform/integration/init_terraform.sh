#!/bin/bash
PROJECT_NAME=$1
STATE_FILE_BUCKET="${STATE_FILE_BUCKET}"
STATE_FILE_DYNAMODB_TABLE="${STATE_FILE_DYNAMODB_TABLE}"
if [ ! "${PROJECT_NAME}" ]; then
    echo "Project Name not provided"
    exit
fi
if [ ! "${STATE_FILE_BUCKET}" ]; then
    echo "Terraform artifacts state file bucket name is not provided."
    exit
fi
if [ ! "${STATE_FILE_DYNAMODB_TABLE}" ]; then
    echo "Terraform artifacts state lock dynamodb table is not provided."
    exit
fi
AWS_REGION=$(aws configure get region)
STATE_FILE_KEY="infra/terraform/${PROJECT_NAME}/state/core.tfstate"
terraform init -backend-config "bucket=${STATE_FILE_BUCKET}" -backend-config "key=${STATE_FILE_KEY}" -backend-config "region=${AWS_REGION}" -backend-config "dynamodb_table=${STATE_FILE_DYNAMODB_TABLE}"
