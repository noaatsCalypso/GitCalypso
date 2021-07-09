create sequence seq_id2 start with 1 increment by 1 maxvalue 99999999 minvalue 1 nocycle
;
begin
add_column_if_not_exists ('liq_info','liq_info_id','number');
end;
/
update liq_info set liq_info_id = seq_id2.nextval
;
 
begin
drop_pk_if_exists ('liq_info');
end;
/
alter table liq_info add constraint pk_liq_info primary key (liq_info_id)
;
drop sequence seq_id2
;

create sequence seq_id start with 1 increment by 1 maxvalue 9999999999 minvalue 1 nocycle
;
begin
add_column_if_not_exists ('trade_open_qty','toq_id','number default 0 NOT NULL');
add_column_if_not_exists ('trade_openqty_hist','toq_id','number default 0 NOT NULL');
add_column_if_not_exists ('trade_openqty_snap','toq_id','number default 0 NOT NULL');
end; 
/ 
declare
x number :=0 ;
begin
SELECT count (*) INTO x FROM user_tables WHERE table_name='TOQ_TEMP' ;
IF x=1 THEN
execute immediate 'drop table toq_temp';
END IF;
end;       
/
CREATE TABLE toq_temp (
	toq_id numeric default 0 NOT NULL,
	book_id numeric NOT NULL,
	product_id numeric NOT NULL,
	liq_config_id numeric DEFAULT 0 NOT NULL,
	liq_agg_id numeric DEFAULT 0 NOT NULL,
	trade_id numeric NOT NULL,
	settle_date timestamp NOT NULL,
	sign numeric NOT NULL,
	linked_id numeric NOT NULL)
;
ALTER TABLE toq_temp ADD CONSTRAINT pk_toq_temp1 PRIMARY KEY ( book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id )
/
begin
add_column_if_not_exists('trade_open_qty','linked_id','number default 0 NOT NULL');
add_column_if_not_exists('trade_openqty_hist','linked_id','number default 0 NOT NULL');
add_column_if_not_exists('trade_openqty_snap','linked_id','number default 0 NOT NULL');
end;
/

update trade_openqty_hist set trade_openqty_hist.toq_id = seq_id.nextval
;
update trade_open_qty set trade_open_qty.toq_id = seq_id.nextval
;

update (select trade_openqty_snap.toq_id old, trade_open_qty.toq_id new from trade_openqty_snap inner join trade_open_qty on
trade_open_qty.book_id = trade_openqty_snap.book_id and
trade_open_qty.product_id = trade_openqty_snap.product_id and
trade_open_qty.liq_config_id = trade_openqty_snap.liq_config_id and
trade_open_qty.liq_agg_id = trade_openqty_snap.liq_agg_id and
trade_open_qty.trade_id = trade_openqty_snap.trade_id and
trade_open_qty.settle_date = trade_openqty_snap.settle_date and
trade_open_qty.sign = trade_openqty_snap.sign and
trade_open_qty.linked_id = trade_openqty_snap.linked_id
) t set t.old = t.new
;

insert into toq_temp(book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id) 
select distinct book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id 
from trade_openqty_snap where toq_id is null or toq_id = 0
;

update toq_temp set toq_id = seq_id.nextval
;

update (select trade_openqty_snap.toq_id old, toq_temp.toq_id new from trade_openqty_snap inner join toq_temp on 
toq_temp.book_id = trade_openqty_snap.book_id and 
toq_temp.product_id = trade_openqty_snap.product_id and 
toq_temp.liq_config_id = trade_openqty_snap.liq_config_id and 
toq_temp.liq_agg_id = trade_openqty_snap.liq_agg_id and 
toq_temp.trade_id = trade_openqty_snap.trade_id and 
toq_temp.settle_date = trade_openqty_snap.settle_date and 
toq_temp.sign = trade_openqty_snap.sign and 
toq_temp.linked_id = trade_openqty_snap.linked_id
) t set t.old = t.new
;

