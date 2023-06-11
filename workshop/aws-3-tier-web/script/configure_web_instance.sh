#!/bin/bash

# Install NVM and Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16

# Download web tier code from S3 bucket
cd ~/
aws s3 cp s3://BUCKET_NAME/web-tier/ web-tier --recursive

# Navigate to the web-tier folder and create the build folder for the React app
cd ~/web-tier
npm install 
npm run build

# Install NGINX
sudo amazon-linux-extras install nginx1 -y

# Configure NGINX
cd /etc/nginx
ls
sudo rm nginx.conf
sudo aws s3 cp s3://BUCKET_NAME/nginx.conf .
sudo service nginx restart
chmod -R 755 /home/ec2-user
sudo chkconfig nginx on
