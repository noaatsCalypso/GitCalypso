
create table aux0 parallel nologging as
select /*+parallel*/ position_id,
                     max(entered_date) as max_entered_date,
                     min(case when is_liquidable = 0 then settle_date else null end) as min_nonliq_settle_date
from trade_open_qty group by position_id
union all
select /*+parallel*/ position_id,
                     max(entered_date) as max_entered_date,
                     min(case when is_liquidable = 0 then settle_date else null end) as min_nonliq_settle_date
from trade_openqty_hist group by position_id
;

create table aux parallel nologging as
select position_id,
      max(max_entered_date) as max_entered_date,
      min(min_nonliq_settle_date) as min_nonliq_settle_date
from aux0 group by position_id
;


begin
add_column_if_not_exists ('pl_position','last_updated_time','timestamp');
end;
/
begin
add_column_if_not_exists ('pl_position','last_batch_liq_time','timestamp');
end;
/
begin
add_column_if_not_exists ('pl_position','next_liquidation_time','timestamp');
end;
/



merge into pl_position USING aux on (aux.position_id = pl_position.position_id)
when matched then update
    set last_updated_time = aux.max_entered_date
    where last_updated_time is null
;


merge into pl_position USING aux on (aux.position_id = pl_position.position_id)
when matched then update
    set last_batch_liq_time = aux.max_entered_date -1/24/60/60 /* -1 second */
    where last_batch_liq_time is null
;


merge into pl_position USING aux on (aux.position_id = pl_position.position_id)
when matched then update
    set next_liquidation_time = current_timestamp at time zone (select ref_time_zone from calypso_info) /* now */
    where next_liquidation_time is null and aux.min_nonliq_settle_date is not null
;

drop table aux0
;

drop table aux
; 


update an_param_items set attribute_value='Weight' where attribute_value='Beta' and param_name 
in (select param_name from an_param_items where attribute_value='Beta' AND param_name 
in(SELECT param_name FROM AN_PARAM_ITEMS where attribute_name='MktType' AND attribute_value='Commodity'))
;
CREATE OR REPLACE PROCEDURE add_scnro_qtd_prd (pname IN varchar2, pparams in varchar2, pmeasure in varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM scenario_quoted_product WHERE product_name= pname and pricer_params= pparams;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
  if x = 0 then
        execute immediate 'insert into scenario_quoted_product (product_name, pricer_params, pricer_measure) 
		values ('||chr(39)||pname||chr(39)||','||chr(39)||pparams||chr(39)||','||chr(39)||pmeasure||chr(39)||')';
        END IF;
END add_scnro_qtd_prd;
/
 
begin
add_scnro_qtd_prd('Bond', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('BondAssetBacked', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('BondBrady', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('BondFRN', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('BondMMDiscount', 'MMKT_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('BondMMDiscountAUD', 'MMKT_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('BondMMInterest', 'MMKT_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureBond', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureMM', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureCommodity', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureEquityIndex', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureEquity', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureOptionMM', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureOptionBond', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureOptionEquityIndex', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureOptionEquity', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD');
end;
/
begin
add_scnro_qtd_prd('FutureOptionDividend', 'NPV_FROM_QUOTE' ,'IMPLIEDVOLATILITY');
end;
/
begin
add_scnro_qtd_prd('FutureDividend', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD');
end;
/
begin
add_scnro_qtd_prd('Warrant', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD');
end;
/
begin
add_scnro_qtd_prd('ETOEquity', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD');
end;
/
begin
add_scnro_qtd_prd('ETOEquityIndex', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD');
end;
/
begin
add_scnro_qtd_prd('BondOption', 'BOND_FROM_QUOTE' ,'PLXG');
end;
/
begin
add_scnro_qtd_prd('PerformanceSwap', 'BOND_FROM_QUOTE' ,'PLXG');
end;
/

update product_cap_floor set init_fixing_type ='NONE' where man_first_reset_b=0
;
update liq_info set sort_method='SettleDate' where sort_method='LongSettleDate'
;
declare
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER('reconvention');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
        execute immediate 'UPDATE reconvention SET reference_timezone = 
(SELECT location FROM book, trade WHERE trade.book_id = book.book_id AND trade.product_id = reconvention.product_id) 
WHERE reconvention.reference_timezone IS NULL';
   END IF;
END;
 
/

UPDATE calypso_info
    SET major_version=14,
        minor_version=4,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('30/09/2015','DD/MM/YYYY')
; 
