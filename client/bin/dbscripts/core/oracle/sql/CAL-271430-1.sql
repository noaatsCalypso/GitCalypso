update SWAP_LEG set ROLLING_DAY=31,CUSTOM_ROL_DAY_B=1 where COUPON_STUB_RULE='SPECIFIC FIRST' and FIRST_STUB_DATE IS NOT NULL and ROLLING_DAY=0 
and (decode(to_char(last_day(maturity_date),'D'),7,last_day(maturity_date)-1,1,last_day(maturity_date)-2,last_day(maturity_date)) = MATURITY_DATE OR
last_day(maturity_date)= MATURITY_DATE)
;
/* all sqls should go between these comments */

/* Data Model Changes BEGIN */

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('COLLATERAL_CONTEXT') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE COLLATERAL_CONTEXT (ID NUMBER(*,0) NOT NULL ENABLE, VERSION NUMBER(*,0) NOT NULL ENABLE, NAME VARCHAR2(128), 
IS_DEFAULT NUMBER(*,0) NOT NULL ENABLE, DESCRIPTION VARCHAR2(256), CURRENCY VARCHAR2(3), ATTRIBUTES BLOB, 
VALUE_DATE_DAYS NUMBER(*,0) NOT NULL ENABLE, UNDERLYING_TEMPLATE_ID NUMBER(*,0) NOT NULL ENABLE, 
INTEREST_TEMPLATE_ID NUMBER(*,0) NOT NULL ENABLE, POSITION_TEMPLATE_ID NUMBER(*,0) NOT NULL ENABLE, 
ALLOCATION_TEMPLATE_ID NUMBER(*,0) NOT NULL ENABLE, POSITION_AGGREGATION VARCHAR2(64))';
 
END IF;
End ;
/

 

/*
* add the quoteType in commodity_reset 
*/
begin
  add_column_if_not_exists('commodity_reset', 'quote_type', 'varchar2(63)');
end;
/
begin
  add_column_if_not_exists('cu_swap','fx_reset_b','number');
end;
/
begin
  add_column_if_not_exists('cu_swap','fx_reset_id','number');
end;
/
begin
  add_column_if_not_exists('cu_swap','fx_reset_leg_id','number');
end;
/
begin
  add_column_if_not_exists('cu_basis_swap','fx_reset_b','number');
end;
/
begin
  add_column_if_not_exists('cu_basis_swap','fx_reset_id','number');
end;
/
begin
  add_column_if_not_exists('cu_basis_swap','fx_reset_leg_id','number');
end;
/
begin
  add_column_if_not_exists('cu_basis_swap','spread_on_leg_id','number');
end;
/
update /*+ parallel( cu_swap ) */ cu_swap set fx_reset_b=0 where fx_reset_b is null
;
update /*+ parallel( cu_swap ) */ cu_swap set fx_reset_id=0 where fx_reset_id is null
;
update /*+ parallel( cu_swap ) */ cu_swap set fx_reset_leg_id=0 where fx_reset_leg_id is null
;
update /*+ parallel( cu_basis_swap ) */ cu_basis_swap set fx_reset_b=0 where fx_reset_b is null
;
update /*+ parallel( cu_basis_swap ) */ cu_basis_swap set fx_reset_id=0 where fx_reset_id is null
;
update /*+ parallel( cu_basis_swap ) */ cu_basis_swap set fx_reset_leg_id=0 where fx_reset_leg_id is null
;
update /*+ parallel( cu_basis_swap ) */ cu_basis_swap set spread_on_leg_id=0 where spread_on_leg_id is null
;

update report_template set private_b=1
where template_id not in
(
select template_id from report_template rt, entity_attributes ea
where rt.template_id = ea.entity_id
and rt.report_type='RiskAggregation'
and ea.entity_type='ReportTemplate'
and ea.attr_name ='IsDrillDownTemplate'
and ea.attr_value='true'
)
and report_type='RiskAggregation'
and is_hidden=1 
;


/* CAL-121475 */


CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE  psheet_pricer_measure_prop ( USER_NAME VARCHAR2(64) NOT NULL,
                NAME VARCHAR2(128) NOT NULL,
                IS_DISPLAY  number NOT NULL,
                DISPLAY_CURRENCY VARCHAR2(32) NOT NULL ,
                DISPLAY_COLOR  VARCHAR2(32) NOT NULL,
                PROPERTY_ORDER NUMBER(38) NOT NULL)';
     
    END IF;
END add_table;
/

BEGIN
add_table('psheet_pricer_measure_prop');
END;
/

UPDATE /*+ parallel( psheet_pricer_measure_prop ) */ psheet_pricer_measure_prop SET display_currency = ' '
;
DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'Fader'
;
DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'European Range Binary'
;
UPDATE /*+ parallel( commodity_reset ) */ commodity_reset SET quote_type='Price' where quote_type is null
;
begin
add_domain_values('function','AuthorizeConfirmMessage','Access permission to authorize a Trade Confirmation');
end;
/
 


/* for all funds with Market Index FundBenchmark */


begin
  add_column_if_not_exists('fund','benchmark_type','varchar2(15) null');
  add_column_if_not_exists('fund','benchmark_ref_id','number null');
  add_column_if_not_exists('fund','benchmark_spread','float default 0.0 not null');
end;
/

DECLARE
CURSOR entityCur is select * from entity_attributes where entity_type = 'Fund' and attr_value = 'MarketIndex' or attr_value = 'Market_Index';
entityAttributes entity_attributes%rowtype;
benchmarkId fund.benchmark_ref_id%TYPE := 0; 
benchmarkSpread fund.benchmark_spread%TYPE :=0.0; 

BEGIN
FOR entityAttributes in entityCur
LOOP
	SELECT CAST(attr_value AS NUMBER) INTO benchmarkId FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = entityAttributes.entity_id and attr_name = 'Benchmark_Id';

	SELECT CAST(attr_value AS NUMBER) INTO benchmarkSpread FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = entityAttributes.entity_id and attr_name = 'Benchmark Spread';

	UPDATE fund SET fund.benchmark_type = 'MarketIndex' WHERE entityAttributes.entity_id = fund.fund_id;
	UPDATE fund SET fund.benchmark_ref_id = benchmarkId WHERE entityAttributes.entity_id = fund.fund_id;
	UPDATE fund SET fund.benchmark_spread = benchmarkSpread WHERE entityAttributes.entity_id = fund.fund_id;
	COMMIT;
END LOOP;
exception
	when NO_DATA_FOUND THEN null;
END;
/
/** For funds that have Carve-out **/
DECLARE
CURSOR entityCur is select * from entity_attributes where entity_type = 'Fund' and attr_value = 'Carve-out';
entityAttributes entity_attributes%rowtype;
benchmarkId fund.benchmark_ref_id%TYPE := 0; 
benchmarkSpread fund.benchmark_spread%TYPE :=0.0; 

BEGIN
FOR entityAttributes in entityCur
LOOP
	SELECT CAST(attr_value AS NUMBER) INTO benchmarkId FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = entityAttributes.entity_id and attr_name = 'Benchmark_Id';

	SELECT CAST(attr_value AS NUMBER) INTO benchmarkSpread FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = entityAttributes.entity_id and attr_name = 'Benchmark Spread';

	UPDATE fund SET fund.benchmark_type = 'Carve-out' WHERE entityAttributes.entity_id = fund.fund_id;
	UPDATE fund SET fund.benchmark_ref_id = benchmarkId where entityAttributes.entity_id = fund.fund_id;
	UPDATE fund SET fund.benchmark_spread = benchmarkSpread where entityAttributes.entity_id = fund.fund_id;
	COMMIT;
END LOOP;
exception
	when NO_DATA_FOUND THEN null;
END;
/

/*  For funds that have RateIndex  */

DECLARE
CURSOR entityCur is select * from entity_attributes where entity_type = 'Fund' and attr_value = 'Rate_Index' or attr_value = 'RateIndex';
entityAttributes entity_attributes%rowtype;
rateIndex entity_attributes.attr_value%TYPE := 'rateindex';
quoteName entity_attributes.attr_value%TYPE := 'quoteName';
benchmarkId fund.benchmark_ref_id%TYPE := 0;
benchmarkSpread fund.benchmark_spread%TYPE := 0.0;

	BEGIN
FOR entityAttributes IN entityCur
LOOP
	SELECT entity_attributes.attr_value INTO rateIndex FROM entity_attributes 
	WHERE entity_attributes.entity_type = 'Fund' and entity_attributes.entity_id = entityAttributes.entity_id and entity_attributes.attr_name = 'Benchmark_Id';

	quoteName := CONCAT('MM.', TRANSLATE (rateIndex, '/', '.'));

	SELECT rate_index.rate_index_id INTO benchmarkId from rate_index WHERE rate_index.quote_name = quoteName;

	SELECT CAST(entity_attributes.attr_value AS NUMBER) INTO benchmarkSpread FROM entity_attributes
	WHERE entity_type = 'Fund' AND entity_id = entityAttributes.entity_id and entity_attributes.attr_name = 'Benchmark Spread';

	UPDATE fund SET fund.benchmark_type = 'RateIndex' WHERE entityAttributes.entity_id = fund.fund_id;
	UPDATE fund SET fund.benchmark_ref_id = benchmarkId WHERE entityAttributes.entity_id = fund.fund_id;
	UPDATE fund SET fund.benchmark_spread = benchmarkSpread WHERE entityAttributes.entity_id = fund.fund_id;
	COMMIT;
END LOOP;
exception
	when NO_DATA_FOUND THEN null;
END;
/
/* end */
/* Histo measure computation was refactored and some classes are deprecated*/

update /*+ parallel( PRICER_MEASURE ) */ PRICER_MEASURE set MEASURE_CLASS_NAME='tk.core.PricerMeasure' where MEASURE_CLASS_NAME IN ('tk.pricer.PricerMeasureHistoricalCumulativeCash','tk.pricer.PricerMeasureHistoricalAccrualBO','tk.pricer.PricerMeasureHistoricalCumulativeCash','tk.pricer.PricerMeasureHistoBS','tk.pricer.PricerMeasureHistoricalCumulativeCash')
;

update /*+ parallel( PRICER_MEASURE ) */ PRICER_MEASURE set MEASURE_CLASS_NAME='tk.core.PricerMeasure' where MEASURE_NAME='HISTO_UNSETTLED_FEES' and MEASURE_CLASS_NAME='tk.pricer.PricerMeasureUnsettledFees'
;

update /*+ parallel( PRICER_MEASURE ) */ PRICER_MEASURE set MEASURE_CLASS_NAME='tk.core.PricerMeasure' where MEASURE_NAME='HISTO_UNSETTLED_CASH' and MEASURE_CLASS_NAME='tk.pricer.PricerMeasureUnsettledCash'
;
/* end */

/* CAL-125732  */
delete from DOMAIN_VALUES where value ='HISTO_CUMULATIVE_CASH_INTEREST'
;


/* CAL-123006 */
begin
add_domain_values('domainName','CreditDefaultSwapCoupon.BulletLCDS','Fixed coupons (bps) for standard LCDS');
add_domain_values('CreditDefaultSwapCoupon.BulletLCDS','0','');
add_domain_values('CreditDefaultSwapCoupon.BulletLCDS','100','');
add_domain_values('CreditDefaultSwapCoupon.BulletLCDS','250','');
add_domain_values('CreditDefaultSwapCoupon.BulletLCDS','500','');
end;
/
update main_entry_prop
set property_value='tws.CalypsoWorkstation'
where property_value like 'tws.TraderWorkstation'
; 


 

begin
  add_column_if_not_exists('pc_discount', 'domiciliation', 'varchar2(32) null');
   add_column_if_not_exists('pc_discount', 'product_type', 'varchar2(64) null');
   add_column_if_not_exists('pc_discount', 'sub_type', 'varchar2(32) null');
   add_column_if_not_exists('pc_discount', 'ext_type', 'varchar2(32) null');
   add_column_if_not_exists('pc_discount', 'rate_idx_name', 'varchar2(32) null');
   add_column_if_not_exists('pc_discount', 'rate_index_tenor', 'varchar2(32) null');
  end;
/

update /*+ parallel( pc_discount ) */ pc_discount set domiciliation = 'ANY'
;
update /*+ parallel( pc_discount ) */ pc_discount set product_type = regexp_substr(desc_name, '[^.]+', 1, 1)
;
update /*+ parallel( pc_discount ) */ pc_discount set ext_type = regexp_substr(desc_name, '[^.]+', 1, 2)
;
update /*+ parallel( pc_discount ) */ pc_discount set sub_type = regexp_substr(desc_name, '[^.]+', 1, 3)
;
update /*+ parallel( pc_discount ) */ pc_discount set rate_idx_name = regexp_substr(desc_name, '[^.]+', 1, 4)
;
update /*+ parallel( pc_discount ) */ pc_discount set rate_index_tenor = regexp_substr(desc_name, '[^.]+', 1, 5)
;

/* CAL-126435 */
CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE  mrgcall_config (discount_currency varchar2(32) null,mrg_call_def number not null)';
     
    END IF;
END add_table;
/

BEGIN
add_table('mrgcall_config');
END;
/

begin
add_column_if_not_exists('mrgcall_config', 'discount_currency', 'varchar2(32) null');
end;
/


UPDATE /*+ parallel( mrgcall_config ) */ mrgcall_config SET mrgcall_config.discount_currency =
(SELECT currency_code FROM mrgcall_config_currency
WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def AND mrgcall_config_currency.mrg_call_def in (select mrgcall_config.mrg_call_def
FROM mrgcall_config, mrgcall_config_currency
WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def
HAVING count(mrgcall_config.mrg_call_def) = 1
GROUP BY mrgcall_config.mrg_call_def ))
WHERE mrgcall_config.discount_currency is NULL
;

delete from domain_values where name='horizonFundingPolicy' and value='Daily'
;

INSERT INTO pricing_param_name(param_name, param_type, param_domain, param_comment, is_global_b, default_value) 
VALUES ('FORMULA_MIXING_METHOD','java.lang.String','STATIC_MIXING,SPREAD_MIXING,EXP_LOSS_MIXING,NAME_MIXING',
'Specifies the correlation formula mixing method',1,'STATIC_MIXING' )
;

begin
add_domain_values('leAttributeType','INDEX_FAMILY','');
end;
/


INSERT INTO product_code (product_code,code_type,unique_b,searchable_b,mandatory_b,product_list,version_num)
VALUES ('INDEX_FAMILY','string',0,0,0,'CDSIndex',0)
;

/* Changes to PLMark and Associated Functionality */

begin
add_column_if_not_exists('pl_mark', 'mark_type', 'varchar2(32) null');
end;
/

update /*+ parallel( pl_mark ) */ pl_mark set mark_type='WAC' where mark_id in (select mark_id from pl_mark_value 
where mark_name in ('PREM_DISC_FACTOR','PREM_DISC_YIELD_FACTOR'))
;
update /*+ parallel( pl_mark ) */ pl_mark set mark_type='FX' where mark_id in(select mark_id from pl_mark_value 
where mark_name in ('PriIntAccrual','SecIntAccrual','PriClosingPosition','SecClosingPosition','FXAllInRate','FXRateToBaseCcy','ClosingPosition'))
;
/* end */ 


update /*+ parallel( an_viewer_config ) */  an_viewer_config set viewer_class_name='apps.risk.ScenarioRiskAnalysisViewer' where analysis_name='Scenario'
;

update main_entry_prop set property_value = 'risk.RiskDesignerParamViewer' where property_value = 'risk.ScenarioRiskDesigner'
;

UPDATE /*+ parallel( product_basket ) */ product_basket SET multiply_traded_b=0
WHERE product_basket.product_id in
(
SELECT product_basket.product_id FROM product_basket
INNER JOIN basket_info
ON product_basket.product_id = basket_info.basket_id
) 
;

  

begin 
drop_table_if_exists('report_template_bak');
end;
/

create table report_template_bak as select * from report_template
;
DELETE from report_template WHERE report_type = 'RiskAggregation' and is_hidden = 1 and template_id NOT IN (SELECT report_template_id from tws_risk_aggregation_node)
;
 
UPDATE /*+ parallel( group_access ) */ group_access SET access_id=37, access_value=concat('BookBundle.', access_value) WHERE access_id=21
;
UPDATE /*+ parallel( perm_book_currency ) */ perm_book_currency SET book_bundle=concat('BookBundle.', book_bundle) WHERE book_bundle NOT LIKE '%.%'
;
UPDATE /*+ parallel( perm_book_cur_pair ) */ perm_book_cur_pair SET book_bundle=concat('BookBundle.', book_bundle) WHERE book_bundle NOT LIKE '%.%'
;
UPDATE /*+ parallel( perm_book_product ) */  perm_book_product SET book_bundle=concat('BookBundle.', book_bundle) WHERE book_bundle NOT LIKE '%.%'
;

/* CAL-130455 set standard_contract_type to FUNDED for funded CDSNthLoss */
 

begin
add_column_if_not_exists('product_cds','standard_contract_type','varchar2(32) ');
end;
/
update product_cds set standard_contract_type = 'FUNDED' 
where standard_contract_type is null and product_id in 
	(select pd.product_id from product_desc pd, swap_leg sl where pd.product_type='CDSNthLoss' 
	and pd.product_id = sl.product_id and (sl.act_final_exch_b = 1 or sl.act_initial_exch_b = 1))
;

/* set standard_contract_type to UNFUNDED for any other remaining CDSNthLoss */
update /*+ parallel( product_cds ) */  product_cds set standard_contract_type = 'UNFUNDED'
where standard_contract_type is null and product_id in
(select pd.product_id from product_desc pd where pd.product_type='CDSNthLoss')
;


UPDATE product_equity SET exchange_id = NVL((SELECT legal_entity_id FROM legal_entity WHERE short_name = product_equity.exchange_code), 0) WHERE product_equity.exchange_id = 0
;


/* CAL-138503 From now mark_procedure AUTO requires a not null auto_mark_type */
update product_seclending set auto_mark_type = 'Internal' where mark_procedure='AUTO' and auto_mark_type is null
;

/* CAL-130257 */
/* step 0 */ 
CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE,tablename IN user_tables.table_NAME%TYPE )
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 
'create table ' ||name||' as select * from '||tablename;
    END IF;
END add_table;
/

begin
add_table ('trfilter_minmax_dtbak','trfilter_minmax_dt');
end;
/

begin
add_table ('TRADE_FILTER_CRITbak','TRADE_FILTER_CRIT');
end;
/

begin
add_column_if_not_exists('trfilter_minmax_dt','DATE_OPERATOR','varchar2(128) null');
end;
/

create or replace procedure trade_filter_to_dt
is
begin
declare 
cursor cur_main is 
select trade_filter_name,settle_date_min,settle_date_max, setledt_tenor_max,setledt_tenor_min from trade_filter where settle_date_min is not null or settle_date_max is not null or (setledt_tenor_max is not null and setledt_tenor_max <> 360000) or (setledt_tenor_min is not null and setledt_tenor_min <> 360000);
arg_trade_filter_name  varchar2(255) ; 
arg_settle_date_min timestamp ;
arg_settle_date_max timestamp ;  
arg_setledt_tenor_max number ; 
arg_setledt_tenor_min number ;
begin 
open cur_main; 
fetch cur_main into arg_trade_filter_name , arg_settle_date_min , arg_settle_date_max ,arg_setledt_tenor_max, arg_setledt_tenor_min; 
while cur_main %FOUND
	loop
    	insert into trfilter_minmax_dt (criterion_name,trade_filter_name,date_min,date_max,tenor_max,tenor_min, time_min, time_max) values ('SettleDate',arg_trade_filter_name , arg_settle_date_min , arg_settle_date_max ,arg_setledt_tenor_max, arg_setledt_tenor_min , -1, -1);
		fetch cur_main into arg_trade_filter_name , arg_settle_date_min , arg_settle_date_max ,arg_setledt_tenor_max, arg_setledt_tenor_min; 
	end loop;
end;
end;
/

create or replace procedure trade_filter_to_dt1
is
begin
declare 
cursor cur_main1 is 
select trade_filter_name, mat_date_min , mat_date_max ,matdt_tenor_max,matdt_tenor_min from trade_filter where mat_date_min is not null or mat_date_max is not null or (matdt_tenor_max is not null and matdt_tenor_max <> 360000)or (matdt_tenor_min is not null and matdt_tenor_min <> 360000);
arg_trade_filter_name  varchar2(255) ; 
arg_mat_date_min timestamp ;
arg_mat_date_max timestamp ; 
arg_matdt_tenor_max number ; 
arg_matdt_tenor_min number;
x  number := 0;
begin
open cur_main1;
		fetch cur_main1 into arg_trade_filter_name , arg_mat_date_min  , arg_mat_date_max  , arg_matdt_tenor_max , arg_matdt_tenor_min ;
