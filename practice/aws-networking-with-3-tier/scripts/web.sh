#!/bin/bash
# web.sh

# Install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Create a simple HTML page
echo "<h1>Welcome to the Web Tier</h1>" | sudo tee /var/www/html/index.html

# Start Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
