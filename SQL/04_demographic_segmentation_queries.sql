-- ============================================================
-- PROJECT: Marketing Campaign Analysis
-- FILE: 04_demographic_segmentation_queries.sql
-- PURPOSE: Analyze demographic and customer segments
-- AUTHOR: Ameena Juhi
-- ============================================================

USE marketing_campaign_db;


-- ============================================================
-- 1. Customer performance by country
-- ============================================================

SELECT
    Country,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Country
ORDER BY Response_Rate DESC;


-- ============================================================
-- 2. Customer performance by education
-- ============================================================

SELECT
    Education_Group,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Education_Group
ORDER BY Average_Spend DESC;


-- ============================================================
-- 3. Customer performance by relationship group
-- ============================================================

SELECT
    Relationship_Group,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Relationship_Group
ORDER BY Average_Spend DESC;


-- ============================================================
-- 4. Customer performance by age group
-- ============================================================

SELECT
    Age_Group,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Age_Group
ORDER BY
    CASE Age_Group
        WHEN 'Under 30' THEN 1
        WHEN '30-39' THEN 2
        WHEN '40-49' THEN 3
        WHEN '50-59' THEN 4
        WHEN '60-69' THEN 5
        WHEN '70+' THEN 6
        ELSE 7
    END;


-- ============================================================
-- 5. Customer performance by income band
-- ============================================================

SELECT
    Income_Band,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Income_Band
ORDER BY
    CASE Income_Band
        WHEN 'Low' THEN 1
        WHEN 'Lower-Middle' THEN 2
        WHEN 'Middle' THEN 3
        WHEN 'High' THEN 4
        WHEN 'Premium' THEN 5
        ELSE 6
    END;


-- ============================================================
-- 6. Customers with and without children
-- ============================================================

SELECT
    Has_Children,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(NumDealsPurchases), 2) AS Average_Deal_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Has_Children
ORDER BY Average_Spend DESC;


-- ============================================================
-- 7. Age and income segment combination
-- ============================================================

SELECT
    Age_Group,
    Income_Band,
    COUNT(*) AS Customers,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY
    Age_Group,
    Income_Band
ORDER BY
    Response_Rate DESC,
    Average_Spend DESC;


-- ============================================================
-- 8. Demographic segments performing above the overall
--    campaign response rate
-- Demonstrates GROUP BY, HAVING and a subquery
-- ============================================================

SELECT
    Country,
    Age_Group,
    COUNT(*) AS Customers,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY
    Country,
    Age_Group
HAVING
    COUNT(*) >= 100
    AND AVG(Response) > (
        SELECT AVG(Response)
        FROM customers
    )
ORDER BY
    Response_Rate DESC,
    Customers DESC;


-- ============================================================
-- 9. High-value demographic profiles
-- ============================================================

SELECT
    Country,
    Age_Group,
    Income_Band,
    Relationship_Group,
    COUNT(*) AS Customers,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
WHERE Customer_Value_Segment = 'Premium Value'
GROUP BY
    Country,
    Age_Group,
    Income_Band,
    Relationship_Group
HAVING COUNT(*) >= 10
ORDER BY
    Response_Rate DESC,
    Average_Spend DESC;


-- ============================================================
-- 10. Under-served demographic profiles
-- ============================================================

SELECT
    Age_Group,
    Income_Band,
    Country,
    COUNT(*) AS Customers,
    ROUND(AVG(NumWebVisitsMonth), 2)
        AS Average_Web_Visits,
    ROUND(AVG(Total_Spend), 2)
        AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2)
        AS Average_Purchases
FROM customers
WHERE Under_Served_Customer = 1
GROUP BY
    Age_Group,
    Income_Band,
    Country
HAVING COUNT(*) >= 25
ORDER BY
    Customers DESC,
    Average_Web_Visits DESC;