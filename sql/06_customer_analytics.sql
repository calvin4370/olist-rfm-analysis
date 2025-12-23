USE olist;

DROP TABLE IF EXISTS customer_analytics;
CREATE TABLE customer_analytics AS
WITH max_date_cte AS (
    SELECT MAX(order_purchase_timestamp) AS dataset_end_date
    FROM orders
)
SELECT
    rfm.customer_unique_id,
    rfm.rfm_segment,
    rfm.recency,
    rfm.frequency,
    rfm.monetary,
    
    AVG(r.review_score) as avg_review_score,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)) as avg_delivery_delay_days,
    DATEDIFF(md.dataset_end_date, MIN(o.order_purchase_timestamp)) as tenure_days -- days since first order

FROM customer_rfm_segmented rfm
JOIN customers c ON rfm.customer_unique_id = c.customer_unique_id
JOIN orders o ON c.customer_id = o.customer_id
-- Left join reviews (some orders might not have reviews)
LEFT JOIN order_reviews r ON o.order_id = r.order_id
CROSS JOIN max_date_cte md
GROUP BY 
    rfm.customer_unique_id, 
    rfm.rfm_segment, 
    rfm.recency, 
    rfm.frequency, 
    rfm.monetary;


-- Validate Final table
SELECT 
    rfm_segment,
    COUNT(*) as count,
    ROUND(AVG(avg_review_score), 2) as avg_score,
    ROUND(AVG(avg_delivery_delay_days), 2) as avg_delay,
    ROUND(AVG(tenure_days), 0) as avg_tenure
FROM customer_analytics
GROUP BY rfm_segment
ORDER BY avg_score DESC;