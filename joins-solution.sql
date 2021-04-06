-- 1. Get all customers and their addresses.
SELECT customers.first_name, customers.last_name, addresses.street, addresses.city, addresses.state, addresses.zip
FROM customers
JOIN addresses ON customers.id = addresses.customer_id
GROUP BY customers.first_name, customers.last_name, addresses.street, addresses.city, addresses.state, addresses.zip
ORDER BY customers.first_name
-- 2. Get all orders and their line items (orders, quantity and product).
SELECT orders.id, line_items.product_id, line_items.quantity, products.description
FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products on line_items.product_id = products.id

-- 3. Which warehouses have cheetos?
SELECT warehouse.warehouse
FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'cheetos'
-- 4. Which warehouses have diet pepsi?
SELECT warehouse.warehouse
FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi'
-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT customers.first_name, customers.last_name, COUNT(orders.address_id)
FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON addresses.id = orders.id
GROUP BY customers.first_name, customers.last_name
ORDER BY customers.first_name
-- 6. How many customers do we have
SELECT COUNT(customers.id)
FROM customers
-- 7. How many products do we carry?
SELECT COUNT(products.id)
FROM products
-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT products.description, SUM(warehouse_product.on_hand)
FROM products
JOIN warehouse_product ON products.id = warehouse_product.product_id
WHERE products.description = 'diet pepsi'
GROUP BY products.description
--STRETCH
-- 9. How much was the total cost for each order?
SELECT orders.id, SUM(line_items.quantity * products.unit_price)
FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
GROUP BY orders.id
ORDER BY orders.id
-- 10. How much has each customer spent in total?
SELECT customers.first_name, customers.last_name, SUM(line_items.quantity * products.unit_price)
FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON addresses.id = orders.address_id
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
GROUP BY customers.first_name, customers.last_name
ORDER BY customers.first_name
-- 11. How much has each customer spent in total? 
--Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT customers.first_name, customers.last_name, COALESCE(SUM(line_items.quantity * products.unit_price), 0)
FROM customers
LEFT JOIN addresses ON customers.id = addresses.customer_id
LEFT JOIN orders ON addresses.id = orders.address_id
LEFT JOIN line_items ON orders.id = line_items.order_id
LEFT JOIN products ON line_items.product_id = products.id
GROUP BY customers.first_name, customers.last_name
ORDER BY customers.first_name