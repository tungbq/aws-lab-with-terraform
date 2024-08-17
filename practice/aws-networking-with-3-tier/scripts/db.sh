#!/bin/bash
# db.sh

# Install PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib

# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create a sample database and user
sudo -u postgres psql -c "CREATE DATABASE sampledb;"
sudo -u postgres psql -c "CREATE USER sampleuser WITH ENCRYPTED PASSWORD 'samplepass';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sampledb TO sampleuser;"
