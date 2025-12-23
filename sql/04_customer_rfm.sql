-- Create base customer-level table, customer_rfm with last_order_date, F, M
DROP TABLE IF EXISTS customer_rfm;
CREATE TABLE customer_rfm AS
WITH customer_base_fm AS (
    SELECT
        customer_unique_id,
        MAX(order_date) AS last_order_date,
        COUNT(order_id) AS frequency,
        SUM(order_revenue) AS monetary
    FROM fact_orders
    GROUP BY customer_unique_id
),
-- Get a reference date for the latest order (to calculate Recency)
reference_date AS (
    SELECT MAX(order_date) AS latest_order_date
    FROM fact_orders
)
SELECT
    customer_unique_id,
    DATEDIFF(reference_date.latest_order_date, last_order_date) AS recency,
    frequency,
    monetary
FROM customer_base_fm
CROSS JOIN reference_date;

-- Sanity checks
SELECT
    COUNT(*) AS num_rows,
    COUNT(DISTINCT customer_unique_id) AS unique_customer_unique_ids,
    SUM(CASE WHEN recency IS NULL THEN 1 ELSE 0 END) as null_recencies,
    SUM(CASE WHEN frequency IS NULL THEN 1 ELSE 0 END) as null_frequencies,
    SUM(CASE WHEN monetary IS NULL THEN 1 ELSE 0 END) as null_monetaries,
    SUM(CASE WHEN recency < 0 THEN 1 ELSE 0 END) as negative_recencies,
    SUM(CASE WHEN frequency < 1 THEN 1 ELSE 0 END) as frequencies_less_than_1,
    SUM(CASE WHEN monetary <= 0 THEN 1 ELSE 0 END) as non_positive_monetaries
FROM customer_rfm;


-- Top 10 Most Recent Spenders
SELECT *
FROM customer_rfm
ORDER BY recency ASC
LIMIT 10;

-- Top 10 Most Frequent Customers
SELECT *
FROM customer_rfm
ORDER BY frequency DESC
LIMIT 10;

-- Top 10 Highest Spenders
SELECT *
FROM customer_rfm
ORDER BY monetary DESC
LIMIT 10;