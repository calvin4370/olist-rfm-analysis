-- Create fact table for orders
-- Grain: one row represents one delivered order
-- order_id, customer_unique_id, order_date, order_revenue

DROP TABLE IF EXISTS fact_orders;
CREATE TABLE fact_orders (
    order_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    order_date DATE,
    order_revenue DECIMAL(10, 2)
);

-- Populate the fact_orders table
INSERT INTO fact_orders (order_id, customer_unique_id, order_date, order_revenue)
WITH order_revenue AS (
    SELECT
        order_id,
        SUM(price) as revenue
    FROM order_items
    GROUP BY order_id
)
SELECT
    o.order_id,
    c.customer_unique_id,
    DATE(order_purchase_timestamp) AS order_date,
    r.revenue AS order_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_revenue r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';


-- Sanity check on fact_orders table
-- Uniqueness of primary key: order_id
SELECT
    COUNT(*) AS num_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM fact_orders;

-- No NULLs in primary key or dimension keys
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_ids,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_customer_unique_ids,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_dates,
    SUM(CASE WHEN order_revenue IS NULL THEN 1 ELSE 0 END) AS null_order_revenues
FROM fact_orders;

-- Revenue distribution
SELECT
    MIN(order_revenue) AS min_revenue,
    MAX(order_revenue) AS max_revenue,
    AVG(order_revenue) AS mean_revenue
FROM fact_orders;

