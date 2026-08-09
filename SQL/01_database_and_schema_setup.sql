-- ============================================================
-- PROJECT: Marketing Campaign Analysis
-- FILE: 01_database_and_schema_setup.sql
-- PURPOSE: Create the project database and customer table
-- AUTHOR: Ameena Juhi
-- ============================================================

-- Create the project database if it does not already exist
CREATE DATABASE IF NOT EXISTS marketing_campaign_db;

-- Select the project database
USE marketing_campaign_db;

-- Create the main customer table
CREATE TABLE IF NOT EXISTS customers (

    -- Customer identifier
    ID BIGINT PRIMARY KEY,

    -- Customer demographic information
    Year_Birth SMALLINT NOT NULL,
    Education VARCHAR(30) NOT NULL,
    Marital_Status VARCHAR(30) NOT NULL,
    Income DECIMAL(12, 2) NOT NULL,
    Kidhome TINYINT UNSIGNED NOT NULL,
    Teenhome TINYINT UNSIGNED NOT NULL,
    Dt_Customer DATE NOT NULL,
    Recency SMALLINT UNSIGNED NOT NULL,

    -- Product spending
    MntWines INT UNSIGNED NOT NULL,
    MntFruits INT UNSIGNED NOT NULL,
    MntMeatProducts INT UNSIGNED NOT NULL,
    MntFishProducts INT UNSIGNED NOT NULL,
    MntSweetProducts INT UNSIGNED NOT NULL,
    MntGoldProds INT UNSIGNED NOT NULL,

    -- Purchase-channel activity
    NumDealsPurchases SMALLINT UNSIGNED NOT NULL,
    NumWebPurchases SMALLINT UNSIGNED NOT NULL,
    NumCatalogPurchases SMALLINT UNSIGNED NOT NULL,
    NumStorePurchases SMALLINT UNSIGNED NOT NULL,
    NumWebVisitsMonth SMALLINT UNSIGNED NOT NULL,

    -- Marketing campaign indicators
    AcceptedCmp3 TINYINT UNSIGNED NOT NULL,
    AcceptedCmp4 TINYINT UNSIGNED NOT NULL,
    AcceptedCmp5 TINYINT UNSIGNED NOT NULL,
    AcceptedCmp1 TINYINT UNSIGNED NOT NULL,
    AcceptedCmp2 TINYINT UNSIGNED NOT NULL,
    Response TINYINT UNSIGNED NOT NULL,
    Complain TINYINT UNSIGNED NOT NULL,

    -- Geographic information
    Country VARCHAR(50) NOT NULL,

    -- Cleaned categorical features
    Education_Group VARCHAR(30) NOT NULL,
    Relationship_Status VARCHAR(30) NOT NULL,
    Income_Outlier_Flag VARCHAR(15) NOT NULL,

    -- Customer age and tenure features
    Age SMALLINT UNSIGNED NOT NULL,
    Customer_Tenure_Days INT UNSIGNED NOT NULL,
    Customer_Tenure_Months DECIMAL(8, 2) NOT NULL,

    -- Family features
    Total_Children TINYINT UNSIGNED NOT NULL,
    Has_Children VARCHAR(3) NOT NULL,

    -- Spending and purchase features
    Total_Spend INT UNSIGNED NOT NULL,
    Total_Purchases SMALLINT UNSIGNED NOT NULL,
    Preferred_Channel VARCHAR(20) NOT NULL,

    -- Campaign-performance features
    Historical_Accepted_Campaigns TINYINT UNSIGNED NOT NULL,
    Total_Accepted_Campaigns TINYINT UNSIGNED NOT NULL,
    Campaign_Acceptance_Rate DECIMAL(6, 4) NOT NULL,

    -- Customer grouping features
    Age_Group VARCHAR(20) NOT NULL,
    Income_Band VARCHAR(30) NOT NULL,
    Relationship_Group VARCHAR(30) NOT NULL,
    Spending_Segment VARCHAR(30) NOT NULL,
    Purchase_Frequency VARCHAR(30) NOT NULL,
    Customer_Value_Segment VARCHAR(30) NOT NULL,

    -- Required and strategic segmentation flags
    High_Income_Customer TINYINT UNSIGNED NOT NULL,
    Young_Customer TINYINT UNSIGNED NOT NULL,
    Campaign_Responder TINYINT UNSIGNED NOT NULL,
    High_Web_Engagement TINYINT UNSIGNED NOT NULL,
    Family_Customer TINYINT UNSIGNED NOT NULL,
    High_Spender TINYINT UNSIGNED NOT NULL,
    Loyal_Customer TINYINT UNSIGNED NOT NULL,
    Deal_Hunter TINYINT UNSIGNED NOT NULL,
    Under_Served_Customer TINYINT UNSIGNED NOT NULL,
    Ideal_Target_Customer TINYINT UNSIGNED NOT NULL,

    -- Constraints for binary indicator fields
    CONSTRAINT chk_response
        CHECK (Response IN (0, 1)),

    CONSTRAINT chk_complain
        CHECK (Complain IN (0, 1)),

    CONSTRAINT chk_has_children
        CHECK (Has_Children IN ('Yes', 'No')),

    CONSTRAINT chk_positive_income
        CHECK (Income >= 0),

    CONSTRAINT chk_positive_spending
        CHECK (Total_Spend >= 0)
);