/* This is the upgrade script for Calypo Rel900 p04 to Rel1000 */

delete an_viewer_config where analysis_name in ('VaR', 'PredictPL', 'VARHistoric', 'PredictPLPre', 'FutureExposure',
  'FXPosition', 'FXSensitivity', 'FXLadder', 'Sensitivity', 'VolSens', 'CreditPositionAging', 'SpotExposure', 'OptionExpiration')
;

delete domain_values where name = 'classAuditMode' and value in ('FutureExposureParam', 'FXPositionParam', 'AccrualParam',
  'PredictPLParam', 'VARHistoricParam', 'PredictPLPreParam', 'CreditExposureParam', 'CreditSensitivityParam', 'SensitivityParam',
  'FXSensitivityParam', 'VaRParam', 'VolSensParam')
;

delete domain_values where name = 'riskAnalysis' and value in ('VolSens', 'PredictPL', 'FXSensitivity', 'Accrual', 'VaR',
  'PredictPLPre', 'VARHistoric', 'FutureExposure', 'FXPosition', 'FXLadder', 'Sensitivity', 'CreditPositionAging',
  'SpotExposure', 'OptionExpiration')
;

create or replace procedure fbi as
begin
declare
  v_idx_name varchar(28);
  v_sql      varchar(256);
  x          number := 0;
  y          number := 0;
begin
      select count(*) into x from user_ind_columns where table_name = 'PRODUCT_DESC' and column_name = 'DESCRIPTION';
      select count(*) into y from user_ind_columns where table_name = 'PRODUCT_DESC' and column_name like 'SYS%';
  if x = 1 then
     select index_name into v_idx_name from user_ind_columns where table_name = 'PRODUCT_DESC' and column_name = 'DESCRIPTION';
     v_sql := 'drop index '||v_idx_name;
     execute immediate v_sql;
  elsif y = 1 then
     select index_name into v_idx_name from user_ind_expressions where table_name = 'PRODUCT_DESC';
     v_sql := 'drop index '||v_idx_name;
     execute immediate v_sql;
  elsif
       (x = 0 or y = 0) then
     v_sql := 'create index idx_prd_desc_desc_fb on product_desc (lower(description))';
     execute immediate v_sql;
  end if;
end;
end fbi;
;

begin
fbi;
end;
;

drop procedure fbi
;


UPDATE pc_surface SET desc_name = desc_name+'.ANY' WHERE desc_name LIKE '%Commodity%' AND desc_name NOT LIKE '%Commodity.%.%.%'
;

delete from domain_values where name = 'futureUnderType' and value = 'BRL'
;

INSERT INTO domain_values (name, value, description) values ('futureUnderType','BRL','')
;

UPDATE engine_config set engine_name = 'MatchingEngine' where engine_name = 'MatchingMessageEngine'
;

delete engine_config where engine_name in ('MatchingEngine','MatchableBuilderEngine')
and not exists (select name from domain_values where name ='dsInit' and value='MatchingServer')
;
delete ps_event_config where engine_name in ('MatchingEngine','MatchableBuilderEngine')
and not exists (select name from domain_values where name ='dsInit' and value='MatchingServer')
;
delete ps_event_filter where engine_name in ('MatchingEngine','MatchableBuilderEngine')
and not exists (select name from domain_values where name ='dsInit' and value='MatchingServer')
;
 
update trade set settlement_date = (select exercise_settle_dt from product_otccom_opt 
  where product_otccom_opt.product_id=trade.product_id) 
  where exists 
  (select exercise_settle_dt from product_otccom_opt  where product_otccom_opt.product_id=trade.product_id)
;

update product_bond set allowed_redemption_type = 'Full' where allowed_redemption_type is null
;

begin
  add_column_if_not_exists('PRICING_ENV','DAY_CHANGE_RULE','VARCHAR2(32)');
end;
;

delete from domain_values where name = 'scheduledTask' and value = 'SAVE_POSITION_SNAPSHOT'
;
insert into domain_values values ('scheduledTask',  'SAVE_POSITION_SNAPSHOT', 'Task to store snapshots of positions') 
;

begin
 drop_pk_if_exists('pc_info');
end;
;

begin
 drop_pk_if_exists('an_viewer_config');
end;
;

begin
 drop_pk_if_exists('exsp_quotable_variable');
end;
;

CREATE OR REPLACE PROCEDURE drop_uq_on_exsp_qv 
 AS
  begin
declare cursor c1 is 
 select table_name, constraint_name from user_constraints where constraint_type = 'U'
    and table_name = 'EXSP_QUOTABLE_VARIABLE';

v_sql varchar2(128);
begin

for c1_rec in c1 LOOP 
  v_sql := 'alter table '||c1_rec.table_name||' drop constraint '||c1_rec.constraint_name;
 execute immediate v_sql;
  END LOOP;
end;
end;
;

begin
  drop_uq_on_exsp_qv;
end;
;



update risk_on_demand_item set position_freq = -1 where position_freq is null
;
update risk_presenter_item set position_freq = -1 where position_freq is null
;

delete from engine_config where engine_id = 15 and engine_name = 'BalanceEngine'
;
insert into engine_config (engine_id, engine_name, engine_comment)
select distinct -1, 'BalanceEngine', 'Compute account balances in real time (alternative to SchduledTaskBALANCE)'
from engine_config
where not exists (select 1 from engine_config where engine_name = 'BalanceEngine')
;

update engine_config
set engine_id = (select max(engine_id) + 1 from engine_config)
where engine_name = 'BalanceEngine'
and engine_id = -1
;


UPDATE domain_values SET value = 'Dispatcher host' WHERE value = 'dispatcher_host' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'Dispatcher port' WHERE value = 'dispatcher_port' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'Dispatcher port' WHERE value = 'Dispatcher Port' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'Notify on job error' WHERE value = 'notify_job_err_b' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'Email address to' WHERE value = 'ext_addr_to' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'Email address from' WHERE value = 'ext_addr_from' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'Read only' WHERE value = 'read_only' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'User name' WHERE value = 'user_name' AND name = 'DispatcherParamsCalypso'
;
UPDATE domain_values SET value = 'Engine group' WHERE value = 'engineGroup' AND name = 'DispatcherParamsDatasynapse'
;
UPDATE domain_values SET value = 'Grid library' WHERE value = 'gridLibrary' AND name = 'DispatcherParamsDatasynapse'
;
UPDATE domain_values SET value = 'Gridlib version' WHERE value = 'gridLibraryVersion' AND name = 'DispatcherParamsDatasynapse'
;
UPDATE domain_values SET value = 'DataSynapse username' WHERE value = 'datasynapseUser' AND name = 'DispatcherParamsDatasynapse'
;
UPDATE domain_values SET value = 'DataSynapse password' WHERE value = 'datasynapsePass' AND name = 'DispatcherParamsDatasynapse'
;


UPDATE disp_params SET param_name =  'Dispatcher host' WHERE param_name = 'dispatcher_host' AND param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Dispatcher port' WHERE param_name = 'dispatcher_port' AND param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Notify on job error' WHERE param_name = 'notify_job_err_b' AND param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Email address to' WHERE param_name = 'ext_addr_to' AND param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Email address from' WHERE param_name = 'ext_addr_from' AND param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Read only' WHERE param_name = 'read_only' AND param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'User name' WHERE param_name = 'user_name' AND param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Engine group' WHERE param_name = 'engineGroup' AND  param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Grid library' WHERE param_name = 'gridLibrary' AND  param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'Gridlib version' WHERE param_name = 'gridLibraryVersion' AND  param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'DataSynapse username' WHERE param_name = 'datasynapseUser' AND  param_type = 'Parameter'
;
UPDATE disp_params SET param_name =  'DataSynapse password' WHERE param_name = 'datasynapsePass' AND  param_type = 'Parameter'
;

DELETE report_panel_def where win_def_id IN (SELECT win_def_id FROM report_win_def WHERE def_name = 'MessageViewerWindow')
;
DELETE report_win_def WHERE def_name = 'MessageViewerWindow'
;
DELETE FROM domain_values WHERE name = 'FXOption.Pricer' and value = 'PricerFXOption'
;
DELETE FROM domain_values where name = 'FXOption.subtype' AND value = 'BARRIER_IN'
;
DELETE FROM domain_values where name = 'FXOption.subtype' AND value = 'BARRIER_OUT'
;

DELETE an_viewer_config WHERE analysis_name in ('Strategy', 'CPPILiability')
;
DELETE domain_values WHERE name = 'riskAnalysis' AND value IN ('Strategy', 'CPPILiability')
;


DELETE FROM pricer_measure where measure_id=297 and measure_name='W_VOL_VEGA'
;
DELETE FROM pricer_measure where measure_id=298 and measure_name='W_VOL_MOD_VEGA'
;
INSERT INTO pricer_measure (measure_name,measure_class_name,measure_id,measure_comment) 
  VALUES ('W_SHIFT_MOD_VEGA','tk.core.PricerMeasure',297,'W_SHIFT_MOD_VEGA = [Price (Current Vol+Beta) - Price (Current Vol)]')
;


begin
 add_column_if_not_exists('LE_LEGAL_AGREEMENT','NOTICE_DAYS','int');
end;
;

begin
 add_column_if_not_exists('LE_LEGAL_AGREEMENT','CALLABLE_BY','varchar2(32)');
end;
;