delete calypso_seed where seed_name = 'TradeOpenQuantity'
;
insert into calypso_seed select seq_id.nextval + 100 , 'TradeOpenQuantity', 500 from dual  
;
drop table toq_temp
;
drop sequence seq_id
;


update an_param_items 
set attribute_value = 'Underlying Instruments' 
where class_name = 'com.calypso.tk.risk.SensitivityParam'  and attribute_name = 'VolatilityPerturbationType' and attribute_value='Underlyings Instruments'
;
	
update an_param_items 
set attribute_value = 'Underlying Instruments (ATM, RR and FLY)' 
where class_name = 'com.calypso.tk.risk.SensitivityParam'  and attribute_name = 'VolatilityPerturbationType' and attribute_value='Underlyings Instruments (ATM, RR and FLY)'
;
	
update an_param_items 
set attribute_value = 'Underlying Instruments (ATM, Vanilla Puts and Calls)' 
where class_name = 'com.calypso.tk.risk.SensitivityParam'  and attribute_name = 'VolatilityPerturbationType' and attribute_value='Underlyings Instruments (ATM, Vanilla Puts and Calls)'
;

insert into pricing_param_name (param_name,param_type,param_domain,param_comment,default_value,is_global_b) values ('NPV_EXCLUDE_PRINCIPAL','java.lang.Boolean','true,false','Used to decide whether to exclude PV of PRINCIPAL and PRINCIPAL_ADJ cashflows from the total NPV', 'false',1)
;
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('sched_task_attr') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table sched_task_attr (task_id number not null,
attr_name varchar2(32) not null,
attr_value varchar2(4000) null,
value_order number default 0 not null)';
END IF;
End ;
/
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('quartz_sched_task_attr') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table quartz_sched_task_attr (task_id number not null,
attr_name varchar2(32) not null,
attr_value varchar2(4000) null,
value_order number default 0 not null)';
END IF;
End ;
/
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('quartz_sched_task') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE quartz_sched_task (
         task_id numeric  NOT NULL,
         task_type varchar2 (255) NULL,
         trade_filter varchar2 (255) NULL,
         filter_set varchar2 (32) NULL,
         pricing_env varchar2 (32) NULL,
         pricer_measures varchar2 (2000) NULL,
         time_zone varchar2 (128) NULL,
         sched_time numeric  NULL,
         from_days numeric  NULL,
         to_days numeric  NULL,
         holidays varchar2 (128) NULL,
         user_name varchar2 (32) NULL,
         publish_b numeric  NOT NULL,
         execute_b numeric  NOT NULL,
         send_email_b numeric  NOT NULL,
         val_time numeric  NULL,
         undo_time numeric  NULL,
         next_id numeric  NULL,
         valdate_offset numeric  NULL,
         exec_hol numeric  NULL,
         po_id numeric  NULL,
         comments varchar2 (255) NULL,
         risk_cfg_name varchar2 (32) NULL,
         date_rule_id numeric  NULL,
         exec_ds_b numeric  NULL,
         description varchar2 (255) NULL,
         version_num numeric  NULL,
         entered_date timestamp  NULL,
         read_only_srvr_b numeric  DEFAULT 0 NOT NULL,
         private_b numeric  DEFAULT 0 NOT NULL,
         is_deactivated numeric  DEFAULT 0 NOT NULL,
         skip_exec_b numeric  DEFAULT 0 NOT NULL,
         skip_cutoff_time numeric  DEFAULT -1 NOT NULL,
         external_ref varchar2 (255) NOT NULL 
    )';
END IF;
End ;
/

