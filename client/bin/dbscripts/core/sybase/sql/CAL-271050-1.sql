/* This is the upgrade script for Calypo Rel900 p04 to Rel1000 */


/* taking care of the dropping the indexes and constraints applied on the table*/



drop_pk_if_exists 'exsp_quotable_variable'
go
drop_index_if_exists 'exsp_quotable_variable'
go

/* end*/


delete an_viewer_config where analysis_name in ('VaR', 'PredictPL', 'VARHistoric', 'PredictPLPre', 'FutureExposure',
  'FXPosition', 'FXSensitivity', 'FXLadder', 'Sensitivity', 'VolSens', 'CreditPositionAging', 'SpotExposure', 'OptionExpiration')
go

delete domain_values where name = 'classAuditMode' and value in ('FutureExposureParam', 'FXPositionParam', 'AccrualParam',
  'PredictPLParam', 'VARHistoricParam', 'PredictPLPreParam', 'CreditExposureParam', 'CreditSensitivityParam', 'SensitivityParam',
  'FXSensitivityParam', 'VaRParam', 'VolSensParam')
go

delete domain_values where name = 'riskAnalysis' and value in ('VolSens', 'PredictPL', 'FXSensitivity', 'Accrual', 'VaR',
  'PredictPLPre', 'VARHistoric', 'FutureExposure', 'FXPosition', 'FXLadder', 'Sensitivity', 'CreditPositionAging',
  'SpotExposure', 'OptionExpiration')
go


UPDATE pc_surface SET desc_name = desc_name+'.ANY' WHERE desc_name LIKE '%Commodity%' AND desc_name NOT LIKE '%Commodity.%.%.%'
go

add_domain_values 'futureUnderType','BRL',''
go

UPDATE engine_config set engine_name = 'MatchingEngine' where engine_name = 'MatchingMessageEngine'
go

delete engine_config where engine_name in ('MatchingEngine','MatchableBuilderEngine')
and not exists (select name from domain_values where name ='dsInit' and value='MatchingServer')
go
delete ps_event_config where engine_name in ('MatchingEngine','MatchableBuilderEngine')
and not exists (select name from domain_values where name ='dsInit' and value='MatchingServer')
go
delete ps_event_filter where engine_name in ('MatchingEngine','MatchableBuilderEngine')
and not exists (select name from domain_values where name ='dsInit' and value='MatchingServer')
go
 
update trade set settlement_date = (select exercise_settle_dt from product_otccom_opt 
  where product_otccom_opt.product_id=trade.product_id) 
  where exists 
  (select exercise_settle_dt from product_otccom_opt where product_otccom_opt.product_id=trade.product_id)
go

update product_bond set allowed_redemption_type = 'Full' where allowed_redemption_type is null
go
add_column_if_not_exists 'pricing_env','day_change_rule', 'varchar(32) NULL'
go
add_domain_values 'scheduledTask',  'SAVE_POSITION_SNAPSHOT', 'Task to store snapshots of positions'  
go
alter table an_viewer_config drop constraint ct_primarykey 
go
alter table pc_info drop constraint ct_primarykey
go
add_column_if_not_exists 'risk_on_demand_item', 'position_freq','numeric NULL'
go
add_column_if_not_exists 'risk_presenter_item', 'position_freq', 'numeric NULL'
go
update risk_on_demand_item set position_freq = -1 where position_freq is null
go
update risk_presenter_item set position_freq = -1 where position_freq is null
go

delete from engine_config where engine_id = 15 and engine_name = 'BalanceEngine'
go

insert into engine_config (engine_id, engine_name, engine_comment)
select distinct -1, 'BalanceEngine', 'Compute account balances in real time (alternative to SchduledTaskBALANCE)'
from engine_config where not exists (select 1 from engine_config where engine_name = 'BalanceEngine')
go



update engine_config
set engine_id = (select max(engine_id) + 1 from engine_config)
where engine_name = 'BalanceEngine'
and engine_id = -1
go


UPDATE domain_values SET value = 'Dispatcher host' WHERE value = 'dispatcher_host' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'Dispatcher port' WHERE value = 'dispatcher_port' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'Dispatcher port' WHERE value = 'Dispatcher Port' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'Notify on job error' WHERE value = 'notify_job_err_b' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'Email address to' WHERE value = 'ext_addr_to' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'Email address from' WHERE value = 'ext_addr_from' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'Read only' WHERE value = 'read_only' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'User name' WHERE value = 'user_name' AND name = 'DispatcherParamsCalypso'
go
UPDATE domain_values SET value = 'Engine group' WHERE value = 'engineGroup' AND name = 'DispatcherParamsDatasynapse'
go
UPDATE domain_values SET value = 'Grid library' WHERE value = 'gridLibrary' AND name = 'DispatcherParamsDatasynapse'
go
UPDATE domain_values SET value = 'Gridlib version' WHERE value = 'gridLibraryVersion' AND name = 'DispatcherParamsDatasynapse'
go
UPDATE domain_values SET value = 'DataSynapse username' WHERE value = 'datasynapseUser' AND name = 'DispatcherParamsDatasynapse'
go
UPDATE domain_values SET value = 'DataSynapse password' WHERE value = 'datasynapsePass' AND name = 'DispatcherParamsDatasynapse'
go


UPDATE disp_params SET param_name =  'Dispatcher host' WHERE param_name = 'dispatcher_host' AND param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Dispatcher port' WHERE param_name = 'dispatcher_port' AND param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Notify on job error' WHERE param_name = 'notify_job_err_b' AND param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Email address to' WHERE param_name = 'ext_addr_to' AND param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Email address from' WHERE param_name = 'ext_addr_from' AND param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Read only' WHERE param_name = 'read_only' AND param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'User name' WHERE param_name = 'user_name' AND param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Engine group' WHERE param_name = 'engineGroup' AND  param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Grid library' WHERE param_name = 'gridLibrary' AND  param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'Gridlib version' WHERE param_name = 'gridLibraryVersion' AND  param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'DataSynapse username' WHERE param_name = 'datasynapseUser' AND  param_type = 'Parameter'
go
UPDATE disp_params SET param_name =  'DataSynapse password' WHERE param_name = 'datasynapsePass' AND  param_type = 'Parameter'
go

DELETE report_panel_def where win_def_id IN (SELECT win_def_id FROM report_win_def WHERE def_name = 'MessageViewerWindow')
go
DELETE report_win_def WHERE def_name = 'MessageViewerWindow'
go
DELETE FROM domain_values WHERE name = 'FXOption.Pricer' and value = 'PricerFXOption'
go
DELETE FROM domain_values where name = 'FXOption.subtype' AND value = 'BARRIER_IN'
go
DELETE FROM domain_values where name = 'FXOption.subtype' AND value = 'BARRIER_OUT'
go

DELETE an_viewer_config WHERE analysis_name in ('Strategy', 'CPPILiability')
go
DELETE domain_values WHERE name = 'riskAnalysis' AND value IN ('Strategy', 'CPPILiability')
go


DELETE FROM pricer_measure where measure_id=297 and measure_name='W_SHIFT_MOD_VEGA'
go
INSERT INTO pricer_measure (measure_name,measure_class_name,measure_id,measure_comment) 
  VALUES ('W_SHIFT_MOD_VEGA','tk.core.PricerMeasure',297,'W_SHIFT_MOD_VEGA = [Price (Current Vol+Beta) - Price (Current Vol)]')
go

add_column_if_not_exists 'le_legal_agreement', 'notice_days', 'numeric(18,0) null'
go

add_column_if_not_exists 'le_legal_agreement','callable_by', 'varchar(12) null'
go

UPDATE le_legal_agreement SET le_legal_agreement.notice_days = (
  SELECT notice_days FROM sec_lend_legal
  WHERE sec_lend_legal.legal_agreement_id = le_legal_agreement.legal_agreement_id)
go

UPDATE le_legal_agreement SET le_legal_agreement.callable_by = (
  SELECT callable_by FROM sec_lend_legal 
  WHERE sec_lend_legal.legal_agreement_id = le_legal_agreement.legal_agreement_id)
go

UPDATE pricing_param_name SET param_domain = 'EXACT_STEP_SIGMA,BEST_FIT_LM' WHERE param_name = 'LGMM_CALIBRATION_SCHEME'
go

add_domain_values 'scheduledTask','EOD_CALCULATION_SERVER','EOD CalculationServer tasks'
go

update calypso_tree_node set node_class_name='com.calypso.apps.tws.FolderView' 
  where leaf_b=0 and node_class_name='com.calypso.apps.tws.CalypsoTreeViewNode'
go
add_domain_values 'quoteType','PriceVol','' 
go
UPDATE advice_config SET template_name = 'fxoptionConfirmation.html' WHERE advice_config_id = 88 AND template_name = 'fxoptionconfirmation.html'
go
UPDATE bo_message SET template_name = 'fxoptionConfirmation.html' WHERE advice_cfg_id = 88 AND template_name = 'fxoptionconfirmation.html'
go
UPDATE advice_config SET template_name = 'fxoptionConfirmation.html' WHERE advice_config_id = 89 AND template_name = 'fxoptionconfirmation.html'
go
UPDATE bo_message SET template_name = 'fxoptionConfirmation.html' WHERE advice_cfg_id = 89 AND template_name = 'fxoptionconfirmation.html'
go
DELETE FROM domain_values WHERE name = 'MESSAGE.Templates' AND value = 'cdsAbsConfirm.html'
go
UPDATE advice_config SET template_name = 'cdsABSConfirm.html' WHERE template_name = 'cdsAbsConfirm.html'
go
UPDATE bo_message SET template_name = 'cdsABSConfirm.html' WHERE template_name = 'cdsAbsConfirm.html'
go
DELETE FROM domain_values WHERE name = 'MESSAGE.Templates' AND value = 'varianceSwapConfirmation.html'
go
UPDATE advice_config SET template_name = 'VarianceSwapConfirmation.html' WHERE template_name = 'varianceSwapConfirmation.html'
go
UPDATE bo_message SET template_name = 'VarianceSwapConfirmation.html' WHERE template_name = 'varianceSwapConfirmation.html'
go

add_column_if_not_exists 'prod_comm_fwd', 'fwd_price_method', 'varchar(32) null'
go

update prod_comm_fwd set fwd_price_method='Nearby' where fwd_price_method is null
go

add_column_if_not_exists 'product_bond_opt', 'liquidity', 'float null'
go
UPDATE product_bond_opt SET liquidity = 1.0
go

if not exists(select 1 from sysobjects where name='pmt_freq_details')
begin
exec('create table pmt_freq_details (
	product_id                      numeric(18,0)                    not null  ,
	pmt_freq_type                   varchar(64)                      not null  ,
	attr_name                       varchar(32)                          null  ,
	attr_value                      varchar(255)                         null   )')
end
go

add_column_if_not_exists 'pmt_freq_details', 'leg_id', 'numeric null'
go

alter table pmt_freq_details  replace leg_id default 0
go

update pmt_freq_details set leg_id = 0 where leg_id is null
go