while cur_main1 %FOUND
	loop
	select count(*) into x from TRFILTER_MINMAX_DT where trade_filter_name=arg_trade_filter_name and (CRITERION_NAME='MaturityDateOrNone' or CRITERION_NAME='MaturityDate');
	if x = 0  then
		insert into trfilter_minmax_dt (criterion_name,trade_filter_name,date_min,date_max, tenor_min, tenor_max, time_min, time_max) values ('MaturityDate',arg_trade_filter_name , arg_mat_date_min , arg_mat_date_max ,arg_matdt_tenor_min, arg_matdt_tenor_max , -1, -1);
	end if;	
		fetch cur_main1 into arg_trade_filter_name , arg_mat_date_min  , arg_mat_date_max  , arg_matdt_tenor_max , arg_matdt_tenor_min ;
	end	loop;
end;
end;
/

create or replace procedure trade_filter_to_dt2
is
begin
declare 
cursor cur_main1 is 
select distinct trade_filter_name from trade_filter;
arg_trade_filter_name  varchar2(255) ; 
x  number := 0;
begin
open cur_main1;
		fetch cur_main1 into arg_trade_filter_name ;
while cur_main1  %FOUND
	loop
select count(*) into x from TRFILTER_MINMAX_DT where criterion_name='TradeDate' and trade_filter_name=arg_trade_filter_name;
        if x = 0  then
insert into TRFILTER_MINMAX_DT (trade_filter_name, criterion_name , date_operator, time_min, time_max, tenor_min, tenor_max) values (arg_trade_filter_name ,'TradeDate','Is On Or Before',-1,-1,360000,360000); 
        end if;	
	fetch cur_main1 into arg_trade_filter_name ;
end	loop;
end;
end;
/

create or replace procedure trade_filter_to_dt3
is
begin
declare 
cursor cur_main2 is 
select trade_filter.trade_filter_name from trade_filter , trade_filter_crit where trade_filter.trade_filter_name=trade_filter_crit.trade_filter_name and
trade_filter_crit.criterion_name ='CURRENTMONTH_CRITERIA' and trade_filter_crit.criterion_value='MATURITY_DATE'and
trade_filter_crit.is_in_b=1 ;
arg_trade_filter_name  varchar2(255) ; 
x  number := 0;
begin
open cur_main2;
		fetch cur_main2 into arg_trade_filter_name ;
while cur_main2 %FOUND
	loop
	select count(*) into x from TRFILTER_MINMAX_DT where trade_filter_name=arg_trade_filter_name and (CRITERION_NAME='MaturityDateOrNone' or CRITERION_NAME='MaturityDate');
	if x = 0  then
	insert into TRFILTER_MINMAX_DT (trade_filter_name, criterion_name , date_operator, time_min, time_max, tenor_min, tenor_max) values (arg_trade_filter_name ,'FinalValuationDate','Within current month',-1,-1,360000,360000); 
	end if;
	fetch cur_main2 into arg_trade_filter_name ;
end	loop;
end;
end;
/

create or replace procedure trade_filter_to_dt4
is
begin
declare
cursor cur_main3 is 
select trade_filter.trade_filter_name from trade_filter , trade_filter_crit where trade_filter.trade_filter_name=trade_filter_crit.trade_filter_name and
trade_filter_crit.criterion_name ='NULL_MATURITY_CRITERIA' and trade_filter_crit.criterion_value='NO' and
trade_filter_crit.is_in_b=1 ; 
arg_trade_filter_name  varchar2(255) ; 
x  number := 0;
begin
open cur_main3;
		fetch cur_main3 into arg_trade_filter_name ;
while cur_main3 %FOUND
	loop
	select count(*) into x from TRFILTER_MINMAX_DT where trade_filter_name=arg_trade_filter_name and (CRITERION_NAME='MaturityDateOrNone' or CRITERION_NAME='MaturityDate');
	if x = 0  then
	insert into TRFILTER_MINMAX_DT (trade_filter_name, CRITERION_NAME , date_operator, time_min, time_max, tenor_min, tenor_max) values (arg_trade_filter_name ,'FinalValuationDate','Is not null',-1,-1,360000,360000); 
	end if;
	fetch cur_main3 into arg_trade_filter_name ;
end	loop;
end;
end;
/
create or replace procedure trade_filter_to_dt5
is
 begin
    declare
    cursor cur_main4 is
    select trade_filter_name from trfilter_minmax_dt where CRITERION_NAME='MaturityDateOrNone';
arg_trade_filter_name  varchar2(255) ;
x  number := 0;
   begin
  open cur_main4;
          fetch cur_main4 into arg_trade_filter_name ;
  while cur_main4 %FOUND
loop
select count(*) into x from trade_filter_crit where criterion_name='includeNull' and trade_filter_name=arg_trade_filter_name and criterion_value='FinalValuationDate';
        if x = 0  then
        insert into TRADE_FILTER_CRIT (trade_filter_name , criterion_name, criterion_value, is_in_b ) values (arg_trade_filter_name,'includeNull','FinalValuationDate',1);
        end if;
        fetch cur_main4 into arg_trade_filter_name ;
end     loop;
end;
end; 
/

create or replace procedure trade_filter_to_dt6
is
	begin
		declare 
		cursor cur_main1 is
		select date_min , tenor_min, trade_filter_name from trfilter_minmax_dt where criterion_name='PositionSettleDate' ;
		arg_date_min timestamp;
		arg_tenor_min number;
		arg_trade_filter_name  varchar2(255);
			begin
				open cur_main1;
				fetch cur_main1 into arg_date_min, arg_tenor_min, arg_trade_filter_name;
					while cur_main1  %FOUND
					loop
						update trfilter_minmax_dt set date_max=arg_date_min , tenor_max=arg_tenor_min , date_min=null , tenor_min=null , date_operator='Is After' where criterion_name='PositionSettleDate' and  trade_filter_name=arg_trade_filter_name;
						fetch cur_main1 into arg_date_min, arg_tenor_min, arg_trade_filter_name;
					end	loop;
			end;
	end;
/

begin
add_column_if_not_exists('product_desc','final_valuation_date','timestamp(6) null');
end;
/

create or replace procedure execution_log
as
   x number;
	begin 
    begin 
	select count(DATE_OPERATOR) into x from TRFILTER_MINMAX_DT;
	EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
	end;	
    if x =0 then 
update trfilter_minmax_dt set DATE_OPERATOR = 'Is On Or Before'  where criterion_name in ('UpdateDate','TradeDate','EnteredDate','MaturityDateOrNone') 
and ((date_max is not null) or (tenor_max is not null and tenor_max <> 360000));

update trfilter_minmax_dt set DATE_OPERATOR = 'Is On Or After'  where criterion_name in ('UpdateDate','TradeDate','EnteredDate','MaturityDateOrNone')  
and ((date_min is not null) or (tenor_min is not null and tenor_min <> 360000));

update trfilter_minmax_dt set DATE_OPERATOR = 'Is Between' where criterion_name in ('UpdateDate','TradeDate','EnteredDate','MaturityDateOrNone') 
and ((date_max is not null and date_min is not null ) or (
(tenor_min is not null and tenor_min <> 360000)and (tenor_max is not null and tenor_max <> 360000)));


update trfilter_minmax_dt set DATE_OPERATOR = 'Is On Or Before' 
where criterion_name in ('TransferDate','TerminationDate','EXERCISED_DATETIME','TransferEffectiveDate','TerminationEffectiveDate')
and ((date_max is not null) or (tenor_max is not null and tenor_max <> 360000));

update trfilter_minmax_dt set DATE_OPERATOR = 'Is On Or After' 
where criterion_name in ('TransferDate','TerminationDate','EXERCISED_DATETIME','TransferEffectiveDate','TerminationEffectiveDate')
and ((date_min is not null) or (tenor_min is not null and tenor_min <> 360000));

update trfilter_minmax_dt set DATE_OPERATOR = 'Is Between' where criterion_name in ('TransferDate','TerminationDate','EXERCISED_DATETIME','TransferEffectiveDate','TerminationEffectiveDate')
and ((date_max is not null and date_min is not null ) or (
(tenor_min is not null and tenor_min <> 360000)and (tenor_max is not null and tenor_max <> 360000)));

/* step 1 */ 


trade_filter_to_dt;
trade_filter_to_dt1;


update trfilter_minmax_dt set DATE_OPERATOR ='Is On Or Before'
where trade_filter_name in  (select t.trade_filter_name  
from  trfilter_minmax_dt t , trade_filter tf 
where (tf.settle_date_max is not null 
or (tf.setledt_tenor_max is not null and tf.setledt_tenor_max <> 360000))
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='SettleDate'
) 
and criterion_name='SettleDate';

update trfilter_minmax_dt set date_operator ='Is On Or After'
where trade_filter_name in  (select t.trade_filter_name  from trade_filter tf , trfilter_minmax_dt t 
where (tf.settle_date_min is not null 
or (tf.setledt_tenor_min is not null and tf.setledt_tenor_min <> 360000))
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='SettleDate')   
and criterion_name='SettleDate';
update trfilter_minmax_dt set DATE_OPERATOR ='Is Between' 
where trade_filter_name in  (select t.trade_filter_name from trade_filter tf, trfilter_minmax_dt t 
where t.criterion_name='SettleDate' and t.trade_filter_name = tf.trade_filter_name and ( (tf.settle_date_min is not null and tf.settle_date_max is not null) 
or ( ( tf.setledt_tenor_min is not null and tf.setledt_tenor_min <> 360000) and (tf.setledt_tenor_max is not null and tf.setledt_tenor_max <> 360000) )
))
and criterion_name='SettleDate';

update  trfilter_minmax_dt set DATE_OPERATOR ='Is On Or Before' where trade_filter_name in  (select t.trade_filter_name from trade_filter tf , trfilter_minmax_dt t where (tf.mat_date_max is not null 
or (tf.matdt_tenor_max is not null and tf.matdt_tenor_max <> 360000)) 
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='MaturityDate'
)  
and criterion_name='MaturityDate';

update trfilter_minmax_dt set DATE_OPERATOR ='Is On Or After' where trade_filter_name in  (select t.trade_filter_name from
trfilter_minmax_dt t, trade_filter tf where  (tf.mat_date_min is not null 
or (tf.matdt_tenor_min is not null and tf.matdt_tenor_min <> 360000))
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='MaturityDate'
)
and criterion_name='MaturityDate';

update trfilter_minmax_dt set DATE_OPERATOR ='Is Between' where trade_filter_name in  (select t.trade_filter_name from trade_filter tf, trfilter_minmax_dt t 
where (
(tf.mat_date_min is not null and tf.mat_date_max is not null) 
or (tf.matdt_tenor_min is not null and tf.matdt_tenor_max is not null and tf.matdt_tenor_min <> 360000 and tf.matdt_tenor_max <> 360000)) 
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='MaturityDate'
)
and criterion_name='MaturityDate';

/* step 3 */
/* 
is not required in the dbscripts remove the columns from the schemaBase.xml and the executesql synchronise will take care of the rest
*/

trade_filter_to_dt2;

trade_filter_to_dt3;

trade_filter_to_dt4;

trade_filter_to_dt5;

trade_filter_to_dt6;

update /*+ parallel( product_desc ) */ product_desc set final_valuation_date=maturity_date;

update TRFILTER_MINMAX_DT set criterion_name='FinalValuationDate' where CRITERION_NAME='MaturityDateOrNone' or CRITERION_NAME='MaturityDate';

update trfilter_minmax_dt set date_min= date_max, tenor_min=tenor_max, time_min=time_max where DATE_OPERATOR = 'Is On Or Before';

update trfilter_minmax_dt set date_max=null, tenor_max=360000, time_max=-1 where DATE_OPERATOR = 'Is On Or Before';

update trfilter_minmax_dt set date_max= date_min, tenor_max=tenor_min, time_max=time_min where DATE_OPERATOR = 'Is On Or After';

update trfilter_minmax_dt set date_min=null, tenor_min=360000, time_min=-1 where DATE_OPERATOR = 'Is On Or After';
update TRADE_FILTER_CRIT set criterion_value='TransferTradeDate' where criterion_value='TransferDate' and criterion_name='haskeyword.Has';
update TRADE_FILTER_CRIT set criterion_value='TransferDate' where criterion_value='TransferEffectiveDate' and criterion_name='haskeyword.Has';
update TRADE_FILTER_CRIT set criterion_value='TerminationTradeDate' where criterion_value='TerminationDate' and criterion_name='haskeyword.Has';
update TRADE_FILTER_CRIT set criterion_value='TerminationDate' where criterion_value='TerminationEffectiveDate' and criterion_name='haskeyword.Has';

UPDATE trfilter_minmax_dt SET time_max = 2359 WHERE criterion_name IN ('EXERCISED_DATETIME', 'TransferDate', 'UpdateDate','TradeDate','EnteredDate','TerminationDate') AND time_max = -1;
UPDATE trfilter_minmax_dt SET  time_min = 0000 WHERE criterion_name IN ('EXERCISED_DATETIME', 'TransferDate','UpdateDate','TradeDate','EnteredDate','TerminationDate') AND time_min = -1;
END IF;

end;
/

begin
execution_log;
end;
/

drop procedure trade_filter_to_dt
;
drop procedure trade_filter_to_dt1
;
drop procedure trade_filter_to_dt2
;
drop procedure trade_filter_to_dt3
;
drop procedure trade_filter_to_dt4
;
drop procedure trade_filter_to_dt5
;
drop procedure trade_filter_to_dt6
;
drop procedure execution_log
;

begin
add_column_if_not_exists('psheet_pricer_measure_prop','display_group','varchar2(128) null');
end;
/

update /*+ parallel( psheet_pricer_measure_prop ) */  psheet_pricer_measure_prop set display_group = 'Favorite' where display_group is null or display_group=' '
;
update /*+ parallel( swap_leg ) */ swap_leg set reset_off_busday_b = 1,reset_offset=0,reset_holidays='' where def_reset_off_b=1
;
update /*+ parallel( swap_leg_hist ) */  swap_leg_hist set reset_off_busday_b = 1,reset_offset=0,reset_holidays='' where def_reset_off_b=1
;

begin
  add_column_if_not_exists ('acc_account','trade_id','numeric default 0 not null');
end;
/

update /*+ parallel( acc_account ) */  acc_account set trade_id=acc_account_id where trade_id=0 and call_account_b=1
;

begin
add_column_if_not_exists('product_future','ccp_date','timestamp');
end;
/

update /*+ parallel( product_future ) */ product_future set ccp_date = expiration_date where ccp_date is null
;

CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE pl_risk_factor ( valdate timestamp  NOT NULL,  trade_id numeric  NOT NULL,  
		sub_id varchar2 (256) NOT NULL,  item_name varchar2 (256) NOT NULL,  quote_name varchar2 (256) NOT NULL,  
		quote_type float  NOT NULL,  env_name varchar2 (64) NOT NULL,  first_order float  NOT NULL,  second_order float  NOT NULL,
		original_quote float  NOT NULL )';
     
    END IF;
END add_table;
/

BEGIN
add_table('pl_risk_factor');
END;
/


CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table HS_CONTEXT_QV ( ID NUMBER(38) not null, DATETIME TIMESTAMP not null,
 QUOTESET_NAME  VARCHAR2(255) not null,
 QUOTE_NAME   VARCHAR2(255) not null,
 QUOTE_TYPE  VARCHAR2(255) not null,
 QUOTE_BID    NUMBER(38),
 QUOTE_ASK  NUMBER(38),
 QUOTE_OPEN  NUMBER(38),
 QUOTE_CLOSE NUMBER(38) )';
     
    END IF;
END add_table;
/

BEGIN
add_table('HS_CONTEXT_QV');
END;
/

CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table HS_CONTEXT_QV_HIST ( ID NUMBER(38) not null, DATETIME TIMESTAMP not null,
 QUOTESET_NAME  VARCHAR2(255) not null,
 QUOTE_NAME   VARCHAR2(255) not null,
 QUOTE_TYPE  VARCHAR2(255) not null,
 QUOTE_BID    NUMBER(38),
 QUOTE_ASK  NUMBER(38),
 QUOTE_OPEN  NUMBER(38),
 QUOTE_CLOSE NUMBER(38) )';
     
    END IF;
END add_table;
/

BEGIN
add_table('HS_CONTEXT_QV_HIST');
END;
/
drop procedure add_table
;

create index i_pl_risk_fac_1 on pl_risk_factor(quote_name) compute statistics online
;
create index i_curve_quote_adj_1 on curve_quote_adj(quote_name) compute statistics online
;
create index i_trade_diary_1 on trade_diary(quote_name) compute statistics online
;

CREATE OR REPLACE PROCEDURE UpdateQuoteName1
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( quote_value ) */ quote_value set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;

commit;
end loop;
end;
END UpdateQuoteName1;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName2
IS BEGIN 
DECLARE 
CURSOR C1 is 
SELECT distinct curve_quote_value.quote_name, cu_fra.rate_index ri, substr(cu_fra.rate_index,instr(cu_fra.rate_index,'/',-1,1)+1) str, curve_member.curve_id cid 
 from curve_member, cu_fra , curve_quote_value
where curve_quote_value.curve_id = curve_member.curve_id and
cu_fra.cu_id = curve_member.cu_id and curve_quote_value.quote_name like 'FRA%';

BEGIN 
FOR C1_REC in C1 LOOP 

update /*+ parallel( CURVE_QUOTE_VALUE ) */ CURVE_QUOTE_VALUE set CURVE_QUOTE_VALUE.quote_name = C1_REC.quote_name||'.'||C1_REC.STR where CURVE_QUOTE_VALUE.curve_id = C1_REC.CID and CURVE_QUOTE_VALUE.quote_name = C1_REC.quote_name;

COMMIT; 
END LOOP; 
END; 
END UpdateQuoteName2; 
/


CREATE OR REPLACE PROCEDURE UpdateQuoteName3
IS BEGIN 
DECLARE 
CURSOR C1 is 
SELECT distinct curve_quote_value.quote_name, cu_fra.rate_index ri, substr(cu_fra.rate_index,instr(cu_fra.rate_index,'/',-1,1)+1) str, curve_member.curve_id cid 
 from curve_member, cu_fra , curve_quote_value
where curve_quote_value.curve_id = curve_member.curve_id and
cu_fra.cu_id = curve_member.cu_id and curve_quote_value.quote_name like 'FRA%';

BEGIN 
FOR C1_REC in C1 LOOP 

update /*+ parallel( CURVE_QUOTE_ADJ ) */ CURVE_QUOTE_ADJ set CURVE_QUOTE_ADJ.quote_name = C1_REC.quote_name||'.'||C1_REC.STR where CURVE_QUOTE_ADJ.curve_id = C1_REC.CID and CURVE_QUOTE_ADJ.quote_name = C1_REC.quote_name;

COMMIT; 
END LOOP; 
END; 
 END UpdateQuoteName3; 
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName4
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( feed_address ) */ feed_address set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName4;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName5
IS BEGIN 
DECLARE 
CURSOR C1 is 
SELECT distinct CURVE_QT_VAL_HIST.quote_name, cu_fra.rate_index ri, substr(cu_fra.rate_index,instr(cu_fra.rate_index,'/',-1,1)+1) str, curve_member.curve_id cid 
from curve_member, cu_fra , CURVE_QT_VAL_HIST
where CURVE_QT_VAL_HIST.curve_id = curve_member.curve_id and
cu_fra.cu_id = curve_member.cu_id and CURVE_QT_VAL_HIST.quote_name like 'FRA%';

BEGIN 
FOR C1_REC in C1 LOOP 

update /*+ parallel( CURVE_QT_ADJ_HIST ) */ CURVE_QT_ADJ_HIST set quote_name = C1_REC.quote_name||'.'||C1_REC.STR where CURVE_QT_ADJ_HIST.curve_id = C1_REC.CID and CURVE_QT_ADJ_HIST.quote_name = C1_REC.quote_name;

COMMIT; 
END LOOP; 
END; 
END UpdateQuoteName5; 
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName6
IS BEGIN 
DECLARE 
CURSOR C1 is 
SELECT distinct CURVE_QT_VAL_HIST.quote_name, cu_fra.rate_index ri, substr(cu_fra.rate_index,instr(cu_fra.rate_index,'/',-1,1)+1) str, curve_member.curve_id cid 
from curve_member, cu_fra , CURVE_QT_VAL_HIST
where CURVE_QT_VAL_HIST.curve_id = curve_member.curve_id and
cu_fra.cu_id = curve_member.cu_id and CURVE_QT_VAL_HIST.quote_name like 'FRA%';

BEGIN 
FOR C1_REC in C1 LOOP 

update /*+ parallel( CURVE_QT_VAL_HIST ) */ CURVE_QT_VAL_HIST set quote_name = C1_REC.quote_name||'.'||C1_REC.STR where CURVE_QT_VAL_HIST.curve_id = C1_REC.CID and CURVE_QT_VAL_HIST.quote_name = C1_REC.quote_name;

