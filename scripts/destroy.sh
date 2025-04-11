#!/bin/bash

set -e

REGION="eu-west-1"
BUCKET_NAME="orbiton-terraform-state"
DYNAMODB_TABLE="orbiton-terraform-locks"
KEY_NAME="orbiton-keypair"
ENVIRONMENT="dev"

echo "⚠️ Destroying Terraform-managed infrastructure in $ENVIRONMENT..."
cd environments/$ENVIRONMENT

terraform destroy -var-file="terraform.tfvars" -auto-approve
cd -

echo "🧼 Cleaning up AWS resources created manually..."

echo "🗑️ Deleting EC2 key pair '$KEY_NAME'..."
aws ec2 delete-key-pair \
  --key-name $KEY_NAME \
  --region $REGION

rm -f ${KEY_NAME}.pem
echo "✅ Key pair deleted and local file removed"

echo "🗑️ Deleting DynamoDB table '$DYNAMODB_TABLE'..."
aws dynamodb delete-table \
  --table-name $DYNAMODB_TABLE \
  --region $REGION

echo "🗑️ Emptying and deleting S3 bucket '$BUCKET_NAME'..."
# First, empty the bucket
aws s3 rm s3://$BUCKET_NAME --recursive

# Then, delete the bucket
aws s3api delete-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION

echo "✅ Clean up complete 🎉"