if not exists(select 1 from sysobjects where name='product_commodity_swap2')
begin
        exec('create table product_commodity_swap2( 
                             product_id numeric not null,
                             pay_leg_id numeric null,
                             receive_leg_id numeric null,
                             currency_code VARCHAR(3) null,
                             AVERAGING_POLICY VARCHAR(64) null,
                             CUSTOM_FLOWS_B numeric null,
                             flow_blob image null,
                             AVG_ROUNDING_POLICY VARCHAR(64) null,
                             constraint pk_prod_comm_swap2 primary key (product_id))')
end
go


add_column_if_not_exists 'cf_sch_gen_params', 'leg_id', 'numeric default 0'
go

update cf_sch_gen_params set leg_id = 0 where leg_id is null
go

add_column_if_not_exists 'cf_sch_gen_params', 'fx_reset_id', 'numeric null'
go

add_column_if_not_exists 'cf_sch_gen_params','fx_calendar', 'varchar(64) null'
go

add_column_if_not_exists 'cf_sch_gen_params', 'payment_date_roll', 'varchar(16) null'
go

add_column_if_not_exists 'commodity_leg2', 'averaging_policy', 'varchar(64)  null'
go

add_column_if_not_exists 'commodity_leg2', 'avg_rounding_policy', 'varchar(64) null'
go


insert into pmt_freq_details (product_id, pmt_freq_type, attr_name, attr_value, leg_id) 
   select p.product_id, p.pmt_freq_type, p.attr_name, p.attr_value, s.receive_leg_id 
      FROM pmt_freq_details p, product_commodity_swap2 s 
      where p.product_id=s.product_id and p.leg_id=0
go

update pmt_freq_details set p.leg_id=s.pay_leg_id from pmt_freq_details p, product_commodity_swap2 s
  where p.product_id=s.product_id and p.leg_id=0
go
 
update pmt_freq_details set p.leg_id=o.leg_id from pmt_freq_details p, product_commodity_otcoption2 o
  where p.product_id=o.product_id and p.leg_id=0
go

UPDATE pricing_param_name SET param_domain = 'EXACT_STEP_SIGMA,BEST_FIT_LM,APPROX_STEP_SIGMA' WHERE param_name = 'LGMM_CALIBRATION_SCHEME'
go

delete from domain_values where name = 'VolSurface.gensimple' and value = 'SmileAdjustment'
go
delete from domain_values where name = 'VolSurface.gensimple' and value = 'SimpleSmile'
go
update vol_surface set vol_surf_generator = 'BondOptionQuadraticSmile' where vol_surf_generator = 'SmileAdjustment'
go
update vol_surface set vol_surf_generator = 'QuadraticSmileParams' where vol_surf_generator = 'SimpleSmile'
go

DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_PRIM'
go
DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_SEC'
go

delete from domain_values where name = 'NDS.subtype' and value = 'CSS'
go
add_domain_values 'NDS.subtype','CCS',''
go

/*                                                          */
/* This is the Sybase/hibernate migration script - phase 1  */
/*                                                          */


/* First deal with the date_rule object */

add_column_if_not_exists 'date_rule', 'date_rules','varchar(255)  DEFAULT  ''NONE'' not null' 
go

/* create a new table to hold the date_rule to date_rule mapping */




create table date_rule_to_date_rule (
  owner numeric not null,
  owned numeric not null)
go
alter table date_rule_to_date_rule add constraint pk_date_rule_to_date_rule primary key (owner, owned)
go
 
/* lets split up our comma-separated list of date_rules into seperate rows */

create procedure reparse_table
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(255),
      @parse_out_val    varchar(255),
      @parse_index2    int,
      @parseval2  varchar(255),
      @parse_out_val2   varchar(255),
      @myid int,
      @my_new_date_rule1  int,
      @my_new_date_rule2  int,
      @a int,
      @b varchar(32)


declare cur_main cursor for
  select date_rule_id, date_rules from date_rule where date_rules != 'NONE' or date_rules is not null

open cur_main
  fetch cur_main into @myid, @parseval
  while (@@sqlstatus = 0)
    begin
      select @parse_char = ','
      select @parse_index = charindex(@parse_char, @parseval)
        if (@parse_index = 1)
          begin
            select @parseval = substring(@parseval, 2, len(@parseval))
         end

  while (charindex(@parse_char, @parseval) > 0)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
             select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))

             insert into date_rule_to_date_rule (owner, owned) values (@myid, convert(numeric,@parse_out_val))

         end
     fetch cur_main into @myid, @parseval
   end

 close cur_main
 deallocate cursor cur_main
go

exec sp_procxmode 'reparse_table', 'anymode'
go

exec reparse_table
go

drop procedure reparse_table
go

/* backup the date_rule table before we drop he column containing the old date_rules format */

select * into date_rule_bak from date_rule
go

/* now drop the column */

alter table date_rule drop date_rules
go


/* OK we're done with date_rule object now  */

/* ################################################################################### */

/* Now we deal with the rate_index_default object */


/* take a backup of RATE_INDEX_DEFAULT table first */

select * into  rate_index_default_bak  from rate_index_default 
go

/* part A - we merge rate_avg_method into rate_index_default */


/* add the columns */

alter table rate_index_default add 
 avg_method     varchar(32) null,
 start_offset   numeric null,
 day_of_week    numeric null,
 cutoff_days    numeric null,
 frequency      varchar(12) null,
 avg_period_rule varchar(18) null,
 under_rate_index    varchar(128) null,
 unadjust_reset      numeric null,
 avg_rounding_unit   numeric null
go

/* now update those columns we just added */


/* adding create table inflation_index which may or may not exist in the database*/

if not exists(select 1 from sysobjects 
             where name = 'inflation_index')
            