COMMIT; 
END LOOP; 
END; 
END UpdateQuoteName6; 
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName7
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( product_desc ) */ product_desc set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName7;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName8
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( product_desc_hist ) */ product_desc_hist set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName8;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName9
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( product_reset ) */ product_reset set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName9;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName10
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( quote_name ) */ quote_name set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName10;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName11
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( quote_value_intraday ) */ quote_value_intraday set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName11;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName12
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update quote_value_hist set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName12;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName13
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( specific_fxrate ) */ specific_fxrate set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName13;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName14
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( trade_diary ) */ trade_diary set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName14;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName15
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( trade_diary_hist ) */ trade_diary_hist set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName15;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName16
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( hs_context_qv ) */ hs_context_qv set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName16;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName17
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( hs_context_qv_hist ) */ hs_context_qv_hist set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName17;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName18
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( pl_risk_factor ) */ pl_risk_factor set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str;
commit;
end loop;
end;
END UpdateQuoteName18;
/

CREATE OR REPLACE PROCEDURE UpdateQuoteName19
AS
BEGIN
DECLARE
CURSOR C1 is 
SELECT a.quote_name , substr(b.rate_index,instr(b.rate_index,'/',-1,1)+1) str, a.cu_id
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA';

BEGIN
FOR C1_REC in C1 LOOP

update /*+ parallel( curve_underlying ) */ curve_underlying set quote_name =c1_rec.quote_name||'.'||c1_rec.str where quote_name=c1_rec.quote_name and quote_name not like '%'||c1_rec.str and cu_id = c1_rec.cu_id;

commit;
end loop;
end;
END UpdateQuoteName19;
/
BEGIN
UpdateQuoteName1;
END;
/
BEGIN
UpdateQuoteName2;
END;
/
BEGIN
UpdateQuoteName3;
END;
/
BEGIN
UpdateQuoteName4;
END;
/
BEGIN
UpdateQuoteName5;
END;
/
BEGIN
UpdateQuoteName6;
END;
/
BEGIN
UpdateQuoteName7;
END;
/
BEGIN
UpdateQuoteName8;
END;
/
BEGIN
UpdateQuoteName9;
END;
/
BEGIN
UpdateQuoteName10;
END;
/
BEGIN
UpdateQuoteName11;
END;
/
BEGIN
UpdateQuoteName12;
END;
/
BEGIN
UpdateQuoteName13;
END;
/
BEGIN
UpdateQuoteName14;
END;
/
BEGIN
UpdateQuoteName15;
END;
/
BEGIN
UpdateQuoteName16;
END;
/
BEGIN
UpdateQuoteName17;
END;
/
BEGIN
UpdateQuoteName18;
END;
/
BEGIN
UpdateQuoteName19;
END;
/
drop procedure UpdateQuoteName1
;
drop procedure UpdateQuoteName2
;
drop procedure UpdateQuoteName3
;
drop procedure UpdateQuoteName4
;
drop procedure UpdateQuoteName5
;
drop procedure UpdateQuoteName6
;
drop procedure UpdateQuoteName7
;
drop procedure UpdateQuoteName8
;
drop procedure UpdateQuoteName9
;
drop procedure UpdateQuoteName10
;
drop procedure UpdateQuoteName11
;
drop procedure UpdateQuoteName12
;
drop procedure UpdateQuoteName13
;
drop procedure UpdateQuoteName14
;
drop procedure UpdateQuoteName15
;
drop procedure UpdateQuoteName16
;
drop procedure UpdateQuoteName17
;
drop procedure UpdateQuoteName18
;
drop procedure UpdateQuoteName19
;
UPDATE main_entry_prop
SET property_value = 'cws.LaunchCWS'
WHERE property_name LIKE '%Action'
AND (property_value = 'tws.CalypsoWorkstation' OR property_value = 'tws.TraderWorkstation')
; 

delete from pricing_param_items where attribute_name = 'BETA_REFERENCE_INDEX'
;
update pricing_param_name set param_name = 'BETA_REFERENCE_NAME', param_comment = 'Reference Matrix for Beta' where param_name = 'BETA_REFERENCE_INDEX'
;

create table scenario_items_back as select * from scenario_items
;
begin
add_column_if_not_exists ('scenario_items','attribute_value1','varchar2(255)');
end;
/

update scenario_items i1 set attribute_value1=(
select substr(i2.attribute_value,1,length(i2.attribute_value)-length(substr(i2.attribute_value,instr(i2.attribute_value,' Beta'),length(i2.attribute_value))))
from scenario_items i2
where i2.class_name = 'com.calypso.tk.risk.ScenarioRuleQuotes' and i1.class_name = i2.class_name and i1.scenario_name = i2.scenario_name
and i2.attribute_name = 'SPECIFIC' and i1.attribute_name = i2.attribute_name and i1.item_seq=i2.item_seq and i2.attribute_value like '% Beta%')
where i1.class_name = 'com.calypso.tk.risk.ScenarioRuleQuotes' 
and i1.attribute_name = 'SPECIFIC' and i1.attribute_value like '% Beta%'
;

update scenario_items set attribute_value=attribute_value1 where class_name = 'com.calypso.tk.risk.ScenarioRuleQuotes' 
and attribute_name = 'SPECIFIC' and attribute_value like '%Beta%'
;




create table an_param_items_back as select * from an_param_items
;

delete from an_param_items 
where class_name = 'com.calypso.tk.risk.SensitivityParam'
and attribute_name = 'BetaReferenceIndex'
;

update an_param_items  
set  attribute_value = 'None'
where  class_name = 'com.calypso.tk.risk.SimulationParam'
and  attribute_name like 'CcyFamily%'
;
update /*+ parallel( an_param_items ) */ an_param_items set attribute_value ='NONE' where class_name='com.calypso.tk.risk.SimulationParam' and attribute_name like '%BetaReferenceIndex%'
;
update /*+ parallel( an_param_items ) */  an_param_items set attribute_value =null where class_name='com.calypso.tk.risk.SimulationParam' and attribute_name = 'EqBetaRefIndex'
;

/* modified for better performance */
/* ALTER SESSION FORCE PARALLEL DML may help in case running script manually */
begin
add_column_if_not_exists('pl_mark_value','adj_comment', 'varchar2(512)');
end;
/
begin
add_column_if_not_exists('pl_mark_value','adj_type', 'varchar2(512)');
end;
/
begin
add_column_if_not_exists('pl_mark_value','is_adjusted', 'numeric null');
add_column_if_not_exists('pl_mark_value','adj_value', 'float null');
end;
/
alter table pl_mark_value rename to pl_mark_value_can_drop
;
create table pl_mark_value (mark_id number(*,0) not null enable, mark_name varchar2(32) not null enable, 
mark_value float(126), currency varchar2(3) not null enable, display_class varchar2(128), display_digits number(*,0), 
adj_value float(126), is_adjusted number(*,0) not null enable, adj_type varchar2(512), adj_comment varchar2(512))  
;
alter table pl_mark_value nologging
;
INSERT /*+ APPEND_VALUES */ INTO PL_MARK_VALUE (mark_id, mark_name,mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment)
select /*+ parallel (PL_MARK_VALUE_can_drop,8) */ mark_id,'HISTO_FEES_UNSETTLED',mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment
from PL_MARK_VALUE_can_drop where mark_name = 'HISTO_UNSETTLED_FEES'
;
INSERT /*+ APPEND_VALUES */ INTO PL_MARK_VALUE (mark_id, mark_name,mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment)
select /*+ parallel (PL_MARK_VALUE_can_drop,8) */  mark_id,'HISTO_CUMULATIVE_CASH',mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment
from PL_MARK_VALUE_can_drop where mark_name = 'HISTO_CUMUL_CASH'
;
INSERT /*+ APPEND_VALUES */ INTO PL_MARK_VALUE (mark_id, mark_name,mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment)
select /*+ parallel (PL_MARK_VALUE_can_drop,8) */ mark_id,'HISTO_CUMULATIVE_CASH_INTEREST',mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment
from PL_MARK_VALUE_can_drop where mark_name = 'HISTO_CUMUL_CASH_INTEREST'
;
INSERT /*+ APPEND_VALUES */ INTO PL_MARK_VALUE (mark_id, mark_name,mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment)
select /*+ parallel (PL_MARK_VALUE_can_drop,8) */ mark_id,'HISTO_POSITION_CASH',mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment
from PL_MARK_VALUE_can_drop where mark_name = 'HISTO_POS_CASH'
;
INSERT /*+ APPEND_VALUES */ INTO PL_MARK_VALUE (mark_id, mark_name,mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment)
select /*+ parallel (PL_MARK_VALUE_can_drop,8) */ mark_id,'HISTO_CUMULATIVE_CASH_FEES',mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment
from PL_MARK_VALUE_can_drop where mark_name = 'HISTO_CUMUL_CASH_FEES'
;
INSERT /*+ APPEND_VALUES */ INTO PL_MARK_VALUE (mark_id, mark_name,mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment)
select /*+ parallel (PL_MARK_VALUE_can_drop,8) */ mark_id, mark_name,mark_value,  currency, display_class, display_digits,adj_value,  is_adjusted, adj_type, adj_comment
from PL_MARK_VALUE_can_drop where mark_name NOT in ( 'HISTO_UNSETTLED_FEES','HISTO_CUMUL_CASH','HISTO_CUMUL_CASH_INTEREST','HISTO_POS_CASH', 'HISTO_CUMUL_CASH_FEES')
;
CREATE UNIQUE INDEX PK_PLMARK_VALUE3 ON PL_MARK_VALUE (MARK_ID , MARK_NAME , CURRENCY ) compute statistics parallel 8 nologging
;
alter index PK_PLMARK_VALUE3 noparallel logging
;
ALTER TABLE PL_MARK_VALUE ADD  CONSTRAINT PK_PLMARK_VALUE3 PRIMARY KEY (MARK_ID, MARK_NAME, CURRENCY) USING INDEX
;
alter table PL_MARK_VALUE logging
;
drop table PL_MARK_VALUE_can_drop
;
/* cal 145629 */


CREATE OR REPLACE PROCEDURE pl_mark_value_update AS

CURSOR C1 IS
SELECT A.* FROM pl_mark_value A, pl_mark B, trade C, product_desc D WHERE A.mark_id = B.mark_id 
AND B.trade_id = C.trade_id AND C.product_id = D.product_id AND B.position_or_trade = 'com.calypso.tk.core.Trade' 
AND A.mark_name = 'HISTO_BS' AND D.product_family IN ('Cash', 'Repo' ,'SecurityLending');

CURSOR C2 IS
SELECT A.* FROM pl_mark_value A, pl_mark B, pl_position C, product_desc D 
WHERE A.mark_id = B.mark_id AND B.trade_id = C.position_id AND C.product_id = D.product_id 
AND B.position_or_trade = 'com.calypso.tk.mo.PLPosition' AND A.mark_name = 'HISTO_BS' 
AND D.product_family IN ('Equity', 'CFD');

CURSOR C3 IS
SELECT A.* FROM pl_mark_value A, pl_mark B, pl_position C, product_desc D 
WHERE A.mark_id = B.mark_id AND B.trade_id = C.position_id 
AND C.product_id = D.product_id AND B.position_or_trade = 'com.calypso.tk.mo.PLPosition' 
AND A.mark_name = 'HISTO_BS' AND D.product_family IN ('Bond','Loan','Issuance');

CURSOR C4 IS
SELECT A.* FROM pl_mark_value A, pl_mark B, pl_position C, product_desc D 
WHERE A.mark_id = B.mark_id AND B.trade_id = C.position_id AND C.product_id = D.product_id 
AND B.position_or_trade = 'com.calypso.tk.mo.PLPosition' AND A.mark_name = 'HISTO_REALIZED' 
AND D.product_family IN ('Bond','Loan','Issuance');

cursor c5 is 
select A.* from pl_mark_value A, pl_mark B, trade C, product_desc D 
WHERE A.mark_id = B.mark_id AND B.trade_id = C.trade_id AND C.product_id = D.product_id 
AND B.position_or_trade = 'com.calypso.tk.core.Trade' AND A.mark_name = 'HISTO_BS' 
AND product_type='PreciousMetalDepositLease';

BEGIN
FOR I IN C1 LOOP
UPDATE /*+ parallel( pl_mark_value ) */ pl_mark_value sp SET sp.mark_name = 'HISTO_CUMULATIVE_CASH_PRINCIPAL'
WHERE sp.mark_id = I.mark_id AND sp.mark_name = I.mark_name AND sp.currency = I.currency;
END LOOP;

FOR I IN C2 LOOP
UPDATE /*+ parallel( pl_mark_value ) */ pl_mark_value sp SET sp.mark_name = 'HISTO_BOOK_VALUE'
WHERE sp.mark_id = I.mark_id AND sp.mark_name = I.mark_name AND sp.currency = I.currency;
END LOOP;

FOR I IN C3 LOOP
UPDATE /*+ parallel( pl_mark_value ) */ pl_mark_value sp SET sp.mark_name = 'HISTO_CLEAN_BOOK_VALUE'
WHERE sp.mark_id = I.mark_id AND sp.mark_name = I.mark_name AND sp.currency = I.currency;
END LOOP;

FOR I IN C4 LOOP
UPDATE /*+ parallel( pl_mark_value ) */ pl_mark_value sp SET sp.mark_name = 'HISTO_CLEAN_REALIZED'
WHERE sp.mark_id = I.mark_id AND sp.mark_name = I.mark_name AND sp.currency = I.currency;
END LOOP;

FOR I in C5 loop 
UPDATE /*+ parallel( pl_mark_value ) */ pl_mark_value sp SET sp.mark_name = 'HISTO_CUMULATIVE_CASH_PRINCIPAL'
WHERE sp.mark_id = I.mark_id AND sp.mark_name = I.mark_name AND sp.currency = I.currency;
END LOOP;

EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line('Error occured ' || SQLERRM);
END;
/

BEGIN
pl_mark_value_update;
END;
/

DROP PROCEDURE pl_mark_value_update
;

DELETE FROM domain_values WHERE value LIKE 'HISTO_CUMUL_CASH%'
;
DELETE FROM domain_values WHERE value LIKE 'HISTO_POS_CASH%'
;
DELETE FROM domain_values WHERE value LIKE 'HISTO_UNSETTLED_FEES%'
;
DELETE FROM domain_values WHERE value LIKE 'HISTO_BS%'
;
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlBondsEOD' AND value = 'HISTO_REALIZED'
;

UPDATE /*+ parallel( an_param_items ) */ an_param_items SET attribute_value = replace(attribute_value, 'HISTO_CUMUL_CASH', 'HISTO_CUMULATIVE_CASH') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_CUMUL_CASH%'
;
UPDATE /*+ parallel( an_param_items ) */ an_param_items SET attribute_value = replace(attribute_value, 'HISTO_POS_CASH', 'HISTO_POSITION_CASH') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_POS_CASH%'
;
UPDATE /*+ parallel( an_param_items ) */ an_param_items SET attribute_value = replace(attribute_value, 'HISTO_UNSETTLED_FEES', 'HISTO_FEES_UNSETTLED') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_UNSETTLED_FEES%'
;
UPDATE /*+ parallel( an_param_items ) */ an_param_items SET attribute_value = replace(attribute_value, 'HISTO_BS', 'HISTO_CUMULATIVE_CASH_PRINCIPAL,HISTO_BOOK_VALUE,HISTO_CLEAN_BOOK_VALUE') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_BS%'
;

delete from termination_events where event_type ='BASKET RESTRUCTURING'
;
/* CAL-140998 */
update /*+ parallel( swap_leg ) */ swap_leg set compound_freq_style = 'Original' where compound_freq='NON' 
and product_id in (select product_id from product_desc 
where product_type in ('Swap', 'XCCySwap', 'Swaption', 'CappedSwap', 'NDS', 'SingleSwapLeg', 'SpreadSwap','AssetSwap', 'CDSIndexDefinition', 'CDSNthDefault', 'CDSNthLoss', 'CreditDefaultSwap', 'PerformanceSwap', 'TotalReturnSwap'))
;

/* CAL-138780 */
/* accretion value field is converted from number to string " */

/* CAL-138780 */
/* accretion value field is converted from number to string " */

begin
add_column_if_not_exists('accretion_schedule','column_strg_value', 'VARCHAR(128) NULL');
add_column_if_not_exists('accretion_schedule_hist','column_strg_value', 'VARCHAR(128) NULL');
END;
/ 

UPDATE /*+ parallel( accretion_schedule ) */ accretion_schedule SET column_strg_value = CAST(column_value AS VARCHAR(128))
;
UPDATE  /*+ parallel( accretion_schedule_hist ) */ accretion_schedule_hist SET column_strg_value = CAST(column_value AS VARCHAR(128))
;

 
CREATE TABLE tempInflRateIndex AS (select rate_index_code from rate_index_default where index_type = 'Inflation')
;

UPDATE /*+ parallel( swap_leg ) */ swap_leg SET fixed_rate = 0.01
where 
EXISTS(
select swap_leg.product_id from tempInflRateIndex where swap_leg.leg_type = 'Float' and swap_leg.rate_index like '%'||tempInflRateIndex.rate_index_code||'%' and swap_leg.fixed_rate = 0
)
;

DROP TABLE tempInflRateIndex
;

/* CAL-141672 */
/* PositionInventory support */
begin
add_domain_values('PositionBasedProducts','PositionInventory','PositionInventory out of box position based product');
end;
/
create or replace procedure insert_mark_ca_cost_ca_pv
as
 cursor select_mark_npv_cur1 is
	select pl_mark.mark_id,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment
	from pl_mark,pl_mark_value
	where
	pl_mark.mark_id=pl_mark_value.mark_id
	and pl_mark.mark_id not in(
		select mark_id
		from pl_mark_value
		where mark_name IN ('CA_PV','CA_COST')
	)
	and mark_name='NPV';
   
    begin
    for c1_rec in select_mark_npv_cur1 LOOP
    	insert into pl_mark_value(mark_id,mark_name,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment)
values(c1_rec.mark_id,'CA_PV',c1_rec.mark_value,c1_rec.currency,c1_rec.display_class,c1_rec.display_digits,c1_rec.adj_value,c1_rec.is_adjusted,c1_rec.adj_type,c1_rec.adj_comment);
		insert into pl_mark_value(mark_id,mark_name,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment)
values(c1_rec.mark_id,'CA_COST',0,c1_rec.currency,c1_rec.display_class,c1_rec.display_digits,0,0,'','');

    end loop;
end;
/
begin
insert_mark_ca_cost_ca_pv;
end;
/
drop procedure insert_mark_ca_cost_ca_pv
;
create table cds_matrix_cfg_bak as select * from cds_settlement_matrix_config
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set seniority = 'ANY' where seniority is NULL
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set red_region = regexp_substr(usage_key, '[^|]+', 1, 1)
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set red_type = regexp_substr(usage_key, '[^|]+', 1, 2)
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set seniority = regexp_substr(usage_key, '[^|]+', 1, 3) 
where regexp_substr(usage_key, '[^|]+', 1, 3) is not null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set red_jurisdiction = 'ANY' where red_jurisdiction is null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set red_sector = 'ANY' where red_sector is null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set rating = 'ANY' where rating is null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set standard = 'ANY' where standard is null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set usage = 'MATRIX' where usage is null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set product_type = 'CreditDefaultSwap' where product_type is null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set effective_date = (select period_start from cds_settlement_matrix c where c.matrix_id=cds_settlement_matrix_config.matrix_id) where effective_date is null
;
update /*+ parallel( cds_settlement_matrix_config ) */ cds_settlement_matrix_config set data_value = to_char(matrix_id) where data_value is null
;
alter table cds_settlement_matrix_config DROP PRIMARY KEY DROP INDEX
;


update /*+ parallel( feed_address ) */ feed_address set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

update /*+ parallel( quote_name ) */ quote_name set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

update /*+ parallel( quote_value ) */ quote_value set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

update /*+ parallel( quote_value_hist ) */ quote_value_hist set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

update /*+ parallel( trade_diary ) */ trade_diary set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

update  /*+ parallel( trade_diary_hist ) */ trade_diary_hist set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

update  /*+ parallel( product_desc_hist ) */  product_desc_hist set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

update  /*+ parallel( product_desc ) */  product_desc set quote_name=nvl(substr(quote_name,1,instr(quote_name,'.',1,4)-1), quote_name) where quote_name in 
(select quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))
;

delete from DOMAIN_VALUES where name = 'plAttribute'
;

