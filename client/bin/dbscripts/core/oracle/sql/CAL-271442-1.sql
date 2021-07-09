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
        EXECUTE IMMEDIATE 'CREATE TABLE CU_BASIS_SWAP_DTLS (CU_ID NUMBER(*,0) NOT NULL ENABLE, 
		LEG_ID NUMBER(*,0) NOT NULL ENABLE, 
		STUB VARCHAR2(32) NOT NULL ENABLE, 
		RESET_TIMING VARCHAR2(18) NOT NULL ENABLE, 
		RESET_AVG_METHOD VARCHAR2(18) NOT NULL ENABLE, 
		AVG_SAMPLE_FREQ VARCHAR2(12) NOT NULL ENABLE, 
		SAMPLE_DAY NUMBER(*,0) NOT NULL ENABLE, 
		INTERP_B NUMBER(*,0) NOT NULL ENABLE)';
		END IF;
END add_table;
/

BEGIN
add_table('CU_BASIS_SWAP_DTLS');
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
        EXECUTE IMMEDIATE 'CREATE TABLE COMMODITY_LEG2 (LEG_ID NUMBER(*,0) NOT NULL ENABLE, 
		LEG_TYPE NUMBER(*,0) NOT NULL ENABLE, 
		STRIKE_PRICE FLOAT(126), 
		STRIKE_PRICE_UNIT VARCHAR2(32), 
		COMM_RESET_ID NUMBER(*,0), 
		SPREAD FLOAT(126), FX_RESET_ID NUMBER(*,0), 
		FX_CALENDAR VARCHAR2(64), CASHFLOW_LOCKS NUMBER(*,0), 
		CASHFLOW_CHANGED NUMBER(*,0), QUANTITY FLOAT(126) NOT NULL ENABLE, 
		QUANTITY_UNIT VARCHAR2(32) NOT NULL ENABLE, PER_PERIOD VARCHAR2(32), 
		VERSION NUMBER(*,0) NOT NULL ENABLE, 
		ROUND_UNIT_CONV_B NUMBER(*,0) NOT NULL ENABLE, 
		LOWER_STRIKE FLOAT(126), UPPER_STRIKE FLOAT(126), 
		AVERAGING_POLICY VARCHAR2(64), 
		AVG_ROUNDING_POLICY VARCHAR2(64), 
		CUST_FX_RND_DIG NUMBER(*,0) NOT NULL ENABLE, 
		PAYOUT_AMOUNT FLOAT(126) NOT NULL ENABLE, 
		PAYOUT_TYPE_ID NUMBER(*,0), 
		SECURITY_COMM_RESET_ID NUMBER, 
		START_DATE TIMESTAMP (6), END_DATE TIMESTAMP (6), 
		CTD_COMM_ID NUMBER(*,0), DST_ID NUMBER(*,0), 
		FIXED_FX_RATE FLOAT(126))';
		END IF;
END add_table;
/

BEGIN
add_table('COMMODITY_LEG2');
END;
/



 
 
 
begin 
add_column_if_not_exists ('INV_SECPOSITION','daily_loaned_auto','FLOAT(126) ');
end;
/

begin 
add_column_if_not_exists ('COMMODITY_LEG2','CTD_COMM_ID','NUMBER ');
end;
/
insert into cf_sch_gen_params
(
                product_id, 
                payment_date_roll,
                leg_id,
                param_type,
                payment_offset_bus_b
)
select    params.product_id,
                params.payment_date_roll,
                params.leg_id,
                'SECURITY',
                '0'
from      PRODUCT_COMMODITY_SWAP2 opt,
                   cf_sch_gen_params params
where  opt.pay_leg_id > 0
and        params.leg_id = opt.pay_leg_id
and        params.product_id = opt.product_id
and        params.param_type = 'COMMODITY'
and        not exists (select 1
                                                from      cf_sch_gen_params sec_params
                                                where  sec_params.leg_id = opt.pay_leg_id
                                                and        sec_params.product_id = opt.product_id
                                                and        sec_params.param_type = 'SECURITY')
;

insert into cf_sch_gen_params
(
                product_id, 
                payment_date_roll,
                leg_id,
                param_type,
                payment_offset_bus_b
)
select    params.product_id,
                params.payment_date_roll,
                params.leg_id,
                'SECURITY',
                '0'
from      PRODUCT_COMMODITY_SWAP2 opt,
                   cf_sch_gen_params params
where  opt.receive_leg_id > 0
and        params.leg_id = opt.receive_leg_id
and        params.product_id = opt.product_id
and        params.param_type = 'COMMODITY'
and        not exists (select 1
                                                from      cf_sch_gen_params sec_params
                                                where  sec_params.leg_id = opt.receive_leg_id
                                                and        sec_params.product_id = opt.product_id
                                                and        sec_params.param_type = 'SECURITY')
;
insert into cf_sch_gen_params
(
product_id,
payment_date_roll,
leg_id,
param_type,
payment_offset_bus_b
)
select params.product_id,
params.payment_date_roll,
params.leg_id,
'SECURITY',
0
from PRODUCT_COMMODITY_OTCOPTION2 opt,
cf_sch_gen_params params
where opt.leg_id > 0
and params.leg_id = opt.leg_id
and params.product_id = opt.product_id
and params.param_type = 'COMMODITY'
and not exists ( select 1
from cf_sch_gen_params sec_params
where sec_params.leg_id = opt.leg_id
and sec_params.product_id = opt.product_id
and sec_params.param_type = 'SECURITY')
;

/* update bullet time */
update pmt_freq_details pfd
set pfd.attr_value='23'
where pfd.pmt_freq_type = 'BulletPaymentFrequency'
and pfd.attr_name = 'BulletHour'
and pfd.attr_value='0'
and pfd.product_id in(select opt.product_id
from PRODUCT_COMMODITY_OTCOPTION2 opt
where opt.leg_id > 0
and pfd.leg_id = opt.leg_id
and pfd.product_id = opt.product_id)
;

/* update bullet time */
update pmt_freq_details pfd
set pfd.attr_value='59'
where pfd.pmt_freq_type = 'BulletPaymentFrequency'
and pfd.attr_name = 'BulletMinutes'
and pfd.attr_value='0'
and pfd.product_id in(select opt.product_id
from PRODUCT_COMMODITY_OTCOPTION2 opt
where opt.leg_id > 0
and pfd.leg_id = opt.leg_id
and pfd.product_id = opt.product_id)
;

/* update leg */
begin 
add_column_if_not_exists ('commodity_leg2','payout_type_id','number ');
end;
/

update commodity_leg2 leg
set leg.per_period='',
leg.ctd_comm_id = '-1',
leg.payout_type_id = '-1',
leg.security_comm_reset_id = '0'
where leg.leg_id in (select opt.leg_id from PRODUCT_COMMODITY_OTCOPTION2 opt, cf_sch_gen_params params, pmt_freq_details pfd
where opt.leg_id > 0
and params.leg_id = opt.leg_id
and params.product_id = opt.product_id
and pfd.leg_id = opt.leg_id
and pfd.product_id = opt.product_id
and pfd.pmt_freq_type = 'BulletPaymentFrequency')
; 
/*
* update bullet time
*/
update pmt_freq_details pfd
set  pfd.attr_value='23' 
where  pfd.pmt_freq_type = 'BulletPaymentFrequency'
and  pfd.attr_name = 'BulletHour' 
and pfd.attr_value='0'
and pfd.product_id in(select opt.product_id
from      PRODUCT_COMMODITY_SWAP2 opt
where opt.receive_leg_id > 0
and        pfd.leg_id = opt.receive_leg_id
and        pfd.product_id = opt.product_id)
;

/*
* update bullet time
*/
update pmt_freq_details pfd
set  pfd.attr_value='59' 
where  pfd.pmt_freq_type = 'BulletPaymentFrequency'
and  pfd.attr_name = 'BulletMinutes' 
and pfd.attr_value='0'
and pfd.product_id in(select opt.product_id
from      PRODUCT_COMMODITY_SWAP2 opt
where opt.receive_leg_id > 0
and        pfd.leg_id = opt.receive_leg_id
and        pfd.product_id = opt.product_id)
;

update commodity_leg2 leg1
set  leg1.strike_price_unit = (select R.quote_unit from commodity_reset R where R.comm_reset_id = leg1.comm_reset_id)
where leg1.leg_type = '1'
and leg1.leg_id in (select DISTINCT params.leg_id from CF_SCH_GEN_PARAMS params, PRODUCT_COMMODITY_SWAP2 swap where leg1.leg_id = params.leg_id and swap.product_id = params.product_id)
;

begin 
add_column_if_not_exists ('eq_linked_leg','fx_res_lag_is_business_b','NUMBER DEFAULT 0 NULL');
end;
/

begin 
add_column_if_not_exists ('eq_linked_leg','fx_res_lag_offset','NUMBER DEFAULT 0 NULL');
end;
/
begin 
add_column_if_not_exists ('eq_linked_leg','fx_res_lag_date_roll','VARCHAR2(16) NULL');
end;
/
begin 
add_column_if_not_exists ('eq_linked_leg','fx_res_lag_holidays','VARCHAR(128) NULL');
end;
/


merge into eq_linked_leg A
USING performance_leg B on (A.product_id = B.product_id and A.leg_id = B.leg_id)
when matched then
UPDATE SET A.fx_res_lag_is_business_b=B.ret_reset_offset_b
;
merge into eq_linked_leg A
USING performance_leg B on (A.product_id = B.product_id and A.leg_id = B.leg_id)
when matched then
UPDATE SET A.fx_res_lag_offset=B.ret_reset_offset
;
merge into eq_linked_leg A
USING performance_leg B on (A.product_id = B.product_id and A.leg_id = B.leg_id)
when matched then
UPDATE SET A.fx_res_lag_date_roll=B.ret_reset_dateroll
;
merge into eq_linked_leg A
USING performance_leg B on (A.product_id = B.product_id and A.leg_id = B.leg_id)
when matched then
UPDATE SET A.fx_res_lag_holidays=B.ret_reset_holidays
;


