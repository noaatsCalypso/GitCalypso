
add_column_if_not_exists 'trade_open_qty','toq_id','numeric default 0 not NULL'
go
add_column_if_not_exists 'trade_openqty_hist','toq_id','numeric default 0 not NULL'
go
add_column_if_not_exists 'trade_openqty_snap','toq_id','numeric default 0 not NULL'
go
add_column_if_not_exists 'trade_open_qty','liq_config_id','numeric DEFAULT 0 NOT NULL' 
go
add_column_if_not_exists 'trade_openqty_hist','liq_config_id','numeric DEFAULT 0 NOT NULL' 
go

if exists (select 1 from sysobjects where name='toq_temp')
begin
exec ('drop table toq_temp')
end
go

	
create table toq_temp (  
	book_id numeric NOT NULL,
	product_id numeric NOT NULL,
	liq_config_id numeric DEFAULT 0 NOT NULL,
	liq_agg_id numeric DEFAULT 0 NOT NULL,
	trade_id numeric NOT NULL,
	settle_date datetime NOT NULL,
	sign numeric NOT NULL,
	linked_id numeric NOT NULL)
go

add_column_if_not_exists 'trade_open_qty','linked_id','numeric default 0 NOT NULL' 
go 
add_column_if_not_exists 'trade_openqty_hist','linked_id','numeric default 0 NOT NULL' 
go
add_column_if_not_exists 'trade_openqty_snap','linked_id','numeric default 0 NOT NULL' 
go
alter table toq_temp add constraint pk_toq_temp1 primary key ( trade_id, product_id, book_id, settle_date, sign, liq_agg_id, liq_config_id, linked_id )
go

insert into toq_temp(book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id) 
select book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id 
from trade_openqty_hist
go

insert into toq_temp(book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id) 
select book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id 
from trade_openqty_snap
go

insert into toq_temp(book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id) 
select book_id, product_id, liq_config_id, liq_agg_id, trade_id, settle_date, sign, linked_id 
from trade_open_qty
go

alter table toq_temp add toq_id int identity 
go

update trade_open_qty set trade_open_qty.toq_id = (select toq_temp.toq_id from toq_temp where 
toq_temp.book_id = trade_open_qty.book_id and 
toq_temp.product_id = trade_open_qty.product_id and 
toq_temp.liq_config_id = trade_open_qty.liq_config_id and 
toq_temp.liq_agg_id = trade_open_qty.liq_agg_id and 
toq_temp.trade_id = trade_open_qty.trade_id and 
toq_temp.settle_date = trade_open_qty.settle_date and 
toq_temp.sign = trade_open_qty.sign and 
toq_temp.linked_id = trade_open_qty.linked_id
)
go

update trade_openqty_hist set trade_openqty_hist.toq_id = (select toq_temp.toq_id from toq_temp where 
toq_temp.book_id = trade_openqty_hist.book_id and 
toq_temp.product_id = trade_openqty_hist.product_id and 
toq_temp.liq_config_id = trade_openqty_hist.liq_config_id and 
toq_temp.liq_agg_id = trade_openqty_hist.liq_agg_id and 
toq_temp.trade_id = trade_openqty_hist.trade_id and 
toq_temp.settle_date = trade_openqty_hist.settle_date and 
toq_temp.sign = trade_openqty_hist.sign and 
toq_temp.linked_id = trade_openqty_hist.linked_id
)
go

update trade_openqty_snap set trade_openqty_snap.toq_id = (select toq_temp.toq_id from toq_temp where 
toq_temp.book_id = trade_openqty_snap.book_id and 
toq_temp.product_id = trade_openqty_snap.product_id and 
toq_temp.liq_config_id = trade_openqty_snap.liq_config_id and 
toq_temp.liq_agg_id = trade_openqty_snap.liq_agg_id and 
toq_temp.trade_id = trade_openqty_snap.trade_id and 
toq_temp.settle_date = trade_openqty_snap.settle_date and 
toq_temp.sign = trade_openqty_snap.sign and 
toq_temp.linked_id = trade_openqty_snap.linked_id
)
go

