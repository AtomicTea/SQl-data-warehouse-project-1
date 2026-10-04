/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    * This script creates tables in the 'Silver' schema, dropping existing tables 
    if they already exist.
	* Run this script to create or re-define the DDL structure of the Silver
    tables that receive transformed data from the Bronze layer.
===============================================================================
*/
DROP TABLE IF EXISTS dwport1_silver.crm_sales_details;
CREATE TABLE dwport1_silver.crm_sales_details (
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwport1_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS dwport1_silver.crm_cust_info;
CREATE TABLE  dwport1_silver.crm_cust_info(
cst_id INT,
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_date DATE, 
dwport1_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS dwport1_silver.crm_prd_info;  
CREATE TABLE dwport1_silver.crm_prd_info (
prd_id INT,
cat_id  VARCHAR(50),
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwport1_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS dwport1_silver.erp_cust_az12;
CREATE TABLE dwport1_silver.erp_cust_az12 (
cid VARCHAR(50),
bdate DATE,
gen VARCHAR(50),
dwport1_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS dwport1_silver.erp_loc_a101;
CREATE TABLE dwport1_silver.erp_loc_a101 (
cid VARCHAR(50),
cntry VARCHAR(50),
dwport1_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS dwport1_silver.erp_px_cat_g1v2; 
CREATE TABLE dwport1_silver.erp_px_cat_g1v2 (
id VARCHAR(50),
cat VARCHAR(50),
subcat VARCHAR(50),
maintenance VARCHAR(50),
dwport1_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);




