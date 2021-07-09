 

begin
add_column_if_not_exists ('pl_position','max_settle_date','timestamp null');
end;
/
begin
add_column_if_not_exists ('risk_presenter_item','saved_output','number null');
end;
/
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('scenario_quoted_product') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table scenario_quoted_product (product_name varchar2(64) not null, pricer_params varchar2(128) null,pricer_measure  varchar2(128) not null)' ;
END IF;
End ;
/

/* new tuned sql */

create table aux0 parallel nologging as select /*+parallel*/ position_id, max(settle_date) as max_settle_date 
from trade_open_qty where product_family not in ('Repo','SecurityLending') group by position_id
union all select /*+parallel*/ position_id, max(settle_date) as max_settle_date 
from trade_openqty_hist where product_family not in ('Repo','SecurityLending') group by position_id
;
create table aux parallel nologging as (select position_id, max(max_settle_date) as max_settle_date from aux0 group by position_id)
;
merge into pl_position USING aux on (aux.position_id = pl_position.position_id)
when matched then update set max_settle_date = aux.max_settle_date
;
drop table aux0
;
drop table aux
;

/* begin */

create table t1 nologging
as select  /*+ parallel(8) */ product_id from trade where trade_status = 'CANCELED' and update_date_time is not null 
group by product_id having count(product_id) < 2 
;

MERGE INTO product_desc a1
USING
(
select product_id, update_date_time from trade 
where product_id in ( select product_id from t1) 
and trade_status = 'CANCELED' and update_date_time is not null ) t2
ON (a1.product_id = t2.product_id)
WHEN MATCHED THEN UPDATE SET
a1.final_valuation_date = t2.update_date_time
;

drop table t1
;

/* end */
update scenario_quoted_product set pricer_params='MMKT_FROM_QUOTE' where product_name='BondMMDiscount' 
;
update scenario_quoted_product set pricer_params='MMKT_FROM_QUOTE' where product_name='BondMMDiscountAUD'
;
update scenario_quoted_product set pricer_params='MMKT_FROM_QUOTE' where product_name='BondMMInterest'
;
update scenario_quoted_product set pricer_measure = 'VOLATILITY_SPREAD' where product_name not like '%Dividend%' and pricer_measure = 'IMPLIEDVOLATILITY'
;
update scenario_quoted_product set pricer_measure = 'PLXG' where product_name='PerformanceSwap' or product_name='BondOption'
;
UPDATE scenario_quoted_product SET pricer_measure='VOLATILITY_SPREAD' WHERE product_name='Warrant'
; 
rename risk_presenter_item to risk_presenter_item_back141
;
create table risk_presenter_item as select * from risk_presenter_item_back141
;
rename risk_on_demand_item to risk_on_demand_item_back141
;
create table risk_on_demand_item as select * from risk_on_demand_item_back141
;
delete from risk_presenter_item where output_id > 0 and output_id not in (
select max(output_id) from risk_presenter_item GROUP BY analysis_name, trade_filter_name, param_name, pricing_env_name having max(output_id)>0)
;       
begin
add_column_if_not_exists ('risk_on_demand_item','saved_output','number null');
end;
/
update risk_presenter_item set output_id = 0, saved_output=1 where output_id > 0
;
delete from risk_on_demand_item where output_id > 0 and output_id not in (select max(output_id) from risk_on_demand_item group by analysis_name, trade_filter_name, param_name, pricing_env_name having max(output_id)>0)
;
update risk_on_demand_item set output_id = 0, saved_output=1 where output_id > 0
;
 
begin
drop_unique_if_exists ('strategy');
end; 
/

