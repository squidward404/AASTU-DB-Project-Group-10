USE inventory_db;

-- sample data used for testing

INSERT INTO supplier (name, phone) VALUES
('Abebe Supplier', '0911123456'),
('Kebede Trading', '0922234567'),
('Hana Wholesale', '0933345678');

INSERT INTO customer (name, phone) VALUES
('Martha Bekele', '0911456789'),
('Samuel Tesfaye', '0922567890'),
('Lidya Alemu', '0933678901'),
('Henok Abate', '0944789012');

INSERT INTO product (supplier_id, name, price) VALUES
(1, 'Soap', 150.00),
(2, 'Shampoo', 800.00),
(1, 'Toothpaste', 100.00),
(3, 'Sugar 1kg', 90.00),
(2, 'Cooking Oil 1L', 500.00),
(3, 'Biscuit Pack', 40.00);

INSERT INTO inventory (product_id, quantity) VALUES
(1, 120),
(2, 60),
(3, 75),
(4, 50),
(5, 40),
(6, 90);

INSERT INTO sale (product_id, customer_id, quantity_sold, sale_date) VALUES
(1, 1, 5,  '2026-04-20 09:30:00'),
(2, 2, 3,  '2026-04-20 13:10:00'),
(3, 3, 4,  '2026-04-21 10:25:00'),
(4, 4, 2,  '2026-04-21 16:40:00'),
(5, 1, 6,  '2026-04-22 11:05:00'),
(6, 2, 7,  '2026-04-22 15:55:00'),
(1, 3, 8,  '2026-04-23 13:20:00'),
(3, 4, 6,  '2026-04-23 17:45:00'),
(2, 1, 5,  '2026-04-24 10:10:00'),
(5, 2, 4,  '2026-04-24 12:30:00');

-- day to day operations

-- 1) add a new product from an existing supplier
INSERT INTO product (supplier_id, name, price)
VALUES (1, 'Detergent Powder', 180.00);

-- 2) create initial stock for the product i just added
-- using max(product_id) is okay here because this is a simple demo flow
INSERT INTO inventory (product_id, quantity)
SELECT MAX(product_id), 35
FROM product;

-- 3) restock an item
UPDATE inventory
SET quantity = quantity + 20
WHERE product_id = 2;

-- 4) record one sale
INSERT INTO sale (product_id, customer_id, quantity_sold, sale_date)
VALUES (2, 3, 5, NOW());

-- 5) reduce stock after the sale
UPDATE inventory
SET quantity = quantity - 5
WHERE product_id = 2;

-- 6) check current stock with supplier info
SELECT
	p.product_id,
	p.name AS product,
	s.name AS supplier,
	p.price,
	i.quantity AS stock_left
FROM product p
JOIN supplier s ON s.supplier_id = p.supplier_id
JOIN inventory i ON i.product_id = p.product_id
ORDER BY p.product_id;

-- simple analysis queries

-- 7) low stock check (threshold under 30)
SELECT
	p.product_id,
	p.name AS product,
	i.quantity AS stock_left
FROM product p
JOIN inventory i ON i.product_id = p.product_id
WHERE i.quantity < 30
ORDER BY i.quantity ASC;

-- 8) revenue summary by product
SELECT
	p.product_id,
	p.name AS product,
	SUM(sa.quantity_sold) AS units_sold,
	ROUND(SUM(sa.quantity_sold * p.price), 2) AS revenue
FROM sale sa
JOIN product p ON p.product_id = sa.product_id
GROUP BY p.product_id, p.name
ORDER BY revenue DESC;

-- 9) daily sales trend (units + revenue)
SELECT
	DATE(sa.sale_date) AS day,
	SUM(sa.quantity_sold) AS units_sold,
	ROUND(SUM(sa.quantity_sold * p.price), 2) AS revenue
FROM sale sa
JOIN product p ON p.product_id = sa.product_id
GROUP BY DATE(sa.sale_date)
ORDER BY day;

-- 10) stock value per product and grand total
SELECT
	p.product_id,
	p.name AS product,
	i.quantity,
	p.price,
	ROUND(i.quantity * p.price, 2) AS stock_value
FROM product p
JOIN inventory i ON i.product_id = p.product_id
ORDER BY stock_value DESC;

SELECT ROUND(SUM(i.quantity * p.price), 2) AS inventory_total_value
FROM product p
JOIN inventory i ON i.product_id = p.product_id;

-- 11) supplier with the highest sales revenue
SELECT
	s.supplier_id,
	s.name AS supplier,
	ROUND(SUM(sa.quantity_sold * p.price), 2) AS revenue
FROM supplier s
JOIN product p ON p.supplier_id = s.supplier_id
JOIN sale sa ON sa.product_id = p.product_id
GROUP BY s.supplier_id, s.name
ORDER BY revenue DESC;

-- required report queries from the checklist

-- 12) products with their suppliers
SELECT
	p.name AS product,
	s.name AS supplier
FROM product p
JOIN supplier s ON p.supplier_id = s.supplier_id
ORDER BY p.name;

-- 13) current inventory per product
SELECT
	p.name AS product,
	i.quantity
FROM inventory i
JOIN product p ON i.product_id = p.product_id
ORDER BY p.name;

-- 14) sales report with product, quantity, and date
SELECT
	p.name AS product,
	c.name AS customer,
	sa.quantity_sold AS sold_quantity,
	DATE(sa.sale_date) AS date
FROM sale sa
JOIN product p ON sa.product_id = p.product_id
JOIN customer c ON sa.customer_id = c.customer_id
ORDER BY sa.sale_date;
