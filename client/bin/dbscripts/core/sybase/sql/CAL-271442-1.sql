if not exists (select 1 from sysobjects where name = 'cu_basis_swap_dtls' and type = 'U')
begin 
exec ('create table cu_basis_swap_dtls ( cu_id numeric not null , 
										leg_id numeric not null , 
										stub varchar(32) null , 
										reset_timing varchar(18) null , 
										reset_avg_method varchar(18) null , 
										avg_sample_freq varchar(12) null , 
										sample_day numeric null , 
										interp_b numeric null )')
end
go

if not exists (select 1 from sysobjects where name = 'commodity_leg2' and type = 'U')
begin 
exec ('create table commodity_leg2 (leg_id numeric not null ,
									leg_type numeric not null ,
									strike_price float,
									strike_price_unit varchar(32),
									comm_reset_id numeric,
									spread float,
									fx_reset_id numeric,
									fx_calendar varchar(64),
									cashflow_locks numeric,
									cashflow_changed numeric,
									quantity float not null ,
									quantity_unit varchar(32) null ,
									per_period varchar(32),
									version numeric  null ,
									round_unit_conv_b numeric null ,
									lower_strike float,
									upper_strike float,
									averaging_policy varchar(64),
									avg_rounding_policy varchar(64),
									cust_fx_rnd_dig numeric not null ,
									payout_amount float not null ,
									payout_type_id numeric,
									security_comm_reset_id number,
									start_date datetime,
									end_date datetime,
									ctd_comm_id numeric,
									dst_id numeric,
									fixed_fx_rate float)')
end
go


if exists (select 1 from domain_values where value='Accretion_PnL_Base')
begin
delete from domain_values where value = 'Accretion_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Accrual_PnL_Base')
begin
delete from domain_values where value = 'Accrual_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Accrued_PnL_Base')
begin
DELETE FROM domain_values where value = 'Accrued_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Cash_PnL_Base')
begin
DELETE FROM domain_values where value = 'Cash_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Cost_Of_Carry_Base_PnL')
begin
DELETE FROM domain_values where value = 'Cost_Of_Carry_Base_PnL'
end
go
if exists (select 1 from domain_values where value='Paydown_PnL_Base')
begin
DELETE FROM domain_values where value = 'Paydown_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Realized_Interests_PnL_Base')
begin
DELETE FROM domain_values where value = 'Realized_Interests_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Realized_PnL_Base')
begin
DELETE FROM domain_values where value = 'Realized_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Sale_Realized_PnL_Base')
begin
DELETE FROM domain_values where value = 'Sale_Realized_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Settlement_Date_PnL_Base')
begin
DELETE FROM domain_values where value = 'Settlement_Date_PnL_Base'
end
go
if exists (select 1 from domain_values where value= 'Total_Accrual_PnL_Base')
begin
DELETE FROM domain_values where value = 'Total_Accrual_PnL_Base'
end
go
if exists (select 1 from domain_values where value= 'Unrealized_Cash_PnL_Base')
begin
DELETE FROM domain_values where value = 'Unrealized_Cash_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Unrealized_Fees_PnL_Base')
begin
DELETE FROM domain_values where value = 'Unrealized_Fees_PnL_Base'
end
go
if exists (select 1 from domain_values where value= 'Unrealized_Interests_Base')
begin
DELETE FROM domain_values where value = 'Unrealized_Interests_Base'
end
go
if exists (select 1 from domain_values where value='Unrealized_Net_PnL_Base')
begin
DELETE FROM domain_values where value = 'Unrealized_Net_PnL_Base'
end
go
if exists (select 1 from domain_values where value='Unrealized_PnL_Base')
begin
DELETE FROM domain_values where value = 'Unrealized_PnL_Base'
end
go

update 	cf_sch_gen_params
set		start_date = leg.start_date,
		end_date = leg.end_date 
from	commodity_leg2 leg,
		cf_sch_gen_params params
where	params.start_date is null
and		params.end_date is null
and 	params.param_type = 'COMMODITY'
and		params.leg_id = leg.leg_id
go

update  cf_sch_gen_params 
set     start_date = cash_params.start_date,
        end_date = cash_params.end_date 
from    cf_sch_gen_params       sec_params,
        cf_sch_gen_params       cash_params,
        prod_comm_fwd           fwd,
        commodity_leg2          leg
where   fwd.product_id = sec_params.product_id
and     fwd.comm_leg_id = sec_params.leg_id 
and     sec_params.param_type = 'SECURITY'
and     sec_params.start_date is null
and     sec_params.end_date is null
and     sec_params.leg_id = leg.leg_id
and     leg.leg_type not in (1, 3)
and     sec_params.product_id = cash_params.product_id
and     sec_params.leg_id = cash_params.leg_id
and     cash_params.param_type = 'COMMODITY'
and     cash_params.start_date is not null
and     cash_params.end_date is not null
go


/* cal-144876 - The following update is already in 130000 */

update /*+ parallel( user_viewer_prop ) */  user_viewer_prop set property_value='FXDetailed' where property_name like 'DealStationPersona_FX_%' and (property_value='FXSalesDetailed' or property_value='FXTraderDetailed')
go

insert into cf_sch_gen_params
(
	product_id, 
	payment_date_roll,
	leg_id,
	param_type,
	payment_offset_bus_b
)
select 	params.product_id,
	params.payment_date_roll,
	params.leg_id,
	'SECURITY',
	0
from   	product_commodity_swap2 opt,
	   cf_sch_gen_params params
where  	opt.pay_leg_id > 0
and	params.leg_id = opt.pay_leg_id
and	params.product_id = opt.product_id
and	params.param_type = 'COMMODITY'
and	not exists ( 	select 1
			from   	cf_sch_gen_params sec_params
			where  	sec_params.leg_id = opt.pay_leg_id
			and	sec_params.product_id = opt.product_id
			and	sec_params.param_type = 'SECURITY')
go

insert into cf_sch_gen_params
(
	product_id, 
	payment_date_roll,
	leg_id,
	param_type,
	payment_offset_bus_b
)
select 	params.product_id,
	params.payment_date_roll,
	params.leg_id,
	'SECURITY',
	0
from   	product_commodity_swap2 opt,
	   cf_sch_gen_params params
where  	opt.receive_leg_id > 0
and	params.leg_id = opt.receive_leg_id
and	params.product_id = opt.product_id
and	params.param_type = 'COMMODITY'
and	not exists ( 	select 1
			from   	cf_sch_gen_params sec_params
			where  	sec_params.leg_id = opt.receive_leg_id
			and	sec_params.product_id = opt.product_id
			and	sec_params.param_type = 'SECURITY')
go
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
from product_commodity_otcoption2 opt,
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
go

/* update bullet time */
update pmt_freq_details 
set attr_value='23'
where pmt_freq_type = 'BulletPaymentFrequency'
and attr_name = 'BulletHour'
and attr_value='0'
and product_id in(select opt.product_id
from product_commodity_otcoption2 opt,pmt_freq_details pfd
where opt.leg_id > 0
and pfd.leg_id = opt.leg_id
and pfd.product_id = opt.product_id)
go

/* update bullet time */
update pmt_freq_details 
set attr_value='59'
where pmt_freq_type = 'BulletPaymentFrequency'
and attr_name = 'BulletMinutes'
and attr_value='0'
and product_id in(select opt.product_id
from product_commodity_otcoption2 opt,pmt_freq_details pfd
where opt.leg_id > 0
and pfd.leg_id = opt.leg_id
and pfd.product_id = opt.product_id)
go

/* update leg */

add_column_if_not_exists 'inv_secposition','daily_loaned_auto','float'
go

add_column_if_not_exists 'commodity_leg2','ctd_comm_id','numeric null'
go
add_column_if_not_exists 'commodity_leg2','payout_type_id','numeric null'
go

update commodity_leg2 
set per_period='' ,
ctd_comm_id = -1 , 
payout_type_id = -1 , 
security_comm_reset_id = 0
where leg_id in (select opt.leg_id from product_commodity_otcoption2 opt, cf_sch_gen_params params, pmt_freq_details pfd
where opt.leg_id > 0
and params.leg_id = opt.leg_id
and params.product_id = opt.product_id
and pfd.leg_id = opt.leg_id
and pfd.product_id = opt.product_id
and pfd.pmt_freq_type = 'BulletPaymentFrequency')
go

/*
* update bullet time
*/
update pmt_freq_details 
set  attr_value='23' 
where  pmt_freq_type = 'BulletPaymentFrequency'
and  attr_name = 'BulletHour' 
and attr_value='0'
and product_id in(select opt.product_id
from      product_commodity_swap2 opt, pmt_freq_details pfd
where opt.receive_leg_id > 0
and        pfd.leg_id = opt.receive_leg_id
and        pfd.product_id = opt.product_id)
go

/*
* update bullet time
*/
update pmt_freq_details 
set  attr_value='59' 
where  pmt_freq_type = 'BulletPaymentFrequency'
and  attr_name = 'BulletMinutes' 
and attr_value='0'
and product_id in(select opt.product_id
from      product_commodity_swap2 opt, pmt_freq_details pfd
where opt.receive_leg_id > 0
and        pfd.leg_id = opt.receive_leg_id
and        pfd.product_id = opt.product_id)
go



update commodity_leg2 
set  strike_price_unit = (select R.quote_unit from commodity_reset R where R.comm_reset_id = commodity_leg2.comm_reset_id)
where commodity_leg2.leg_type = 1
and commodity_leg2.leg_id in (select DISTINCT params.leg_id from cf_sch_gen_params params, product_commodity_swap2 swap where commodity_leg2.leg_id = params.leg_id and swap.product_id = params.product_id)
go

if exists (select 1 from sysobjects where name='varbinaryToHex')
begin
drop function varbinaryToHex
end
go

create function varbinaryToHex(@password varbinary(255))
returns varchar(255)
as
declare @length int
declare @tmpInt int
declare @tmpVar varbinary(1)
declare @tmpRtn varchar(2)
declare @rtnVal varchar(255)
declare @currrentPos int

select @length = datalength(@password)
select @rtnVal = ''
select @currrentPos = 1

while @currrentPos <= @length
begin
select @tmpVar = substring(@password,@currrentPos,1)
select @currrentPos = @currrentPos + 1
select @tmpInt = convert(int, @tmpVar)
select @tmpRtn = substring(inttohex(@tmpInt),7,2)
select @rtnVal = @rtnVal + lower(@tmpRtn)
end
return @rtnVal
go

select * into user_name_bak14 from user_name
go


update user_name 
set user_name.hex_password = rtrim(ltrim(dbo.varbinaryToHex(convert(varbinary(255), user_password.user_password)))) 
from user_password, user_name 
where user_name.user_name = user_password.user_name
go