UPDATE le_legal_agreement SET le_legal_agreement.notice_days = (
  SELECT notice_days FROM sec_lend_legal
  WHERE sec_lend_legal.legal_agreement_id = le_legal_agreement.legal_agreement_id)
;

UPDATE le_legal_agreement SET le_legal_agreement.callable_by = (
  SELECT callable_by FROM sec_lend_legal 
  WHERE sec_lend_legal.legal_agreement_id = le_legal_agreement.legal_agreement_id)
;

UPDATE pricing_param_name SET param_domain = 'EXACT_STEP_SIGMA,BEST_FIT_LM' WHERE param_name = 'LGMM_CALIBRATION_SCHEME'
;

INSERT INTO domain_values (name,value,description)
VALUES('scheduledTask','EOD_CALCULATION_SERVER','EOD CalculationServer tasks')
;

update calypso_tree_node set node_class_name='com.calypso.apps.tws.FolderView' 
  where leaf_b=0 and node_class_name='com.calypso.apps.tws.CalypsoTreeViewNode'
;
INSERT INTO domain_values (name,value,description) VALUES('quoteType','PriceVol','')
;
UPDATE advice_config SET template_name = 'fxoptionConfirmation.html' WHERE advice_config_id = 88 AND template_name = 'fxoptionconfirmation.html'
;
UPDATE bo_message SET template_name = 'fxoptionConfirmation.html' WHERE advice_cfg_id = 88 AND template_name = 'fxoptionconfirmation.html'
;
UPDATE advice_config SET template_name = 'fxoptionConfirmation.html' WHERE advice_config_id = 89 AND template_name = 'fxoptionconfirmation.html'
;
UPDATE bo_message SET template_name = 'fxoptionConfirmation.html' WHERE advice_cfg_id = 89 AND template_name = 'fxoptionconfirmation.html'
;
DELETE FROM domain_values WHERE name = 'MESSAGE.Templates' AND value = 'cdsAbsConfirm.html'
;
UPDATE advice_config SET template_name = 'cdsABSConfirm.html' WHERE template_name = 'cdsAbsConfirm.html'
;
UPDATE bo_message SET template_name = 'cdsABSConfirm.html' WHERE template_name = 'cdsAbsConfirm.html'
;
DELETE FROM domain_values WHERE name = 'MESSAGE.Templates' AND value = 'varianceSwapConfirmation.html'
;
UPDATE advice_config SET template_name = 'VarianceSwapConfirmation.html' WHERE template_name = 'varianceSwapConfirmation.html'
;
UPDATE bo_message SET template_name = 'VarianceSwapConfirmation.html' WHERE template_name = 'varianceSwapConfirmation.html'
;


update prod_comm_fwd set fwd_price_method='Nearby' where fwd_price_method is null
;


UPDATE product_bond_opt SET liquidity = 1.0
;

CREATE OR REPLACE PROCEDURE add_pmt_freq_if_not_exist
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
        execute immediate 'create table '|| tab_name ||' (PRODUCT_ID NUMBER,
                                                         PMT_FREQ_TYPE VARCHAR2(64),
                                                         ATTR_NAME VARCHAR2(32),
                                                         ATTR_VALUE VARCHAR2(255),
                                constraint pk_pmt_freq_details primary key (product_id))';

                               
                                                 

   END IF;
END;
;

begin
   add_pmt_freq_if_not_exist('pmt_freq_details');
end;
;

CREATE OR REPLACE PROCEDURE add_prod_com_swp2_if_not_exist
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
        execute immediate 'create table '|| tab_name ||' (PRODUCT_ID NUMBER(38),
                                                          PAY_LEG_ID NUMBER(38),
                                                          RECEIVE_LEG_ID NUMBER(38),
                                                          CURRENCY_CODE VARCHAR2(3),
                                                          AVERAGING_POLICY VARCHAR2(64),
                                                          CUSTOM_FLOWS_B NUMBER(38),
                                                          FLOWS_BLOB BLOB,
                                                          AVG_ROUNDING_POLICY VARCHAR2(64),
                                    constraint pk_prod_comm_swap2 primary key (product_id))';
END IF;
END;
;

begin
  add_prod_com_swp2_if_not_exist('product_commodity_swap2');
end;
;

CREATE OR REPLACE PROCEDURE add_pco2_if_not_exist
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
        execute immediate 'create table '|| tab_name ||' (PRODUCT_ID           NUMBER,  
                                                          LEG_ID               NUMBER,
                                                          BUY_SELL             VARCHAR2(4),
                                                          OPTION_TYPE          VARCHAR2(20),
                                                          CURRENCY_CODE        VARCHAR2(3),
                                                          AVERAGING_POLICY     VARCHAR2(64),
                                                          CUSTOM_FLOWS_B       NUMBER,
                                                          FLOWS_BLOB           BLOB,
                                                          AVG_ROUNDING_POLICY  VARCHAR2(64),
                                                          SETTLEMENT_TYPE      VARCHAR2(32),
                                  constraint pk_prod_comm_otc2 primary key (product_id))';
   END IF;
END;
;

begin
  add_pco2_if_not_exist('product_commodity_otcoption2');
end;
;


begin
  add_column_if_not_exists('pmt_freq_details','leg_id','int');
end;
;


update pmt_freq_details set leg_id = 0 where leg_id is null
;

begin 
  add_column_if_not_exists('cf_sch_gen_params','leg_id','int');
end;
;


update cf_sch_gen_params set leg_id = 0 where leg_id is null
;

begin 
  add_column_if_not_exists('cf_sch_gen_params','fx_reset_id','int');
end;
;

begin 
  add_column_if_not_exists('cf_sch_gen_params','fx_calendar','varchar2(64)');
end;
;


begin 
  add_column_if_not_exists('cf_sch_gen_params','payment_date_roll','varchar2(16)');
end;
;

begin 
  add_column_if_not_exists('commodity_leg2','averaging_policy','varchar2(64)');
end;
;


begin 
  add_column_if_not_exists('commodity_leg2','avg_rounding_policy','varchar2(64)');
end;
;


insert into pmt_freq_details (product_id, pmt_freq_type, attr_name, attr_value, leg_id) 
   select p.product_id, p.pmt_freq_type, p.attr_name, p.attr_value, s.receive_leg_id 
      FROM pmt_freq_details p, product_commodity_swap2 s 
      where p.product_id=s.product_id and p.leg_id=0
;

update (select p.leg_id a1, s.pay_leg_id b1 from pmt_freq_details p, product_commodity_swap2 s where p.product_id=s.product_id and p.leg_id=0)
        set a1 = b1
;
update (select p.leg_id a1, o.leg_id b1 from pmt_freq_details p, product_commodity_otcoption2 o where p.product_id=o.product_id and p.leg_id=0)
        set a1 = b1
;

UPDATE pricing_param_name SET param_domain = 'EXACT_STEP_SIGMA,BEST_FIT_LM,APPROX_STEP_SIGMA' WHERE param_name = 'LGMM_CALIBRATION_SCHEME'
;

delete from domain_values where name = 'VolSurface.gensimple' and value = 'SmileAdjustment'
;
delete from domain_values where name = 'VolSurface.gensimple' and value = 'SimpleSmile'
;
update vol_surface set vol_surf_generator = 'BondOptionQuadraticSmile' where vol_surf_generator = 'SmileAdjustment'
;
update vol_surface set vol_surf_generator = 'QuadraticSmileParams' where vol_surf_generator = 'SimpleSmile'
;

DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_PRIM'
;
DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_SEC'
;

delete from domain_values where name = 'NDS.subtype' and value = 'CSS'
;
delete from domain_values where name = 'NDS.subtype' and value = 'CCS'
;
insert into domain_values (name,value,description) VALUES ('NDS.subtype','CCS','')
;


/*                                                          */
/* This is the Oracle/hibernate migration script - phase 1  */
/*                                                          */


/* First deal with the date_rule object */


/* create a new table to hold the date_rule to date_rule mapping */

 
/* lets split up our comma-separated list of date_rules into seperate rows */

insert into date_rule_to_date_rule (
select date_rule_id,  date_rules from (
select
  date_rule_id,
  substr(date_rules, instr(date_rules,',',1,rr.r)+1, instr(date_rules,',',1,rr.r+1)-instr(date_rules,',',1,rr.r)-1 ) date_rules
from
  (select date_rule_id, ','||date_rules||',' date_rules, length(date_rules)-length(replace(date_rules,',',''))+1 cnt
     from date_rule where date_rules is NOT NULL and date_rules != 'NONE' ) date_rule,
      (select rownum r from all_objects where rownum <= 100) rr
       where rr.r <= date_rule.cnt
) where date_rules  is not null )
;

/* backup the date_rule table before we drop he column containing the old date_rules format */

create table date_rule_bak as select * from date_rule
;

/* now drop the column */



/* OK we're done with date_rule object now  */

/* ################################################################################### */

/* Now we deal with the rate_index_default object */


/* take a backup of RATE_INDEX_DEFAULT table first */

create table rate_index_default_bak as select * from rate_index_default
;

/* part A - we merge rate_avg_method into rate_index_default */


/* add the columns */


/* now update those columns we just added */

update rate_index_default rid set (
  avg_method,
  start_offset,
  day_of_week,
  cutoff_days,
  frequency,
  avg_period_rule,
  under_rate_index,
  unadjust_reset,
  avg_rounding_unit) =
