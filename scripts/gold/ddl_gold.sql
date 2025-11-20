

CREATE VIEW gold.dim_customers as
SELECT 
DISTINCT ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
ci.cst_marital_status as marital_status,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
     ELSE COALESCE(ca.gen ,'n/a')
END as gender,
ci.cst_create_date as create_date,
ca.bdate as birthdate,
la.cntry as country
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON (ci.cst_key =ca.cid)
LEFT JOIN  silver.erp_loc_a101 la
ON        (  ca.cid = la.cid)

-------------------------------------------------
-------------------------------------------------
CREATE VIEW gold.fact_sales as
SELECT 
 sd.sls_ord_num as order_number,
 --pr.product_key,
 --cu.customer_key,
 sd.sls_prd_key,
 sd.sls_cust_id,
 sd.sls_order_dt as order_date,
 sd.sls_ship_dt as shipping_date,
 sd.sls_due_dt as due_date ,
 sd.sls_sales as sales_amount,
 sd.sls_quantity as quantity,
 sd.sls_price
 FROM silver.crm_sales_details sd
 LEFT JOIN gold.dim_products pr
 ON sd.sls_prd_key = pr.product_number
 LEFT JOIN gold.dim_customers cu
 ON  sd.sls_cust_id = cu.customer_id

--------------------------------------------------
--------------------------------------------------
CREATE VIEW gold.fact_sales as
SELECT 
 sd.sls_ord_num as order_number,
 pr.product_id,
 cu.customer_id,
 sd.sls_prd_key,
 sd.sls_cust_id,
 sd.sls_order_dt as order_date,
 sd.sls_ship_dt as shipping_date,
 sd.sls_due_dt as due_date ,
 sd.sls_sales as sales_amount,
 sd.sls_quantity as quantity,
 sd.sls_price
 FROM silver.crm_sales_details sd
 LEFT JOIN gold.dim_products pr
 ON sd.sls_prd_key = pr.product_number
 LEFT JOIN gold.dim_customers cu
 ON  sd.sls_cust_id = cu.customer_id

