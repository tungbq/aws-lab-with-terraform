#!/bin/bash

#Start by downloading the MySQL CLI:
sudo yum install mysql -y


#Initiate your DB connection with your Aurora RDS writer endpoint.

# Define variables
rds_endpoint="CHANGE-TO-YOUR-RDS-ENDPOINT"
user_name="CHANGE-TO-USER-NAME"

# Prompt for password
read -s -p "Enter password: " password
echo

# Construct the mysql command using variables
mysql_cmd="mysql -h $rds_endpoint -u $user_name -p$password"

# Execute the mysql command
eval $mysql_cmd 


#Create a database called webappdb with the following command using the MySQL CLI:
CREATE DATABASE webappdb;   

SHOW DATABASES;

#Create a data table by first navigating to the database we just created:
USE webappdb;    

#Then, create the following transactions table by executing this create table command:
CREATE TABLE IF NOT EXISTS transactions(id INT NOT NULL
AUTO_INCREMENT, amount DECIMAL(10,2), description
VARCHAR(100), PRIMARY KEY(id));    

SHOW TABLES;    

#Insert data into table for use/testing later:
INSERT INTO transactions (amount,description) VALUES ('400','groceries');   

SELECT * FROM transactions;
EOF