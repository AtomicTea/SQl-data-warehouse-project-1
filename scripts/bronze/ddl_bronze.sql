/*
==================================================
DDL Script: Create Bronze Tables
==================================================
This script creates tables in the Bronze schema.

DROP TABLE will erase the previous version of the table before re-defining.
CREATE TABLE will define the DDL structure of Bronze tables.
*/

DROP TABLE IF EXISTS dwport1_bronze.crm_sales_details;
CREATE TABLE dwport1_bronze.crm_sales_details (
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);


DROP TABLE IF EXISTS dwport1_bronze.crm_cust_info;
CREATE TABLE  dwport1_bronze.crm_cust_info(
cst_id INT,
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_material_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_date date
);


DROP TABLE IF EXISTS dwport1_bronze.crm_prd_info;  
CREATE TABLE dwport1_bronze.crm_prd_info (
prd_id INT,
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
);


DROP TABLE IF EXISTS dwport1_bronze.erp_cust_az12;
CREATE TABLE dwport1_bronze.erp_cust_az12 (
cid VARCHAR(50),
bdate DATE,
gen VARCHAR(50)
);


DROP TABLE IF EXISTS dwport1_bronze.erp_loc_a101;
CREATE TABLE dwport1_bronze.erp_loc_a101 (
cid VARCHAR(50),
cntry VARCHAR(50)
);


DROP TABLE IF EXISTS dwport1_bronze.erp_px_cat_g1v2; 
CREATE TABLE dwport1_bronze.erp_px_cat_g1v2 (
id VARCHAR(50),
cat VARCHAR(50),
subcat VARCHAR(50),
maintenance VARCHAR(50)
);


