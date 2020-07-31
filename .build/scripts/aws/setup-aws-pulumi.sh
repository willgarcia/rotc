#!/usr/bin/env bash

aws s3 rb s3://pulumi-bucket-unique

aws s3api create-bucket --bucket pulumi-bucket-unique --region us-east-1

pulumi login s3://pulumi-bucket-unique

cd cluster

rm -rf hello-world-pulumi
mkdir hello-world-pulumi && cd hello-world-pulumi

pulumi new aws-typescript

pulumi up