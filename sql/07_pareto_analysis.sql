USE olist;

-- Create pareto table
WITH ranked_customers AS (
    SELECT
        customer_unique_id,
        monetary AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY monetary DESC) AS customer_rank,
        SUM(monetary) OVER () AS overall_revenue,
        SUM(monetary) OVER (
            ORDER BY monetary DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM customer_analytics
)
SELECT
    customer_rank,
    customer_unique_id,
    total_revenue,
    cumulative_revenue / overall_revenue AS cumulative_revenue_pct
FROM ranked_customers
ORDER BY customer_rank;

-- Check number of unique customers
-- note that customer_analytics has unique customers unlike customers which has order_level customers
SELECT COUNT(*) FROM customer_analytics;


-- Outputs the % of customers which produce 80% of the revenue
WITH ranked_customers AS (
    SELECT
        customer_unique_id,
        monetary,
        SUM(monetary) OVER (
            ORDER BY monetary DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) /
        SUM(monetary) OVER () AS cumulative_revenue_pct
    FROM customer_analytics
)
SELECT
    COUNT(*) / (SELECT COUNT(*) FROM customer_analytics) 
        AS pct_customers_for_80pct_revenue
FROM ranked_customers
WHERE cumulative_revenue_pct <= 0.80;