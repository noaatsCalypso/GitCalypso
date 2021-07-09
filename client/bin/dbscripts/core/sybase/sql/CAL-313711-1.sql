-- ########################################################################## ORACLE ################################################################
select pl_config_id, valuation_date into temp_opl_latest_dates from official_pl_mark where 1=2
go

-- These are the dates the update proc will work with
-- Insert the MOST RECENT dates for each pl-config
insert into temp_opl_latest_dates (pl_config_id, valuation_date)
select pl_config_id, max(valuation_date) valuation_date from official_pl_mark group by pl_config_id
go 

/*
 * populatte effective product type - try subproduct type first
 */
 
update official_pl_mark set official_pl_mark.effective_product_type = b.subproduct_type 
from 
temp_opl_latest_dates dt,official_pl_bucket b
where official_pl_mark.pl_config_id = dt.pl_config_id
        and official_pl_mark.valuation_date = dt.valuation_date
        and     official_pl_mark.pl_bucket_id = b.pl_bucket_id
        and official_pl_mark.effective_product_type=' '
        and     b.subproduct_type is not null
go

	
/*
 * populate effective product type - then try product type next
 */
update official_pl_mark  SET official_pl_mark.effective_product_type = a.prod_type
FROM  official_trade_attrs a, temp_opl_latest_dates dt
        where   official_pl_mark.mark_id = a.mark_id
        and official_pl_mark.pl_config_id = dt.pl_config_id
        and official_pl_mark.valuation_date = dt.valuation_date
        and official_pl_mark.effective_product_type=' '
        and a.prod_type is not null       
go	

drop table temp_opl_latest_dates
go
