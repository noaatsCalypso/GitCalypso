 

UPDATE pricer_measure SET measure_name = 'HISTO_BS' WHERE measure_name = 'HISTO_BS_FX_REVAL'
go
DELETE FROM pricer_measure WHERE measure_name = 'HISTO_UNSETTLED_CASH_FX_REVAL'
go
UPDATE country SET time_zone = null WHERE time_zone = 'null'
go
drop_pk_if_exists 'pmt_freq_details'
go  

DELETE FROM pricer_measure WHERE measure_name LIKE '%GENERIC_CASH%'
go

delete from domain_values where name = 'DispatcherParamsSymphony'
go

DELETE FROM domain_values WHERE value = 'CashSettleDefaultsAgreements'
go

DELETE FROM domain_values WHERE name = 'CashSettleDefaultsAgreements'
go


/* 49608 - Add DayChangeRule to pricing environment and market data item */
/* pricing env */

/* correlation matrix */
add_column_if_not_exists 'correlation_matrix', 'day_change_rule', 'varchar(32) null'
go

add_column_if_not_exists 'corr_matrix_hist','day_change_rule', 'varchar(32) null'
go

/* correlation surface */
add_column_if_not_exists 'corr_surface','day_change_rule', 'varchar(32) null'
go

/* curve */
add_column_if_not_exists 'curve', 'day_change_rule','varchar(32) null'
go

add_column_if_not_exists 'curve_hist','day_change_rule', 'varchar(32) null'
go

/* vol surface */
add_column_if_not_exists 'vol_surface','day_change_rule', 'varchar(32) null'
go

add_column_if_not_exists 'vol_surface_hist' ,'day_change_rule','varchar(32) null'
go

/* End 49608  */
  
/* BZ 49534 */
delete from domain_values where name = 'liquidationMethod' and value in ('Bond', 'Security')
go

delete from domain_values where name = 'sortMethod' and value in ('TradeId')
go





add_column_if_not_exists 'liq_info', 'date_rule_id','numeric null'
go


update liq_info SET date_rule_id = date_rule.date_rule_id 
from date_rule where date_rule.date_rule_name =liq_info.date_rule
go


/* BZ 55036 */

UPDATE legal_entity 
SET version_num=0 
WHERE version_num is null
go

UPDATE book 
SET version_num=0 
WHERE version_num is null
go

UPDATE wfw_transition 
SET version_num=0 
WHERE version_num is null
go

UPDATE product_desc 
SET version_num=0 
WHERE version_num is null
go

UPDATE ps_event_cfg_name 
SET version_num=0 
WHERE version_num is null
go

UPDATE curve_underlying 
SET version_num=0 
WHERE version_num is null
go

UPDATE pricer_config 
SET version_num=0 
WHERE version_num is null
go

UPDATE liq_info 
SET version_num=0 
WHERE version_num is null
go

UPDATE acc_account 
SET version_num=0 
WHERE version_num is null
go

UPDATE currency_default 
SET version_num=0 
WHERE version_num is null
go

/* end */

insert into domain_values (name, value, description) select 'TerminationAssignee', value, description from domain_values where name = 'terminationAssignee'
delete from domain_values where name = 'terminationAssignee'
go
insert into trade_keyword (trade_id, keyword_name, keyword_value) select trade_id, 'TerminationAssignee', keyword_value from trade_keyword where keyword_name = 'terminationAssignee'
delete from trade_keyword where keyword_name = 'terminationAssignee'
go
insert into domain_values (name, value, description) select 'TerminationAssignor', value, description from domain_values where name = 'terminationAssignor'
delete from domain_values where name = 'terminationAssignor'
go
insert into trade_keyword (trade_id, keyword_name, keyword_value) select trade_id, 'TerminationAssignor', keyword_value from trade_keyword where keyword_name = 'terminationAssignor'
delete from trade_keyword where keyword_name = 'terminationAssignor'
go
insert into domain_values (name, value, description) select 'keyword.TerminationReason', value, description from domain_values where name = 'terminationReason'
delete from domain_values where name = 'terminationReason'
go
insert into trade_keyword (trade_id, keyword_name, keyword_value) select trade_id, 'TerminationReason', keyword_value from trade_keyword where keyword_name = 'terminationReason'
delete from trade_keyword where keyword_name = 'terminationReason'
go
delete from domain_values where name = 'keyword.terminationReason'
go
delete from domain_values where value = 'keyword.terminationReason'
go
delete from domain_values where value = 'terminationReason'
go
delete from domain_values where name = 'terminationAssignee'
go
delete from domain_values where value = 'terminationAssignee'
go
delete from domain_values where name = 'terminationAssignor'
go
delete from domain_values where value = 'terminationAssignor'
go

/* BZ 40050 */
add_domain_values 'AllocationSupported','CancellableSwap','' 
go
add_domain_values 'AllocationSupported','CancellableXCCySwap','' 
go
add_domain_values 'AllocationSupported','XCCySwap','' 
go
add_domain_values 'AllocationSupported','CapFloor','' 
go
add_domain_values 'AllocationSupported','CappedSwap','' 
go
add_domain_values 'AllocationSupported','ExoticCapFloor','' 
go
add_domain_values 'AllocationSupported','ExtendibleSwap',''
go
add_domain_values 'AllocationSupported','FRA',''
go
add_domain_values 'AllocationSupported','SingleSwapLeg',''
go
add_domain_values 'AllocationSupported','Swap',''
go
add_domain_values 'AllocationSupported','Swaption',''
go
add_domain_values 'AllocationSupported','NDS',''
go
add_domain_values 'AllocationSupported','SpreadCapFloor',''
go

/* BZ 40050 end */



update domain_values set description='Price is taken from the first Forward Point date which is greater than the closest upcoming First Delivery Date' where name='commodity.ForwardPriceMethods' and value='NearbyNonDelivered'
go

/* BZ 55036 */
UPDATE book SET version_num=0 WHERE version_num IS NULL
go
UPDATE currency_default SET version_num=0 WHERE version_num IS NULL
go
UPDATE currency_pair SET version_num=0 WHERE version_num IS NULL
go
UPDATE curve_underlying SET version_num=0 WHERE version_num IS NULL
go
UPDATE holiday_code SET version_num=0 WHERE version_num IS NULL
go
UPDATE le_attribute SET version_num=0 WHERE version_num IS NULL
go
UPDATE le_contact SET version_num=0 WHERE version_num IS NULL
go
UPDATE le_settle_delivery SET version_num=0 WHERE version_num IS NULL
go
UPDATE legal_entity SET version_num=0 WHERE version_num IS NULL
go
UPDATE liq_info SET version_num=0 WHERE version_num IS NULL
go
UPDATE netting_method SET version_num=0 WHERE version_num IS NULL
go
UPDATE pricer_config SET version_num=0 WHERE version_num IS NULL
go
UPDATE product_desc SET version_num=0 WHERE version_num IS NULL
go
UPDATE ps_event_cfg_name SET version_num=0 WHERE version_num IS NULL
go
UPDATE quote_value SET version_num=0 WHERE version_num IS NULL
go
UPDATE rate_index SET version_num=0 WHERE version_num IS NULL
go
UPDATE rate_index_default SET version_num=0 WHERE version_num IS NULL
go
UPDATE wfw_transition SET version_num=0 WHERE version_num IS NULL
go
/* BZ 55036 end */

/* BZ 57987 */

sp_rename 'product_els.auto_adj_swp_not_b', auto_adj_swp_notional
go

/* end */

/*BZ 52825*/
update product_cdsnthloss set amort_type='None'
go
/* end BZ 52825*/

/*BZ 58120*/

if not exists (select 1 from sysobjects where name='option_observation_method')
begin 
exec ('create table option_observation_method (product_id  numeric not null ,   usage varchar(16) not null, observation_type varchar(32) not null,   version numeric not null,  value float null, multiplier  float null,  in_out_processor_type varchar(32) null, schedule_id numeric null, is_ov_basis numeric null,  basis float  null,  constraint ct_primarykey primary key (product_id, usage))')
end
go

update option_observation_method set observation_type='SPOT' where observation_type='SpotObservationMethod'
go
update option_observation_method set observation_type='FWD_START' where observation_type='ForwardStartingObservationMethod'
go
update option_observation_method set observation_type='FORMULA' where observation_type='ProcessorObservationMethod'
go
update option_observation_method set observation_type='CONST' where observation_type='ConstantObservationMethod'
go

/*end*/

/*  BZ 37789  */
add_column_if_not_exists 'le_settle_delivery','reference', 'varchar(64) null'
go
UPDATE le_settle_delivery SET reference = convert(varchar,sdi_id) WHERE reference IS NULL
go
add_column_if_not_exists 'manual_sdi' ,'reference', 'varchar(64) null'
go
UPDATE manual_sdi SET reference = convert(varchar,sdi_id) WHERE reference IS NULL
go

/*  BZ 56506  */

UPDATE referring_object SET rfg_tbl_join_cols = 'prd_sd_filter_name' WHERE rfg_obj_id = 11
go

delete from referring_object where rfg_obj_id=601  
go
INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (601, 1, 'sched_task_attr', 'task_id', '1', 'attr_value', 'attr_name IN (''SD_FILTER'', ''STATIC DATA FILTER'', ''TRANSFER_FILTER'', ''SD Filter'', ''Xfer SD Filter'', ''Msg SD Filter'')', 'ScheduledTask', 'apps.refdata.ScheduledTaskWindow', 'Scheduled Task - Attributes')
go

delete from referring_object where rfg_obj_id=602
go
INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (602, 2, 'sched_task_attr', 'task_id', '1', 'attr_value', 'attr_name IN (''OTC Trade Filter'')', 'ScheduledTask', 'apps.refdata.ScheduledTaskWindow', 'Scheduled Task - Attributes')
go

delete from referring_object where rfg_obj_id=501
go

INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (501, 2, 'entity_attributes', 'entity_id', '1', 'attr_value', 'entity_attributes.attr_name = ''TRADE_FILTER'' AND entity_attributes.entity_type = ''ReportTemplate''', 'ReportTemplate', 'apps.reporting.ReportWindow', 'ReportTemplate attribute')
go

delete from referring_object where rfg_obj_id=502
go
INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (502, 1, 'entity_attributes', 'entity_id', '1', 'attr_value', 'entity_attributes.attr_name = ''SdFilter'' AND entity_attributes.entity_type = ''ReportTemplate''', 'ReportTemplate', 'apps.reporting.ReportWindow', 'ReportTemplate attribute')
go

delete from referring_object where rfg_obj_id=503
go
INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (503, 3, 'entity_attributes', 'entity_id', '1', 'attr_value', 'entity_attributes.attr_name = ''FilterSet'' AND entity_attributes.entity_type = ''ReportTemplate''', 'ReportTemplate', 'apps.reporting.ReportWindow', 'ReportTemplate attribute')
go

/*  BZ58682*/

/* BZ 55036 - populate classes of classAuditMode in domainValue for product */
update trade set quantity = 1 where product_id in (select product_id FROM product_pm_depo_lease (parallel 5) where deposit_lease_type=1)
go
update trade set quantity = -1 where product_id in (select product_id FROM product_pm_depo_lease (parallel 5) where deposit_lease_type=2)
go

/* BZ 55036 - Add classes to classAuditMode */

add_domain_values 'classAuditMode','CA',''
go
add_domain_values 'classAuditMode','CDSABSIndexDefinition',''
go
add_domain_values 'classAuditMode','CDSIndexDefinition',''
go
add_domain_values 'classAuditMode','CFD',''
go
add_domain_values 'classAuditMode','CollateralPool',''
go
add_domain_values 'classAuditMode','Commodity',''
go
add_domain_values 'classAuditMode','CommodityCertificate',''
go
add_domain_values 'classAuditMode','Equity',''
go
add_domain_values 'classAuditMode','EquityIndex',''
go
add_domain_values 'classAuditMode','ETO',''
go
add_domain_values 'classAuditMode','ExoticConfigurableTypeI',''
go
add_domain_values 'classAuditMode','Future',''
go
add_domain_values 'classAuditMode','FutureOption',''
go
add_domain_values 'classAuditMode','FX',''
go
add_domain_values 'classAuditMode','Holding',''
go
add_domain_values 'classAuditMode','Issuance',''
go
add_domain_values 'classAuditMode','Loan',''
go
add_domain_values 'classAuditMode','MarketIndex',''
go
add_domain_values 'classAuditMode','MMDiscount',''
go
add_domain_values 'classAuditMode','MMInterest',''
go
add_domain_values 'classAuditMode','PositionCash',''
go
add_domain_values 'classAuditMode','UnitizedFund',''
go
add_domain_values 'classAuditMode','Warrant',''
go
/* BZ 55036 */

/*BZ 59278*/

if not exists (select 1 from sysobjects where name='cds_addl_provisions')
begin
exec('create table cds_addl_provisions (product_id numeric not null, provision_name varchar(128) not null , constraint ct_primarykey primary key (product_id, provision_name))')
end
go
add_column_if_not_exists 'product_cds', 'matrix_id','numeric null'
go

if not exists (select 1 from sysobjects where name='matrix_addl_provisions')
begin
exec ('create table matrix_addl_provisions (matrix_id numeric not null, provision_name varchar(128) not null , constraint ct_primarykey primary key (matrix_id))')
end
go

insert into cds_addl_provisions(product_id, provision_name)
select product_cds.product_id, matrix_addl_provisions.provision_name
from matrix_addl_provisions, product_cds (parallel 5) 
where product_cds.matrix_id=matrix_addl_provisions.matrix_id
go

add_column_if_not_exists 'cds_settlement_matrix','period_start','datetime default ''03/07/2005 0:00:00.000'' NOT NULL'
go

add_column_if_not_exists 'product_cds', 'market_standard_b', 'numeric default 0 NOT NULL'
go

update product_cds set market_standard_b=1 where product_cds.matrix_id > 0
go

/*end BZ 59278*/
/* cal-241462 --merge into 14.3*/
if  exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'option_formula'
        and syscolumns.name = 'formula_id' )
begin
    exec ('select * into  option_formula_back10 from option_formula')
	exec ('alter table option_formula add product_id numeric null')
	exec ('update option_formula set product_id = (select product_id from product_eq_struct_option 
where payoff_formula_id=option_formula.formula_id)')
end
go
/* end cal-241462 */
/*58840*/
if not exists (Select 1 from sysobjects where name='option_formula')
begin
exec ('create table option_formula (product_id numeric not null, formula_type varchar(32) not null,
version numeric not null , is_call numeric null , nparameter float null , sparameter varchar(32) null,
constraint ct_primarykey primary key (product_id))')
end
go

