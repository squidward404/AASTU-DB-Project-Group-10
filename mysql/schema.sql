-- drop tables first so the script can run again without manual cleanup
DROP TABLE IF EXISTS sale;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS supplier;

-- base tables
CREATE TABLE supplier (
	supplier_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	phone VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE product (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
	supplier_id INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	price DECIMAL(10,2) NOT NULL,
	CONSTRAINT product_supplier_fk
		FOREIGN KEY (supplier_id)
		REFERENCES supplier(supplier_id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT product_price_check CHECK (price >= 0)
);

CREATE TABLE inventory (
	inventory_id INT AUTO_INCREMENT PRIMARY KEY,
	product_id INT NOT NULL UNIQUE,
	quantity INT NOT NULL,
	CONSTRAINT inventory_product_fk
		FOREIGN KEY (product_id)
		REFERENCES product(product_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT inventory_quantity_check CHECK (quantity >= 0)
);

CREATE TABLE sale (
	sale_id INT AUTO_INCREMENT PRIMARY KEY,
	product_id INT NOT NULL,
	quantity_sold INT NOT NULL,
	sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT sale_product_fk
		FOREIGN KEY (product_id)
		REFERENCES product(product_id)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT sale_quantity_check CHECK (quantity_sold > 0)
);
