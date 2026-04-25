# AASTU-DB-Project-Group-5

## Project Title
Inventory and Sales Management System Database

## Group Information
- Group Number: 10
- Course: Database Systems
- Department: Software Engineering, AASTU

## Group Members
- Blen Mekonnen (ETS 0357/17)
- Biniam Girma (ETS 0312/17)
- Eden Wubshet (ETS 0461/17)
- Abemelek Samson (ETS 0043/17)
- Adonias Hailu (ETS 0103/17)
- Befikir Shimelis (ETS 0237/17)

## Project Description
This project designs and implements a complete database solution for an Inventory and Sales
Management System. The system handles product registration, stock updates, sales transactions,
low-stock monitoring, category organization, and inventory value analysis.

The implementation includes:
- Relational database design and implementation in MySQL
- NoSQL design and implementation in MongoDB
- Normalized schema up to BCNF for the relational part
- Example operational and analytical queries

## Final Data Model

### Entities
1. Product
	- product_id
	- name
	- price
2. Supplier
	- supplier_id
	- name
	- phone
3. Inventory
	- inventory_id
	- product_id
	- quantity
4. Sale
	- sale_id
	- product_id
	- quantity_sold
	- sale_date

### Relationships
- Supplier -> Product (1:M)
- Product -> Inventory (1:1)
- Product -> Sale (1:M)


## Repository Structure
The repository follows the required submission format:

```
/docs
	final_report.pdf
	final_report_template.md
	presentation.pptx
	presentation_outline.md
/mysql
	schema.sql
	queries.sql
/mongodb
	collections.json
	queries.js
/diagrams
	erd.mmd
	erd.png
	normalization.pdf
/annex
	survey_questions.pdf
	sample_forms.pdf
CONTRIBUTION.md
README.md
```

## Technologies Used
- MySQL 8+
- MongoDB 6+

## How To Run

### MySQL
1. Create a database:
	- `CREATE DATABASE inventory_db;`
	- `USE inventory_db;`
2. Run schema script from `mysql/schema.sql`.
3. Run data and query script from `mysql/queries.sql`.

### MongoDB
1. Open `mongosh`.
2. Run:
	- `use inventory_db`
	 - `load("mongodb/queries.js")`
3. Optional: import sample JSON from `mongodb/collections.json` if preferred.