UPDATE option_formula SET formula_type = 'VANILLA' WHERE formula_type='VanillaFormula'
go
UPDATE option_formula SET formula_type = 'VANILLA_BASKET' WHERE formula_type='VanillaBasketPayoffFormula'
go
UPDATE option_formula SET formula_type = 'CASH_OR_NOTHING' WHERE formula_type='CashOrNothingFormula'
go
UPDATE option_formula SET formula_type = 'ASSET_OR_NOTHING' WHERE formula_type='AssetOrNothingFormula'
go
UPDATE option_formula SET formula_type = 'RAINBOW' WHERE formula_type='RainbowPayoffFormula'
go
UPDATE option_formula SET formula_type = 'CLIQUET' WHERE formula_type='CliquetPayoffFormula'
go
UPDATE option_formula SET formula_type = 'EXSP' WHERE formula_type='EXSPOptionFormula'
go
UPDATE option_formula SET formula_type = 'COMPOUND' WHERE formula_type='CompoundFormula'
go
UPDATE option_formula SET formula_type = 'CHOOSER' WHERE formula_type='ChooserFormula'
go

/* BZ 59630 */
 

/* BZ 59766 */

add_column_if_not_exists 'rate_index', 'rate_index_id', 'INT NULL'
go

Select currency_code, rate_index_code, rate_index_tenor, rate_index_source,id_col=identity(10) into #tmp_bal from rate_index
go

Update rate_index set rate_index_id = #tmp_bal.id_col+1000 from #tmp_bal 
where rate_index.currency_code = #tmp_bal.currency_code
and rate_index.rate_index_code = #tmp_bal.rate_index_code 
and rate_index.rate_index_tenor = #tmp_bal.rate_index_tenor 
and rate_index.rate_index_source = #tmp_bal.rate_index_source
go

DELETE FROM calypso_seed WHERE seed_name = 'RATE_INDEX'
go

begin 
declare @new_id int 
select @new_id= max(rate_index_id)+1 from rate_index
if @new_id=NULL
return 
INSERT INTO calypso_seed(last_id, seed_name, seed_alloc_size) values (@new_id ,'RATE_INDEX', 100)
end 
go

ALTER TABLE rate_index MODIFY rate_index_id INT NOT NULL
go
EXEC drop_pk_if_exists 'rate_index'
go
ALTER TABLE rate_index ADD CONSTRAINT ct_primarykey  PRIMARY KEY (rate_index_id)
go
ALTER TABLE rate_index ADD CONSTRAINT UNIQUE_RATE_INDEX UNIQUE (currency_code, rate_index_code, rate_index_tenor, rate_index_source)
go
drop table #tmp_bal
go

/* BZ 59775 */
if not exists (select 1 from sysobjects where name='task_priority_time')
begin 
exec('create table task_priority_time ( task_priority_id  numeric null ,  priority numeric null, time  varchar(64) not null,  holidays  varchar(128) null, timezone varchar(128) null , absolute_b numeric default 0 not null, dateroll varchar(16) not null , 
check_holiday_b numeric null )')
end
go
add_column_if_not_exists 'task_priority_time', 'task_priority_time_id', 'INT NULL'
go
Select task_priority_id, priority,id_col=identity(10) into #tmp_bal from task_priority_time
go

Update task_priority_time set task_priority_time_id = #tmp_bal.id_col+1000 from #tmp_bal 
where task_priority_time.task_priority_id = #tmp_bal.task_priority_id
and task_priority_time.priority = #tmp_bal.priority 

go

DELETE FROM calypso_seed WHERE seed_name = 'TaskPriorityTime'
go

begin 
declare @new_id int 
select @new_id= max(task_priority_time_id)+1 from task_priority_time
if @new_id=NULL
return 
INSERT INTO calypso_seed(last_id, seed_name, seed_alloc_size) values (@new_id ,'TaskPriorityTime', 100)
end 
go

ALTER TABLE task_priority_time MODIFY task_priority_time_id INT NOT NULL
go
EXEC drop_pk_if_exists 'task_priority_time'
go
ALTER TABLE task_priority_time ADD CONSTRAINT ct_primarykey PRIMARY KEY (task_priority_time_id)
go
ALTER TABLE task_priority_time MODIFY task_priority_id INTEGER NULL
go
ALTER TABLE task_priority_time MODIFY priority INTEGER NULL
go
drop table #tmp_bal
go

/* BZ 59777 */
add_column_if_not_exists 'product_bond', 'rate_index_id', 'int NULL'
go



UPDATE product_bond
SET rate_index_id = rate_index.rate_index_id FROM rate_index 
WHERE product_bond.rate_index = (rate_index.currency_code + '/' + rate_index.rate_index_code + '/' + 
convert(varchar(10),rate_index.rate_index_tenor) + '/' + rate_index.rate_index_source)                                   
go

add_column_if_not_exists 'product_bond', 'notional_index_id', 'INT NULL'
go


UPDATE product_bond
SET notional_index_id =rate_index.rate_index_id 
from rate_index
WHERE product_bond.notional_index =  (rate_index.currency_code + '/' + rate_index.rate_index_code + '/' + convert(varchar(10),rate_index.rate_index_tenor) + '/' + rate_index.rate_index_source)
go


/* BZ 59837 */
/* create a new table to hold the date rule in sequence mapping */

alter table date_rule_in_seq add constraint date_rule_in_seq_pk primary key (date_rule_id, seq_number)
go

/* lets split up our comma-separated list of date_rules_in_seq into seperate rows */
if exists (select 1 from sysobjects where name ='sp_date_rule_in_seq' and type='P')
begin
exec ('drop procedure sp_date_rule_in_seq')
end
go

create procedure sp_date_rule_in_seq
as
declare @date_rule_id int
declare @seq int
declare @first_dash int
declare @second_dash int
declare @date_rule_in_seq varchar(255)
declare @current_date_rule_in_seq varchar(255)
declare date_rule_in_seq_crsr cursor
for
select date_rule_id, substring(date_rules_in_seq, 2, len(date_rules_in_seq) - 1)
from date_rule where lower(date_rules_in_seq) <> 'none'
open date_rule_in_seq_crsr
fetch date_rule_in_seq_crsr into @date_rule_id ,  @date_rule_in_seq 
while (@@sqlstatus=0)
begin
  select @seq = 0
  while (@date_rule_in_seq IS NOT NULL)
  begin
    select @current_date_rule_in_seq = substring(@date_rule_in_seq, 1, charindex(',', @date_rule_in_seq) - 1)
    select @first_dash = charindex('-', @current_date_rule_in_seq)
    select @second_dash = charindex('-', substring(@current_date_rule_in_seq, @first_dash + 1, len(@current_date_rule_in_seq))) + @first_dash
    insert into date_rule_in_seq(date_rule_id, seq_number, num, tenor_type, orig_date_rule, is_date)
    values(@date_rule_id,
           @seq,
           convert(int, substring(@current_date_rule_in_seq, @first_dash + 1, @second_dash - @first_dash - 1)),
           substring(@current_date_rule_in_seq, @second_dash + 1, len(@current_date_rule_in_seq)),
           convert(int, substring(@current_date_rule_in_seq, 1, charindex('-', @current_date_rule_in_seq) - 1)),
           0)
    select @date_rule_in_seq = substring(@date_rule_in_seq, len(@current_date_rule_in_seq) + 2, len(@date_rule_in_seq))
    select @seq = @seq + 1
  end
 
  fetch date_rule_in_seq_crsr into @date_rule_id ,  @date_rule_in_seq
end
update date_rule_in_seq set is_date = 1 where tenor_type = '[Dates]'
commit
close date_rule_in_seq_crsr
deallocate cursor date_rule_in_seq_crsr
go

exec sp_date_rule_in_seq
go

/* backup the date_rule table before we drop he column containing the old date_rules format */

select * into date_rule_bak11 from date_rule
go

/* BZ 59774 */
/* Create the new PK constraint*/

EXEC drop_pk_if_exists 'acc_statement_cfg'
go

/* checking the duplicate if exists then remove */

if exists (select 1 from acc_limit_cfg group by account_id,active_from,active_to,minimum,maximum having count(*)>1)
begin
exec ('select * into acc_limit_cfg_back from acc_limit_cfg where 1=0')
exec('create unique index idx_limit_dup on acc_limit_cfg_back(account_id,active_from,active_to,minimum,maximum) with ignore_dup_key')
exec ('insert acc_limit_cfg_back  select * from acc_limit_cfg')
exec('delete from acc_limit_cfg')
exec('insert acc_limit_cfg select * from acc_limit_cfg_back')
exec('drop table acc_limit_cfg_back')
end
go 

/* Make ACCOUNT_ID column null */
ALTER TABLE acc_statement_cfg MODIFY account_id INT NULL 
go
/* Creates the new numeric Id for table acc_limit_cfg */
add_column_if_not_exists 'acc_limit_cfg','acc_limit_cfg_id', 'INT NULL'
go
/* sql to initialize the new column */
Select account_id ,id_col=identity(10) into #tmp_bal from acc_limit_cfg
go

Update acc_limit_cfg set acc_limit_cfg_id = #tmp_bal.id_col+1000 from #tmp_bal 
where acc_limit_cfg.account_id = #tmp_bal.account_id
go

DELETE FROM calypso_seed WHERE seed_name = 'accountLimit'
go

begin 
declare @new_id int 
select @new_id= max(acc_limit_cfg_id)+1 from acc_limit_cfg
if @new_id=NULL
return 
INSERT INTO calypso_seed(last_id, seed_name, seed_alloc_size) values (@new_id ,'accountLimit', 100)
end 
go

/* Make ID column not null, add new PK and remove old one */ 
ALTER TABLE acc_limit_cfg
MODIFY acc_limit_cfg_id INT NOT NULL
go
ALTER TABLE acc_limit_cfg ADD CONSTRAINT ct_primarykey PRIMARY KEY (acc_limit_cfg_id)
go
/* Make ACCOUNT_ID column null */
ALTER TABLE acc_limit_cfg
MODIFY account_id INT NULL
go

drop table #tmp_bal
go
/*Table acc_account_interest. Make ACCOUNT_ID column null */
ALTER TABLE acc_account_interest
MODIFY account_id INT NULL
go

/*end*/

/* BZ 59375 */
UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureFXRate' WHERE measure_id = 339 
go


UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureCumulativeCash' WHERE measure_name = 'CUMULATIVE_CASH'
go

/* BZ 60050 */


/* BZ 59777 */


UPDATE product_bond
SET rate_index_id = rate_index.rate_index_id from rate_index 
WHERE product_bond.rate_index =  str_replace(substring(rate_index.quote_name, charindex('.', rate_index.quote_name) + 1, len(rate_index.quote_name)), '.', '/')
go

update product_bond
set notional_index_id = rate_index.rate_index_id from rate_index 
WHERE product_bond.notional_index =  str_replace(substring(rate_index.quote_name, charindex('.', rate_index.quote_name) + 1, len(rate_index.quote_name)), '.', '/')
go

/* BZ 59781 */
add_column_if_not_exists 'cash_flow_simple', 'rate_index_id', 'INT NULL'
go
add_column_if_not_exists 'cash_flow_simple','interp_index_id', 'INT NULL'
go
alter table cash_flow_simple
replace fixed_rate_b default '1'
GO
alter table cash_flow_simple
replace manual_reset_b default '0'
GO
alter table cash_flow_simple
replace interpolated_b default '0'
GO
alter table cash_flow_simple
replace manual_amt_b default '0'
GO
alter table cash_flow_simple
replace basis_convert_b default '0'
GO
alter table cash_flow_simple
replace manual_fx_rate_b default '0'
GO

/* BZ 59769 */
add_column_if_not_exists 'recon_inven_row' ,'recon_inven_row_id', 'INT NULL'
go

Select run_name, run_date, agent_id, account_id, underlyer_key, book_id ,id_col=identity(10) into #tmp_bal from recon_inven_row
go

Update recon_inven_row set recon_inven_row_id = #tmp_bal.id_col+1000 from #tmp_bal 
where recon_inven_row.run_name = #tmp_bal.run_name
and recon_inven_row.run_date = #tmp_bal.run_date
and recon_inven_row.agent_id = #tmp_bal.agent_id 
and recon_inven_row.account_id = #tmp_bal.account_id 
and recon_inven_row.underlyer_key = #tmp_bal.underlyer_key
and recon_inven_row.book_id=#tmp_bal.book_id
go

DELETE FROM calypso_seed WHERE seed_name = 'BOInventoryReconciliation'
go

begin 
declare @new_id int 
select @new_id= max(recon_inven_row_id)+1 from recon_inven_row
if @new_id=NULL
return 
INSERT INTO calypso_seed(last_id, seed_name, seed_alloc_size) values (@new_id ,'BOInventoryReconciliation', 100)
end 
go

ALTER TABLE recon_inven_row MODIFY recon_inven_row_id INT NOT NULL
go
EXEC drop_pk_if_exists 'recon_inven_row'
go
ALTER TABLE recon_inven_row ADD CONSTRAINT ct_primarykey PRIMARY KEY (recon_inven_row_id)
go
ALTER TABLE recon_inven_row MODIFY run_name VARCHAR(64) NULL
go
ALTER TABLE recon_inven_row MODIFY run_date datetime  NULL
go
drop table #tmp_bal
go



/* BZ 59767 */
if exists (select 1 from sysobjects where name='sp_upd_balpos')
begin
exec('DROP PROC sp_upd_balpos')
end
go

CREATE PROCEDURE sp_upd_balpos(
	    @account_id        numeric,
        @currency_code     varchar(3),
        @date_type         varchar(16),
        @position_date     datetime,
        @total_amount       float,
        @change             float,
        @security_id       numeric)
AS
UPDATE balance_position
SET total_amount = @total_amount,change = @change
WHERE position_date = @position_date AND
        account_id = @account_id AND
        date_type= @date_type AND
        currency_code = @currency_code

IF (@@rowcount = 0)
    INSERT INTO  balance_position(account_id ,date_type,position_date,
        currency_code,total_amount,change,security_id )
    VALUES(@account_id ,@date_type,@position_date,
        @currency_code,@total_amount,@change,@security_id)