begin
add_domain_values('plAttribute','Adjusted',null);
add_domain_values('plAttribute','Mark Status',null);
add_domain_values('plAttribute','Bucket',null);
add_domain_values('plAttribute','Bucket Date',null);
add_domain_values('plAttribute','PL Maturity Date',null);
add_domain_values('plAttribute','PL State',null);
add_domain_values('plAttribute','PL Status',null);
end;
/
CREATE OR REPLACE procedure add_pl_attribute_data
IS
    v_attrib_cnt number(6);

    cursor c1 is
      select param_name
      from analysis_param
      where class_name='com.calypso.tk.risk.CrossAssetPLParam';

BEGIN

        v_attrib_cnt := 0;

    delete from an_param_items 
    where   class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
    and     attribute_name = 'PL_ATTRIBUTES'
    and     attribute_value = 'PL End Date,PL Maturity Date,Adjusted,Bucket,Bucket Date,Mark Status,PL State,PL Status';

    FOR param_rec in c1
    LOOP
        select  count(*)
        into    v_attrib_cnt 
        from    an_param_items 
        where   param_name = param_rec.param_name
        and     class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
        and     attribute_name = 'PL_ATTRIBUTES';
        
        IF (v_attrib_cnt = 0) THEN
          insert into an_param_items ( param_name, class_name, attribute_name, attribute_value)
          values ( param_rec.param_name, 
                  'com.calypso.tk.risk.CrossAssetPLParam', 
                  'PL_ATTRIBUTES', 
                  'PL Maturity Date,Adjusted,Bucket,Bucket Date,Mark Status,PL State,PL Status');

         
        END IF;  
        
    END LOOP;

END;
/
begin
add_pl_attribute_data;
end;
/
drop procedure add_pl_attribute_data
;
/* CAL- 125793 */


update  /*+ parallel( ps_event ) */  ps_event set create_timestamp=sysdate
;



CREATE OR REPLACE PROCEDURE add_prd_var_if_not_exist
    (tab_name IN varchar2)
      
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER(tab_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        execute immediate 'create table '|| tab_name ||'(
        product_id numeric not null,
        swap_type varchar2(16),
        underlying_id numeric not null,
         start_date timestamp  null,
        end_date timestamp  null,
        settle_date timestamp  null )';
   END IF;
END;
/
begin
add_prd_var_if_not_exist('product_variance_option');
end;
/
drop procedure add_prd_var_if_not_exist
;
begin
add_column_if_not_exists ('product_variance_option','vol_reference','float null');
add_column_if_not_exists ('product_variance_option','strike','float null');
add_column_if_not_exists ('product_variance_swap','vol_reference','float null');
end;
/

update /*+ parallel( product_variance_option ) */  product_variance_option set vol_reference = strike
;
update /*+ parallel( product_variance_swap ) */ product_variance_swap set vol_reference = strike
;
delete from DOMAIN_VALUES where value ='TD_ACRUAL_BS'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'NamesForPNL' AND value = 'PNLMTMAndAccruals'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'NamesForPNL' AND value = 'PNLTradeDateCash'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Cost_Of_Carry_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Cost_Of_Carry_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Realized_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Realized_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Total_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Trade_Full_Base_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Trade_Translation_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Unrealized_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLMTMAndAccruals' AND value = 'Unrealized_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Accrual_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Accrual_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Accrued_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Accrued_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Cash_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Cash_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Cost_Of_Carry_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Cost_Of_Carry_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Cost_Of_Funding_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Funding_Cost_FX_Reval'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Paydown_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Paydown_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Interests_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Interests_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Realized_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Price_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Price_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Sale_Realized_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Sale_Realized_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Total_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Cash_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Cash_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Fees_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Fees_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Interests_Full'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Interests'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Net_Full_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Net_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Translation_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PNLTrader' AND value = 'Cost_Of_Carry_PnL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_DISC_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_NET_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_NET'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlBondsEOD' AND value = 'NPV_DISC_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlEquitiesEOD' AND value = 'NPV_NET_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlEquitiesEOD' AND value = 'NPV_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlETOEOD' AND value = 'NPV_NET_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlETOEOD' AND value = 'NPV_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlFuturesEOD' AND value = 'NPV_NET_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlFuturesEOD' AND value = 'NPV_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlMMEOD' AND value = 'NPV_NET'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlOTCEOD' AND value = 'ACCUMULATED_ACCRUAL'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlOTCEOD' AND value = 'NPV_NET'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlPhysComEOD' AND value = 'NPV_NET_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlPhysComEOD' AND value = 'NPV_NET'
;
DELETE FROM DOMAIN_VALUES WHERE name = 'PricerMeasurePnlPhysComEOD' AND value = 'NPV_WITH_COST'
;
DELETE FROM DOMAIN_VALUES WHERE value = 'Intraday_Cost_Of_Funding_FX_Reval'
;
DELETE FROM DOMAIN_VALUES WHERE value = 'Intraday_Trade_Cash_FX_Reval'
;
UPDATE an_param_items SET attribute_value = replace(attribute_value, 'Intraday_Cost_Of_Funding_FX_Reval', '') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_MEASURES_LIST' AND attribute_value LIKE '%Intraday_Cost_Of_Funding_FX_Reval%'
;
UPDATE an_param_items SET attribute_value = replace(attribute_value, 'Intraday_Trade_Cash_FX_Reval', '') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_MEASURES_LIST' AND attribute_value LIKE '%Intraday_Trade_Cash_FX_Reval%'
;
BEGIN
FOR i IN 1..10 LOOP
UPDATE an_param_items SET attribute_value = replace(attribute_value, ',,', ',') 
WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_MEASURES_LIST' AND attribute_value LIKE '%,,%';
END LOOP;
END;
/

/* CAL-139498 */

begin 
drop_table_if_exists('tokenstore');
end;
/
UPDATE mrgcall_config SET mrgcall_config.discount_currency =
(SELECT currency_code FROM mrgcall_config_currency
WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def AND mrgcall_config_currency.mrg_call_def in (select mrgcall_config.mrg_call_def
FROM mrgcall_config, mrgcall_config_currency
WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def
GROUP BY mrgcall_config.mrg_call_def
HAVING count(mrgcall_config.mrg_call_def) = 1))
WHERE mrgcall_config.discount_currency is NULL 
;

delete from pc_param
where pricer_name = 'PricerSwaptionOneFactorModel'
;

delete from pc_param
where pricer_name = 'PricerSwaptionMultiFactorModel'
;

delete from pc_param
where pricer_name = 'PricerCapFloorMultiFactorModel'
;

delete from pc_param
where pricer_name = 'PricerSpreadCapFloor'
;

delete from pc_param
where pricer_name = 'PricerSingleSwapLegExotic'
;
update  /*+ parallel( pc_pricer ) */ pc_pricer
set product_pricer = 'PricerSwaptionLGMM1F'
where product_pricer = 'PricerSwaptionLGMM'
;

delete from domain_values
where name = 'Swaption.Pricer'
and value = 'PricerSwaptionLGMM'
;

delete from pc_param
where pricer_name = 'PricerSwaptionLGMM'
;

update  /*+ parallel( pc_pricer ) */ pc_pricer
set product_pricer = 'PricerSwapLGMM1F'
where product_pricer = 'PricerSwapLGM'
;

delete from domain_values
where name = 'Swap.Pricer'
and value = 'PricerSwapLGM'
;

delete from pc_param
where pricer_name = 'PricerSwapLGM'
;

CREATE OR REPLACE procedure add_unsettled_cash_fees
IS

    cursor c1 is
      select *
      from pl_mark_value
      where mark_name='UNSETTLED_CASH';

BEGIN

    FOR param_rec in c1
    LOOP 
      BEGIN
          insert into pl_mark_value ( mark_id, mark_name, mark_value, currency, display_class, display_digits, adj_type,
          adj_value, adj_comment, is_adjusted)
          values ( param_rec.mark_id, 'UNSETTLED_CASH_FEES', 0, param_rec.currency, param_rec.display_class, 
          param_rec.display_digits, '', 0, '', 0);
      EXCEPTION
        WHEN others THEN
        null;
      END;    
       
    END LOOP;

END;
/


begin
add_unsettled_cash_fees;
end;
/

CREATE OR REPLACE procedure add_histo_unsettled_cash_fees
IS

    cursor c1 is
      select *
      from pl_mark_value
      where mark_name='HISTO_UNSETTLED_CASH';

BEGIN

    FOR param_rec in c1
    LOOP 
      BEGIN
          insert into pl_mark_value ( mark_id, mark_name, mark_value, currency, display_class, display_digits, adj_type,
          adj_value, adj_comment, is_adjusted)
          values ( param_rec.mark_id, 'HISTO_UNSETTLED_CASH_FEES', 0, param_rec.currency, param_rec.display_class, 
          param_rec.display_digits, '', 0, '', 0);
      EXCEPTION
               WHEN others THEN
               null;
      END;
    END LOOP;

END;
/

begin
add_histo_unsettled_cash_fees;
end;
/

CREATE OR REPLACE procedure rate_attr
IS
begin
declare 
    cursor c1 is
      select currency_code,rate_index_code
      from rate_attributes
      where attr_name='ROUND_FINAL_RATE_ONLY' and (upper(attr_value) = 'TRUE' or upper(attr_value)='Y' or upper(attr_value)='YES' or upper(attr_value)='T');
	  currency_code varchar2(50);
	  rate_index_code varchar2(50);
	  
BEGIN

    open c1;
	fetch c1 into currency_code , rate_index_code;
    while c1 %FOUND
	LOOP
	
	insert into rate_attributes ( currency_code, rate_index_code, attr_name, attr_value)
          values ( currency_code,rate_index_code, 'ROUND_FINAL_RATE','True');
		  fetch c1 into currency_code , rate_index_code;
    END LOOP;
end;
END;
/
begin
rate_attr;
end;
/


update  /*+ parallel( rate_attributes ) */ rate_attributes set attr_name='ROUND_FINAL_RATE_ISDA', attr_value ='true' 
where attr_name='ROUND_FINAL_RATE_ONLY' and (upper(attr_value) = 'TRUE' or upper(attr_value)='Y' or upper(attr_value)='YES' or upper(attr_value)='T')
;


DELETE FROM DOMAIN_VALUES WHERE value = 'Unrealized_FX_Base'
;

create or replace procedure updateunrealizedfx
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Unrealized_FX_Base,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Unrealized_FX_Base,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Unrealized_FX_Base,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateunrealizedfx;
end;
/

create or replace procedure updateunrealizedfx_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Unrealized_FX_Base' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Unrealized_FX_Base' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateunrealizedfx_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Unrealized_FX_Base','') where  attribute_value like '%,Unrealized_FX_Base' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */  an_param_items  set attribute_value=replace(attribute_value,',Unrealized_FX_Base,',',') where  attribute_value like '%,Unrealized_FX_Base,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value = 'Trade_Date_Cash_Full_PnL'
;

create or replace procedure updatetradefullpnl
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Cash_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Trade_Date_Cash_Full_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Trade_Date_Cash_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatetradefullpnl;
end;
/

create or replace procedure updatetradefullpnl_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Cash_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Trade_Date_Cash_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatetradefullpnl_1;
end;
/

update /*+ parallel( an_param_items ) */  an_param_items  set attribute_value= replace(attribute_value,',Trade_Date_Cash_Full_PnL','') where  attribute_value like '%,Trade_Date_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Trade_Date_Cash_Full_PnL,',',') where  attribute_value like '%,Trade_Date_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;


DELETE FROM DOMAIN_VALUES WHERE value = 'Total_Accrual_PnL'
;

create or replace procedure updatetotalaccrual
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Total_Accrual_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Total_Accrual_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Total_Accrual_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatetotalaccrual;
end;
/

create or replace procedure updatetotalaccrual_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Total_Accrual_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Total_Accrual_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatetotalaccrual_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Total_Accrual_PnL','') where  attribute_value like '%,Total_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Total_Accrual_PnL,',',') where  attribute_value like '%,Total_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;


DELETE FROM DOMAIN_VALUES WHERE value = 'Trade_Full_Accrual_PnL'
;

create or replace procedure updatetradeaccrualpnl
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Full_Accrual_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Trade_Full_Accrual_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Trade_Full_Accrual_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatetradeaccrualpnl;
end;
/

create or replace procedure updatetradeaccrualpnl_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Full_Accrual_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Trade_Full_Accrual_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatetradeaccrualpnl_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Trade_Full_Accrual_PnL','') where  attribute_value like '%,Trade_Full_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Trade_Full_Accrual_PnL,',',') where  attribute_value like '%,Trade_Full_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value = 'Trade_Date_Full_Base_PnL'
;

create or replace procedure updatetradedatefullpnl
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Trade_Date_Full_Base_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Trade_Date_Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatetradedatefullpnl;
end;
/

create or replace procedure updatetradedatefullpnl_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Trade_Date_Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatetradedatefullpnl_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Trade_Date_Full_Base_PnL','') where  attribute_value like '%,Trade_Date_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Trade_Date_Full_Base_PnL,',',') where  attribute_value like '%,Trade_Date_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;


DELETE FROM DOMAIN_VALUES WHERE value = 'Trade_Date_Cash_FX_Reval'
;

create or replace procedure updatetradedatecashreval
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Cash_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Trade_Date_Cash_FX_Reval,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Trade_Date_Cash_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatetradedatecashreval;
end;
/

create or replace procedure updatetradedatecashreval_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Cash_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Trade_Date_Cash_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatetradedatecashreval_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Trade_Date_Cash_FX_Reval','') where  attribute_value like '%,Trade_Date_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Trade_Date_Cash_FX_Reval,',',') where  attribute_value like '%,Trade_Date_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value = 'Trade_date_Unrealized_FX_Reval'
;

create or replace procedure updatetradedateunrealized
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_date_Unrealized_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Trade_date_Unrealized_FX_Reval,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Trade_date_Unrealized_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatetradedateunrealized;
end;
/

create or replace procedure updatetradedateunrealized_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_date_Unrealized_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Trade_date_Unrealized_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatetradedateunrealized_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Trade_date_Unrealized_FX_Reval','') where  attribute_value like '%,Trade_date_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Trade_date_Unrealized_FX_Reval,',',') where  attribute_value like '%,Trade_date_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value = 'Trade_Date_Cash_Unrealized_FX_Reval'
;

create or replace procedure updatetradeunrealizedfx
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Cash_Unrealized_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Trade_Date_Cash_Unrealized_FX_Reval,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Trade_Date_Cash_Unrealized_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatetradeunrealizedfx;
end;
/

create or replace procedure updatetradeunrealizedfx_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Trade_Date_Cash_Unrealized_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Trade_Date_Cash_Unrealized_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatetradeunrealizedfx_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Trade_Date_Cash_Unrealized_FX_Reval','') where  attribute_value like '%,Trade_Date_Cash_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Trade_Date_Cash_Unrealized_FX_Reval,',',') where  attribute_value like '%,Trade_Date_Cash_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value = 'SL_Fees_PnL'
;

create or replace procedure updateslfeespnl
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'SL_Fees_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='SL_Fees_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'SL_Fees_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateslfeespnl;
end;
/

create or replace procedure updateslfeespnl_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'SL_Fees_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'SL_Fees_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateslfeespnl_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',SL_Fees_PnL','') where  attribute_value like '%,SL_Fees_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',SL_Fees_PnL,',',') where  attribute_value like '%,SL_Fees_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value LIKE '%Intraday%PnL'
;

create or replace procedure updateintraday_1
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Accrual_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Accrual_Full_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Accrual_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_1;
end;
/

create or replace procedure updateintraday_2
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Accrual_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Accrual_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_2;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Accrual_Full_PnL','') where  attribute_value like '%,Intraday_Accrual_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Accrual_Full_PnL,',',') where  attribute_value like '%,Intraday_Accrual_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_3
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Cash_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Cash_Full_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Cash_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_3;
end;
/

create or replace procedure updateintraday_4
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Cash_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Cash_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_4;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Cash_Full_PnL','') where  attribute_value like '%,Intraday_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Cash_Full_PnL,',',') where  attribute_value like '%,Intraday_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_5
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Realized_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Realized_Full_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Realized_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_5;
end;
/

create or replace procedure updateintraday_6
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Realized_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Realized_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_6;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Realized_Full_PnL','') where  attribute_value like '%,Intraday_Realized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Realized_Full_PnL,',',') where  attribute_value like '%,Intraday_Realized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_7
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Translation_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Translation_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Translation_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_7;
end;
/

create or replace procedure updateintraday_8
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Translation_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Translation_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_8;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Translation_PnL','') where  attribute_value like '%,Intraday_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Translation_PnL,',',') where  attribute_value like '%,Intraday_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_9
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Unrealized_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Unrealized_Full_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Unrealized_Full_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_9;
end;
/

create or replace procedure updateintraday_10
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Unrealized_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Unrealized_Full_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_10;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Unrealized_Full_PnL','') where  attribute_value like '%,Intraday_Unrealized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Unrealized_Full_PnL,',',') where  attribute_value like '%,Intraday_Unrealized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_11
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Trade_Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Trade_Full_Base_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Trade_Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_11;
end;
/

create or replace procedure updateintraday_12
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Trade_Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Trade_Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_12;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Trade_Full_Base_PnL','') where  attribute_value like '%,Intraday_Trade_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Trade_Full_Base_PnL,',',') where  attribute_value like '%,Intraday_Trade_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_13
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Cost_Of_Funding_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Cost_Of_Funding_FX_Reval,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Cost_Of_Funding_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_13;
end;
/

create or replace procedure updateintraday_14
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Cost_Of_Funding_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Cost_Of_Funding_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_14;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Cost_Of_Funding_FX_Reval','') where  attribute_value like '%,Intraday_Cost_Of_Funding_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Cost_Of_Funding_FX_Reval,',',') where  attribute_value like '%,Intraday_Cost_Of_Funding_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_15
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Cost_Of_Funding_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Cost_Of_Funding_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Cost_Of_Funding_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_15;
end;
/

create or replace procedure updateintraday_16
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Cost_Of_Funding_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Cost_Of_Funding_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_16;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Cost_Of_Funding_PnL','') where  attribute_value like '%,Intraday_Cost_Of_Funding_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Cost_Of_Funding_PnL,',',') where  attribute_value like '%,Intraday_Cost_Of_Funding_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_17
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Full_Base_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_17;
end;
/

create or replace procedure updateintraday_18
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_18;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Full_Base_PnL','') where  attribute_value like '%,Intraday_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Full_Base_PnL,',',') where  attribute_value like '%,Intraday_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_19
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Trade_Cash_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Trade_Cash_FX_Reval,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Trade_Cash_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_19;
end;
/

create or replace procedure updateintraday_20
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Trade_Cash_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Trade_Cash_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_20;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Trade_Cash_FX_Reval','') where  attribute_value like '%,Intraday_Trade_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Intraday_Trade_Cash_FX_Reval,',',') where  attribute_value like '%,Intraday_Trade_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

create or replace procedure updateintraday_21
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Trade_Translation_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Intraday_Trade_Translation_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Intraday_Trade_Translation_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updateintraday_21;
end;
/

create or replace procedure updateintraday_22
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Intraday_Trade_Translation_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Intraday_Trade_Translation_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updateintraday_22;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Intraday_Trade_Translation_PnL','') where  attribute_value like '%,Intraday_Trade_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */  an_param_items  set attribute_value=replace(attribute_value,',Intraday_Trade_Translation_PnL,',',') where  attribute_value like '%,Intraday_Trade_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value = 'Cash_FX_Reval'
;

create or replace procedure updatecashfxreval
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Cash_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Cash_FX_Reval,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Cash_FX_Reval,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatecashfxreval;
end;
/

create or replace procedure updatecashfxreval_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Cash_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Cash_FX_Reval' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatecashfxreval_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Cash_FX_Reval','') where  attribute_value like '%,Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value=replace(attribute_value,',Cash_FX_Reval,',',') where  attribute_value like '%,Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

DELETE FROM DOMAIN_VALUES WHERE value = 'Full_Base_PnL'
;

create or replace procedure updatefullbasepnl
is
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	v1 := substr(parseval, 1, parse_index);
	if v1='Full_Base_PnL,' then
		parseval := substr(parseval,parse_index+1,length(parseval));
		update an_param_items  set attribute_value =parseval where attribute_value like 'Full_Base_PnL,%' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
	fetch cur_main1 into parseval ;
	end	loop;
end;
end;
/
begin
updatefullbasepnl;
end;
/

create or replace procedure updatefullbasepnl_1
is 
begin
declare 
cursor cur_main1 is 
select attribute_value from an_param_items where attribute_value like 'Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
parseval varchar2(255) ;
v1  varchar2(255) ; 
parse_index number ; 
begin
open cur_main1;
		fetch cur_main1 into parseval ;
while cur_main1 %FOUND
	loop
		parse_index := instr(parseval,',');
	if parse_index=0 then
		update an_param_items  set attribute_value ='' where attribute_value  like 'Full_Base_PnL' and class_name  = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST';
	end if;
