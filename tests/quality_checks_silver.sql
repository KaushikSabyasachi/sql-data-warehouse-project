-- Quality Checks
-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT prd_id , COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 OR prd_id IS NULL

--Check for unwanted Spaces
--Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info

--CHECK FOR UNWANTED SPACES
--Exception: No Results
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for NULLS or Negative Number
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

--Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT *
FROM silver.crm_prd_info

SELECT 
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <=0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt > 19000101

-- Check for Invalid Date Orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--Check Data Consistency: Between Sales , Quantity , and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL , ZERO ,or negative.

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)

      THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
END  AS sls_sales,
CASE WHEN sls_price IS NULL  OR sls_price <= 0
     then sls_sales /NULLIF(sls_quantity ,0)
    ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity ,sls_price