go

exec sp_procxmode 'sp_upd_balpos', 'anymode'
go

/* 60269 */
ALTER TABLE sched_task MODIFY pricer_measures varchar(2000)
go

/* BZ 60050 */
add_column_if_not_exists 'product_ps' ,'primary_leg_id','INTEGER NULL'
go
UPDATE product_ps
SET primary_leg_id = (SELECT MAX(product_id) FROM perf_swap_leg (parallel 5) WHERE perf_swap_id = product_ps.product_id AND leg_id = 1)
go
add_column_if_not_exists 'product_ps' ,'secondary_leg_id','INTEGER NULL'
go
UPDATE product_ps
SET secondary_leg_id = (SELECT MAX(product_id) FROM perf_swap_leg (parallel 5) WHERE perf_swap_id = product_ps.product_id AND leg_id = 2)
go
/* 59709 */
add_column_if_not_exists 'inv_secpos_hist','total_repo_track_in','float null'
go
add_column_if_not_exists 'inv_secpos_hist','daily_repo_track_in' ,'float null'
go
add_column_if_not_exists 'inv_secpos_hist','total_repo_track_out' ,'float null'
go
add_column_if_not_exists 'inv_secpos_hist',' daily_repo_track_out' ,'float null'
go

/* BZ 60723 */


UPDATE calypso_cache SET eviction = 'LRU' WHERE eviction = 'PerishableLRU'
go

/* BZ 59997 */

DELETE FROM domain_values WHERE name = 'plMeasure' AND value = 'Translation_PL'
go
DELETE FROM domain_values WHERE name = 'plMeasure' AND value = 'Translation_Risk'
go


select * into trigger_info_bak from trigger_info
go

UPDATE trigger_info
SET trigger_index_id = (SELECT rate_index_id FROM rate_index R 
                     WHERE trigger_info.trigger_index =  str_replace(substring(R.quote_name, charindex('.', R.quote_name) + 1, len(R.quote_name)), '.', '/')
					 )
WHERE trigger_index IS NOT NULL
go
ALTER TABLE trigger_info
DROP trigger_index
go

/* BZ 61223 */ 
add_column_if_not_exists 'cash_flow_option','payoff_factor','float null'
go

/* BZ 60723 */

select * into product_fx_order_bak FROM product_fx_order
go
add_column_if_not_exists 'product_fx_order','base_currency', 'VARCHAR(3) null' 
go
add_column_if_not_exists 'product_fx_order' ,'quote_currency', 'VARCHAR(3) null'
go

UPDATE product_fx_order SET base_currency = substring(currency_pair, 1, charindex('/', currency_pair) - 1), quote_currency = substring(currency_pair, charindex('/', currency_pair) + 1, len(currency_pair) - charindex('/', currency_pair)) WHERE currency_pair IS NOT NULL
go

ALTER TABLE product_fx_order 
DROP currency_pair
go

/* BZ 60723 */

EXEC drop_pk_if_exists 'fxorder_ex_entry'
go
ALTER TABLE fxorder_ex_entry ADD CONSTRAINT PK_FXORDER_EX_ENTRY PRIMARY KEY (id)
go

/* end */

/* BZ 60936 */

add_column_if_not_exists 'fee_definition', 'is_allocated','numeric default 0 not null'
go

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'PREMIUM'
go

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'SPOT_MARGIN'
go

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'FAR_MARGIN'
go

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'UPFRONT_FEE'
go

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'FXOPT_MARGIN'
go

/* BZ 61702 */
add_column_if_not_exists 'master_confirmation', 'type','varchar(255) NULL'
go


UPDATE master_confirmation SET type ='ANY' WHERE type IS NULL
go

/* end */



sp_rename 'basic_prod_keyword.product_id', basic_product_id
go

add_column_if_not_exists 'basic_prod_keyword', 'product_id', 'INT default 0 not NULL' 
go
add_column_if_not_exists 'basic_prod_keyword','sub_id', 'INT default 0 not NULL'
go 

if exists (select 1 from sysobjects where name = 'basic_prod_keyword_bak' and  type='U') 
begin
  exec('drop table basic_prod_keyword_bak') 
end 
go 

select * into basic_prod_keyword_bak from basic_prod_keyword
go

EXEC drop_pk_if_exists 'basic_prod_keyword'
go

DELETE FROM basic_prod_keyword  WHERE  product_id is NULL AND sub_id is NULL 
go


INSERT INTO basic_prod_keyword (basic_product_id, keyword_name, keyword_value, product_id, sub_id)
                (SELECT p.basic_product_id, k.keyword_name, k.keyword_value, p.product_id, p.sub_id
                 FROM basic_product p INNER JOIN basic_prod_keyword_bak k  (parallel 5) ON p.basic_product_id = k.basic_product_id) 
go

/* end */


/*BZ 62766 */ 

UPDATE observable SET rel_exch = substring(rel_exch,2, len(rel_exch) - 2)
go
/*end*/

/* BZ 63318 */
add_column_if_not_exists 'product_structured_option_bc','product_id','int default 0 not null'
go

DELETE FROM product_structured_option_bc WHERE product_id = 0 
go

/* end */

/*BZ 63194 */
EXEC drop_unique_if_exists 'credit_event'
go

add_column_if_not_exists 'credit_event', 'protocol_type', 'varchar(32) null'
go

update credit_event set protocol_type='Calypso' where protocol_type is null
go

alter table credit_event modify protocol_type VARCHAR(32) not null
go

/*end*/


/*BZ 62734 */
UPDATE pricer_measure SET measure_class_name='tk.core.PricerMeasure' WHERE measure_class_name='tk.pricer.PricerMeasure'
go
/*end*/


/*BZ 63022*/
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('UPFRONT_PCT','tk.core.PricerMeasure',386)
go

INSERT INTO pricing_param_name (param_name, param_type, param_domain, param_comment, is_global_b, default_value)
VALUES ('UPFRONT_PCT_FIX_CPN', 'com.calypso.tk.core.Spread', '', 'Fixed Coupon Spread for calculating Upfront Rate', 1, '500')
go
/*end*/

/* BZ 63654 */
UPDATE advice_config
  SET template_name=STR_REPLACE(template_name, '_Submit', '')
  WHERE address_method='DTCC'
go

UPDATE advice_document
  SET template_name=STR_REPLACE(template_name, '_Submit', '')
  WHERE address_method='DTCC'
go

UPDATE domain_values
  SET value=STR_REPLACE(value, '_Submit', '')
  WHERE name='DTCC.Templates'
go

UPDATE bo_message
  SET template_name=STR_REPLACE(template_name, '_Submit', '')
  WHERE address_method='DTCC'
go

UPDATE bo_message_hist
  SET template_name=STR_REPLACE(template_name, '_Submit', '')
  WHERE address_method='DTCC'
go

UPDATE advice_doc_hist
  SET template_name=STR_REPLACE(template_name, '_Submit', '')
  WHERE address_method='DTCC'
go

/*end*/

UPDATE pricer_measure set measure_class_name = 'tk.pricer.PricerMeasureHistoBS' where measure_name = 'HISTO_BS' and measure_id = 374
go

/* BZ 63374 */
UPDATE pricer_measure SET measure_id = 316 WHERE measure_name = 'ACCRUAL_BS'
go
UPDATE pricer_measure SET measure_id = 313 WHERE measure_name = 'LIQUIDATION_EFFECT'
go
UPDATE pricer_measure SET measure_id = 309 WHERE measure_name = 'CUMULATIVE_CASH'
go
UPDATE pricer_measure SET measure_id = 311 WHERE measure_name = 'CUMULATIVE_CASH_INTEREST'
go
UPDATE pricer_measure SET measure_id = 312 WHERE measure_name = 'CUMULATIVE_CASH_FEES'
go
UPDATE pricer_measure SET measure_id = 315 WHERE measure_name = 'IMPLIED_IN_RANGE'
go

UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureHistoricalAccrualBO' WHERE measure_name = 'HISTO_ACCRUAL_BO'
go

UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledCash'
WHERE measure_name='HISTO_UNSETTLED_CASH'
go

UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureHistoricalCumulativeCash'
WHERE measure_name='HISTO_CUMUL_CASH_INTEREST'
go

/* BZ 63843 */

UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledCash' WHERE measure_name = 'HISTO_UNSETTLED_FEES'
go
UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledCash' WHERE measure_name = 'FEES_UNSETTLED'
go


DELETE domain_values WHERE name = 'plMeasure' AND value = 'Accrual_FX_Reeval'
go 
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Cash_FX_Reeval'
go
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Clean_Realized_FX_Reeval'
go
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Paydown_FX_Reeval'
go
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Realized_Accrual_FX_Reeval'
go
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Realized_FX_Reeval'
go
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Unrealized_FX_Reeval'
go
DELETE domain_values WHERE name = 'plMeasure' AND value = 'UnsettledCash_FX_Reeval'
go

/* end */

/* BZ:63397  */
add_column_if_not_exists 'option_deliverable', 'eto_contract_id', 'numeric(38) null'
go

update option_deliverable
set option_deliverable.eto_contract_id = option_deliverable.calc_offset where option_deliverable.deliverable_type = 'CONTRACT ADJUSTMENT' and exists (select 1 from eto_contract where eto_contract.contract_id =
option_deliverable.calc_offset)
go

update option_deliverable set calc_offset=0 where eto_contract_id is not null
go


/* end */

/* BZ 64724 */

UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledFees' WHERE measure_name = 'HISTO_UNSETTLED_FEES'
go
UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledFees' WHERE measure_name = 'FEES_UNSETTLED'
go
UPDATE pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledFees' WHERE measure_name = 'FEES_UNSETTLED_SD'
go

/* end */

/* BZ 56618 Add sales_margin to the Cash products */
/* scripts to move the keywords into the product and fix audit etries */
/* for SimpleMM, Cash, CallNotice,  live and history tables */  


if exists (select 1 from sysobjects where name ='unlocalize' and type='P')
begin
exec ('drop procedure unlocalize')
end
go

create procedure unlocalize 
@str varchar(64), @res varchar(64) output
as
begin declare @last_sep_char_pos integer, @i integer, @sep_char char(1)
select @i=0, @last_sep_char_pos = 0
while @i<len(@str)
begin
   select @i = @i+1
   if (substring(@str, @i, 1) = '.') or (substring(@str, @i, 1) = ',')  
       select @last_sep_char_pos = @i
end
if @last_sep_char_pos = 0 
  begin
  select @res = @str
  return
  end

select @sep_char = substring(@str, @last_sep_char_pos, 1)

if (@sep_char = '.') 
  select @res = str_replace(substring(@str, 1, @last_sep_char_pos-1), ',', null) + '.' + substring(@str,@last_sep_char_pos+1, len(@str)-@last_sep_char_pos)
else 
  select @res = str_replace(substring(@str, 1, @last_sep_char_pos-1), '.', null) + '.' + substring(@str,@last_sep_char_pos+1, len(@str)-@last_sep_char_pos)
end
go

exec sp_procxmode 'unlocalize', 'anymode'
go

if exists (select 1 from sysobjects where name ='string_to_spread' and type='P')
begin
exec ('drop procedure string_to_spread')
end
go

create procedure string_to_spread @str VARCHAR(255), @result float output as
BEGIN
  declare @str2 varchar(255)
  exec unlocalize @str, @str2 output
  select @result = convert(float, @str2) / 10000.0
END 
go

exec sp_procxmode 'string_to_spread', 'anymode'
go

add_column_if_not_exists 'product_simple_mm', 'sales_margin', 'float default 0 not null' 
go
add_column_if_not_exists 'product_cash','sales_margin', 'float default 0 not null' 
go
add_column_if_not_exists 'product_call_not','sales_margin',  'float default 0 not null '
go
add_column_if_not_exists 'prd_smp_mm_hist ',' sales_margin','  float default 0 not null' 
go
add_column_if_not_exists 'product_cash_hist ',' sales_margin  ','float default 0 not null' 
go
add_column_if_not_exists 'product_call_not_hist ',' sales_margin ',' float default 0 not null'
go


if exists (select 1 from sysobjects where name ='migrate_simplemm_sales_margin' and type='P')
begin
exec ('drop procedure migrate_simplemm_sales_margin')
end
go

