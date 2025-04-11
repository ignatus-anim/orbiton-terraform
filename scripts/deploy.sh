#!/bin/bash

set -e

REGION="eu-west-1"
BUCKET_NAME="orbiton-terraform-state"
DYNAMODB_TABLE="orbiton-terraform-locks"
KEY_NAME="orbiton-keypair"
ENVIRONMENT="dev"

echo "🔐 Creating EC2 Key Pair..."
aws ec2 create-key-pair \
  --region $REGION \
  --key-name $KEY_NAME \
  --query "KeyMaterial" \
  --output text > ${KEY_NAME}.pem

chmod 400 ${KEY_NAME}.pem
echo "✅ Key Pair '${KEY_NAME}' created and saved as ${KEY_NAME}.pem"

echo "📦 Creating S3 Bucket for Remote State..."
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION

aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

echo "✅ S3 Bucket '${BUCKET_NAME}' created and versioning enabled"

echo "📚 Creating DynamoDB table for state locking..."
aws dynamodb create-table \
  --table-name $DYNAMODB_TABLE \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION

echo "✅ DynamoDB Table '${DYNAMODB_TABLE}' created"