begin
exec('CREATE TABLE inflation_index(
        currency_code       varchar(3)  NOT NULL,
        rate_index_code     varchar(32)   NOT NULL,
        publication_day     numeric default 1,
        calculation_method  varchar(32) default null,
        interp_method       varchar(32) default null,
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (currency_code, rate_index_code)')
end
go
add_column_if_not_exists 'inflation_index','reference_day', 'numeric default 1 null'
go
/*end*/
update rate_index_default set
  avg_method = rate_avg_method.avg_method,
  start_offset = rate_avg_method.start_offset,
  day_of_week = rate_avg_method.day_of_week,
  cutoff_days = rate_avg_method.cutoff_days,
  frequency = rate_avg_method.frequency,
  avg_period_rule = rate_avg_method.period_rule,
  under_rate_index = rate_avg_method.under_rate_index,
  unadjust_reset = rate_avg_method.unadjust_reset,
  avg_rounding_unit = rate_avg_method.avg_rounding_unit
from rate_avg_method, rate_index_default
where
 rate_avg_method.currency_code = rate_index_default.currency_code 
and 
 rate_avg_method.rate_index_code = rate_index_default.rate_index_code
and exists (
select 1 from rate_index_default , rate_avg_method
 where rate_index_default.currency_code = rate_avg_method.currency_code
 and rate_index_default.rate_index_code = rate_avg_method.rate_index_code)
go

update rate_index_default set avg_rounding_unit = -1 where avg_rounding_unit is null
go
alter table rate_index_default modify avg_rounding_unit not null 
go
alter table rate_index_default replace avg_rounding_unit default -1 
go

/* part B - we merge inflation_index into rate_index_default */

/* add the columns */

add_column_if_not_exists 'rate_index_default', 'publication_day', 'NUMERIC default 45 null'
go
add_column_if_not_exists 'rate_index_default', 'calculation_method' ,'VARCHAR(32) null'
go
add_column_if_not_exists 'rate_index_default', 'interp_method ','VARCHAR(32) null'
go
add_column_if_not_exists 'rate_index_default', 'reference_day' ,'NUMERIC default 1 null'
go

/* now update those columns we just added */
 
update rate_index_default set 
  publication_day  = inflation_index.publication_day,
  calculation_method = inflation_index.calculation_method,
  interp_method = inflation_index.interp_method,
  reference_day = inflation_index.reference_day
from inflation_index, rate_index_default
  where
 inflation_index.currency_code = rate_index_default.currency_code
  and
 inflation_index.rate_index_code = rate_index_default.rate_index_code
and exists (
select 1 from rate_index_default , inflation_index
 where rate_index_default.currency_code = inflation_index.currency_code
 and rate_index_default.rate_index_code = inflation_index.rate_index_code)
go

update rate_index_default set publication_day = 45 where publication_day is null
go
alter table rate_index_default modify publication_day not null
go

update rate_index_default set reference_day = 1 where reference_day is null
go
alter table rate_index_default modify reference_day not null
go


/* part C - we merge rateindex_cu_swap into rate_index_default */

alter table rate_index_default add 
  cu_swap_currency_code              VARCHAR(3) null,
  cu_swap_rate_index_code            VARCHAR(32) null,
  cu_swap_rate_index_tenor           NUMERIC null,
  cu_swap_rate_index_source          VARCHAR(32) null,
  maturity_tenor                     NUMERIC null,
  fixed_cpn_holidays                 VARCHAR(128) null,
  fixed_cpn_dateroll                 VARCHAR(16) null,
  fxd_daycount                       VARCHAR(10) null,
  flt_cpn_holidays                   VARCHAR(128) null,
  flt_cpn_dateroll                   VARCHAR(16) null,
  fixed_cpn_freq                     VARCHAR(12) null,
  float_cpn_freq                     VARCHAR(12) null,
  man_first_reset_b                  NUMERIC null,
  fxd_period_rule                    VARCHAR(18) null,
  flt_period_rule                    VARCHAR(18) null,
  flt_cmp_freq                       VARCHAR(12) null,
  spc_lag_b                          NUMERIC default 0 null,
  spc_lag_offset                     NUMERIC null,
  spc_lag_holidays                   VARCHAR(128) null,
  spc_lag_bus_cal_b                  NUMERIC default 0 null,
  fixed_po_formula                   VARCHAR(32) null,
  flt_po_formula                     VARCHAR(32) null,
  fxd_cmp_freq                       VARCHAR(12) null,
  principal_actual_b                 NUMERIC default 0 null,
  discount_method                    NUMERIC default 0 null
go
 
/* now update all the columns we just added (except for the 4 cu_swap_NNN columns */
/* we will deal with them seperately                                              */
/* note that clients coming from earlier versions may not have syncd to xml yet and so  */
/* wont have rateindex_cu_swap table yet - so we check see if its there avoiding        */
/* noise from this script                                                               */ 

if not exists (select 1 from sysobjects where name='rateindex_cu_swap')
		    begin
		    exec('create table rateindex_cu_swap(
			defaults_currency_code     varchar(3),
                        defaults_rateindex_code    varchar(32),
                        rate_index                 varchar(128),
                        maturity_tenor             numeric,
                        fixed_cpn_holidays         varchar(128),
                        fixed_cpn_dateroll         varchar(16),
                        fxd_daycount               varchar(10),
                        flt_cpn_holidays           varchar(128),
                        flt_cpn_dateroll           varchar(16),
                        fixed_cpn_freq             varchar(12),
                        float_cpn_freq             varchar(12),
                        man_first_reset_b          numeric,
                        fxd_period_rule            varchar(18),
                        flt_period_rule            varchar(18),
                        flt_cmp_freq               varchar(12),
                        spc_lag_b                  numeric,
                        spc_lag_offset             numeric,
                        spc_lag_holidays           varchar(128),
                        spc_lag_bus_cal_b          numeric,
                        fixed_po_formula           varchar(32),
                        flt_po_formula             varchar(32),
                        fxd_cmp_freq               varchar(12),
                        principal_actual_b         numeric,
                        discount_method            numeric,
			constraint pk_rateindex_cu_swap primary key (defaults_currency_code,defaults_rateindex_code))')
			end
go

/* now update all the columns we just added (except for the 4 cu_swap_NNN columns */
/* we will deal with them seperately                                              */



update rate_index_default set 
  maturity_tenor = rateindex_cu_swap.maturity_tenor,
  fixed_cpn_holidays = rateindex_cu_swap.fixed_cpn_holidays,
  fixed_cpn_dateroll = rateindex_cu_swap.fixed_cpn_dateroll,
  fxd_daycount = rateindex_cu_swap.fxd_daycount,
  flt_cpn_holidays = rateindex_cu_swap.flt_cpn_holidays,
  flt_cpn_dateroll = rateindex_cu_swap.flt_cpn_dateroll,
  fixed_cpn_freq = rateindex_cu_swap.fixed_cpn_freq,
  float_cpn_freq = rateindex_cu_swap.float_cpn_freq,
  man_first_reset_b = rateindex_cu_swap.man_first_reset_b,
  fxd_period_rule = rateindex_cu_swap.fxd_period_rule,
  flt_period_rule = rateindex_cu_swap.flt_period_rule,
  flt_cmp_freq = rateindex_cu_swap.flt_cmp_freq,
  spc_lag_b = rateindex_cu_swap.spc_lag_b,
  spc_lag_offset = rateindex_cu_swap.spc_lag_offset,
  spc_lag_holidays = rateindex_cu_swap.spc_lag_holidays,
  spc_lag_bus_cal_b = rateindex_cu_swap.spc_lag_bus_cal_b,
  fixed_po_formula = rateindex_cu_swap.fixed_po_formula,
  flt_po_formula = rateindex_cu_swap.flt_po_formula,
  fxd_cmp_freq = rateindex_cu_swap.fxd_cmp_freq,
  principal_actual_b = rateindex_cu_swap.principal_actual_b,
  discount_method = rateindex_cu_swap.discount_method
from rateindex_cu_swap , rate_index_default
 where  rateindex_cu_swap.defaults_currency_code = rate_index_default.currency_code
  and   rateindex_cu_swap.defaults_rateindex_code = rate_index_default.rate_index_code
and exists (
select 1 from rate_index_default , rateindex_cu_swap
 where rate_index_default.currency_code = rateindex_cu_swap.defaults_currency_code
 and   rate_index_default.rate_index_code = rateindex_cu_swap.defaults_rateindex_code)
go


/* now we have to split the 4 concatenated fields in the RATEINDEX_CU_SWAP RATE_INDEX  column */
/* stored as "currency/rate_index_code/tenor/source" and update them into 4 seperate          */
/* columns in the RATE_INDEX_DEFAULT table                                                    */

/* proc to split up the 4 rate_index values stored as    */
/*  "currency/rate_index_code/tenor/source" and put into */
/* 4 seperate columns in the rate_index_code table       */

create procedure reparse_rate_index
as
declare  @my_defaults_currency_code varchar(32)
declare  @my_defaults_rateindex_code varchar(32)
declare  @my_rate_index varchar(32)
declare  @v_curr_code  varchar(32)
declare  @v_ri_code varchar(32)
declare  @v_ri_tenor varchar(32)
declare  @v_ri_source varchar(32)
declare  @v_pos int
declare  @v_length int
declare  @v_chunk varchar(32)
declare  @v_tenor varchar(32)
declare  @v_tenor_amount int
declare  @v_multiplier int
declare  @v_ri_tenor_int  int
declare  @x varchar(32)

 declare c1 cursor for
  select defaults_currency_code, defaults_rateindex_code, rate_index 
    from rateindex_cu_swap where rate_index is not null

declare c2 cursor for
  select defaults_currency_code, defaults_rateindex_code, rate_index 
    from rateindex_cu_swap where rate_index is not null

declare c3 cursor for
  select defaults_currency_code, defaults_rateindex_code, rate_index 
    from rateindex_cu_swap where rate_index is not null

declare c4 cursor for
  select defaults_currency_code, defaults_rateindex_code, rate_index 
    from rateindex_cu_swap where rate_index is not null

open c1
  fetch c1 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
  while (@@sqlstatus = 0)
    begin
     select @v_pos = charindex('/',@my_rate_index)
     select @v_curr_code = substring(@my_rate_index,1,@v_pos-1)
     update rate_index_default set cu_swap_currency_code = @v_curr_code 
       where rate_index_default.currency_code = @my_defaults_currency_code
       and rate_index_default.rate_index_code = @my_defaults_rateindex_code
    fetch c1 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
   end 
 close c1
 deallocate cursor c1

open c2
  fetch c2 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
  while (@@sqlstatus = 0)
    begin
     select @v_pos = charindex('/',@my_rate_index)
     select @v_chunk = substring(@my_rate_index,@v_pos+1,char_length(@my_rate_index)-@v_pos)
     select @v_pos = charindex('/',@v_chunk)
     select @v_ri_code = substring(@v_chunk,1,@v_pos-1)
     update rate_index_default set cu_swap_rate_index_code = @v_ri_code 
       where rate_index_default.currency_code = @my_defaults_currency_code
       and rate_index_default.rate_index_code = @my_defaults_rateindex_code 
    fetch c2 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
   end 
 close c2
 deallocate cursor c2


open c3
  fetch c3 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
  while (@@sqlstatus = 0)
    begin                         
     select @v_pos = charindex('/',@my_rate_index)
     select @v_chunk = substring(@my_rate_index,@v_pos+1,char_length(@my_rate_index)-@v_pos)
     select @v_pos = charindex('/',@v_chunk)
     select @v_chunk = substring(@v_chunk,@v_pos+1,char_length(@v_chunk)-@v_pos)
     select @v_pos = charindex('/',@v_chunk)
     select @v_ri_tenor = substring(@v_chunk,1,@v_pos-1)
     select @v_tenor_amount = convert(int,substring(@v_ri_tenor,1,1))
     select @v_tenor = substring(@v_ri_tenor,2,1)
   
     if @v_tenor = 'Y' select @v_multiplier = 360    
     if @v_tenor = 'M' select @v_multiplier =  30    
     if @v_tenor = 'W' select @v_multiplier =   7    
     if @v_tenor = 'D' select @v_multiplier =   1

     select @v_ri_tenor_int = (@v_tenor_amount * @v_multiplier) 

     select @x = convert(varchar,@v_ri_tenor_int)
     print @x

   update rate_index_default set cu_swap_rate_index_tenor = @v_ri_tenor_int
     where rate_index_default.currency_code = @my_defaults_currency_code
       and rate_index_default.rate_index_code = @my_defaults_rateindex_code

 
    fetch c3 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
   end 
 close c3
 deallocate cursor c3

open c4
  fetch c4 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
  while (@@sqlstatus = 0)
    begin
     select @v_chunk = reverse(@my_rate_index)
     select @v_pos = charindex('/',@v_chunk)
     select @v_pos = char_length(@my_rate_index)-@v_pos
     select @v_ri_source = substring(@my_rate_index,@v_pos+2,char_length(@my_rate_index))   
     update rate_index_default set cu_swap_rate_index_source = @v_ri_source 
       where rate_index_default.currency_code = @my_defaults_currency_code
       and rate_index_default.rate_index_code = @my_defaults_rateindex_code
    fetch c4 into @my_defaults_currency_code, @my_defaults_rateindex_code, @my_rate_index
   end 
 close c4
 deallocate cursor c4
commit
go

exec sp_procxmode 'reparse_rate_index','anymode'
go

exec reparse_rate_index
go

drop procedure reparse_rate_index
go

/* OK we're done with rate_index object now  */

/* ################################################################################### */

/* still to apply some defaults of 0 in some places and make them NOT NULL also   */

update rate_index_default set spc_lag_b = 0 where spc_lag_b is null
go
alter table rate_index_default modify spc_lag_b not null
go

update rate_index_default set spc_lag_bus_cal_b = 0 where spc_lag_bus_cal_b is null
go
alter table rate_index_default modify  spc_lag_bus_cal_b not null
go

update rate_index_default set principal_actual_b = 0 where principal_actual_b is null
go
alter table rate_index_default modify principal_actual_b  not null
go

update rate_index_default set discount_method = 0 where discount_method is null
go
alter table rate_index_default modify  discount_method not null
go

update rate_index_default set fxd_period_rule = 'ADJUSTED' where fxd_period_rule is null
go
alter table rate_index_default replace fxd_period_rule default 'ADJUSTED'
go
alter table rate_index_default modify fxd_period_rule not null
go

update rate_index_default set flt_period_rule = 'ADJUSTED' where flt_period_rule is null
go
alter table rate_index_default replace flt_period_rule default 'ADJUSTED'
go
alter table rate_index_default modify flt_period_rule not null
go

update rate_index_default set man_first_reset_b = 0 where man_first_reset_b is null
go
alter table rate_index_default replace man_first_reset_b default 0
go
alter table rate_index_default modify man_first_reset_b not null
go

update rate_index_default set start_offset = 0 where start_offset is null
go
alter table rate_index_default replace start_offset default 0
go
alter table rate_index_default modify start_offset not null
go

update rate_index_default set  day_of_week = 0 where day_of_week is null
go
alter table rate_index_default replace day_of_week default 0
go
alter table rate_index_default modify day_of_week not null
go

update rate_index_default set cutoff_days = 0 where cutoff_days is null
go
alter table rate_index_default replace cutoff_days default 0
go
alter table rate_index_default modify cutoff_days not null
go

update rate_index_default set unadjust_reset = 0 where unadjust_reset  is null
go
alter table rate_index_default replace unadjust_reset default 0
go
alter table rate_index_default modify unadjust_reset not null
go

update rate_index_default set spc_lag_offset = 0 where spc_lag_offset  is null
go
alter table rate_index_default replace spc_lag_offset default 0
go
alter table rate_index_default modify spc_lag_offset not null
go

if not exists (select 1 from syscolumns,sysobjects where convert(bit, (status &8))=1 and 
               sysobjects.name='rate_index_default' and sysobjects.id=syscolumns.id and 
               syscolumns.name='interp_rounding_mthd')
begin
exec('alter table rate_index_default modify interp_rounding_mthd null')
end
go 

alter table rate_index_default replace interp_rounding_mthd default null
go
update rate_index_default set interp_rounding_mthd = null where interp_rounding_mthd = 'NONE'
go

update rate_index_default set interp_rounding_dec = 0 where interp_rounding_dec is null
go
alter table rate_index_default replace interp_rounding_dec default 0
go

update rate_index_default set no_auto_interp_b = 0 where no_auto_interp_b is null
go
alter table rate_index_default replace no_auto_interp_b default 0
go


sp_rename rateindex_cu_swap, rateindex_cu_swap_old
go
sp_rename inflation_index, inflation_index_old
go
sp_rename rate_avg_method, rate_avg_method_old
go

/* OK we're done with rate_index object now  */

/* ################################################################################### */

/* End of Sybase/hibernate migration script - phase 1  */


/* ################################################################################### */

/* commodities swap2/otc2 changes    */

select * into cf_sch_gen_params_bak from cf_sch_gen_params
go
select * into product_commodity_swap2_bak from product_commodity_swap2
go
select * into commodity_leg2_bak from commodity_leg2
go

alter table cf_sch_gen_params drop constraint ct_primarykey
go

create procedure comm_swap1 
as

declare @v_product_id int
declare @v_leg_id   int
declare @v_start_date datetime
declare @v_end_date datetime
declare @v_payment_lag int
declare @v_payment_calendar varchar(64)
declare @v_fixing_date_policy int
declare @v_fixing_calendar varchar(64)
declare @v_payment_offset_bus_b int
declare @v_payment_day int
declare @v_payment_date_rule int
declare @v_payment_date_roll varchar(16)
declare @v_fx_reset_id int
declare @v_fx_calendar varchar(64)
declare @v_pay_leg_id int
declare @v_receive_leg_id int
declare @v_currency_code varchar(3)
declare @v_averaging_policy varchar(64)
declare @v_custom_flows_b int
declare @v_avg_rounding_policy varchar(64)

declare c1 cursor for
   select cf.product_id,
          cf.leg_id,
          cf.start_date,
          cf.end_date,
          cf.payment_lag,
          cf.payment_calendar,
          cf.fixing_date_policy,
          cf.fixing_calendar,
          cf.payment_offset_bus_b,
          cf.payment_day,
          cf.payment_date_rule,
          cf.payment_date_roll,
          cf.fx_reset_id,
          cf.fx_calendar,
          pcs2.pay_leg_id,
          pcs2.receive_leg_id,
          pcs2.currency_code,
          pcs2.averaging_policy,
          pcs2.custom_flows_b,
          pcs2.avg_rounding_policy
  from cf_sch_gen_params cf, product_commodity_swap2 pcs2
    where cf.product_id = pcs2.product_id and cf.leg_id = 0


open c1 
  fetch c1 into @v_product_id, @v_leg_id, @v_start_date, @v_end_date, @v_payment_lag, @v_payment_calendar,
      @v_fixing_date_policy, @v_fixing_calendar, @v_payment_offset_bus_b, @v_payment_day, @v_payment_date_rule,
      @v_payment_date_roll, @v_fx_reset_id, @v_fx_calendar, @v_pay_leg_id, @v_receive_leg_id, @v_currency_code,
      @v_averaging_policy, @v_custom_flows_b, @v_avg_rounding_policy 
   while (@@sqlstatus = 0)
     begin
       insert into cf_sch_gen_params (product_id, leg_id, start_date, end_date, payment_lag, payment_calendar, 
         fixing_date_policy, fixing_calendar, payment_offset_bus_b, payment_day, payment_date_rule,
         payment_date_roll, fx_reset_id, fx_calendar ) 
       values ( @v_product_id,@v_pay_leg_id, @v_start_date, @v_end_date, @v_payment_lag, @v_payment_calendar,
          @v_fixing_date_policy, @v_fixing_calendar, @v_payment_offset_bus_b, @v_payment_day, @v_payment_date_rule,
          @v_payment_date_roll, @v_fx_reset_id, @v_fx_calendar)

       insert into cf_sch_gen_params (product_id, leg_id, start_date, end_date, payment_lag, payment_calendar, 
         fixing_date_policy, fixing_calendar, payment_offset_bus_b, payment_day, payment_date_rule,
         payment_date_roll, fx_reset_id, fx_calendar ) 
       values ( @v_product_id,@v_receive_leg_id, @v_start_date, @v_end_date, @v_payment_lag, @v_payment_calendar,
          @v_fixing_date_policy, @v_fixing_calendar, @v_payment_offset_bus_b, @v_payment_day, @v_payment_date_rule,
          @v_payment_date_roll, @v_fx_reset_id, @v_fx_calendar)

       update commodity_leg2 set averaging_policy = @v_averaging_policy, 
                                 avg_rounding_policy = @v_avg_rounding_policy
                      where leg_id = @v_pay_leg_id or leg_id = @v_receive_leg_id


  fetch c1 into @v_product_id, @v_leg_id, @v_start_date, @v_end_date, @v_payment_lag, @v_payment_calendar,
      @v_fixing_date_policy, @v_fixing_calendar, @v_payment_offset_bus_b, @v_payment_day, @v_payment_date_rule,
      @v_payment_date_roll, @v_fx_reset_id, @v_fx_calendar, @v_pay_leg_id, @v_receive_leg_id, @v_currency_code,
      @v_averaging_policy, @v_custom_flows_b, @v_avg_rounding_policy 
  end 
   
    delete from cf_sch_gen_params where leg_id = 0 and product_id in (select product_id from product_commodity_swap2)

    close c1
   deallocate cursor c1
go

exec sp_procxmode 'comm_swap1','anymode'
go

exec comm_swap1
go 
   

create procedure comm_swap2
as

declare @v_pay_leg_id int
declare @v_receive_leg_id int
declare @v_comm_reset_id int

declare c1 cursor for 
select
  pcs2.pay_leg_id,
  pcs2.receive_leg_id,
  cl2.comm_reset_id
FROM
 product_commodity_swap2 pcs2, commodity_leg2 cl2
where
  cl2.leg_id = pcs2.pay_leg_id or cl2.leg_id = pcs2.receive_leg_id


open c1
fetch c1 into  @v_pay_leg_id, @v_receive_leg_id, @v_comm_reset_id
   WHILE  (@@sqlstatus=0)
     begin
       if @v_comm_reset_id = 0 
         update commodity_leg2 set comm_reset_id = (
           select max(a.comm_reset_id) from commodity_leg2 a where
           a.comm_reset_id !=0 and a.leg_id = @v_pay_leg_id or a.leg_id = @v_receive_leg_id)
         where leg_id =  @v_pay_leg_id or leg_id = @v_receive_leg_id

      fetch c1 into  @v_pay_leg_id, @v_receive_leg_id, @v_comm_reset_id


end
close c1
deallocate cursor c1
go

exec sp_procxmode 'comm_swap2','anymode'
go

exec comm_swap2
go


create procedure comm_swap3 
as
declare @v_product_id int
declare @v_leg_id int
declare @v_fx_reset_id int
declare @v_fx_calendar varchar(64)
declare @v_pay_leg_id int
declare @v_receive_leg_id int
declare @v_temp_calendar varchar(64)
   
declare c1 cursor for select cf.product_id,
       cf.leg_id,
       cl2.fx_reset_id,
       cl2.fx_calendar,
       pcs2.pay_leg_id,
       pcs2.receive_leg_id
 from commodity_leg2 cl2, cf_sch_gen_params cf,  product_commodity_swap2 pcs2
where cf.product_id = pcs2.product_id and cl2.leg_id = cf.leg_id

open c1 
fetch c1 into @v_product_id, @v_leg_id,@v_fx_reset_id, @v_fx_calendar, @v_pay_leg_id, @v_receive_leg_id 
  WHILE  (@@sqlstatus=0)
    begin
     if @v_fx_calendar is null select @v_temp_calendar = ' ' else select @v_temp_calendar = @v_fx_calendar

        update cf_sch_gen_params set fx_reset_id = @v_fx_reset_id ,fx_calendar = @v_temp_calendar
           where leg_id = @v_pay_leg_id
         
        update cf_sch_gen_params set fx_reset_id = @v_fx_reset_id, fx_calendar = @v_temp_calendar
           where leg_id = @v_receive_leg_id

fetch c1 into @v_product_id, @v_leg_id,@v_fx_reset_id, @v_fx_calendar, @v_pay_leg_id, @v_receive_leg_id 

end
close c1
deallocate cursor c1
go

exec sp_procxmode 'comm_swap3','anymode'
go

exec comm_swap3
go 

create procedure otc2 
as
declare @v_product_id numeric
declare @v_leg_id numeric
declare @v_averaging_policy varchar(64)
declare @v_avg_rounding_policy varchar(64)
declare @fx_reset_id numeric
declare @fx_calendar varchar(64)
declare @v_temp_calendar varchar(64)

declare c1 cursor for
   select cf.product_id,
      pco2.leg_id,
      pco2.averaging_policy,
      pco2.avg_rounding_policy
  from cf_sch_gen_params cf, product_commodity_otcoption2 pco2
    where cf.product_id = pco2.product_id and cf.leg_id = 0

open c1
fetch c1 into @v_product_id, @v_leg_id, @v_averaging_policy, @v_avg_rounding_policy
 WHILE  (@@sqlstatus=0)
 begin 
   update cf_sch_gen_params set leg_id = @v_leg_id where product_id = @v_product_id

   update commodity_leg2 set averaging_policy = @v_averaging_policy,
                             avg_rounding_policy = @v_avg_rounding_policy
       where leg_id = @v_leg_id

fetch c1 into @v_product_id, @v_leg_id, @v_averaging_policy, @v_avg_rounding_policy


end 

declare @x_product_id int
declare @x_leg_id int
declare @x_fx_reset_id int
declare @x_fx_calendar varchar(64)
declare @x_temp_calendar varchar(64)

declare c2 cursor for
   select cf.product_id,
       cf.leg_id,
       cl2.fx_reset_id,
       cl2.fx_calendar
  from commodity_leg2 cl2, cf_sch_gen_params cf
    where cl2.leg_id = cf.leg_id

open c2 
fetch c2 into @x_product_id, @x_leg_id, @x_fx_reset_id, @x_fx_calendar
 WHILE  (@@sqlstatus=0)
   begin
   if @x_fx_calendar is null select @x_temp_calendar = ' ' else select @x_temp_calendar = @x_fx_calendar

    update cf_sch_gen_params set fx_reset_id = @x_fx_reset_id, fx_calendar = @x_temp_calendar
      where leg_id = @x_leg_id

fetch c2 into @x_product_id, @x_leg_id, @x_fx_reset_id, @x_fx_calendar

end 

close c1
deallocate cursor c1

close c2
deallocate cursor c2

go

exec sp_procxmode 'otc2','anymode'
go

exec otc2
go 

drop procedure comm_swap1
go
drop procedure comm_swap2
go
drop procedure comm_swap3
go
drop procedure otc2
go

/* end of commodities swap2/otc2 stuff */


/* start of XML "inserts"   */

INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Exotic', 'apps.risk.ExoticAnalysisViewer', 0 )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Benchmark', 'apps.risk.BenchmarkAnalysisViewer', 0 )
go
INSERT INTO calypso_seed ( last_id, seed_name ) VALUES ( 1000, 'FXResetProductInfo' )
go
INSERT INTO calypso_seed ( last_id, seed_name ) VALUES ( 1000, 'Calibration' )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_calibratible_model', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_calibrator', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
go
add_domain_values 'eco_pl_column', 'INCOME_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values 'workflowRuleTransfer', 'CheckUnauthorizedSDI', '' 
go
add_domain_values 'workflowRuleMessage', 'CheckUnauthorizedSDI', '' 
go
add_domain_values   'accEventType', 'NOMINAL_ADJUST', '' 
go
add_domain_values   'function', 'AllowInsertRemoveTransferRules', 'Allow user to insert or remove customized transfer rules in BackOffice SDI Panel' 
go
add_domain_values   'productType', 'CommodityCertificate', 'Commodity Certificates for Physical Commodities' 
go
add_domain_values   'incomingType', 'MT320', 'INC_CASHCONFIRM' 
go
add_domain_values   'domainName', 'IncomingSwiftTrade', 'Incomimg Swift Message Template Name for Trade Confirmation' 
go
add_domain_values 'IncomingSwiftTrade', 'MT300','' 
go
add_domain_values 'IncomingSwiftTrade', 'MT305' ,''
go
add_domain_values 'IncomingSwiftTrade', 'MT306' ,''
go
add_domain_values 'IncomingSwiftTrade', 'MT320' ,''
go
add_domain_values   'domainName', 'tradeCancelStatus', 'Status where the trade is considered canceled. Should be a subset of domain tradeStatus.' 
go
add_domain_values   'domainName', 'scenarioRule', 'Custom Scenario Rules' 
go
add_domain_values   'VolSurface.gensimple', 'QuadraticSmileParams', 'Smile adjustment surface containing user defined Alpha and Beta values' 
go
add_domain_values   'VolSurface.gensimple', 'BondOptionQuadraticSmile', 'BondOption Smile adjusted surface that uses a QuadraticSmileParams and a Bond Option vol surface to create its own surface' 
go
add_domain_values   'volSurfaceGenerator', 'BondOption', 'BondOption volatility surface' 
go
add_domain_values   'volSurfaceGenerator', 'LGMM2FMultiStartBestFit', 'Calibrates the LGMM2F model with constant parameter in a best-fit sense' 
go
add_domain_values   'domainName', 'CallAccountType', 'Used in acc_account to indicate the type of a CallAccount.' 
go
add_domain_values   'domainName', 'AccountHolderRole', 'Used in acc_account to indicate the role of a CallAccount.' 
go
add_domain_values   'domainName', 'AccountSettleMethod', 'Used in acc_account to indicate the SettleMethod od the sdi linked to a CallAccount.' 
go
add_domain_values   'tradeKeyword', 'InventoryAgent', '' 
go
add_domain_values   'tradeKeyword', 'AccountNumber', '' 
go
add_domain_values   'tradeKeyword', 'UnavailabilityReason', '' 
go
add_domain_values   'tradeTmplKeywords', 'InventoryAgent', '' 
go
add_domain_values   'tradeTmplKeywords', 'AccountNumber', '' 
go
add_domain_values   'tradeTmplKeywords', 'UnavailabilityReason', '' 
go
add_domain_values   'engineParam', 'DateType', '' 
go
add_domain_values   'engineParam', 'BALANCE_MODE', '' 
go
add_domain_values   'domainName', 'dayChangeRule', 'Day Change Rule' 
go
add_domain_values   'domainName', 'CurveSeasonality.adj', '' 
go
add_domain_values   'domainName', 'absMktDataUsage', 'Usage codes for assigned ABS Market Data Items' 
go
add_domain_values   'REPORT.Types', 'AccountStatement', 'AccountStatement Report' 
go
add_domain_values   'REPORT.Types', 'AccountStatementConfig', 'AccountStatementConfig Report' 
go
add_domain_values   'REPORT.Types', 'CAWarrantGeneration', 'CAWarrantGeneration Report' 
go
add_domain_values   'REPORT.Types', 'CorporateActionSimulation', 'CorporateActionSimulation Report' 
go
add_domain_values   'REPORT.Types', 'GenericComment', 'GenericComment Report' 
go
add_domain_values   'REPORT.Types', 'WarrantTransformation', 'WarrantTransformation Report' 
go
delete from domain_values where name='AssetSwap.extendedType' and value='CreditContingent'
go
add_domain_values   'AssetSwap.extendedType', 'CreditContingent', 'Asset swap contingent on reference entity' 
go
add_domain_values   'AssetSwap.extendedType', 'CreditContingentBasket', 'Asset swap contingent on basket reference entity' 
go
add_domain_values   'classAuditMode', 'CalculationServerConfig', '' 
go
add_domain_values   'domainName', 'unavailabilityReason', 'List of unavailability reasons' 
go
add_domain_values   'securityCode', 'LoanXID', '' 
go
add_domain_values   'domainName', 'keyword.terminationReason', 'List of termination reason' 
go
add_domain_values   'keyword.terminationReason', 'Assigned', '' 
go
add_domain_values   'keyword.terminationReason', 'Manual', '' 
go
add_domain_values   'keyword.terminationReason', 'BoughtBack', '' 
go
add_domain_values   'keyword.terminationReason', 'ContractRevision', '' 
go
add_domain_values   'volatilityType', 'BondOption', '' 
go
add_domain_values   'futureUnderType', 'Equity', '' 
go
add_domain_values   'domainName', 'ExternalMessageField.Instructions', '' 
go
add_domain_values   'scheduledTask', 'NAV_CALC', 'Market Index NAV Calculation' 
go
add_domain_values   'userAttributes', 'FX Default Currency Pair', '' 
go
add_domain_values   'userAttributes', 'FX Default CounterParty', '' 
go
add_domain_values   'userAttributes', 'FX Default Broker', '' 
go
add_domain_values   'userAttributes', 'FX Default Prime Broker', '' 
go
add_domain_values   'userAttributes', 'FX User Type', '' 
go
add_domain_values   'domainName', 'CommoditySwap2.Pricer', 'Pricers for CommoditySwap2' 
go
add_domain_values   'CommoditySwap2.Pricer', 'PricerCommoditySwap2', 'Pricer for the CommoditySwap2 product' 
go
add_domain_values   'domainName', 'CommodityOTCOption2.Pricer', 'Pricers for CommodityOTCOption2' 
go
add_domain_values   'CommodityOTCOption2.Pricer', 'PricerCommodityOTCOption2', 'Pricer for the CommodityOTCOption2 product' 
go
add_domain_values   'domainName', 'CommodityCertificate.Pricer', 'Pricers for CommodityCertificates' 
go
add_domain_values   'CommodityCertificate.Pricer', 'PricerCommodityCertificate', 'Pricer for the CommodityCertificate product' 
go
add_domain_values   'DispatcherParamsDatasynapse', 'DataSynapse username', 'string' 
go
add_domain_values   'DispatcherParamsDatasynapse', 'DataSynapse password', 'string' 
go
add_domain_values   'keyword.terminationReason', 'Novation', '' 
go
add_domain_values   'userAccessPermAttributes', 'Max.Task', 'Type to be enforced by reports' 
go
add_domain_values   'domainName', 'PCCreditRatingLEAttributesOrder', 'Order of attributes separated with a comma' 
go
add_domain_values   'domainName', 'creditRatingSource', '' 
go
add_domain_values   'workflowRuleTrade', 'CATransformation', '' 
go
add_domain_values   'tradeAction', 'CONTINUE', 'User continues trade. It means the current trade is ended but continued by another trade. It looks like a rollover.' 
go
add_domain_values   'ScenarioViewerClassNames', 'apps.risk.Scenario2DMarketDataItemViewer', 'A generic viewer for perturbations on 2D market data items' 
go
add_domain_values   'ScenarioViewerClassNames', 'apps.risk.ScenarioSeasonalityRiskViewer', 'Display monthly seasonality risk measures' 
go
add_domain_values   'ScenarioViewerClassNames', 'apps.risk.ScenarioInflationFixingReportViewer', 'Display monthly inflation risk measures' 
go
add_domain_values   'accEventType', 'INTEREST_PREMIUMLEG', '' 
go
add_domain_values   'accEventType', 'INTEREST_SHORTFALL', '' 
go
add_domain_values   'accEventType', 'PRINCIPAL_SHORTFALL', '' 
go
add_domain_values   'accEventType', 'WRITE_DOWN', '' 
go
add_domain_values   'accEventType', 'FIXED_CORRECTION', '' 
go
add_domain_values   'accEventType', 'FLOAT_CORRECTION', '' 
go
add_domain_values   'accEventType', 'INTEREST_SHORTFALL_REIM', '' 
go
add_domain_values   'accEventType', 'PRINCIPAL_SHORTFALL_REIM', '' 
go
add_domain_values   'accEventType', 'WRITE_DOWN_REIM', '' 
go
add_domain_values   'accEventType', 'RECLASS_LIABILITY', '' 
go
add_domain_values   'accEventType', 'RECLASS_ASSET', '' 
go
add_domain_values   'accEventType', 'RECLASS_ACCOUNT', '' 
go
add_domain_values   'domainName', 'currencyDefaultAttribute', '' 
go
add_domain_values   'domainName', 'currencyPairAttribute', '' 
go
add_domain_values   'domainName', 'FXOptVolSurfUndSource', 'FX Option volatility source underlying source' 
go
add_domain_values   'domainName', 'assetSwapUpfrontFeeType', 'Asset Swap Upfront Fee Type' 
go
add_domain_values   'domainName', 'assetSwapRedemptionFeeType', '' 
go
add_domain_values   'assetSwapUpfrontFeeType', 'UPFRONT_FEE', 'Asset Swap Upfront Fee' 
go
add_domain_values   'assetSwapRedemptionFeeType', 'REDEMPTION_FEE', 'Asset Swap Redemption Fee' 
go
add_domain_values   'Bond.Pricer', 'PricerBondLGMM2F', 'Exotic note pricer using LGMM2F model' 
go
add_domain_values   'CDSNthLoss.Pricer', 'PricerCDSNthLossOFMHermite', 'NthLoss pricer using a fast Hermite expansion of the Gaussian one factor model.' 
go
add_domain_values   'AssetSwap.Pricer', 'PricerAssetSwapCreditContingent', 'Pricer for an AssetSwap contingent on credit events of a single reference entity' 
go
add_domain_values   'AssetSwap.Pricer', 'PricerAssetSwapCreditContBasket', 'Pricer for an AssetSwap contingent on credit events of a basket of reference entities' 
go
add_domain_values   'CDSIndexOption.Pricer', 'PricerCDSIndexOption', 'Pricer for CDSIndex Option which uses quote or underlying curves' 
go
add_domain_values   'CDSIndexOption.Pricer', 'PricerCDSIndexOptionSingleCurve', 'Pricer for CDSIndex Option which uses Probability curve assigned to basket' 
go
add_domain_values   'CallAccount.Pricer', 'PricerCallAccount', '' 
go
add_domain_values   'Bond.subtype', 'Exotic', 'Bonds with eXotic payouts' 
go
add_domain_values   'domainName', 'AssetPerformanceSwap.subtype', '' 
go
add_domain_values   'AssetPerformanceSwap.subtype', 'Total_Return', '' 
go
add_domain_values   'AssetPerformanceSwap.subtype', 'Price_Return', '' 
go
add_domain_values   'AssetPerformanceSwap.subtype', 'Future', '' 
go
add_domain_values   'AssetPerformanceSwap.subtype', 'Forward', '' 
go
add_domain_values   'FXOption.optionSubType', 'DIGITAL : DIGITAL_ONE TOUCH NO TOUCH', '' 
go
add_domain_values   'unavailabilityReason', 'NONE', '' 
go
add_domain_values   'engineName', 'BalanceEngine', '' 
go
add_domain_values   'eventClass', 'PSEventProcessAccounting', '' 
go
add_domain_values   'eventFilter', 'TransferBatchNettingFilter', 'Transfer Batch Netting Event Filter' 
go
add_domain_values   'eventFilter', 'MatchingEventFilter', 'Filter out Message not eligible for any Matching Context Event Filter' 
go
add_domain_values   'eventClass', 'PSEventBalanceReclassification', '' 
go
add_domain_values   'eventFilter', 'BalanceEngineEventFilter', 'filter for Balance Engine to check if at least one balance process_flag is ''N''' 
go
add_domain_values   'eventType', 'BALANCE_RECLASSIFICATION', '' 
go
delete from domain_values where name='eventType' and value='EX_LIQUIDATION_ERROR'
go
add_domain_values   'eventType', 'EX_LIQUIDATION_ERROR', 'Indicates an exception has occurred during liquidation.' 
go
delete from domain_values where name='exceptionType' and value='LIQUIDATION_ERROR'
go
add_domain_values   'exceptionType', 'LIQUIDATION_ERROR', 'Indicates an exception has occurred during liquidation.' 
go
add_domain_values   'exceptionType', 'BICDATA', '' 
go
add_domain_values   'function', 'OperationsProcessingProcessTrade', 'Access permission to use the Process Trades function in the Process Trades window' 
go
add_domain_values   'function', 'OperationsProcessingRegenerateEvent', 'Access permission to use the Regenerate Event function in the Process Trades window' 
go
add_domain_values   'function', 'OperationsProcessingMergeCounterparties', 'Access permission to use the Merge CounterParties function in the Process Trades window' 
go
add_domain_values   'function', 'ModifyUsedSDI', 'Access permission to Modify Used SDIs' 
go
add_domain_values   'function', 'ModifyLEManualSDIDefaultedValues', 'Access permission to Modify MSDIs Defaulted values' 
go
add_domain_values   'function', 'ModifyCalculationServerConfig', 'Access permission to create/modify/delete CalculationServer Configuration.' 
go
add_domain_values   'function', 'FXTradingSalesMargin', 'Access permission for Sales Margin Trades'
go
add_domain_values   'function', 'FXTradingBroker', 'Access permission for Broker Trades' 
go
add_domain_values   'function', 'FXTradingInternal', 'Access permission for Internal Trades' 
go
add_domain_values   'function', 'CreateCalculationServerConfig', 'Function to authorize to create/modify CalculationServer config' 
go
add_domain_values   'function', 'RemoveCalculationServerConfig', 'Function to authorize to remove CalculationServer config' 
go
add_domain_values   'marketDataUsage', 'PREPAY', 'Indicates item is a prepayment curve' 
go
add_domain_values   'marketDataUsage', 'DEFAULT', 'Indicates item is a default curve' 
go
add_domain_values   'absMktDataUsage', 'PREPAY', 'Indicates item is prepayment curve' 
go
add_domain_values   'absMktDataUsage', 'DEFAULT', 'Indicates item is default curve' 
go
add_domain_values   'absMktDataUsage', 'REC', 'Indicates item is Recovery curve' 
go
add_domain_values   'absMktDataUsage', 'DELINQUENCY', 'Indicates item is delinquency curve' 
go
add_domain_values   'domainName', 'absMktDataUsage.PREPAY', '' 
go
add_domain_values   'absMktDataUsage.PREPAY', 'CurvePrepay', '' 
go
add_domain_values   'domainName', 'absMktDataUsage.DEFAULT', '' 
go
add_domain_values   'absMktDataUsage.DEFAULT', 'CurveDefault', '' 
go
add_domain_values   'domainName', 'absMktDataUsage.REC', '' 
go
add_domain_values   'absMktDataUsage.REC', 'CurveRecovery', '' 
go
add_domain_values   'domainName', 'absMktDataUsage.DELINQUENCY', '' 
go
add_domain_values   'absMktDataUsage.DELINQUENCY', 'CurveDelinquency', '' 
go
add_domain_values   'function', 'AddModifyAccountStatement', 'Access permission to Add or Modify an Account Statement Config' 
go
add_domain_values   'function', 'RemoveAccountStatement', 'Access permission to Remove an Account Statement Config' 
go
add_domain_values   'function', 'CreateCDSIndexDefinition', 'Access permission to create a CDS Index Definition' 
go
add_domain_values   'marketDataType', 'CurvePrepay', '' 
go
add_domain_values   'marketDataType', 'CurveDefault', '' 
go
add_domain_values   'marketDataType', 'CurveDelinquency', '' 
go
add_domain_values   'riskAnalysis', 'CommodityCertificateStock', '' 
go
add_domain_values   'quoteType', 'Future32', '' 
go
add_domain_values   'riskAnalysis', 'ScenarioTaylorSeriesInput', 'Compute and store taylor series inputs' 
go
add_domain_values   'riskAnalysis', 'Exotic', '' 
go
add_domain_values   'riskAnalysis', 'Benchmark', '' 
go
add_domain_values   'scheduledTask', 'GENERATE_CORRELATION_SURFACE', '' 
go
add_domain_values   'scheduledTask', 'PS_RERUN_ANALYSIS', '' 
go
add_domain_values   'scheduledTask', 'EOD_TRANSFER_NETTING', '' 
go
add_domain_values   'scheduledTask', 'BALANCE_RECLASSIFICATION', '' 
go
add_domain_values   'scheduledTask', 'RECON_INV_PL_POSITIONS', '' 
go
add_domain_values   'scheduledTask', 'ACCOUNT_BALANCE', 'Update balance positions for next PROJECTED_DAYS' 
go
add_domain_values   'scheduledTask', 'ACCOUNT_BALANCE_EVENT', 'Generate events to update account balances' 
go
add_domain_values   'scheduledTask', 'CFD_CA', '' 
go
add_domain_values   'scheduledTask', 'CHECK_BICDATA', 'Check the valid swift contact in the Schedule Task' 
go
add_domain_values   'tradeKeyword', 'PartialNovatedTo', '' 
go
add_domain_values   'tradeKeyword', 'CAVersion', '' 
go
add_domain_values   'MESSAGE.Templates', 'cdsABSConfirm.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'VarianceSwapConfirmation.html', '' 
go
add_domain_values   'applicationName', 'CalculationServer', 'CalculationServer' 
go
add_domain_values   'riskPresenter', 'MatrixSheet', '' 
go
add_domain_values   'riskPresenter', 'Benchmark', '' 
go
add_domain_values   'riskPresenter', 'Hedge', 'Hedge Analysis' 
go
add_domain_values   'riskPresenter', 'VegaByStrike', 'VegaByStrike Analysis' 
go
add_domain_values   'riskPresenter', 'CommodityCertificateStock', 'CommodityCertificateStock Analysis' 
go
add_domain_values   'domainName', 'SwiftMessage.Action', 'Mapping of ack/nack action' 
go
add_domain_values   'SwiftMessage.Action', 'ACK', 'ACK' 
go
add_domain_values   'SwiftMessage.Action', 'NACK', 'NACK' 
go
add_domain_values   'domainName', 'MsgAttributes.NackReason', 'Mapping of Nack Reason' 
go
add_domain_values   'MsgAttributes.NackReason', 'H01', 'Basic Header not present or format error block 1' 
go
add_domain_values   'MsgAttributes.NackReason', 'H02', 'Application identifier not A (GPA) or F (FIN)' 
go
add_domain_values   'MsgAttributes.NackReason', 'H03', 'Invalid Service Message-identifier (unknown or not allowed from user)' 
go
add_domain_values   'MsgAttributes.NackReason', 'H10', 'Bad LT address or application not enabled for the LT' 
go
add_domain_values   'MsgAttributes.NackReason', 'H15', 'Bad session number' 
go
add_domain_values   'MsgAttributes.NackReason', 'H20', 'Error in the ISN' 
go
add_domain_values   'MsgAttributes.NackReason', 'H21', 'Error in the message sender''s branch code' 
go
add_domain_values   'MsgAttributes.NackReason', 'H25', 'Application header format error or not present when mandatory' 
go
add_domain_values   'MsgAttributes.NackReason', 'H26', 'Input/output identifier not ''I'' (on input from LT)' 
go
add_domain_values   'MsgAttributes.NackReason', 'H30', 'Message type does not exist for this application' 
go
add_domain_values   'MsgAttributes.NackReason', 'H40', 'This priority does not exist for this message category' 
go
add_domain_values   'MsgAttributes.NackReason', 'H50', 'Destination address error' 
go
add_domain_values   'MsgAttributes.NackReason', 'H51', 'Invalid sender or receiver for message type or mode' 
go
add_domain_values   'MsgAttributes.NackReason', 'H52', 'MT 072, selection of Test AND Training mode/version, MT 077 Additional Selection Criteria for FIN are not allowed while a FIN session is open' 
go
add_domain_values   'MsgAttributes.NackReason', 'H55', 'Message type not allowed for fallback session for MT 030' 
go
add_domain_values   'MsgAttributes.NackReason', 'H80', 'Delivery option error' 
go
add_domain_values   'MsgAttributes.NackReason', 'H81', 'Obsolescence period error' 
go
add_domain_values   'MsgAttributes.NackReason', 'H98', 'other format error in the Basic Header or in the Application Header' 
go
add_domain_values   'MsgAttributes.NackReason', 'H99', 'Invalid receiver destination Or Invalid date or time' 
go
add_domain_values   'domainName', 'CustomStaticDataFilter', 'Custom Static Data Filter Names' 
go
add_domain_values   'productTypeReportStyle', 'Cash', 'Cash  ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'WarrantIssuance', 'WarrantIssuance ReportStyle' 
go
add_domain_values   'domainName', 'LegalEntitySelector', 'Legal Entity Selector' 
go
add_domain_values   'domainName', 'CommodityCumulativeDailyFwdPointKeywords', 'keywords to differentiate dialy forward point from monthly forward point' 
go
add_domain_values   'CommodityCumulativeDailyFwdPointKeywords', 'DD', 'Daily foward point keyword' 
go
add_domain_values   'CommodityCumulativeDailyFwdPointKeywords', 'Day', 'Daily foward point keyword'
go
add_domain_values   'CommodityCumulativeDailyFwdPointKeywords', 'Daily', 'Daily foward point keyword' 
go
add_domain_values   'domainName', 'CommodityCumulativeMonthlyFwdPointKeywords', 'keywords to differentiate monthly forward point from daily forward point' 
go
add_domain_values   'CommodityCumulativeMonthlyFwdPointKeywords', 'DM', 'Monthly foward point keyword' 
go
add_domain_values   'CommodityCumulativeMonthlyFwdPointKeywords', 'Month', 'Monthly foward point keyword' 
go
add_domain_values   'domainName', 'PhysicalCommodityType', 'Supported behavioral types of physically represented Commodities' 
go
add_domain_values   'PhysicalCommodityType', 'Storage Based', 'Commodities that are physically stored at a location for a cost. (ie Agriculture)' 
go
add_domain_values   'PhysicalCommodityType', 'Vintage Based', 'Commodities that are traded based on vintage year(ie Emmision Credits)' 
go
add_domain_values   'domainName', 'CommodityCertificate.Vintage', 'Vintages used for Vintage Based Commodity Certificates' 
go
add_domain_values   'CommodityCertificate.Vintage', '2008', 'The 2008 Vintage year' 
go
add_domain_values   'CommodityCertificate.Vintage', '2009', 'The 2009 Vintage year' 
go
add_domain_values   'CommodityCertificate.Vintage', '2010', 'The 2010 Vintage year' 
go
add_domain_values   'domainName', 'scenarioMarketDataFilters', '' 
go
add_domain_values   'scenarioMarketDataFilters', 'HyperSurface', '' 
go
add_domain_values   'marketDataType', 'HyperSurfaceImpl', '' 
go
add_domain_values   'marketDataUsage', 'HyperSurface', '' 
go
add_domain_values   'domainName', 'hyperSurfaceSubTypes', '' 
go
add_domain_values   'domainName', 'hyperSpaceContainers', '' 
go
add_domain_values   'hyperSpaceContainers', 'Default', '' 
go
add_domain_values   'domainName', 'hyperSurfaceGenerators', '' 
go
add_domain_values   'domainName', 'hyperSpaceInterpolators', '' 
go
add_domain_values   'hyperSurfaceGenerators', 'SimpleDefault', '' 
go
add_domain_values   'hyperSpaceInterpolators', 'SimpleNoInterp', '' 
go
add_domain_values   'hyperSpaceInterpolators', '1DLinear', '' 
go
add_domain_values   'hyperSpaceInterpolators', '1DLogLinear', '' 
go
add_domain_values   'hyperSpaceInterpolators', '1DSpline', '' 
go
add_domain_values   'hyperSpaceInterpolators', '2DLinear', '' 
go
add_domain_values   'Swap.Pricer', 'PricerSwapDemoUsingHyperSurface', '' 
go
add_domain_values   'hyperSpaceInterpolators', '3DLinear', '' 
go
add_domain_values   'hyperSpaceInterpolators', '4DLinear', '' 
go
add_domain_values   'scenarioRule', 'HyperSurface', '' 
go
add_domain_values   'domainName', 'calibratibleModels', '' 
go
add_domain_values   'domainName', 'calibrations', '' 
go
add_domain_values   'domainName', 'CustomCalibrationFrameConfig', '' 
go
add_domain_values   'domainName', 'CustomCalibrationMeasureConfig', '' 
go
add_domain_values   'calibratibleModels', 'CalibratibleLGMModel', '' 
go
add_domain_values   'calibrators', 'LGMCalibrator', '' 
go
add_domain_values   'CustomCalibrationFrameConfig', 'LGMFrameConfig', '' 
go
add_domain_values   'CustomCalibrationMeasureConfig', 'LGMCalibrationMeasureConfig', '' 
go
add_domain_values   'dsInit', 'CalibrationReferenceServer', '' 
go
add_domain_values   'dayChangeRule', 'TimeZone', 'Day Change based on selected TimeZone ' 
go
add_domain_values   'dayChangeRule', 'FX', 'Day Change based on FX market convention ' 
go
add_domain_values   'marketDataType', 'CurveInflation', '' 
go
add_domain_values   'domainName', 'CurveInflation.gen', '' 
go
add_domain_values   'CurveInflation.gen', 'InflationDefault', '' 
go
add_domain_values   'CurveInflation.gen', 'InflationAdditive', '' 
go
add_domain_values   'CurveInflation.gen', 'InflationMultiplicative', '' 
go
add_domain_values   'domainName', 'CurveInflation.gensimple', '' 
go
add_domain_values   'CurveInflation.gensimple', 'InflationBasis', '' 
go
add_domain_values   'domainName', 'CurveInflationBasis.gen', '' 
go
add_domain_values   'CurveSeasonality.adj', 'Additive', '' 
go
add_domain_values   'CurveSeasonality.adj', 'Multiplicative', '' 
go
delete from eco_pl_col_name where col_name='INCOME_EFFECT'
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'INCOME_EFFECT', 'Income Effect', 66, 'NPV', 0 )
go
INSERT INTO fee_definition ( fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, fee_code ) VALUES ( 'UPFRONT_FEE', 'Upfront Fee', 1, 1, 'CounterParty', 1, 1, 17 )
go
INSERT INTO fee_definition ( fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, fee_code ) VALUES ( 'REDEMPTION_FEE', 'Redemption Fee', 1, 1, 'CounterParty', 1, 1, 18 )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'BACKOFFICE', 'CallAccount.ANY.ANY', 'PricerCallAccount' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'MIDDLEOFFICE', 'CallAccount.ANY.ANY', 'PricerCallAccount' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'FRONTOFFICE', 'CallAccount.ANY.ANY', 'PricerCallAccount' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'AssetSwap.CreditContingent.ANY', 'PricerAssetSwapCreditContingent' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'AssetSwap.CreditContingentBasket.ANY', 'PricerAssetSwapCreditContBasket' )
go
INSERT INTO pos_agg_conf ( pos_agg_conf_id, name, strategy_b, long_short_b, custodian_b, trader_b, dynamic_attrs ) VALUES ( 1, 'CurrencyPair', 0, 0, 0, 0, 'CCY_PAIR' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LOSS_GRAPH', 'tk.core.PricerMeasure', 276, 'Graph of expected losses for a credit contingent contract' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'MC_GRAPH', 'tk.core.PricerMeasure', 279, 'Graph of Monte Carlo results' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'MC_HSTGRAM', 'tk.core.PricerMeasure', 282, 'Histogram of Monte Carlo simulations' )
go
delete from pricer_measure where measure_name='DELTA_RISKY_SEC' and measure_id=243
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'DELTA_RISKY_SEC', 'tk.core.PricerMeasure', 243, 'Delta where risky currency is secondary' )
go
delete from pricer_measure where measure_name='DELTA_RISKY_PRIM' and measure_id=244
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'DELTA_RISKY_PRIM', 'tk.core.PricerMeasure', 244, 'Delta where risky currency is primary (same as DELTA_W_PREMIUM)' )
go
delete from pricer_measure where measure_name='FWD_DELTA_RISKY_PRIM' and measure_id=252
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'FWD_DELTA_RISKY_PRIM', 'tk.core.PricerMeasure', 252, 'Forward Delta where risky currency is primary' )
go
delete from pricer_measure where measure_name='FWD_DELTA_RISKY_SEC' and measure_id=251
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'FWD_DELTA_RISKY_SEC', 'tk.core.PricerMeasure', 251, 'Forward Delta where risky currency is secondary' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURRENCY_BREAKDOWN', 'tk.core.TabularPricerMeasure', 263 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'LEG_BREAKDOWN', 'tk.core.TabularPricerMeasure', 291 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'PROB_OF_REDEMPTION', 'tk.core.PricerMeasure', 292, 'Probability of redemption information held in client data' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'VALUATION_TIME_MS', 'tk.core.PricerMeasure', 294, 'Time, in milli-seconds, to value the trade excluding the time to calibrate the model' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'CALIBRATION_TIME_MS', 'tk.core.PricerMeasure', 295, 'Time, in milli-seconds, to calibrate the model' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'EXPECTED_TIME_TO_REDEMPTION', 'tk.core.PricerMeasure', 296, 'The expected time to redemption of a Tarn' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_NEAR', 'tk.core.PricerMeasure', 298, 'FX Swap - NPV of the near leg' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_FAR', 'tk.core.PricerMeasure', 299, 'FX Swap - NPV of the far leg' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SALES_MARGIN', 'tk.core.PricerMeasure', 285 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SALES_MARGIN_UNREALIZED', 'tk.core.PricerMeasure', 286 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'FX', 'tk.core.PricerMeasure', 293, 'FX rate used' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DEF_EXPOSURE_TIGHT', 'tk.core.PricerMeasure', 300 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'THEO_POS', 'tk.core.PricerMeasure', 301 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACTUAL_POS', 'tk.core.PricerMeasure', 302 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FWD_POS', 'tk.core.PricerMeasure', 303 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCRUAL_IB', 'tk.core.PricerMeasure', 304 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LGM2F_MODEL', 'tk.core.PricerMeasure', 305, 'records the LGM2F model used in the valuation' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'INDEX_FWD_RATE', 'tk.core.PricerMeasure', 306 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BETA', 'tk.core.PricerMeasure', 307 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BETA_ADJUSTED_DELTA', 'tk.core.PricerMeasure', 308 )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_BEST_FIT_GRAPH_MESH_SIZE', '30' )
go
delete from pricing_param_name where param_name='MIXTURE_CALIBRATE_FOR_GREEKS'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'MIXTURE_CALIBRATE_FOR_GREEKS', 'java.lang.Boolean', 'true,false', 'Re-calibrate mixture volatility model when calculating numerical greeks.', 1, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'BETA_REFERENCE_INDEX', 'java.lang.String', '', 'Refernce Index For Beta', 1, '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'LOAN_FROM_QUOTE', 'java.lang.Boolean', 'true,false', 'Use quote for the NPV of secondary market trade on loan', 1, 'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'APPLY_INSTR_SPRD', 'java.lang.Boolean', 'true,false', 'Apply the instrument spread of a bond to the discount curve and price all measures using the shifted discount curve together with the probability curve.', 1, 'false' )
go
delete from pricing_param_name where param_name='COMM_OPT_TIME_TO_EXPIRY_ADJ'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'COMM_OPT_TIME_TO_EXPIRY_ADJ', 'java.lang.Double', '', 'The approximation of the time to expiry (in days) on the final fixing date of the option.  The value must be greater than zero and less than or equal to 1.', 0, '0.5' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_BEST_FIT_GRAPH_MESH_SIZE', 'java.lang.Integer', '', 'Number of discrete points used in the best-fit error graph', 0, 'BEST_FIT_GRAPH_MESH_SIZE', '30' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_KAPPA1', 'com.calypso.tk.core.Rate', '', 'Kappa1 in the LGM2F model, entered as a rate', 0, 'KAPPA1', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_KAPPA2', 'com.calypso.tk.core.Rate', '', 'Kappa2 in the LGM2F model, entered as a rate', 0, 'KAPPA2', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_SIGMA1', 'com.calypso.tk.core.Rate', '', 'Sigma1 in the LGM2F model, entered as a rate', 0, 'SIGMA1', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_SIGMA2', 'com.calypso.tk.core.Rate', '', 'Sigma2 in the LGM2F model, entered as a rate', 0, 'SIGMA2', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_RHO', 'com.calypso.tk.core.Rate', '', 'Rho in the LGM2F model, entered as a rate', 0, 'RHO', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'IGNORE_TARN', 'java.lang.Boolean', '', 'Ignore the Tarn feature when pricing, typically in a transient way', 0, 'IGNORE_TARN', 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'ANTITHETIC_VARIATE', 'java.lang.Boolean', 'true,false', 'Flag controls whether or not the monte-carlo routine uses an antithetic variate to reduce variance', 0, 'ANTITHETIC_VARIATE', 'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'BROWNIAN_BRIDGE', 'java.lang.Boolean', 'true,false', 'Flag controls whether or not the path generator within the monte-carlo routine uses a Brownian bridge when constructing paths', 0, 'BROWNIAN_BRIDGE', 'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name, default_value ) VALUES ( 'VOLATILITY_AS_OF_TIME', 'java.lang.String', 'Fx/FxOption : The roll time for the vol surfaces', 1, 'VOLATILITY_AS_OF_TIME', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'CEV_ALPHA', 'com.calypso.tk.core.Rate', '', 'CEV model parameter Alpha', 0, 'CEV_ALPHA' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'CEV_BETA', 'java.lang.Double', '', 'CEV model parameter Beta', 0, 'CEV_BETA' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'USE_CALIBRATION', 'java.lang.Boolean', 'true,false', 'Controls whether a CalibrationAware Pricer should use an available Calibration.', 0, 'USE_CALIBRATION', 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'INTG_MTHD_CR', 'java.lang.String', 'LINEAR_SINGLE,SIMPSON,EXACT', 'Credit integration method, specifying the numerical method for summing credit event probability over the course of a cashflow period.', 1, 'INTG_MTHD_CR', 'LINEAR_SINGLE' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'INCLUDE_NPV_COLLAT', 'java.lang.Boolean', 'true,false', 'Include Collateral Value in Repo NPV', 1, 'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'FORECAST_FX_RATE', 'java.lang.Boolean', 'true,false', 'Forecast FX Rates when calculating future Principal Adjustment Flows in PricerXCCySwap.', 1, 'false' )
go
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list ) VALUES ( 'LoanXID', 'string', 0, 0, 0, '' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventAccounting', 'BalanceEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventBalanceReclassification', 'AccountingEngine' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'dts_field_mask', 'DTS - Configuration data for TOF Field List bit-mask' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'dts_field_type', 'DTS - Configuration data for TOF Field Definitions' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'dts_data_source', 'DTS - Configuration data for DTS Source of Data and Broker configuration' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'sort_order', 'Customized Sort order per user for use in reports' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'pc_credit_rating', 'Pricer configuration for credit rating (Credit panel).' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'pc_credit_rating_attribute', 'Attributes linked with pc_credit_rating.' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'product_commodity_otcoption2', 'averaging_policy and avg_rounding_policy columns are not used anymore, only here for migration purpose' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'product_commodity_swap2', 'averaging_policy and avg_rounding_policy columns are not used anymore, only here for migration purpose' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'commodity_leg2', 'fx_reset_id and fx_calendar columns are not used anymore, only here for migration purpose' )
go

CREATE TABLE dts_field_mask ( mask_id numeric  NOT NULL,  mask_type varchar (64) NOT NULL,  mask_value numeric  NOT NULL ) 
go

INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 500, 'Database Status', 1 )
go
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 501, 'Spot', 2 )
go
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 501, 'Outright', 4 )
go
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 502, 'Swap', 8 )
go
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 503, 'Deposit', 16 )
go
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 504, 'Conversation Text', 1024 )
go
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 505, 'FRA', 32 )
go