create PROCEDURE migrate_simplemm_sales_margin AS
BEGIN
  DECLARE c1 cursor for  
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_simple_mm, trade , trade_keyword
      WHERE trade.product_id = product_simple_mm.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c2 cursor for  
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_cash, trade , trade_keyword
      WHERE trade.product_id = product_cash.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c3 cursor for  
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_call_not, trade , trade_keyword
      WHERE trade.product_id = product_call_not.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin'
      
      
  DECLARE c1h cursor for  
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM prd_smp_mm_hist, trade_hist, trade_keyword_hist
      WHERE trade_hist.product_id = prd_smp_mm_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c2h cursor for  
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM product_cash_hist, trade_hist , trade_keyword_hist
      WHERE trade_hist.product_id = product_cash_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c3h cursor for  
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM product_call_not_hist, trade_hist , trade_keyword_hist
      WHERE trade_hist.product_id = product_call_not_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin'

  declare     @nonlocalized_sales_margin varchar(255)
  declare     @margin float
  declare @product_id int, @trade_id int, @keyword_value varchar(255)
  BEGIN
     /* live tables: move current keyword value into product field */
    open c1
    fetch c1 into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_simple_mm set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c1 into @product_id, @trade_id, @keyword_value
    end
    close c1
    deallocate cursor c1
    
    
    open c2
    fetch c2 into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_cash set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c2 into @product_id, @trade_id, @keyword_value
    end
    close c2
    deallocate cursor c2
    
    
    open c3
    fetch c3 into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_call_not set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c3 into @product_id, @trade_id, @keyword_value
    end
    close c3
    deallocate cursor c3

    /* fix audit entries */


    declare @entity_id int, @version_num int
    declare @entity_class_name varchar(255), @entity_field_name varchar(255)
    declare @modif_date datetime
    declare c1a cursor for
      select  old_value, new_value,
              entity_id, 
              entity_class_name, entity_field_name,
              modif_date, version_num
      from bo_audit 
      where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade t, product_desc pd 
          where t.trade_id = bo_audit.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )

    declare @old varchar(255), @new varchar(255), @entity_field_nam varchar(255)
    declare @tmp_o float, @tmp_n float
    open c1a
    fetch c1a into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    while   (@@sqlstatus=0)
    begin
      exec string_to_spread @old, @tmp_o output
      exec string_to_spread @new, @tmp_n output
      update bo_audit
        /* can't update the entity_field_name here since it would close the cursor... */
        set 
        field_type = 'double',
        old_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_o, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end,
        new_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_n, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end
        where entity_id = @entity_id 
          and entity_class_name = @entity_class_name
          and entity_field_name = @entity_field_name
          and modif_date = @modif_date
          and version_num = @version_num

      fetch c1a into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    end
    close c1a
    deallocate c1a

   /* now update the entity_field_name */
    update bo_audit 
      set  entity_field_name = 'Product._salesMargin'
    where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade t, product_desc pd 
          where t.trade_id = bo_audit.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )
  end
  
  /* and now the same for the history tables */
  
  
    open c1h
    fetch c1h into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update prd_smp_mm_hist set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword_hist where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c1h into @product_id, @trade_id, @keyword_value
    end
    close c1h
    deallocate cursor c1h
    
    
    open c2h
    fetch c2h into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_cash_hist set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword_hist where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c2h into @product_id, @trade_id, @keyword_value
    end
    close c2h
    deallocate cursor c2h
    
    
    open c3h
    fetch c3h into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_call_not_hist set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword_hist where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c3h into @product_id, @trade_id, @keyword_value
    end
    close c3h
    deallocate cursor c3h

    /* fix audit entries */


    declare c1ah cursor for
      select  old_value, new_value,
              entity_id, 
              entity_class_name, entity_field_name,
              modif_date, version_num
      from bo_audit_hist 
      where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade_hist t, product_desc_hist pd 
          where t.trade_id = bo_audit_hist.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )

    open c1ah
    fetch c1ah into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    while   (@@sqlstatus=0)
    begin
      exec string_to_spread @old, @tmp_o output
      exec string_to_spread @new, @tmp_n output
      update bo_audit_hist
        /* can't update the entity_field_name here since it would close the cursor... */
        set 
        field_type = 'double',
        old_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_o, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end,
        new_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_n, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end
        where entity_id = @entity_id 
          and entity_class_name = @entity_class_name
          and entity_field_name = @entity_field_name
          and modif_date = @modif_date
          and version_num = @version_num

      fetch c1ah into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    end
    close c1ah
    deallocate c1ah

   /* now update the entity_field_name */
    update bo_audit_hist
      set  entity_field_name = 'Product._salesMargin'
    where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade_hist t, product_desc_hist pd 
          where t.trade_id = bo_audit_hist.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )
  
end
go

exec sp_procxmode 'migrate_simplemm_sales_margin', 'anymode'
go


if not exists (select 1 from sysobjects where name = 'trade_keyword_bak_bz56618' and type='U')
begin
    exec ('select * into trade_keyword_bak_bz56618 from trade_keyword where keyword_name = ''SalesMargin''')
end
go

if not exists (select 1 from sysobjects where name = 'trade_keyword_hist_bak_bz56618' and type='U')
begin
    exec ('select * into trade_keyword_hist_bak_bz56618 from trade_keyword_hist where keyword_name = ''SalesMargin''')
end
go

if not exists (select 1 from sysobjects where name = 'bo_audit_bak_bz56618' and type='U')
begin
    exec ('select * into bo_audit_bak_bz56618 from bo_audit where entity_class_name =''Trade'' and entity_field_name in (''ADDKEY#SalesMargin'', ''DELKEY#SalesMargin'', ''MODKEY#SalesMargin'')')
end
go

if not exists (select 1 from sysobjects where name = 'bo_audit_hist_bak_bz56618' and type='U')
begin
    exec ('select * into bo_audit_hist_bak_bz56618 from bo_audit_hist where entity_class_name =''Trade'' and entity_field_name in (''ADDKEY#SalesMargin'', ''DELKEY#SalesMargin'', ''MODKEY#SalesMargin'')')
end
go


exec migrate_simplemm_sales_margin
go

/* BZ 56618 end */

/* BZ 58718 */

update trade_open_qty set return_date = end_date from product_pledge, trade where product_family='Repo' and product_type='Pledge' and return_date is null and end_date is not null and product_pledge.product_id = trade.product_id and trade.trade_id = trade_open_qty.trade_id
go
/* end */ 

/* BZ 64937: Duplicate PLMeasure names for unsettled cash fx reval */ 

DELETE domain_values WHERE name='plMeasure' AND value='UnsettledCash_FX_Reval'
go

/* end */

/* BZ 63506 */

delete from domain_values where name = 'riskAnalysis'
and value in ('Benchmark', 'Comparison', 'DefaultAggregation', 'ExposureWeight', 'FIProfitability', 'HistoricalCrossAsset', 'MTM', 'NetAssetValue', 'PredictPL', 'PredictPLPre', 'WeightedPricing', 'FOPosition')
go

delete from an_viewer_config where analysis_name  in ('Benchmark', 'Comparison', 'DefaultAggregation', 'ExposureWeight', 'FIProfitability', 'HistoricalCrossAsset', 'MTM', 'NetAssetValue', 'PredictPL', 'PredictPLPre', 'WeightedPricing', 'FOPosition')
go


delete from domain_values where name = 'riskPresenter'
and value in ('Benchmark', 'WeightedPricing')
go
/* end */

/*BZ 64042 */

DELETE FROM domain_values WHERE name = 'riskAnalysis' AND value IN ('FAS133', 'Accrual', 'Security', 'SecurityAccrual', 'CFDPL')
go
DELETE FROM an_viewer_config WHERE analysis_name IN ('FAS133', 'Accrual', 'Security', 'SecurityAccrual', 'CFDPL')
go

/* end */

/* BZ 65204 */
DELETE FROM domain_values WHERE  name = 'interpolator3D' AND value = 'FXVolInterpolator'
go
/* end */

/* BZ 62911 */
if not exists(select 1 from sysobjects where name like 'analysis_output_perm')
begin
exec ('create table analysis_output_perm 
(id numeric not null ,
created_date  datetime null,  
analysis_type varchar(64) null,
param_config_name varchar(32) null,pages numeric not null,
complete numeric not null, Constraint ct_primarykey primary key (id))')
end
go
update an_service_set_elements set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update an_viewer_config set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update analysis_output_perm set analysis_type='Simulation'
where analysis_type='ScenarioSlide'
go
update analysis_output set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update analysis_output_hist set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update analysis_param set class_name='com.calypso.tk.risk.SimulationParam'
where class_name='com.calypso.tk.risk.ScenarioSlideParam'
go
update an_param_item_mul set class_name='com.calypso.tk.risk.SimulationParam'
where class_name='com.calypso.tk.risk.ScenarioSlideParam'
go
update an_param_items set class_name='com.calypso.tk.risk.SimulationParam'
where class_name='com.calypso.tk.risk.ScenarioSlideParam'
go
update risk_config_item set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update risk_on_demand_item set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update risk_presenter_item set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update risk_shortcuts set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update tws_risk_node set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
if not exists (select 1 from sysobjects where name='risk_presenter_def_view_cfg')
begin
exec('create table risk_presenter_def_view_cfg
(template_id numeric not null, 
analysis_name varchar(64) not null,
param_name varchar(32) not null,
template_id_drill_down numeric null,
constraint ct_primarykey primary key (analysis_name,param_name))')
end
go

update risk_presenter_def_view_cfg set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
go
update domain_values set value='Simulation'
where value='ScenarioSlide'
go

update an_service_set_elements set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update an_viewer_config set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update analysis_output_perm set analysis_type='Sensitivity'
where analysis_type='ScenarioFORiskPosition'
go
update analysis_output set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update analysis_output_hist set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update analysis_param set class_name='com.calypso.tk.risk.SensitivityParam'
where class_name='com.calypso.tk.risk.ScenarioFORiskPositionParam'
go
update an_param_item_mul set class_name='com.calypso.tk.risk.SensitivityParam'
where class_name='com.calypso.tk.risk.ScenarioFORiskPositionParam'
go
update an_param_items set class_name='com.calypso.tk.risk.SensitivityParam'
where class_name='com.calypso.tk.risk.ScenarioFORiskPositionParam'
go
update risk_config_item set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update risk_on_demand_item set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update risk_presenter_item set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update risk_shortcuts set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update tws_risk_node set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update risk_presenter_def_view_cfg set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
go
update domain_values set value='Sensitivity'
where value='ScenarioFORiskPosition'
go
/* end */
/* BZ:65173 */
DELETE FROM pricing_param_name where param_name='INTG_MTHD_CR'
go
INSERT INTO pricing_param_name(param_name,param_type,param_domain,param_comment,is_global_b,display_name,default_value) values('INTG_MTHD_CR','java.lang.String','ANALYTIC_JPM,LINEAR_SINGLE,SIMPSON,EXACT','Credit integration method, specifying the numerical method for summing credit event probability over the course of a cashflow period.',1,'INTG_MTHD_CR','LINEAR_SINGLE')
go
/* end */

/* BZ:64870 */


ALTER TABLE pricing_param_name  MODIFY display_name VARCHAR(255) NULL
go


/* BZ 60536 */

delete from domain_values
where name = 'riskAnalysis'
and value in
('EquityOptGammaSlide',
 'EquityOptOpenPosBlotter',
 'EquityOptSpotSlide',
 'EquityOptTradeBlotter',
 'EquityOptTradeDrillDownBlotter',
 'EquityOptVegaSlide',
 'EquityOptVolatilitySlide',
 'Shift',
 'ScenarioHedge',
 'ScenarioSensitivity',
 'SensitivityHedge',
 'SimpleSensitivity',
 'VARHistoric',
 'VolatilityRisk',
 'XMLReport')
go

delete from an_viewer_config
where analysis_name in
('EquityOptGammaSlide',
 'EquityOptOpenPosBlotter',
 'EquityOptSpotSlide',
 'EquityOptTradeBlotter',
 'EquityOptTradeDrillDownBlotter',
 'EquityOptVegaSlide',
 'EquityOptVolatilitySlide',
 'Shift',
 'ScenarioHedge',
 'ScenarioSensitivity',
 'SensitivityHedge',
 'SimpleSensitivity',
 'VARHistoric',
 'VolatilityRisk',
 'XMLReport')
go

delete from domain_values
where name = 'ScenarioViewerClassNames'
and value in
('ScenarioInflationFixingReportViewer',
 'ScenarioSeasonalityRiskViewer')
go

/* end BZ 60536 */

/* BZ 65305 */

delete from domain_values
where name = 'riskAnalysis'
and value in
('BondHedge',
 'BucketHedge',
 'CommodityHedge',
 'Hedge',
 'ScenarioCommodity',
 'ScenarioRiskPosition',
 'ScenarioTaylorSeriesInput',
 'SyntheticHedge',
 'ValueAdded')
go

delete from domain_values
where name = 'riskPresenter'
and value in
('BondHedge',
 'BucketHedge',
 'CommodityHedge',
 'Hedge',
 'ScenarioCommodity',
 'ScenarioRiskPosition',
 'ScenarioTaylorSeriesInput',
 'SyntheticHedge',
 'ValueAdded')
go

/* end BZ 65305 */

/* BZ 64294 */

update trade
set t.trade_currency = t.settle_currency
from trade t, product_pm_depo_lease p 
where t.product_id = p.product_id
and t.trade_currency <> t.settle_currency
go

/* end */
/* BZ:65474 */
if exists (select 1 from sysobjects where name='dts_data_source')
begin
exec ('select * into dts_data_source_bak from dts_data_source')
exec ('drop table dts_data_source')
end
go


if exists(select 1 from	sysobjects where name='dts_field_mask')
begin
exec ('select * into dts_field_mask_bak from dts_field_mask')
exec ('drop table dts_field_mask')
end
go

if exists(select 1 from sysobjects where name='dts_field_type')
begin
exec ('select * into dts_field_type_bak from dts_field_type')
exec('drop table dts_field_type')
end
go

if exists(select 1 from sysobjects where name='dts_rec_data_hist')
begin
exec ('select * into dts_rec_data_hist_bak from dts_rec_data_hist')
exec('drop table dts_rec_data_hist')
end
go

if exists(select 1 from sysobjects where name='dts_rec_hist')
begin
exec ('select * into dts_rec_hist_bak from dts_rec_hist')
exec ('drop table dts_rec_hist')
end
go

if exists(select 1 from sysobjects where name='dts_rec_msgs_hist')
begin
exec ('select * into dts_rec_msgs_hist_bak from dts_rec_msgs_hist')
exec('drop table dts_rec_msgs_hist')
end
go

if exists(select 1 from sysobjects where name='dts_record')
begin
exec ('select * into dts_record_bak from dts_record')
exec ('drop table dts_record')
end
go

if exists(select 1 from sysobjects where name='dts_record_data')
begin
exec ('select * into dts_record_data_bak from dts_record_data')
exec('drop table dts_record_data')
end
go

if exists(select 1 from sysobjects where name='dts_record_msgs')
begin
exec ('select * into dts_record_msgs_bak from dts_record_msgs')
exec('drop table dts_record_msgs')
end
go

/* end */

/* BZ:58821 */

Update pricing_param_name set default_value = null where param_name = 'HESTON_DRIFT'
go
Update pricing_param_name set default_value = null where param_name = 'HESTON_MEAN_VAR'
go
Update pricing_param_name set default_value = null where param_name = 'HESTON_VAR_REV_SPEED'
go
Update pricing_param_name set default_value = null where param_name = 'HESTON_VOL_VOL'
go
Update pricing_param_name set default_value = null where param_name = 'HESTON_CORR'
go
/* end */

/* BZ:65036 */
/* Tables created in calypso version 1010 and deleted in calypso version 1010
* These tables are not used anymore.
*/
if exists(select 1 from sysobjects where name='tws_workspace_tf')
begin
exec('DROP TABLE tws_workspace_tf')
end
go

if exists(select 1 from sysobjects where name='tws_workspace_tf_crit')
begin
exec('DROP TABLE tws_workspace_tf_crit')
end
go

if exists(select 1 from sysobjects where name='tws_workspace_an_param')
begin
exec('DROP TABLE tws_workspace_an_param')
end
go
if exists(select 1 from sysobjects where name='tws_workspace_an_param_items')
begin
exec('DROP TABLE tws_workspace_an_param_items')
end
go

/* end */

/* BZ: 63396 */ 

update bo_audit 
set old_value = convert(varchar(216),version_num),
entity_field_name = entity_field_name + '_' + convert (varchar(216),version_num)
where entity_class_name = 'LegalEntity' 
and entity_field_name like 'REMOVE_%' 
and old_value is null
go

update bo_audit set version_num =  0
where bo_audit.entity_class_name = 'LegalEntity' 
and bo_audit.entity_field_name like 'REMOVE_%' 
and bo_audit.old_value = convert(varchar(216),bo_audit.version_num)
and not exists 
(
select * from bo_audit ss (parallel 5) 
where ss.entity_class_name =  bo_audit.entity_class_name 
and ss.entity_id = bo_audit.entity_id 
and ss.entity_field_name not like 'REMOVE_%' 
and ss.entity_field_name not like 'CREATE_%' 
and ss.entity_field_name not like 'MODIFY_%' 
and ss.modif_date <= bo_audit.modif_date
)
go

update bo_audit 
set version_num = 
(
select max(ms.version_num) 
from bo_audit ms  (parallel 5) 
where ms.entity_class_name = bo_audit.entity_class_name 
and ms.entity_id = bo_audit.entity_id 
and ms.entity_field_name not like 'REMOVE_%'
and modif_date = 
( 
select max(ss.modif_date)
from bo_audit ss  (parallel 5)
where
ss.entity_class_name = bo_audit.entity_class_name and
ss.entity_id = bo_audit.entity_id and
ss.entity_field_name not like 'REMOVE_%' and
ss.entity_field_name not like 'CREATE_%' and
ss.entity_field_name not like 'MODIFY_%' and
ss.modif_date <= bo_audit.modif_date
)
)
where
bo_audit.entity_class_name = 'LegalEntity' and
bo_audit.entity_field_name like 'REMOVE_%' and
bo_audit.old_value = convert(varchar(216),bo_audit.version_num)
go

/* end */

/* BZ 64964, 64199 */
DELETE domain_values WHERE name = 'plMeasure'
go

/* BZ:56529 */
ALTER TABLE pc_param MODIFY pricer_name VARCHAR(64) NOT NULL
go

/* end */

/* BZ  65466 */ 
delete from domain_values where name = 'riskAnalysis' and value in ('CashFlow', 'CashFlowLadder','CashLiquidity','FXCashPosition','FwdLadderRisk','FXMatrix',
'FXPL','FXSensitivity')
go

delete from an_viewer_config where analysis_name  in ('CashFlow', 'CashFlowLadder', 'CashLiquidity')
go
/* end */ 
/* BZ:65775 */

add_column_if_not_exists 'risk_runner_config','is_shared', 'numeric default 0 not null'
go
add_column_if_not_exists 'presentation_config','is_shared','numeric default 0 not null'
go
/* end */


DELETE pricer_measure WHERE measure_name = 'HISTO_ACCRUAL'
go

/*  JIRA   66971 */

delete from domain_values where name = 'riskPresenter' and value in ('Benchmark', 'Comparison', 'WeightedPricing')
go

/*  JIRA   67116 */
DELETE FROM pricer_measure WHERE measure_name ='TRADING_DAYS' and measure_id = 206
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('TRADING_DAYS','tk.core.PricerMeasure',206)
go
/* CAL-67682 */
UPDATE bo_audit_fld_map  SET field_name='_bookId'  WHERE display_name='Book' and field_name='_book'
go
/* end */
/* CAL-68198 */
    if not exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'wfw_transition'
        and syscolumns.name = 'gen_int_event_b' )
begin
exec ('alter table wfw_transition add  gen_int_event_b numeric null')
end
go
/*end */
/* CAL-63156 */ 
 if exists (select 1 from sysobjects where name='fxtrade_proc')
begin
exec('drop proc fxtrade_proc')
end
go
create procedure fxtrade_proc
as
begin
declare @Name VARCHAR(255)
declare @PName VARCHAR(255)
declare @SName int
 
declare fxtrade_crsr cursor
 for
    
    select distinct name from fx_trades_alloc
 
     open fxtrade_crsr
     fetch fxtrade_crsr into @Name
     
     while (@@sqlstatus=0)
    begin 
       declare @c int 
       select @c=count(*) from percent_alloc_rule where name= @Name
       select @c 
       select @@sqlstatus
       if (@c >0 ) 
	 begin
	     select @PName='FX_' + @Name  
	     select @PName
	 end 
       else
	 begin
	     select @PName= @Name
	     select @PName
         end 
		update calypso_seed set last_id=last_id+1 where seed_name='AllocationRule'
		select @SName=last_id from calypso_seed where seed_name='AllocationRule'
     if (@SName=NULL)
     		begin
 
			declare @plid int
			declare @elid int
			select @plid=max(rule_id) from percent_alloc_rule 
			select @elid=max(rule_id) from percent_alloc_rule_element
			if (@plid > @elid)
			begin
 				insert into calypso_seed values (@plid+1,'AllocationRule',100)
				insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values(@plid+1,@PName,'UpgradeScript',0)
			end
			else 
			if (@elid > @plid)
			begin
 				insert into calypso_seed values (@elid+1,'AllocationRule',100)
				insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values(@elid+1,@PName,'UpgradeScript',0)
			end
			else
			if (@elid= NULL and @plid =NULL)
			begin
 				insert into calypso_seed values (1000,'AllocationRule',100)
				insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values(1000,@PName,'UpgradeScript',0)
			end
		end
	else
	begin
		insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values(@SName,@PName,'UpgradeScript',0)
	end 
     fetch fxtrade_crsr into @Name
end
  close fxtrade_crsr
 deallocate cursor fxtrade_crsr
 end


go

exec fxtrade_proc
go
drop proc fxtrade_proc
go

add_column_if_not_exists 'fx_trades_alloc', 'book_id', 'numeric default 0 not null'
go

if exists (select 1 from sysobjects where name='fxtradeele_proc')
begin
exec('drop proc fxtradeele_proc')
end
go

create proc fxtradeele_proc
as
begin
declare @le_role varchar(255)
	declare @le_id int , @name varchar(255)
	declare @amt float , @book_id int 
	declare @lid int , @ruid int
declare fxtradele_crsr cursor 
for
	select name,le_role,le_id,amount,book_id from fx_trades_alloc

	
open fxtradele_crsr
fetch fxtradele_crsr  into  @name, @le_role, @le_id , @amt, @book_id
	while (@@sqlstatus=0)
	begin	
 		select @ruid=max(rule_id) from percent_alloc_rule where name= @name or name='FX_' + @name
		update calypso_seed set last_id=last_id+1 where seed_name='AllocationRule'
		select @lid=last_id from calypso_seed where seed_name='AllocationRule'
		 if (@lid=NULL)
     		begin
 
			declare @plid int
			declare @elid int
			select @plid=max(rule_id) from percent_alloc_rule 
			select @elid=max(rule_id) from percent_alloc_rule_element
			if (@plid > @elid)
			begin
 				insert into calypso_seed values (@plid+1,'AllocationRule',100)
				insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id, percent) 
		values (@plid+1, @ruid, @le_role, @le_id, @book_id, @amt)
			end
			else 
			if (@elid > @plid)
			begin
 				insert into calypso_seed values (@elid+1,'AllocationRule',100)
				insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id, percent) 
		values (@elid+1, @ruid, @le_role, @le_id, @book_id, @amt)
			end
			else
			if (@elid= NULL and @plid =NULL)
			begin
 				insert into calypso_seed values (1000,'AllocationRule',100)
				insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id, percent) 
		values (1000, @ruid, @le_role, @le_id, @book_id, @amt)
			end
		end
		else
		begin
		insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id, percent) 
		values (@lid, @ruid, @le_role, @le_id, @book_id, @amt)
		end