sp_rename user_password, user_password_bak
go

update eq_linked_leg set fx_res_lag_is_business_b = ret_reset_offset_b from performance_leg 
where eq_linked_leg.product_id = performance_leg.product_id and eq_linked_leg.leg_id = performance_leg.leg_id
go
update eq_linked_leg  set fx_res_lag_offset = ret_reset_offset 
from performance_leg where eq_linked_leg.product_id = performance_leg.product_id and eq_linked_leg.leg_id = performance_leg.leg_id
go
update eq_linked_leg set fx_res_lag_date_roll = ret_reset_dateroll 
from performance_leg where eq_linked_leg.product_id = performance_leg.product_id and eq_linked_leg.leg_id = performance_leg.leg_id
go
update eq_linked_leg  set fx_res_lag_holidays = ret_reset_holidays 
from performance_leg where eq_linked_leg.product_id = performance_leg.product_id and eq_linked_leg.leg_id = performance_leg.leg_id
go
if exists (select 1 from sysobjects where name='eq_linked_leg_hist')
begin 
exec ('alter table eq_linked_leg_hist add fx_res_lag_is_business_b numeric default 0 null')
exec ('alter table eq_linked_leg_hist add fx_res_lag_offset numeric default 0 null')
exec ('alter table eq_linked_leg_hist add fx_res_lag_date_roll VARCHAR(16) NULL')
exec ('ALTER TABLE eq_linked_leg_hist add fx_res_lag_holidays VARCHAR(128) NULL')
exec ('update eq_linked_leg_hist  set fx_res_lag_is_business_b =
(select ret_reset_offset_b from perf_leg_hist , eq_linked_leg_hist t where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)')
exec ('update eq_linked_leg_hist  set fx_res_lag_offset =
(select ret_reset_offset from perf_leg_hist ,eq_linked_leg_hist t where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)')
exec ('update eq_linked_leg_hist set fx_res_lag_date_roll =
(select ret_reset_dateroll from perf_leg_hist ,eq_linked_leg_hist t where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)')
exec ('update eq_linked_leg_hist set fx_res_lag_holidays =
(select ret_reset_holidays from perf_leg_hist ,eq_linked_leg_hist t where t.product_id = perf_leg_hist.product_id and t.leg_id = perf_leg_hist.leg_id)')
end
go



/* CAL-151390 */ 
/* update missing fwd start end dates */
 
update  cf_sch_gen_params
set     p.start_date = leg.start_date, 
        p.end_date = leg.end_date
from    cf_sch_gen_params       p,
        commodity_leg2          leg,
        product_desc            d
where   p.start_date is null
and     p.end_date is null
and     p.leg_id = leg.leg_id
and     p.product_id = d.product_id
and     d.product_type = 'CommodityForward'
go

/*  update fwd security calendar and fixing policy with that of the cash  */

update cf_sch_gen_params
set     p_sec.payment_calendar = p_cash.payment_calendar,
        p_sec.fixing_calendar = p_cash.fixing_calendar,
        p_sec.fixing_date_policy = p_cash.fixing_date_policy
from    cf_sch_gen_params       p_sec,
        cf_sch_gen_params       p_cash,
        product_desc            d
where   p_sec.product_id = p_cash.product_id
and     p_sec.leg_id = p_cash.leg_id
and     p_sec.param_type = 'SECURITY'
and     p_cash.param_type = 'COMMODITY'
and     p_sec.payment_calendar is null
and     p_sec.fixing_calendar is null        
and     p_sec.product_id = d.product_id
and     d.product_type = 'CommodityForward'
go

/* CAL-155875 ? FXNDF processing as Trades rather than Positions */

update pos_info set product_pos_b=0 where product_type IN ('FXNDF','FXNDFSwap','PositionFXNDF')
go
delete from domain_values where name ='PositionBasedProducts' and value IN ('FXNDF','FXNDFSwap','PositionFXNDF')
go
 
 /* CAL-158607 */
update settle_position set date_type = 'Trade Date' where date_type='TRADE'
go
update settle_position set date_type = 'Settle Date' where date_type='SETTLE'
go
/* end */

/* CAL-157793 */
delete from liq_position where is_deleted = 1
go
/* end */

/* CAL-157793 */
delete from liq_position where is_deleted = 1
go
/* end */

/* CAL-153882 */
/* currently, we don't bother about bo_task_hist */
if not exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'bo_task'
        and syscolumns.name = 'po_id' )
begin
    alter table bo_task add po_id numeric NULL
 	exec ('update bo_task set po_id = (select legal_entity_id from book where book.book_id = bo_task.book_id) where bo_task.book_id != 0 and bo_task.po_id is null')
end
go
/* end */

/* CAL-158718 adding boolean to control settlement holidays*/
add_column_if_not_exists 'swap_leg','settle_holidays_b','numeric null'
go

update swap_leg set settle_holidays_b=1 where settle_holidays is not NULL and settle_holidays != coupon_holidays
go



alter table generic_comment modify document_type varchar(128) null
go
alter table generic_comment_hist modify document_type varchar(128) null
go
delete from domain_values where name='applicationName' and value='EventServer' and description=''
go

update user_viewer_column set column_name='Accounting Link' where uv_usage = 'BOOK_WINDOW_COL' and column_name='Accounting Book'
go


DELETE FROM pricer_measure WHERE measure_name = 'HISTO_POS_CASH'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_CUMUL_CASH'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_UNSETTLED_CASH'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_REALIZED'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_CUMUL_CASH_FEES'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_BS'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_ACCRUAL_BO'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_REALIZED_ACCRUAL'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_TOTAL_PAYDOWN'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_TOTAL_PAYDOWN_BOOK_VALUE'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_CUMUL_CASH_INTEREST'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_TOTAL_INTEREST'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_UNSETTLED_FEES'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_UNREALIZED_CASH'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_SETTLED_REALIZED'
go

add_column_if_not_exists 'pl_mark_value' , 'original_currency', 'varchar(3) null'
go
add_column_if_not_exists 'pl_mark_value' , 'is_derived', 'numeric null' 
go

if not exists (select 1 from sysobjects where type='U' and name='pl_archive_trade')
begin
exec ('create table pl_archive_trade (trade_id numeric not null , currency varchar(3) not null , archive_date datetime not null , 
book_id numeric not null , liq_agg_id numeric not null , entered_datetime datetime not null , 
update_datetime datetime, version_num numeric not null , entered_user varchar(32) not null )  ')
end
go

update pl_mark_value set original_currency= currency 
go


if exists (select 1 from sysobjects where name='cws_document')
begin
if exists (select 1 from sysobjects where name='user_configs')
begin
 declare @x int, @cws_doc datetime , @usr_cfg datetime
 exec ('select @cws_doc = max(cws_document.last_modified) from cws_document')
 exec ('select @usr_cfg = max(user_configs.last_modified) from user_configs')
 exec ('select @x=count(*) from user_configs')
 exec ('select @x,@cws_doc ,@usr_cfg')
 if (@cws_doc > @usr_cfg) or  @x = 0 
   begin
   exec ('drop table user_configs')
   exec ('select * into user_configs from cws_document')
   end
end
 else
begin
   exec ('select * into user_configs from cws_document')
end
end
go


update bo_audit set entity_field_name = 'Product.__specificResets', old_value = null, new_value = null where entity_field_name = 'Product.__specificResets (count)' and entity_class_name = 'Trade'
go


update bo_audit set entity_field_name = 'Product.__excludedFixings', old_value = null, new_value = null where entity_field_name = 'Product.__excludedFixings (count)' and entity_class_name = 'Trade'
go


add_column_if_not_exists 'pc_discount' , 'collateral_curr', 'varchar(4) null'
go

if exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'pc_discount' and syscolumns.name = 'collateral_curr')
begin
	exec ('alter table pc_discount modify collateral_curr varchar(4) not null')
end
go

update pc_discount set collateral_curr='NONE' where collateral_curr='ANY' or collateral_curr is null
go

INSERT INTO group_access( group_name, access_id, access_value, read_only_b ) 
SELECT DISTINCT ga.group_name, 1, 'AdmLoginAttempts', 0 
FROM group_access ga WHERE ga.access_id = 1 and (ga.access_value = 'AdmDeleteLoginAttempts' or ga.access_value = 'AdmPurgeLoginAttempts')
go
DELETE FROM group_access WHERE access_id=1 AND (access_value='AdmDeleteLoginAttempts' OR access_value = 'AdmPurgeLoginAttempts')
go
INSERT INTO group_access( group_name, access_id, access_value, read_only_b )
SELECT DISTINCT ga.group_name, 1, 'AdmServer', 0
FROM group_access ga
WHERE ga.group_name NOT IN (SELECT ga.group_name FROM group_access ga WHERE ga.access_id =1 AND ga.access_value='AdmServer') AND ga.access_id = 1
AND ga.access_value IN ('AdmChangeDSLogOptions','AdmClearCache','AdmDSListActiveDataServer','AdmDSShowConnectedClient',
'AdmDSShowTaskStatistics','AdmShowDSOptions','AdmShowProfiler','AdmShowSQLMonitoring','AdmStartStopEngines',
'AdmUpdateTrace','AuthorizeDisconnectClients','RunAdminMonitor')
go
DELETE FROM group_access WHERE access_id=1
AND access_value IN ('AdmChangeDSLogOptions','AdmClearCache','AdmDSListActiveDataServer','AdmDSShowConnectedClient',
'AdmDSShowTaskStatistics','AdmShowDSOptions','AdmShowProfiler','AdmShowSQLMonitoring','AdmStartStopEngines',
'AdmUpdateTrace','AuthorizeDisconnectClients','RunAdminMonitor','AdmPurgeDBConnection','AdmPurgeLiquidatedPosition','AdmPurgeLogFiles',
'AdmUnCacheBook_Filter','AdmUpdateDSOptions')
go
DELETE FROM domain_values where name='function' and value IN ('AdmChangeDSLogOptions','AdmClearCache','AdmDSListActiveDataServer','AdmDSShowConnectedClient',
'AdmDSShowTaskStatistics','AdmShowDSOptions','AdmShowProfiler','AdmShowSQLMonitoring','AdmStartStopEngines',
'AdmUpdateTrace','AuthorizeDisconnectClients','RunAdminMonitor','AdmPurgeDBConnection','AdmPurgeLiquidatedPosition','AdmPurgeLogFiles',
'AdmUnCacheBook_Filter','AdmUpdateDSOptions','AdmDeleteLoginAttempts','AdmPurgeLoginAttempts')
go
DELETE FROM group_access WHERE access_id=1 AND (access_value='AdmDeleteLoginAttempts' OR access_value = 'AdmPurgeLoginAttempts')
go

sp_rename "lifecycle_event.execution_date", event_datetime
go
delete from domain_values where name = 'riskAnalysis' and value = 'VegaByStrike'
go
delete from an_viewer_config where analysis_name = 'VegaByStrike' 
go
/* Scheduled task main entry changes */

select * into main_entry_prop_bak14 from main_entry_prop
go

if exists (Select 1 from sysobjects where name ='mainent_schd_new' and type='P')
begin
exec ('drop proc mainent_schd_new')
end
go

create  procedure mainent_schd_new as 
begin
declare
  c1 cursor for 
  select property_name, user_name,substring(property_name,1,charindex('Action',property_name)-1),
  property_value from main_entry_prop where property_value = 'refdata.ScheduledTaskTreeFrame' 
 
OPEN c1
declare   @prefix_code varchar(16)
declare   @prop_value varchar(256)
declare   @user_name varchar(255)
declare   @property_name varchar(255)

fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

WHILE (@@sqlstatus = 0)

begin

    select @prefix_code = substring(@property_name,1,charindex('Action',@property_name)-1) from main_entry_prop 
	where @prop_value = 'refdata.ScheduledTaskTreeFrame'

   update main_entry_prop set property_value='scheduling.ScheduledTaskListWindow' where property_name like   
	@prefix_code+'%' and user_name =@user_name and property_name like @prefix_code+'Action'
    
fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

end
close c1
deallocate cursor c1
end
go
exec mainent_schd_new
go
drop procedure mainent_schd_new
go
if exists (Select 1 from sysobjects where name ='mainent_schd_l' and type='P')
begin
exec ('drop proc mainent_schd_l')
end
go

create  procedure mainent_schd_l as 
begin
declare
  c1 cursor for 
	 select property_name, user_name,substring(property_name,1,charindex('Action',property_name)-1),
  property_value from main_entry_prop where property_value = 'scheduling.ScheduledTaskListWindow' 
 OPEN c1
declare   @prefix_code varchar(16)
declare   @prop_value varchar(256)
declare   @user_name varchar(255)
declare   @property_name varchar(255)

fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

WHILE (@@sqlstatus = 0)

begin

    select @prefix_code = substring(@property_name,1,charindex('Action',@property_name)-1) from main_entry_prop 
	where @prop_value = 'scheduling.ScheduledTaskListWindow' 
	 update main_entry_prop set property_value='ScheduledTask(New)' where property_name like   
	@prefix_code+'Label' and user_name =@user_name 
    
fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

end
close c1
deallocate cursor c1
end
go
exec mainent_schd_l
go
drop procedure mainent_schd_l
go



if exists (Select 1 from sysobjects where name ='mainent_schd_o' and type='P')
begin
exec ('drop proc mainent_schd_o')
end
go

create  procedure mainent_schd_o as 
begin
declare
  c1 cursor for 
	 select property_name, user_name,substring(property_name,1,charindex('Action',property_name)-1),
  property_value from main_entry_prop where property_value =  'refdata.ScheduledTaskWindow' 
 OPEN c1
declare   @prefix_code varchar(16)
declare   @prop_value varchar(256)
declare   @user_name varchar(255)
declare   @property_name varchar(255)

fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

WHILE (@@sqlstatus = 0)

begin

    select @prefix_code = substring(@property_name,1,charindex('Action',@property_name)-1) from main_entry_prop 
	where @prop_value = 'refdata.ScheduledTaskWindow' 
	 update main_entry_prop set property_value='ScheduledTask(Depricated)' where property_name like   
	@prefix_code+'Label' and user_name =@user_name 
    
fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

end
close c1
deallocate cursor c1
end
go
exec mainent_schd_o
go
drop procedure mainent_schd_o
go
/*end*/

/* Scheduling Engine Changes End */

update risk_presenter_item set trade_freq = -1 where trade_freq = 0
go

update risk_presenter_item set quote_freq = -1 where quote_freq = 0
go

update risk_presenter_item set market_data_freq= -1 where market_data_freq = 0
go

update risk_on_demand_item set trade_freq = -1 where trade_freq = 0
go

update risk_on_demand_item set quote_freq = -1 where quote_freq = 0
go

update risk_on_demand_item set market_data_freq= -1 where market_data_freq = 0
go

 

drop_pk_if_exists 'alive_dataservers'
go

ALTER TABLE alive_dataservers DROP registry_port
go

/*Diff as of the Revision # 247861 */

INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (818,'CheckEndDate' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (826,'EndShortcut' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (607,'CheckPartiallyElected' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (608,'CheckElected' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (609,'CheckBookEntitledObligatedDifference' )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'UserConfigDocuments',500 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'LifeCycleProcessorRule',500 )
go
begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='PositionKeepingPersistenceEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'PositionKeepingPersistenceEngine','Position Keeping Persistence Engine' )
end
end
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2252387,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Fixed_Rate,Payment_Date,Period_Rate,Record_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2360385,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Payment_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2449758,'CASwiftEventCode','CAMatch.MT564','List','Amort_Rate,Ex_Date,Payment_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2455926,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Payment_Date,Record_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464289,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,New_Pool_Factor,Payment_Date,Previous_Pool_Factor,Record_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2511356,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Payment_Date,Redemption_Price' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2252387,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Fixed_Rate,Payment_Date,Period_Rate,Record_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2360385,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Payment_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2449758,'CASwiftEventCode','CAMatch.MT566','List','Amort_Rate,Ex_Date,Payment_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2455926,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Payment_Date,Record_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464289,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,New_Pool_Factor,Payment_Date,Previous_Pool_Factor,Record_Date' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2511356,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Payment_Date,Redemption_Price' )
go
INSERT INTO fee_definition ( fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, is_allocated, fee_code ) VALUES ('CA_SALES_MARGIN','cross asset sales margin',0,0,'ProcessingOrg',0,0,1,28 )
go
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','AllowCashSecurityMixDiffCcy' )
go
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','EventTypeAction' )
go
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','InternalLegalEntity' )
go
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','InternalRole' )
go
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','ValueDate' )
go
INSERT INTO netting_config ( netting_type, netting_key ) VALUES ('SecLendingFeeCashPoolDAP','XferCollId' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('HORIZON_TENOR','com.calypso.tk.core.Tenor','','Horizon tenor',1,'1D' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('MC_BLACK_VOLATILITY','java.lang.String','FAST,EXACT','Flag controls whether volatility lookup is optimized for Monte-Carlo Black pricers.',0,'FAST' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('BASIS_ADJ_METHOD','java.lang.String','PV Mult,PV Add,Dur Wtd Mult,Dur Wtd Add','Credit index basis adjustment method.',1,'BASIS_ADJ_METHOD','null' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('USE_PEDERSEN_MODEL','java.lang.Boolean','true,false','Credit Index Option Valuation method',1,'USE_PEDERSEN_MODEL','false' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventProcessMessage','SenderEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTrade','LifeCycleEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTransfer','LifeCycleEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeDesignationRecord','RelationshipManagerEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeDesignationRecord','AccountingEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Front-Office','PSEventTrade','PositionKeepingPersistenceEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTrade','PositionKeepingPersistenceEngine' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','LiquidationEngine','LiquidationEngineEventFilter' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','PositionKeepingPersistenceEngine','PositionKeepingServerTradeEventFilter' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Front-Office','PositionKeepingPersistenceEngine','PositionKeepingServerTradeEventFilter' )
go
DELETE referring_object WHERE rfg_obj_id=603
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (603,1,'task_priority','id','1','sd_filter','TaskPriority','apps.refdata.TaskPriorityWindow','Task Priority Configuration Setup' )
go
INSERT INTO report_panel_def ( win_def_id, panel_index, report_type, panel_name ) VALUES (134,0,'CAReconciliationCash','Cash' )
go
INSERT INTO report_panel_def ( win_def_id, panel_index, report_type, panel_name ) VALUES (134,1,'CAReconciliationSecurity','Security' )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (134,'CAReconciliation',0,0,1 )
go


add_column_if_not_exists 'wfw_transition','priority', 'numeric default 0 not null'
go

INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (656,'LifeCycleEvent','PENDING','TERMINATE','TERMINATED',0,1,'ALL',0,0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (657,'LifeCycleEvent','CANCELLING','TERMINATE','TERMINATED',0,1,'ALL',0,0,0,0,0 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b,priority ) VALUES (818,'HedgeRelationshipDefinition','INEFFECTIVE','TERMINATE','TERMINATED',0,1,'ALL','ALL',0,0,0,0,0 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b,priority ) VALUES (819,'HedgeRelationshipDefinition','INACTIVE','UPDATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (825,'HedgeRelationshipDefinition','PENDING','MIGRATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b,priority ) VALUES (826,'HedgeRelationshipDefinition','EFFECTIVE','END_SHORTCUT','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (600,'CAElection','NONE','NEW','PENDING',0,1,'ALL',0,0,1,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, prefered_b ,priority) VALUES (602,'CAElection','PARTIALLY_ELECTED','ELECT','PENDING',0,1,'ALL',0,0,1,0,0,1 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, prefered_b,priority ) VALUES (603,'CAElection','ELECTED','ELECT','PENDING',0,1,'ALL',0,0,1,0,0,1 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (604,'CAElection','ELECTED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (605,'CAElection','PENDING','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (606,'CAElection','PARTIALLY_ELECTED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (607,'CAElection','PENDING','ELECT','PARTIALLY_ELECTED',1,1,'ALL',0,0,1,0,0 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (608,'CAElection','PARTIALLY_ELECTED','ELECT','ELECTED',1,1,'ALL',0,0,1,0,0 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (609,'CAElection','ELECTED','AUTHORIZE','VALIDATED',1,1,'ALL',0,0,1,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (610,'CAElection','LOCKED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (611,'CAElection','LOCKED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b,priority ) VALUES (612,'CAElection','ELECTED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (613,'CAElection','PARTIALLY_ELECTED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (614,'CAElection','PENDING','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (615,'CAElection','VALIDATED','UPDATE','PENDING',0,1,'ALL',0,0,1,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, priority ) VALUES (616,'CAElection','VALIDATED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0,5 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b, prefered_b ,priority) VALUES (617,'CAElection','VALIDATED','ELECT','PENDING',0,1,'ALL',0,0,1,0,0,1 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ,priority) VALUES (618,'CAElection','VALIDATED','LOCK','LOCKED',0,1,'ALL',0,0,1,0,0 ,0)
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b,priority ) VALUES (619,'CAElection','PENDING','ELECT','PENDING',0,1,'ALL',0,0,1,0,0,0 )
go
DELETE sql_blacklist_properties WHERE value LIKE 'com.calypso.apps.taskstation.dialog.reportplan%'
go
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.taskstation.dialog.reportplan.ReportPlanDialog' )
go
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.ui.distribution.DistributionProgressDialog' )
go
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.taskstation.dialog.reportplan.ConditionalColorPage')
go
add_domain_values 'expressProductTypes','FutureMM','FutureMM'
go
add_domain_values 'LocaleForBondQuotes','English','Locale for Bond quotes'
go
add_domain_values 'domainName','AdvanceStandardSingleSwapLegTemplateName','specify the SingleSwapLeg trade template name to be used by hypersurface advance generator'
go
add_domain_values 'workflowRuleMessage','CheckCutOffTimeSdi',''
go
add_domain_values 'workflowRuleMessage','CheckCutOffTimeSdiLate',''
go
add_domain_values 'workflowRuleTrade','UndoLastReset',''
go
add_domain_values 'function','CreateCommodityUnitconversion','Access permission to create Commodity Unit conversion'
go
add_domain_values 'function','ModifyCommodityUnitconversion','Access permission to Modify Commodity Unit conversion'
go
add_domain_values 'function','RemoveCommodityUnitconversion','Access permission to Remove Commodity Unit conversion'
go
add_domain_values 'function','AddModifyTradeEntryDefaultConfig','Access permission to Add or Modify a trade entry default configuration'
go
add_domain_values 'sdiAttribute','CutOffTime',''
go
add_domain_values 'MsgAttributes.ConfType','PartFixing','PartFixing Confirmation'
go
add_domain_values 'MsgAttributes','IsQuanto','3rd Settlement Currency'
go
add_domain_values 'domainName','MsgAttributes.IsQuanto','3rd Settlement Ccy (TRUE, FALSE)'
go
add_domain_values 'MsgAttributes.IsQuanto','TRUE','3rd Settlement Currency'
go
add_domain_values 'MsgAttributes.IsQuanto','FALSE','Not 3rd Settlement Currency'
go
add_domain_values 'CountryAttributes','CountryAddressFormat','Define Country address format template for messaging purpose'
go
add_domain_values 'CountryAttributesReadOnly','CountryAddressFormat','Define Country address format template for messaging purpose'
go
add_domain_values 'classAuditMode','Country',''
go
add_domain_values 'function','AddBookSubstitutionRequest','Access permission to Add Book Substitution Requests'
go
add_domain_values 'function','ModifyBookSubstitutionRequest','Access permission to Modify Book Substitution Requests'
go
add_domain_values 'function','RemoveBookSubstitutionRequest','Access permission to Remove Book Substitution Requests'
go
add_domain_values 'domainName','bulkTerminationProductType','Termination Action Product Types'
go
add_domain_values 'bulkTerminationProductType','Cash',''
go
add_domain_values 'bulkTerminationProductType','CallNotice',''
go
add_domain_values 'bulkTerminationProductType','CapFloor',''
go
add_domain_values 'bulkTerminationProductType','CDSIndex',''
go
add_domain_values 'bulkTerminationProductType','CDSIndexTranche',''
go
add_domain_values 'bulkTerminationProductType','CDSNthDefault',''
go
add_domain_values 'bulkTerminationProductType','CDSNthLoss',''
go
add_domain_values 'bulkTerminationProductType','CreditDefaultSwap',''
go
add_domain_values 'bulkTerminationProductType','CreditDefaultSwapABS',''
go
add_domain_values 'bulkTerminationProductType','EquityLinkedSwap',''
go
add_domain_values 'bulkTerminationProductType','FRA',''
go
add_domain_values 'bulkTerminationProductType','FXOption',''
go
add_domain_values 'bulkTerminationProductType','FXSwap',''
go
add_domain_values 'bulkTerminationProductType','DBVRepo',''
go
add_domain_values 'bulkTerminationProductType','GCFRepo',''
go
add_domain_values 'bulkTerminationProductType','JGBRepo',''
go
add_domain_values 'bulkTerminationProductType','Pledge',''
go
add_domain_values 'bulkTerminationProductType','Repo',''
go
add_domain_values 'bulkTerminationProductType','SecurityLending',''
go
add_domain_values 'bulkTerminationProductType','SecLending',''
go
add_domain_values 'bulkTerminationProductType','SecurityVersusCash',''
go
add_domain_values 'bulkTerminationProductType','SimpleMM',''
go
add_domain_values 'bulkTerminationProductType','SimpleRepo',''
go
add_domain_values 'bulkTerminationProductType','Swap',''
go
add_domain_values 'bulkTerminationProductType','SwapCrossCurrency',''
go
add_domain_values 'bulkTerminationProductType','UnavailabilityTransfer',''
go
add_domain_values 'bulkTerminationProductType','XCCySwap',''
go
add_domain_values 'MultiMDIGenerators','TripleGlobal','Generate three curves together.'
go
add_domain_values 'CurveZero.gen','DoubleGlobal','Generate two curves together. Requires multiple curve window.'
go
add_domain_values 'CurveZero.gen','TripleGlobal','Generate three curves together. Requires multiple curve window.'
go
add_domain_values 'CorrelationSurface.gen','BaseCorrelationTopDown',''
go
add_domain_values 'correlationType','ADR',''
go
add_domain_values 'domainName','FXForwardStart.subtype','Types of FXForwardStart'
go
add_domain_values 'domainName','FXForwardStart.underlyingType','Underlying product types for FXForwardStart'
go
add_domain_values 'domainName','SecLending.tradeCaptureSubTypes','Types of SecLending sub types available for new trade capture'
go
add_domain_values 'MarketMeasureCalculators','BreakEvenCOF',''
go
add_domain_values 'MarketMeasureTrigger','IsAmortizing',''
go
add_domain_values 'classAuditMode','BookSubstitutionRequest',''
go
add_domain_values 'StructuredFlows.subtype','Revolving','Subtype to define revolving loans'
go
add_domain_values 'classAuthMode','TradeEntryDefaultConfig',''
go
add_domain_values 'classAuditMode','TradeEntryDefaultConfig',''
go
add_domain_values 'classAuditMode','CreditEvent',''
go
add_domain_values 'PositionBasedProducts','BondDanishMortgage',''
go
add_domain_values 'rateIndexAttributes','USE_INDEX_FREQUENCY',''
go
add_domain_values 'SpotDateCalculator','LiborRateIndexSpotDateCalculator',''
go
add_domain_values 'ExternalMessageField.MessageMapper','MT564',''
go
add_domain_values 'ExternalMessageField.MessageMapper','MT566',''
go
add_domain_values 'domainName','MT370CodeTag22F',''
go
add_domain_values 'MT370CodeTag22F','FOEX','FX,FXSwap,FXForward'
go
add_domain_values 'MT370CodeTag22F','MMKT','SimpleMM,Cash'
go
add_domain_values 'MT370CodeTag22F','NDLF','FXNDF,FXNDFSwap'
go
add_domain_values 'MT370CodeTag22F','OPTI','FXOption,Swaption'
go
add_domain_values 'FXForwardStart.keywords','XCcySplitRates',''
go
add_domain_values 'FXForwardStart.keywords','XccySptMismatchRates',''
go
add_domain_values 'domainName','ParRatesCurveGeneratorChoice',''
go
add_domain_values 'ParRatesCurveGeneratorChoice','BootStrap',''
go
add_domain_values 'ParRatesCurveGeneratorChoice','Global',''
go
add_domain_values 'domainName','ParRatesCurveInterpolatorChoice',''
go
add_domain_values 'ParRatesCurveInterpolatorChoice','InterpolatorLogLinear',''
go
add_domain_values 'ParRatesCurveInterpolatorChoice','InterpolatorLinear',''
go
add_domain_values 'workflowRuleTrade','AppendReportingCurrencyData','Adds Reporting Currency Data to the trades'
go
add_domain_values 'workflowRuleTrade','FXSpotReserveSETVAL','Performs SETVALDT action on FXSpotReserve swap trades'
go
add_domain_values 'userAttributes','FXForwardStart Default Reset Tenor',''
go
add_domain_values 'userAttributes','FX Default Trade Region','Used in the FX Deal station to determine the default Trade Region'
go
add_domain_values 'ExternalMessageField.MessageMapper','MT942',''
go
add_domain_values 'function','EditAccountSweepingDetail','Allow User to Edit Sweeping Detail in PoolConsolidation Wizard'
go
add_domain_values 'workflowRuleTransfer','UpdateCAAdjustBookLinkedXfer',''
go
add_domain_values 'AccountSetup','INTEREST_ALWAYS_SWEPT_WITH_CUSTXFER','false'
go
add_domain_values 'cfdProductType','EquityIndex',''
go
add_domain_values 'corporateActionType','ACCRUAL.EXERCISE',''
go
add_domain_values 'corporateActionType','ACCRUAL.OVER',''
go
add_domain_values 'corporateActionType','ADR.CAADR',''
go
add_domain_values 'CASwiftEventCodeAttributes','CAMatch.MT564','Message Attributes matched for incoming MT564'
go
add_domain_values 'CASwiftEventCodeAttributes','CAMatch.MT566','Message Attributes matched for incoming MT566'
go
add_domain_values 'classAuditMode','CASwiftEventCodeAttributes','tk.product.corporateaction'
go
add_domain_values 'domainName','CAMatch.MessageAttribute','List of incoming MT56x eligible for matching'
go
add_domain_values 'CAMatch.MessageAttribute','Ex_Date',''
go
add_domain_values 'CAMatch.MessageAttribute','Record_Date',''
go
add_domain_values 'CAMatch.MessageAttribute','Payment_Date',''
go
add_domain_values 'CAMatch.MessageAttribute','Period_Rate',''
go
add_domain_values 'CAMatch.MessageAttribute','Fixed_Rate',''
go
add_domain_values 'CAMatch.MessageAttribute','Amort_Rate',''
go
add_domain_values 'CAMatch.MessageAttribute','Redemption_Price',''
go
add_domain_values 'CAMatch.MessageAttribute','Previous_Pool_Factor',''
go
add_domain_values 'CAMatch.MessageAttribute','New_Pool_Factor',''
go
add_domain_values 'CA.subtype','CAADR',''
go
add_domain_values 'CA.subtype','OVER',''
go
add_domain_values 'CA.Status','WITHDRAWN','Withdrawal: Message sent to void a previously sent notification due to the withdrawal of the event or offer by the issuer'
go
add_domain_values 'CA.Status','MANUAL','a Bond Corporate Action with MANUAL status will not be modified by the CA generation process'
go
add_domain_values 'CA.ApplicableStatus','MANUAL',''
go
add_domain_values 'CA.CanceledStatus','WITHDRAWN',''
go
add_domain_values 'Advance.subtype','Revolving','Subtype to define revolving loans'
go
add_domain_values 'FXForwardStart.subtype','FXForward',''
go
add_domain_values 'FXForwardStart.subtype','FXNDF',''
go
add_domain_values 'FXForwardStart.subtype','FXSwap',''
go
add_domain_values 'FXForwardStart.subtype','FXNDFSwap',''
go
add_domain_values 'domainName','FXForwardStartKeywordsToCopy','Identify keywords to copy from FXForwardStart trade to underlying trade when the forward-start is fixed.'
go
add_domain_values 'SecLending.subtype','Rebate',''
go
add_domain_values 'SecLending.subtype','Fee Cash Pool',''
go
add_domain_values 'SecLending.subtype','Fee Non Cash Pool',''
go
add_domain_values 'SecLending.subtype','Fee Unsecured',''
go
add_domain_values 'Repo.subtype','BSB',''
go
add_domain_values 'Repo.subtype','ZAR',''
go
add_domain_values 'eventFilter','LiquidationEngineEventFilter','Event Filter allowing only position-based products (and filtering others even if cash positions are set up for PositionEngine)'
go
add_domain_values 'eventFilter','PositionKeepingServerTradeEventFilter','Filter to allow only the PSEventTrade events with trades eligible for PositionKeepingServer.'
go
add_domain_values 'formatType','PDF',''
go
add_domain_values 'eventType','EX_CREATE_FX_POS_MON_MARKS','The FX Position Monitor mark creation scheduled task was successful.'
go
add_domain_values 'exceptionType','CREATE_FX_POS_MON_MARKS_SUCCESS',''
go
add_domain_values 'eventType','EX_CREATE_FX_POS_MON_MARKS_FAILURE','The FX Position Monitor mark creation scheduled task was not successful.'
go
add_domain_values 'exceptionType','CREATE_FX_POS_MON_MARKS_FAILURE',''
go
add_domain_values 'eventType','EX_SWEEP_FX_POS_MON_PL_SUCCESS','The FX Position Monitor PnL Sweep scheduled task was successful.'
go
add_domain_values 'eventType','EX_SWEEP_FX_POS_MON_PL_FAILURE','The FX Position Monitor PnL Sweep scheduled task was not successful.'
go
add_domain_values 'flowType','DIVIDEND',''
go
add_domain_values 'exceptionType','REPRICE',''
go
add_domain_values 'function','RemoveTradeEntryDefaultConfig','Access permission to remove a trade entry default configuration'
go
add_domain_values 'function','UndoSettledCreditEvents','Access permission to undo settled credit events'
go
add_domain_values 'function','AdmServer','Permission to administer servers'
go
add_domain_values 'function','AdmLoginAttempts','Permission to view and delete user login attempts'
go
add_domain_values 'billingCalculators','BillingFTTCalculator',''
go
add_domain_values 'function','CreateCommodityConversion','Function authorizing creation of commodity unit conversions'
go
add_domain_values 'function','ModifyCommodityConversion','Function authorizing modification of commodity unit conversions'
go
add_domain_values 'function','RemoveCommodityConversion','Function authorizing removal of commodity unit conversions'
go
add_domain_values 'function','CreateCommodityReset','Function authorizing creation of commodity resets'
go
add_domain_values 'function','ModifyCommodityReset','Function authorizing modification of commodity resets'
go
add_domain_values 'function','RemoveCommodityReset','Function authorizing removal of commodity resets'
go
add_domain_values 'function','CreateCommodityFixingDatePolicy','Function authorizing creation of commodity fixing date policies'
go
add_domain_values 'function','ModifyCommodityFixingDatePolicy','Function authorizing modification of commodity fixing date policies'
go
add_domain_values 'function','RemoveCommodityFixingDatePolicy','Function authorizing removal of commodity fixing date policies'
go
add_domain_values 'function','CreateCommodityCertificateTemplate','Function authorizing creation of commodity certificate templates'
go
add_domain_values 'function','ModifyCommodityCertificateTemplate','Function authorizing modification of commodity certificate templates'
go
add_domain_values 'function','RemoveCommodityCertificateTemplate','Function authorizing removal of commodity certificate templates'
go
add_domain_values 'function','CreateCommodityQuote','Function authorizing creation of commodity quotes'
go
add_domain_values 'function','ModifyCommodityQuote','Function authorizing modification of commodity quotes'
go
add_domain_values 'function','RemoveCommodityQuote','Function authorizing removal of commodity quotes'
go
add_domain_values 'function','ModifyCommodityCertificate','Function authorizing modification of commodity certificates'
go
add_domain_values 'function','ModifyCommodityWeight','Function authorizing modification of commodity risk weights'
go
add_domain_values 'function','AddProductCreditRating','Function authorizing modification of Credit Ratings'
go
add_domain_values 'function','ModifyProductCreditRating','Function authorizing modification of Credit Ratings'
go
add_domain_values 'function','DeleteProductCreditRating','Function authorizing modification of Credit Ratings'
go
add_domain_values 'productType','MICEXRepo',''
go
add_domain_values 'nettingType','SecLendingFeeCashPoolDAP','Merge SecLending xfer and MarginCall xfer in a DAP xfer'
go
add_domain_values 'productType','FXForwardStart','Forward Starting FX trade'
go
add_domain_values 'productType','ScriptableOTCProduct','produttype domain for ScriptableOTCProduct'
go
add_domain_values 'productType','RateIndexProduct','produttype domain for RateIndexProduct'
go
add_domain_values 'productType','ExternalTrade',''
go
add_domain_values 'scheduledTask','REPRICE','For revolving loans.'
go
add_domain_values 'scheduledTask','CREATE_FX_POS_MON_MARKS','Creates FX position monitor marks for the defined mark date and time'
go
add_domain_values 'scheduledTask','SWEEP_FX_POS_MON_PL','Sweeps daily FX position monitor PnL for the specified sweep currency'
go
add_domain_values 'scheduledTask','PROCESS_ENRICHED_TASKS','Update Task Enrichment'
go
add_domain_values 'SWIFT.Templates','MT210Grouped','Group of Notice to Receive'
go
add_domain_values 'MESSAGE.Templates','ScriptableOTCProductConfirmation.html',''
go
add_domain_values 'productTypeReportStyle','FXForwardStart','FXForwardStart ReportStyle'
go
add_domain_values 'productTypeReportStyle','TransferAgent','TransferAgent ReportStyle'
go
add_domain_values 'groupStaticDataFilter','Book','group of StaticDataFilters dedicated to [Trade] Book, Book attributes selection'
go
add_domain_values 'groupStaticDataFilter','Security','group of StaticDataFilters dedicated to [Trade] underlying Security selection'
go
add_domain_values 'tradeKeyword','SecLendingTradeId','Available on MarginCall trade. Trade Id of SecLending generating this MarginCall trade. '
go
add_domain_values 'tradeKeyword','SecLendingConvertedFrom','Available on SecLending trade converted from a Pay To Hold trade. This keyword contains the id of the Pay To Hold trade'
go
add_domain_values 'tradeKeyword','CAClaimReason','CA Trade generated either for Fail or Claim'
go
add_domain_values 'tradeKeyword','CAAgentAccountId',''
go
add_domain_values 'tradeKeyword','CAAgentCashAccountId',''
go
add_domain_values 'domainName','sdFilterCriterion','Static Data Filter criterion name'
go
add_domain_values 'domainName','sdFilterCriterion.Factory','Static Data Filter criterion factory name'
go
add_domain_values 'sdFilterCriterion','Trade Booking Date',''
go
add_domain_values 'sdFilterCriterion.Factory','CA','build Corporate Action Static Data Filter criteria'
go
add_domain_values 'domainName','DefaultTradeValuesHandler','Handlers for the trade entry default configs'
go
add_domain_values 'DefaultTradeValuesHandler','SecFinance','Defaults handler for secFinance TradeEntry'
go

add_domain_values 'marketDataUsage','HyperSurfaceOpen',''
go
add_domain_values 'hyperSurfaceSubTypes','Advance',''
go
add_domain_values 'hyperSurfaceSubTypes','AdvanceTemplate',''
go
add_domain_values 'accountProperty','CATradeDDAInternal','Create a Corporate Action Trade on the Internal View of a Client DDA Account Position '
go
add_domain_values 'domainName','accountProperty.CATradeDDAInternal',''
go
add_domain_values 'accountProperty.CATradeDDAInternal','False',''
go
add_domain_values 'accountProperty.CATradeDDAInternal','True',''
go
add_domain_values 'plMeasure','Settlement_Date_PnL_Base',''
go
add_domain_values 'plMeasure','Accrual_FX_Reval',''
go
add_domain_values 'domainName','systemEnrichmentContext',''
go
add_domain_values 'systemEnrichmentContext','ParticipationClassificationTradeEnrichment',''
go
add_domain_values 'function','CRMConfigAdmin','Give access to the Configuration dialog in the CRM window'
go
add_domain_values 'function','CRMAccessConfig','CRM user can see the Relationship and User tabs'
go
add_domain_values 'LifeCycleEventProcessor','tk.lifecycle.processor.NoAction','No Action'
go
add_domain_values 'LifeCycleEventStatus','CANCELLING',''
go
add_domain_values 'TradeRejectAction','UN-KNOCK_IN','UN-KNOCK_IN considered to be a reject action'
go
add_domain_values 'TradeRejectAction','UN-KNOCK_OUT','UN-KNOCK_OUT considered to be a reject action'
go
add_domain_values 'TradeRejectAction','UNEXERCISE','UNEXERCISE considered to be a reject action'
go
add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationDate',''
go
add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationStatus',''
go
add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationDeDesignationDate',''
go
add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationHETPassCount',''
go
add_domain_values 'hedgeRelationshipDefinitionAttributes','DeactivationDate',''
go
add_domain_values 'hedgeAccountingSchemeAttributes','Calculate Baseline Adjustment',''
go
add_domain_values 'hedgeDefinitionAttributes','Default HAS',''
go
add_domain_values 'HedgeRelationshipDefinitionAction','MIGRATE',''
go
add_domain_values 'HedgeRelationshipDefinitionAction','DEACTIVATE',''
go
add_domain_values 'HedgeRelationshipDefinitionAction','END_SHORTCUT',''
go
add_domain_values 'workflowRuleHedgeRelationshipDefinition','EndShortcut',''
go
add_domain_values 'workflowRuleHedgeRelationshipDefinition','Deactivation',''
go
add_domain_values 'function','ModifyTSCatalogOrdering','Allow User to modify Task Station Catalog Ordering'
go
add_domain_values 'domainName','taskEnrichmentClasses','List of data source classes used for task enrichment'
go
add_domain_values 'taskEnrichmentClasses','Trade','com.calypso.tk.core.Trade'
go
add_domain_values 'taskEnrichmentClasses','Transfer','com.calypso.tk.bo.BOTransfer'
go
add_domain_values 'taskEnrichmentClasses','Message','com.calypso.tk.bo.BOMessage'
go
add_domain_values 'taskEnrichmentClasses','CrossWorkflows','com.calypso.tk.bo.Task'
go
add_domain_values 'taskEnrichmentClasses','Dynamic','com.calypso.tk.bo.Task'
go
add_domain_values 'taskEnrichmentClasses','TradeBundle','com.calypso.tk.core.TradeBundle'
go
add_domain_values 'taskEnrichmentClasses','CAElection','com.calypso.tk.product.corporateaction.CAElection'
go
add_domain_values 'taskEnrichmentClasses','HedgeRelationshipDefinition','HedgeRelationshipDefinition'
go
add_domain_values 'domainName','keyword.TradePlatform','List of Trade Platforms'
go
add_domain_values 'keyword.TradePlatform','Calypso','Default trade routing platform'
go
add_domain_values 'domainName','keyword.TradeRegion','List of Trade Regions'
go
add_domain_values 'keyword.TradeRegion','Global','Default trade region'
go
add_domain_values 'domainName','FXMirrorKeywords','List of Keywords to copy from original FX trade to mirror trade.'
go
add_domain_values 'FXMirrorKeywords','TradePlatform',''
go
add_domain_values 'FXMirrorKeywords','TradeRegion',''
go
add_domain_values 'domainName','keywords2CopyUponAllocate','List of Keywords to copy from original FX trade to trade created via SPLIT action.'
go
add_domain_values 'keywords2CopyUponAllocate','TradePlatform',''
go
add_domain_values 'keywords2CopyUponAllocate','TradeRegion',''
go
add_domain_values 'domainName','keywords2CopyUponSpotReserveSetVal','List of Keywords to copy from original FXSpotReserve trade to trade created via SETVAL action.'
go
add_domain_values 'keywords2CopyUponSpotReserveSetVal','TradePlatform',''
go
add_domain_values 'keywords2CopyUponSpotReserveSetVal','TradeRegion',''
go
add_domain_values 'function','ModifyPositionKeepingConfig','Access permission to update entries in PositionKeeping Config Editor'
go
add_domain_values 'domainName','bookAttribute.PositionKeepingBookType',''
go
add_domain_values 'bookAttribute.PositionKeepingBookType','SALES',''
go
add_domain_values 'bookAttribute.PositionKeepingBookType','TRADING',''
go
add_domain_values 'bookAttribute.PositionKeepingBookType','PROP',''
go
add_domain_values 'domainName','FXPositionMonitor.MarkRefTimes','Reference times for the PositionKeepingBlotter marks. Entries under this should be of type ''hhmm TimeZone'', ex. ''1659 America/New_York'''
go
add_domain_values 'FXPositionMonitor.MarkRefTimes','1659 America/New_York',''
go
add_domain_values 'engineName','PositionKeepingPersistenceEngine',''
go
add_domain_values 'lifeCycleEntityType','CAElection','Corporate Action election has its own life cycle'
go
add_domain_values 'workflowType','CAElection','Corporate Action election follows its own workflow'
go
add_domain_values 'CAElectionStatus','NONE',''
go
add_domain_values 'CAElectionStatus','PENDING',''
go
add_domain_values 'CAElectionStatus','PARTIALLY_ELECTED',''
go
add_domain_values 'CAElectionStatus','CANCELED',''
go
add_domain_values 'CAElectionStatus','ELECTED',''
go
add_domain_values 'CAElectionStatus','VALIDATED',''
go
add_domain_values 'CAElectionStatus','LOCKED','Applicable election status'
go
add_domain_values 'domainName','CAElectionApplicableStatus','Identifies CAELection status for which CA Trade generation is applicable'
go
add_domain_values 'CAElectionApplicableStatus','VALIDATED',''
go
add_domain_values 'CAElectionApplicableStatus','LOCKED',''
go
add_domain_values 'domainName','CAElectionLockedStatus','Identifies CAELection final status for which automated update cannot be performed'
go
add_domain_values 'CAElectionLockedStatus','LOCKED',''
go
add_domain_values 'CAElectionAction','NEW',''
go
add_domain_values 'CAElectionAction','CANCEL',''
go
add_domain_values 'CAElectionAction','AMEND','User amendment'
go
add_domain_values 'CAElectionAction','AUTHORIZE',''
go
add_domain_values 'CAElectionAction','UPDATE','System automated amendment'
go
add_domain_values 'CAElectionAction','ELECT','action name for STP transition towards ELECTED status'
go
add_domain_values 'CAElectionAction','LOCK',''
go
add_domain_values 'workflowRuleCAElection','ApplySameAction',''
go
add_domain_values 'workflowRuleMessage','SetElectionMessageRef',''
go
add_domain_values 'workflowRuleMessage','CheckCAAgentDetails',''
go
add_domain_values 'workflowRuleMessage','MatchIncomingElection',''
go
add_domain_values 'workflowRuleMessage','CheckIncomingProcess',''
go
add_domain_values 'workflowRuleMessage','ReprocessIncoming',''
go
add_domain_values 'workflowRuleMessage','UnprocessCashSettlementConfirmation',''
go
add_domain_values 'SWIFT.Templates','MT565',''
go
add_domain_values 'domainName','CAElectionAttributes',''
go
add_domain_values 'CAElectionAttributes','MessageId',''
go
add_domain_values 'CAElectionAttributes','Instruction_Status',''
go
add_domain_values 'CAElectionAttributes','Instruction_Reason',''
go
add_domain_values 'MsgAttributes','Instruction_Reason',''
go
add_domain_values 'MsgAttributes','Instruction_Status',''
go
add_domain_values 'MsgAttributes','CA_Agent_Reference',''
go
add_domain_values 'MsgAttributes','CA Option',''
go
add_domain_values 'MsgAttributes','CA Option Number',''
go
add_domain_values 'MsgAttributes','Quantity',''
go
add_domain_values 'MsgAttributes','Balance',''
go
add_domain_values 'MsgAttributes','Process Issue',''
go
add_domain_values 'domainName','ElectionMatchingReason',''
go
add_domain_values 'ElectionMatchingReason','CAND//CANI','Instruction has been cancelled as per your request.'
go
add_domain_values 'ElectionMatchingReason','CAND//CANO','Instruction has been cancelled by another party than the instructing party.'
go
add_domain_values 'ElectionMatchingReason','CAND//CANS','Instruction has been cancelled by the system.'
go
add_domain_values 'ElectionMatchingReason','CAND//CSUB','Instruction has been cancelled by the agent.'
go
add_domain_values 'ElectionMatchingReason','PACK//ADEA','Received after the account servicer''s deadline. Processed on best effort basis.'
go
add_domain_values 'ElectionMatchingReason','PACK//LATE','Instruction was received after market deadline.'
go
add_domain_values 'ElectionMatchingReason','PACK//NSTP','Instruction was not STP and had to be processed manually.'
go
add_domain_values 'ElectionMatchingReason','REJT//ADEA','Received after the account servicer''s deadline.'
go
add_domain_values 'ElectionMatchingReason','REJT//CANC','Option is not valid; it has been cancelled by the market or service provider, and cannot be responded to.'
go
add_domain_values 'ElectionMatchingReason','REJT//CERT','Instruction is rejected since the provided certification is incorrect or incomplete.'
go
add_domain_values 'ElectionMatchingReason','REJT//DQUA','Unrecognized or invalid instructed quantity.'
go
add_domain_values 'ElectionMatchingReason','REJT//DSEC','Unrecognized or invalid financial instrument identification.'
go
add_domain_values 'ElectionMatchingReason','REJT//EVNM','Unrecognized Corporate Action Event Number Rejection.'
go
add_domain_values 'ElectionMatchingReason','REJT//LACK','Instructed position exceeds the eligible balance.'
go
add_domain_values 'ElectionMatchingReason','REJT//LATE','Instruction received after market deadline.'
go
add_domain_values 'ElectionMatchingReason','REJT//NMTY','Mismatch Option Number and Option Type Rejection.'
go
add_domain_values 'ElectionMatchingReason','REJT//OPNM','Unrecognized option number.'
go
add_domain_values 'ElectionMatchingReason','REJT//OPTY','Invalid option type.'
go
add_domain_values 'ElectionMatchingReason','REJT//SAFE','Unrecognized or invalid message sender''s safekeeping account.'
go
add_domain_values 'ElectionMatchingReason','REJT//ULNK','Unknown. Linked reference is unknown.'
go
add_domain_values 'ElectionMatchingReason','PEND//ADEA','Account Servicer Deadline Missed.'
go
add_domain_values 'ElectionMatchingReason','PEND//CERT','Instruction is rejected since the provided certification is incorrect or incomplete.'
go
add_domain_values 'ElectionMatchingReason','PEND//DQUA','Disagreement on Quantity. Unrecognized or invalid instructed quantity.'
go
add_domain_values 'ElectionMatchingReason','PEND//LACK','Lack of Securities. Insufficient financial instruments in your account.'
go
add_domain_values 'ElectionMatchingReason','PEND//LATE','Market Deadline Missed.'
go
add_domain_values 'ElectionMatchingReason','PEND//MCER','Missing or Invalid Certification. Awaiting receipt of adequate certification.'
go
add_domain_values 'ElectionMatchingReason','PEND//MONY','Insufficient cash in your account.'
go
add_domain_values 'ElectionMatchingReason','PEND//NPAY','Payment Not Made. Payment has not been made by issuer.'
go
add_domain_values 'ElectionMatchingReason','PEND//NSEC','Securities Not Delivered. Financial instruments have not been delivered by the issuer.'
go
add_domain_values 'ElectionMatchingReason','PEND/PENR','The instruction is pending receipt of securities, for example, from a purchase, loan etc.'
go
add_domain_values 'incomingType','MT567','INC_CA'
go
add_domain_values 'CA.keywords','CAElectionId','Applied election if any'
go
add_domain_values 'CA.keywords','CAElectionPosition','Applied election total position'
go
add_domain_values 'MESSAGE.Templates','caElectionInstruction.html',''
go
add_domain_values 'messageType','CA_ELECTION','Sent in case of CA Election'
go
add_domain_values 'classAuditMode','CAElection',''
go
add_domain_values 'classAuditMode','CAElectionInstruction',''
go
add_domain_values 'classAuditMode','CAElectionDeadlineRule',''
go
add_domain_values 'workflowRuleCAElection','CheckPartiallyElected',''
go
add_domain_values 'workflowRuleCAElection','CheckElected',''
go
add_domain_values 'workflowRuleCAElection','CheckBookEntitledObligatedDifference',''
go
add_domain_values 'domainName','workflowRuleCAElection','Workflow rule available for CAElection workflow'
go
add_domain_values 'genericObjectClass','CAElection','package com.calypso.tk.product.corporateaction'
go
add_domain_values 'genericObjectClass','CAElectionInstruction','package com.calypso.tk.product.corporateaction'
go
add_domain_values 'genericObjectClass','CAElectionDeadlineRule','package com.calypso.tk.product.corporateaction'
go
add_domain_values 'genericCommentType','Supporting Documentation',''
go
add_domain_values 'unavailabilityReason','Conditional CA Event','Conditional Corporate Action event such as Tender offer'
go
add_domain_values 'eventType','PENDING_CAELECTION',''
go
add_domain_values 'eventType','PARTIALLY_ELECTED_CAELECTION',''
go
add_domain_values 'eventType','CANCELED_CAELECTION',''
go
add_domain_values 'eventType','ELECTED_CAELECTION',''
go
add_domain_values 'eventType','LOCKED_CAELECTION',''
go
add_domain_values 'eventType','EX_CAELECTION','Exception  generated by the ScheduledTaskCA_ELECTION'
go
add_domain_values 'exceptionType','CAELECTION',''
go
add_domain_values 'scheduledTask','CA_ELECTION',''
go
add_domain_values 'function','AddCAElection',''
go
add_domain_values 'function','ModifyCAElection',''
go
add_domain_values 'function','RemoveCAElection',''
go
add_domain_values 'function','AddCAElectionInstruction',''
go
add_domain_values 'function','ModifyCAElectionInstruction',''
go
add_domain_values 'function','RemoveCAElectionInstruction',''
go
add_domain_values 'function','AddCAElectionDeadlineRule',''
go
add_domain_values 'function','ModifyCAElectionDeadlineRule',''
go
add_domain_values 'function','RemoveCAElectionDeadlineRule',''
go
add_domain_values 'function','ModifyTaskStationGlobalFilter',''
go
add_domain_values 'domainName','CAAuditReportField',''
go
add_domain_values 'eventType','EX_CA_ELECTION_INFORMATION',''
go
add_domain_values 'exceptionType','CA_ELECTION_INFORMATION',''
go
add_domain_values 'workflowRuleCAElection','PublishTaskIfChange',''
go
add_domain_values 'domainName','PublishTaskIfChangeCAElectionRule',''
go
add_domain_values 'systemKeyword','CASalesMarginGroup','System wide Keyword for capturing Cross-Asset Sales Margin Group Name'
go
add_domain_values 'tradeKeyword','CASalesMarginGroup','Trade Keyword for capturing Cross-Asset Sales Margin Group Name'
go
add_domain_values 'domainName','salesMarginGroup','Cross Asset Sales Margin Counterparty group'
go
add_domain_values 'domainName','salesMarginChannelType','Cross Asset Sales Margin Channel Type'
go
add_domain_values 'domainName','salesMarginConfigProducts','Supported Products for Cross Asset Sales Margin'
go
add_domain_values 'salesMarginConfigProducts','FXOption',''
go
add_domain_values 'salesMarginConfigProducts','FX',''
go
add_domain_values 'salesMarginConfigProducts','FXCash',''
go
add_domain_values 'salesMarginConfigProducts','FXForward',''
go
add_domain_values 'salesMarginConfigProducts','FXNDF',''
go
add_domain_values 'salesMarginConfigProducts','FXSwap',''
go
add_domain_values 'salesMarginConfigProducts','CapFloor',''
go
add_domain_values 'salesMarginConfigProducts','StructuredFlows',''
go
add_domain_values 'salesMarginConfigProducts','FRA',''
go
add_domain_values 'salesMarginConfigProducts','Swap',''
go
add_domain_values 'salesMarginConfigProducts','FutureBond',''
go
add_domain_values 'salesMarginConfigProducts','Bond',''
go
add_domain_values 'salesMarginConfigProducts','FutureFX',''
go
add_domain_values 'salesMarginConfigProducts','FutureMM',''
go
add_domain_values 'salesMarginConfigProducts','FutureOptionFX',''
go
add_domain_values 'salesMarginConfigProducts','FutureOptionMM',''
go
add_domain_values 'salesMarginConfigProducts','Equity',''
go
add_domain_values 'salesMarginConfigProducts','EquityForward',''
go
add_domain_values 'salesMarginConfigProducts','EquityStructuredOption',''
go
add_domain_values 'salesMarginConfigProducts','CommodityOTCOption2',''
go
add_domain_values 'salesMarginConfigProducts','CommoditySwap2',''
go
add_domain_values 'salesMarginConfigProducts','CommodityForward',''
go
add_domain_values 'salesMarginConfigProducts','CreditDefaultSwap',''
go
add_domain_values 'salesMarginConfigProducts','CDSIndex',''
go
add_domain_values 'salesMarginConfigProducts','CDSIndexOption',''
go
add_domain_values 'salesMarginConfigProducts','CDSIndexTranche',''
go
add_domain_values 'salesMarginConfigProducts','AssetSwap',''
go
add_domain_values 'salesMarginConfigProducts','Swaption',''
go
add_domain_values 'systemKeyword','TaxLotLiquidationMethod','Tax lot liquidation method that a Trade is subject to.  Can be used in Liquidation Config Trade Filters'
go
add_domain_values 'tradeKeyword','TaxLotLiquidationMethod','Tax lot liquidation method that a Trade is subject to.  Can be used in Liquidation Config Trade Filters'
go
add_domain_values 'keyword.TaxLotLiquidationMethod','FIFO',''
go
add_domain_values 'keyword.TaxLotLiquidationMethod','MANUAL',''
go
add_domain_values 'domainname','ManualPartyName','Domain used by Cash Manual SDI'
go

add_domain_values 'ManualPartyName','Beneficiary','UNKNOWN BENEFICIARY'
go

add_domain_values 'ManualPartyName','Banker','UNKNOWN AGENT'
go

add_domain_values 'ManualPartyName','Intermediary1','UNKNOWN INT1'
go

add_domain_values 'ManualPartyName','Intermediary2','UNKNOWN INT2'
go

add_domain_values 'ManualPartyName','Remitter','UNKNOWN REMITTER'
go

add_domain_values 'domainname','manualSDITAG','Domain used by Cash Manual SDI'
go

add_domain_values 'manualSDITAG','Receivers Charges','71G-0'
go

add_domain_values 'manualSDITAG','Remitter Information','70-1'
go

add_domain_values 'manualSDITAG','Senders Charges','71F-2'
go

add_domain_values 'manualSDITAG','Details of Charges','71A-3'
go

add_domain_values 'manualSDITAG','Sender to Receiver Information','72-4'
go

add_domain_values 'domainname','manualSDITAG.70','Domain used by Cash Manual SDI'
go

add_domain_values 'manualSDITAG.70','INV/',''
go

add_domain_values 'manualSDITAG.70','IPI/',''
go

add_domain_values 'manualSDITAG.70','RFB/',''
go

add_domain_values 'manualSDITAG.70','ROC/',''
go

add_domain_values 'domainname','manualSDITAG.71A','Domain used by Cash Manual SDI'
go

add_domain_values 'manualSDITAG.71A','BEN',''
go

add_domain_values 'manualSDITAG.71A','OUR',''
go

add_domain_values 'manualSDITAG.71A','SHA',''
go

add_domain_values 'domainname','manualSDITAG.72','Domain used by Cash Manual SDI'
go

add_domain_values 'manualSDITAG.72','ACC/',''
go

add_domain_values 'manualSDITAG.72','INS/',''
go

add_domain_values 'manualSDITAG.72','INT/',''
go

add_domain_values 'manualSDITAG.72','REC/',''
go

add_domain_values 'domainname','beneficiaryIdentifierPrefixes','Domain used by Cash Manual SDI'
go

add_domain_values 'beneficiaryIdentifierPrefixes','A/C',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','AT',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','AU',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','BL',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','CC',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','CH',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','CP',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','ES',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','FW',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','GR',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','HK',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','IE',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','IN',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','IT',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','NZ',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','PL',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','PT',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','RT',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','RU',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','SC',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','SW',''
go

add_domain_values 'beneficiaryIdentifierPrefixes','ZA',''
go

add_domain_values 'domainname','agentIdentifierPrefixes','Domain used by Cash Manual SDI'
go

add_domain_values 'agentIdentifierPrefixes','A/C',''
go

add_domain_values 'agentIdentifierPrefixes','AT',''
go

add_domain_values 'agentIdentifierPrefixes','AU',''
go

add_domain_values 'agentIdentifierPrefixes','BL',''
go

add_domain_values 'agentIdentifierPrefixes','CC',''
go

add_domain_values 'agentIdentifierPrefixes','CH',''
go

add_domain_values 'agentIdentifierPrefixes','CP',''
go

add_domain_values 'agentIdentifierPrefixes','ES',''
go

add_domain_values 'agentIdentifierPrefixes','FW',''
go

add_domain_values 'agentIdentifierPrefixes','GR',''
go

add_domain_values 'agentIdentifierPrefixes','HK',''
go

add_domain_values 'agentIdentifierPrefixes','IE',''
go

add_domain_values 'agentIdentifierPrefixes','IN',''
go

add_domain_values 'agentIdentifierPrefixes','IT',''
go

add_domain_values 'agentIdentifierPrefixes','NZ',''
go

add_domain_values 'agentIdentifierPrefixes','PL',''
go

add_domain_values 'agentIdentifierPrefixes','PT',''
go

add_domain_values 'agentIdentifierPrefixes','RT',''
go

add_domain_values 'agentIdentifierPrefixes','RU',''
go

add_domain_values 'agentIdentifierPrefixes','SC',''
go

add_domain_values 'agentIdentifierPrefixes','SW',''
go

add_domain_values 'agentIdentifierPrefixes','ZA',''
go

add_domain_values 'domainname','intermediary1IdentifierPrefixes','Domain used by Cash Manual SDI'
go

add_domain_values 'intermediary1IdentifierPrefixes','A/C',''
go

add_domain_values 'intermediary1IdentifierPrefixes','AT',''
go

add_domain_values 'intermediary1IdentifierPrefixes','AU',''
go

add_domain_values 'intermediary1IdentifierPrefixes','BL',''
go

add_domain_values 'intermediary1IdentifierPrefixes','CC',''
go

add_domain_values 'intermediary1IdentifierPrefixes','CH',''
go

add_domain_values 'intermediary1IdentifierPrefixes','CP',''
go

add_domain_values 'intermediary1IdentifierPrefixes','ES',''
go

add_domain_values 'intermediary1IdentifierPrefixes','FW',''
go

add_domain_values 'intermediary1IdentifierPrefixes','GR',''
go

add_domain_values 'intermediary1IdentifierPrefixes','HK',''
go

add_domain_values 'intermediary1IdentifierPrefixes','IE',''
go

add_domain_values 'intermediary1IdentifierPrefixes','IN',''
go

add_domain_values 'intermediary1IdentifierPrefixes','IT',''
go

add_domain_values 'intermediary1IdentifierPrefixes','NZ',''
go

add_domain_values 'intermediary1IdentifierPrefixes','PL',''
go

add_domain_values 'intermediary1IdentifierPrefixes','PT',''
go

add_domain_values 'intermediary1IdentifierPrefixes','RT',''
go

add_domain_values 'intermediary1IdentifierPrefixes','RU',''
go

add_domain_values 'intermediary1IdentifierPrefixes','SC',''
go

add_domain_values 'intermediary1IdentifierPrefixes','SW',''
go

add_domain_values 'intermediary1IdentifierPrefixes','ZA',''
go

add_domain_values 'domainname','intermediary2IdentifierPrefixes','Domain used by Cash Manual SDI'
go

add_domain_values 'intermediary2IdentifierPrefixes','A/C',''
go

add_domain_values 'intermediary2IdentifierPrefixes','AT',''
go

add_domain_values 'intermediary2IdentifierPrefixes','AU',''
go

add_domain_values 'intermediary2IdentifierPrefixes','BL',''
go

add_domain_values 'intermediary2IdentifierPrefixes','CC',''
go

add_domain_values 'intermediary2IdentifierPrefixes','CH',''
go

add_domain_values 'intermediary2IdentifierPrefixes','CP',''
go

add_domain_values 'intermediary2IdentifierPrefixes','ES',''
go

add_domain_values 'intermediary2IdentifierPrefixes','FW',''
go

add_domain_values 'intermediary2IdentifierPrefixes','GR',''
go

add_domain_values 'intermediary2IdentifierPrefixes','HK',''
go

add_domain_values 'intermediary2IdentifierPrefixes','IE',''
go

add_domain_values 'intermediary2IdentifierPrefixes','IN',''
go

add_domain_values 'intermediary2IdentifierPrefixes','IT',''
go

add_domain_values 'intermediary2IdentifierPrefixes','NZ',''
go

add_domain_values 'intermediary2IdentifierPrefixes','PL',''
go

add_domain_values 'intermediary2IdentifierPrefixes','PT',''
go

add_domain_values 'intermediary2IdentifierPrefixes','RT',''
go

add_domain_values 'intermediary2IdentifierPrefixes','RU',''
go

add_domain_values 'intermediary2IdentifierPrefixes','SC',''
go

add_domain_values 'intermediary2IdentifierPrefixes','SW',''
go

add_domain_values 'intermediary2IdentifierPrefixes','ZA',''
go

add_domain_values 'domainname','remitterIdentifierPrefixes','Domain used by Cash Manual SDI'
go

add_domain_values 'remitterIdentifierPrefixes','A/C',''
go

add_domain_values 'remitterIdentifierPrefixes','ARNU',''
go

add_domain_values 'remitterIdentifierPrefixes','CCPT',''
go

add_domain_values 'remitterIdentifierPrefixes','CUST',''
go

add_domain_values 'remitterIdentifierPrefixes','DRLC',''
go

add_domain_values 'remitterIdentifierPrefixes','EMPL',''
go

add_domain_values 'remitterIdentifierPrefixes','IBEI',''
go

add_domain_values 'remitterIdentifierPrefixes','NIDN',''
go

add_domain_values 'remitterIdentifierPrefixes','SOSE',''
go

add_domain_values 'remitterIdentifierPrefixes','TXID',''
go

add_domain_values 'scheduledTask','SWIFT_BIC_IMPORT',''
go      
insert into pricer_measure (measure_name,measure_class_name,measure_id,measure_comment) values ('DV01','tk.core.PricerMeasure',408,'Yield Sensitivity - computed as the dollar value change due to a 1 bpts change in yield.')
go
if not exists (select 1 from sysobjects where name='config_hierarchy')
begin
exec ('create table config_hierarchy (id numeric null , hierarchy varchar(32) null , client_id numeric null,
        le_id numeric null , user_name varchar(32) null, enabled varchar(1) null)')
end
go
INSERT INTO config_hierarchy ( id, hierarchy, enabled ) VALUES (0,'default','Y' )
go
delete from task_enrichment_field_config where custom_class_name = 'com.calypso.tk.bo.DefaultTaskEnrichmentCustom' or field_db_name in ('xfer_is_dda', 'xfer_int_sdi_status', 'xfer_ext_sdi_status', 'xfer_event_type', 'trade_comment', 'trade_bundle_id', 'msg_version', 'msg_statement_id', 'msg_sender_role', 'msg_sender_address_code', 'msg_reset_date','msg_receiver_role', 'msg_receiver_address_code', 'msg_product_type', 'msg_event_type', 'msg_description', 'msg_creation_date', 'msg_address_method')
go 

/* making changes to the HedgeAccounting Domain data */

insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (601,'UNKNOWN BENEFICIARY','UNKNOWN BENEFICIARY',0,0,'Fake Unknown Beneficiary used by Cash Manual Sdi','Enabled','FRANCE')
go
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (602,'UNKNOWN AGENT','UNKNOWN AGENT',0,1,'Fake Unknown Agent used by Cash Manual Sdi','Enabled','NONE')
go
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (603,'UNKNOWN INT1','UNKNOWN INTERMEDIARY1',0,1,'Fake Unknown Intermediary 1 used by Cash Manual Sdi','Enabled','NONE')
go
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (604,'UNKNOWN INT2','UNKNOWN INTERMEDIARY2',0,1,'Fake Unknown Intermediary 2 used by Cash Manual Sdi','Enabled','NONE')
go
insert into legal_entity  (legal_entity_id,short_name,long_name,parent_le_id,classification,comments,le_status,country) values (605,'UNKNOWN REMITTER','UNKNOWN REMITTER',0,0,'Fake Unknown Remitter used by Cash Manual Sdi','Enabled','NONE')
go  
insert into legal_entity_role (legal_entity_id ,role_name) values (601,'CounterParty')
go
insert into legal_entity_role (legal_entity_id ,role_name) values (602,'Agent')
go
insert into legal_entity_role (legal_entity_id ,role_name) values (603,'Agent')
go
insert into legal_entity_role (legal_entity_id ,role_name) values (604,'Agent')
go
insert into legal_entity_role (legal_entity_id ,role_name) values (605,'Counterparty')
go
insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (501,601,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
go
insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (502,602,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
go

insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (503,603,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
go

insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (504,604,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
go
insert into le_contact (contact_id,legal_entity_id,legal_entity_role,po_id,contact_type,product_family,last_name,title,city,zipcode,state,country,mailing_address,email_address,phone,fax,telex,swift,comments,product_list)
values (505,605,'ALL',0,'ALL','ALL','Jim Kow',null,null,null,null,null,null,null,null,null,null,null,null,'ALL')
go
/* end */
add_domain_values 'Swap.subtype','Fixed Payment',''
go
add_domain_values 'PLPositionProduct.Pricer','PricerPLPositionProductBondWAC','PLPositionProduct Pricer'
go
if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='NONE' and possible_action ='NEW' and resulting_status = 'PENDING' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (801,'HedgeRelationshipDefinition','NONE','NEW','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (801,'Reprocess' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' and possible_action ='DESIGNATE' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (802,'HedgeRelationshipDefinition','PENDING','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
 
end
go


if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='DE_DESIGNATE' and resulting_status = 'INEFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (803,'HedgeRelationshipDefinition','EFFECTIVE','DE_DESIGNATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
 
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='DESIGNATE' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (804,'HedgeRelationshipDefinition','INEFFECTIVE','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='CANCEL' and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (805,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='CANCEL' and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (806,'HedgeRelationshipDefinition','INEFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
end
go


if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='TERMINATE' and resulting_status = 'INACTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (807,'HedgeRelationshipDefinition','INEFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (807,'Deactivation' )
end
go


if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='TERMINATE' and resulting_status = 'INACTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (808,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (808,'CheckEndDate' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INACTIVE' and possible_action ='TERMINATE' and resulting_status = 'TERMINATED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (809,'HedgeRelationshipDefinition','INACTIVE','TERMINATE','TERMINATED',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (809,'CheckEndDate' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INACTIVE' and possible_action ='REPROCESS' and resulting_status = 'INACTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (810,'HedgeRelationshipDefinition','INACTIVE','REPROCESS','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (810,'Reprocess' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' and possible_action ='REPROCESS' and resulting_status = 'PENDING' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (811,'HedgeRelationshipDefinition','PENDING','REPROCESS','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (811,'Reprocess' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='UPDATE' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (812,'HedgeRelationshipDefinition','EFFECTIVE','UPDATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )

end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='UPDATE' and resulting_status = 'INEFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0  )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (813,'HedgeRelationshipDefinition','INEFFECTIVE','UPDATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )

end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='INEFFECTIVE' and possible_action ='REPROCESS' and resulting_status = 'INEFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (814,'HedgeRelationshipDefinition','INEFFECTIVE','REPROCESS','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (814,'Reprocess' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='REPROCESS' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (815,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (815,'Reprocess' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' and possible_action ='CANCEL' and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (816,'HedgeRelationshipDefinition','PENDING','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )

end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='PENDING' and possible_action ='UPDATE' and resulting_status = 'PENDING' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'ALL' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (817,'HedgeRelationshipDefinition','PENDING','UPDATE','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )

end
go


if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='NONE' and possible_action ='NEW' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (820,'HedgeRelationshipDefinition','NONE','NEW','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (820,'Reprocess' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='REPROCESS' and resulting_status = 'EFFECTIVE' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0)
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (821,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
	INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (821,'ReprocessEconomic' )
end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='TERMINATE' and resulting_status = 'TERMINATED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0  )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (822,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','TERMINATED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )

end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='EFFECTIVE' and possible_action ='CANCEL' and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (823,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )

end
go

if not exists (select 1 from wfw_transition where event_class= 'HedgeRelationshipDefinition' and status='TERMINATED' and possible_action ='CANCEL' and resulting_status = 'CANCELED' and use_stp_b = 0 and same_user_b = 1 and product_type = 'ALL' and msg_type = 'Non-Qualifying Hedge' and log_completed_b = 0 and kick_cutoff_b = 0 and create_task_b =0 and  update_only_b =0 and gen_int_event_b =0 )
begin 
	INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (824,'HedgeRelationshipDefinition','TERMINATED','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )

end
go

truncate table alive_dataservers
go
update pricer_measure set measure_class_name = 'tk.pricer.PricerMeasureIRR' where measure_name = 'IRR' 
go
insert into pricer_measure values ('ACCRUAL_EIR', 'tk.core.PricerMeasure', 454, 'Amount accrued to date based on effective interest rate') 
go

add_column_if_not_exists 'pc_discount','collateral_curr','varchar(32) null'
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=0,
        sub_version=0,
        patch_version='011',
        version_date='20130815'
go