CREATE TABLE dts_field_type ( field_id numeric  NOT NULL,  title varchar (64) NULL,  description varchar (255) NULL,  is_optional_b numeric  DEFAULT 0 NOT NULL,  max_size numeric  NULL,  data_type varchar (32) NULL,  field_mask numeric  NULL,  sw_version varchar (32) NULL ) 
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 500, 'Source of Data', 0, 2, 'Integer', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 501, 'Source Reference', 0, 11, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 502, 'Date of Deal', 0, 11, 'Date', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 503, 'Time of Deal', 0, 8, 'Time', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 504, 'Dealer ID', 0, 6, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 505, 'Date Confirmed', 0, 11, 'Date', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 506, 'Time Confirmed', 0, 8, 'Time', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 507, 'Confirmed-by ID', 0, 6, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 508, 'Bank 1 Dealing Code', 1, 4, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 509, 'Bank 1 Name', 0, 56, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 510, 'Broker Dealing Code', 1, 4, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 511, 'Broker Name', 1, 56, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 512, 'Reason for Sending (CIF)', 0, 2, 'String', 0, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 513, 'Bank 2 Name', 1, 56, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 514, 'Deal Type', 0, 2, 'Integer', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 515, 'Period 1', 0, 3, 'Period', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 516, 'Period 2', 0, 3, 'Period', 56, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 517, 'Currency 1', 0, 3, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 518, 'Currency 2', 0, 3, 'String', 14, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 519, 'Deal Volume Currency 1', 0, 15, 'Price', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 520, 'Deposit Rate', 0, 12, 'Price', 48, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 521, 'Swap Rate', 0, 12, 'String', 8, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 522, 'Exchange Rate Period 1', 0, 12, 'Price', 14, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 523, 'Exchange Rate Period 2', 0, 12, 'Price', 8, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 524, 'Rate Direction', 0, 1, 'Direction', 14, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 525, 'Value Date Period 1 Currency 1', 0, 11, 'Date', 30, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 526, 'Value Date Period 1 Currency 2', 0, 11, 'Date', 14, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 527, 'Value Date Period 2 Currency 1', 0, 11, 'Date', 24, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 528, 'Value Date Period 2 Currency 2', 0, 11, 'Date', 8, '3.08' )
go
INSERT INTO dts_field_type ( title, field_id, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 'Payment Instruction Period 1 Currency 1', 529, 1, 56, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 530, 'Payment Instruction Period 1 Currency 2', 1, 56, 'String', 14, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 531, 'Payment Instruction Period 2 Currency 1', 1, 56, 'String', 56, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 532, 'Payment Instruction Period 2 Currency 2', 1, 56, 'String', 0, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 533, 'Oldest Deal Identifier', 0, 11, 'String', 1, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 534, 'Oldest Deal Date', 1, 11, 'String', 1, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 535, 'Oldest Deal Time', 1, 8, 'Time', 1, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 536, 'Latest Deal Identifier', 0, 11, 'String', 1, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 537, 'Latest Deal Date', 1, 11, 'Date', 1, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 538, 'Latest Deal Time', 1, 8, 'Time', 1, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 539, 'Secondary Source Reference', 1, 10, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 540, 'Method of deal', 0, 2, 'String', 62, '3.08' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 541, 'Rate Currency 1 against USD', 1, 12, 'Price', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 542, 'Rate Currency 2 against USD', 1, 12, 'Price', 14, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 543, 'Rate Base Currency against USD', 1, 12, 'Price', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 544, 'Base Currency', 1, 3, 'String', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 545, 'Calculated volume Period 1 Currency 2', 1, 15, 'Price', 14, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 546, 'Calculated volume Period 2 Currency 2', 1, 15, 'Price', 8, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 547, 'Volume Period 2 Currency 1', 1, 15, 'Price', 24, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 548, 'Conversation Text', 0, 2000, 'String', 1024, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 549, 'Dealer Name', 0, 20, 'String', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 550, 'Confirmed-by Name', 0, 20, 'String', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 551, 'Local TCID', 0, 4, 'String', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 552, 'Review Reference Number', 0, 10, 'String', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 553, 'Common Text', 1, 124, 'String', 62, '3.10' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 554, 'FRA Fixing Date', 0, 11, 'Date', 32, '3.20' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 555, 'FRA Settlement Date', 0, 11, 'Date', 32, '3.20' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 556, 'FRA Maturity Date', 0, 11, 'Date', 32, '3.20' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 557, 'IMM Indicator', 0, 1, 'String', 32, '3.20' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 558, 'Dealing Server Version Number', 0, 10, 'String', 1, '3.20' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 559, 'Outright Points Premium Rate', 1, 12, 'Price', 4, '3.20' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 560, 'Spot Basis Rate', 1, 12, 'Price', 4, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 561, 'User-defined Title 1', 1, 20, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 562, 'User-defined Data 1', 1, 40, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 563, 'User-defined Title 2', 1, 20, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 564, 'User-defined Data 2', 1, 40, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 565, 'User-defined Title 3', 1, 20, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 566, 'User-defined Data 3', 1, 40, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 567, 'ID of the original if this is a Contra', 1, 11, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 568, 'ID of previous if this is a next', 1, 11, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 569, 'Pure Deal-type', 0, 4, 'Integer', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 570, 'Volume of Interest', 0, 15, 'Price', 16, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 571, 'Days elapsed during Deal', 0, 6, 'String', 56, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 572, 'Year Length', 0, 3, 'String', 48, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 573, 'Price Convention', 0, 1, 'String', 12, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 574, 'Interest Message (CIF)', 1, 14, 'String', 0, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 575, 'SWIFT-BIC Currency-1 Period-1', 1, 11, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 576, 'SWIFT-BIC Currency-2 Period-1', 1, 11, 'String', 14, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 577, 'SWIFT-BIC Currency-1 Period-2', 1, 11, 'String', 56, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 578, 'SWIFT-BIC Currency-2 Period-2', 1, 11, 'String', 8, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 579, 'D2000-2 Credit Reduction', 1, 15, 'Price', 2, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 580, 'D2000-2 Credit Remaining', 1, 15, 'Price', 2, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 581, 'Base Currency 2', 1, 3, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 582, 'Base Currency 3', 1, 3, 'String', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 583, 'Rate Base Currency 2 versus USD', 1, 12, 'Price', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 584, 'Rate Base Currency 3 versus USD', 1, 12, 'Price', 62, '3.30' )
go
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 599, 'Reuters TOF Simulator', 1, 124, 'String', 62, '3.08' )
go
CREATE TABLE dts_data_source ( source_code varchar (2) NOT NULL,  provider varchar (32) NOT NULL,  description varchar (255) NOT NULL,  broker varchar (32) NULL ) 
go
INSERT INTO dts_data_source ( source_code, provider, description ) VALUES ( '1', 'REUTERS', 'Dealing3000-OfflineDealCapture' )
go
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '2', 'REUTERS', 'Dealing3000-2-Match', 'REUTERS' )
go
INSERT INTO dts_data_source ( source_code, provider, description ) VALUES ( '3', 'REUTERS', 'Dealing3000-1-Conversation' )
go
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '4', 'EBS', 'SRC_4_EBS=EBS-E-EBSGeneratedTrade', 'EBS' )
go
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '5', 'EBS', 'EBS-F-EBSTrade', 'EBS' )
go
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( ' ', 'EBS', 'EBS-Blank-EBSTrade', 'EBS' )
go
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '12', 'RTNS', 'RTNS-RTFX-Multi-Portal_Trade', 'REUTERS' )
go
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '32', 'RTNS', 'RTNS-Meitan-Tradition-Broker_Trade', 'REUTERS' )
go
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '34', 'RTNS', 'RTNS-Nittan-Broker_Trade', 'RTNS' )
go

/* end of XML "inserts"  */

DELETE domain_values WHERE name = 'riskAnalysis' AND value IN ('PL', 'PLSummary', 'PLMerger')
go

DELETE an_viewer_config WHERE analysis_name IN ('PL', 'PLSummary')
go


 
UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date='20080328'
go
