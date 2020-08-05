#!/usr/bin/env bash

# This code works. At the time of writing this we had issues with the limit on VPCs beign able to be created in the Beach AWS account.
# I'll leave the code in here as a POC

# S3_NAME="pulumi-bucket-${AZURE_PREFIX}"

# Create S3 bucket for self managed backend state
# aws s3api create-bucket --bucket $S3_NAME --region us-east-1

# Create new directory to hold resource files
# cd cluster
# mkdir pulumi-k8s-aws && cd pulumi-k8s-aws

# Login to Pulumi S3
# pulumi login s3://$S3_NAME

# Create new Pulumi project
# pulumi new aws-typescript

# Copy over k8s files
# cp -r /code/cluster/aws-pulumi/. /code/cluster/pulumi-k8s-aws

# install dependencies
# npm i

# provision resources
# pulumi up