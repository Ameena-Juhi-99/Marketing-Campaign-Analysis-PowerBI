-- ============================================================
-- PROJECT: Marketing Campaign Analysis
-- FILE: 07_reporting_views.sql
-- PURPOSE: Create reusable reporting views
-- AUTHOR: Ameena Juhi
-- ============================================================

USE marketing_campaign_db;


-- ============================================================
-- 1. Executive KPI view
-- ============================================================

CREATE OR REPLACE VIEW vw_executive_kpis AS

SELECT
    COUNT(*) AS Total_Customers,
    SUM(Total_Spend) AS Total_Customer_Spending,
    ROUND(AVG(Total_Spend), 2) AS Average_Customer_Spend,
    ROUND(AVG(Income), 2) AS Average_Customer_Income,
    SUM(Total_Purchases) AS Total_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate,
    ROUND(AVG(Complain) * 100, 2) AS Complaint_Rate
FROM customers;


-- ============================================================
-- 2. Country-performance view
-- ============================================================

CREATE OR REPLACE VIEW vw_country_performance AS

SELECT
    Country,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    SUM(Total_Spend) AS Total_Spending,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    SUM(Total_Purchases) AS Total_Purchases,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    SUM(Response) AS Responders,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Country;


-- ============================================================
-- 3. Campaign-performance view
-- ============================================================

CREATE OR REPLACE VIEW vw_campaign_performance AS

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
FROM customers;


-- ============================================================
-- 4. Product-performance view
-- ============================================================

CREATE OR REPLACE VIEW vw_product_performance AS

SELECT
    'Wine' AS Product,
    SUM(MntWines) AS Total_Spending,
    ROUND(AVG(MntWines), 2) AS Average_Spending
FROM customers

UNION ALL

SELECT
    'Fruits',
    SUM(MntFruits),
    ROUND(AVG(MntFruits), 2)
FROM customers

UNION ALL

SELECT
    'Meat',
    SUM(MntMeatProducts),
    ROUND(AVG(MntMeatProducts), 2)
FROM customers

UNION ALL

SELECT
    'Fish',
    SUM(MntFishProducts),
    ROUND(AVG(MntFishProducts), 2)
FROM customers

UNION ALL

SELECT
    'Sweets',
    SUM(MntSweetProducts),
    ROUND(AVG(MntSweetProducts), 2)
FROM customers

UNION ALL

SELECT
    'Gold',
    SUM(MntGoldProds),
    ROUND(AVG(MntGoldProds), 2)
FROM customers;


-- ============================================================
-- 5. Channel-performance view
-- ============================================================

CREATE OR REPLACE VIEW vw_channel_performance AS

SELECT
    'Web' AS Channel,
    SUM(NumWebPurchases) AS Total_Purchases,
    ROUND(AVG(NumWebPurchases), 2) AS Average_Purchases
FROM customers

UNION ALL

SELECT
    'Catalog',
    SUM(NumCatalogPurchases),
    ROUND(AVG(NumCatalogPurchases), 2)
FROM customers

UNION ALL

SELECT
    'Store',
    SUM(NumStorePurchases),
    ROUND(AVG(NumStorePurchases), 2)
FROM customers;


-- ============================================================
-- 6. Customer-value performance view
-- ============================================================

CREATE OR REPLACE VIEW vw_customer_value_performance AS

SELECT
    Customer_Value_Segment,
    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    SUM(Total_Spend) AS Total_Spending,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate,
    ROUND(
        AVG(Total_Accepted_Campaigns),
        2
    ) AS Average_Accepted_Campaigns
FROM customers
GROUP BY Customer_Value_Segment;


-- ============================================================
-- 7. Ideal-target customer view
-- ============================================================

CREATE OR REPLACE VIEW vw_ideal_target_customers AS

SELECT
    ID,
    Age,
    Age_Group,
    Income,
    Income_Band,
    Country,
    Education_Group,
    Relationship_Group,
    Has_Children,
    Total_Spend,
    Total_Purchases,
    Preferred_Channel,
    Total_Accepted_Campaigns,
    Response
FROM customers
WHERE Ideal_Target_Customer = 1;


-- ============================================================
-- 8. Under-served customer view
-- ============================================================

CREATE OR REPLACE VIEW vw_under_served_customers AS

SELECT
    ID,
    Age,
    Age_Group,
    Income,
    Income_Band,
    Country,
    Education_Group,
    Relationship_Group,
    Total_Spend,
    Total_Purchases,
    NumWebVisitsMonth,
    NumWebPurchases,
    Preferred_Channel,
    Response
FROM customers
WHERE Under_Served_Customer = 1;


-- ============================================================
-- 9. Verify all reporting views
-- ============================================================

SHOW FULL TABLES
WHERE Table_Type = 'VIEW';


-- ============================================================
-- 10. Test the views
-- ============================================================

SELECT *
FROM vw_executive_kpis;

SELECT *
FROM vw_country_performance
ORDER BY Response_Rate DESC;

SELECT *
FROM vw_campaign_performance
ORDER BY Acceptance_Rate DESC;

SELECT *
FROM vw_product_performance
ORDER BY Total_Spending DESC;

SELECT *
FROM vw_channel_performance
ORDER BY Total_Purchases DESC;

SELECT *
FROM vw_customer_value_performance
ORDER BY Average_Spend DESC;

SELECT COUNT(*) AS Ideal_Target_Customers
FROM vw_ideal_target_customers;

SELECT COUNT(*) AS Under_Served_Customers
FROM vw_under_served_customers;