(select
  ram.avg_method,
  ram.start_offset,
  ram.day_of_week,
  ram.cutoff_days,
  ram.frequency,
  ram.period_rule,
  ram.under_rate_index,
  ram.unadjust_reset,
  ram.avg_rounding_unit
from rate_avg_method ram
where
ram.currency_code = rid.currency_code and ram.rate_index_code = rid.rate_index_code)
where exists (
select 1 from rate_index_default , rate_avg_method
 where rate_index_default.currency_code = rate_avg_method.currency_code
 and rate_index_default.rate_index_code = rate_avg_method.rate_index_code)
;

update rate_index_default set avg_rounding_unit = -1 where avg_rounding_unit is null
;


/* part B - we merge inflation_index into rate_index_default */
/* in case we cam from rel800 we wont have inflation_index   */
/* so lets create a placeholder so we get no noise           */


CREATE OR REPLACE PROCEDURE add_inflat_index_if_not_exist
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
                        CURRENCY_CODE      VARCHAR2(3),
                        RATE_INDEX_CODE    VARCHAR2(32),
                        publication_day    INT,
                        calculation_method varchar2(32),
                        interp_method      varchar2(32),
                        reference_day      int,
constraint pk_inflation_index primary key (CURRENCY_CODE,RATE_INDEX_CODE))';
   END IF;
END;
;


begin
add_inflat_index_if_not_exist('INFLATION_INDEX');
end;
;

begin
add_column_if_not_exists('INFLATION_INDEX','REFERENCE_DAY','INT');
end;
;


/* now update those columns we just added */

update rate_index_default rid set (
  publication_day,
  calculation_method,
  interp_method,
  reference_day) = 
(select
  ii.publication_day,
  ii.calculation_method,
  ii.interp_method,
  ii.reference_day 
from inflation_index ii 
  where
 ii.currency_code = rid.currency_code 
  and 
 ii.rate_index_code = rid.rate_index_code)
where exists (
select 1 from rate_index_default , inflation_index
 where rate_index_default.currency_code = inflation_index.currency_code
 and rate_index_default.rate_index_code = inflation_index.rate_index_code)
;

update rate_index_default set publication_day = 45 where publication_day is null
;



update rate_index_default set reference_day = 1 where reference_day is null
;




/* part C - we merge rateindex_cu_swap into rate_index_default */


/* now update all the columns we just added (except for the 4 cu_swap_NNN columns */
/* we will deal with them seperately                                              */

/* note that clients coming from earlier versions may not have syncd to xml yet and so  */
/* wont have rateindex_cu_swap table yet - so we check see if its there avoiding        */
/* noise from this script                                                               */

CREATE OR REPLACE PROCEDURE add_ri_cu_swap_if_not_exist (tab_name IN varchar2)
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
        execute immediate 'create table '|| tab_name ||' (
                        DEFAULTS_CURRENCY_CODE     VARCHAR2(3),
                        DEFAULTS_RATEINDEX_CODE    VARCHAR2(32),
                        RATE_INDEX                 VARCHAR2(128),
                        MATURITY_TENOR             NUMBER,
                        FIXED_CPN_HOLIDAYS         VARCHAR2(128),
                        FIXED_CPN_DATEROLL         VARCHAR2(16),
                        FXD_DAYCOUNT               VARCHAR2(10),
                        FLT_CPN_HOLIDAYS           VARCHAR2(128),
                        FLT_CPN_DATEROLL           VARCHAR2(16),
                        FIXED_CPN_FREQ             VARCHAR2(12),
                        FLOAT_CPN_FREQ             VARCHAR2(12),
                        MAN_FIRST_RESET_B          NUMBER,
                        FXD_PERIOD_RULE            VARCHAR2(18),
                        FLT_PERIOD_RULE            VARCHAR2(18),
                        FLT_CMP_FREQ               VARCHAR2(12),
                        SPC_LAG_B                  NUMBER,
                        SPC_LAG_OFFSET             NUMBER,
                        SPC_LAG_HOLIDAYS           VARCHAR2(128),
                        SPC_LAG_BUS_CAL_B          NUMBER,
                        FIXED_PO_FORMULA           VARCHAR2(32),
                        FLT_PO_FORMULA             VARCHAR2(32),
                        FXD_CMP_FREQ               VARCHAR2(12),
                        PRINCIPAL_ACTUAL_B         NUMBER,
                        DISCOUNT_METHOD            NUMBER,
constraint pk_rateindex_cu_swap primary key (DEFAULTS_CURRENCY_CODE,DEFAULTS_RATEINDEX_CODE))';
   END IF;
END;
;


begin
  add_ri_cu_swap_if_not_exist('RATEINDEX_CU_SWAP');
end;
;


update rate_index_default rid set (
  maturity_tenor,
  fixed_cpn_holidays,
  fixed_cpn_dateroll,
  fxd_daycount,
  flt_cpn_holidays,
  flt_cpn_dateroll,
  fixed_cpn_freq,
  float_cpn_freq,
  man_first_reset_b,
  fxd_period_rule,
  flt_period_rule,
  flt_cmp_freq,
  spc_lag_b,
  spc_lag_offset,
  spc_lag_holidays,
  spc_lag_bus_cal_b,
  fixed_po_formula,
  flt_po_formula,
  fxd_cmp_freq,
  principal_actual_b,
  discount_method) = 
(select
  ricus.maturity_tenor,
  ricus.fixed_cpn_holidays,
  ricus.fixed_cpn_dateroll,
  ricus.fxd_daycount,
  ricus.flt_cpn_holidays,
  ricus.flt_cpn_dateroll,
  ricus.fixed_cpn_freq,
  ricus.float_cpn_freq,
  ricus.man_first_reset_b,
  ricus.fxd_period_rule,
  ricus.flt_period_rule,
  ricus.flt_cmp_freq,
  ricus.spc_lag_b,
  ricus.spc_lag_offset,
  ricus.spc_lag_holidays,
  ricus.spc_lag_bus_cal_b,
  ricus.fixed_po_formula,
  ricus.flt_po_formula,
  ricus.fxd_cmp_freq,
  ricus.principal_actual_b,
  ricus.discount_method
from rateindex_cu_swap ricus
 where ricus.defaults_currency_code = rid.currency_code
  and   ricus.defaults_rateindex_code = rid.rate_index_code)
where exists (
select 1 from rate_index_default , rateindex_cu_swap
 where rate_index_default.currency_code = rateindex_cu_swap.defaults_currency_code
 and   rate_index_default.rate_index_code = rateindex_cu_swap.defaults_rateindex_code)
;

update rate_index_default set spc_lag_b = 0 where spc_lag_b is null
;


update rate_index_default set spc_lag_bus_cal_b = 0 where spc_lag_bus_cal_b is null
;


update rate_index_default set principal_actual_b = 0 where principal_actual_b is null
;

update rate_index_default set discount_method = 0 where discount_method is null
;


create or replace function tenor_to_int ( str_tenor in varchar2 ) return number 
  is 
  unit        varchar2(1);
  multiplier  number;
  amount      number;
	begin 
        unit := substr(str_tenor, length(str_tenor));
        multiplier := 1;
        case 
          when 'Y' = unit then multiplier := 360;
          when 'M' = unit then multiplier := 30;
          when 'W' = unit then multiplier := 7;
          when 'D' = unit then multiplier := 1;
          else
            begin
              dbms_output.put_line('unsupported tenor unit: ' || unit);
            end;
        end case;
        amount := to_number(substr(str_tenor, 1, length(str_tenor) - 1), '9');
        return(amount * multiplier);
end tenor_to_int;
;

/* now we have to split the 4 concatenated fields in the RATEINDEX_CU_SWAP RATE_INDEX  column */
/* and update them into 4 seperate columns in the RATE_INDEX_DEFAULT table                    */
create or replace procedure tmp_rate_index as
begin
declare
  v_sql  varchar2(500);
  v_curr_code varchar2(32);
  v_ri_code   varchar2(32);
  v_ri_tenor varchar2(32);
  v_ri_source varchar2(32);
  cursor c1 is select defaults_currency_code, defaults_rateindex_code, rate_index from rateindex_cu_swap where rate_index is not null;
  cursor c2 is select defaults_currency_code, defaults_rateindex_code, rate_index from rateindex_cu_swap where rate_index is not null;
  cursor c3 is select defaults_currency_code, defaults_rateindex_code, rate_index from rateindex_cu_swap where rate_index is not null;
  cursor c4 is select defaults_currency_code, defaults_rateindex_code, rate_index from rateindex_cu_swap where rate_index is not null;

