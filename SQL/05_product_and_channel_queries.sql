-- ============================================================
-- PROJECT: Marketing Campaign Analysis
-- FILE: 05_product_and_channel_queries.sql
-- PURPOSE: Analyze products, purchase channels and opportunities
-- AUTHOR: Ameena Juhi
-- ============================================================

USE marketing_campaign_db;


-- ============================================================
-- 1. Rank product categories by total spending
-- Demonstrates a CTE and UNION ALL
-- ============================================================

WITH product_performance AS (

    SELECT
        'Wine' AS Product,
        SUM(MntWines) AS Total_Spending,
        AVG(MntWines) AS Average_Spending
    FROM customers

    UNION ALL

    SELECT
        'Fruits',
        SUM(MntFruits),
        AVG(MntFruits)
    FROM customers

    UNION ALL

    SELECT
        'Meat',
        SUM(MntMeatProducts),
        AVG(MntMeatProducts)
    FROM customers

    UNION ALL

    SELECT
        'Fish',
        SUM(MntFishProducts),
        AVG(MntFishProducts)
    FROM customers

    UNION ALL

    SELECT
        'Sweets',
        SUM(MntSweetProducts),
        AVG(MntSweetProducts)
    FROM customers

    UNION ALL

    SELECT
        'Gold',
        SUM(MntGoldProds),
        AVG(MntGoldProds)
    FROM customers
)

SELECT
    Product,
    Total_Spending,
    ROUND(Average_Spending, 2) AS Average_Spending,
    ROUND(
        Total_Spending * 100.0 /
        SUM(Total_Spending) OVER (),
        2
    ) AS Spending_Share
FROM product_performance
ORDER BY Total_Spending DESC;


-- ============================================================
-- 2. Compare purchase-channel performance
-- ============================================================

WITH channel_performance AS (

    SELECT
        'Web' AS Channel,
        SUM(NumWebPurchases) AS Total_Purchases,
        AVG(NumWebPurchases) AS Average_Purchases
    FROM customers

    UNION ALL

    SELECT
        'Catalog',
        SUM(NumCatalogPurchases),
        AVG(NumCatalogPurchases)
    FROM customers

    UNION ALL

    SELECT
        'Store',
        SUM(NumStorePurchases),
        AVG(NumStorePurchases)
    FROM customers
)

SELECT
    Channel,
    Total_Purchases,
    ROUND(Average_Purchases, 2) AS Average_Purchases,
    ROUND(
        Total_Purchases * 100.0 /
        SUM(Total_Purchases) OVER (),
        2
    ) AS Purchase_Share
FROM channel_performance
ORDER BY Total_Purchases DESC;


-- ============================================================
-- 3. Preferred purchase channel
-- ============================================================

SELECT
    Preferred_Channel,
    COUNT(*) AS Customers,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS Customer_Share,

    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Preferred_Channel
ORDER BY Customers DESC;


-- ============================================================
-- 4. Channel behaviour of high-value customers
-- ============================================================

SELECT
    Customer_Value_Segment,
    COUNT(*) AS Customers,
    ROUND(AVG(NumWebPurchases), 2) AS Average_Web_Purchases,
    ROUND(AVG(NumCatalogPurchases), 2) AS Average_Catalog_Purchases,
    ROUND(AVG(NumStorePurchases), 2) AS Average_Store_Purchases,
    ROUND(AVG(NumDealsPurchases), 2) AS Average_Deal_Purchases,
    ROUND(AVG(NumWebVisitsMonth), 2) AS Average_Web_Visits,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Customer_Value_Segment
ORDER BY AVG(Total_Spend) DESC;


-- ============================================================
-- 5. Product preferences by customer-value segment
-- ============================================================

SELECT
    Customer_Value_Segment,
    COUNT(*) AS Customers,
    ROUND(AVG(MntWines), 2) AS Average_Wine_Spend,
    ROUND(AVG(MntFruits), 2) AS Average_Fruit_Spend,
    ROUND(AVG(MntMeatProducts), 2) AS Average_Meat_Spend,
    ROUND(AVG(MntFishProducts), 2) AS Average_Fish_Spend,
    ROUND(AVG(MntSweetProducts), 2) AS Average_Sweet_Spend,
    ROUND(AVG(MntGoldProds), 2) AS Average_Gold_Spend