delete from calypso_seed where seed_name = 'TradeOpenQuantity'
go

insert into calypso_seed select coalesce(max(toq_id) + 1,100) , 'TradeOpenQuantity', 500 from toq_temp  
go

drop table toq_temp
go

if not exists (select 1 from sysobjects where name='sched_task_attr' and type='U')
begin
exec ( 'create table sched_task_attr (task_id numeric not null,
attr_name varchar(32) not null,
attr_value varchar(4000) null,
value_order numeric default 0 not null)')
end
go
insert into pricing_param_name (param_name,param_type,param_domain,param_comment,default_value,is_global_b) values ('NPV_EXCLUDE_PRINCIPAL','java.lang.Boolean','true,false','Used to decide whether to exclude PV of PRINCIPAL and PRINCIPAL_ADJ cashflows from the total NPV', 'false',1)
go
insert into sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Destination Quoteset',pe.quote_set_name from pricing_env pe,sched_task st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
go
insert into sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Source Quoteset',pe.quote_set_name from pricing_env pe,sched_task st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
go
if not exists (select 1 from sysobjects where name='quartz_sched_task_attr' and type='U')
begin
exec ( 'create table quartz_sched_task_attr (task_id numeric not null,
attr_name varchar(32) not null,
attr_value varchar(4000) null,
value_order numeric default 0 not null)')
end
go
if not exists (select 1 from sysobjects where name='quartz_sched_task' and type='U')
begin
exec ( 'CREATE TABLE quartz_sched_task (
         task_id numeric  NOT NULL,
         task_type varchar (255) NULL,
         trade_filter varchar (255) NULL,
         filter_set varchar (32) NULL,
         pricing_env varchar (32) NULL,
         pricer_measures varchar (2000) NULL,
         time_zone varchar (128) NULL,
         sched_time numeric  NULL,
         from_days numeric  NULL,
         to_days numeric  NULL,
         holidays varchar (128) NULL,
         user_name varchar (32) NULL,
         publish_b numeric  NOT NULL,
         execute_b numeric  NOT NULL,
         send_email_b numeric  NOT NULL,
         val_time numeric  NULL,
         undo_time numeric  NULL,
         next_id numeric  NULL,
         valdate_offset numeric  NULL,
         exec_hol numeric  NULL,
         po_id numeric  NULL,
         comments varchar (255) NULL,
         risk_cfg_name varchar (32) NULL,
         date_rule_id numeric  NULL,
         exec_ds_b numeric  NULL,
         description varchar (255) NULL,
         version_num numeric  NULL,
         entered_date datetime  NULL,
         read_only_srvr_b numeric  DEFAULT 0 NOT NULL,
         private_b numeric  DEFAULT 0 NOT NULL,
         is_deactivated numeric  DEFAULT 0 NOT NULL,
         skip_exec_b numeric  DEFAULT 0 NOT NULL,
         skip_cutoff_time numeric  DEFAULT -1 NOT NULL,
         external_ref varchar (255) NOT NULL )')
end
go

insert into quartz_sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Destination Quoteset',pe.quote_set_name from pricing_env pe,quartz_sched_task st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
go
insert into quartz_sched_task_attr (task_id,attr_name,attr_value) (select st.task_id,'Source Quoteset',pe.quote_set_name from pricing_env pe,quartz_sched_task st where st.pricing_env=pe.pricing_env_name and st.task_type ='PROP_RATE_1BUSDAY')
go
update an_param_items 
set attribute_value = 'Underlying Instruments' 
where class_name = 'com.calypso.tk.risk.SensitivityParam'  and attribute_name = 'VolatilityPerturbationType' and attribute_value='Underlyings Instruments'
go
	
update an_param_items 
set attribute_value = 'Underlying Instruments (ATM, RR and FLY)' 
where class_name = 'com.calypso.tk.risk.SensitivityParam'  and attribute_name = 'VolatilityPerturbationType' and attribute_value='Underlyings Instruments (ATM, RR and FLY)'
go
	
