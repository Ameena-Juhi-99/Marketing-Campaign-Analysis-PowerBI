-- ============================================================
-- PROJECT: Marketing Campaign Analysis
-- FILE: 02_data_load_and_verification.sql
-- PURPOSE: Validate the customer data loaded into MySQL
-- AUTHOR: Ameena Juhi
-- ============================================================

USE marketing_campaign_db;

-- ============================================================
-- 1. Verify total and unique customer records
-- ============================================================

SELECT
    COUNT(*) AS Total_Customers,
    COUNT(DISTINCT ID) AS Unique_Customers
FROM customers;


-- ============================================================
-- 2. Check for duplicate customer IDs
-- Expected result: no rows
-- ============================================================

SELECT
    ID,
    COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY ID
HAVING COUNT(*) > 1;


-- ============================================================
-- 3. Check important fields for missing values
-- ============================================================

SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END)
        AS Missing_IDs,

    SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END)
        AS Missing_Income,

    SUM(CASE WHEN Dt_Customer IS NULL THEN 1 ELSE 0 END)
        AS Missing_Enrollment_Dates,

    SUM(CASE WHEN Total_Spend IS NULL THEN 1 ELSE 0 END)
        AS Missing_Total_Spend,

    SUM(CASE WHEN Total_Purchases IS NULL THEN 1 ELSE 0 END)
        AS Missing_Total_Purchases
FROM customers;


-- ============================================================
-- 4. Validate important numerical ranges
-- ============================================================

SELECT
    MIN(Age) AS Minimum_Age,
    MAX(Age) AS Maximum_Age,

    MIN(Income) AS Minimum_Income,
    MAX(Income) AS Maximum_Income,

    MIN(Total_Spend) AS Minimum_Total_Spend,
    MAX(Total_Spend) AS Maximum_Total_Spend,

    MIN(Total_Purchases) AS Minimum_Total_Purchases,
    MAX(Total_Purchases) AS Maximum_Total_Purchases
FROM customers;


-- ============================================================
-- 5. Validate customer enrollment-date range
-- ============================================================

SELECT
    MIN(Dt_Customer) AS Earliest_Enrollment_Date,
    MAX(Dt_Customer) AS Latest_Enrollment_Date
FROM customers;


-- ============================================================
-- 6. Check campaign and complaint binary values
-- Expected ranges: 0 to 1
-- ============================================================

SELECT
    MIN(Response) AS Minimum_Response,
    MAX(Response) AS Maximum_Response,

    MIN(Complain) AS Minimum_Complain,
    MAX(Complain) AS Maximum_Complain
FROM customers;


-- ============================================================
-- 7. Check income-outlier flags
-- ============================================================

SELECT
    Income_Outlier_Flag,
    COUNT(*) AS Customers
FROM customers
GROUP BY Income_Outlier_Flag
ORDER BY Customers DESC;


-- ============================================================
-- 8. Preview five imported customer records
-- ============================================================

SELECT *
FROM customers
LIMIT 5;