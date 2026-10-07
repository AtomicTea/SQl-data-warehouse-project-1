/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer contains the final dimension and fact views that form the
    analytical Star Schema.

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset for analytics and reporting.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

/* ***************************************************** FACT tables ***********************************************/
-- DROP EXISTING VIEW
DROP VIEW IF EXISTS dwport1_gold.fact_sales;

-- CREATE THE fact_sales VIEW
CREATE VIEW dwport1_gold.fact_sales AS
SELECT 
sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sls_order_dt AS order_date,
sls_ship_dt AS shipping_date,
sls_due_dt AS due_date,
sls_sales AS sales_amount,
sls_quantity AS quantity,
sls_price AS price
FROM dwport1_silver.crm_sales_details AS sd
LEFT JOIN dwport1_gold.dim_products AS pr ON sd.sls_prd_key = pr.product_number
LEFT JOIN dwport1_gold.dim_customers AS cu ON sd.sls_cust_id = cu.customer_id
;

/* ***************************************************** DIM Tables ************************************************/
-- DROP EXISTING VIEW
DROP VIEW IF EXISTS dwport1_gold.dim_products;

-- CREATE THE dim_products VIEW
CREATE VIEW dwport1_gold.dim_products AS
/* Collect all necessary product information from the source systems */
SELECT
ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, 
pn.prd_id AS product_id,
pn.prd_key AS product_number,
pn.prd_nm AS product_name,
pn.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pc.maintenance AS maintenance,
pn.prd_cost AS cost,
pn.prd_line AS product_line,
pn.prd_start_dt AS start_date
FROM dwport1_silver.crm_prd_info AS pn
LEFT JOIN dwport1_silver.erp_px_cat_g1v2 AS pc ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filters out historical data. If end date is Null, it is currently a product.



  
-- DROP EXISTING VIEW
DROP VIEW IF EXISTS dwport1_gold.dim_customers;

-- CREATE THE dim_customers VIEW
CREATE VIEW dwport1_gold.dim_customers AS
-- Collect all necessary customer information from the source systems 
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
    la.cntry AS country,
	ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr NOT IN ('n/a','Unknown') THEN ci.cst_gndr -- CRM is the master for gender info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date    
FROM dwport1_silver.crm_cust_info AS ci
LEFT JOIN dwport1_silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
LEFT JOIN dwport1_silver.erp_loc_a101 AS la ON ci.cst_key = la.cid
;
 


