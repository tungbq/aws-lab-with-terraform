CREATE DATABASE webappdb;
SHOW DATABASES;
USE webappdb;
CREATE TABLE IF NOT EXISTS transactions(
  id INT NOT NULL AUTO_INCREMENT,
  amount DECIMAL(10, 2),
  description VARCHAR(100),
  PRIMARY KEY(id)
);
SHOW TABLES;
INSERT INTO transactions (amount, description)
VALUES ('400', 'groceries');
SELECT *
FROM transactions;