fetch cur_main1 into parseval ;
	end	loop;
   
end;
end;     
/
begin
updatefullbasepnl_1;
end;
/

update /*+ parallel( an_param_items ) */ an_param_items  set attribute_value= replace(attribute_value,',Full_Base_PnL','') where  attribute_value like '%,Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

update /*+ parallel( an_param_items ) */  an_param_items  set attribute_value=replace(attribute_value,',Full_Base_PnL,',',') where  attribute_value like '%,Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
;

/* Data Model Changes END */

/* Domain Values Changes BEGIN */

INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16562,'CVA_EXPOSURE','ALL','CVA Allocated per Trade','FULL','INVENTORY','N/A','NONE','CVA_ALLOCATION,CVA_CREDITSIM',0 )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (13918,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16551,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16552,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16553,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16554,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16555,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16556,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16557,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16558,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16559,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'REMOVE_HEDGE_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16562,'MATURED_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16562,'TRADE_VALUATION' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16562,'CANCELED_TRADE' )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('MultiSensitivity','apps.risk.MultiSensitivityJideViewer',0 )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('HedgeEffectivenessProspective','apps.risk.HedgeEffectivenessProspectiveViewer',0 )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('Rebalancing','apps.risk.RebalancingAnalysisReportFrameworkViewer',0 )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('PositionTransferPrice','To specify the type of pricing to use during transfer' )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('Can Take Positions','Indicates if the book can take positions' )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('Domiciliation','Indicates if the book is for onshore or offshore trades.  Blank for not applicable.' )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'BetaMatrix',500 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'CARules',500 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'CWSDocument',500)
;
declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='LifeCycleEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES ( n,'LifeCycleEngine','' );
end if;
end;
/

INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','RISK_OPTIMISE','true' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_CALIBRATION_INSTRUMENTS','CORE_SWAPTION' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_CALIBRATION_SCHEME','EXACT_STEP_SIGMA' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_CONTROL_VARIATE','true' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_LATTICE_NODES','35' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_QUAD_ORDER','20' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_LATTICE_CUTOFF','6.0' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ('default','ANY','USE_NATIVE_CURRENCY','false' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ('default','MBSFixedRate','USE_PROJ_FOR_HIST_CF','true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ('default','MBSArm','USE_ARM_COMPONENTS','true' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','BondExoticNote.ANY.ANY','PricerBlackNFMonteCarloExotic' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Bond.ANY.BondExoticNote','PricerBondExoticNote' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.American.TradingWarrant','PricerBlack1FFiniteDifference' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.European.TradingWarrant','PricerBlack1FAnalyticVanilla' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.American.IndexWarrant','PricerBlack1FFiniteDifference' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.European.IndexWarrant','PricerBlack1FAnalyticVanilla' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquity.ANY.American','PricerBlack1FFiniteDifference' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquityIndex.ANY.American','PricerBlack1FFiniteDifference' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquity.ANY.European','PricerBlack1FAnalyticDiscreteVanilla' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquityIndex.ANY.European','PricerBlack1PricerBlack1FAnalyticDiscreteVanilla' )
;

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricer_measure WHERE measure_name = 'SEC_FIN_SECURITY_ACCRUAL' and measure_id=418;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_SECURITY_ACCRUAL','tk.core.PricerMeasure',418,'' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricer_measure WHERE measure_name = 'SEC_FIN_SECURITY_VALUE' and measure_id=419;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_SECURITY_VALUE','tk.core.PricerMeasure',419,'' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricer_measure WHERE measure_name = 'SEC_FIN_SECURITY_CLEAN_VALUE' and measure_id=420;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_SECURITY_CLEAN_VALUE','tk.core.PricerMeasure',420,'' );
	END;	
	END IF;
END;
/
DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricer_measure WHERE measure_name = 'SEC_FIN_LIABILITY' and measure_id=421;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_LIABILITY','tk.core.PricerMeasure',421,'' );
	END;	
	END IF;
