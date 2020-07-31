#!/usr/bin/env bash

aws s3 rb s3://pulumi-bucket-unique --force

aws s3api create-bucket --bucket pulumi-bucket-unique --region us-east-1

pulumi login s3://pulumi-bucket-unique

cd cluster

rm -rf pulumi-k8s
mkdir pulumi-k8s && cd pulumi-k8s

pulumi new aws-typescript

cp -r /code/cluster/aws-pulumi/. /code/cluster/pulumi-k8s

npm i

pulumi up