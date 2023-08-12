#!/bin/bash

install_focalboard() {
    version=$1
    wget "https://github.com/mattermost/focalboard/releases/download/$1/focalboard-server-linux-amd64.tar.gz"
    tar -xvzf focalboard-server-linux-amd64.tar.gz
    mv focalboard /opt
}

install_nginx() {
    # install NGINX
    apt update -y
    apt install -y nginx
}

configure_nginx() {
    # Configure NGINX
    # nano /etc/nginx/sites-available/focalboard

    # Note: We cannot know the server.server_name with default EC2 launch, cuz the URL we only know after deployment
    # TODO: investigate to improve

    cat <<EOF > /etc/nginx/sites-available/focalboard
upstream focalboard {
    server localhost:8000;
    keepalive 32;
}

server {
    listen 80 default_server;
    server_name focalboard.example.com;

    location ~ /ws/.* {
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        client_max_body_size 50M;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
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
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
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
}

remove_default_site() {
    # delete default site if existed
    rm /etc/nginx/sites-enabled/default
}

enable_focalboard_site() {
    # Enable the Focalboard site
    ln -s /etc/nginx/sites-available/focalboard /etc/nginx/sites-enabled/focalboard
    nginx -t
    /etc/init.d/nginx reload
}

configure_focalboard_to_run_as_a_service() {
    # Configure Focalboard to run as a service
    cat <<EOF >/lib/systemd/system/focalboard.service
[Unit]
Description=Focalboard server

[Service]
Type=simple
Restart=always
RestartSec=5s
ExecStart=/opt/focalboard/bin/focalboard-server
WorkingDirectory=/opt/focalboard

[Install]
WantedBy=multi-user.target
EOF
    # Reload and start new unit
    systemctl daemon-reload
    systemctl start focalboard.service
    systemctl enable focalboard.service
}

check_result() {
    curl localhost:8000
    curl localhost
}

###################
#### main #########
###################
FOCALBOARD_VERSION="v7.8.7"

install_focalboard $FOCALBOARD_VERSION
install_nginx
configure_nginx
remove_default_site
enable_focalboard_site
configure_focalboard_to_run_as_a_service
check_result