begin

  for c1_rec in c1 LOOP
   v_curr_code := substr(c1_rec.rate_index,1,instr(c1_rec.rate_index,'/',1)-1);
   execute immediate  'update rate_index_default rid set cu_swap_currency_code = '||chr(39)||v_curr_code||chr(39)||
           ' where rid.currency_code = '||chr(39)||c1_rec.defaults_currency_code||chr(39)||
           '  and rid.rate_index_code = '||chr(39)||c1_rec.defaults_rateindex_code||chr(39);
  end loop;

  for c2_rec in c2 LOOP
   v_ri_code := substr(c2_rec.rate_index,instr(c2_rec.rate_index,'/',1)+1,instr(c2_rec.rate_index,'/',1,2)-instr(c2_rec.rate_index,'/',1,1)-1);
   execute immediate  'update rate_index_default rid set cu_swap_rate_index_code = '||chr(39)||v_ri_code||chr(39)||
           ' where rid.currency_code = '||chr(39)||c2_rec.defaults_currency_code||chr(39)||
           '  and rid.rate_index_code = '||chr(39)||c2_rec.defaults_rateindex_code||chr(39);
  end loop;

  for c3_rec in c3 LOOP
   v_ri_tenor := substr(c3_rec.rate_index,instr(c3_rec.rate_index,'/',1,2)+1,length(c3_rec.rate_index)-instr(c3_rec.rate_index,'/',1,3));
   v_ri_tenor := substr(v_ri_tenor, 1, instr(v_ri_tenor, '/', 1) - 1);
   execute immediate  'update rate_index_default rid set cu_swap_rate_index_tenor = tenor_to_int('||chr(39)||v_ri_tenor||chr(39)||')'||
           ' where rid.currency_code = '||chr(39)||c3_rec.defaults_currency_code||chr(39)||
           '  and rid.rate_index_code = '||chr(39)||c3_rec.defaults_rateindex_code||chr(39);
  end loop;

  for c4_rec in c4 LOOP
   v_ri_source := substr(c4_rec.rate_index,instr(c4_rec.rate_index,'/',1,3)+1,length(c4_rec.rate_index)-instr(c4_rec.rate_index,'/',1,3));
   execute immediate  'update rate_index_default rid set cu_swap_rate_index_source = '||chr(39)||v_ri_source||chr(39)||
           ' where rid.currency_code = '||chr(39)||c4_rec.defaults_currency_code||chr(39)||
           '  and rid.rate_index_code = '||chr(39)||c4_rec.defaults_rateindex_code||chr(39);
  end loop;

  commit;

end;
end tmp_rate_index;
;

begin
tmp_rate_index;
end;
;

drop procedure tmp_rate_index
;

drop function tenor_to_int
;

/* OK were done with rate_index object now  */

/* ################################################################################### */

update rate_index_default set fxd_period_rule = 'ADJUSTED' where fxd_period_rule is null
;


update rate_index_default set flt_period_rule = 'ADJUSTED' where flt_period_rule is null
;


update rate_index_default set man_first_reset_b = 0 where man_first_reset_b is null
;


update rate_index_default set start_offset = 0 where start_offset is null
;

update rate_index_default set  day_of_week = 0 where day_of_week is null
;


update rate_index_default set cutoff_days = 0 where cutoff_days is null
;


update rate_index_default set unadjust_reset = 0 where unadjust_reset  is null
;

update rate_index_default set spc_lag_offset = 0 where spc_lag_offset  is null
;

CREATE OR REPLACE PROCEDURE set_col_to_null 
    (tab_name IN varchar2, col_name IN varchar2)
      
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns 
             where table_name = UPPER(TAB_NAME)
             and column_name = UPPER(COL_NAME) 
             and NULLABLE = 'N';
     dbms_output.put_line('X = > '||x);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
       execute immediate 'alter table '|| tab_name ||' modify '|| col_name ||' NULL';
    END IF;
END;
;

begin
  set_col_to_null ('RATE_INDEX_DEFAULT','INTERP_ROUNDING_MTHD');
end;
;


update rate_index_default set interp_rounding_mthd = null where interp_rounding_mthd = 'NONE'
;

update rate_index_default set interp_rounding_dec = 0 where interp_rounding_dec is null
;

update rate_index_default set no_auto_interp_b = 0 where no_auto_interp_b is null
;


rename rateindex_cu_swap to rateindex_cu_swap_old
;
rename inflation_index to inflation_index_old
;
rename rate_avg_method to rate_avg_method_old
;

/* OK we're done with rate_index object now  */

/* ################################################################################### */

/* End of Oracle/hibernate migration script - phase 1  */

/* ################################################################################### */


/* swap2 and otc2 stored procs for commodities */

create table CF_SCH_GEN_PARAMS_bak as select * from CF_SCH_GEN_PARAMS
;
create table PRODUCT_COMMODITY_SWAP2_bak as select * from PRODUCT_COMMODITY_SWAP2
;
create table COMMODITY_LEG2_bak as select * from COMMODITY_LEG2
;

alter table cf_sch_gen_params drop primary key drop index
;

create or replace procedure comm_swap1 as
begin
declare
 cursor c1 is
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
    where cf.product_id = pcs2.product_id and cf.leg_id = 0;

 v_sql1 varchar2(2000);
 v_sql2 varchar2(2000);
 v_sql3 varchar2(2000);

begin
for c1_rec in c1 loop
    v_sql1 :=  'insert into cf_sch_gen_params (product_id, leg_id, start_date, end_date, payment_lag, payment_calendar, 
                        fixing_date_policy, fixing_calendar, payment_offset_bus_b, payment_day, payment_date_rule,
                        payment_date_roll, fx_reset_id, fx_calendar ) values ( '||
                         c1_rec.product_id||','||
                         c1_rec.pay_leg_id||','||
                         chr(39)||c1_rec.start_date||chr(39)||','||
                         chr(39)||c1_rec.end_date||chr(39)||','||
                         c1_rec.payment_lag||','||
                         chr(39)||c1_rec.payment_calendar||chr(39)||','||    
                         c1_rec.fixing_date_policy||','||
                         chr(39)||c1_rec.fixing_calendar||chr(39)||','||
                         c1_rec.payment_offset_bus_b||','||
                         c1_rec.payment_day||','||
                         c1_rec.payment_date_rule||','||
                         chr(39)||c1_rec.payment_date_roll||chr(39)||','||
                         nvl(c1_rec.fx_reset_id,0)||','||
                         chr(39)||c1_rec.fx_calendar||chr(39)||')';    
               
               execute immediate v_sql1;


    v_sql2 :=  'insert into cf_sch_gen_params (product_id, leg_id, start_date, end_date, payment_lag, payment_calendar, 
                        fixing_date_policy, fixing_calendar, payment_offset_bus_b, payment_day, payment_date_rule,
                        payment_date_roll, fx_reset_id, fx_calendar ) values ( '||
                         c1_rec.product_id||','||
                         c1_rec.receive_leg_id||','||
                         chr(39)||c1_rec.start_date||chr(39)||','||
                         chr(39)||c1_rec.end_date||chr(39)||','||
                         c1_rec.payment_lag||','||
                         chr(39)||c1_rec.payment_calendar||chr(39)||','||    
                         c1_rec.fixing_date_policy||','||
                         chr(39)||c1_rec.fixing_calendar||chr(39)||','||
                         c1_rec.payment_offset_bus_b||','||
                         c1_rec.payment_day||','||
                         c1_rec.payment_date_rule||','||
                         chr(39)||c1_rec.payment_date_roll||chr(39)||','||
                         nvl(c1_rec.fx_reset_id,0)||','||
                         chr(39)||c1_rec.fx_calendar||chr(39)||')';    

               execute immediate v_sql2;

    v_sql3 :=  'update commodity_leg2 set averaging_policy = '||chr(39)||c1_rec.averaging_policy||chr(39)||     
                                        ' , avg_rounding_policy = '||chr(39)||c1_rec.avg_rounding_policy||chr(39)||
                     '  where leg_id = '||c1_rec.pay_leg_id||' or leg_id = '||c1_rec.receive_leg_id;
              

   
            execute immediate v_sql3;
 end loop;
      execute immediate 'delete from cf_sch_gen_params where leg_id = 0 and product_id in (select product_id from product_commodity_swap2)';

commit;
end;
end comm_swap1;
;

begin
comm_swap1;
end;
;

create or replace procedure comm_swap2 as
begin
declare
cursor c1 is
SELECT
  pcs2.pay_leg_id,
  pcs2.receive_leg_id,
  cl2.comm_reset_id
FROM
 product_commodity_swap2 pcs2, commodity_leg2 cl2
where
  cl2.leg_id = pcs2.pay_leg_id or cl2.leg_id = pcs2.receive_leg_id;

begin
for c1_rec in c1 loop
  if c1_rec.comm_reset_id = 0 then
   execute immediate
      'update commodity_leg2 set comm_reset_id = (
          select max(a.comm_reset_id) from commodity_leg2 a where
          a.comm_reset_id !=0 and a.leg_id = '||c1_rec.pay_leg_id||' or a.leg_id = '||c1_rec.receive_leg_id||')
       where leg_id = '||c1_rec.pay_leg_id||' or leg_id = '||c1_rec.receive_leg_id;

end if;
 end loop;
commit;
end;
end comm_swap2;
;

begin
comm_swap2;
end;
;


create or replace procedure comm_swap3
as
begin
declare cursor c1 is
select cf.product_id,
       cf.leg_id,
       cl2.fx_reset_id,
       cl2.fx_calendar,
       pcs2.pay_leg_id,
       pcs2.receive_leg_id
 from commodity_leg2 cl2, cf_sch_gen_params cf,  product_commodity_swap2 pcs2
where cf.product_id = pcs2.product_id and cl2.leg_id = cf.leg_id;

v_sql1 varchar2(2000);
v_sql2 varchar2(2000);
v_temp_calendar varchar2(64);

begin
for c1_rec in c1 loop
  if c1_rec.fx_calendar is null then v_temp_calendar := ' '; else v_temp_calendar := c1_rec.fx_calendar; end if;
  v_sql1 := 'update cf_sch_gen_params set fx_reset_id = '||c1_rec.fx_reset_id||',
               fx_calendar = '||chr(39)||v_temp_calendar||chr(39)||'  where leg_id = '||c1_rec.pay_leg_id;

  v_sql2 := 'update cf_sch_gen_params set fx_reset_id = '||c1_rec.fx_reset_id||',
               fx_calendar = '||chr(39)||v_temp_calendar||chr(39)||'  where leg_id = '||c1_rec.receive_leg_id;

   execute immediate v_sql1;
   
   execute immediate v_sql2;

