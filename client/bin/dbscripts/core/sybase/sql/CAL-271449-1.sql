if not exists (select 1 from sysobjects where type='U' and name='scenario_quoted_product')
begin
exec ('create table scenario_quoted_product (product_name varchar(64) not null, pricer_params varchar(128) null,pricer_measure  varchar(128) not null)')
end
go
add_column_if_not_exists 'pl_position','max_settle_date','datetime null'
go
add_column_if_not_exists 'risk_presenter_item','saved_output','numeric null'
go
add_column_if_not_exists 'risk_on_demand_item','saved_output','numeric null'
go
select position_id , max(settle_date) as settle_date into aux0
from trade_open_qty where product_family not in ('Repo','SecurityLending') group by position_id
union all select position_id, max(settle_date)
from trade_openqty_hist where product_family not in ('Repo','SecurityLending') group by position_id
go

select position_id, max(settle_date) as max_settle_date into aux from aux0 group by position_id
go

update pl_position set max_settle_date = (select aux.max_settle_date from aux where aux.position_id = pl_position.position_id)
go
drop table aux0
go
drop table aux
go
/* begin */
if exists (select 1 from sysobjects where type='P' and name ='update_trade')
begin
drop procedure update_trade
end
go
CREATE PROCEDURE update_trade
AS
BEGIN

declare @final_valuation_date datetime
declare @product_id numeric
declare c1 cursor
for
select product_id, update_date_time from trade where exists ( select product_id from trade where trade_status = 'CANCELED'
group by product_id having count(product_id) < 2 ) and trade_status = 'CANCELED'
and update_date_time is not null
open c1
fetch c1 into @product_id , @final_valuation_date
while (@@sqlstatus = 0)
begin
update product_desc set final_valuation_date=@final_valuation_date
where product_id=@product_id and product_id in (select product_id from trade where trade_status = 'CANCELED' and update_date_time is not null 
group by product_id having count(product_id) < 2)   
fetch c1 into @product_id , @final_valuation_date
end
close c1
deallocate cursor c1
end
go
exec update_trade
go
drop procedure update_trade
go
/* end */
add_domain_values 'scheduledTask', 'CHAIN', '' 
go

update scenario_quoted_product set pricer_params='MMKT_FROM_QUOTE' where product_name='BondMMDiscount' 
go
update scenario_quoted_product set pricer_params='MMKT_FROM_QUOTE' where product_name='BondMMDiscountAUD'
go
update scenario_quoted_product set pricer_params='MMKT_FROM_QUOTE' where product_name='BondMMInterest'
go
update scenario_quoted_product set pricer_measure = 'VOLATILITY_SPREAD' where product_name not like '%Dividend%' and pricer_measure = 'IMPLIEDVOLATILITY'
go
update scenario_quoted_product set pricer_measure = 'PLXG' where product_name='PerformanceSwap' or product_name='BondOption'
go
UPDATE scenario_quoted_product SET pricer_measure='VOLATILITY_SPREAD' WHERE product_name='Warrant'
go
sp_rename risk_presenter_item, risk_presenter_item_back141
go
sp_rename risk_on_demand_item, risk_on_demand_item_back141
go
select * into  risk_presenter_item from risk_presenter_item_back141
go
select * into  risk_on_demand_item from risk_on_demand_item_back141
go
delete from risk_presenter_item where output_id > 0 and output_id not in (
select max(output_id) from risk_presenter_item GROUP BY analysis_name, trade_filter_name, param_name, pricing_env_name having max(output_id)>0)
go       
add_column_if_not_exists 'risk_presenter_item','saved_output','numeric null'
go
update risk_presenter_item set output_id = 0, saved_output=1 where output_id > 0
go
delete from risk_on_demand_item where output_id > 0 and output_id not in (select max(output_id) from risk_on_demand_item group by analysis_name, trade_filter_name, param_name, pricing_env_name having max(output_id)>0)
go
update risk_on_demand_item set output_id = 0, saved_output=1 where output_id > 0
go

 
exec drop_unique_if_exists 'strategy' 
go

 