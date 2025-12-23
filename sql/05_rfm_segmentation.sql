USE olist;

DROP TABLE IF EXISTS customer_rfm_scored;
CREATE TABLE customer_rfm_scored AS
SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    -- f-score: Hardcode as NTILE will give a bad distribution
    CASE 
        WHEN frequency >= 5 THEN 5
        WHEN frequency = 4 THEN 4
        WHEN frequency = 3 THEN 3
        WHEN frequency = 2 THEN 2
        WHEN frequency = 1 THEN 1
        ELSE 1
    END AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
FROM customer_rfm;

-- Customer RFM Segmentation into Groups of similar RFM score
DROP TABLE IF EXISTS customer_rfm_segmented;
CREATE TABLE customer_rfm_segmented AS
SELECT
    *,
    CASE 
        WHEN r_score = 5 AND f_score IN (4, 5) THEN 'Champion'
        WHEN r_score IN (3, 4) AND f_score IN (4, 5) THEN 'Loyal Customer'
        WHEN r_score IN (1, 2) AND f_score = 5 THEN 'Cannot Lose Them'
        WHEN r_score IN (1, 2) AND f_score IN (3, 4) THEN 'At Risk'
        WHEN r_score IN (4, 5) AND f_score IN (2, 3) THEN 'Potential Loyalists'
        WHEN r_score = 3 AND f_score = 3 THEN 'Need Attention'
        WHEN r_score = 5 AND f_score = 1 THEN 'New Customer'
        WHEN r_score = 4 AND f_score = 1 THEN 'Promising'
        WHEN r_score = 3 AND f_score IN (1, 2) THEN 'About to Sleep'
        WHEN r_score IN (1, 2) AND f_score IN (1, 2) THEN 'Hibernating'
        ELSE 'Others'
    END AS rfm_segment
FROM customer_rfm_scored;


--------------------------------------------------------------------------
-- Validation of table and EDA
--------------------------------------------------------------------------

-- Segment counts, Segment % of total customers
SELECT
    rfm_segment,
    COUNT(*) as num_customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 
        2
    ) as proportion_pct
FROM customer_rfm_segmented
GROUP BY rfm_segment
ORDER BY num_customers DESC;

-- Check that f_score is distribued properly
SELECT 
    frequency,
    f_score,
    COUNT(*) 
FROM customer_rfm_scored 
GROUP BY frequency, f_score 
ORDER BY frequency, f_score;

-- Revenue metrics per segment, Revenue concentration by segment
SELECT
    rfm_segment,
    SUM(monetary) AS total_revenue,
    ROUND(
		AVG(monetary),
        2
    ) AS avg_revenue_per_customer,
    ROUND(
        SUM(monetary) * 100.0 / SUM(SUM(monetary)) OVER(), 
        2
    ) AS revenue_pct
FROM customer_rfm_segmented
GROUP BY rfm_segment
ORDER BY total_revenue DESC;

-- Check RFM metrics by RFM segment
SELECT
    rfm_segment,
    ROUND(AVG(recency), 1) AS avg_recency,
    ROUND(AVG(frequency), 2) AS avg_frequency,
    ROUND(AVG(monetary), 2) AS avg_monetary
FROM customer_rfm_segmented
GROUP BY rfm_segment
ORDER BY avg_monetary DESC;