#!/bin/bash

# install focalboard
wget https://github.com/mattermost/focalboard/releases/download/v7.10.4/focalboard-server-linux-amd64.tar.gz
tar -xvzf focalboard-server-linux-amd64.tar.gz
sudo mv focalboard /opt

# install NGINX
sudo apt update -y
sudo apt install -y nginx

# Configure NGINX
# sudo nano /etc/nginx/sites-available/focalboard
cat << EOF > /etc/nginx/sites-available/focalboard
upstream focalboard {
     server localhost:8000;
     keepalive 32;
  }

  server {
    listen 80 default_server;

   server_name focalboard.example.com;

    location ~ /ws/* {
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "upgrade";
       client_max_body_size 50M;
       proxy_set_header Host $http_host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Frame-Options SAMEORIGIN;
       proxy_buffers 256 16k;
       proxy_buffer_size 16k;
       client_body_timeout 60;
       send_timeout 300;
       lingering_timeout 5;
       proxy_connect_timeout 1d;
       proxy_send_timeout 1d;
       proxy_read_timeout 1d;
       proxy_pass http://focalboard;
   }

   location / {
       client_max_body_size 50M;
       proxy_set_header Connection "";
       proxy_set_header Host $http_host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Frame-Options SAMEORIGIN;
       proxy_buffers 256 16k;
       proxy_buffer_size 16k;
       proxy_read_timeout 600s;
       proxy_cache_revalidate on;
       proxy_cache_min_uses 2;
       proxy_cache_use_stale timeout;
       proxy_cache_lock on;
       proxy_http_version 1.1;
       proxy_pass http://focalboard;
   }
}
EOF