insert into sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Destination Quoteset',pe.quote_set_name from pricing_env pe,sched_task st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
;
insert into sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Source Quoteset',pe.quote_set_name from pricing_env pe,sched_task st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
;
insert into quartz_sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Destination Quoteset',pe.quote_set_name from pricing_env pe,QUARTZ_SCHED_TASK st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
;
insert into quartz_sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Source Quoteset',pe.quote_set_name from pricing_env pe,QUARTZ_SCHED_TASK st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
;
begin
add_column_if_not_exists ('product_eq_struct_option','notional_currency','varchar2(3) null');
end;
/
begin
add_column_if_not_exists ('swap_leg','infl_calc_type','number null');
end;
/
begin
add_column_if_not_exists ('swap_leg','infl_adjtarget','varchar2 (64)  NULL');
end;
/
begin
add_column_if_not_exists ('swap_leg_hist','infl_adjtarget','varchar2 (64)  NULL');
end;
/
begin
add_column_if_not_exists ('swap_leg_hist','INFL_CALC_TYPE','number');
end;
/
update swap_leg set infl_adjtarget = null, infl_calc_type = -1 where rate_index IS NULL
or 
(rate_index IS NOT NULL and substr(rate_index,instr(rate_index,'/',1)+1,instr(rate_index ,'/',2)-1) not in
(select rate_index_code from rate_index_default where index_type='Inflation'))
;
update swap_leg set infl_adjtarget = 'Interest', infl_calc_type = 0 where rate_index IS NOT NULL
and substr(rate_index,instr(rate_index,'/',1)+1,instr(rate_index ,'/',2)-1) in
(select rate_index_code from rate_index_default where index_type='Inflation') and infl_calc_type = -1
;
update swap_leg_hist set infl_adjtarget = null, infl_calc_type = -1 where rate_index IS NULL
or 
(rate_index IS NOT NULL and substr(rate_index,instr(rate_index,'/',1)+1,instr(rate_index ,'/',2)-1) not in
(select rate_index_code from rate_index_default where index_type='Inflation'))
;
update swap_leg_hist set infl_adjtarget = 'Interest', infl_calc_type = 0 where rate_index IS NOT NULL
and substr(rate_index,instr(rate_index,'/',1)+1,instr(rate_index ,'/',2)-1) in
(select rate_index_code from rate_index_default where index_type='Inflation') and infl_calc_type = -1
;


update product_eq_struct_option eso 
set (notional_currency) = (select trades.trade_currency from trade trades where trades.product_id = eso.product_id and eso.notional_currency IS NULL) 
WHERE EXISTS (select 1 from trade trades where trades.product_id = eso.product_id and eso.notional_currency IS NULL)
;
/* is has been added the second time since the first script was using last_update_time instead of last_updated_time 
which would get dropped when sync columns is done using executesql */ 
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
add_column_if_not_exists ('pl_position','last_updated_time','timestamp(6)');
add_column_if_not_exists ('pl_position','last_batch_liq_time','timestamp(6)');
add_column_if_not_exists ('pl_position','next_liquidation_time','timestamp(6)');
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
/* end */
delete from vol_surf_und where quote_name is null
;
update date_rule set date_rule_rank=0, date_rule_weekday=0, month_list='', add_days=0, holidays='', check_holidays=0, date_roll='END_MONTH', add_months=0, add_bus_days_b=0 where date_rule_type=17
;
DELETE from domain_values where name = 'commodity.ForwardPriceMethods' and value = 'Linear'
;
UPDATE commodity_reset SET fwd_prc_method = 'InterpolatedPrice' WHERE fwd_prc_method = 'Linear'
;
UPDATE vol_surf_param SET value = 'Interpolated' WHERE parameter_name = 'Default Time Axis Projection Method' AND value = 'Linear'
;
UPDATE vol_surf_param SET value = 'Interpolated' WHERE parameter_name = 'Default Time Axis Projection Method' AND value = 'InterpolatedPrice'
;
UPDATE vol_surf_param SET value = 'Use Commodity Reset' WHERE parameter_name = 'Default Time Axis Projection Method' AND value != 'Interpolated'
;
UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='002',
        version_date=TO_DATE('01/07/2016','DD/MM/YYYY')
;