END;
/

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRICE_NOTE','tk.core.PricerMeasure',424,'' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRICE_NOTE_ACCRUAL_ADJ','tk.core.PricerMeasure',425,'' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('DV01_SPREAD','tk.core.PricerMeasure',426,'Change in NPV by change in SPREAD on Floating Leg' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PV_OPEN','tk.core.PricerMeasure',427,'NPV previous day + Accrual' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SUM_FUT_FLOWS','tk.core.PricerMeasure',428,'Sum of the future flows' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_NOTIONAL','tk.pricer.PricerMeasureCANotional',429,'Cross Asset Notional' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('NPV_BASE','tk.core.PricerMeasure',432,'NPV base currency' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRIMARY_NPV_BASE','tk.core.PricerMeasure',433,'NPV primary base currency' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('QUOTING_NPV_BASE','tk.core.PricerMeasure',434,'NPV quoting base currency' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CVA_ALLOCATION','tk.pricer.PricerMeasureCVAFromDB',435,'PL Mark; CVA from BO' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CVA_CREDITSIM','tk.pricer.PricerMeasureCVAFromDB',436,'PL Mark; CVA from ERS' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_COST','tk.pricer.PricerMeasureCACost',437,'Corss Asset COST' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_PV','tk.pricer.PricerMeasureCA_PV',438,'Corss Asset PV' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_MARKET_PRICE','tk.pricer.PricerMeasureCAMarketPrice',439,'Corss Asset Market Price' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR_PAR','tk.pricer.PricerMeasureChilean',440,'Chilean Bond Valor Par Measure' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRECIO','tk.pricer.PricerMeasureChilean',441,'Chilean Bond Precio Measure' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR_ACTUAL','tk.pricer.PricerMeasureChilean',442,'Chilean Bond Valor Actual Measure' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR','tk.pricer.PricerMeasureChilean',443,'Chilean Bond Valor Measure' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR_MERCADO','tk.pricer.PricerMeasureChilean',444,'Chilean Bond Valor Mercado Measure' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CUMULATIVE_MARGIN','tk.core.PricerMeasure',445,'Sum of all the margin payments made on the trade' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeValuation','CreEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventLifeCycle','MessageEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventArray','InventoryEngine' )
;
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','LifeCycleEngine','LifeCycleEngineEventFilter' )
;
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','MessageEngine','MessageEngineEntityObjectEventFilter' )
;

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='AAA';
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','AAA',0,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='AA' and order_id=1;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','AA',1,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='A' and order_id=2;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','A',2,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='BBB' and order_id=3;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','BBB',3,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='BB' and order_id=4;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','BB',4,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='B' and order_id=5;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','B',5,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='CCC' and order_id=6;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','CCC',6,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='CC' and order_id=7;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','CC',7,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='C' and order_id=8;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','C',8,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='DDD' and order_id=9;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','DDD',9,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='DD' and order_id=10;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','DD',10,'Current' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM rating_values WHERE agency_name = 'Markit' and rating_value='D' and order_id=11;
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','D',11,'Current' );
	END;	
	END IF;
END;
/
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','AA+',1,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','AA-',1,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BBB+',3,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BBB-',3,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BB+',4,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BB-',4,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','B+',5,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','B-',5,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','CCC+',6,'Current' )
;
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','CCC-',6,'Current' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('bond_exotic_note','Table for Product BondExoticNote' )
;

INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('Swap','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CapFloor','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('Swaption','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CancellableSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CancellableXCCySwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CappedSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('ExtendibleSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('NDS','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SpreadCapFloor','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SpreadSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SpreadLock','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('StructuredProduct','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('FRA','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('Cash','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SimpleMM','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('DualCcyMM','com.calypso.apps.trading.CSATabTradeWindow',0 )
;

begin
add_column_if_not_exists('entity_attributes','ATTR_NUMERIC_VALUE', 'float');
 END;
/ 

INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2101481,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2142666,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2142762,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2374992,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2514741,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2550812,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2571239,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2106933,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2110576,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2110963,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2544407,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110576,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2544407,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2044628,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CBNS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2551959,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2551971,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2550812,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU,CBNS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111076,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111074,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2106933,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110963,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464424,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CRTS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2142762,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CRTS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2074445,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CRTS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2571239,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2061013,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2462631,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2514235,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2374992,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110576,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2544407,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2044628,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XBNS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2550812,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX,XBNS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111076,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111074,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2106933,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110963,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464424,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XRTS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2142762,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XRTS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2074445,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XRTS' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2571239,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2061013,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2514235,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
;
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2374992,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
;
INSERT INTO system_settings ( name, value ) VALUES ('MAIN_ENTRY_STOP_DB_CONNECTIONS','true' )
;
INSERT INTO cds_settlement_matrix_config ( user_name, red_region, red_type, red_jurisdiction, red_sector, seniority, standard, rating, usage, product_type, effective_date, data_value, matrix_id, usage_key ) VALUES ('_ANY_','ANY','ANY','ANY','ANY','ANY','STANDARD','ANY','RECOVERY','CreditDefaultSwap',TIMESTAMP'1970-01-01 00:00:00.0','40',0,'ANY' )
;
INSERT INTO cds_settlement_matrix_config ( user_name, red_region, red_type, red_jurisdiction, red_sector, seniority, standard, rating, usage, product_type, effective_date, data_value, matrix_id, usage_key ) VALUES ('_ANY_','ANY','ANY','ANY','ANY','SUBORDINATE','STANDARD','ANY','RECOVERY','CreditDefaultSwap',TIMESTAMP'1970-01-01 00:00:00.0','20',0,'ANY' )
;
INSERT INTO cds_settlement_matrix_config ( user_name, red_region, red_type, red_jurisdiction, red_sector, seniority, standard, rating, usage, product_type, effective_date, data_value, matrix_id, usage_key ) VALUES ('_ANY_','ANY','ANY','ANY','ANY','ANY','STANDARD','ANY','RECOVERY','CreditDefaultSwapLoan',TIMESTAMP'1970-01-01 00:00:00.0','70',0,'ANY' )
;
 

BEGIN
add_domain_values ('eventClass','PSEventArray','');

add_domain_values('domainName','AdvanceStandardSingleSwapLegTemplateName','specify the SingleSwapLeg trade template name to be used by hypersurface advance generator');

add_domain_values('currencyDefaultAttribute','MarginCallAdjLag','DATE_RULE');

add_domain_values('currencyDefaultAttribute','FundingIndex','Funding Index used in the calculation of Carry Cost on the Liquid Assets Buffer');

add_domain_values('currencyDefaultAttribute','FundingIndexTenor','Funding Index Tenor in the calculation of Carry Cost on the Liquid Assets Buffer');

add_domain_values('workflowRuleMessage','AddTransferBusinessReference','');

add_domain_values('currencyPairAttribute','RegulatoryValidationSource','Name of the FX Rate index which would provide the regulatory FX rate');

add_domain_values('currencyPairAttribute','RegulatoryTolerance','Regulatory Tolerance percentage');

add_domain_values('FutureEquity.subtype','ES','Extended settlement based FutureEquity');

add_domain_values('productType','IOPOIndex','IOPOIndex');

add_domain_values('productType','MBSFixedRate','MBSFixedRate');

add_domain_values('productType','MBSArm','MBSArm');

add_domain_values('productType','SpotPLSweep','SpotPLSweep');

add_domain_values('domainName','FutureEquity.subtype','FutureEquity product subtypes');

add_domain_values('CapFloor.subtype','Inflation','');

add_domain_values('domainName','BillingFeeType','Billing Fee Types');

add_domain_values('domainName','CurveDividend.gensimple','Simple Curve Dividend generators');

add_domain_values('CurveDividend.gensimple','DividendDiscrete','');

add_domain_values('domainName','CurveDividend.gen','Curve Dividend generators');

add_domain_values('CurveDividend.gen','DividendImplied','');

add_domain_values('volSurfaceGenerator','Spline','');

add_domain_values('domainName','AccountSweepingRuleType','Used in acc_sweep_cfg to indicate the rule type.');

add_domain_values('sdiAttribute','AccountMapping','');

add_domain_values('tradeKeyword','PositionTransferPrice','');

add_domain_values('tradeKeyword','PosTransferId','Id of the associated position transfer');

add_domain_values('tradeKeyword','PosTransferDst','This is the destination trade in a pos transfer');

add_domain_values('tradeKeyword','HedgeType','Keyword to classify whether a trade is used to hedge an asset or a liability.Values expected are Asset or Liability.Used in forward ladder analysis');

add_domain_values('leAttributeType','RequireTripartyRepoAgreement','');

add_domain_values('domainName','leAttributeType.RequireTripartyRepoAgreement','');

add_domain_values('leAttributeType.RequireTripartyRepoAgreement','false','');

add_domain_values('leAttributeType.RequireTripartyRepoAgreement','true','');

add_domain_values('leAttributeType','RegulatoryRateQuoteSource','Quote Source name for retrieving the regulatory FX Rate');

add_domain_values('domainName','CountryAttributes','Country attributes');

add_domain_values('CountryAttributes','CATradeBasis','If true, it means trades have to manage CUM or EX cases.');

add_domain_values('CountryAttributes','AutoCompensation','If true, process is driven by the fact that the trade deal was executed prior to the ex-date of the CA event and that the delayed settlement after record date appears like a fail. The market attempts to correct itself.');

add_domain_values('CountryAttributes','ReverseMarketClaim','If true, the market is attempting to correct the dividend flow and in the context of a SBL trade this results in the beneficial owner actually receiving the dividend through the Agent rather than needing to get it back from the counterparty.');

add_domain_values('function','CreateAnalyticsMeasure','');

add_domain_values('function','ModifyAnalyticsMeasure','');

add_domain_values('function','RemoveAnalyticsMeasure','');
COMMIT;
END;
/

BEGIN
add_domain_values('function','CreateCarveOut','');

add_domain_values('function','ModifyCarveOut','');

add_domain_values('function','RemoveCarveOut','');

add_domain_values('engineEventPoolPolicyAliases','LiquidationEvent','tk.util.TradeLiquidationEventSequencePolicy');

add_domain_values('engineEventPoolPolicyAliases','PositionEngine','tk.util.PositionEngineSequencePolicy');

add_domain_values('engineEventPoolPolicies','tk.util.TradeLiquidationSequencePolicy','Sequence Policy for the LiquidationEngine (optional)');

add_domain_values('engineEventPoolPolicies','tk.util.TradeLiquidationEventSequencePolicy','Sequence Policy of Liquidation Events for the TransferEngine (optional)');

add_domain_values('engineEventPoolPolicies','tk.util.PositionEngineSequencePolicy','Sequence Policy for the events processed by the position engine');

add_domain_values('classAuditMode','FeeConfig','');

add_domain_values('classAuditMode','AnalyticsMeasure','');

add_domain_values('classAuditMode','Basket','');

add_domain_values('classAuditMode','BetaValue','');

add_domain_values('classAuditMode','CARules','');

add_domain_values('domainName','BondMMDiscountWithAI.Pricer','Pricers for MM Discount bonds with AI');

add_domain_values('domainName','SwapCrossCurrency.Pricer','Pricers for SwapCrossCurrency');

add_domain_values('domainName','SwapNonDeliverable.Pricer','Pricers for SwapNonDeliverable');

add_domain_values('domainName','ETOIR.Pricer','Pricers for ETOIR (exchange traded equity option) trades');

add_domain_values('domainName','FutureStructuredFlows.Pricer','Pricer for StucturedFlow Futures');

add_domain_values('domainName','ADR.conversionAgentRole','List party possible role on ADR bust or creation');

add_domain_values('ADR.conversionAgentRole','Issuer','Default party role for ADR bust or creation');

add_domain_values('function','CAEdition','function name for Corporate Action edition restriction');

add_domain_values('function','ViewPortfolioSwapContract','function name for Portfolio Swap Contract view restriction');

add_domain_values('function','ModifyPortfolioSwapContract','function name for Portfolio Swap Contract edition restriction');

add_domain_values('restriction','CAEdition','function name for Corporate Action edition restriction');

add_domain_values('CurveZero.gen','BasisGlobal','Generator for yield curves using basis swaps, single currency or cross-currency.');

add_domain_values('CurveZero.gen','XCCYForwardBootStrap','Generator of forward curve using cross-currency basis swaps.');

add_domain_values('CurveZero.gen','XCCYForwardGlobal','Generator of forward curve using cross-currency basis swaps.');

add_domain_values('CurveBasis.gen','BasisGlobal','Generator for yield curves using basis swaps, single currency or cross-currency.');

add_domain_values('CurveBasis.gen','XCCYForwardBootStrap','Generator of forward curve using cross-currency basis swaps.');

add_domain_values('CurveBasis.gen','XCCYForwardGlobal','Generator of forward curve using cross-currency basis swaps.');

add_domain_values('Warrant.subtype','TradingWarrant','TradingWarrant');

add_domain_values('Warrant.subtype','CurrencyWarrant','CurrencyWarrant');

add_domain_values('Warrant.subtype','IndexWarrant','IndexWarrant');

add_domain_values('Warrant.subtype','InstalmentWarrant','InstalmentWarrant');

add_domain_values('Warrant.subtype','InvestmentWarrant','InvestmentWarrant');

add_domain_values('Warrant.subtype','InternationalWarrant','InternationalWarrant');

add_domain_values('Warrant.subtype','MINI','MINI');

add_domain_values('Warrant.subtype','CBBC','CBBC');

add_domain_values('domainName','Warrant.Covered','Warrant.Covered');

add_domain_values('Warrant.Covered','TradingWarrant','TradingWarrant');

add_domain_values('Warrant.Covered','InvestmentWarrant','InvestmentWarrant');

add_domain_values('Warrant.Covered','InternationalWarrant','InternationalWarrant');

add_domain_values('Warrant.Covered','MINI','MINI');

add_domain_values('Warrant.Covered','CBBC','CBBC');

add_domain_values('Warrant.Covered','CurrencyWarrant','CurrencyWarrant');

add_domain_values('Warrant.Covered','IndexWarrant','IndexWarrant');

add_domain_values('Warrant.Covered','Capped','Capped');

add_domain_values('domainName','Warrant.BuyBackPeriod','Warrant.BuyBackPeriod');

add_domain_values('Warrant.BuyBackPeriod','MINI','MINI');

add_domain_values('domainName','Warrant.SpecialQuote','Warrant.SpecialQuote');

add_domain_values('Warrant.SpecialQuote','TradingWarrant','TradingWarrant');
COMMIT;
END;
/

BEGIN
add_domain_values('Warrant.SpecialQuote','IndexWarrant','IndexWarrant');

add_domain_values('Warrant.SpecialQuote','InvestmentWarrant','InvestmentWarrant');

add_domain_values('Warrant.SpecialQuote','InstalmentWarrant','InstalmentWarrant');

add_domain_values('domainName','Warrant.DivPassThrough','Warrant.DivPassThrough');

add_domain_values('Warrant.DivPassThrough','TradingWarrant','TradingWarrant');

add_domain_values('Warrant.DivPassThrough','IndexWarrant','IndexWarrant');

add_domain_values('Warrant.DivPassThrough','InvestmentWarrant','InvestmentWarrant');

add_domain_values('Warrant.DivPassThrough','InstalmentWarrant','InstalmentWarrant');

add_domain_values('Warrant.DivPassThrough','InternationalWarrant','InternationalWarrant');

add_domain_values('Warrant.DivPassThrough','MINI','MINI');

add_domain_values('Warrant.DivPassThrough','CBBC','CBBC');

add_domain_values('domainName','Warrant.DeliveryUnderlying','Warrant.DeliveryUnderlying');

add_domain_values('Warrant.DeliveryUnderlying','InternationalWarrant','InternationalWarrant');

add_domain_values('domainName','Warrant.FxType','Warrant.FxType');

add_domain_values('Warrant.FxType','IndexWarrant','IndexWarrant');

add_domain_values('Warrant.FxType','TradingWarrant','TradingWarrant');

add_domain_values('Warrant.FxType','InternationalWarrant','InternationalWarrant');

add_domain_values('Warrant.FxType','CurrencyWarrant','CurrencyWarrant');

add_domain_values('domainName','Warrant.Barrier','Warrant.Barrier');

add_domain_values('Warrant.Barrier','TradingWarrant','TradingWarrant');

add_domain_values('Warrant.Barrier','IndexWarrant','IndexWarrant');

add_domain_values('Warrant.Barrier','MINI','MINI');

add_domain_values('Warrant.Barrier','CBBC','CBBC');

add_domain_values('domainName','Warrant.Attributes','Warrant.Attributes');

add_domain_values('Warrant.Attributes','TradingWarrant','TradingWarrant');

add_domain_values('Warrant.Attributes','IndexWarrant','IndexWarrant');

add_domain_values('Warrant.Attributes','InvestmentWarrant','InvestmentWarrant');

add_domain_values('Warrant.Attributes','CurrencyWarrant','CurrencyWarrant');

add_domain_values('Warrant.Attributes','InternationalWarrant','InternationalWarrant');

add_domain_values('Warrant.Attributes','MINI','MINI');

add_domain_values('Warrant.Attributes','CBBC','CBBC');

add_domain_values('Warrant.Attributes','Capped','Capped');

add_domain_values('Warrant.Attributes','Exotic','Exotic');

add_domain_values('domainName','Warrant.AveragePrice','Warrant.AveragePrice');

add_domain_values('Warrant.AveragePrice','TradingWarrant','TradingWarrant');

add_domain_values('Warrant.AveragePrice','IndexWarrant','IndexWarrant');

add_domain_values('domainName','tradeBarriersAction','Exercise Action ofa trade');

add_domain_values('tradeBarriersAction','KNOCK_OUT','');

add_domain_values('tradeBarriersAction','KNOCK_IN','');

add_domain_values('hedgeRelationshipAttributes','MaterialThreshold','Material limit for materiality check');

add_domain_values('hedgeRelationshipAttributes','CVAMeasure','Must contains the name of the CVA pricer measure to use for Hedge Effectiveness');

add_domain_values('FASEffMethodPro','Simulation','Simulation');

add_domain_values('tradeKeyword','FRC Far Leg ID','');

add_domain_values('tradeKeyword','FRC Near Leg ID','');

add_domain_values('domainName','BondExoticNote.subtype','Types of bond exotic note');
commit;
END;
/

BEGIN
add_domain_values('domainName','BondMMDiscountWithAI.subtype','Types of MM Discount bonds with AI');

add_domain_values('domainName','ETOIR.subtype','');

add_domain_values('domainName','IRStructuredOption.subtype','IRStructuredOption.subtype domain name');

add_domain_values('domainName','StaticPricingScriptDefinitionSuites','Names of static pricing script definition suites');

add_domain_values('StaticPricingScriptDefinitionSuites','alpha','');

add_domain_values('StaticPricingScriptDefinitionSuites','examples','');

add_domain_values('StaticPricingScriptDefinitionSuites','gamma','');

add_domain_values('classAuthMode','FeeConfig','');

add_domain_values('classAuditMode','BookSubsitutionRequest','');

add_domain_values('StructuredFlows.subtype','OpenTerm','');

add_domain_values('StructuredFlows.subtype','RollOver','');

add_domain_values('StructuredFlows.subtype','Discount','');

add_domain_values('StructuredFlows.subtype','Standard','');

add_domain_values('StructuredFlows.subtype','Exotic','');

add_domain_values('classAuditMode','IOPOIndex','');

add_domain_values('PositionBasedProducts','FutureEquity','FutureEquity out of box position based product');

add_domain_values('PositionBasedProducts','BondExoticNote','BondExoticNote out of box position based product');

add_domain_values('PositionBasedProducts','ETOIR','ETOIR out of box position based product');

add_domain_values('PositionBasedProducts','PortfolioSwapPosition','');

add_domain_values('PositionBasedProducts','SpotPLSweep','');

add_domain_values('domainName','bookAttribute.Domiciliation','');

add_domain_values('XferAttributes','CATradeBasis','');

add_domain_values('XferAttributes','CATradeBasisOverride','This attribute is used to override CATradeBasis attribute.');

add_domain_values('XferAttributes','SwapNDNativeCurrency','');

add_domain_values('XferAttributes','SwapNDNativeInterestAmt','');

add_domain_values('XferAttributes','SwapNDIntermediateCurrency','');

add_domain_values('XferAttributes','SwapNDIntermediateResetDate','');

add_domain_values('XferAttributes','SwapNDIntermediateResetRate','');

add_domain_values('XferAttributes','SwapNDIntermediateFXDescription','');

add_domain_values('XferAttributes','SwapNDSettlementResetDate','');

add_domain_values('XferAttributes','SwapNDSettlementResetRate','');

add_domain_values('XferAttributes','SwapNDSettlementFXDescription','');

add_domain_values('domainName','ProductUseTermFrame','list of products using the new Termination Window');

add_domain_values('ProductUseTermFrame','CreditDefaultSwap','');

add_domain_values('ProductUseTermFrame','EquityLinkedSwap','');

add_domain_values('keyword.TerminationReason.Advance','Prepayment','');

add_domain_values('keyword.TerminationReason.Advance','NotionalIncrease','');

add_domain_values('keyword.TerminationReason.Advance','Manual','');

add_domain_values('keyword.TerminationReason.Advance','BoughtBack','');

add_domain_values('keyword.TerminationReason.Advance','BookTransfer','');

add_domain_values('systemKeyword','TransferPayIntFlow','');

add_domain_values('systemKeyword','TransferReason','');

add_domain_values('domainName','simulationCustomVolatilityType','');

add_domain_values('futureUnderType','StructuredFlows','');

add_domain_values('ETOUnderlyingType','IR','');

add_domain_values('feeCalculator','FeeConfig','');

add_domain_values('scheduledTask','TENOR_RANGE_EXECUTOR','This schedule task execute other schedule task recursively over a time interval defined by tenor range');

add_domain_values('scheduledTask','IMPORT_INDUSTRY_HIERARCHY','Load an industry hierarchy from file');
COMMIT;
END;
/

BEGIN
add_domain_values('scheduledTask','IMPORT_MARKET_INDEX_CONSTITUENTS','Import a market index constituents from file');

add_domain_values('scheduledTask','IMPORT_MARKET_INDEX_DEFINITIONS','Import market index definitions from file');

add_domain_values('scheduledTask','IMPORT_ANALYTICS','Import analytics from file');

add_domain_values('scheduledTask','IMPORT_ANALYTICS_CREDIT_RATING','Import analytics credit rating from file');

add_domain_values('scheduledTask','PROCESS_ADJUSTMENTS','process generate/update/cancel adjustements');

add_domain_values('scheduledTask','EOD_SPOT_PLSWEEP','Spot PL Sweep');

add_domain_values('workflowRuleTrade','CheckFXSpotRateTolerance','The rule checks if the spot rate for the FX trade falls within the regulatory tolerance specified for the currency pair');

add_domain_values('userAttributes','FX Default Trade Role','');

add_domain_values('userAttributes','FX Default Rollover Type','Default FX rollover type selection on opening the FX rollover window');

add_domain_values('userAttributes','Default Pricing Grid Auto Update Dispatcher','Default dispatcher configuration for Pricing Grid auto recalculation');

add_domain_values('productType','IRStructuredOption','IRStructuredOption');

add_domain_values('CommodityUnit','MT','Metric Tonnes');

add_domain_values('productType','PortfolioSwap','');

add_domain_values('productType','PortfolioSwapPosition','');

add_domain_values('domainName','issuerSector','Domain to hold list of available sectors');

add_domain_values ('bookAttribute.Domiciliation','Onshore','');

add_domain_values ('bookAttribute.Domiciliation','Offshore','');

add_domain_values('tradeAction','LATE_CANCEL','Late cancellation of a trade.');

add_domain_values('transferAction','LATE_CANCEL','Late cancellation of a trade');

add_domain_values('messageAction','LATE_CANCEL','Late cancellation of a trade');

add_domain_values('ScenarioViewerClassNames','apps.risk.ScenarioAnalysisViewer','the old default scenario risk viewer, replaced by ScenarioRiskAnalysisViewer');

add_domain_values('creditRatingSource','Markit','Rating Agency which would configured in pricer config as well in probability curve creation');

add_domain_values('PCCreditRatingLEAttributesOrder','RED_SECTOR,RED_REGION','Comma seperated legal entity attribute names');

add_domain_values('issuerSector','Basic materials','Sector Basic materials');

add_domain_values('issuerSector','Consumer goods','Sector Consumer goods');

add_domain_values('issuerSector','Consumer services','Sector Consumer services');

add_domain_values('issuerSector','Industrials','Sector Industrials');

add_domain_values('issuerSector','Healthcare','Sector Healthcare');

add_domain_values('issuerSector','Oil and Gas','Sector Oil and Gas');

add_domain_values('issuerSector','Technology','Sector Technology');

add_domain_values('issuerSector','Telecommunications','Sector Telecommunications');

add_domain_values('issuerSector','Utilities','Sector Utilities');

add_domain_values('issuerSector','Financials','Sector Financials');

add_domain_values('issuerSector','Government','Sector Government');

add_domain_values('AccountSetup','ACCOUNT_TRADE_SEED','false');

add_domain_values('AccountSetup','CALL_ACCOUNT_INTERNAL_VIEW','false');

add_domain_values('AccountSetup','ACCOUNT_SHARE_TRADE_SEED','false');

add_domain_values('AccountSetup','CALL_ACCOUNT_NAME_EQUALS_ID','false');

add_domain_values('AccountSetup','ACCESS_PERCENTAGE','false');

add_domain_values('BondAssetBacked.collateralType','IOS Index','');

add_domain_values('BondAssetBacked.collateralType','POS Index','');

add_domain_values('BondAssetBacked.collateralType','Fannie Agency Pools','');

add_domain_values('FeeBillingRuleAttributes','MatchBook','');

add_domain_values('FeeBillingRuleAttributes','BillingOnly','');

add_domain_values('FeeBillingRuleAttributes','EntryType','');

add_domain_values('FeeBillingRuleAttributes','XferByBook','');

add_domain_values('corporateActionType','ACCRUAL.BONUS','');

add_domain_values('corporateActionType','ACCRUAL.EQUITYOFFERING','');
COMMIT;
END;
/

BEGIN
add_domain_values('corporateActionType','ACCRUAL.REINVEST','');

add_domain_values('corporateActionType','ACCRUAL.RIGHTS_CPN','');

add_domain_values('corporateActionType','ACCRUAL.STOCK_DIV','');

add_domain_values('corporateActionType','ACCRUAL.TAX','');

add_domain_values('corporateActionType','ACQUISITION.CASH_OFFER','');

add_domain_values('corporateActionType','ACQUISITION.OPA','');

add_domain_values('corporateActionType','ACQUISITION.OPE','');

add_domain_values('corporateActionType','ACQUISITION.STOCK_OFFER','');

add_domain_values('corporateActionType','ADR.ADR','');

add_domain_values('corporateActionType','AMORTIZATION.AMORTIZATION','');

add_domain_values('corporateActionType','AMORTIZATION.PIK_INTEREST','');

add_domain_values('corporateActionType','CASH.ADJUSTMENT','');

add_domain_values('corporateActionType','CASH.BIDS','');

add_domain_values('corporateActionType','CASH.CAPITALRETURN','');

add_domain_values('corporateActionType','CASH.DIVIDEND','');

add_domain_values('corporateActionType','CASH.INSTALLMENT_CALL','');

add_domain_values('corporateActionType','CASH.INTEREST','');

add_domain_values('corporateActionType','CASH.ODD_LOT','');

add_domain_values('corporateActionType','CASH.REBATE','');

add_domain_values('corporateActionType','CASH.RIGHT_ISSUE','');

add_domain_values('corporateActionType','EXERCISE.ASSIGNMENT','');

add_domain_values('corporateActionType','EXERCISE.EXERCISE','');

add_domain_values('corporateActionType','EXPIRY.BARRIER_DEACTIVATION','');

add_domain_values('corporateActionType','EXPIRY.EXPIRY','');

add_domain_values('corporateActionType','EXPIRY.MARK_DOWN','');

add_domain_values('corporateActionType','EXPIRY.MDE','');

add_domain_values('corporateActionType','FUTURE.FUTURE','');

add_domain_values('corporateActionType','MERGER.MERGER','');

add_domain_values('corporateActionType','MERGER.RIGHTS_CALL','');

add_domain_values('corporateActionType','PAYDOWN.PAYDOWN','');

add_domain_values('corporateActionType','REDEMPTION.BUYBACK','');

add_domain_values('corporateActionType','REDEMPTION.CALL_REDEMPTION','');

add_domain_values('corporateActionType','REDEMPTION.DELISTING','');

add_domain_values('corporateActionType','REDEMPTION.DRAWING','');

add_domain_values('corporateActionType','REDEMPTION.LOTTERY_WINNER','');

add_domain_values('corporateActionType','REDEMPTION.PRINCIPAL','');

add_domain_values('corporateActionType','REDEMPTION.REDEMPTION','');

add_domain_values('corporateActionType','REFERENTIAL.CALL_REDEMPTION','');

add_domain_values('corporateActionType','REFERENTIAL.REFERENTIAL','');

add_domain_values('corporateActionType','RESET.RESET','');

add_domain_values('corporateActionType','SPINOFF.SPINOFF','');

add_domain_values('corporateActionType','TRANSFORMATION.ASSIMILATION','');

add_domain_values('corporateActionType','TRANSFORMATION.CONVERTIBLE','');

add_domain_values('corporateActionType','TRANSFORMATION.IMPAIRMENT','');

add_domain_values('corporateActionType','TRANSFORMATION.SPLIT','');

add_domain_values('corporateActionType','UNMAPPED.UNMAPPED','');

add_domain_values('domainName','CASwiftEventCodeAttributes','Attributes qualifying Swift event code and interprted to process CorporateAction');

add_domain_values('CASwiftEventCodeAttributes','CATradeBasis.CUM','Trade attribute indicating operation CUM dividend');
commit;
END;
/
BEGIN
add_domain_values('CASwiftEventCodeAttributes','CATradeBasis.EX','Trade attribute indicating operation EX dividend');

add_domain_values('CASwiftEventCodeAttributes','CASubjectToScaleBack','Boolean value indicating if Corporate Action is subject to scale back');

add_domain_values('CASwiftEventCodeAttributes','SpecialDividend','Boolean value indicating if Corporate Action can be marked as a special dividend');

add_domain_values('CASwiftEventCodeAttributes','CAModelSubtype','an ordered List of model.subtype.CAOP assigned to CA EVent');

add_domain_values('CASwiftEventCodeAttributes','CASwiftEventChoice','MAND CHOS or VOLU event choice');

add_domain_values('CASwiftEventCodeAttributes','CASwiftEventProcess','Enum of Distribution(DISN), Reorganisation(REOR) or General(GENL)');

add_domain_values('classAuthMode','CASwiftEventCodeAttributes','tk.product.corporateaction');

add_domain_values('domainName','lifeCycleEntityObject','Simple name of EntityObject for which exists a LifyCycleHandler');

add_domain_values('bondType','BondMMDiscountWithAI','');

add_domain_values('bondType','BondExoticNote','bondtype domain');

add_domain_values('bondType','MBSFixedRate','bondType Domain');

add_domain_values('bondType','MBSArm','bondType Domain');

add_domain_values('BondExoticNote.Pricer','PricerBlackNFMonteCarloExotic','Pricer for BondExoticNote');

add_domain_values('BondMMDiscountWithAI.Pricer','PricerBondMMDiscount','MM Discount bond With AI Pricer');

add_domain_values('Bond.Pricer','PricerLGMM1FSaliTree','LGMM1F Sali Tree Pricer');

add_domain_values('CapFloor.Pricer','PricerCapFloorInflationBlack','Pricer Cap Floor Inflation Black');

add_domain_values('ETOIR.Pricer','PricerETOIR','');

add_domain_values('Swap.Pricer','PricerSwapLGMM1F','Pricer for a Swap with a Bermudan cancellable schedule.');

add_domain_values('SwapCrossCurrency.Pricer','PricerSwap','');

add_domain_values('SwapCrossCurrency.Pricer','PricerExoticSwap','');

add_domain_values('SwapNonDeliverable.Pricer','PricerSwap','');

add_domain_values('Bond.Pricer','PricerBondChilean','Pricer for Chilean Bonds.');

add_domain_values('Swaption.Pricer','PricerSwaptionLGMM1F','');

add_domain_values('ETOEquityIndex.Pricer','PricerBlack1FAnalyticDiscreteVanilla','Analytic Black-Scholes pricer for european options using discrete (escrowed) dividend or continuous yield');

add_domain_values('ETOEquityIndex.Pricer','PricerBlack1FFiniteDifference','Finite difference pricer for american or european options');

add_domain_values('FutureStructuredFlows.Pricer','PricerFutureStructuredFlows','');

add_domain_values('ETOEquity.Pricer','PricerBlack1FAnalyticDiscreteVanilla','European Analytic Pricer following the Black-Scholes model');

add_domain_values('ETOEquity.Pricer','PricerBlack1FFiniteDifference','Finite Difference Pricer for single asset european or american or bermudan option');

add_domain_values('Bond.subtype','BondExoticNote','subtype for bond exotic note');

add_domain_values('Warrant.extendedType','European','');

add_domain_values('Warrant.extendedType','American','');

add_domain_values('FutureEquity.extendedType','FutureEquity','');

add_domain_values('FutureEquity.extendedType','FutureEquityES','');

add_domain_values('BondExoticNote.subtype','Standard','BondExoticNote subtype');

add_domain_values('BondMMDiscountWithAI.subtype','Discount','');

add_domain_values('CA.subtype','ADJUSTMENT','');

add_domain_values('CA.subtype','ADR','');

add_domain_values('CA.subtype','BIDS','');

add_domain_values('CA.subtype','BONUS','');

add_domain_values('CA.subtype','BUYBACK','');

add_domain_values('CA.subtype','CAPITALRETURN','');

add_domain_values('CA.subtype','CASH_OFFER','');

add_domain_values('CA.subtype','CONVERTIBLE','');

add_domain_values('CA.subtype','DELISTING','');

add_domain_values('CA.subtype','EQUITYOFFERING','');

add_domain_values('CA.subtype','FUTURE','');

add_domain_values('CA.subtype','INSTALLMENT_CALL','');

add_domain_values('CA.subtype','LOTTERY_WINNER','');

add_domain_values('CA.subtype','MDE','');

add_domain_values('CA.subtype','MERGER','');

add_domain_values('CA.subtype','ODD_LOT','');

add_domain_values('CA.subtype','OPA','');

add_domain_values('CA.subtype','OPE','');

add_domain_values('CA.subtype','PAYDOWN','');

add_domain_values('CA.subtype','PIK_INTEREST','');

add_domain_values('CA.subtype','PRINCIPAL','');

add_domain_values('CA.subtype','REFERENTIAL','');

add_domain_values('CA.subtype','REINVEST','');

add_domain_values('CA.subtype','RESET','');

add_domain_values('CA.subtype','RIGHTS_CALL','');

add_domain_values('CA.subtype','RIGHTS_CPN','');

add_domain_values('CA.subtype','RIGHT_ISSUE','');

add_domain_values('CA.subtype','SPINOFF','');

add_domain_values('CA.subtype','STOCK_DIV','');

add_domain_values('CA.subtype','TAX','');

add_domain_values('CA.subtype','STOCK_OFFER','');

add_domain_values('CA.subtype','UNMAPPED','');

add_domain_values('domainName','CA.Status','All possible Corporate Action Status');

add_domain_values('domainName','CA.ApplicableStatus','Corporate Action Status allowing CA application');

add_domain_values('domainName','CA.CanceledStatus','Corporate Action Status resulting in cancellation of previously created CA Trade');

add_domain_values('CA.Status','NOT_APPLICABLE','Default Non Applicable Event Status - no application of CA occurs, no CA Trade is created');

add_domain_values('CA.Status','APPLICABLE','');

add_domain_values('CA.Status','CANCELED','');

add_domain_values('CA.Status','REMOVED','');

add_domain_values('CA.ApplicableStatus','APPLICABLE','Default Applicable Event Status - CA application results in created CA Trade');

add_domain_values('CA.CanceledStatus','CANCELED','Default Canceled Event Status - CA application results in cancellation of any of previously created CA Trade');

add_domain_values('CA.CanceledStatus','REMOVED','');

add_domain_values('engineName','LifeCycleEngine','');

add_domain_values('ETOIR.subtype','European','');

add_domain_values('ETOIR.subtype','American','');

add_domain_values('IRStructuredOption.subtype','European','');

add_domain_values('IRStructuredOption.subtype','American','');

add_domain_values('interpolator','InterpolatorLogSpline','Cubic spline interpolator on logarithms.');

add_domain_values('eventClass','PSEventCalculationServerJobStatus','PSEvent indicating the Calculation Server run status for MarketData update cycle');

add_domain_values('eventClass','PSEventScheduledTaskExec','');

add_domain_values('eventClass','PSEventMktDataServerAdmin','');

add_domain_values('eventFilter','FutureAndCfdLiquidationEventFilter','Future and Cfd Liquidation Event Filter');

add_domain_values('eventClass','PSEventLifeCycle','');

add_domain_values('eventClass','PSEventEntityObject','');

add_domain_values('eventFilter','LifeCycleEngineEventFilter','Filter to select only PSEvent applicable for LifeCycleHandler');

add_domain_values('eventFilter','MessageEngineEntityObjectEventFilter','Filter to select only PSEventEntityObject for which exists a BOMessageHandler');

add_domain_values('eventType','REMOVE_HEDGE_TRADE','');

add_domain_values('eventType','EX_CA_INFORMATION','Indicates an information published by the ScheduledTaskCORPORATE_ACTON concerning its execution.');

add_domain_values('eventType','EX_EOD_SPOT_PLSWEEP_SUCCESS','');

add_domain_values('eventType','EX_EOD_SPOT_PLSWEEP_FAILURE','');

add_domain_values('exceptionType','EOD_SPOT_PLSWEEP_SUCCESS','');

add_domain_values('exceptionType','EOD_SPOT_PLSWEEP_FAILURE','');

add_domain_values('eventType','EX_CREATE_POSITION_SNAPSHOT_SUCCESS','The position snapshot creation scheduled task was successful.');

add_domain_values('exceptionType','CREATE_POSITION_SNAPSHOT_SUCCESS','');

add_domain_values('eventType','EX_CREATE_POSITION_SNAPSHOT_FAILURE','The position snapshot creation scheduled task was not successful.');

add_domain_values('exceptionType','CREATE_POSITION_SNAPSHOT_FAILURE','');

add_domain_values('eventType','EX_CREATE_POSITION_SNAPSHOT_INFORMATION','The position snapshot creation scheduled task generated extra information.');

add_domain_values('exceptionType','CREATE_POSITION_SNAPSHOT_INFORMATION','');

add_domain_values('feeCalculator','PortfolioSwapCommission','fee calculator for Portfolio Swap');

add_domain_values('exceptionType','CA_INFORMATION','');

add_domain_values('flowType','SECLENDING_FEE','');

add_domain_values('function','ApplyCA','Access permission to apply a CA');

add_domain_values('function','ModifyCA','Access permission to modify CA product');

add_domain_values('function','AddRemoveCAToProduct','Access permission to add/remove a CA to product');

add_domain_values('function','AddRemoveCAOption','Access permission to add/remove a CA option');

add_domain_values('function','OnDemandMktDataRefresh','Access permission to perform on demand market data refresh in CWS');

add_domain_values('function','ModifyStressParametersTables','Access permission to create/modify/delete stress tables.');

add_domain_values('function','ViewStressParametersTables','Access permission to view stress tables.');

add_domain_values('function','AuthorizeLegalEntityDisabled','Access permission to Authorize Legal Entities in Disabled status');

add_domain_values('function','AuthorizeLegalEntityEnabled','Access permission to Authorize Legal Entities in Enabled status');

add_domain_values('function','AuthorizeLegalEntityPending','Access permission to Authorize Legal Entities in Pending status');

add_domain_values('function','ReadPriceFromTradePriceReport','Permission to allow user to read price from trade price report');

add_domain_values('function','SavePriceFromTradePriceReport','Permission to allow user to save price from trade price report');

add_domain_values('function','DeletePriceFromTradePriceReport','Permission to allow user to delete price from trade price report');

add_domain_values('function','CreateHedgeRelationshipConfiguration','Access permission to create Hedge Relationship Config');

add_domain_values('function','ModifyHedgeRelationshipConfiguration','Access permission to modify Hedge Relationship Config');

add_domain_values('function','RemoveHedgeRelationshipConfiguration','Access permission to remove Hedge Relationship Config');

add_domain_values('billingEvents','BillingTradeEvent','');

add_domain_values ('billingEvents','BillingMaintenanceTradeEvent','');

add_domain_values('function','ViewBetaMatrix','Access Permission to allow selection of multiple Market Data Server configurations');

add_domain_values('function','ModifyBetaMatrix','Access Permission to allow selection of multiple Market Data Server configurations');

add_domain_values('function','ViewCARules','Access Permission to allow selection of multiple Market Data Server configurations');

add_domain_values('function','ModifyCARules','Access Permission to allow selection of multiple Market Data Server configurations');

add_domain_values('liquidationMethod','HIFO','');

add_domain_values('billingCalculators','BillingFeeConfigCalculator',''  );

add_domain_values ('billingCalculators','BillingTradeFeeRebateCalculator',''  );

add_domain_values('productType','BondExoticNote','produttype domain');

add_domain_values('productType','SwapCrossCurrency','');

add_domain_values('productType','SwapNonDeliverable','');

add_domain_values('productType','FutureStructuredFlows','');

add_domain_values('productType','BondMMDiscountWithAI','');

add_domain_values('productType','ETOIR','');

add_domain_values('productType','CallAccount','');

add_domain_values('StructuredFlows.Pricer','PricerExoticStructuredFlows','Pricer to pricer exotic StructuredFlows product');

add_domain_values('quoteType','WS','WorldScale');

add_domain_values('quoteType','UnitaryPrice','');

add_domain_values('quoteType','GrossUnitaryPrice','');

add_domain_values('role','Remitter','');

add_domain_values('riskAnalysis','HedgeEffectivenessProspective','');

add_domain_values('role','Seller','Seller');

add_domain_values('role','Servicer','Servicer');

add_domain_values('scheduledTask','GENERATE_EQUITY_VOL_INSTRUMENTS','');

add_domain_values('scheduledTask','SECFINANCE_AUTOMARK','');

add_domain_values('scheduledTask','SECFINANCE_UPDATE_SETTLEMENTDATE','');

add_domain_values('scheduledTask','FUTURE_VARIATION_MARGIN','EOD Future Variation Margin');

add_domain_values('scheduledTask','WARRANT_PROCESSING','Process Warrant Corporate Actions (exercice, expiry) and upgrades floating strikes');

add_domain_values('yieldMethod','ThaiBMA','');

add_domain_values('riskPresenter','Rebalancing','');
COMMIT;
END;
/

BEGIN
add_domain_values('FutureContractAttributes','UseMarginCallAdjLag','Use date rule attached to currency definition');

add_domain_values('FutureContractAttributes.UseMarginCallAdjLag','Yes','');

add_domain_values('FutureContractAttributes.UseMarginCallAdjLag','No','');

add_domain_values('FutureContractAttributes','DaylightSavingTime','Daylight Saving Time to apply associated with electricity contract.');

add_domain_values('productInterfaceReportStyle','CorporateActionBased','CorporateActionBased ReportStyle');

add_domain_values('productTypeReportStyle','BondExoticNote','BondExoticNote ReportStyle');

add_domain_values('productTypeReportStyle','ETOIR','ETOIR ReportStyle');

add_domain_values('productTypeReportStyle','IRStructuredOption','IRStructured Option ReportStyle');

add_domain_values('CommodityType','Freight','Freight');

add_domain_values('domainName','volSurfaceGenerator.equity','Equity derived volatility surface generators');

add_domain_values('volSurfaceGenerator.equity','ETO','ETO');

add_domain_values('volSurfaceGenerator.equity','OTCEquityOption','OTCEquityOption');

add_domain_values('volSurfaceGenerator.equity','Heston','Heston');

add_domain_values('volSurfaceGenerator.equity','Spline','Volatility surface by spline interpolation');

add_domain_values('volSurfaceGenerator.equity','SVI','SVI');

add_domain_values('domainName','volSurfaceGenSimple.equity','Equity non-derived volatility surface generators');

add_domain_values('volSurfaceGenSimple.equity','SVISimple','SVISimple');

add_domain_values('volSurfaceGenSimple.equity','SABRSimple','SABRSimple');

add_domain_values('volSurfaceGenSimple.equity','Default','Default');

add_domain_values('tradeKeyword','CAManualAmend','YES or NO: a CA Trade that will be excluded from automated CA Application');

add_domain_values('domainName','keyword.CAManualAmend','');

add_domain_values('keyword.CAManualAmend','YES','');

add_domain_values('keyword.CAManualAmend','NO','');

add_domain_values('tradeKeyword','ContractDivRate','SBL Contract Div Rate');

add_domain_values('tradeKeyword','CATradeBasis','Trade was executed CUM or EX (MT540-43 :22F::TTCO//4!c)');

add_domain_values('XferAttributesForMatching','CATradeBasis','');

add_domain_values('tradeKeyword','BasisOfQuote','Agent codification matching CATradeBasis, indicated if Trade was executed CUM or EX');

add_domain_values('XferAttributesForMatching','BasisOfQuote','');

add_domain_values('domainName','keyword.CATradeBasis','MultipleSelection of keyword value allowed. Trade was executed CUM or EX (MT540-43 :22F::TTCO//4!c)');

add_domain_values('keyword.CATradeBasis','CBNS','Cum Bonus - Trade was executed cum bonus. ');

add_domain_values('keyword.CATradeBasis','CDIV','Cum Dividend - Trade was executed cum dividend. ');

add_domain_values('keyword.CATradeBasis','CRTS','Cum Rights - Trade was executed cum rights. ');

add_domain_values('keyword.CATradeBasis','XBNS','Ex Bonus - Trade was executed ex bonus. ');

add_domain_values('keyword.CATradeBasis','XDIV','Ex Dividend - Trade was executed ex dividend. ');

add_domain_values('keyword.CATradeBasis','XRTS','Ex Rights - Trade was executed ex rights. ');

add_domain_values('keyword.CATradeBasis','SPCU','Special Cum - Trade was executed with a special cum condition');

add_domain_values('keyword.CATradeBasis','SPEX','Special Ex - Trade was executed with a special ex condition');

add_domain_values('CA.keywords','CAFailedTransfer','transfer id for claim trade');

add_domain_values('CA.keywords','CAFractionalShares','remaining shares in case of security event');

add_domain_values('accEventType','CVA_EXPOSURE','CVA Amount');

add_domain_values('domainName','cvaExposureBookName','Default Book to Import CVA per Counterparty');

add_domain_values('domainName','CVAExposure.Pricer','Pricer for CVA Exposure product');

add_domain_values('CVAExposure.Pricer','PricerSimpleTransfer','Pricer for CVA Exposure product');
commit;
end;
/

begin
add_domain_values('productType','CVAExposure','');

add_domain_values('flowType','CVA_PLMARKING','');

add_domain_values('scheduledTask','EOD_CVAALLOCATION','');

add_domain_values('scheduledTask','EOD_CVAPLMARKING','');

add_domain_values('measuresForAdjustment','CVA_ALLOCATION','');

add_domain_values('domainName','IRStructuredOption.Pricer','Pricers for IRStructuredOption');

add_domain_values('systemKeyword','ReportingCcyData','Internal keyword to carry over reporting currency data for the trade');

add_domain_values('systemKeyword','ReportingCcyDataFarLeg','Internal keyword to carry over reporting currency data for the trade');

add_domain_values('tradeKeyword','ReportingCcyData','Internal keyword to carry over reporting currency data for the trade');

add_domain_values('tradeKeyword','ReportingCcyDataFarLeg','Internal keyword to carry over reporting currency data for the trade');

add_domain_values('workflowRuleTrade','EsoKnockIn','Knock-In Rule for EquityStructuredOption');

add_domain_values('domainName','EsoKnockInTradeRule.PricingEnvName','Default PricingEnvName for EsoKnockInTradeRule');

add_domain_values('domainName','Swift.UserHeader.Service Identifier.EUR','Swift Headers Block 3 values expected in tag103');

add_domain_values('Swift.UserHeader.Service Identifier.EUR','TGT','');

add_domain_values('accountProperty','Platform.TGT','Specify is this is the account for Platform TGT');

add_domain_values('domainName','accountProperty.Platform.TGT','');

add_domain_values('accountProperty.Platform.TGT','False','');

add_domain_values('accountProperty.Platform.TGT','True','');

add_domain_values('Swift.UserHeader.Service Identifier.EUR','EBA','');

add_domain_values('accountProperty','Platform.EBA','Specify is this is the account for Platform EBA');

add_domain_values('domainName','accountProperty.Platform.EBA','');

add_domain_values('accountProperty.Platform.EBA','False','');

add_domain_values('accountProperty.Platform.EBA','True','');

add_domain_values('Swift.UserHeader.Service Identifier.EUR','STC','');

add_domain_values('accountProperty','Platform.STC','Specify is this is the account for Platform STC');

add_domain_values('domainName','accountProperty.Platform.STC','');

add_domain_values('accountProperty.Platform.STC','False','');

add_domain_values('accountProperty.Platform.STC','True','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_POSITION_CASH','');

add_domain_values('plMeasure','Cost_Of_Funding_Full_PnL','');

add_domain_values('plMeasure','Cost_Of_Opportunity_Full_PnL','');

add_domain_values('plMeasure','Cost_Of_Opportunity_PnL','');

add_domain_values('plMeasure','Realized_Fees_Full_PnL','');

add_domain_values('plMeasure','Realized_Fees_PnL','');

add_domain_values('plMeasure','Total_Fees_Full_PnL','');

add_domain_values('plMeasure','Total_Fees_PnL','');

add_domain_values('plMeasure','Settlement_Date_PnL_Base','');

add_domain_values('PricerMeasurePnlOTCEOD','UNSETTLED_CASH','');

add_domain_values('PricerMeasurePnlOTCEOD','HISTO_UNSETTLED_CASH','');

add_domain_values('PricerMeasurePnlOTCEOD','CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlOTCEOD','UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlOTCEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlOTCEOD','CA_PV','');

add_domain_values('PricerMeasurePnlOTCEOD','CA_COST','');

add_domain_values('PricerMeasurePnlOTCEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH_INTEREST','');

add_domain_values('PricerMeasurePnlEquitiesEOD','CA_PV','');

add_domain_values('PricerMeasurePnlEquitiesEOD','CA_COST','');

add_domain_values('PricerMeasurePnlEquitiesEOD','UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlEquitiesEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlEquitiesEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlEquitiesEOD','HISTO_CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlEquitiesEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlEquitiesEOD','HISTO_BOOK_VALUE','');

add_domain_values('PricerMeasurePnlMMEOD','ACCUMULATED_ACCRUAL','');

add_domain_values('PricerMeasurePnlMMEOD','HISTO_ACCUMULATED_ACCRUAL','');

add_domain_values('PricerMeasurePnlMMEOD','CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlMMEOD','UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlMMEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlMMEOD','CA_COST','');

add_domain_values('PricerMeasurePnlMMEOD','CA_PV','');

add_domain_values('PricerMeasurePnlMMEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH_INTEREST','');

add_domain_values('PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH_PRINCIPAL','');

add_domain_values('PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlRepoEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlRepoEOD','CA_PV','');

add_domain_values('PricerMeasurePnlRepoEOD','CA_COST','');
commit;
end;
/

begin
add_domain_values('PricerMeasurePnlRepoEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_INTEREST','');

add_domain_values('PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_PRINCIPAL','');

add_domain_values('PricerMeasurePnlBondsEOD','CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlBondsEOD','FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlBondsEOD','FEES_UNSETTLED_SD','');

add_domain_values('PricerMeasurePnlBondsEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlBondsEOD','UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlBondsEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlBondsEOD','CA_COST','');

add_domain_values('PricerMeasurePnlBondsEOD','CA_PV','');

add_domain_values('PricerMeasurePnlBondsEOD','HISTO_CLEAN_BOOK_VALUE','');

add_domain_values('PricerMeasurePnlBondsEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlBondsEOD','HISTO_CLEAN_REALIZED','');

add_domain_values('PricerMeasurePnlFXEOD','CA_PV','');

add_domain_values('PricerMeasurePnlFXEOD','CA_COST','');

add_domain_values('PricerMeasurePnlFuturesEOD','UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlFuturesEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlFuturesEOD','CA_PV','');

add_domain_values('PricerMeasurePnlFuturesEOD','CA_COST','');

add_domain_values('PricerMeasurePnlFuturesEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlFuturesEOD','HISTO_CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlFuturesEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlETOEOD','UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlETOEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlETOEOD','CA_PV','');

add_domain_values('PricerMeasurePnlETOEOD','CA_COST','');

add_domain_values('PricerMeasurePnlETOEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlETOEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlAllEOD','ACCUMULATED_ACCRUAL','');

add_domain_values('PricerMeasurePnlAllEOD','CA_MARKET_PRICE','');

add_domain_values('PricerMeasurePnlAllEOD','CA_NOTIONAL','');

add_domain_values('PricerMeasurePnlAllEOD','CA_QUANTITY','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_CLEAN_BOOK_VALUE','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_BOOK_VALUE','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_PRINCIPAL','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_CLEAN_REALIZED','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_UNSETTLED_CASH_FEES','');

add_domain_values('PricerMeasurePnlAllEOD','CA_PV','');

add_domain_values('PricerMeasurePnlBondsEOD','ACCRUAL_SETTLE_DATE','');

add_domain_values('PricerMeasurePnlAllEOD','CA_COST','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_FEES','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_INTEREST','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_ACCUMULATED_ACCRUAL','');

add_domain_values('PricerMeasurePnlAllEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('measuresForAdjustment','HISTO_CUMULATIVE_CASH','');

add_domain_values('measuresForAdjustment','HISTO_CUMULATIVE_CASH_FEES','');

add_domain_values('measuresForAdjustment','HISTO_CUMULATIVE_CASH_INTEREST','');

add_domain_values('measuresForAdjustment','HISTO_POSITION_CASH','');

add_domain_values('measuresForAdjustment','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlPhysComEOD','HISTO_CUMULATIVE_CASH','');

add_domain_values('PricerMeasurePnlPhysComEOD','HISTO_CUMULATIVE_CASH_INTEREST','');

add_domain_values('PricerMeasurePnlPhysComEOD','HISTO_FEES_UNSETTLED','');

add_domain_values('PricerMeasurePnlPhysComEOD','CA_PV','');

add_domain_values('PricerMeasurePnlPhysComEOD','CA_COST','');

add_domain_values('PNLWithDetails','Accretion_Full_PnL','');

add_domain_values('PNLWithDetails','Accretion_PnL','');

add_domain_values('PNLWithDetails','Cost_Of_Funding_Full_PnL','');

add_domain_values('PNLWithDetails','Realized_Fees_Full_PnL','');

add_domain_values('PNLWithDetails','Realized_Fees_PnL','');

add_domain_values('PNLWithDetails','Total_Fees_Full_PnL','');

add_domain_values('PNLWithDetails','Total_Fees_PnL','');

add_domain_values('function','AllowUpdateTagsWithManualSdi','');

add_domain_values('pricingScriptReportVariables','ObservationDates.ReferenceDateArray','');

add_domain_values('pricingScriptReportVariables','CouponPayment.AccrualPeriodArray','');

add_domain_values('pricingScriptReportVariables','Coupon_NFixed','');

add_domain_values('pricingScriptReportVariables','CouponRate_Above','');

add_domain_values('pricingScriptReportVariables','CouponRate_Below','');

add_domain_values('pricingScriptReportVariables','CouponStrikePct','');

add_domain_values('pricingScriptReportVariables','IR_CouponPayment.AccrualPeriodArray','');

add_domain_values('pricingScriptReportVariables','IR_curr','');

add_domain_values('pricingScriptReportVariables','IR_FloatRateRef','');

add_domain_values('pricingScriptReportVariables','IR_KO_RedemptionPct','');

add_domain_values('pricingScriptReportVariables','IR_Notional','');

add_domain_values('pricingScriptReportVariables','IR_RedemptionPct','');

add_domain_values('pricingScriptReportVariables','IR_Spread_BPS','');

add_domain_values('pricingScriptReportVariables','InitialFixing','');

add_domain_values('pricingScriptReportVariables','isPut','');

add_domain_values('pricingScriptReportVariables','LeveragePct','');

add_domain_values('pricingScriptReportVariables','KI.ReferenceDateArray','');

add_domain_values('pricingScriptReportVariables','KI_BarrierPct','');

add_domain_values('pricingScriptReportVariables','KI_Override','');

add_domain_values('pricingScriptReportVariables','KO.PaymentDateArray','');

add_domain_values('pricingScriptReportVariables','KO_BarrierPct','');

add_domain_values('pricingScriptReportVariables','KO_RedemptionCurr','');

add_domain_values('pricingScriptReportVariables','KO_RedemptionFX','');

add_domain_values('pricingScriptReportVariables','KO_RedemptionPct','');

add_domain_values('pricingScriptReportVariables','KO_StepDownAmount','');

add_domain_values('pricingScriptReportVariables','KO_StepDownPct','');

add_domain_values('pricingScriptReportVariables','KO_StepDownUsePct','');

add_domain_values('pricingScriptReportVariables','StrikePct','');

add_domain_values('domainName','pricingScriptReportVariables.ReferenceDateArray','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','STARTDATE','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','ENDDATE','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','FREQUENCY','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','HOLIDAYS','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','DATEROLL','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','PERIODRULE','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','SPECIFYROLLDAY','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','ROLLDAY','');

add_domain_values('pricingScriptReportVariables.ReferenceDateArray','INCLUDESTART','');

add_domain_values('domainName','bookAttribute.PositionTransferPrice','Price type of position transfer');

add_domain_values('bookAttribute.PositionTransferPrice','Average','Use position average price');

add_domain_values('bookAttribute.PositionTransferPrice','Closing','Use closing price');

add_domain_values('domainName','keyword.PositionTransferPrice','Price type of position transfer');
commit;
end;
/

begin
add_domain_values('keyword.PositionTransferPrice','Average','Use position average price');

add_domain_values('keyword.PositionTransferPrice','Closing','Use closing price');

add_domain_values('function','PricingSheetSettingAccess','Give access to the Setting in Pricing Sheet');

add_domain_values('function','AddCustomEditorWorkflowRule','Access permission to add a new custom workflow rule');

add_domain_values('function','ModifyCustomEditorWorkflowRule','Access permission to modify an existing custom workflow rule');

add_domain_values('function','RemoveCustomEditorWorkflowRule','Access permission to remove an existing custom workflow rule');

add_domain_values('domainName','PricingSheetMeasures.CrossAssetSummable','The Pricer Measures that support summing accross assets');

add_domain_values('PricingSheetMeasures.CrossAssetSummable','NPV','');

add_domain_values ('PricingSheetMeasures.CrossAssetSummable','PV','');

add_domain_values('domainName','mktDataVisuType','Market Data format by MDI Type');

add_domain_values('mktDataVisuType','Quotes','');

add_domain_values('domainName','mktDataVisuType.Quotes','');

add_domain_values('mktDataVisuType.Quotes','Quotes','');

add_domain_values('mktDataVisuType','CMD','');

add_domain_values('domainName','mktDataVisuType.CMD','');

add_domain_values('mktDataVisuType.CMD','CurveCommodity','');

add_domain_values('mktDataVisuType.CMD','CurveCommoditySpread','');

add_domain_values('mktDataVisuType.CMD','CurveZeroPreciousMetal','');

add_domain_values('mktDataVisuType.CMD','CurveConvenienceYield','');

add_domain_values('mktDataVisuType.CMD','CurveCommoditySeasonality','');

add_domain_values('mktDataVisuType','Correlation','');

add_domain_values('domainName','mktDataVisuType.Correlation','');

add_domain_values('mktDataVisuType.Correlation','CorrelationSurface','');

add_domain_values('mktDataVisuType.Correlation','CorrelationMatrix','');

add_domain_values('mktDataVisuType.Correlation','CorrelationFormula','');

add_domain_values('mktDataVisuType','Credit','');

add_domain_values('domainName','mktDataVisuType.Credit','');

add_domain_values('mktDataVisuType.Credit','CurveCDSBasisAdjustment','');

add_domain_values('mktDataVisuType.Credit','CurveProbability','');

add_domain_values('mktDataVisuType.Credit','CurveRisky','');

add_domain_values('mktDataVisuType.Credit','CurveRecovery','');

add_domain_values('mktDataVisuType','Equity','');

add_domain_values('domainName','mktDataVisuType.Equity','');

add_domain_values('mktDataVisuType.Equity','CurveDividend','');

add_domain_values('mktDataVisuType.Equity','CurveBorrow','');

add_domain_values('mktDataVisuType','FixedIncome','');

add_domain_values('domainName','mktDataVisuType.FixedIncome','');

add_domain_values('mktDataVisuType.FixedIncome','CurveYield','');

add_domain_values('mktDataVisuType.FixedIncome','CurveRepo','');

add_domain_values('mktDataVisuType','FX','');

add_domain_values('domainName','mktDataVisuType.FX','');

add_domain_values('mktDataVisuType.FX','CurveFX','');

add_domain_values('mktDataVisuType','Inflation','');

add_domain_values('domainName','mktDataVisuType.Inflation','');

add_domain_values('mktDataVisuType.Inflation','CurveInflation','');

add_domain_values('mktDataVisuType.Inflation','CurveSeasonality','');

add_domain_values('mktDataVisuType','IRD','');

add_domain_values('domainName','mktDataVisuType.IRD','');

add_domain_values('mktDataVisuType.IRD','CurveBasis','');

add_domain_values('mktDataVisuType.IRD','CurveZero','');

add_domain_values('mktDataVisuType.IRD','CurveZeroFXDerived','');

add_domain_values('mktDataVisuType.IRD','USDCurveZero','');

add_domain_values('mktDataVisuType','Volatility','');

add_domain_values('domainName','mktDataVisuType.Volatility','');

add_domain_values('mktDataVisuType.Volatility','FXVolatilitySurface','');

add_domain_values('mktDataVisuType.Volatility','VolatilitySurface3D','');

add_domain_values('mktDataVisuType','ABS','');

add_domain_values('domainName','mktDataVisuType.ABS','');

add_domain_values('mktDataVisuType.ABS','CurveDefault','');

add_domain_values('mktDataVisuType.ABS','CurveDelinquency','');

add_domain_values('mktDataVisuType.ABS','CurvePrepay','');

add_domain_values('mktDataVisuType','Hypersurface','');

add_domain_values('domainName','mktDataVisuType.Hypersurface','');

add_domain_values('mktDataVisuType.Hypersurface','HyperSurfaceImpl','');

add_domain_values('CreditDefaultSwap.PricerMeasure','NPV','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','PRICE','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','B/E_Rate','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','DURATION','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','CARRY','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','ACCRUAL','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','PV01','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwap.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','NPV','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','PRICE','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','B/E_Rate','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','DURATION','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','CARRY','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','ACCRUAL','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','PV01','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CreditDefaultSwapLoan.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','NPV','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','PRICE','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','B/E_Rate','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','DURATION','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','CARRY','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','ACCRUAL','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','PV01','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSIndex.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','NPV','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','PRICE','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','B/E_Rate','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','DURATION','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','CARRY','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','ACCRUAL','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','PV01','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','EFF_ATT','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','EFF_DET','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','AVG_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSIndexTranche.PricerMeasure','PV01_CORRELATION','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','NPV','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','PRICE','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','B/E_Rate','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','DURATION','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','CARRY','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','ACCRUAL','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','PV01','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','EFF_ATT','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','EFF_DET','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','AVG_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSNthLoss.PricerMeasure','PV01_CORRELATION','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','NPV','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','PRICE','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','B/E_Rate','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','DURATION','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','CARRY','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','ACCRUAL','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','PV01','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','EFF_ATT','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','EFF_DET','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','AVG_SPREAD','Default Super User Pricer Measure');

add_domain_values('CDSNthDefault.PricerMeasure','PV01_CORRELATION','Default Super User Pricer Measure');

add_domain_values('SecurityLending.autoMarkType','Internal','');

add_domain_values('SecurityLending.autoMarkType','Pirum','');

add_domain_values('function','ConfigureODAShortcuts','Allows the creation of Trade and Analysis shortcuts in ODA');

add_domain_values('function','ConfigureODAServers','Allows configuration of CS, PS, MDS and Dispatcher in ODAs Analysis section');

add_domain_values('function','ODAAdhocTradeFilter','Allows direct specification of existing trade filter in ODA');

add_domain_values('function','ODAAdhocAnalysis','Allows the use of the Ad Hoc analysis in ODA');

add_domain_values('function','DistributeODAShortcuts','');

add_domain_values('function','DistributeODASpeedButtons','');

add_domain_values('function','DistributeCWSNodes','');

add_domain_values('function','DistributeCWSReportPlans','');

add_domain_values('function','DistributeCWSDrillDowns','');

add_domain_values('function','DistributeCWSSpeedButtons','');

add_domain_values('function','DistributeCWSWindowPlans','');

add_domain_values('function','DistributeCWSConfigWithGroup','function name for DistributeCWSConfigWithGroup restriction');

add_domain_values('restriction','DistributeCWSConfigWithGroup','Restrict distribution of accessible CWS items to current users groups only');

add_domain_values('domainName','creditStaticDataUsage','Supported usages');

add_domain_values('creditStaticDataUsage','MATRIX','');

add_domain_values('creditStaticDataUsage','RECOVERY','');

add_domain_values('domainName','creditStaticDataProductTypes','Supported products');

add_domain_values('creditStaticDataProductTypes','CreditDefaultSwap','');

add_domain_values('creditStaticDataProductTypes','CreditDefaultSwapLoan','');
END;
/

 

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('PRICE_FROM_UNDERLYING','java.lang.Boolean','true,false','Forecast Spread from Components',0,'true' )
;

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricing_param_name WHERE param_name = 'ALLOW_EX_DIVIDEND';
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('ALLOW_EX_DIVIDEND','java.lang.Boolean','true,false','For Bond, allows ex div trading',1,'true' );
	END;	
	END IF;
END;
/

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('FORECAST_USE_SPOT','java.lang.Boolean','true,false','Determine whether spot rate or FXReset rate should be used for forecasting of FX.',1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('FORECAST_INF_ACCRUAL','java.lang.Boolean','true,false','Forecast Inflation Accural',1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MIN_YIELD','java.lang.Double','','Designate minimum limit for yield.',0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MAX_IMPLIED_VOL','java.lang.Double','','Designate maximum limit for implied vol.',0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MIN_IMPLIED_VOL','java.lang.Double','','Designate minimum limit for implied vol.',0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_ADJUST_FOR_MIDFLOW_EXERCISE','java.lang.Boolean','true,false','Flag controls whether mid flow exercise should be adjusted.',0,'CALIBRATE_TO_OTM_OPTIONS','false' )
;

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricing_param_name WHERE param_name = 'LGMM_CALIB_MIN_CALENDAR_DAYS';
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_CALIB_MIN_CALENDAR_DAYS','java.lang.Integer','','If >0, the lag between the value date and the next exercise date will be at least that number of days.',0,'CALIB_MIN_CALENDAR_DAYS','0' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricing_param_name WHERE param_name = 'LGMM_CALIBRATE_TO_STD_OPTIONS';
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_CALIBRATE_TO_STD_OPTIONS','java.lang.Boolean','true,false','if set to true, it calibrates to vanilla swaptions as specified by the point underlying swap on the volatility surface used. Note that Bermudan.',0,'CALIBRATE_TO_STD_OPTIONS','false' );
	END;	
	END IF;
END;
/
DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricing_param_name WHERE param_name = 'LGMM_CALIBRATION_VOL_TYPE';
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_CALIBRATION_VOL_TYPE','java.lang.String','BLACK_VOL,BP_VOL','Controls how the model is parameterised and the scheme for calibration',0,'CALIBRATION_VOL_TYPE','BLACK_VOL' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricing_param_name WHERE param_name = 'DATES_TO_TENOR_THRESHOLD';
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('DATES_TO_TENOR_THRESHOLD','java.lang.Double','','The number of days within which a whole year is preserved.',1,'DATES_TO_TENOR_THRESHOLD','7.0' );
	END;	
	END IF;
END;
/

DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(*) INTO l_exists FROM pricing_param_name WHERE param_name = 'SWAP_REPLICATION_METHOD';
	IF l_exists = 0 THEN
	BEGIN
	INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('SWAP_REPLICATION_METHOD','java.lang.String','swap_rate_offset,overlap_negative_weights','SWAP_REPLICATION_METHOD methodology',1,'SWAP_REPLICATION_METHOD','swap_rate_offset' );
	END;	
	END IF;
END;
/
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('COLLATERALIZED_PRICING','java.lang.String','On,Off','On:Use collateral discounting for fully collatearlized trade. Off:Do not use collateral disc even if trade is fully collateralized.',1,'COLLATERALIZED_PRICING','Off' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('COLLATERAL_POLICY_OVERRIDE','java.lang.String','','Transient param overwriting collateral discount policy defined in CSA',1,'COLLATERAL_POLICY_OVERRIDE','' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('USE_REAL_YIELD','java.lang.Boolean','true,false','Model parameter to control inflation adjustments for price/yield calculations.','false',1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('USE_NATIVE_CURRENCY','java.lang.Boolean','true,false','Controls whether the npv and accrual will be returned in the native currency or the settlement currency.',0,'USE_NATIVE_CURRENCY','false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('USE_PROJ_FOR_HIST_CF','java.lang.Boolean','true,false','MBSFixedRate Parameter determines as the historical cashflows to be generated using projections','false',1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('USE_ARM_COMPONENTS','java.lang.Boolean','true,false','MBSArm Parameter determines to include ARM Components in CashFlow Generation','false',1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('HOMOGENEOUS_METHOD','java.lang.String','TRUE,FALSE,As_Assets','Recovery approximation method for small NTD baskets',0,'As_Assets' )
;

INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.util.SimpleLogWindow' )
;
INSERT INTO plmethodology_info ( book_id, product_type, strategy, cash_type ) VALUES (0,'ANY',0,0 )
;

/* Domain Value Changes END */

update /*+ parallel( user_viewer_prop ) */  user_viewer_prop set property_value='FXDetailed' where property_name like 'DealStationPersona_FX_%' and (property_value='FXSalesDetailed' or property_value='FXTraderDetailed')
; 

/* all sqls should go between these comments */

delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIB_MIN_CALENDAR_DAYS'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_MIN_CALENDAR_DAYS','java.lang.Integer','','If >0, the lag between the value date and the next exercise date will be at least that number of days.',0,'CALIB_MIN_CALENDAR_DAYS','0' )
;
delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIBRATE_TO_STD_OPTIONS'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATE_TO_STD_OPTIONS','java.lang.Boolean','true,false','if set to true, it calibrates to vanilla swaptions as specified by the point underlying swap on the volatility surface used. Note that Bermudan.',0,'CALIBRATE_TO_STD_OPTIONS','false' )
;
delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIBRATION_VOL_TYPE'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATION_VOL_TYPE','java.lang.String','BLACK_VOL,BP_VOL','Controls how the model is parameterised and the scheme for calibration',0,'CALIBRATION_VOL_TYPE','BLACK_VOL' )
;
delete from Pricing_Param_Name where PARAM_NAME = 'DATES_TO_TENOR_THRESHOLD'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('DATES_TO_TENOR_THRESHOLD','java.lang.Double','','The number of days within which a whole year is preserved.',1,'DATES_TO_TENOR_THRESHOLD','7.0' )

;
delete from Pricing_Param_Name where PARAM_NAME = 'SWAP_REPLICATION_METHOD'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('SWAP_REPLICATION_METHOD','java.lang.String','swap_rate_offset,overlap_negative_weights','SWAP_REPLICATION_METHOD methodology',1,'SWAP_REPLICATION_METHOD','swap_rate_offset' )
;

delete from Pricing_Param_Name where PARAM_NAME = 'MAX_DAY_SPACING'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('MAX_DAY_SPACING','java.lang.Integer','','Maximum number of days between time splices in the lattice',0,'MAX_DAY_SPACING','30' )
;

delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIB_SWAPTION'
;

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SWAPTION','java.lang.String','','Swaption template used to define calibration instruments',0,'CALIB_SWAPTION','' )
;

delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIB_SPACING'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SPACING','java.lang.Integer','','Minimum spacing between calibration instruments',0,'CALIB_SPACING','30' )
;
begin
add_domain_values ('CapFloor.Pricer','PricerCapFloorInflationBlack','Pricer Cap Floor Inflation Black' );
add_domain_values ('Swap.Pricer','PricerSwapLGMM1F','Cancellable swap pricer using sali tree to price the option and LGMM to calibrate' );
add_domain_values ('Swaption.Pricer','PricerSwaptionLGMM1F','LGMM1F pricer' );
add_domain_values ('Bond.Pricer','PricerLGMM1FSaliTree','LGMM1F Sali Tree Pricer' );
end;
/
DELETE FROM DOMAIN_VALUES where value = 'Accretion_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Accrual_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Accrued_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Cash_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Cost_Of_Carry_Base_PnL'
;
DELETE FROM DOMAIN_VALUES where value = 'Paydown_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Realized_Interests_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Realized_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Sale_Realized_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Settlement_Date_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Total_Accrual_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Unrealized_Cash_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Unrealized_Fees_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Unrealized_Interests_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Unrealized_Net_PnL_Base'
;
DELETE FROM DOMAIN_VALUES where value = 'Unrealized_PnL_Base'
;

/* CAL-146327 */

update  cf_sch_gen_params       cash_params
set     (start_date, end_date) = 
                (
                        select  start_date, end_date
                        from    commodity_leg2 leg
                        where   leg.leg_id = cash_params.leg_id
                )
where   start_date is null
and     end_date is null
and     param_type = 'COMMODITY'
;

update  cf_sch_gen_params sec_params
set     (sec_params.start_date, sec_params.end_date, sec_params.fixing_calendar) = 
        (select  cash_params.start_date, cash_params.end_date, cash_params.fixing_calendar
        from    cf_sch_gen_params cash_params
        where   cash_params.product_id = sec_params.product_id
        and     cash_params.leg_id = sec_params.leg_id
        and     cash_params.param_type = 'COMMODITY'
        and     cash_params.start_date is not null
        and     cash_params.end_date is not null)
where   exists(
                select  1
                from    prod_comm_fwd fwd,
                        commodity_leg2 leg
                where   fwd.product_id = sec_params.product_id
                and     fwd.comm_leg_id = sec_params.leg_id
                and     sec_params.param_type = 'SECURITY'
                and     sec_params.leg_id = leg.leg_id
                and     leg.leg_type not in (1, 3)
                and     sec_params.start_date is null
                and     sec_params.end_date is null
        )
;

/* CAL-146376 */



begin
drop_pk_if_exists('VOL_SURFACE_POINT_TYPE_SWAP');
end;
/

delete from pc_param where pricer_name = 'PricerBondTarnLGMM'
;

/* CAL-190826 */

UPDATE curve SET data_blob = null where curve_id in 
(select distinct curve_id from curve_member where cu_id in (select cu_id from cu_fra))
;

UPDATE curve_def_data set curve_def_blob = null where curve_id in 
(select distinct curve_id from curve_member where cu_id in (select cu_id from cu_fra))
;
create or replace FUNCTION "UNLOCALIZE" ( str IN VARCHAR2 ) return varchar2
/* normalies number-like strings to have "." as decimal separator and no grouping.
effect on other strings may be desctructive
*/
deterministic as
last_sep_char_pos number := regexp_instr(str, '[,\.][^,\.]*$');
begin
if last_sep_char_pos = 0
then
return str;
else
declare sep_char char(1) := substr(str, last_sep_char_pos, 1);
begin
if sep_char = '.' THEN
/* it was a "us-like" string, verify this */
if regexp_instr(substr(str, 1, last_sep_char_pos-1), '^[0-9 ,]*$') = 0
or regexp_instr(substr(str, last_sep_char_pos+1), '^[0-9]*$') =0
then
return str;
end if;
/* remove leading "," grouping chars */
return replace(substr(str, 1, last_sep_char_pos-1), ',', '') || substr(str,last_sep_char_pos) ;
else
/* it was a "non-us" string, , verify this */
if regexp_instr(substr(str, 1, last_sep_char_pos-1), '^[0-9 .]*$') = 0
or regexp_instr(substr(str, last_sep_char_pos+1), '^[0-9]*$') = 0
then
return replace(str, ',', '.');
end if;
/* remove leading "." grouping chars */
return replace(substr(str, 1, last_sep_char_pos-1), '.', '') || '.' || substr(str,last_sep_char_pos+1);
end if;
end;
end if;
end;
;
create or replace FUNCTION "STRING_TO_SPREAD" ( str IN VARCHAR2 ) RETURN VARCHAR2 AS
/* parse a string ("US" locale) and convert to spread
 used e.g. to fill the sales_margin column in the product */ 
BEGIN
  RETURN to_number(unlocalize(str), '999999999999999.999999999999999')/10000.0;
END STRING_TO_SPREAD;
;
  
create or replace FUNCTION "NUMBER_TO_STRING" (num in number) RETURN VARCHAR2 AS
/* convert a number into a string. used when updating audit entries */
BEGIN
  RETURN trim(to_char(num, '999999999999999D999999999999999', 'NLS_NUMERIC_CHARACTERS = ''.,'''));
END NUMBER_TO_STRING;
;


create or replace PROCEDURE "MIGRATE_SIMPLEMM_SALES_MARGIN" AS
BEGIN
  DECLARE cursor c1 IS 
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_simple_mm, trade , trade_keyword
      WHERE trade.product_id = product_simple_mm.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'MarginPips'
	  AND product_simple_mm.sales_margin = 0;
      
       
      
     nonlocalized_sales_margin varchar2(255);
     margin number;
  BEGIN
      /* live tables:  move current keyword value into product field */
      FOR c1_rec IN c1 LOOP
         margin := string_to_spread(c1_rec.keyword_value);  
         update product_simple_mm set sales_margin = margin where product_id = c1_rec.product_id;
      END LOOP;
      
      
      
   END;
END MIGRATE_SIMPLEMM_SALES_MARGIN;
;
begin
  MIGRATE_SIMPLEMM_SALES_MARGIN;
end;
;
/*  Update Version */
UPDATE calypso_info
    SET major_version=13,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('2/11/2011','DD/MM/YYYY')
;
