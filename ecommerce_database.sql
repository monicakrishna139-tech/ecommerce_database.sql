-- Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderItems Table
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- Insert Customers
INSERT INTO Customers (name, email, phone) VALUES
('Alice Johnson', 'alice@example.com', '9876543210'),
('Bob Smith', 'bob@example.com', '9123456780'),
('Charlie Brown', 'charlie@example.com', '9988776655');

-- Insert Products
INSERT INTO Products (product_name, price, stock) VALUES
('Laptop', 75000.00, 10),
('Smartphone', 35000.00, 25),
('Headphones', 2000.00, 50),
('Keyboard', 1500.00, 40);

-- Insert Orders
INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2025-08-01'),
(2, '2025-08-02'),
(3, '2025-08-03');

-- Insert OrderItems
INSERT INTO OrderItems (order_id, product_id, quantity) VALUES
(1, 1, 1),   -- Alice buys 1 Laptop
(1, 3, 2),   -- Alice buys 2 Headphones
(2, 2, 1),   -- Bob buys 1 Smartphone
(3, 4, 3);   -- Charlie buys 3 Keyboards
-- 1. Show all customers
SELECT * FROM Customers;

-- 2. Show all products
SELECT * FROM Products;

-- 3. List all orders with customer names
SELECT o.order_id, o.order_date, c.name AS CustomerName
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- 4. Show order details (customer, product, quantity, total price)
SELECT o.order_id, c.name AS CustomerName, p.product_name, oi.quantity,
       (oi.quantity * p.price) AS total_price
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON oi.product_id = p.product_id;

-- 5. Find best-selling product (highest total quantity sold)
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

-- 6. Calculate total sales per customer
SELECT c.name AS CustomerName, SUM(oi.quantity * p.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;
