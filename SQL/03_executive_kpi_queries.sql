-- ============================================================
-- PROJECT: Marketing Campaign Analysis
-- FILE: 03_executive_kpi_queries.sql
-- PURPOSE: Calculate executive marketing and customer KPIs
-- AUTHOR: Ameena Juhi
-- ============================================================

USE marketing_campaign_db;


-- ============================================================
-- 1. Executive customer KPIs
-- ============================================================

SELECT
    COUNT(*) AS Total_Customers,

    ROUND(SUM(Total_Spend), 2)
        AS Total_Customer_Spending,

    ROUND(AVG(Total_Spend), 2)
        AS Average_Spend_Per_Customer,

    ROUND(AVG(Income), 2)
        AS Average_Customer_Income,

    SUM(Total_Purchases)
        AS Total_Purchases,

    ROUND(AVG(Total_Purchases), 2)
        AS Average_Purchases_Per_Customer,

    ROUND(AVG(Response) * 100, 2)
        AS Latest_Campaign_Response_Rate,

    ROUND(AVG(Complain) * 100, 2)
        AS Complaint_Rate
FROM customers;


-- ============================================================
-- 2. Latest campaign response distribution using CASE WHEN
-- ============================================================

SELECT
    CASE
        WHEN Response = 1 THEN 'Responded'
        ELSE 'Did Not Respond'
    END AS Response_Status,

    COUNT(*) AS Customers,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS Customer_Percentage
FROM customers
GROUP BY Response_Status
ORDER BY Customers DESC;


-- ============================================================
-- 3. Campaign acceptance-rate comparison
-- ============================================================

SELECT
    'Campaign 1' AS Campaign,
    SUM(AcceptedCmp1) AS Accepted_Customers,
    ROUND(AVG(AcceptedCmp1) * 100, 2) AS Acceptance_Rate
FROM customers

UNION ALL

SELECT
    'Campaign 2',
    SUM(AcceptedCmp2),
    ROUND(AVG(AcceptedCmp2) * 100, 2)
FROM customers

UNION ALL

SELECT
    'Campaign 3',
    SUM(AcceptedCmp3),
    ROUND(AVG(AcceptedCmp3) * 100, 2)
FROM customers

UNION ALL

SELECT
    'Campaign 4',
    SUM(AcceptedCmp4),
    ROUND(AVG(AcceptedCmp4) * 100, 2)
FROM customers

UNION ALL

SELECT
    'Campaign 5',
    SUM(AcceptedCmp5),
    ROUND(AVG(AcceptedCmp5) * 100, 2)
FROM customers

UNION ALL

SELECT
    'Latest Campaign',
    SUM(Response),
    ROUND(AVG(Response) * 100, 2)
FROM customers

ORDER BY Acceptance_Rate DESC;


-- ============================================================
-- 4. Customer-value segment KPIs
-- ============================================================

SELECT
    Customer_Value_Segment,

    COUNT(*) AS Customers,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS Customer_Share,

    ROUND(AVG(Income), 2)
        AS Average_Income,

    ROUND(AVG(Total_Spend), 2)
        AS Average_Spend,

    ROUND(AVG(Total_Purchases), 2)
        AS Average_Purchases,

    ROUND(AVG(Response) * 100, 2)
        AS Response_Rate
FROM customers
GROUP BY Customer_Value_Segment
ORDER BY Average_Spend DESC;


-- ============================================================
-- 5. Product spending KPIs
-- ============================================================

SELECT
    SUM(MntWines) AS Wine_Spending,
    SUM(MntFruits) AS Fruit_Spending,
    SUM(MntMeatProducts) AS Meat_Spending,
    SUM(MntFishProducts) AS Fish_Spending,
    SUM(MntSweetProducts) AS Sweet_Spending,
    SUM(MntGoldProds) AS Gold_Spending,
    SUM(Total_Spend) AS Total_Spending
FROM customers;


-- ============================================================
-- 6. Purchase-channel KPIs
-- ============================================================

SELECT
    SUM(NumWebPurchases) AS Web_Purchases,
    SUM(NumCatalogPurchases) AS Catalog_Purchases,
    SUM(NumStorePurchases) AS Store_Purchases,
    SUM(Total_Purchases) AS Total_Purchases,
    ROUND(AVG(NumWebVisitsMonth), 2) AS Average_Web_Visits
FROM customers;


-- ============================================================
-- 7. Strategic customer-segment counts
-- ============================================================

SELECT
    SUM(High_Income_Customer)
        AS High_Income_Customers,

    SUM(Young_Customer)
        AS Young_Customers,

    SUM(Campaign_Responder)
        AS Campaign_Responders,

    SUM(High_Web_Engagement)
        AS High_Web_Engagement_Customers,

    SUM(Family_Customer)
        AS Family_Customers,

    SUM(High_Spender)
        AS High_Spenders,

    SUM(Loyal_Customer)
        AS Loyal_Customers,

    SUM(Deal_Hunter)
        AS Deal_Hunters,

    SUM(Under_Served_Customer)
        AS Under_Served_Customers,

    SUM(Ideal_Target_Customer)
        AS Ideal_Target_Customers
FROM customers;


-- ============================================================
-- 8. Ideal-target customer KPIs
-- ============================================================

SELECT
    COUNT(*) AS Ideal_Target_Customers,
    ROUND(AVG(Age), 2) AS Average_Age,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
WHERE Ideal_Target_Customer = 1;


-- ============================================================
-- 9. Under-served customer KPIs
-- ============================================================

SELECT
    COUNT(*) AS Under_Served_Customers,
    ROUND(AVG(Age), 2) AS Average_Age,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(NumWebVisitsMonth), 2) AS Average_Web_Visits,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
WHERE Under_Served_Customer = 1;