fetch fxtradele_crsr  into @name, @le_role, @le_id , @amt, @book_id
end
close fxtradele_crsr
deallocate cursor fxtradele_crsr
end
go

exec fxtradeele_proc
go
drop procedure fxtradeele_proc
go

/* diff as of version 1.850.2.5 */

INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Simulation', 'apps.risk.SimulationViewer', 0 )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Sensitivity', 'apps.risk.SensitivityViewer', 0 )
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'CAMoneyDiff Book', 'To create simple transfer trade for CA money diff ' )
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'DayChangeRule', 'For supporting FX day change market convnetion  ' )
go
add_domain_values 'domainName', 'FXLinked.DoNotPropagateAction', 'This domain name is used in FXLinked workflow' 
go
add_domain_values 'domainName', 'FXLinked.PropagateAction', 'This domain name is used in FXLinked workflow to indicate actions that need be carried over to the linked trade.' 
go
add_domain_values   'FXLinked.PropagateAction', 'CANCEL', 'The CANCEL on the original FX trade will be carried over as CANCEL on the linked FX trade.' 
go
add_domain_values   'FXLinked.PropagateAction', 'RATERESET', 'The RATERESET on the original FX trade will be carried over as RATERESET on the linked FX trade.' 
go
add_domain_values   'ForwardLadderProduct', 'FXNDFSwap', '' 
go
add_domain_values   'eco_pl_column', 'CMD_RESET_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CMD_FWD_CURVE_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CMD_FWD_CURVE_EFFECT_PAY_LEG', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CMD_FWD_CURVE_EFFECT_REC_LEG', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CMD_BASIS_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CMD_BASIS_EFFECT_PAY_LEG', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CMD_BASIS_EFFECT_REC_LEG', 'Column implemented by PLCalculator' 
go
add_domain_values   'workflowRuleMessage', 'HandleCashPooling', '' 
go
add_domain_values   'domainName', 'ProductSelectorTypes.Repo', 'This domain contains available product types displayed in the TradeRepoWindow Product chooser' 
go
add_domain_values   'ProductSelectorTypes.Repo', 'Bond', '' 
go
add_domain_values   'ProductSelectorTypes.Repo', 'Equity', '' 
go
add_domain_values   'domainName', 'ProductSelectorTypes.MarginCall', 'This domain contains available product types displayed in the MarginCall Product chooser' 
go
add_domain_values   'ProductSelectorTypes.MarginCall', 'Bond', '' 
go
add_domain_values   'ProductSelectorTypes.MarginCall', 'Equity', '' 
go
add_domain_values   'domainName', 'riskIssuerAttributes', 'Issuer attributes to be included in sensitivy and simulation analyses' 
go
add_domain_values   'commodity.ForwardPriceMethods', 'NearbyNonDelivered', 'Price is taken from the first Forward Point date which is greater than the closest upcoming First Delivery Date' 
go
add_domain_values   'BOPositionFilter', 'MarginCallIneligibleFilter', '' 
go
add_domain_values   'domainName', 'AccountTransferKeywords', 'Used to copy TradeKeyword from a CustomerTransfer IC Trade.' 
go
add_domain_values   'sdiAttribute', 'PayOnly', '' 
go
add_domain_values   'MsgAttributes', 'LegType', 'For an FXSwap or FXNDFSwap, "Near" or "Far"' 
go
add_domain_values   'domainName', 'MsgAttributes.LegType', 'List of Leg Types for FXSwap and FXNDFSwap (Near, Far)' 
go
add_domain_values   'MsgAttributes.LegType', 'Near', 'Message for near leg' 
go
add_domain_values   'MsgAttributes.LegType', 'Far', 'Message for far leg' 
go
add_domain_values   'domainName', 'MsgAttributes.CashStatementProcess', 'List of Cash Statement Type' 
go
add_domain_values   'MsgAttributes', 'CashStatementProcess', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'Statement', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'SubStatement.BankFee', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'SubStatement.CashPooling', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'SubStatement.CashPoolingPF', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'SubStatement.CashSweeping', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'SubStatement.Nostro', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'SubStatement.PivotPoolingPF', '' 
go
add_domain_values   'MsgAttributes.CashStatementProcess', 'Unknown', '' 
go
add_domain_values   'domainName', 'keyword.CashStatementProcess', 'List of Cash Statement Linked Trade' 
go
add_domain_values   'keyword.CashStatementProcess', 'Automatic CashPooling', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'Automatic CashPooling PF', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'PivotPooling PF', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'Manual CashPooling', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'Manual CashPooling PF', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'Automatic BankFee', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'Automatic CashSweeping', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'AutoFXConsolidation', '' 
go
add_domain_values   'keyword.CashStatementProcess', 'AutoZeroDebitBalance', '' 
go
add_domain_values   'domainName', 'CashStatement.AgentRegExp.BARCGB22', 'Regexp for BARC' 
go
add_domain_values   'CashStatement.AgentRegExp.BARCGB22', 'First', '[0-9a-zA-Z -?/:().,''+]*ACCOUNT +([0-9]+)' 
go
add_domain_values   'MsgAttributes', 'ConfType', 'For an FXNDF or FXNDFSwap, "Opening" or "Fixing"' 
go
add_domain_values   'domainName', 'MsgAttributes.ConfType', 'List of Confirmation Types for FXNDF and FXNDFSwap (Opening, Fixing)' 
go
add_domain_values   'MsgAttributes.ConfType', 'Opening', 'Opening Confirmation' 
go
add_domain_values   'MsgAttributes.ConfType', 'Fixing', 'Fixing Confirmation' 
go
add_domain_values   'tradeTmplKeywords', 'DisplayOptionStyle', 'use for FXOption' 
go
add_domain_values   'leAttributeType', 'DEFAULT_BOOK', '' 
go
add_domain_values   'leAttributeType', 'DEFAULT_CPTY', '' 
go
add_domain_values   'leAttributeType', 'OptionF_PartyId', '' 
go
add_domain_values   'leAttributeType', 'OptionF_DateOfBirth', '' 
go
add_domain_values   'leAttributeType', 'OptionF_PlaceOfBirth', '' 
go
add_domain_values   'leAttributeType', 'OptionF_CustomerId', '' 
go
add_domain_values   'leAttributeType', 'OptionF_NationalId', '' 
go
add_domain_values   'domainName', 'cdsSettlementConditions', '' 
go
add_domain_values   'cdsSettlementConditions', 'Section 3.9 of the Definitions shall be excluded', '' 
go
add_domain_values   'cdsSettlementConditions', 'Section 3.3 will be amended by replacing "GMT" with "Tokyo time"', '' 
go
add_domain_values   'engineParam', 'SAVE_SETTLE_POSITION_CHANGES', 'Audit the updates to the settle positions. Position Snapshots rely on the history information captured.' 
go
add_domain_values   'classAuthMode', 'HedgeRelationship', '' 
go
add_domain_values   'classAuthMode', 'HedgeStrategy', '' 
go
add_domain_values   'function', 'CreateSystemPLMark', '' 
go
add_domain_values   'StatementType', 'Incoming', '' 
go
add_domain_values   'engineEventPoolPolicyAliases', 'Inventory', 'tk.util.TransferInventorySequencePolicy' 
go
add_domain_values   'engineEventPoolPolicyAliases', 'Liquidation', 'tk.util.TradeLiquidationSequencePolicy' 
go
add_domain_values   'engineEventPoolPolicies', 'tk.util.TransferInventorySequencePolicy', 'Sequence Policy for the InventoryEngine (optional)' 
go
add_domain_values   'engineEventPoolPolicies', 'tk.util.TradeLiquidatoinSequencePolicy', 'Sequence Policy for the LiquidatiinEngine (optional)' 
go
add_domain_values   'classAuditMode', 'HedgeRelationship', '' 
go
add_domain_values   'classAuditMode', 'HedgeStrategy', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Other', '' 
go
add_domain_values   'domainName', 'DividendSwap.Pricer', 'Pricer dividendSwap' 
go
add_domain_values   'domainName', 'SkewSwap.Pricer', 'Pricer skewSwap' 
go
add_domain_values   'domainName', 'FXNDFSwap.Pricer', 'Pricers for FX NDF swaps' 
go
add_domain_values   'CorrelationSurface.gen', 'BaseCorrelationLPM', 'Base Correlation Surface generator using the Large Homogeneous Pool Model' 
go
add_domain_values   'correlationType', 'EquityBasket', 'Allow input of Equity/EquityIndex/FX correlation matrix' 
go
add_domain_values   'domainName', 'fxRateResetAction', 'Trade Actions available on the FX Rate Reset Window' 
go
add_domain_values   'fxRateResetAction', 'RATERESET', 'Rate reset action on the FX Rate Reset Window' 
go
add_domain_values   'domainName', 'SpeedButton.Types', '' 
go
add_domain_values   'SpeedButton.Types', 'Risk', 'Risk Analysis Speed Buttons' 
go
add_domain_values   'SpeedButton.Types', 'Trade', 'Trade Entry Speed Buttons' 
go
add_domain_values   'domainName', 'FASAccountingMethod', 'FASAccountingMethod' 
go
add_domain_values   'domainName', 'hedgeStrategyAttributes', 'hedgeStrategyAttributes' 
go
add_domain_values   'domainName', 'hedgeStrategyStandard', 'hedgeStrategyStandard' 
go
add_domain_values   'domainName', 'relativeDifferenceMethodCriticalValue', 'relativeDifferenceMethodCriticalValue' 
go
add_domain_values   'FASAccountingMethod', 'Change In Variable Cashflows', 'Change In Variable Cashflows' 
go
add_domain_values   'FASAccountingMethod', 'Change In Fair Value', 'Change In Fair Value' 
go
add_domain_values   'FASAccountingMethod', 'Hypothetical Derivative', 'Hypothetical Derivative' 
go
add_domain_values   'FASAccountingMethod', 'ShortCut', 'ShortCut' 
go
add_domain_values   'FASAccountingMethod', 'Matched Terms', 'Matched Terms' 
go
add_domain_values   'hedgeStrategyStandard', 'FAS', 'FAS' 
go
add_domain_values   'hedgeStrategyStandard', 'IAS', 'IAS' 
go
add_domain_values   'hedgeStrategyAttributes', 'De-designation Fee', 'De-designation Fee' 
go
add_domain_values   'hedgeStrategyAttributes', 'Check List Template', 'Check List Template' 
go
add_domain_values   'FASEffMethodPro', 'Matched Terms', 'Matched Terms'
go
add_domain_values   'FASEffMethodPro', 'ShortCut', 'ShortCut' 
go
add_domain_values   'FASEffMethodRetro', 'Matched Terms', 'Matched Terms' 
go
add_domain_values   'FASEffMethodRetro', 'ShortCut', 'ShortCut' 
go
add_domain_values   'relativeDifferenceMethodCriticalValue', '0.03', 'Relative Difference Method' 
go
add_domain_values   'REPORT.Types', 'MarginCallConfig', 'MarginCall Config Report' 
go
add_domain_values   'REPORT.Types', 'MarginCallPosition', 'MarginCall Position Report' 
go
add_domain_values   'domainName', 'DividendSwap.subtype', 'DividendSwap subtypes' 
go
add_domain_values   'domainName', 'SkewSwap.subtype', 'SkewSwap subtypes' 
go
add_domain_values   'SingleSwapLeg.Pricer', 'PricerSingleSwapLegExotic', 'Demo pricer for Single Swap Leg for a class of exsp based legs' 
go
add_domain_values   'classAuditMode', 'CFDCountryGrid', '' 
go
add_domain_values   'classAuditMode', 'CFDContractDefinition', '' 
go
add_domain_values   'classAuditMode', 'UserWorkflowConfig', '' 
go
add_domain_values   'PositionBasedProducts', 'FXNDFSwap', 'FXNDFSwap out of box position based product' 
go
add_domain_values   'domainName', 'securityCode.ReprocessTrades', 'Security codes requiring to check for trades to be reprocessed when code value changes' 
go
add_domain_values   'XferAttributes', 'ExpectedStatus', '' 
go
add_domain_values   'XferAttributes', 'PreciousMetal-location', '' 
go
add_domain_values   'XferAttributes', 'PreciousMetal-allocation', '' 
go
add_domain_values   'domainName', 'XferMatchingAttributes', 'Xfer attributes to force full matching' 
go
add_domain_values   'domainName', 'keyword.TerminationReason', 'List of termination reason' 
go
add_domain_values   'domainName', 'TerminationAssignee', 'list of assignee' 
go
add_domain_values   'domainName', 'TerminationAssignor', 'list of assignor' 
go
add_domain_values   'keyword.TerminationReason', 'Assigned', '' 
go
add_domain_values   'keyword.TerminationReason', 'BookTransfer', '' 
go
add_domain_values   'keyword.TerminationReason', 'Manual', '' 
go
add_domain_values   'keyword.TerminationReason', 'BoughtBack', '' 
go
add_domain_values   'keyword.TerminationReason', 'NotionalIncrease', '' 
go
add_domain_values   'keyword.TerminationReason', 'ContractRevision', '' 
go
add_domain_values   'systemKeyword', 'RolledOverToIncrease', '' 
go
add_domain_values   'systemKeyword', 'RolledOverFromIncrease', '' 
go
add_domain_values   'systemKeyword', 'TerminationFullFirstCalculationPeriod', '' 
go
add_domain_values   'systemKeyword', 'keyword.TerminationReason', '' 
go
add_domain_values   'systemKeyword', 'Hedge', '' 
go
add_domain_values   'systemKeyword', 'IC Trade', '' 
go
add_domain_values   'systemKeyword', 'IC Transaction', '' 
go
add_domain_values   'volatilityType', 'Basket', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT940', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT950', '' 
go
add_domain_values   'tradeKeyword', 'RolledOverToIncrease', '' 
go
add_domain_values   'tradeKeyword', 'RolledOverFromIncrease', '' 
go
add_domain_values   'tradeKeyword', 'Instruction Code', '' 
go
add_domain_values   'tradeKeyword', 'CrossChecked', '' 
go
add_domain_values   'tradeKeyword', 'CashStatementProcess', '' 
go
add_domain_values   'tradeKeyword', 'FXConsolidation-LinkedTo', '' 
go
add_domain_values   'systemKeyword', 'FXConsolidation-LinkedTo', 'Id of the Cross Consolidation Trade' 
go
add_domain_values   'tradeKeyword', 'TradeSource', '' 
go
add_domain_values   'tradeKeyword', 'TargetAccountId', '' 
go
add_domain_values   'FX.keywords', 'PreciousMetal-location', '' 
go
add_domain_values   'FXSwap.keywords', 'PreciousMetal-location', '' 
go
add_domain_values   'FXForward.keywords', 'PreciousMetal-location', '' 
go
add_domain_values   'FXForward.keywords', 'PreciousMetal-allocation', '' 
go
add_domain_values   'FXSwap.keywords', 'PreciousMetal-allocation', '' 
go
add_domain_values   'FX.keywords', 'PreciousMetal-allocation', '' 
go
add_domain_values   'FX.keywords', 'PreciousMetal-deliveryDetails', '' 
go
add_domain_values   'FXForward.keywords', 'PreciousMetal-deliveryDetails', '' 
go
add_domain_values   'FXSwap.keywords', 'PreciousMetal-deliveryDetails', '' 
go
add_domain_values   'domainName', 'MT101.MAX', '' 
go
add_domain_values   'domainName', 'MT101.MIN', '' 
go
add_domain_values   'domainName', 'InventoryPositions', 'List of Positions in the Inv. Engine' 
go
add_domain_values   'FXSwap.keywords', 'PVMultiplier', '' 
go
add_domain_values   'FXForward.keywords', 'PVMultiplier', '' 
go
add_domain_values   'FXSpotReserve.keywords', 'PVMultiplier', '' 
go
add_domain_values   'FXTTM.keywords', 'PVMultiplier', '' 
go
add_domain_values   'FXNDF.keywords', 'PVMultiplier', '' 
go
add_domain_values   'FXOptionForward.keywords', 'PVMultiplier', '' 
go
add_domain_values   'scheduledTask', 'EOD_SYSTEM_PLMARKING', 'End of day system PL Marking.' 
go
add_domain_values   'messageType', 'SWIFT_TRADE_RECON', '' 
go
add_domain_values   'MESSAGE.Templates', 'SubsidiaryICStatement.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'SubsidiaryICInterestAdvice.html', '' 
go
add_domain_values   'userAttributes', 'FXForward Default Tenor', '' 
go
add_domain_values   'userAttributes', 'FXNDF Default Tenor', '' 
go
add_domain_values   'userAttributes', 'FXSwap Default Near Tenor', '' 
go
add_domain_values   'userAttributes', 'FXSwap Default Far Tenor', '' 
go
add_domain_values   'userAttributes', 'FXNDFSwap Default Near Tenor', '' 
go
add_domain_values   'userAttributes', 'FXNDFSwap Default Far Tenor', '' 
go
add_domain_values   'EquityStructuredOption.subtype', 'CLIQUET', 'CLIQUET option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'COMPOUND', 'COMPOUND option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'CHOOSER', 'CHOOSER option Product subtype' 
go
add_domain_values   'productType', 'DividendSwap', 'DividendSwap' 
go
add_domain_values   'productType', 'SkewSwap', 'SkewSwap' 
go
add_domain_values   'tradeKeyword', 'PreciousMetal-location', '' 
go
add_domain_values   'tradeKeyword', 'PreciousMetal-allocation', '' 
go
add_domain_values   'keyword.PreciousMetal-allocation', 'allocated', '' 
go
add_domain_values   'keyword.PreciousMetal-allocation', 'unallocated', '' 
go
add_domain_values   'tradeKeyword', 'PreciousMetal-deliveryDetails', '' 
go
add_domain_values   'keyword.PreciousMetal-deliveryDetails', 'CIF', '' 
go
add_domain_values  'domainName', 'transferCanceledStatus' ,''
go
add_domain_values   'DispatcherParamsDatasynapse', 'dontUseLocalCache', 'boolean' 
go

