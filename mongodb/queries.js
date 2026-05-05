// Inventory and Sales MongoDB Setup + Queries
// Run in mongosh: use inventory_db; load("mongodb/queries.js")

db.supplier.drop();
db.customer.drop();
db.product.drop();
db.inventory.drop();
db.sale.drop();

db.supplier.insertMany([
  { supplier_id: 1, name: "Alem Suppliers", phone: "0911001001" },
  { supplier_id: 2, name: "Abel Distribution", phone: "0911001002" }
]);

db.customer.insertMany([
  { customer_id: 1, name: "Marta Bekele", phone: "0912002001" },
  { customer_id: 2, name: "Nahom Demeke", phone: "0912002002" },
  { customer_id: 3, name: "Saron Tola", phone: "0912002003" }
]);

db.product.insertMany([
  { product_id: 1, name: "Rice 1kg", price: 120, supplier_id: 1 },
  { product_id: 2, name: "Cooking Oil 1L", price: 210, supplier_id: 1 },
  { product_id: 3, name: "Laundry Soap", price: 65, supplier_id: 2 }
]);

db.inventory.insertMany([
  { inventory_id: 1, product_id: 1, quantity: 100 },
  { inventory_id: 2, product_id: 2, quantity: 60 },
  { inventory_id: 3, product_id: 3, quantity: 150 }
]);

db.sale.insertMany([
  { sale_id: 1, product_id: 1, customer_id: 1, quantity_sold: 3, date: "2026-04-22" },
  { sale_id: 2, product_id: 2, customer_id: 2, quantity_sold: 2, date: "2026-04-22" },
  { sale_id: 3, product_id: 1, customer_id: 3, quantity_sold: 5, date: "2026-04-23" },
  { sale_id: 4, product_id: 3, customer_id: 1, quantity_sold: 10, date: "2026-04-23" }
]);

print("--- Products with Supplier ---");
printjson(
  db.product.aggregate([
    {
      $lookup: {
        from: "supplier",
        localField: "supplier_id",
        foreignField: "supplier_id",
        as: "supplier"
      }
    },
    { $unwind: "$supplier" },
    {
      $project: {
        _id: 0,
        product_id: 1,
        name: 1,
        price: 1,
        supplier_name: "$supplier.name"
      }
    }
  ]).toArray()
);

print("--- Inventory by Product ---");
printjson(
  db.inventory.aggregate([
    {
      $lookup: {
        from: "product",
        localField: "product_id",
        foreignField: "product_id",
        as: "product"
      }
    },
    { $unwind: "$product" },
    {
      $project: {
        _id: 0,
        inventory_id: 1,
        product_id: 1,
        product_name: "$product.name",
        quantity: 1
      }
    }
  ]).toArray()
);

print("--- Sales with Product and Customer ---");
printjson(
  db.sale.aggregate([
    {
      $lookup: {
        from: "product",
        localField: "product_id",
        foreignField: "product_id",
        as: "product"
      }
    },
    {
      $lookup: {
        from: "customer",
        localField: "customer_id",
        foreignField: "customer_id",
        as: "customer"
      }
    },
    { $unwind: "$product" },
    { $unwind: "$customer" },
    {
      $project: {
        _id: 0,
        sale_id: 1,
        product_name: "$product.name",
        customer_name: "$customer.name",
        quantity_sold: 1,
        date: 1
      }
    },
    { $sort: { sale_id: 1 } }
  ]).toArray()
);

print("--- Total Sold By Product ---");
printjson(
  db.sale.aggregate([
    {
      $group: {
        _id: "$product_id",
        total_sold: { $sum: "$quantity_sold" }
      }
    },
    {
      $lookup: {
        from: "product",
        localField: "_id",
        foreignField: "product_id",
        as: "product"
      }
    },
    { $unwind: "$product" },
    {
      $project: {
        _id: 0,
        product_id: "$product.product_id",
        product_name: "$product.name",
        total_sold: 1
      }
    },
    { $sort: { total_sold: -1 } }
  ]).toArray()
);

print("--- Sales Count By Customer ---");
printjson(
  db.sale.aggregate([
    {
      $group: {
        _id: "$customer_id",
        sales_count: { $sum: 1 }
      }
    },
    {
      $lookup: {
        from: "customer",
        localField: "_id",
        foreignField: "customer_id",
        as: "customer"
      }
    },
    { $unwind: "$customer" },
    {
      $project: {
        _id: 0,
        customer_id: "$customer.customer_id",
        customer_name: "$customer.name",
        sales_count: 1
      }
    },
    { $sort: { sales_count: -1, customer_id: 1 } }
  ]).toArray()
);
