-- ########################################################################## ORACLE ################################################################
create table temp_opl_latest_dates 
as select pl_config_id, valuation_date from official_pl_mark where 1=2
;

-- These are the dates the update proc will work with
-- Insert the MOST RECENT dates for each pl-config
insert into temp_opl_latest_dates (pl_config_id, valuation_date)
select pl_config_id, max(valuation_date) valuation_date from official_pl_mark group by pl_config_id
;

/*
 * populatte effective product type - try subproduct type first
 */
MERGE
INTO    official_pl_mark trg
USING   (
        SELECT  m.mark_id, b.SUBPRODUCT_TYPE
        FROM    official_pl_mark m,
                temp_opl_latest_dates dt,
                official_pl_bucket b
        where   m.pl_config_id = dt.pl_config_id
        and m.valuation_date = dt.valuation_date
        and     m.pl_bucket_id = b.pl_bucket_id
        and m.effective_product_type=' '
        and     b.SUBPRODUCT_TYPE is not null
        ) src
ON      (trg.mark_id = src.mark_id)
WHEN MATCHED THEN UPDATE
    SET trg.EFFECTIVE_PRODUCT_TYPE = src.SUBPRODUCT_TYPE
;
	
	
/*
 * populate effective product type - then try product type next
 */
MERGE
INTO    official_pl_mark trg
USING   (
        SELECT  a.mark_id, a.prod_type 
        FROM    official_pl_mark m,
                official_trade_attrs a,
                temp_opl_latest_dates dt
        where   m.mark_id = a.mark_id
        and m.pl_config_id = dt.pl_config_id
        and m.valuation_date = dt.valuation_date
        and m.effective_product_type=' '
        and a.prod_type is not null
        ) src
ON      (trg.mark_id = src.mark_id)
WHEN MATCHED THEN UPDATE
    SET trg.EFFECTIVE_PRODUCT_TYPE = src.prod_type
;	

DROP TABLE temp_opl_latest_dates
;
