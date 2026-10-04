/*
===============================================================================
Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This procedure loads data into the 'Silver' schema from the Bronze layer. 
    It performs the following actions:
     * Truncates the Silver tables before loading new data. 
     * Extracts data from the Bronze tables.
     * Cleans, standardizes and transforms the data as needed.
     * Uses the 'INSERT INTO' command to load transformed data into the corresponding Silver tables.
     * Handles SQL exceptions by stopping execution and returning the
       original error to the caller.

===============================================================================

How to run: 
	* CALL  dwport1_silver.load_dwport1_silver();
*/


/* ************************* Beginning of full procedure ********************************* */
DROP PROCEDURE IF EXISTS load_dwport1_silver;
DELIMITER $$

CREATE PROCEDURE load_dwport1_silver()
BEGIN
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

/* ******************** CRM_CUST_INFO ****************** */
/* ****************** INSERT statement cust_info ************************ */
TRUNCATE TABLE dwport1_silver.crm_cust_info;
INSERT INTO dwport1_silver.crm_cust_info(
	cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
/* ****************** Main query Cust_info CLEANED************************ */
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
     WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
     ELSE 'Unknown'
END cst_marital_status, -- Normalize marital status values to readable format
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
     WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
     ELSE 'Unknown'
END cst_gndr, -- Normalize gender values to readable format
cst_create_date
FROM (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM dwport1_bronze.crm_cust_info
    WHERE cst_id IS NOT NULL AND cst_id !=0) AS t
WHERE flag_last = 1; -- Select the most recent record per customer


/* ******************** CRM_PRD_INFO ****************** */
/* ****************** INSERT statement crm_prd_info ************************ */
TRUNCATE TABLE dwport1_silver.crm_prd_info;
INSERT INTO dwport1_silver.crm_prd_info(
	prd_id,
    cat_id,
    prd_key,
    prd_nm, 
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
/* ****************** Main query crm_prd_info CLEANED************************ */

SELECT 
	prd_id,
    -- prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-','_' )AS cat_id,
    SUBSTRING(prd_key, 7) AS prd_key,
    prd_nm,
    prd_cost,
    -- prd_line,
    CASE UPPER(TRIM(prd_line)) 
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE  'n/a'
	END AS prd_line,
    -- Getting rid of blank time info
    DATE(prd_start_dt) AS prd_start_dt,
    -- Getting rid of blank time info and fixing date issues
   DATE(
    DATE_SUB(
		LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY
        )
        ) AS prd_end_dt
FROM dwport1_bronze.crm_prd_info;



/* ******************** CRM_SALES_DETAILS ****************** */
/* ****************** INSERT statement crm_sales_details ************************ */
TRUNCATE TABLE dwport1_silver.crm_sales_details;
INSERT INTO dwport1_silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
/* ****************** Main query crm_prd_info CLEANED ************************ */

/* Assumed business rules:
If Sales is negative, zero or null, derive it using Quantity and Price.
If Price is zero or null, calculate it using Sales and Quantity.
If Price is negative, convert it to a positive value.
*/
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
-- sls_order_dt,
	CASE WHEN sls_order_dt <= 0 OR lENGTH(sls_order_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
	END AS sls_order_dt,
-- FIND SHIP DATE
	CASE WHEN sls_ship_dt <= 0 OR lENGTH(sls_ship_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
	END AS sls_ship_dt,
-- sls_due_dt,
	CASE WHEN sls_due_dt <=    0 OR lENGTH(sls_due_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
	END AS sls_due_dt,
-- FIND SALES
	CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
sls_quantity,
sls_price

FROM (
SELECT
  sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
-- FIND PRICE
	CASE WHEN sls_price IS NULL OR sls_price <= 0 
		THEN ROUND(sls_sales / NULLIF(sls_quantity,0),2)
		ELSE ROUND(sls_price,2)
	END AS sls_price
FROM dwport1_bronze.crm_sales_details
) AS cleaned
;

/* ******************** ERP_CUST_AZ12 ****************** */
/* ****************** INSERT statement erp_cust_az12 ************************ */
TRUNCATE TABLE dwport1_silver.erp_cust_az12;
INSERT INTO dwport1_silver.erp_cust_az12(
cid,
bdate,
gen)
/* ************************ Main Query erp_cust_az12 CLEANED ***************** */
SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LENGTH(CID))
	ELSE cid
	END AS cid,
CASE WHEN bdate > CURRENT_DATE() THEN NULL
	ELSE bdate
	END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'
    END AS gen
FROM dwport1_bronze.erp_cust_az12
;


/* ******************** ERP_LOC_A101 ****************** */
/* ****************** INSERT statement erp_loc_a101 ************************ */
TRUNCATE TABLE dwport1_silver.erp_loc_a101;

INSERT INTO dwport1_silver.erp_loc_a101(
cid,
cntry
)
/* ****************** Main query erp_loc_a101 CLEANED ************************ */
SELECT 
REPLACE(cid, '-', '') AS cid,
CASE 	WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
END AS cntry

FROM dwport1_bronze.erp_loc_a101 
;
  
  
  
/* ********************ERP_PX_CAT_G1V2 ****************** */
/* ****************** INSERT statement erp_px_cat_g1v2 ************************ */
TRUNCATE TABLE dwport1_silver.erp_px_cat_g1v2;

INSERT INTO dwport1_silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintenance
) 
/* **************************** Main Query erp_px_cat_g1v2 CLEANED *************** */
SELECT 
    id, 
    cat, 
    subcat, 
    maintenance
FROM
    dwport1_bronze.erp_px_cat_g1v2
;

END $$

DELIMITER ;