end loop;
commit;
end;
end comm_swap3;
;

begin
comm_swap3;
end;
;



create or replace procedure otc2 as
begin
declare
 cursor c1 is
   select cf.product_id,
          pco2.leg_id,
          pco2.averaging_policy,
          pco2.avg_rounding_policy
  from cf_sch_gen_params cf, product_commodity_otcoption2 pco2
    where cf.product_id = pco2.product_id and cf.leg_id = 0;

  cursor c2 is
    select cf.product_id,
       cf.leg_id,
       cl2.fx_reset_id,
       cl2.fx_calendar
 from commodity_leg2 cl2, cf_sch_gen_params cf
where cl2.leg_id = cf.leg_id;

 v_sql1 varchar2(2000);
 v_sql2 varchar2(2000);
 v_sql3 varchar2(2000);

 v_temp_calendar varchar2(64);
  

begin
for c1_rec in c1 loop
    v_sql1 :=  'update cf_sch_gen_params set leg_id = '||c1_rec.leg_id||     
                     '  where product_id = '||c1_rec.product_id;


     execute immediate v_sql1;
 
   
   v_sql2 :=  'update commodity_leg2 set averaging_policy = '||chr(39)||c1_rec.averaging_policy||chr(39)||     
                                        ' , avg_rounding_policy = '||chr(39)||c1_rec.avg_rounding_policy||chr(39)||
                     '  where leg_id = '||c1_rec.leg_id;
 

     execute immediate v_sql2;
 
end loop;

for c2_rec in c2 loop
  if c2_rec.fx_calendar is null then v_temp_calendar := ' '; else v_temp_calendar := c2_rec.fx_calendar; end if;

   v_sql3 := 'update cf_sch_gen_params set fx_reset_id = '||c2_rec.fx_reset_id||',
               fx_calendar = '||chr(39)||v_temp_calendar||chr(39)||'  where leg_id = '||c2_rec.leg_id;


     execute immediate v_sql3;

end loop;
end;
end otc2;
;

begin
otc2;
end;
;

/* end of commodities changes */


/* start of XML "inserts"   */

INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Exotic', 'apps.risk.ExoticAnalysisViewer', 0 )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Benchmark', 'apps.risk.BenchmarkAnalysisViewer', 0 )
;
INSERT INTO calypso_seed ( last_id, seed_name ) VALUES ( 1000, 'FXResetProductInfo' )
;
INSERT INTO calypso_seed ( last_id, seed_name ) VALUES ( 1000, 'Calibration' )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_calibratible_model', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_calibrator', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'INCOME_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTransfer', 'CheckUnauthorizedSDI', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'CheckUnauthorizedSDI', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOMINAL_ADJUST', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AllowInsertRemoveTransferRules', 'Allow user to insert or remove customized transfer rules in BackOffice SDI Panel' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'CommodityCertificate', 'Commodity Certificates for Physical Commodities' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'incomingType', 'MT320', 'INC_CASHCONFIRM' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'IncomingSwiftTrade', 'Incomimg Swift Message Template Name for Trade Confirmation' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'IncomingSwiftTrade', 'MT300' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'IncomingSwiftTrade', 'MT305' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'IncomingSwiftTrade', 'MT306' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'IncomingSwiftTrade', 'MT320' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'tradeCancelStatus', 'Status where the trade is considered canceled. Should be a subset of domain tradeStatus.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'scenarioRule', 'Custom Scenario Rules' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VolSurface.gensimple', 'QuadraticSmileParams', 'Smile adjustment surface containing user defined Alpha and Beta values' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VolSurface.gensimple', 'BondOptionQuadraticSmile', 'BondOption Smile adjusted surface that uses a QuadraticSmileParams and a Bond Option vol surface to create its own surface' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'BondOption', 'BondOption volatility surface' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'LGMM2FMultiStartBestFit', 'Calibrates the LGMM2F model with constant parameter in a best-fit sense' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CallAccountType', 'Used in acc_account to indicate the type of a CallAccount.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AccountHolderRole', 'Used in acc_account to indicate the role of a CallAccount.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AccountSettleMethod', 'Used in acc_account to indicate the SettleMethod od the sdi linked to a CallAccount.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'InventoryAgent', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'AccountNumber', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'UnavailabilityReason', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeTmplKeywords', 'InventoryAgent', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeTmplKeywords', 'AccountNumber', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeTmplKeywords', 'UnavailabilityReason', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineParam', 'DateType', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineParam', 'BALANCE_MODE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'dayChangeRule', 'Day Change Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CurveSeasonality.adj', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'absMktDataUsage', 'Usage codes for assigned ABS Market Data Items' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'AccountStatement', 'AccountStatement Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'AccountStatementConfig', 'AccountStatementConfig Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'CAWarrantGeneration', 'CAWarrantGeneration Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'CorporateActionSimulation', 'CorporateActionSimulation Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'GenericComment', 'GenericComment Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'WarrantTransformation', 'WarrantTransformation Report' )
;
delete from domain_values where name = 'AssetSwap.extendedType' and value = 'CreditContingent'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetSwap.extendedType', 'CreditContingent', 'Asset swap contingent on reference entity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetSwap.extendedType', 'CreditContingentBasket', 'Asset swap contingent on basket reference entity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'CalculationServerConfig', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'unavailabilityReason', 'List of unavailability reasons' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'securityCode', 'LoanXID', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'keyword.terminationReason', 'List of termination reason' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.terminationReason', 'Assigned', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.terminationReason', 'Manual', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.terminationReason', 'BoughtBack', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.terminationReason', 'ContractRevision', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volatilityType', 'BondOption', '' )
;
delete from domain_values where name = 'futureUnderType' and value = 'Equity'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'futureUnderType', 'Equity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ExternalMessageField.Instructions', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'NAV_CALC', 'Market Index NAV Calculation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FX Default Currency Pair', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FX Default CounterParty', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FX Default Broker', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FX Default Prime Broker', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FX User Type', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommoditySwap2.Pricer', 'Pricers for CommoditySwap2' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommoditySwap2.Pricer', 'PricerCommoditySwap2', 'Pricer for the CommoditySwap2 product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityOTCOption2.Pricer', 'Pricers for CommodityOTCOption2' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityOTCOption2.Pricer', 'PricerCommodityOTCOption2', 'Pricer for the CommodityOTCOption2 product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityCertificate.Pricer', 'Pricers for CommodityCertificates' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCertificate.Pricer', 'PricerCommodityCertificate', 'Pricer for the CommodityCertificate product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DispatcherParamsDatasynapse', 'DataSynapse username', 'string' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DispatcherParamsDatasynapse', 'DataSynapse password', 'string' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.terminationReason', 'Novation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAccessPermAttributes', 'Max.Task', 'Type to be enforced by reports' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'PCCreditRatingLEAttributesOrder', 'Order of attributes separated with a comma' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'creditRatingSource', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'CATransformation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeAction', 'CONTINUE', 'User continues trade. It means the current trade is ended but continued by another trade. It looks like a rollover.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ScenarioViewerClassNames', 'apps.risk.Scenario2DMarketDataItemViewer', 'A generic viewer for perturbations on 2D market data items' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ScenarioViewerClassNames', 'apps.risk.ScenarioSeasonalityRiskViewer', 'Display monthly seasonality risk measures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ScenarioViewerClassNames', 'apps.risk.ScenarioInflationFixingReportViewer', 'Display monthly inflation risk measures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'INTEREST_PREMIUMLEG', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'INTEREST_SHORTFALL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'PRINCIPAL_SHORTFALL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'WRITE_DOWN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'FIXED_CORRECTION', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'FLOAT_CORRECTION', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'INTEREST_SHORTFALL_REIM', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'PRINCIPAL_SHORTFALL_REIM', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'WRITE_DOWN_REIM', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'RECLASS_LIABILITY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'RECLASS_ASSET', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'RECLASS_ACCOUNT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'currencyDefaultAttribute', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'currencyPairAttribute', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FXOptVolSurfUndSource', 'FX Option volatility source underlying source' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'assetSwapUpfrontFeeType', 'Asset Swap Upfront Fee Type' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'assetSwapRedemptionFeeType', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'assetSwapUpfrontFeeType', 'UPFRONT_FEE', 'Asset Swap Upfront Fee' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'assetSwapRedemptionFeeType', 'REDEMPTION_FEE', 'Asset Swap Redemption Fee' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Bond.Pricer', 'PricerBondLGMM2F', 'Exotic note pricer using LGMM2F model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CDSNthLoss.Pricer', 'PricerCDSNthLossOFMHermite', 'NthLoss pricer using a fast Hermite expansion of the Gaussian one factor model.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetSwap.Pricer', 'PricerAssetSwapCreditContingent', 'Pricer for an AssetSwap contingent on credit events of a single reference entity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetSwap.Pricer', 'PricerAssetSwapCreditContBasket', 'Pricer for an AssetSwap contingent on credit events of a basket of reference entities' )
;
delete from domain_values where name = 'CDSIndexOption.Pricer' and value = 'PricerCDSIndexOption'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CDSIndexOption.Pricer', 'PricerCDSIndexOption', 'Pricer for CDSIndex Option which uses quote or underlying curves' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CDSIndexOption.Pricer', 'PricerCDSIndexOptionSingleCurve', 'Pricer for CDSIndex Option which uses Probability curve assigned to basket' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CallAccount.Pricer', 'PricerCallAccount', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Bond.subtype', 'Exotic', 'Bonds with eXotic payouts' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AssetPerformanceSwap.subtype', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetPerformanceSwap.subtype', 'Total_Return', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetPerformanceSwap.subtype', 'Price_Return', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetPerformanceSwap.subtype', 'Future', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetPerformanceSwap.subtype', 'Forward', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_ONE TOUCH NO TOUCH', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'unavailabilityReason', 'NONE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineName', 'BalanceEngine', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventClass', 'PSEventProcessAccounting', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'TransferBatchNettingFilter', 'Transfer Batch Netting Event Filter' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'MatchingEventFilter', 'Filter out Message not eligible for any Matching Context Event Filter' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventClass', 'PSEventBalanceReclassification', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'BalanceEngineEventFilter', 'filter for Balance Engine to check if at least one balance process_flag is ''N''' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'BALANCE_RECLASSIFICATION', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'EX_LIQUIDATION_ERROR', 'Indicates an exception has occurred during liquidation.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'LIQUIDATION_ERROR', 'Indicates an exception has occurred during liquidation.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'BICDATA', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'OperationsProcessingProcessTrade', 'Access permission to use the Process Trades function in the Process Trades window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'OperationsProcessingRegenerateEvent', 'Access permission to use the Regenerate Event function in the Process Trades window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'OperationsProcessingMergeCounterparties', 'Access permission to use the Merge CounterParties function in the Process Trades window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyUsedSDI', 'Access permission to Modify Used SDIs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyLEManualSDIDefaultedValues', 'Access permission to Modify MSDIs Defaulted values' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyCalculationServerConfig', 'Access permission to create/modify/delete CalculationServer Configuration.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'FXTradingSalesMargin', 'Access permission for Sales Margin Trades' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'FXTradingBroker', 'Access permission for Broker Trades' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'FXTradingInternal', 'Access permission for Internal Trades' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateCalculationServerConfig', 'Function to authorize to create/modify CalculationServer config' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveCalculationServerConfig', 'Function to authorize to remove CalculationServer config' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataUsage', 'PREPAY', 'Indicates item is a prepayment curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataUsage', 'DEFAULT', 'Indicates item is a default curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage', 'PREPAY', 'Indicates item is prepayment curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage', 'DEFAULT', 'Indicates item is default curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage', 'REC', 'Indicates item is Recovery curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage', 'DELINQUENCY', 'Indicates item is delinquency curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'absMktDataUsage.PREPAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage.PREPAY', 'CurvePrepay', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'absMktDataUsage.DEFAULT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage.DEFAULT', 'CurveDefault', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'absMktDataUsage.REC', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage.REC', 'CurveRecovery', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'absMktDataUsage.DELINQUENCY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'absMktDataUsage.DELINQUENCY', 'CurveDelinquency', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddModifyAccountStatement', 'Access permission to Add or Modify an Account Statement Config' )
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveAccountStatement', 'Access permission to Remove an Account Statement Config' )
;

