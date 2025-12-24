# Olist Customer RFM Analysis

## Project Overview
This project analyses customer purchasing behavior in a multi-seller e-commerce marketplace to understand customer value, engagement, and retention patterns. 

Using transactional order data, I built a SQL-based analytics pipeline and performed customer segmentation using Recency, Frequency, and Monetary (RFM) metrics. The results are presented through a Tableau dashboard to support retention-focused business decision-making.

## Business Questions
This analysis focuses on the following questions:
- How are customers distributed across RFM segments?
- What purchasing behaviours differentiate high-value customers from low-value or inactive customers?
- Which customer segments represent the greatest retention and re-engagement opportunities?

## Dataset
This analysis uses the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), which contains information on approximately 100,000 orders placed between 2016 and 2018 across multiple marketplaces in Brazil.

## Methodology
Key steps in the analysis include:
- Building order-level and customer-level fact tables in MySQL by joining transactional order data across multiple tables.
- Computing Recency, Frequency, and Monetary (RFM) metrics to quantify customer engagement and value.
- Assigning customers to RFM-based segments using rule-based scoring logic.
- Visualising customer segments and behavioural patterns in Tableau.

## Key Insights
- A vast majority of customers fall into low-frequency segments such as "Hibernating", "About to Sleep", and "Promising", which indicates a highly transactional customer base driven primarily by one-time purchases.
- Higher value segments ("Loyal Customers" and "Champions"), represent a very small proportion of the customer base but exhibit significantly higher purchase frequency and recency.
- Low-frequency segments produce the vast majority of revenue, suggesting that improving customer retention could be key to increasing revenue.

## Dashboard
This Tableau dashboard visualises the distribution of customers across RFM segments and compares recency, frequency, and monetary behaviour between high-value and low-value customer groups.

![Customer RFM Segmentation Dashboard](./exports/Customer%20Segmentation%20Dashboard.png)

## Recommendations
Based on my analysis, the following actions may improve customer retention and long-term revenue:

- Implement targeted re-engagement campaigns for customers in segments who have not made any recent purchases ("Hibernating" and "About to Sleep") to encourage repeat purchases.
- Prioritise loyalty programs to encourage newer one-time purchase segments ("Promising" and "New Customers") to continue buying through discounts.
- Introduce retention strategies for higher-value customer segments ("Champions", "Loyal Customers") such as a points system and increased points gain for higher value orders.

## Tools Used
- **SQL (MySQL)** — data transformation and RFM segmentation
- **Tableau Desktop** — data visualisation and dashboard development