FROM customers
GROUP BY Customer_Value_Segment
ORDER BY AVG(Total_Spend) DESC;


-- ============================================================
-- 6. Product preferences of ideal target customers
-- ============================================================

SELECT
    COUNT(*) AS Ideal_Target_Customers,
    ROUND(AVG(MntWines), 2) AS Average_Wine_Spend,
    ROUND(AVG(MntFruits), 2) AS Average_Fruit_Spend,
    ROUND(AVG(MntMeatProducts), 2) AS Average_Meat_Spend,
    ROUND(AVG(MntFishProducts), 2) AS Average_Fish_Spend,
    ROUND(AVG(MntSweetProducts), 2) AS Average_Sweet_Spend,
    ROUND(AVG(MntGoldProds), 2) AS Average_Gold_Spend
FROM customers
WHERE Ideal_Target_Customer = 1;


-- ============================================================
-- 7. Cross-selling opportunity indicators
-- These represent customers who spent on both categories.
-- They do not prove that products were bought in one transaction.
-- ============================================================

SELECT
    SUM(
        CASE
            WHEN MntWines > 0
                 AND MntMeatProducts > 0
            THEN 1 ELSE 0
        END
    ) AS Wine_And_Meat_Customers,

    SUM(
        CASE
            WHEN MntWines > 0
                 AND MntGoldProds > 0
            THEN 1 ELSE 0
        END
    ) AS Wine_And_Gold_Customers,

    SUM(
        CASE
            WHEN MntMeatProducts > 0
                 AND MntFishProducts > 0
            THEN 1 ELSE 0
        END
    ) AS Meat_And_Fish_Customers,

    SUM(
        CASE
            WHEN MntFruits > 0
                 AND MntSweetProducts > 0
            THEN 1 ELSE 0
        END
    ) AS Fruit_And_Sweet_Customers,

    SUM(
        CASE
            WHEN MntFishProducts > 0
                 AND MntGoldProds > 0
            THEN 1 ELSE 0
        END
    ) AS Fish_And_Gold_Customers
FROM customers;


-- ============================================================
-- 8. Digital-engagement opportunity
-- High website visits but comparatively low web purchasing
-- ============================================================

SELECT
    Age_Group,
    Income_Band,
    COUNT(*) AS Customers,
    ROUND(AVG(NumWebVisitsMonth), 2) AS Average_Web_Visits,
    ROUND(AVG(NumWebPurchases), 2) AS Average_Web_Purchases,
    ROUND(AVG(Total_Spend), 2) AS Average_Total_Spend,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
WHERE
    NumWebVisitsMonth > 5
    AND NumWebPurchases <= 2
GROUP BY
    Age_Group,
    Income_Band
HAVING COUNT(*) >= 50
ORDER BY
    Customers DESC,
    Average_Web_Visits DESC;


-- ============================================================
-- 9. Product spending by country
-- ============================================================

SELECT
    Country,
    SUM(MntWines) AS Wine_Spending,
    SUM(MntFruits) AS Fruit_Spending,
    SUM(MntMeatProducts) AS Meat_Spending,
    SUM(MntFishProducts) AS Fish_Spending,
    SUM(MntSweetProducts) AS Sweet_Spending,
    SUM(MntGoldProds) AS Gold_Spending,
    SUM(Total_Spend) AS Total_Spending
FROM customers
GROUP BY Country
ORDER BY Total_Spending DESC;


-- ============================================================
-- 10. Deal-purchase behaviour
-- ============================================================

SELECT
    CASE
        WHEN NumDealsPurchases = 0
            THEN 'No Deal Purchases'
        WHEN NumDealsPurchases BETWEEN 1 AND 2
            THEN 'Low Deal Usage'
        WHEN NumDealsPurchases BETWEEN 3 AND 5
            THEN 'Medium Deal Usage'
        ELSE 'High Deal Usage'
    END AS Deal_Usage_Group,

    COUNT(*) AS Customers,
    ROUND(AVG(Income), 2) AS Average_Income,
    ROUND(AVG(Total_Spend), 2) AS Average_Spend,
    ROUND(AVG(Total_Purchases), 2) AS Average_Purchases,
    ROUND(AVG(Response) * 100, 2) AS Response_Rate
FROM customers
GROUP BY Deal_Usage_Group
ORDER BY Average_Spend DESC;