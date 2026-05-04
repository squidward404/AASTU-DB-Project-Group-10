// Inventory & Sales MongoDB Project

This project sets up a simple inventory and sales database using MongoDB and runs aggregation queries to analyze the data.

Features
Creates collections: supplier, customer, product, inventory, sale

Inserts sample data
Performs aggregation queries:
Products with supplier details
Inventory by product
Sales with product and customer info
Total quantity sold per product
Sales count per customer


How to Run:
Open mongosh

Run:

use inventory_db
load("mongodb/queries.js")
 Output

The script prints results directly in the console using printjson().

Requirements
MongoDB installed
mongosh shell