begin 
add_column_if_not_exists ('eq_link_leg_hist','fx_res_lag_is_business_b','NUMBER DEFAULT 0 NULL');
end;
/

begin 
add_column_if_not_exists ('eq_link_leg_hist','fx_res_lag_offset','NUMBER DEFAULT 0 NULL');
end;
/
begin 
add_column_if_not_exists ('eq_link_leg_hist','fx_res_lag_date_roll','VARCHAR2(16) NULL');
end;
/
begin 
add_column_if_not_exists ('eq_link_leg_hist','fx_res_lag_holidays','VARCHAR(128) NULL');
end;
/

update eq_link_leg_hist t set fx_res_lag_is_business_b =
(select ret_reset_offset_b from perf_leg_hist where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)
;
update eq_link_leg_hist t set fx_res_lag_offset =
(select ret_reset_offset from perf_leg_hist where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)
;
update eq_link_leg_hist t set fx_res_lag_date_roll =
(select ret_reset_dateroll from perf_leg_hist where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)
;
update eq_link_leg_hist t set fx_res_lag_holidays =
(select ret_reset_holidays from perf_leg_hist where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)
;
 
/* CAL-151390 */
/* update missing fwd start end dates */
 
update cf_sch_gen_params       p
set     (start_date, end_date) = 
        (
                select start_date, end_date
                from    commodity_leg2 l
                where   p.leg_id = l.leg_id
        )
where   start_date is null
and     end_date is null
and     exists (
                select 1 
                from product_desc d
                where   d.product_type = 'CommodityForward'
                and     p.product_id = d.product_id
                )
;

 
/*  update fwd security calendar and fixing policy with that of the cash 
 */

update cf_sch_gen_params       p_sec
set     (payment_calendar, fixing_calendar, fixing_date_policy) = 
        (
                select payment_calendar, fixing_calendar, fixing_date_policy
                from    cf_sch_gen_params p_cash
                where   p_sec.product_id = p_cash.product_id
                and     p_sec.leg_id = p_cash.leg_id
                and     p_cash.param_type = 'COMMODITY'
        )
where   payment_calendar is null
and     fixing_calendar is null
and     p_sec.param_type = 'SECURITY'
and     exists (
                select 1 
                from 	product_desc d
                where   d.product_type = 'CommodityForward'
                and     p_sec.product_id = d.product_id
                )
;


create table user_name_bak14 as select * from user_name
;

begin 
add_column_if_not_exists ('user_name','hex_password','varchar2(255) null');
end;
/


update user_name n set hex_password = 
(select lower(RAWTOHEX(utl_raw.cast_to_raw(utl_raw.cast_to_varchar2(p.user_password)))) from user_password p
where n.user_name = p.user_name)
where hex_password is null
;

rename user_password to user_password_bak
;
 
/* CAL-155875 ? FXNDF processing as Trades rather than Positions */

update pos_info set product_pos_b=0 where product_type IN ('FXNDF','FXNDFSwap','PositionFXNDF')
;
delete from domain_values where name ='PositionBasedProducts' and value IN ('FXNDF','FXNDFSwap','PositionFXNDF')
;
 
/* CAL-158607 */
update settle_position set date_type = 'Trade Date' where date_type='TRADE'
;
update settle_position set date_type = 'Settle Date' where date_type='SETTLE'
;
/* end */

/* CAL-157793 */
/* can process 300m rows / 20m deletions in < 20min in parallel */ 
delete /*+ parallel(8) */ from liq_position where is_deleted = 1
;
/* end */

/* CAL-153882 */
/* may profit from 'alter session enable parallel dml;' for large bo_task tables */ 
/* can process 158m rows in <12min in parallel */
/* currently, we don't bother about bo_task_hist */
declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tab_columns WHERE table_name='BO_TASK' and column_name='PO_ID';
  IF x=0 THEN
    execute immediate 'alter table bo_task add ( po_id numeric )';
 	execute immediate 'update /*+ parallel(8) */ bo_task set po_id = (select legal_entity_id from book where book.book_id = bo_task.book_id) where bo_task.book_id != 0 and bo_task.po_id is null';
	END IF;
end;
/

/* CAL-158718 adding boolean to control settlement holidays*/
begin
add_column_if_not_exists ('swap_leg','settle_holidays_b', 'number DEFAULT 0 NULL');
end;
/
update swap_leg set settle_holidays_b=1 where settle_holidays is not NULL and settle_holidays != coupon_holidays
;

/* end */

ALTER TABLE generic_comment MODIFY document_type VARCHAR(128) 
;
ALTER TABLE generic_comment_hist MODIFY document_type VARCHAR(128) 
;
delete from domain_values where name='applicationName' and value='EventServer' and description=''
;

update user_viewer_column set column_name='Accounting Link' where uv_usage = 'BOOK_WINDOW_COL' and column_name='Accounting Book'
;


DELETE FROM pricer_measure WHERE measure_name = 'HISTO_POS_CASH'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_CUMUL_CASH'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_UNSETTLED_CASH'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_REALIZED'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_CUMUL_CASH_FEES'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_BS'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_ACCRUAL_BO'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_REALIZED_ACCRUAL'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_TOTAL_PAYDOWN'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_TOTAL_PAYDOWN_BOOK_VALUE'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_CUMUL_CASH_INTEREST'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_TOTAL_INTEREST'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_UNSETTLED_FEES'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_UNREALIZED_CASH'
;
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_SETTLED_REALIZED' 
;
begin
add_column_if_not_exists ('pl_mark_value','is_derived','number null');
end;
/

begin
add_column_if_not_exists ('pl_mark_value','original_currency','varchar2(3) null');
end;
/
declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tables WHERE table_name=upper('pl_archive_trade') ;
  IF x=0 THEN
    execute immediate 'create table pl_archive_trade (trade_id number(*,0) not null , currency varchar2(3) not null , archive_date timestamp (6) not null , 
	book_id number(*,0) not null , liq_agg_id number(*,0) not null , entered_datetime timestamp (6) not null , 
	update_datetime timestamp (6), version_num number(*,0) not null , entered_user varchar2(32) not null ) ';
	END IF;
end;
/
update /*+ PARALLEL ( pl_mark_value) */ pl_mark_value set original_currency = currency
/

 
begin
drop_procedure_if_exists('ADD_HISTO_UNSETTLED_CASH_FEES');
end;
/
begin 
drop_procedure_if_exists ('ADD_PL_ATTRIBUTE_DATA'); 
end;
/
begin 
drop_procedure_if_exists ('ADD_UNSETTLED_CASH_FEES'); 
end;
/
begin 
drop_procedure_if_exists ('CALYPSO_SEED_PROC');
end;
/
begin 
drop_procedure_if_exists ('INSERT_MARK_CA_COST_CA_PV'); 
end;
/
begin 
drop_procedure_if_exists ('MIGRATE_SIMPLEMM_SALES_MARGIN'); 
end;
/
begin 
drop_procedure_if_exists ('SETRATEINDEXATTRIBUTE'); 
end;
/
begin 
drop_procedure_if_exists ('SP_ADD_BOOK_ATTRIBUTE'); 
end;
/
begin 
drop_procedure_if_exists ('SP_ADD_EOD_GROUP_BOOK_ATTR'); 
end;
/
begin 
drop_procedure_if_exists ('SP_ADD_LE_ATTR ');
end;
/
begin 
drop_procedure_if_exists ('SP_ADD_TENOR'); 
end;
/
begin 
drop_procedure_if_exists ('SP_ADD_TERMS_CONDITIONS'); 
end;
/
begin 
drop_procedure_if_exists ('SP_CHNGPRIORITY'); 
end;
/
begin 
drop_procedure_if_exists ('SP_COPY_TNC'); 
end;
/
begin 
drop_procedure_if_exists ('SP_COUNTRY_ATTRIBUTE'); 
end;
/
begin 
drop_procedure_if_exists ('SP_EVENT_PROCESSED ');
end;
/
begin 
drop_procedure_if_exists ('SP_INSERT_FX_RESET ');
end;
/
begin 
drop_procedure_if_exists ('SP_UPDATE_AN_PARAM ');
end;
/
begin 
drop_procedure_if_exists ('TRADE_FILTER_MAT_DTFIX'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATECASHFXREVAL ');
end;
/
begin 
drop_procedure_if_exists ('UPDATECASHFXREVAL_1 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEFULLBASEPNL ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEFULLBASEPNL_1 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_1 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_10 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_11 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_12 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_13 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_14 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_15 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_16 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_17 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_18 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_19 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_2 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_20 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_21 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_22 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_3 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_4 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_5 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_6 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_7 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_8 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATEINTRADAY_9 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATESLFEESPNL ');
end;
/
begin 
drop_procedure_if_exists ('UPDATESLFEESPNL_1 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATETOTALACCRUAL ');
end;
/
begin 
drop_procedure_if_exists ('UPDATETOTALACCRUAL_1 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEACCRUALPNL ');
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEACCRUALPNL_1 ');
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEDATECASHREVAL'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEDATECASHREVAL_1'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEDATEFULLPNL'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEDATEFULLPNL_1');
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEDATEUNREALIZED'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEDATEUNREALIZED_1'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEFULLPNL'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEFULLPNL_1'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEUNREALIZEDFX');
end;
/
begin 
drop_procedure_if_exists ('UPDATETRADEUNREALIZEDFX_1'); 
end;
/
begin 
drop_procedure_if_exists ('UPDATEUNREALIZEDFX');
end;
/
begin 
drop_procedure_if_exists ('UPDATEUNREALIZEDFX_1');
end;
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
        EXECUTE IMMEDIATE 'CREATE TABLE user_configs ( id numeric  DEFAULT 0 NOT NULL,  
		username varchar2 (128) NOT NULL,  last_modified timestamp  NOT NULL,  
		name varchar2 (255) NULL,  doc_type varchar2 (255) NOT NULL,  xml_data clob  NULL )';
     
    END IF;