add_domain_values   'keyword.TerminationReason', 'Novation', '' 
go
add_domain_values   'classAuditMode', 'RefEntityObligations', '' 
go
add_domain_values   'userAccessPermAttributes', 'Max.Account', 'Type to be enforced by reports' 
go
add_domain_values   'userAccessPermAttributes', 'Max.PLMark', 'Type to be enforced by reports' 
go
add_domain_values   'workflowRuleTrade', 'CheckHedgeRelationship', '' 
go
add_domain_values   'workflowRuleTrade', 'Reject', '' 
go
add_domain_values   'workflowRuleTrade', 'SetKeywords', '' 
go
add_domain_values   'workflowRuleMessage', 'UpdateTrade', '' 
go
add_domain_values   'workflowRuleMessage', 'UpdateMessage', '' 
go
add_domain_values   'workflowRuleMessage', 'SetAttributes', '' 
go
add_domain_values   'tradeRejectAction', 'REJECT', 'to rebuild Previous trade version' 
go
add_domain_values   'messageAction', 'AUTOMATCH', 'AutoMatch' 
go
add_domain_values   'messageAction', 'MANUALMATCH', 'ManualMatch' 
go
add_domain_values   'ScenarioViewerClassNames', 'apps.risk.ScenarioVolSurfUnderlyingViewer', 'A viewer for perturbations on vol surface underlyings' 
go
add_domain_values   'accEventType', 'COT_RES_NEAR_LEG', '' 
go
add_domain_values   'accEventType', 'COT_RES_FAR_LEG', '' 
go
add_domain_values   'accountProperty', 'PaymentFactory', 'Boolean representing if account is a PaymentFactory' 
go
add_domain_values   'accountProperty', 'PayInterestOnly', 'False to receive interest' 
go
add_domain_values   'accountProperty', 'DTCPartAccountID', 'DTC Participant Number' 
go
add_domain_values   'domainName', 'accountProperty.PayInterestOnly', '' 
go
add_domain_values   'accountProperty.PayInterestOnly', 'False', '' 
go
add_domain_values   'accountProperty.PayInterestOnly', 'True', '' 
go
add_domain_values   'FeeBillingRuleAttributes', 'DefaultTransferType', '' 
go
add_domain_values   'FeeBillingRuleAttributes', 'DefaultBundleID', '' 
go
add_domain_values   'FeeBillingRuleAttributes', 'DefaultKWDAgent', '' 
go
add_domain_values   'CurveProbability.gen', 'ProbabilityIndex', 'Probability curve generator for CDSIndex' 
go
delete from domain_values where name= 'Swap.Pricer' and value='PricerExoticSwap'
go
add_domain_values   'Swap.Pricer', 'PricerExoticSwap', '' 
go
add_domain_values   'Bond.Pricer', 'PricerBondExotic', '' 
go
add_domain_values   'FXNDFSwap.Pricer', 'PricerFXNDFSwap', '' 
go
add_domain_values   'PLPositionProduct.Pricer', 'PricerPLPositionProductBond', 'PLPositionProduct Pricer' 
go
add_domain_values   'PLPositionProduct.Pricer', 'PricerPLPositionProductUnitizedFund', 'PLPositionProduct Pricer' 
go
add_domain_values   'FXOption.Pricer', 'PricerFXOptionAccrual', '' 
go
add_domain_values   'FXOption.Pricer', 'PricerFXOptionVanillaHeston', 'Heston model valuation of vanilla options' 
go
add_domain_values   'FXOption.Pricer', 'PricerFXOptionBarrierHestonMC', 'Heston model valuation of barrier options using Monte Carlo' 
go
add_domain_values   'FXOption.Pricer', 'PricerFXOptionBarrierHestonFD', 'Heston model valuation of barrier options using Finite Differences' 
go
add_domain_values   'FXOption.subtype', 'ACCRUAL', '' 
go
add_domain_values   'eventClass', 'PSEventProcessMessage', '' 
go
add_domain_values   'eventType', 'EX_SWIFT_BIC_IMPORT', '' 
go
add_domain_values   'eventType', 'EX_HEDGE_RELATIONSHIP', 'Exception Generated when a trade in hedge strategy is modified' 
go
add_domain_values   'exceptionType', 'HOLIDAYS_CHANGES', '' 
go
add_domain_values   'flowType', 'FORECAST', '' 
go
add_domain_values   'flowType', 'BANKFEE', '' 
go
add_domain_values   'flowType', 'CASHPOOLING', '' 
go
add_domain_values   'function', 'CreateRiskPresenterDefaultViewConfig', 'Access permission to create RiskPresenterDefaultViewConfig' 
go
add_domain_values   'function', 'RemoveRiskPresenterDefaultViewConfig', 'Access permission to remove RiskPresenterDefaultViewConfig' 
go
add_domain_values   'function', 'AddVisokioTemplate', 'Access permission to add a Visokio Template' 
go
add_domain_values   'function', 'RemoveVisokioTemplate', 'Access permission to remove a Visokio Template' 
go
add_domain_values   'exceptionType', 'SWIFT_BIC_IMPORT', '' 
go
add_domain_values   'exceptionType', 'HEDGE_RELATIONSHIP', '' 
go
add_domain_values   'flowType', 'MT950_ADJUSTMENT', '' 
go
add_domain_values   'function', 'CreateCallAccount', 'Access permission to Create Call Accounts' 
go
add_domain_values   'function', 'ModifyCallAccount', 'Access permission to Modify Call Accounts' 
go
add_domain_values   'function', 'ModifyPresentationServerConfig', 'Access permission to create/modify/delete PresentationServer Configuration.' 
go
add_domain_values   'function', 'CreatePresentationServerConfig', 'Function to authorize to create/modify PresentationServer config' 
go
add_domain_values   'function', 'RemovePresentationServerConfig', 'Function to authorize to remove PresentationServer config' 
go
add_domain_values   'function', 'UnlockMarks', 'Unlock P&L Marks' 
go
add_domain_values   'function', 'CreateHedgeRelationship', 'Access permission to create Hedge Relationship' 
go
add_domain_values   'function', 'ModifyHedgeRelationship', 'Access permission to modify Hedge Relationship' 
go
add_domain_values   'function', 'RemoveHedgeRelationship', 'Access permission to remove Hedge Relationship' 
go
add_domain_values   'function', 'MarginCallUncheckedPositions', 'Access permission to enable or disable the position check when doing margin call' 
go
add_domain_values   'marketDataUsage', 'ISDA_DIS', '' 
go
add_domain_values   'productType', 'FXNDFSwap', '' 
go
add_domain_values   'riskAnalysis', 'ForwardLadder', 'Cross Asset Forward Ladder Cash Analysis' 
go
add_domain_values   'riskAnalysis', 'OptionLifecycle', 'OptionLifecycle Analysis' 
go
add_domain_values   'riskAnalysis', 'Simulation', '' 
go
add_domain_values   'riskAnalysis', 'Sensitivity', '' 
go
add_domain_values   'SWIFT.Templates', 'MT101', '' 
go
add_domain_values   'scheduledTask', 'ADD_BROKERAGE_FEE', '' 
go
add_domain_values   'scheduledTask', 'INC_CASH_STATEMENT', '' 
go
add_domain_values   'scheduledTask', 'PROCESS_EXPIRY', 'Process Trades for expiry' 
go
add_domain_values   'scheduledTask', 'ACCOUNT_CONSOLIDATION', '' 
go
add_domain_values   'scheduledTask', 'CREATE_POSITION_SNAPSHOT', 'Creates positions snapshots for the defined snapshot date and time' 
go
add_domain_values   'tradeKeyword', 'TerminationFullFirstCalculationPeriod', '' 
go
add_domain_values   'tradeKeyword', 'CASource', '' 
go
add_domain_values   'tradeKeyword', 'CAClosing', '' 
go
add_domain_values   'tradeKeyword', 'Hedge', '' 
go
add_domain_values   'SWIFT.Templates', 'MT300CLSNonMemberPO', 'Foreign Exchange Confirmation for non-member Processing Organizations' 
go
add_domain_values   'SWIFT.Templates', 'MT304', 'Advice/Instruction of a Third Party Deal' 
go
add_domain_values   'SWIFT.Templates', 'MT304CLSNonMemberPO', 'Advice/Instruction of a Third Party Deal for non-member Processing Organizations' 
go
add_domain_values   'SWIFT.Templates', 'MT600', 'Precious Metal Confirmation' 
go
add_domain_values   'MESSAGE.Templates', 'fxndfconfirmation.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'fxndfswapconfirmation.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'fxndffixingconfirmation.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'fxndfswapfixingconfirmation.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'DividendSwapConfirmation.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'SkewSwapConfirmation.html', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-ACTUAL-SETTLE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-ACTUAL-TRADE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-FAILED-TRADE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-FAILED-AVAILABLE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-FAILED-SETTLE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-ACTUAL-AVAILABLE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-ACTUAL-VALUE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-THEORETICAL-SETTLE', '' 
go
add_domain_values   'InventoryPositions', 'CLIENT-THEORETICAL-TRADE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-ACTUAL-SETTLE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-ACTUAL-TRADE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-ACTUAL-VALUE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-FAILED-TRADE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-FAILED-SETTLE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-THEORETICAL-SETTLE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-THEORETICAL-TRADE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-FORECAST-SETTLE', '' 
go
add_domain_values   'InventoryPositions', 'INTERNAL-EXPECTED-SETTLE', '' 
go
add_domain_values   'applicationName', 'PresentationServer', 'PresentationServer' 
go
add_domain_values   'riskPresenter', 'Simulation', '' 
go
add_domain_values   'riskPresenter', 'Sensitivity', '' 
go
add_domain_values   'riskPresenter', 'Comparison', '' 
go
add_domain_values   'riskPresenter', 'ForwardLadder', 'Cross Asset Forward Ladder Cash Analysis' 
go
add_domain_values   'riskPresenter', 'OptionLifecycle', 'OptionLifecycle Analysis' 
go
add_domain_values   'riskOnDemandIncremental', 'ForwardLadder', 'Cross Asset Forward Ladder Cash Analysis' 
go
add_domain_values   'FutureOptionContractAttributes', 'PremiumPaymentConvention', 'convention for the premium payment' 
go
add_domain_values   'FutureOptionContractAttributes.PremiumPaymentConvention', 'Conventional', '' 
go
add_domain_values   'FutureOptionContractAttributes.PremiumPaymentConvention', 'VariationMargined', '' 
go
add_domain_values   'domainName', 'CustomBOTradeFrameTab', 'Custom BOTrade Frame Tab Names' 
go
add_domain_values   'productTypeReportStyle', 'FutureMM', 'FutureMM ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'FXOrder', 'ADR ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'FXNDF', 'FXNDF ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'DividendSwap', 'DividendSwap ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'EquityStructuredOption', 'EquityStructured Option ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'SkewSwap', 'SkewSwap ReportStyle' 
go
add_domain_values   'CommodityPaymentFrequency', 'ThirdWednesday', 'Third Wednesday' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency.ThirdWednesday', 'Fixing Date Policy for Payment Frequency' 
go
add_domain_values   'CommodityPaymentFrequency.ThirdWednesday', 'THIRD_WEDNESDAY', '' 
go
add_domain_values   'domainName', 'groupStaticDataFilter', 'Names for groups of static data filters' 
go
add_domain_values   'groupStaticDataFilter', 'ANY', 'group for StaticDataFilters which should be available in any window'
go
add_domain_values   'groupStaticDataFilter', 'Accounting', 'group for StaticDataFilters which should be available in Accounting-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'B2B', 'group for StaticDataFilters which should be available in B2B-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'BrokerFee', 'group for StaticDataFilters which should be available in BrokerFee-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'CA', 'group for StaticDataFilters which should be available in CA-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'FeeBillingRule', 'group for StaticDataFilters which should be available in FeeBillingRule-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'FeeGrid', 'group for StaticDataFilters which should be available in FeeGrid-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'FundingRate', 'group for StaticDataFilters which should be available in FundingRate-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'FUND_AM', 'group for StaticDataFilters which should be available in Fund-related windows (CashForwardConfig)' 
go
add_domain_values   'groupStaticDataFilter', 'FXBlotter', 'group for StaticDataFilters which should be available in FXBlotter' 
go
add_domain_values   'groupStaticDataFilter', 'HairCut', 'group for StaticDataFilters which should be available in HairCut-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'KickoffCutoff', 'group for StaticDataFilters which should be available in KickoffCuttoff windows' 
go
add_domain_values   'groupStaticDataFilter', 'LeContact', 'group for StaticDataFilters which should be available in LEContact-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'MappingStatus', 'group for StaticDataFilters which should be available in MappingStatus-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'MasterConfirmation', 'group for StaticDataFilters which should be available in MasterConfirmation-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'MarginCall', 'group for StaticDataFilters which should be available in MarginCall-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'MessageSetup', 'group for StaticDataFilters which should be available in Message-Setup-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'PairOff', 'group for StaticDataFilters which should be available in PairOff-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'PortfolioManager', 'group for StaticDataFilters which should be available in PortfolioManager-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'PositionKeeper', 'group for StaticDataFilters which should be available in PositionKeeper-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'Product', 'group for StaticDataFilters which should be available in Product-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'Reporting', 'group for StaticDataFilters which should be available in Reporting-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'SDI', 'group for StaticDataFilters which should be available in Settlement-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'SenderConfig', 'group for StaticDataFilters which should be available in SenderConfig-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'TaskInternalRefConfig', 'group for StaticDataFilters which should be available in Task Internal Reference configuration-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'TaskPriorityConfig', 'group for StaticDataFilters which should be available in Task Priority configuration-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'TaskStation', 'group for StaticDataFilters which should be available in Task Station configuration-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'TaskStationColor', 'group for StaticDataFilters which should be available in Task Station Color configuration-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'TaskStationDefault', 'group for StaticDataFilters which should be available in Task Station Default configuration-related windows' 
go
add_domain_values   'groupStaticDataFilter', 'TWS', 'group for StaticDataFilters which should be available in TraderWorkStation windows' 
go
add_domain_values   'groupStaticDataFilter', 'XferReport', 'group for StaticDataFilters which should be available in Transfer Report' 
go
add_domain_values   'groupStaticDataFilter', 'WF', 'group for StaticDataFilters which should be available in WF Windows' 
go
add_domain_values   'groupStaticDataFilter', 'WF_Message', 'group for StaticDataFilters which should be available in WF Windows for Message workflow' 
go
add_domain_values   'groupStaticDataFilter', 'WF_Trade', 'group for StaticDataFilters which should be available in WF Windows for Trade workflow' 
go
add_domain_values   'groupStaticDataFilter', 'WF_Transfer', 'group for StaticDataFilters which should be available in WF Windows for Transfer workflow' 
go
add_domain_values   'domainName', 'bulkEntry.productType', 'trade bulk upload supported product types' 
go
add_domain_values   'bulkEntry.productType', 'EquityLinkedSwap', '' 
go
add_domain_values   'domainName', 'BONYComparisonThresholdAmount', 'Threshold for BONY' 
go
add_domain_values   'BONYComparisonThresholdAmount', '10', 'Threshold amount for BONY' 
go
add_domain_values   'bulkEntry.productType', 'VarianceSwap', '' 
go
add_domain_values   'REPORT.Types', 'BulkEntry', 'Trade bulk upload from a CSV file' 
go
add_domain_values   'scheduledTask', 'TRADE_BULK_ENTRY', 'Trade bulk upload from a CSV file' 
go
add_domain_values   'domainName', 'eligibleToDividend', 'OTC Product Types - without position - eligible to dividends' 
go
add_domain_values   'eligibleToDividend', 'EquityLinkedSwap', 'EquityLinkedSwapCorporateActionHandler is responsible of performinf CA dividend releated tasks' 
go
add_domain_values   'function', 'AddDivivdend', 'Allow User to add Dividend to Equity DividendSchedule' 
go
add_domain_values   'function', 'RemoveDivivdend', 'Allow User to remove Dividend from Equity DividendSchedule' 
go
add_domain_values   'systemKeyword', 'TerminationQuoteFixing', 'For Equity/Rate Swap, store the Termination fixing value' 
go
add_domain_values   'systemKeyword', 'TerminationFXRateFixing', 'For Equity/Rate Swap, store the Termination fx rate value' 
go
add_domain_values   'tradeKeyword', 'TerminationQuoteFixing', 'For Equity/Rate Swap, store the Termination fixing value' 
go
add_domain_values   'tradeKeyword', 'TerminationFXRateFixing', 'For Equity/Rate Swap, store the Termination fx rate value' 
go
add_domain_values   'hyperSurfaceGenerators', 'Heston', '' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerExoticEquityStructuredOption', 'Default dummy Pricer for exotic OTC structured option' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerBlackNFJuAnalyticVanilla', 'analytic Pricer for Equity basket option - using Ju 2002 basket approximation' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerBlackNFMonteCarlo', 'MonteCarlo Pricer for Equity basket option, vanilla and performance payoffs' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticBarrier', 'analytic Pricer for single asset option with barriers' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticDigital', 'analytic Pricer for single asset digital option' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerBlack1FSemiAnalyticChooser', 'analytic Pricer for chooser option' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerBlack1FSemiAnalyticCompound', 'analytic Pricer for compound option' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerBlack1FMonteCarlo', 'MonteCarlo Pricer for single asset asian or lookback option' 
go
add_domain_values   'systemKeyword', 'PVMultiplier', '' 
go
add_domain_values   'tradeKeyword', 'PVMultiplier', '' 
go
add_domain_values   'systemKeyword', 'QuantoSource', '' 
go
add_domain_values   'domainName', 'taskStationDates', 'Date Types that are supporter by TaskStation config' 
go
add_domain_values   'taskStationDates', 'START', 'Start date of the config' 
go
add_domain_values   'taskStationDates', 'END', 'End date of the config' 
go
add_domain_values   'taskStationDates', 'TODAY', 'System Date' 
go
add_domain_values   'taskStationDates', 'START(1)', 'Start date + 1 bus day' 
go
add_domain_values   'taskStationDates', 'END(-1)', 'End date -1 bus day' 
go
add_domain_values   'taskStationDates', 'TODAY(1)', 'Today +1 bus day' 
go
add_domain_values   'plMeasure', 'Accrual_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Accrual_PnL', '' 
go
add_domain_values   'plMeasure', 'Accrual_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'BS_FX_Reval', '' 
go
add_domain_values   'plMeasure', 'Cash_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Cash_FX_Reval', '' 
go
add_domain_values   'plMeasure', 'Cash_PnL', '' 
go
add_domain_values   'plMeasure', 'Cash_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Full_Base_PnL', '' 
go
add_domain_values   'plMeasure', 'Intraday_Accrual_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Intraday_Cash_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Intraday_Full_Base_PnL', '' 
go
add_domain_values   'plMeasure', 'Intraday_Realized_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Intraday_Translation_PnL', '' 
go
add_domain_values   'plMeasure', 'Paydown_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Paydown_PnL', '' 
go
add_domain_values   'plMeasure', 'Paydown_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Realized_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Realized_Interests_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Realized_Interests_PnL', '' 
go
add_domain_values   'plMeasure', 'Realized_Interests_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Realized_PnL', '' 
go
add_domain_values   'plMeasure', 'Realized_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Sale_Realized_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Sale_Realized_PnL', '' 
go
add_domain_values   'plMeasure', 'Sale_Realized_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Total_PnL', '' 
go
add_domain_values   'plMeasure', 'Total_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Translation_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Cash_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Cash_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Cash_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Fees_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Fees_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Fees_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Interests', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Interests_Base', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Interests_Full', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Net_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Net_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Net_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Unrealized_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Unsettled_Cash_FX_Reval', '' 
go
add_domain_values   'function', 'DoNotAllowNettingGroupChange', '' 
go
add_domain_values   'function', 'DoNotAllowNettingMethodChange', '' 
go
add_domain_values   'function', 'DoNotAllowSDIChange', '' 
go
add_domain_values   'function', 'DoNotAllowBeneficiaryChange', '' 
go
add_domain_values   'function', 'DoNotCheckCorporateActions', 'This function will disallow the user to check corporate actions when a bond is changed from the Bond window.' 
go
add_domain_values   'function', 'NettingManagerApply', '' 
go
add_domain_values   'function', 'NettingManagerApplyToTrade', '' 
go
add_domain_values   'restriction', 'DoNotAllowNettingGroupChange', '' 
go
add_domain_values   'restriction', 'DoNotAllowNettingMethodChange', '' 
go
add_domain_values   'restriction', 'DoNotAllowSDIChange', '' 
go
add_domain_values   'restriction', 'DoNotAllowBeneficiaryChange', '' 
go
add_domain_values   'restriction', 'DoNotCheckCorporateActions', 'This restriction will disallow the user to check corporate actions when a bond is changed from the Bond window.' 
go
add_domain_values   'function', 'AllowSplitWithoutSDI', '' 
go
add_domain_values   'domainName', 'XferTypeActual', 'Xfer types that update only Actual Position' 
go
add_domain_values   'XferTypeActual', 'MT950_ADJUSTMENT', '' 
go
add_domain_values   'domainName', 'PropagateTradeKeyword', 'Trade Keyword to be copied to Transfer' 
go
add_domain_values   'PropagateTradeKeyword', 'Instruction Code', '' 
go
add_domain_values   'workflowRuleTransfer', 'PropagateTradeKeyword', '' 
go
add_domain_values   'workflowRuleTransfer', 'CheckCancel', '' 
go
add_domain_values   'domainName', 'CreditDefaultSwapCoupon.SNAC', '' 
go
add_domain_values   'CreditDefaultSwapCoupon.SNAC', '100', '' 
go
add_domain_values   'CreditDefaultSwapCoupon.SNAC', '500', '' 
go
add_domain_values   'domainName', 'DayChangeRule', '' 
go
add_domain_values   'DayChangeRule', 'TimeZone', '' 
go
add_domain_values   'DayChangeRule', 'FX', '' 
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_RESET_EFFECT', 'Impact of Commodity Fixings', 83, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_FWD_CURVE_EFFECT', 'Impact of the Commodity Forward Curve', 84, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_FWD_CURVE_EFFECT_PAY_LEG', 'Impact of the Commodity Forward Curve For the Pay Leg', 85, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_FWD_CURVE_EFFECT_REC_LEG', 'Impact of the Commodity Forward Curve For the Receive Leg', 86, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_BASIS_EFFECT', 'Impact of the Commodity Spread Quotes', 87, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_BASIS_EFFECT_PAY_LEG', 'Impact of the Commodity Spread Quotes For the Pay Leg', 88, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_BASIS_EFFECT_REC_LEG', 'Impact of the Commodity Spread Quotes For the Receive Leg', 89, 'NPV', 0 )
go
delete from group_access where group_name='admin' and access_id=1 and access_value='UnlockMarks' and read_only_b=0
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'UnlockMarks', 0 )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CLIQUET', 'PricerBlack1FMonteCarlo' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.COMPOUND', 'PricerBlack1FSemiAnalyticCompound' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CHOOSER', 'PricerBlack1FSemiAnalyticChooser' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'TV', 'tk.core.PricerMeasure', 380, 'Theoretical Price' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'VANNA_VOLGA_ADJ', 'tk.core.PricerMeasure', 381, 'Vanna Volga Adjustment' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUR_NOTIONAL_PAY', 'tk.core.PricerMeasure', 353 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUR_NOTIONAL_REC', 'tk.core.PricerMeasure', 354 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CASH_BASE', 'tk.pricer.PricerMeasureCashBase', 361 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_POS_CASH', 'tk.core.PricerMeasure', 359 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DISCOUNT_FACTOR', 'tk.core.PricerMeasure', 287 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'COMPONENT_MEASURES', 'tk.core.PricerMeasure', 310 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_CUMUL_CASH', 'tk.pricer.PricerMeasureHistoricalCumulativeCash', 360 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REALIZED_ACCRUAL', 'tk.core.PricerMeasure', 377 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_ACCRUAL_BO', 'tk.pricer.PricerMeasureHistoricalAccrualBO', 378 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_REALIZED_ACCRUAL', 'tk.core.PricerMeasure', 379 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BETA_INDEX', 'tk.core.PricerMeasure', 343 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PV_COLLAT', 'tk.core.PricerMeasure', 352 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REPL_SPREAD', 'tk.core.PricerMeasure', 355 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CARRY', 'tk.core.PricerMeasure', 356 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SLIDE', 'tk.core.PricerMeasure', 357 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'TIME', 'tk.core.PricerMeasure', 358 )
go
delete from pricer_measure where measure_name='FEES_ALL' and measure_class_name='tk.pricer.PricerMeasureGenericFee' and measure_id=362
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_ALL', 'tk.pricer.PricerMeasureGenericFee', 362 )
go
delete from pricer_measure where measure_name='FEES_ALL_AM' and measure_class_name='tk.pricer.PricerMeasureGenericFee' and measure_id=363
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_ALL_AM', 'tk.pricer.PricerMeasureGenericFee', 363 )
go
delete from pricer_measure where measure_name='FEES_ALL_REMAIN' and measure_class_name='tk.pricer.PricerMeasureGenericFee' and measure_id=364
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_ALL_REMAIN', 'tk.pricer.PricerMeasureGenericFee', 364 )
go
delete from pricer_measure where measure_name='FEES_ALL_NPV' and measure_class_name='tk.pricer.PricerMeasureGenericFee' and measure_id=365
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_ALL_NPV', 'tk.pricer.PricerMeasureGenericFee', 365 )
go
delete from pricer_measure where measure_name='FEES_ALL_CASH' and measure_class_name='tk.pricer.PricerMeasureGenericFee' and measure_id=366
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_ALL_CASH', 'tk.pricer.PricerMeasureGenericFee', 366 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'UNSETTLED_CASH', 'tk.pricer.PricerMeasureUnsettledCash', 367 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_UNSETTLED_CASH', 'tk.pricer.PricerMeasureUnsettledCash', 368 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ORIGINAL_NOTIONAL_SD', 'tk.core.PricerMeasure', 369 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NPV_DISC_WITH_COST', 'tk.core.PricerMeasure', 370 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_REALIZED', 'tk.core.PricerMeasure', 371 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_CUMUL_CASH_FEES', 'tk.pricer.PricerMeasureHistoricalCumulativeCash', 372 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_BS', 'tk.pricer.PricerMeasureHistoBS', 374 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CLEAN_BOOK_VALUE', 'tk.core.PricerMeasure', 376 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'TOTAL_PAYDOWN', 'tk.core.PricerMeasure', 382 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'TOTAL_PAYDOWN_BOOK_VALUE', 'tk.core.PricerMeasure', 383 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_TOTAL_PAYDOWN', 'tk.core.PricerMeasure', 384 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_TOTAL_PAYDOWN_BOOK_VALUE', 'tk.core.PricerMeasure', 385 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_CUMUL_CASH_INTEREST', 'tk.pricer.PricerMeasureHistoricalCumulativeCash', 387 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_UNSETTLED_SD', 'tk.pricer.PricerMeasureUnsettledFees', 388 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_TOTAL_INTEREST', 'tk.core.PricerMeasure', 389 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_UNSETTLED_FEES', 'tk.pricer.PricerMeasureUnsettledFees', 390 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'USE_VANNA_VOLGA_ADJ', 'java.lang.Boolean', 'true,false', 'Values double and single full-window barriers using vanna-volga pricing in PricerFXOptionBarrier', 0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'ACCURACY_LEVEL', 'java.lang.Integer', '0,1,2,3,4,5,6,7,8,9,10,11', 'Controls the level of accuracy in pricing, 0-lowest accuracy (fastest), 11-highest accuracy (slowest)', 1, 'ACCURACY_LEVEL', '5' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'IGNORE_BASKET_MARKETDATA', 'java.lang.Boolean', 'true,false', 'Allow to price some baskets from either as components or as a single.  If it sets to true then it will ALWAYS price from components.', 1, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'PRICING_MODEL', 'java.lang.String', 'Ju2002,Levy92', 'Basket pricing model choice', 1, 'Ju2002' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'RECALC_SYSTEM_PLMARKS', 'java.lang.Boolean', 'true,false', 'Re-calculate system PL marks by brute force', 0, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_DRIFT', 'java.lang.Double', 'Drift parameter in the time-independent Heston model; known also as mu.', 0, 'HESTON_DRIFT' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_MEAN_VAR', 'java.lang.Double', 'Long-term mean of the variance in the time-independent Heston model; known also as theta.', 0, 'HESTON_MEAN_VAR' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_VAR_REV_SPEED', 'java.lang.Double', 'The variance mean-reversion speed in the time-independent Heston model; known also as kappa.', 0, 'HESTON_VAR_REV_SPEED' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_VOL_VOL', 'java.lang.Double', 'The volatility of volatility in the time-independent Heston model; known also as epsilon, sigma or xi.', 0, 'HESTON_VOL_VOL' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_CORR', 'java.lang.Double', 'The correlation of price and variance in the time-independent Heston model; known also as rho.', 0, 'HESTON_CORR' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name, default_value ) VALUES ( 'HESTON_NUM_MC_PATHS', 'java.lang.Integer', 'The number of Monte Carlo simulations to use when calculating with the Heston model.', 0, 'HESTON_NUM_MC_PATHS', '1000' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'PAYOUT_AS_FEE', 'java.lang.Boolean', 'true,false', 'Include Variance Swap payout as a fee', 1, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_UNDERLYING_TRADES_PRICER', 'java.lang.Boolean', 'true,false', 'Price structured product using underlying pricer params.', 0, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'EQUITY/EQUITY_CORRELATION', 'com.calypso.tk.core.Rate', '', 'Option basket model parameter.', 0, 'EQUITY/EQUITY_CORRELATION' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'EQUITY/EQUITYINDEX_CORRELATION', 'com.calypso.tk.core.Rate', '', 'Option basket model parameter.', 0, 'EQUITY/EQUITYINDEX_CORRELATION' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'EQUITYINDEX/EQUITYINDEX_CORRELATION', 'com.calypso.tk.core.Rate', '', 'Option basket model parameter.', 0, 'EQUITYINDEX/EQUITYINDEX_CORRELATION' )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 130, 'PLMark', 0, 0, 0 )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 131, 'MarginCallPosition', 0, 1, 1 )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'task_completion', 'Auxiliary table to complete linked tasks at TaskEngine start.' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'speed_button', 'Speed Button information to capture often used trade or risk data, used in CWS' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'arch_cre_tmp', 'Scratch table to store ids of cre to be archived/deleted.' )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES ( 218, 'PSEventTrade', 'ALLOCATED', 'TERMINATE', 'TERMINATED', 0, 1, 'ALL', 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES ( 219, 'PSEventTrade', 'TERMINATED', 'AMEND', 'TERMINATED', 0, 1, 'ALL', 0, 0, 0, 0, 0 )
go

/* CAL-66546 */

delete from domain_values where name = 'riskPresenter' and value = 'Pricing'
go


/*CAL-54413*/
if exists(select 1 from sysobjects where name='size_column_name')
begin
exec ('drop proc size_column_name')
end
go

create proc size_column_name
as
declare @colsize int
begin
select @colsize= max(datalength(column_name)) from user_viewer_column if (@colsize < 2000)
exec('alter table user_viewer_column modify column_name varchar(2000) NOT NULL')
else
begin
return 1
end
end
go

exec size_column_name
go
drop proc size_column_name
go
/*end*/

/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date='20090702'
go
