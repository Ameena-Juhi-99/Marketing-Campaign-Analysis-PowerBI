-- ============================================================
-- PROJECT: Marketing Campaign Analysis
-- FILE: 06_advanced_window_function_queries.sql
-- PURPOSE: Perform advanced customer ranking and segmentation
-- AUTHOR: Ameena Juhi
-- ============================================================

USE marketing_campaign_db;


-- ============================================================
-- 1. Top five spending customers in every country
-- Demonstrates ROW_NUMBER()
-- ============================================================

WITH ranked_customers AS (

    SELECT
        ID,
        Country,
        Age,
        Income,
        Total_Spend,
        Total_Purchases,
        Preferred_Channel,
        Response,

        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY Total_Spend DESC
        ) AS Customer_Row_Number

    FROM customers
)

SELECT
    ID,
    Country,
    Age,
    Income,
    Total_Spend,
    Total_Purchases,
    Preferred_Channel,
    Response,
    Customer_Row_Number
FROM ranked_customers
WHERE Customer_Row_Number <= 5
ORDER BY
    Country,
    Customer_Row_Number;


-- ============================================================
-- 2. Rank countries by average customer spending
-- Demonstrates RANK()
-- ============================================================

WITH country_performance AS (

    SELECT
        Country,
        COUNT(*) AS Customers,
        ROUND(AVG(Total_Spend), 2) AS Average_Spend,
        ROUND(AVG(Response) * 100, 2) AS Response_Rate
    FROM customers
    GROUP BY Country
)

SELECT
    Country,
    Customers,
    Average_Spend,
    Response_Rate,

    RANK() OVER (
        ORDER BY Average_Spend DESC
    ) AS Spending_Rank

FROM country_performance
ORDER BY Spending_Rank;


-- ============================================================
-- 3. Rank countries by campaign-response rate
-- Demonstrates DENSE_RANK()
-- ============================================================

WITH country_response AS (

    SELECT
        Country,
        COUNT(*) AS Customers,
        SUM(Response) AS Responders,
        ROUND(AVG(Response) * 100, 2) AS Response_Rate
    FROM customers
    GROUP BY Country
)

SELECT
    Country,
    Customers,
    Responders,
    Response_Rate,

    DENSE_RANK() OVER (
        ORDER BY Response_Rate DESC
    ) AS Response_Rank

FROM country_response
ORDER BY Response_Rank;


-- ============================================================
-- 4. Divide customers into four spending quartiles
-- Demonstrates NTILE()
-- ============================================================

WITH customer_quartiles AS (

    SELECT
        ID,
        Country,
        Income,
        Total_Spend,
        Total_Purchases,
        Response,

        NTILE(4) OVER (
            ORDER BY Total_Spend DESC
        ) AS Spending_Quartile

    FROM customers
)

SELECT
    Spending_Quartile,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customer_quartiles
GROUP BY Spending_Quartile
ORDER BY Spending_Quartile;


-- ============================================================
-- 5. Rank customers within each value segment
-- Demonstrates RANK() with PARTITION BY
-- ============================================================

WITH value_segment_ranking AS (

    SELECT
        ID,
        Customer_Value_Segment,
        Country,
        Income,
        Total_Spend,
        Total_Purchases,
        Total_Accepted_Campaigns,

        RANK() OVER (
            PARTITION BY Customer_Value_Segment
            ORDER BY Total_Spend DESC
        ) AS Segment_Spending_Rank

    FROM customers
)

SELECT
    ID,
    Customer_Value_Segment,
    Country,
    Income,
    Total_Spend,
    Total_Purchases,
    Total_Accepted_Campaigns,
    Segment_Spending_Rank
FROM value_segment_ranking
WHERE Segment_Spending_Rank <= 10
ORDER BY
    Customer_Value_Segment,
    Segment_Spending_Rank;


-- ============================================================
-- 6. Rank demographic profiles by response rate
-- ============================================================

WITH demographic_performance AS (

    SELECT
        Age_Group,
        Income_Band,
        Relationship_Group,
        COUNT(*) AS Customers,
        ROUND(AVG(Total_Spend), 2) AS Average_Spend,
        ROUND(AVG(Response) * 100, 2) AS Response_Rate
    FROM customers
    GROUP BY
        Age_Group,
        Income_Band,
        Relationship_Group
    HAVING COUNT(*) >= 100
)

SELECT
    Age_Group,
    Income_Band,
    Relationship_Group,
    Customers,
    Average_Spend,
    Response_Rate,

    DENSE_RANK() OVER (
        ORDER BY Response_Rate DESC
    ) AS Response_Rank

FROM demographic_performance
ORDER BY
    Response_Rank,
    Average_Spend DESC;


-- ============================================================
-- 7. Customers with the strongest campaign history
-- ============================================================

WITH campaign_ranking AS (

    SELECT
        ID,
        Country,
        Customer_Value_Segment,
        Historical_Accepted_Campaigns,
        Response,
        Total_Accepted_Campaigns,
        Total_Spend,

        DENSE_RANK() OVER (
            ORDER BY
                Total_Accepted_Campaigns DESC,
                Total_Spend DESC
        ) AS Campaign_Engagement_Rank

    FROM customers
)

SELECT
    ID,
    Country,
    Customer_Value_Segment,
    Historical_Accepted_Campaigns,
    Response,
    Total_Accepted_Campaigns,
    Total_Spend,
    Campaign_Engagement_Rank
FROM campaign_ranking
WHERE Campaign_Engagement_Rank <= 20
ORDER BY Campaign_Engagement_Rank;


-- ============================================================
-- 8. Cumulative contribution of customers to total spending
-- ============================================================

WITH spending_contribution AS (

    SELECT
        ID,
        Total_Spend,

        SUM(Total_Spend) OVER (
            ORDER BY Total_Spend DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS Cumulative_Spend,

        SUM(Total_Spend) OVER ()
            AS Overall_Spend

    FROM customers
),

customer_contribution AS (

    SELECT
        ID,
        Total_Spend,
        Cumulative_Spend,
        Overall_Spend,

        ROUND(
            Cumulative_Spend * 100.0 /
            NULLIF(Overall_Spend, 0),
            2
        ) AS Cumulative_Spending_Percentage

    FROM spending_contribution
)

SELECT
    ID,
    Total_Spend,
    Cumulative_Spend,
    Cumulative_Spending_Percentage
FROM customer_contribution
WHERE Cumulative_Spending_Percentage <= 80
ORDER BY Total_Spend DESC;