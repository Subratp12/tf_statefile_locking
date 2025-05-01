-- Create Database
CREATE DATABASE IF NOT EXISTS custdb;
USE custdb;

-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Sample Data
INSERT IGNORE INTO users (username, email) VALUES
    ('JohnDoe', 'john@example.com'),
    ('JaneDoe', 'jane@example.com');

INSERT IGNORE INTO products (name, price, stock) VALUES
    ('Laptop', 75000.00, 10),
    ('Headphones', 2500.00, 50);

-- Insert Sample Data
INSERT IGNORE INTO users (username, email) VALUES
    ('AliceSmith', 'alice@example.com'),
    ('BobBrown', 'bob@example.com');

INSERT IGNORE INTO products (name, price, stock) VALUES
    ('Smartphone', 40000.00, 25),
    ('Bluetooth Speaker', 3500.00, 30);