END add_table;
/

BEGIN
add_table('user_configs');
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
        EXECUTE IMMEDIATE 'CREATE TABLE cws_document (  ID NUMBER(38) NOT NULL,
USERNAME VARCHAR2(128) NOT NULL,  LAST_MODIFIED TIMESTAMP(6)  NOT NULL, 
NAME VARCHAR2(255),  DOC_TYPE VARCHAR2(255) NOT NULL, XML_DATA CLOB)';
     
    END IF;
END add_table;
/

BEGIN
add_table('cws_document');
END;
/

create or replace procedure cws_document_user_configs  
as
x number := 0 ;
cws_last_date timestamp;
cfg_last_date timestamp;
usr_cfg number := 0 ;
begin
                select count(*) into x from user_tables where table_name=UPPER('user_configs');
if x = 1 then               
                select max(cws_document.last_modified) into cws_last_date from cws_document;
                select max(user_configs.last_modified) into cfg_last_date from user_configs;
                select count(*) into usr_cfg from user_configs;
    if (cws_last_date > cfg_last_date) or  usr_cfg = 0 then
                execute immediate 'drop table user_configs';
                execute immediate 'create table user_configs as (select * from cws_document)';
    end if;
elsif  x = 0 then
execute immediate 'create table user_configs as (select * from cws_document)';
end if;
end;
/
begin
cws_document_user_configs;
end;
/
drop procedure cws_document_user_configs
;


DECLARE
x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER('pc_discount') and column_name=upper('collateral_curr');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x != 0 THEN
        EXECUTE IMMEDIATE 'alter table pc_discount modify collateral_curr varchar2(4)';
		EXECUTE IMMEDIATE 'alter table pc_discount modify collateral_curr default '||chr(39)||'NONE'||chr(39);
		EXECUTE IMMEDIATE 'update pc_discount set collateral_curr = '||chr(39)||'NONE'||chr(39)||' where collateral_curr = '||chr(39)||'ANY'||chr(39);
    END IF;
END;
/

update bo_audit set entity_field_name = 'Product.__specificResets', old_value = null, new_value = null where entity_field_name = 'Product.__specificResets (count)' and entity_class_name = 'Trade'
;

update bo_audit set entity_field_name = 'Product.__excludedFixings', old_value = null, new_value = null where entity_field_name = 'Product.__excludedFixings (count)' and entity_class_name = 'Trade'
;

/* end */
begin
add_column_if_not_exists('group_access','access_value','varchar2(255) not null');
end;
/

INSERT INTO group_access( group_name, access_id, access_value, read_only_b ) 
SELECT DISTINCT ga.group_name, 1, 'AdmLoginAttempts', 0 
FROM group_access ga WHERE ga.access_id = 1 and (ga.access_value = 'AdmDeleteLoginAttempts' or ga.access_value = 'AdmPurgeLoginAttempts')
;
DELETE FROM group_access WHERE access_id=1 AND (access_value='AdmDeleteLoginAttempts' OR access_value = 'AdmPurgeLoginAttempts')
;
INSERT INTO group_access( group_name, ACCESS_ID, ACCESS_VALUE, READ_ONLY_B )
SELECT DISTINCT ga.group_name, 1, 'AdmServer', 0
FROM group_access ga
WHERE ga.group_name NOT IN (SELECT ga.group_name FROM group_access ga WHERE ga.access_id =1 AND ga.access_value='AdmServer') AND ga.access_id = 1
AND ga.access_value IN ('AdmChangeDSLogOptions','AdmClearCache','AdmDSListActiveDataServer','AdmDSShowConnectedClient',
'AdmDSShowTaskStatistics','AdmShowDSOptions','AdmShowProfiler','AdmShowSQLMonitoring','AdmStartStopEngines',
'AdmUpdateTrace','AuthorizeDisconnectClients','RunAdminMonitor')
;
DELETE FROM group_access WHERE access_id=1
AND access_value IN ('AdmChangeDSLogOptions','AdmClearCache','AdmDSListActiveDataServer','AdmDSShowConnectedClient',
'AdmDSShowTaskStatistics','AdmShowDSOptions','AdmShowProfiler','AdmShowSQLMonitoring','AdmStartStopEngines',
'AdmUpdateTrace','AuthorizeDisconnectClients','RunAdminMonitor','AdmPurgeDBConnection','AdmPurgeLiquidatedPosition','AdmPurgeLogFiles',
'AdmUnCacheBook_Filter','AdmUpdateDSOptions')
;
DELETE FROM domain_values where name='function' and value IN ('AdmChangeDSLogOptions','AdmClearCache','AdmDSListActiveDataServer','AdmDSShowConnectedClient',
'AdmDSShowTaskStatistics','AdmShowDSOptions','AdmShowProfiler','AdmShowSQLMonitoring','AdmStartStopEngines',
'AdmUpdateTrace','AuthorizeDisconnectClients','RunAdminMonitor','AdmPurgeDBConnection','AdmPurgeLiquidatedPosition','AdmPurgeLogFiles',
'AdmUnCacheBook_Filter','AdmUpdateDSOptions','AdmDeleteLoginAttempts','AdmPurgeLoginAttempts')
;
DELETE FROM group_access WHERE access_id=1 AND (access_value='AdmDeleteLoginAttempts' OR access_value = 'AdmPurgeLoginAttempts')
;

declare
    x number;
begin
    begin
	select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER('lifecycle_event') and column_name=upper('execution_date');
	exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
        EXECUTE IMMEDIATE 'update lifecycle_event set event_datetime =execution_date';
    END IF;
END;
/

delete from domain_values where name = 'riskAnalysis' and value = 'VegaByStrike'
;
delete from an_viewer_config where analysis_name = 'VegaByStrike' 
;
create table main_entry_prop_back14 as select * from main_entry_prop
;
create or replace procedure mainent_schd_new
as 
  begin
  declare
  v_sql varchar2(512);
  v_prefix_code_l varchar2(16);
  v_prefix_code varchar(16);
  cursor c1 is
  select property_name, user_name,substr(property_name,1,instr(property_name, 'Action')-1),
  property_value from main_entry_prop where property_value = 'refdata.ScheduledTaskTreeFrame';
  begin
  for c1_rec in c1 LOOP
  
v_prefix_code := substr(c1_rec.property_name,1,instr(c1_rec.property_name,'Action')-1);

v_sql := 'update main_entry_prop set property_value = '||chr(39)||'scheduling'||chr(46)||'ScheduledTaskListWindow'||chr(39)|| ' 
where user_name = '||chr(39)||c1_rec.user_name||chr(39)|| ' and property_name like '||chr(39)||chr(37)||v_prefix_code||chr(37)||chr(39)||'
and property_name like '||chr(39)||chr(37)||'Action'||chr(39);

                       
execute immediate v_sql;           
                
end loop;
end;
end;
/

begin
mainent_schd_new;
end;
/
drop procedure mainent_schd_new
;
create or replace procedure mainent_schd_l
as 
  begin
  declare
  v_sql varchar2(512);
  v_prefix_code_l varchar2(16);
  v_prefix_code varchar(16);
  cursor c1 is
  select property_name, user_name,substr(property_name,1,instr(property_name, 'Action')-1),
  property_value from main_entry_prop where property_value = 'scheduling.ScheduledTaskListWindow';
  begin
  for c1_rec in c1 LOOP
  
v_prefix_code_l :=substr(c1_rec.property_name,1,instr(c1_rec.property_name,'Action')-1);
v_sql :='update main_entry_prop set property_value='||chr(39)||'ScheduledTask(New)'||chr(39)|| ' where user_name = '||chr(39)||c1_rec.user_name||chr(39)|| ' 
 and property_name like '||chr(39)||v_prefix_code_l||'Label'||chr(39) ; 

execute immediate v_sql; 

end loop;
end;
end;
/
begin
mainent_schd_l;
end;
/
drop procedure mainent_schd_l
;


create or replace procedure mainent_schd_o
as 
  begin
  declare
  v_sql varchar2(512);
  v_prefix_code_l varchar2(16);
  v_prefix_code varchar(16);
  cursor c1 is
  select property_name, user_name,substr(property_name,1,instr(property_name, 'Action')-1),
  property_value from main_entry_prop where property_value = 'refdata.ScheduledTaskWindow';
  begin
  for c1_rec in c1 LOOP
  
v_prefix_code_l :=substr(c1_rec.property_name,1,instr(c1_rec.property_name,'Action')-1);
v_sql :='update main_entry_prop set property_value='||chr(39)||'ScheduledTask(Depricated)'||chr(39)|| ' where user_name = '||chr(39)||c1_rec.user_name||chr(39)|| ' 
 and property_name like '||chr(39)||v_prefix_code_l||'Label'||chr(39) ; 

execute immediate v_sql; 

end loop;
end;
end;
/
begin
mainent_schd_o;
end;
/
drop procedure mainent_schd_o
;
/* Scheduling Engine Changes End */

update risk_presenter_item set trade_freq = -1 where trade_freq = 0
;

update risk_presenter_item set quote_freq = -1 where quote_freq = 0
;

update risk_presenter_item set market_data_freq= -1 where market_data_freq = 0
;

update risk_on_demand_item set trade_freq = -1 where trade_freq = 0
;

update risk_on_demand_item set quote_freq = -1 where quote_freq = 0
;

update risk_on_demand_item set market_data_freq= -1 where market_data_freq = 0
;

/*Diff as of the Revision # 247861 */

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_POS_CASH','tk.core.PricerMeasure',359 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_REALIZED_ACCRUAL','tk.core.PricerMeasure',379 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_REALIZED','tk.core.PricerMeasure',371 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_TOTAL_PAYDOWN','tk.core.PricerMeasure',384 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_TOTAL_PAYDOWN_BOOK_VALUE','tk.core.PricerMeasure',385 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_TOTAL_INTEREST','tk.core.PricerMeasure',389 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_CUMUL_CASH','tk.core.PricerMeasure',360 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_ACCRUAL_BO','tk.core.PricerMeasure',378 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_UNSETTLED_CASH','tk.core.PricerMeasure',368 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_CUMUL_CASH_FEES','tk.core.PricerMeasure',372 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_BS','tk.core.PricerMeasure',374 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_CUMUL_CASH_INTEREST','tk.core.PricerMeasure',387 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_UNSETTLED_FEES','tk.core.PricerMeasure',390 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_UNREALIZED_CASH','tk.core.PricerMeasure',392 )
/
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('HISTO_SETTLED_REALIZED','tk.core.PricerMeasure',397 )
/