update an_param_items 
set attribute_value = 'Underlying Instruments (ATM, Vanilla Puts and Calls)' 
where class_name = 'com.calypso.tk.risk.SensitivityParam'  and attribute_name = 'VolatilityPerturbationType' and attribute_value='Underlyings Instruments (ATM, Vanilla Puts and Calls)'
go

add_column_if_not_exists 'swap_leg','infl_calc_type','numeric default -1 null'
go

add_column_if_not_exists 'swap_leg','infl_adjtarget','varchar(64) null'
go

add_column_if_not_exists 'swap_leg_hist','infl_calc_type','numeric default -1 null'
go

add_column_if_not_exists 'swap_leg_hist','infl_adjtarget','varchar(64) null'
go
update swap_leg set infl_adjtarget = null, infl_calc_type = -1 where rate_index IS NULL or (rate_index IS NOT NULL and substring(substring(rate_index,charindex('/',rate_index)+1,len(rate_index)),1,charindex('/',substring(rate_index,charindex('/',rate_index)+1,len(rate_index)))-1) 
not in (select rate_index_code from rate_index_default where index_type='Inflation')) 
go

update swap_leg set infl_adjtarget = 'Interest', infl_calc_type = 0 where rate_index IS NOT NULL 
and substring(substring(rate_index,charindex('/',rate_index)+1,len(rate_index)),1,charindex('/',substring(rate_index,charindex('/',rate_index)+1,len(rate_index)))-1) 
in (select rate_index_code from rate_index_default where index_type='Inflation') and infl_calc_type = -1
go

update swap_leg_hist set infl_adjtarget = null, infl_calc_type = -1 where rate_index IS NULL or (rate_index IS NOT NULL and substring(substring(rate_index,charindex('/',rate_index)+1,len(rate_index)),1,charindex('/',substring(rate_index,charindex('/',rate_index)+1,len(rate_index)))-1) 
not in (select rate_index_code from rate_index_default where index_type='Inflation')) 
go

update swap_leg_hist set infl_adjtarget = 'Interest', infl_calc_type = 0 where rate_index IS NOT NULL 
and substring(substring(rate_index,charindex('/',rate_index)+1,len(rate_index)),1,charindex('/',substring(rate_index,charindex('/',rate_index)+1,len(rate_index)))-1) 
in (select rate_index_code from rate_index_default where index_type='Inflation') and infl_calc_type = -1
go
DELETE from domain_values where name = 'commodity.ForwardPriceMethods' and value = 'Linear'
go
UPDATE commodity_reset SET fwd_prc_method = 'InterpolatedPrice' WHERE fwd_prc_method = 'Linear'
go
UPDATE vol_surf_param SET value = 'Interpolated' WHERE parameter_name = 'Default Time Axis Projection Method' AND value = 'Linear'
go
UPDATE vol_surf_param SET value = 'Interpolated' WHERE parameter_name = 'Default Time Axis Projection Method' AND value = 'InterpolatedPrice'
go
UPDATE vol_surf_param SET value = 'Use Commodity Reset' WHERE parameter_name = 'Default Time Axis Projection Method' AND value != 'Interpolated'
go
if exists (select 1 from sysobjects where name='product_eq_struct_option' and type='U')
begin
exec ('update product_eq_struct_option 
set notional_currency = (select trades.trade_currency from trade trades where trades.product_id = product_eq_struct_option.product_id and product_eq_struct_option.notional_currency IS NULL)
 WHERE EXISTS (select 1 from trade trades where trades.product_id = product_eq_struct_option.product_id and product_eq_struct_option.notional_currency IS NULL) ')
end
go
delete from vol_surf_und where quote_name is null
go
update date_rule set date_rule_rank=0, date_rule_weekday=0, month_list='', add_days=0, holidays='', check_holidays=0, date_roll='END_MONTH', add_months=0, add_bus_days_b=0 where date_rule_type=17
go
UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='002',
        version_date='20160701'
go 

