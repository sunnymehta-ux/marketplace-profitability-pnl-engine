create database ecommerce_pnl;
use ecommerce_pnl;

CREATE TABLE products (
    sku VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    cost_price DECIMAL(10,2),
    selling_price DECIMAL(10,2)
);
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    marketplace VARCHAR(50),
    sku VARCHAR(20),
    qty INT
);
CREATE TABLE marketplace_charges (
    marketplace VARCHAR(50),
    commission_percent DECIMAL(5,2)
);
CREATE TABLE shipping_cost (
    marketplace VARCHAR(50),
    shipping_cost DECIMAL(10,2)
);
CREATE VIEW vw_marketplace_pnl AS
SELECT
    o.order_id,
    o.order_date,
    o.marketplace,
    o.sku,
    p.product_name,

    o.qty,

    p.selling_price,
    p.cost_price,

    mc.commission_percent,
    sc.shipping_cost,
    
    (o.qty * p.selling_price) AS revenue,
    
	(o.qty * p.cost_price) AS product_cost,
    
    ((o.qty * p.selling_price) * mc.commission_percent / 100)
    AS commission_cost,
    
    (o.qty * sc.shipping_cost)
    AS shipping_total,
    
     (
      (o.qty * p.selling_price)
      -
      (o.qty * p.cost_price)
      -
      ((o.qty * p.selling_price) * mc.commission_percent / 100)
      -
      (o.qty * sc.shipping_cost)
    ) AS profit
FROM orders o
JOIN products p
ON o.sku = p.sku

JOIN marketplace_charges mc
ON o.marketplace = mc.marketplace

JOIN shipping_cost sc
ON o.marketplace = sc.marketplace;