INSERT INTO fee_definition ( fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, is_allocated, fee_code ) VALUES ('CA_SALES_MARGIN','cross asset sales margin',0,0,'ProcessingOrg',0,0,1,28 )
/
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','AllowCashSecurityMixDiffCcy' )
/
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','EventTypeAction' )
/
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','InternalLegalEntity' )
/
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','InternalRole' )
/
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','ValueDate' )
/
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','XferCollId' )
/
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','LiquidationEngine','LiquidationEngineEventFilter' )
/
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','PositionKeepingPersistenceEngine','PositionKeepingServerTradeEventFilter' )
/
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Front-Office','PositionKeepingPersistenceEngine','PositionKeepingServerTradeEventFilter' )
/
DELETE referring_object WHERE rfg_obj_id=603
/
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (603,1,'task_priority','id','1','sd_filter','TaskPriority','apps.refdata.TaskPriorityWindow','Task Priority Configuration Setup' )
/
INSERT INTO report_panel_def ( win_def_id, panel_index, report_type, panel_name ) VALUES (134,0,'CAReconciliationCash','Cash' )
/
INSERT INTO report_panel_def ( win_def_id, panel_index, report_type, panel_name ) VALUES (134,1,'CAReconciliationSecurity','Security' )
/
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (134,'CAReconciliation',0,0,1 )
/
DELETE sql_blacklist_properties WHERE value LIKE 'com.calypso.apps.taskstation.dialog.reportplan%'
/
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.taskstation.dialog.reportplan.ReportPlanDialog' )
/
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.ui.distribution.DistributionProgressDialog' )
/
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.taskstation.dialog.reportplan.ConditionalColorPage')
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2252387,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Fixed_Rate,Payment_Date,Period_Rate,Record_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2360385,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Payment_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2449758,'CASwiftEventCode','CAMatch.MT564','List','Amort_Rate,Ex_Date,Payment_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2455926,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Payment_Date,Record_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464289,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,New_Pool_Factor,Payment_Date,Previous_Pool_Factor,Record_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2511356,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Payment_Date,Redemption_Price' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2252387,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Fixed_Rate,Payment_Date,Period_Rate,Record_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2360385,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Payment_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2449758,'CASwiftEventCode','CAMatch.MT566','List','Amort_Rate,Ex_Date,Payment_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2455926,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Payment_Date,Record_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464289,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,New_Pool_Factor,Payment_Date,Previous_Pool_Factor,Record_Date' )
/
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2511356,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Payment_Date,Redemption_Price' )
/
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('HORIZON_TENOR','com.calypso.tk.core.Tenor','','Horizon tenor',1,'1D' )
/
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('MC_BLACK_VOLATILITY','java.lang.String','FAST,EXACT','Flag controls whether volatility lookup is optimized for Monte-Carlo Black pricers.',0,'FAST' )
/
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('BASIS_ADJ_METHOD','java.lang.String','PV Mult,PV Add,Dur Wtd Mult,Dur Wtd Add','Credit index basis adjustment method.',1,'BASIS_ADJ_METHOD','null' )
/
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('USE_PEDERSEN_MODEL','java.lang.Boolean','true,false','Credit Index Option Valuation method',1,'USE_PEDERSEN_MODEL','false' )
/
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'UserConfigDocuments',500)
/
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'LifeCycleProcessorRule',500 )
/
declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='PositionKeepingPersistenceEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'PositionKeepingPersistenceEngine','Position Keeping Persistence Engine' );
end if;
end;
/
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventProcessMessage','SenderEngine' )
/
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTrade','LifeCycleEngine' )
/
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTransfer','LifeCycleEngine' )
/
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Front-Office','PSEventTrade','PositionKeepingPersistenceEngine' )
/
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTrade','PositionKeepingPersistenceEngine' )
/

declare
  x number :=0 ;
    begin
	SELECT count(*) INTO x FROM user_tab_columns WHERE table_name=upper('wfw_transition') and column_name=upper('priority');
    IF x = 0 THEN
    execute immediate 'alter table wfw_transition add priority number default 0';
		EXECUTE IMMEDIATE 'update wfw_transition set PRIORITY=0 where PRIORITY is null';
		EXECUTE IMMEDIATE 'alter table wfw_transition modify PRIORITY not null';
    END IF;
end;
/

INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (656,'LifeCycleEvent','PENDING','TERMINATE','TERMINATED',0,1,'ALL',0,0,0,0,0 )
/

INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (657,'LifeCycleEvent','CANCELLING','TERMINATE','TERMINATED',0,1,'ALL',0,0,0,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (600,'CAElection','NONE','NEW','PENDING',0,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, prefered_b ) VALUES (602,'CAElection','PARTIALLY_ELECTED','ELECT','PENDING',0,1,'ALL',0,0,1,0,0,1 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, prefered_b ) VALUES (603,'CAElection','ELECTED','ELECT','PENDING',0,1,'ALL',0,0,1,0,0,1 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (604,'CAElection','ELECTED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (605,'CAElection','PENDING','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (606,'CAElection','PARTIALLY_ELECTED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (607,'CAElection','PENDING','ELECT','PARTIALLY_ELECTED',1,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (608,'CAElection','PARTIALLY_ELECTED','ELECT','ELECTED',1,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (609,'CAElection','ELECTED','AUTHORIZE','VALIDATED',1,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (610,'CAElection','LOCKED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (611,'CAElection','LOCKED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (612,'CAElection','ELECTED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (613,'CAElection','PARTIALLY_ELECTED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (614,'CAElection','PENDING','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (615,'CAElection','VALIDATED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (616,'CAElection','VALIDATED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, prefered_b ) VALUES (617,'CAElection','VALIDATED','ELECT','PENDING',0,1,'ALL',0,0,1,0,0,1 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (618,'CAElection','VALIDATED','LOCK','LOCKED',0,1,'ALL',0,0,1,0,0 )
/
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (619,'CAElection','PENDING','ELECT','PENDING',0,1,'ALL',0,0,1,0,0 )
/

/* ..*/

INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (607,'CheckPartiallyElected' )
/
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (608,'CheckElected' )
/
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (609,'CheckBookEntitledObligatedDifference' )
/
  

begin
add_domain_values('plMeasure','Settlement_Date_PnL_Base','' );
end;
/
begin
add_domain_values('expressProductTypes','FutureMM','FutureMM' );
end;
/
begin
add_domain_values('function','AdmServer','' );
end;
/
begin
add_domain_values('function','AdmLoginAttempts','' );
end;
/
begin
add_domain_values('LocaleForBondQuotes','English','Locale for Bond quotes' );
end;
/
begin
add_domain_values('domainName','AdvanceStandardSingleSwapLegTemplateName','specify the SingleSwapLeg trade template name to be used by hypersurface advance generator' );
end;
/
begin
add_domain_values('workflowRuleMessage','CheckCutOffTimeSdi','' );
end;
/
begin
add_domain_values('workflowRuleMessage','CheckCutOffTimeSdiLate','' );
end;
/
begin
add_domain_values('workflowRuleTrade','UndoLastReset','' );
end;
/
begin
add_domain_values('function','CreateCommodityUnitconversion','Access permission to create Commodity Unit conversion' );
end;
/
begin
add_domain_values('function','ModifyCommodityUnitconversion','Access permission to Modify Commodity Unit conversion' );
end;
/
begin
add_domain_values('function','RemoveCommodityUnitconversion','Access permission to Remove Commodity Unit conversion' );
end;
/
begin
add_domain_values('function','AddModifyTradeEntryDefaultConfig','Access permission to Add or Modify a trade entry default configuration' );
end;
/
begin
add_domain_values('sdiAttribute','CutOffTime','' );
end;
/
begin
add_domain_values('MsgAttributes.ConfType','PartFixing','PartFixing Confirmation' );
end;
/
begin
add_domain_values('MsgAttributes','IsQuanto','3rd Settlement Currency' );
end;
/
begin
add_domain_values('domainName','MsgAttributes.IsQuanto','3rd Settlement Ccy (TRUE, FALSE);' );
end;
/
begin
add_domain_values('MsgAttributes.IsQuanto','TRUE','3rd Settlement Currency' );
end;
/
begin
add_domain_values('MsgAttributes.IsQuanto','FALSE','Not 3rd Settlement Currency' );
end;
/
begin
add_domain_values('CountryAttributes','CountryAddressFormat','Define Country address format template for messaging purpose' );
end;
/
begin
add_domain_values('CountryAttributesReadOnly','CountryAddressFormat','Define Country address format template for messaging purpose' );
end;
/
begin
add_domain_values('classAuditMode','Country','' );
end;
/
begin
add_domain_values('function','AddBookSubstitutionRequest','Access permission to Add Book Substitution Requests' );
end;
/
begin
add_domain_values('function','ModifyBookSubstitutionRequest','Access permission to Modify Book Substitution Requests' );
end;
/
begin
add_domain_values('function','RemoveBookSubstitutionRequest','Access permission to Remove Book Substitution Requests' );
end;
/
begin
add_domain_values('domainName','bulkTerminationProductType','Termination Action Product Types' );
end;
/
begin
add_domain_values('bulkTerminationProductType','Cash','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CallNotice','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CapFloor','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CDSIndex','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CDSIndexTranche','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CDSNthDefault','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CDSNthLoss','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CreditDefaultSwap','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','CreditDefaultSwapABS','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','EquityLinkedSwap','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','FRA','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','FXOption','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','FXSwap','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','DBVRepo','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','GCFRepo','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','JGBRepo','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','Pledge','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','Repo','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','SecurityLending','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','SecLending','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','SecurityVersusCash','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','SimpleMM','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','SimpleRepo','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','Swap','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','SwapCrossCurrency','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','UnavailabilityTransfer','' );
end;
/
begin
add_domain_values('bulkTerminationProductType','XCCySwap','' );
end;
/
begin
add_domain_values('MultiMDIGenerators','TripleGlobal','Generate three curves together.' );
end;
/
begin
add_domain_values('CurveZero.gen','DoubleGlobal','Generate two curves together. Requires multiple curve window.' );
end;
/
begin
add_domain_values('CurveZero.gen','TripleGlobal','Generate three curves together. Requires multiple curve window.' );
end;
/
begin
add_domain_values('CorrelationSurface.gen','BaseCorrelationTopDown','' );
end;
/
begin
add_domain_values('correlationType','ADR','' );
end;
/
begin
add_domain_values('domainName','FXForwardStart.subtype','Types of FXForwardStart' );
end;
/
begin
add_domain_values('domainName','FXForwardStart.underlyingType','Underlying product types for FXForwardStart' );
end;
/
begin
add_domain_values('domainName','SecLending.tradeCaptureSubTypes','Types of SecLending sub types available for new trade capture' );
end;
/
begin
add_domain_values('MarketMeasureCalculators','BreakEvenCOF','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','IsAmortizing','' );
end;
/
begin
add_domain_values('classAuditMode','BookSubstitutionRequest','' );
end;
/
begin
add_domain_values('StructuredFlows.subtype','Revolving','Subtype to define revolving loans' );
end;
/
begin
add_domain_values('classAuthMode','TradeEntryDefaultConfig','' );
end;
/
begin
add_domain_values('classAuditMode','TradeEntryDefaultConfig','' );
end;
/
begin
add_domain_values('classAuditMode','CreditEvent','' );
end;
/
begin
add_domain_values('PositionBasedProducts','BondDanishMortgage','' );
end;
/
begin
add_domain_values('rateIndexAttributes','USE_INDEX_FREQUENCY','' );
end;
/
begin
add_domain_values('SpotDateCalculator','LiborRateIndexSpotDateCalculator','' );
end;
/
begin
add_domain_values('ExternalMessageField.MessageMapper','MT564','' );
end;
/
begin
add_domain_values('ExternalMessageField.MessageMapper','MT566','' );
end;
/
begin
add_domain_values('domainName','MT370CodeTag22F','' );
end;
/
begin
add_domain_values('MT370CodeTag22F','FOEX','FX,FXSwap,FXForward' );
end;
/
begin
add_domain_values('MT370CodeTag22F','MMKT','SimpleMM,Cash' );
end;
/
begin
add_domain_values('MT370CodeTag22F','NDLF','FXNDF,FXNDFSwap' );
end;
/
begin
add_domain_values('MT370CodeTag22F','OPTI','FXOption,Swaption' );
end;
/
begin
add_domain_values('FXForwardStart.keywords','XCcySplitRates','' );
end;
/
begin
add_domain_values('FXForwardStart.keywords','XccySptMismatchRates','' );
end;
/
begin
add_domain_values('domainName','ParRatesCurveGeneratorChoice','' );
end;
/
begin
add_domain_values('ParRatesCurveGeneratorChoice','BootStrap','' );
end;
/
begin
add_domain_values('ParRatesCurveGeneratorChoice','Global','' );
end;
/
begin
add_domain_values('domainName','ParRatesCurveInterpolatorChoice','' );
end;
/
begin
add_domain_values('ParRatesCurveInterpolatorChoice','InterpolatorLogLinear','' );
end;
/
begin
add_domain_values('ParRatesCurveInterpolatorChoice','InterpolatorLinear','' );
end;
/
begin
add_domain_values('workflowRuleTrade','AppendReportingCurrencyData','Adds Reporting Currency Data to the trades' );
end;
/
begin
add_domain_values('workflowRuleTrade','FXSpotReserveSETVAL','Performs SETVALDT action on FXSpotReserve swap trades' );
end;
/
begin
add_domain_values('userAttributes','FXForwardStart Default Reset Tenor','' );
end;
/
begin
add_domain_values('userAttributes','FX Default Trade Region','Used in the FX Deal station to determine the default Trade Region' );
end;
/
begin
add_domain_values('ExternalMessageField.MessageMapper','MT942','' );
end;
/
begin
add_domain_values('function','EditAccountSweepingDetail','Allow User to Edit Sweeping Detail in PoolConsolidation Wizard' );
end;
/
begin
add_domain_values('workflowRuleTransfer','UpdateCAAdjustBookLinkedXfer','' );
end;
/
begin
add_domain_values('AccountSetup','INTEREST_ALWAYS_SWEPT_WITH_CUSTXFER','false' );
end;
/
begin
add_domain_values('cfdProductType','EquityIndex','' );
end;
/
begin
add_domain_values('corporateActionType','ACCRUAL.EXERCISE','' );
end;
/
begin
add_domain_values('corporateActionType','ACCRUAL.OVER','' );
end;
/
begin
add_domain_values('corporateActionType','ADR.CAADR','' );
end;
/
begin
add_domain_values('CASwiftEventCodeAttributes','CAMatch.MT564','Message Attributes matched for incoming MT564' );
end;
/
begin
add_domain_values('CASwiftEventCodeAttributes','CAMatch.MT566','Message Attributes matched for incoming MT566' );
end;
/
begin
add_domain_values('classAuditMode','CASwiftEventCodeAttributes','tk.product.corporateaction' );
end;
/
begin
add_domain_values('domainName','CAMatch.MessageAttribute','List of incoming MT56x eligible for matching' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Ex_Date','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Record_Date','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Payment_Date','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Period_Rate','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Fixed_Rate','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Amort_Rate','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Redemption_Price','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','Previous_Pool_Factor','' );
end;
/
begin
add_domain_values('CAMatch.MessageAttribute','New_Pool_Factor','' );
end;
/
begin
add_domain_values('CA.subtype','CAADR','' );
end;
/
begin
add_domain_values('CA.subtype','OVER','' );
end;
/
begin
add_domain_values('CA.Status','WITHDRAWN','Withdrawal: Message sent to void a previously sent notification due to the withdrawal of the event or offer by the issuer' );
end;
/
begin
add_domain_values('CA.Status','MANUAL','a Bond Corporate Action with MANUAL status will not be modified by the CA generation process' );
end;
/
begin
add_domain_values('CA.ApplicableStatus','MANUAL','' );
end;
/
begin
add_domain_values('CA.CanceledStatus','WITHDRAWN','' );
end;
/
begin
add_domain_values('Advance.subtype','Revolving','Subtype to define revolving loans' );
end;
/
begin
add_domain_values('FXForwardStart.subtype','FXForward','' );
end;
/
begin
add_domain_values('FXForwardStart.subtype','FXNDF','' );
end;
/
begin
add_domain_values('FXForwardStart.subtype','FXSwap','' );
end;
/
begin
add_domain_values('FXForwardStart.subtype','FXNDFSwap','' );
end;
/
begin
add_domain_values('domainName','FXForwardStartKeywordsToCopy','Identify keywords to copy from FXForwardStart trade to underlying trade when the forward-start is fixed.' );
end;
/
begin
add_domain_values('SecLending.subtype','Rebate','' );
end;
/
begin
add_domain_values('SecLending.subtype','Fee Cash Pool','' );
end;
/
begin
add_domain_values('SecLending.subtype','Fee Non Cash Pool','' );
end;
/
begin
add_domain_values('SecLending.subtype','Fee Unsecured','' );
end;
/
begin
add_domain_values('Repo.subtype','BSB','' );
end;
/
begin
add_domain_values('Repo.subtype','ZAR','' );
end;
/
begin
add_domain_values('eventFilter','LiquidationEngineEventFilter','Event Filter allowing only position-based products (and filtering others even if cash positions are set up for PositionEngine);' );
end;
/
begin
add_domain_values('eventFilter','PositionKeepingServerTradeEventFilter','Filter to allow only the PSEventTrade events with trades eligible for PositionKeepingServer.' );
end;
/
begin
add_domain_values('formatType','PDF','' );
end;
/
begin
add_domain_values('eventType','EX_CREATE_FX_POS_MON_MARKS','The FX Position Monitor mark creation scheduled task was successful.' );
end;
/
begin
add_domain_values('exceptionType','CREATE_FX_POS_MON_MARKS_SUCCESS','' );
end;
/
begin
add_domain_values('eventType','EX_CREATE_FX_POS_MON_MARKS_FAILURE','The FX Position Monitor mark creation scheduled task was not successful.' );
end;
/
begin
add_domain_values('exceptionType','CREATE_FX_POS_MON_MARKS_FAILURE','' );
end;
/
begin
add_domain_values('eventType','EX_SWEEP_FX_POS_MON_PL_SUCCESS','The FX Position Monitor PnL Sweep scheduled task was successful.' );
end;
/
begin
add_domain_values('eventType','EX_SWEEP_FX_POS_MON_PL_FAILURE','The FX Position Monitor PnL Sweep scheduled task was not successful.' );
end;
/
begin
add_domain_values('flowType','DIVIDEND','' );
end;
/
begin
add_domain_values('exceptionType','REPRICE','' );
end;
/
 
begin
add_domain_values('function','RemoveTradeEntryDefaultConfig','Access permission to remove a trade entry default configuration' );
end;
/
begin
add_domain_values('function','UndoSettledCreditEvents','Access permission to undo settled credit events' );
end;
/


begin
add_domain_values('function','AdmServer','Permission to administer servers' );
end;
/
begin
add_domain_values('function','AdmLoginAttempts','Permission to view and delete user login attempts' );
end;
/

begin
add_domain_values('billingCalculators','BillingFTTCalculator',null );
end;
/

begin
add_domain_values('function','CreateCommodityConversion','Function authorizing creation of commodity unit conversions' );
end;
/
begin
add_domain_values('function','ModifyCommodityConversion','Function authorizing modification of commodity unit conversions' );
end;
/
begin
add_domain_values('function','RemoveCommodityConversion','Function authorizing removal of commodity unit conversions' );
end;
/
begin
add_domain_values('function','CreateCommodityReset','Function authorizing creation of commodity resets' );
end;
/
begin
add_domain_values('function','ModifyCommodityReset','Function authorizing modification of commodity resets' );
end;
/
begin
add_domain_values('function','RemoveCommodityReset','Function authorizing removal of commodity resets' );
end;
/
begin
add_domain_values('function','CreateCommodityFixingDatePolicy','Function authorizing creation of commodity fixing date policies' );
end;
/
begin
add_domain_values('function','ModifyCommodityFixingDatePolicy','Function authorizing modification of commodity fixing date policies' );
end;
/
begin
add_domain_values('function','RemoveCommodityFixingDatePolicy','Function authorizing removal of commodity fixing date policies' );
end;
/
begin
add_domain_values('function','CreateCommodityCertificateTemplate','Function authorizing creation of commodity certificate templates' );
end;
/
begin
add_domain_values('function','ModifyCommodityCertificateTemplate','Function authorizing modification of commodity certificate templates' );
end;
/
begin
add_domain_values('function','RemoveCommodityCertificateTemplate','Function authorizing removal of commodity certificate templates' );
end;
/
begin
add_domain_values('function','CreateCommodityQuote','Function authorizing creation of commodity quotes' );
end;
/
begin
add_domain_values('function','ModifyCommodityQuote','Function authorizing modification of commodity quotes' );
end;
/
begin
add_domain_values('function','RemoveCommodityQuote','Function authorizing removal of commodity quotes' );
end;
/
begin
add_domain_values('function','ModifyCommodityCertificate','Function authorizing modification of commodity certificates' );
end;
/
begin
add_domain_values('function','ModifyCommodityWeight','Function authorizing modification of commodity risk weights' );
end;
/
begin
add_domain_values('function','AddProductCreditRating','Function authorizing modification of Credit Ratings' );
end;
/
begin
add_domain_values('function','ModifyProductCreditRating','Function authorizing modification of Credit Ratings' );
end;
/
begin
add_domain_values('function','DeleteProductCreditRating','Function authorizing modification of Credit Ratings' );
end;
/
begin
add_domain_values('productType','MICEXRepo','' );
end;
/
begin
add_domain_values('nettingType','SecLendingFeeCashPoolDAP','Merge SecLending xfer and MarginCall xfer in a DAP xfer' );
end;
/
begin
add_domain_values('productType','FXForwardStart','Forward Starting FX trade' );
end;
/
begin
add_domain_values('productType','ScriptableOTCProduct','produttype domain for ScriptableOTCProduct' );
end;
/
begin
add_domain_values('productType','RateIndexProduct','produttype domain for RateIndexProduct' );
end;
/
begin
add_domain_values('productType','ExternalTrade','' );
end;
/
begin
add_domain_values('scheduledTask','REPRICE','For revolving loans.' );
end;
/
begin
add_domain_values('scheduledTask','CREATE_FX_POS_MON_MARKS','Creates FX position monitor marks for the defined mark date and time' );
end;
/
begin
add_domain_values('scheduledTask','SWEEP_FX_POS_MON_PL','Sweeps daily FX position monitor PnL for the specified sweep currency' );
end;
/
begin
add_domain_values('scheduledTask','PROCESS_ENRICHED_TASKS','Update Task Enrichment' );
end;
/
begin
add_domain_values('SWIFT.Templates','MT210Grouped','Group of Notice to Receive' );
end;
/
begin
add_domain_values('MESSAGE.Templates','ScriptableOTCProductConfirmation.html','' );
end;
/
begin
add_domain_values('productTypeReportStyle','FXForwardStart','FXForwardStart ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','TransferAgent','TransferAgent ReportStyle' );
end;
/
begin
add_domain_values('groupStaticDataFilter','Book','group of StaticDataFilters dedicated to [Trade] Book, Book attributes selection' );
end;
/
begin
add_domain_values('groupStaticDataFilter','Security','group of StaticDataFilters dedicated to [Trade] underlying Security selection' );
end;
/
begin
add_domain_values('tradeKeyword','SecLendingTradeId','Available on MarginCall trade. Trade Id of SecLending generating this MarginCall trade. ' );
end;
/
begin
add_domain_values('tradeKeyword','SecLendingConvertedFrom','Available on SecLending trade converted from a Pay To Hold trade. This keyword contains the id of the Pay To Hold trade' );
end;
/
begin
add_domain_values('tradeKeyword','CAClaimReason','CA Trade generated either for Fail or Claim' );
end;
/
begin
add_domain_values('tradeKeyword','CAAgentAccountId','' );
end;
/
begin
add_domain_values('tradeKeyword','CAAgentCashAccountId','' );
end;
/
begin
add_domain_values('domainName','sdFilterCriterion','Static Data Filter criterion name' );
end;
/
begin
add_domain_values('domainName','sdFilterCriterion.Factory','Static Data Filter criterion factory name' );
end;
/
begin
add_domain_values('sdFilterCriterion','Trade Booking Date','' );
end;
/
begin
add_domain_values('sdFilterCriterion.Factory','CA','build Corporate Action Static Data Filter criteria' );
end;
/
begin
add_domain_values('domainName','DefaultTradeValuesHandler','Handlers for the trade entry default configs' );
end;
/
begin
add_domain_values('DefaultTradeValuesHandler','SecFinance','Defaults handler for secFinance TradeEntry' );
end;
/
begin
add_domain_values('marketDataUsage','HyperSurfaceOpen','' );
end;
/
begin
add_domain_values('hyperSurfaceSubTypes','Advance','' );
end;
/
begin
add_domain_values('hyperSurfaceSubTypes','AdvanceTemplate','' );
end;
/
begin
add_domain_values('accountProperty','CATradeDDAInternal','Create a Corporate Action Trade on the Internal View of a Client DDA Account Position ' );
end;
/
begin
add_domain_values('domainName','accountProperty.CATradeDDAInternal','' );
end;
/
begin
add_domain_values('accountProperty.CATradeDDAInternal','False','' );
end;
/
begin
add_domain_values('accountProperty.CATradeDDAInternal','True','' );
end;
/
begin
add_domain_values('plMeasure','Accrual_FX_Reval','' );
end;
/
begin
add_domain_values('domainName','systemEnrichmentContext','' );
end;
/
begin
add_domain_values('systemEnrichmentContext','ParticipationClassificationTradeEnrichment','' );
end;
/
begin
add_domain_values('function','CRMConfigAdmin','Give access to the Configuration dialog in the CRM window' );
end;
/
begin
add_domain_values('function','CRMAccessConfig','CRM user can see the Relationship and User tabs' );
end;
/
begin
add_domain_values('LifeCycleEventProcessor','tk.lifecycle.processor.NoAction','No Action' );
end;
/
begin
add_domain_values('LifeCycleEventStatus','CANCELLING','' );
end;
/
begin
add_domain_values('TradeRejectAction','UN-KNOCK_IN','UN-KNOCK_IN considered to be a reject action' );
end;
/
begin
add_domain_values('TradeRejectAction','UN-KNOCK_OUT','UN-KNOCK_OUT considered to be a reject action' );
end;
/
begin
add_domain_values('TradeRejectAction','UNEXERCISE','UNEXERCISE considered to be a reject action' );
end;
/
begin
add_domain_values('function','ModifyTSCatalogOrdering','Allow User to modify Task Station Catalog Ordering' );
end;
/
begin
add_domain_values('domainName','taskEnrichmentClasses','List of data source classes used for task enrichment' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','Trade','com.calypso.tk.core.Trade' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','Transfer','com.calypso.tk.bo.BOTransfer' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','Message','com.calypso.tk.bo.BOMessage' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','CrossWorkflows','com.calypso.tk.bo.Task' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','Dynamic','com.calypso.tk.bo.Task' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','TradeBundle','com.calypso.tk.core.TradeBundle' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','CAElection','com.calypso.tk.product.corporateaction.CAElection' );
end;
/
begin
add_domain_values('taskEnrichmentClasses','HedgeRelationshipDefinition','HedgeRelationshipDefinition' );
end;
/
begin
add_domain_values('domainName','keyword.TradePlatform','List of Trade Platforms' );
end;
/
begin
add_domain_values('keyword.TradePlatform','Calypso','Default trade routing platform' );
end;
/
begin
add_domain_values('domainName','keyword.TradeRegion','List of Trade Regions' );
end;
/
begin
add_domain_values('keyword.TradeRegion','Global','Default trade region' );
end;
/
begin
add_domain_values('domainName','FXMirrorKeywords','List of Keywords to copy from original FX trade to mirror trade.' );
end;
/
begin
add_domain_values('FXMirrorKeywords','TradePlatform','' );
end;
/
begin
add_domain_values('FXMirrorKeywords','TradeRegion','' );
end;
/
begin
add_domain_values('domainName','keywords2CopyUponAllocate','List of Keywords to copy from original FX trade to trade created via SPLIT action.' );
end;
/
begin
add_domain_values('keywords2CopyUponAllocate','TradePlatform','' );
end;
/
begin
add_domain_values('keywords2CopyUponAllocate','TradeRegion','' );
end;
/
begin
add_domain_values('domainName','keywords2CopyUponSpotReserveSetVal','List of Keywords to copy from original FXSpotReserve trade to trade created via SETVAL action.' );
end;
/
begin
add_domain_values('keywords2CopyUponSpotReserveSetVal','TradePlatform','' );
end;
/
begin
add_domain_values('keywords2CopyUponSpotReserveSetVal','TradeRegion','' );
end;
/
begin
add_domain_values('function','ModifyPositionKeepingConfig','Access permission to update entries in PositionKeeping Config Editor' );
end;
/
begin
add_domain_values('domainName','bookAttribute.PositionKeepingBookType',null );
end;
/
begin
add_domain_values('bookAttribute.PositionKeepingBookType','SALES', null );
end;
/
begin
add_domain_values('bookAttribute.PositionKeepingBookType','TRADING',null );
end;
/
begin
add_domain_values('bookAttribute.PositionKeepingBookType','PROP',null );
end;
/
begin
add_domain_values('domainName','FXPositionMonitor.MarkRefTimes','Reference times for the PositionKeepingBlotter marks. Entries under this should be of type hhmm TimeZone, ex. 1659 America/New_York' );
end;
/
begin
add_domain_values('FXPositionMonitor.MarkRefTimes','1659 America/New_York',null );
end;
/
begin
add_domain_values('engineName','PositionKeepingPersistenceEngine','' );
end;
/
begin
add_domain_values('lifeCycleEntityType','CAElection','Corporate Action election has its own life cycle' );
end;
/
begin
add_domain_values('workflowType','CAElection','Corporate Action election follows its own workflow' );
end;
/
begin
add_domain_values('CAElectionStatus','NONE','' );
end;
/
begin
add_domain_values('CAElectionStatus','PENDING','' );
end;
/
begin
add_domain_values('CAElectionStatus','PARTIALLY_ELECTED','' );
end;
/
begin
add_domain_values('CAElectionStatus','CANCELED','' );
end;
/
begin
add_domain_values('CAElectionStatus','ELECTED','' );
end;
/
begin
add_domain_values('CAElectionStatus','VALIDATED','' );
end;
/
begin
add_domain_values('CAElectionStatus','LOCKED','Applicable election status' );
end;
/
begin
add_domain_values('domainName','CAElectionApplicableStatus','Identifies CAELection status for which CA Trade generation is applicable' );
end;
/
begin
add_domain_values('CAElectionApplicableStatus','VALIDATED','' );
end;
/
begin
add_domain_values('CAElectionApplicableStatus','LOCKED','' );
end;
/
begin
add_domain_values('domainName','CAElectionLockedStatus','Identifies CAELection final status for which automated update cannot be performed' );
end;
/
begin
add_domain_values('CAElectionLockedStatus','LOCKED','' );
end;
/
begin
add_domain_values('CAElectionAction','NEW','' );
end;
/
begin
add_domain_values('CAElectionAction','CANCEL','' );
end;
/
begin
add_domain_values('CAElectionAction','AMEND','User amendment' );
end;
/
begin
add_domain_values('CAElectionAction','AUTHORIZE','' );
end;
/
begin
add_domain_values('CAElectionAction','UPDATE','System automated amendment' );
end;
/
begin
add_domain_values('CAElectionAction','ELECT','action name for STP transition towards ELECTED status' );
end;
/
begin
add_domain_values('CAElectionAction','LOCK','' );
end;
/
begin
add_domain_values('workflowRuleCAElection','ApplySameAction','' );
end;
/
begin
add_domain_values('workflowRuleMessage','SetElectionMessageRef','' );
end;
/
begin
add_domain_values('workflowRuleMessage','CheckCAAgentDetails','' );
end;
/
begin
add_domain_values('workflowRuleMessage','MatchIncomingElection','' );
end;
/
begin
add_domain_values('workflowRuleMessage','CheckIncomingProcess','' );
end;
/
begin
add_domain_values('workflowRuleMessage','ReprocessIncoming','' );
end;
/
begin
add_domain_values('workflowRuleMessage','UnprocessCashSettlementConfirmation','' );
end;
/
begin
add_domain_values('SWIFT.Templates','MT565','' );
end;
/
begin
add_domain_values('domainName','CAElectionAttributes','' );
end;
/
begin
add_domain_values('CAElectionAttributes','MessageId','' );
end;
/
begin
add_domain_values('CAElectionAttributes','Instruction_Status','' );
end;
/
begin
add_domain_values('CAElectionAttributes','Instruction_Reason','' );
end;
/
begin
add_domain_values('MsgAttributes','Instruction_Reason','' );
end;
/
begin
add_domain_values('MsgAttributes','Instruction_Status','' );
end;
/
begin
add_domain_values('MsgAttributes','CA_Agent_Reference','' );
end;
/
begin
add_domain_values('MsgAttributes','CA Option','' );
end;
/
begin
add_domain_values('MsgAttributes','CA Option Number','' );
end;
/
begin
add_domain_values('MsgAttributes','Quantity','' );
end;
/
begin
add_domain_values('MsgAttributes','Balance','' );
end;
/
begin
add_domain_values('MsgAttributes','Process Issue','' );
end;
/
begin
add_domain_values('domainName','ElectionMatchingReason','' );
end;
/
begin
add_domain_values('ElectionMatchingReason','CAND//CANI','Instruction has been cancelled as per your request.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','CAND//CANO','Instruction has been cancelled by another party than the instructing party.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','CAND//CANS','Instruction has been cancelled by the system.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','CAND//CSUB','Instruction has been cancelled by the agent.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PACK//ADEA','Received after the account servicers deadline. Processed on best effort basis.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PACK//LATE','Instruction was received after market deadline.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PACK//NSTP','Instruction was not STP and had to be processed manually.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//ADEA','Received after the account servicers deadline.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//CANC','Option is not valid; it has been cancelled by the market or service provider, and cannot be responded to.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//CERT','Instruction is rejected since the provided certification is incorrect or incomplete.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//DQUA','Unrecognized or invalid instructed quantity.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//DSEC','Unrecognized or invalid financial instrument identification.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//EVNM','Unrecognized Corporate Action Event Number Rejection.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//LACK','Instructed position exceeds the eligible balance.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//LATE','Instruction received after market deadline.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//NMTY','Mismatch Option Number and Option Type Rejection.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//OPNM','Unrecognized option number.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//OPTY','Invalid option type.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//SAFE','Unrecognized or invalid message senders safekeeping account.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','REJT//ULNK','Unknown. Linked reference is unknown.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//ADEA','Account Servicer Deadline Missed.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//CERT','Instruction is rejected since the provided certification is incorrect or incomplete.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//DQUA','Disagreement on Quantity. Unrecognized or invalid instructed quantity.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//LACK','Lack of Securities. Insufficient financial instruments in your account.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//LATE','Market Deadline Missed.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//MCER','Missing or Invalid Certification. Awaiting receipt of adequate certification.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//MONY','Insufficient cash in your account.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//NPAY','Payment Not Made. Payment has not been made by issuer.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND//NSEC','Securities Not Delivered. Financial instruments have not been delivered by the issuer.' );
end;
/
begin
add_domain_values('ElectionMatchingReason','PEND/PENR','The instruction is pending receipt of securities, for example, from a purchase, loan etc.' );
end;
/
begin
add_domain_values('incomingType','MT567','INC_CA' );
end;
/
begin
add_domain_values('CA.keywords','CAElectionId','Applied election if any' );
end;
/
begin
add_domain_values('CA.keywords','CAElectionPosition','Applied election total position' );
end;
/
begin
add_domain_values('MESSAGE.Templates','caElectionInstruction.html','' );
end;
/
begin
add_domain_values('messageType','CA_ELECTION','Sent in case of CA Election' );
end;
/
begin
add_domain_values('classAuditMode','CAElection','' );
end;
/
begin
add_domain_values('classAuditMode','CAElectionInstruction','' );
end;
/
begin
add_domain_values('classAuditMode','CAElectionDeadlineRule','' );
end;
/
begin
add_domain_values('workflowRuleCAElection','CheckPartiallyElected','' );
end;
/
begin
add_domain_values('workflowRuleCAElection','CheckElected','' );
end;
/
begin
add_domain_values('workflowRuleCAElection','CheckBookEntitledObligatedDifference','' );
end;
/
begin
add_domain_values('domainName','workflowRuleCAElection','Workflow rule available for CAElection workflow' );
end;
/
begin
add_domain_values('genericObjectClass','CAElection','package com.calypso.tk.product.corporateaction' );
end;
/
begin
add_domain_values('genericObjectClass','CAElectionInstruction','package com.calypso.tk.product.corporateaction' );
end;
/
begin
add_domain_values('genericObjectClass','CAElectionDeadlineRule','package com.calypso.tk.product.corporateaction' );
end;
/
begin
add_domain_values('genericCommentType','Supporting Documentation',null );
end;
/
begin
add_domain_values('unavailabilityReason','Conditional CA Event','Conditional Corporate Action event such as Tender offer' );
end;
/
begin
add_domain_values('eventType','PENDING_CAELECTION','' );
end;
/
begin
add_domain_values('eventType','PARTIALLY_ELECTED_CAELECTION','' );
end;
/
begin
add_domain_values('eventType','CANCELED_CAELECTION','' );
end;
/
begin
add_domain_values('eventType','ELECTED_CAELECTION','' );
end;
/
begin
add_domain_values('eventType','LOCKED_CAELECTION','' );
end;
/
begin
add_domain_values('eventType','EX_CAELECTION','Exception  generated by the ScheduledTaskCA_ELECTION' );
end;
/
begin
add_domain_values('exceptionType','CAELECTION','' );
end;
/
begin
add_domain_values('scheduledTask','CA_ELECTION','' );
end;
/
begin
add_domain_values('function','AddCAElection','' );
end;
/
begin
add_domain_values('function','ModifyCAElection','' );
end;
/
begin
add_domain_values('function','RemoveCAElection','' );
end;
/
begin
add_domain_values('function','AddCAElectionInstruction','' );
end;
/
begin
add_domain_values('function','ModifyCAElectionInstruction','' );
end;
/
begin
add_domain_values('function','RemoveCAElectionInstruction','' );
end;
/
begin
add_domain_values('function','AddCAElectionDeadlineRule','' );
end;
/
begin
add_domain_values('function','ModifyCAElectionDeadlineRule','' );
end;
/
begin
add_domain_values('function','RemoveCAElectionDeadlineRule','' );
end;
/
begin
add_domain_values('function','ModifyTaskStationGlobalFilter','' );
end;
/
begin
add_domain_values('domainName','CAAuditReportField','' );
end;
/
begin
add_domain_values('eventType','EX_CA_ELECTION_INFORMATION','' );
end;
/
begin
add_domain_values('exceptionType','CA_ELECTION_INFORMATION','' );
end;
/
begin
add_domain_values('workflowRuleCAElection','PublishTaskIfChange','' );
end;
/
begin
add_domain_values('domainName','PublishTaskIfChangeCAElectionRule','' );
end;
/
begin
add_domain_values('systemKeyword','CASalesMarginGroup','System wide Keyword for capturing Cross-Asset Sales Margin Group Name' );
end;
/
begin
add_domain_values('tradeKeyword','CASalesMarginGroup','Trade Keyword for capturing Cross-Asset Sales Margin Group Name' );
end;
/
begin
add_domain_values('domainName','salesMarginGroup','Cross Asset Sales Margin Counterparty group' );
end;
/
begin
add_domain_values('domainName','salesMarginChannelType','Cross Asset Sales Margin Channel Type' );
end;
/
begin
add_domain_values('domainName','salesMarginConfigProducts','Supported Products for Cross Asset Sales Margin' );
end;
/

begin
add_domain_values('salesMarginConfigProducts','FXOption',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FX'  , null);
end;
/
begin
add_domain_values('salesMarginConfigProducts','FXCash',  null);
end;
/
begin
add_domain_values('salesMarginConfigProducts','FXForward',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FXNDF',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FXSwap',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','CapFloor',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','StructuredFlows',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FRA',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','Swap',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FutureBond', null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','Bond', null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FutureBond', null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FutureFX', null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FutureMM', null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FutureOptionFX', null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','FutureOptionMM', null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','Equity',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','EquityForward',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','EquityStructuredOption',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','CommodityOTCOption2' ,null);
end;
/
begin
add_domain_values('salesMarginConfigProducts','CommoditySwap2',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','CommodityForward',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','CreditDefaultSwap',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','CDSIndex',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','CDSIndexOption',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','CDSIndexTranche',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','AssetSwap',null );
end;
/
begin
add_domain_values('salesMarginConfigProducts','Swaption', null);
end;
/

begin
add_domain_values('systemKeyword','TaxLotLiquidationMethod','Tax lot liquidation method that a Trade is subject to.  Can be used in Liquidation Config Trade Filters' );
end;
/
begin
add_domain_values('tradeKeyword','TaxLotLiquidationMethod','Tax lot liquidation method that a Trade is subject to.  Can be used in Liquidation Config Trade Filters' );
end;
/
begin
add_domain_values('keyword.TaxLotLiquidationMethod','FIFO','' );
end;
/
begin
add_domain_values('keyword.TaxLotLiquidationMethod','MANUAL','' );
end;
/


DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from pricer_measure where measure_name='DV01' ;
	IF x = 0 THEN
	insert into pricer_measure (measure_name,measure_class_name,measure_id,measure_comment) values ('DV01','tk.core.PricerMeasure',408,'Yield Sensitivity - computed as the dollar value change due to a 1 bpts change in yield.');
	END IF;
end;
/


alter table alive_dataservers drop primary key
;
ALTER TABLE alive_dataservers DROP column registry_port
;
delete from task_enrichment_field_config where custom_class_name = 'com.calypso.tk.bo.DefaultTaskEnrichmentCustom' or field_db_name in ('xfer_is_dda', 'xfer_int_sdi_status', 'xfer_ext_sdi_status', 'xfer_event_type', 'trade_comment', 'trade_bundle_id', 'msg_version', 'msg_statement_id', 'msg_sender_role', 'msg_sender_address_code', 'msg_reset_date','msg_receiver_role', 'msg_receiver_address_code', 'msg_product_type', 'msg_event_type', 'msg_description', 'msg_creation_date', 'msg_address_method')
;
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (601,'UNKNOWN BENEFICIARY','UNKNOWN BENEFICIARY',0,0,'Fake Unknown Beneficiary used by Cash Manual Sdi','Enabled','FRANCE')
;
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (602,'UNKNOWN AGENT','UNKNOWN AGENT',0,1,'Fake Unknown Agent used by Cash Manual Sdi','Enabled','NONE')
;
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (603,'UNKNOWN INT1','UNKNOWN INTERMEDIARY1',0,1,'Fake Unknown Intermediary 1 used by Cash Manual Sdi','Enabled','NONE')
;
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (604,'UNKNOWN INT2','UNKNOWN INTERMEDIARY2',0,1,'Fake Unknown Intermediary 2 used by Cash Manual Sdi','Enabled','NONE')
;
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (605,'UNKNOWN REMITTER','UNKNOWN REMITTER',0,0,'Fake Unknown Remitter used by Cash Manual Sdi','Enabled','NONE')
;  
insert into legal_entity_role (legal_entity_id ,role_name) values (601,'CounterParty')
;
insert into legal_entity_role (legal_entity_id ,role_name) values (602,'Agent')
;
insert into legal_entity_role (legal_entity_id ,role_name) values (603,'Agent')
;
insert into legal_entity_role (legal_entity_id ,role_name) values (604,'Agent')
;
insert into legal_entity_role (legal_entity_id ,role_name) values (605,'Counterparty')
;
insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (501,601,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
;
insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (502,602,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
;

insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (503,603,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
;

insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (504,604,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
;
insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (505,605,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
;
/* end */
begin
add_domain_values ('Swap.subtype','Fixed Payment','');
end;
/
begin
add_domain_values ('PLPositionProduct.Pricer','PricerPLPositionProductBondWAC','PLPositionProduct Pricer');
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='NONE' and possible_action ='NEW' 
	and resulting_status = 'PENDING' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 
	and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 ;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, 
	msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (801,'HedgeRelationshipDefinition','NONE','NEW','PENDING',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (801,'Reprocess' );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' and possible_action ='DESIGNATE' 
	and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 
	and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
		INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
		VALUES (802,'HedgeRelationshipDefinition','PENDING','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='DE_DESIGNATE' 
	and resulting_status = 'INEFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 
	and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b )
	VALUES (803,'HedgeRelationshipDefinition','EFFECTIVE','DE_DESIGNATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='DESIGNATE' and resulting_status = 'EFFECTIVE' 
	and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b )
	VALUES (804,'HedgeRelationshipDefinition','INEFFECTIVE','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='CANCEL' and resulting_status = 'CANCELED' 
	and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 
	and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b )
	VALUES (805,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='CANCEL' and resulting_status = 'CANCELED' 
	and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 
	and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b )
	VALUES (806,'HedgeRelationshipDefinition','INEFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/


DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x  from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='TERMINATE' and resulting_status = 'INACTIVE' 
	and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b )
	VALUES (807,'HedgeRelationshipDefinition','INEFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (807,'Deactivation' );
	END IF;
end;
/ 

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='TERMINATE' 
	and resulting_status = 'INACTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 
	and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b )
	VALUES (808,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (808,'CheckEndDate' );
	END IF;
end;
/
  
DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INACTIVE' and possible_action ='TERMINATE' and resulting_status = 'TERMINATED' 
	and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b )
	VALUES (809,'HedgeRelationshipDefinition','INACTIVE','TERMINATE','TERMINATED',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (809,'CheckEndDate' );
	END IF;
end;
/
  
  
DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INACTIVE' 
	and possible_action ='REPROCESS' and resulting_status = 'INACTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (810,'HedgeRelationshipDefinition','INACTIVE','REPROCESS','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (810,'Reprocess' );
	END IF;
end;
/
  
DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' 
	and possible_action ='REPROCESS' and resulting_status = 'PENDING' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (811,'HedgeRelationshipDefinition','PENDING','REPROCESS','PENDING',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (811,'Reprocess' );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' 
	and possible_action ='UPDATE' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (812,'HedgeRelationshipDefinition','EFFECTIVE','UPDATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/


DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' 
	and possible_action ='UPDATE' and resulting_status = 'INEFFECTIVE' and use_stp_b = 0 and same_user_b = 1 
	and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 
	and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (813,'HedgeRelationshipDefinition','INEFFECTIVE','UPDATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' 
	and possible_action ='REPROCESS' and resulting_status = 'INEFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (814,'HedgeRelationshipDefinition','INEFFECTIVE','REPROCESS','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (814,'Reprocess' );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' 
	and possible_action ='REPROCESS' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (815,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (815,'Reprocess' );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' and possible_action ='CANCEL' 
	and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 
	and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (816,'HedgeRelationshipDefinition','PENDING','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' and possible_action ='UPDATE' 
	and resulting_status = 'PENDING' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 
	and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (817,'HedgeRelationshipDefinition','PENDING','UPDATE','PENDING',0,1,'ALL','ALL',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='NONE' and possible_action ='NEW' 
	and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'Non-Qualifying Hedge' 
	and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (820,'HedgeRelationshipDefinition','NONE','NEW','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (820,'Reprocess' );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' 
	and possible_action ='REPROCESS' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 
	and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (821,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 );
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (821,'ReprocessEconomic' );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' 
	and possible_action ='TERMINATE' and resulting_status = 'TERMINATED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 
	and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (822,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','TERMINATED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' 
	and possible_action ='CANCEL' and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 
	and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (823,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 );
	END IF;
end;
/

DECLARE
x number :=0 ;
begin
	SELECT count(*) INTO x from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='TERMINATED' 
	and possible_action ='CANCEL' and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' 
	and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 
	and gen_int_event_b =0;
	IF x = 0 THEN
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) 
	VALUES (824,'HedgeRelationshipDefinition','TERMINATED','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 );
	END IF;
end;
/

truncate table alive_dataservers
;

begin
add_column_if_not_exists ('pc_discount','collateral_curr','varchar2(32) null');
end;
/


UPDATE calypso_info
    SET major_version=14,
        minor_version=0,
        sub_version=0,
        patch_version='011',
        version_date=TO_DATE('15/08/2013','DD/MM/YYYY')
;
