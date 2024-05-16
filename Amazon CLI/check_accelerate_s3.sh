#!/bin/bash

# Specify the AWS region
AWS_REGION="sa-east-1"

# List all S3 buckets
buckets=$(aws s3api list-buckets --output json | jq -r '.Buckets[].Name')

# Loop through each bucket and check Transfer Acceleration status
for bucket in $buckets
do
   # Get the bucket's location
   location=$(aws s3api get-bucket-location --bucket $bucket --query "LocationConstraint" --output text)

   # Check if the bucket's location matches the specified region
   if [ "$location" == "$AWS_REGION" ]; then
        if [[ "$bucket" == *"pub"* ]]; then
            status=$(aws s3api get-bucket-accelerate-configuration --bucket $bucket --query "Status" --output text)

            if [ "$status" == "Enabled" ]; then
                echo "0: Bucket '$bucket' ENABLED."
            elif [ "$status" == "Suspended" ]; then
                echo "1: Bucket '$bucket' Transfer Acceleration DISABLED."
            else
                echo "2: Bucket '$bucket' in region '$AWS_REGION' has an unknown Transfer Acceleration status: $status"
            fi
        fi
   fi
done