delete from domain_values where name='function' and value='CreateCDSIndexDefinition'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateCDSIndexDefinition', 'Access permission to create a CDS Index Definition' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataType', 'CurvePrepay', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataType', 'CurveDefault', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataType', 'CurveDelinquency', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'CommodityCertificateStock', '' )
;
delete from domain_values where name= 'quoteType'and value='Future32'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'quoteType', 'Future32', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'ScenarioTaylorSeriesInput', 'Compute and store taylor series inputs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'Exotic', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'Benchmark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'GENERATE_CORRELATION_SURFACE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'PS_RERUN_ANALYSIS', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'EOD_TRANSFER_NETTING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'BALANCE_RECLASSIFICATION', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'RECON_INV_PL_POSITIONS', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'ACCOUNT_BALANCE', 'Update balance positions for next PROJECTED_DAYS' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'ACCOUNT_BALANCE_EVENT', 'Generate events to update account balances' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'CFD_CA', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'CHECK_BICDATA', 'Check the valid swift contact in the Schedule Task' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'PartialNovatedTo', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'CAVersion', '' )
;
delete from domain_values where name = 'MESSAGE.Templates' and value = 'cdsABSConfirm.html'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'cdsABSConfirm.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'VarianceSwapConfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'applicationName', 'CalculationServer', 'CalculationServer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'MatrixSheet', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'Benchmark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'Hedge', 'Hedge Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'VegaByStrike', 'VegaByStrike Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'CommodityCertificateStock', 'CommodityCertificateStock Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'SwiftMessage.Action', 'Mapping of ack/nack action' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SwiftMessage.Action', 'ACK', 'ACK' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SwiftMessage.Action', 'NACK', 'NACK' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MsgAttributes.NackReason', 'Mapping of Nack Reason' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H01', 'Basic Header not present or format error block 1' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H02', 'Application identifier not A (GPA) or F (FIN)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H03', 'Invalid Service Message-identifier (unknown or not allowed from user)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H10', 'Bad LT address or application not enabled for the LT' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H15', 'Bad session number' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H20', 'Error in the ISN' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H21', 'Error in the message sender''s branch code' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H25', 'Application header format error or not present when mandatory' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H26', 'Input/output identifier not ''I'' (on input from LT)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H30', 'Message type does not exist for this application' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H40', 'This priority does not exist for this message category' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H50', 'Destination address error' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H51', 'Invalid sender or receiver for message type or mode' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H52', 'MT 072, selection of Test AND Training mode/version, MT 077 Additional Selection Criteria for FIN are not allowed while a FIN session is open' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H55', 'Message type not allowed for fallback session for MT 030' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H80', 'Delivery option error' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H81', 'Obsolescence period error' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H98', 'other format error in the Basic Header or in the Application Header' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.NackReason', 'H99', 'Invalid receiver destination Or Invalid date or time' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CustomStaticDataFilter', 'Custom Static Data Filter Names' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'Cash', 'Cash  ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'WarrantIssuance', 'WarrantIssuance ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'LegalEntitySelector', 'Legal Entity Selector' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityCumulativeDailyFwdPointKeywords', 'keywords to differentiate dialy forward point from monthly forward point' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCumulativeDailyFwdPointKeywords', 'DD', 'Daily foward point keyword' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCumulativeDailyFwdPointKeywords', 'Day', 'Daily foward point keyword' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCumulativeDailyFwdPointKeywords', 'Daily', 'Daily foward point keyword' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityCumulativeMonthlyFwdPointKeywords', 'keywords to differentiate monthly forward point from daily forward point' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCumulativeMonthlyFwdPointKeywords', 'DM', 'Monthly foward point keyword' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCumulativeMonthlyFwdPointKeywords', 'Month', 'Monthly foward point keyword' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'PhysicalCommodityType', 'Supported behavioral types of physically represented Commodities' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PhysicalCommodityType', 'Storage Based', 'Commodities that are physically stored at a location for a cost. (ie Agriculture)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PhysicalCommodityType', 'Vintage Based', 'Commodities that are traded based on vintage year(ie Emmision Credits)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityCertificate.Vintage', 'Vintages used for Vintage Based Commodity Certificates' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCertificate.Vintage', '2008', 'The 2008 Vintage year' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCertificate.Vintage', '2009', 'The 2009 Vintage year' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCertificate.Vintage', '2010', 'The 2010 Vintage year' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'scenarioMarketDataFilters', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scenarioMarketDataFilters', 'HyperSurface', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataType', 'HyperSurfaceImpl', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataUsage', 'HyperSurface', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'hyperSurfaceSubTypes', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'hyperSpaceContainers', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceContainers', 'Default', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'hyperSurfaceGenerators', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'hyperSpaceInterpolators', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSurfaceGenerators', 'SimpleDefault', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceInterpolators', 'SimpleNoInterp', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceInterpolators', '1DLinear', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceInterpolators', '1DLogLinear', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceInterpolators', '1DSpline', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceInterpolators', '2DLinear', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swap.Pricer', 'PricerSwapDemoUsingHyperSurface', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceInterpolators', '3DLinear', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSpaceInterpolators', '4DLinear', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scenarioRule', 'HyperSurface', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'calibratibleModels', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'calibrations', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CustomCalibrationFrameConfig', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CustomCalibrationMeasureConfig', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'calibratibleModels', 'CalibratibleLGMModel', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'calibrators', 'LGMCalibrator', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CustomCalibrationFrameConfig', 'LGMFrameConfig', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CustomCalibrationMeasureConfig', 'LGMCalibrationMeasureConfig', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'dsInit', 'CalibrationReferenceServer', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'dayChangeRule', 'TimeZone', 'Day Change based on selected TimeZone ' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'dayChangeRule', 'FX', 'Day Change based on FX market convention ' )
;
delete from domain_values where name = 'marketDataType' and value = 'CurveInflation'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataType', 'CurveInflation', '' )
;
delete from domain_values where name = 'domainName' and value = 'CurveInflation.gen'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CurveInflation.gen', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveInflation.gen', 'InflationDefault', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveInflation.gen', 'InflationAdditive', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveInflation.gen', 'InflationMultiplicative', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CurveInflation.gensimple', '' )
;
delete from domain_values where name = 'CurveInflation.gensimple' and value = 'InflationBasis'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveInflation.gensimple', 'InflationBasis', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CurveInflationBasis.gen', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveSeasonality.adj', 'Additive', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveSeasonality.adj', 'Multiplicative', '' )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'INCOME_EFFECT', 'Income Effect', 66, 'NPV', 0 )
;
INSERT INTO fee_definition ( fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, fee_code ) VALUES ( 'UPFRONT_FEE', 'Upfront Fee', 1, 1, 'CounterParty', 1, 1, 17 )
;
INSERT INTO fee_definition ( fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, fee_code ) VALUES ( 'REDEMPTION_FEE', 'Redemption Fee', 1, 1, 'CounterParty', 1, 1, 18 )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'BACKOFFICE', 'CallAccount.ANY.ANY', 'PricerCallAccount' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'MIDDLEOFFICE', 'CallAccount.ANY.ANY', 'PricerCallAccount' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'FRONTOFFICE', 'CallAccount.ANY.ANY', 'PricerCallAccount' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'AssetSwap.CreditContingent.ANY', 'PricerAssetSwapCreditContingent' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'AssetSwap.CreditContingentBasket.ANY', 'PricerAssetSwapCreditContBasket' )
;
INSERT INTO pos_agg_conf ( pos_agg_conf_id, name, strategy_b, long_short_b, custodian_b, trader_b, dynamic_attrs ) VALUES ( 1, 'CurrencyPair', 0, 0, 0, 0, 'CCY_PAIR' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LOSS_GRAPH', 'tk.core.PricerMeasure', 276, 'Graph of expected losses for a credit contingent contract' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'MC_GRAPH', 'tk.core.PricerMeasure', 279, 'Graph of Monte Carlo results' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'MC_HSTGRAM', 'tk.core.PricerMeasure', 282, 'Histogram of Monte Carlo simulations' )
;
delete from pricer_measure where measure_name ='DELTA_RISKY_SEC' and measure_class_name = 'tk.core.PricerMeasure' and measure_id= 243
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'DELTA_RISKY_SEC', 'tk.core.PricerMeasure', 243, 'Delta where risky currency is secondary' )
;
delete from pricer_measure where measure_name ='DELTA_RISKY_PRIM' and measure_class_name = 'tk.core.PricerMeasure' and measure_id= 244
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'DELTA_RISKY_PRIM', 'tk.core.PricerMeasure', 244, 'Delta where risky currency is primary (same as DELTA_W_PREMIUM)' )
;
delete from pricer_measure where measure_name ='FWD_DELTA_RISKY_PRIM' and measure_class_name = 'tk.core.PricerMeasure' and measure_id= 252
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'FWD_DELTA_RISKY_PRIM', 'tk.core.PricerMeasure', 252, 'Forward Delta where risky currency is primary' )
;
delete from pricer_measure where measure_name ='FWD_DELTA_RISKY_SEC' and measure_class_name = 'tk.core.PricerMeasure' and measure_id= 251
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'FWD_DELTA_RISKY_SEC', 'tk.core.PricerMeasure', 251, 'Forward Delta where risky currency is secondary' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURRENCY_BREAKDOWN', 'tk.core.TabularPricerMeasure', 263 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'LEG_BREAKDOWN', 'tk.core.TabularPricerMeasure', 291 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'PROB_OF_REDEMPTION', 'tk.core.PricerMeasure', 292, 'Probability of redemption information held in client data' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'VALUATION_TIME_MS', 'tk.core.PricerMeasure', 294, 'Time, in milli-seconds, to value the trade excluding the time to calibrate the model' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'CALIBRATION_TIME_MS', 'tk.core.PricerMeasure', 295, 'Time, in milli-seconds, to calibrate the model' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'EXPECTED_TIME_TO_REDEMPTION', 'tk.core.PricerMeasure', 296, 'The expected time to redemption of a Tarn' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_NEAR', 'tk.core.PricerMeasure', 298, 'FX Swap - NPV of the near leg' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_FAR', 'tk.core.PricerMeasure', 299, 'FX Swap - NPV of the far leg' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SALES_MARGIN', 'tk.core.PricerMeasure', 285 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SALES_MARGIN_UNREALIZED', 'tk.core.PricerMeasure', 286 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'FX', 'tk.core.PricerMeasure', 293, 'FX rate used' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DEF_EXPOSURE_TIGHT', 'tk.core.PricerMeasure', 300 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'THEO_POS', 'tk.core.PricerMeasure', 301 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACTUAL_POS', 'tk.core.PricerMeasure', 302 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FWD_POS', 'tk.core.PricerMeasure', 303 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCRUAL_IB', 'tk.core.PricerMeasure', 304 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LGM2F_MODEL', 'tk.core.PricerMeasure', 305, 'records the LGM2F model used in the valuation' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'INDEX_FWD_RATE', 'tk.core.PricerMeasure', 306 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BETA', 'tk.core.PricerMeasure', 307 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BETA_ADJUSTED_DELTA', 'tk.core.PricerMeasure', 308 )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_BEST_FIT_GRAPH_MESH_SIZE', '30' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'MIXTURE_CALIBRATE_FOR_GREEKS', 'java.lang.Boolean', 'true,false', 'Re-calibrate mixture volatility model when calculating numerical greeks.', 1, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'BETA_REFERENCE_INDEX', 'java.lang.String', '', 'Refernce Index For Beta', 1, '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'LOAN_FROM_QUOTE', 'java.lang.Boolean', 'true,false', 'Use quote for the NPV of secondary market trade on loan', 1, 'true' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'APPLY_INSTR_SPRD', 'java.lang.Boolean', 'true,false', 'Apply the instrument spread of a bond to the discount curve and price all measures using the shifted discount curve together with the probability curve.', 1, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'COMM_OPT_TIME_TO_EXPIRY_ADJ', 'java.lang.Double', '', 'The approximation of the time to expiry (in days) on the final fixing date of the option.  The value must be greater than zero and less than or equal to 1.', 0, '0.5' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_BEST_FIT_GRAPH_MESH_SIZE', 'java.lang.Integer', '', 'Number of discrete points used in the best-fit error graph', 0, 'BEST_FIT_GRAPH_MESH_SIZE', '30' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_KAPPA1', 'com.calypso.tk.core.Rate', '', 'Kappa1 in the LGM2F model, entered as a rate', 0, 'KAPPA1', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_KAPPA2', 'com.calypso.tk.core.Rate', '', 'Kappa2 in the LGM2F model, entered as a rate', 0, 'KAPPA2', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_SIGMA1', 'com.calypso.tk.core.Rate', '', 'Sigma1 in the LGM2F model, entered as a rate', 0, 'SIGMA1', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_SIGMA2', 'com.calypso.tk.core.Rate', '', 'Sigma2 in the LGM2F model, entered as a rate', 0, 'SIGMA2', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM2F_RHO', 'com.calypso.tk.core.Rate', '', 'Rho in the LGM2F model, entered as a rate', 0, 'RHO', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'IGNORE_TARN', 'java.lang.Boolean', '', 'Ignore the Tarn feature when pricing, typically in a transient way', 0, 'IGNORE_TARN', 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'ANTITHETIC_VARIATE', 'java.lang.Boolean', 'true,false', 'Flag controls whether or not the monte-carlo routine uses an antithetic variate to reduce variance', 0, 'ANTITHETIC_VARIATE', 'true' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'BROWNIAN_BRIDGE', 'java.lang.Boolean', 'true,false', 'Flag controls whether or not the path generator within the monte-carlo routine uses a Brownian bridge when constructing paths', 0, 'BROWNIAN_BRIDGE', 'true' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name, default_value ) VALUES ( 'VOLATILITY_AS_OF_TIME', 'java.lang.String', 'Fx/FxOption : The roll time for the vol surfaces', 1, 'VOLATILITY_AS_OF_TIME', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'CEV_ALPHA', 'com.calypso.tk.core.Rate', '', 'CEV model parameter Alpha', 0, 'CEV_ALPHA' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'CEV_BETA', 'java.lang.Double', '', 'CEV model parameter Beta', 0, 'CEV_BETA' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'USE_CALIBRATION', 'java.lang.Boolean', 'true,false', 'Controls whether a CalibrationAware Pricer should use an available Calibration.', 0, 'USE_CALIBRATION', 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'INTG_MTHD_CR', 'java.lang.String', 'LINEAR_SINGLE,SIMPSON,EXACT', 'Credit integration method, specifying the numerical method for summing credit event probability over the course of a cashflow period.', 1, 'INTG_MTHD_CR', 'LINEAR_SINGLE' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'INCLUDE_NPV_COLLAT', 'java.lang.Boolean', 'true,false', 'Include Collateral Value in Repo NPV', 1, 'true' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'FORECAST_FX_RATE', 'java.lang.Boolean', 'true,false', 'Forecast FX Rates when calculating future Principal Adjustment Flows in PricerXCCySwap.', 1, 'false' )
;
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list ) VALUES ( 'LoanXID', 'string', 0, 0, 0, '' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventAccounting', 'BalanceEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventBalanceReclassification', 'AccountingEngine' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'dts_field_mask', 'DTS - Configuration data for TOF Field List bit-mask' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'dts_field_type', 'DTS - Configuration data for TOF Field Definitions' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'dts_data_source', 'DTS - Configuration data for DTS Source of Data and Broker configuration' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'sort_order', 'Customized Sort order per user for use in reports' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'pc_credit_rating', 'Pricer configuration for credit rating (Credit panel).' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'pc_credit_rating_attribute', 'Attributes linked with pc_credit_rating.' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'product_commodity_otcoption2', 'averaging_policy and avg_rounding_policy columns are not used anymore, only here for migration purpose' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'product_commodity_swap2', 'averaging_policy and avg_rounding_policy columns are not used anymore, only here for migration purpose' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'commodity_leg2', 'fx_reset_id and fx_calendar columns are not used anymore, only here for migration purpose' )
;

CREATE TABLE dts_field_mask ( mask_id numeric  NOT NULL,  mask_type varchar2 (64) NOT NULL,  mask_value numeric  NOT NULL ) 
;

INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 500, 'Database Status', 1 )
;
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 501, 'Spot', 2 )
;
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 501, 'Outright', 4 )
;
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 502, 'Swap', 8 )
;
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 503, 'Deposit', 16 )
;
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 504, 'Conversation Text', 1024 )
;
INSERT INTO dts_field_mask ( mask_id, mask_type, mask_value ) VALUES ( 505, 'FRA', 32 )
;

