#!/usr/bin/env bash
sudo yum update -y
sudo yum install -y ruby wget

wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install -O /tmp/codedeploy-install
chmod +x /tmp/codedeploy-install

sudo /tmp/codedeploy-install auto