CREATE TABLE dts_field_type ( field_id numeric  NOT NULL,  title varchar2 (64) NULL,  description varchar2 (255) NULL,  is_optional_b numeric  DEFAULT 0 NOT NULL,  max_size numeric  NULL,  data_type varchar2 (32) NULL,  field_mask numeric  NULL,  sw_version varchar2 (32) NULL ) 
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 500, 'Source of Data', 0, 2, 'Integer', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 501, 'Source Reference', 0, 11, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 502, 'Date of Deal', 0, 11, 'Date', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 503, 'Time of Deal', 0, 8, 'Time', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 504, 'Dealer ID', 0, 6, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 505, 'Date Confirmed', 0, 11, 'Date', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 506, 'Time Confirmed', 0, 8, 'Time', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 507, 'Confirmed-by ID', 0, 6, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 508, 'Bank 1 Dealing Code', 1, 4, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 509, 'Bank 1 Name', 0, 56, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 510, 'Broker Dealing Code', 1, 4, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 511, 'Broker Name', 1, 56, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 512, 'Reason for Sending (CIF)', 0, 2, 'String', 0, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 513, 'Bank 2 Name', 1, 56, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 514, 'Deal Type', 0, 2, 'Integer', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 515, 'Period 1', 0, 3, 'Period', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 516, 'Period 2', 0, 3, 'Period', 56, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 517, 'Currency 1', 0, 3, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 518, 'Currency 2', 0, 3, 'String', 14, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 519, 'Deal Volume Currency 1', 0, 15, 'Price', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 520, 'Deposit Rate', 0, 12, 'Price', 48, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 521, 'Swap Rate', 0, 12, 'String', 8, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 522, 'Exchange Rate Period 1', 0, 12, 'Price', 14, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 523, 'Exchange Rate Period 2', 0, 12, 'Price', 8, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 524, 'Rate Direction', 0, 1, 'Direction', 14, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 525, 'Value Date Period 1 Currency 1', 0, 11, 'Date', 30, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 526, 'Value Date Period 1 Currency 2', 0, 11, 'Date', 14, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 527, 'Value Date Period 2 Currency 1', 0, 11, 'Date', 24, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 528, 'Value Date Period 2 Currency 2', 0, 11, 'Date', 8, '3.08' )
;
INSERT INTO dts_field_type ( title, field_id, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 'Payment Instruction Period 1 Currency 1', 529, 1, 56, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 530, 'Payment Instruction Period 1 Currency 2', 1, 56, 'String', 14, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 531, 'Payment Instruction Period 2 Currency 1', 1, 56, 'String', 56, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 532, 'Payment Instruction Period 2 Currency 2', 1, 56, 'String', 0, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 533, 'Oldest Deal Identifier', 0, 11, 'String', 1, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 534, 'Oldest Deal Date', 1, 11, 'String', 1, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 535, 'Oldest Deal Time', 1, 8, 'Time', 1, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 536, 'Latest Deal Identifier', 0, 11, 'String', 1, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 537, 'Latest Deal Date', 1, 11, 'Date', 1, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 538, 'Latest Deal Time', 1, 8, 'Time', 1, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 539, 'Secondary Source Reference', 1, 10, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 540, 'Method of deal', 0, 2, 'String', 62, '3.08' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 541, 'Rate Currency 1 against USD', 1, 12, 'Price', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 542, 'Rate Currency 2 against USD', 1, 12, 'Price', 14, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 543, 'Rate Base Currency against USD', 1, 12, 'Price', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 544, 'Base Currency', 1, 3, 'String', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 545, 'Calculated volume Period 1 Currency 2', 1, 15, 'Price', 14, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 546, 'Calculated volume Period 2 Currency 2', 1, 15, 'Price', 8, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 547, 'Volume Period 2 Currency 1', 1, 15, 'Price', 24, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 548, 'Conversation Text', 0, 2000, 'String', 1024, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 549, 'Dealer Name', 0, 20, 'String', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 550, 'Confirmed-by Name', 0, 20, 'String', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 551, 'Local TCID', 0, 4, 'String', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 552, 'Review Reference Number', 0, 10, 'String', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 553, 'Common Text', 1, 124, 'String', 62, '3.10' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 554, 'FRA Fixing Date', 0, 11, 'Date', 32, '3.20' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 555, 'FRA Settlement Date', 0, 11, 'Date', 32, '3.20' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 556, 'FRA Maturity Date', 0, 11, 'Date', 32, '3.20' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 557, 'IMM Indicator', 0, 1, 'String', 32, '3.20' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 558, 'Dealing Server Version Number', 0, 10, 'String', 1, '3.20' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 559, 'Outright Points Premium Rate', 1, 12, 'Price', 4, '3.20' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 560, 'Spot Basis Rate', 1, 12, 'Price', 4, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 561, 'User-defined Title 1', 1, 20, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 562, 'User-defined Data 1', 1, 40, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 563, 'User-defined Title 2', 1, 20, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 564, 'User-defined Data 2', 1, 40, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 565, 'User-defined Title 3', 1, 20, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 566, 'User-defined Data 3', 1, 40, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 567, 'ID of the original if this is a Contra', 1, 11, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 568, 'ID of previous if this is a next', 1, 11, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 569, 'Pure Deal-type', 0, 4, 'Integer', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 570, 'Volume of Interest', 0, 15, 'Price', 16, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 571, 'Days elapsed during Deal', 0, 6, 'String', 56, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 572, 'Year Length', 0, 3, 'String', 48, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 573, 'Price Convention', 0, 1, 'String', 12, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 574, 'Interest Message (CIF)', 1, 14, 'String', 0, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 575, 'SWIFT-BIC Currency-1 Period-1', 1, 11, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 576, 'SWIFT-BIC Currency-2 Period-1', 1, 11, 'String', 14, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 577, 'SWIFT-BIC Currency-1 Period-2', 1, 11, 'String', 56, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 578, 'SWIFT-BIC Currency-2 Period-2', 1, 11, 'String', 8, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 579, 'D2000-2 Credit Reduction', 1, 15, 'Price', 2, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 580, 'D2000-2 Credit Remaining', 1, 15, 'Price', 2, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 581, 'Base Currency 2', 1, 3, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 582, 'Base Currency 3', 1, 3, 'String', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 583, 'Rate Base Currency 2 versus USD', 1, 12, 'Price', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 584, 'Rate Base Currency 3 versus USD', 1, 12, 'Price', 62, '3.30' )
;
INSERT INTO dts_field_type ( field_id, title, is_optional_b, max_size, data_type, field_mask, sw_version ) VALUES ( 599, 'Reuters TOF Simulator', 1, 124, 'String', 62, '3.08' )
;
CREATE TABLE dts_data_source ( source_code varchar2 (2) NOT NULL,  provider varchar2 (32) NOT NULL,  description varchar2 (255) NOT NULL,  broker varchar2 (32) NULL ) 
;
INSERT INTO dts_data_source ( source_code, provider, description ) VALUES ( '1', 'REUTERS', 'Dealing3000-OfflineDealCapture' )
;
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '2', 'REUTERS', 'Dealing3000-2-Match', 'REUTERS' )
;
INSERT INTO dts_data_source ( source_code, provider, description ) VALUES ( '3', 'REUTERS', 'Dealing3000-1-Conversation' )
;
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '4', 'EBS', 'SRC_4_EBS=EBS-E-EBSGeneratedTrade', 'EBS' )
;
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '5', 'EBS', 'EBS-F-EBSTrade', 'EBS' )
;
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( ' ', 'EBS', 'EBS-Blank-EBSTrade', 'EBS' )
;
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '12', 'RTNS', 'RTNS-RTFX-Multi-Portal_Trade', 'REUTERS' )
;
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '32', 'RTNS', 'RTNS-Meitan-Tradition-Broker_Trade', 'REUTERS' )
;
INSERT INTO dts_data_source ( source_code, provider, description, broker ) VALUES ( '34', 'RTNS', 'RTNS-Nittan-Broker_Trade', 'RTNS' )
;

/* end of XML "inserts"  */

DELETE domain_values WHERE name = 'riskAnalysis' AND value IN('PL', 'PLSummary', 'PLMerger')
;

DELETE an_viewer_config WHERE analysis_name IN ('PL', 'PLSummary')
;

 
UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('28/03/2008','DD/MM/YYYY')
;
