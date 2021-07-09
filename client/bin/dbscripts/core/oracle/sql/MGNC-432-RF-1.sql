/* 
  Microservice Risk Factor Migration Script - This script needs to evolve to allow new clients to be able to migrate from the 
  old model MGNC 3.x to the latest microservice model) 
*/
create or replace function current_days_since_input_date(input_date timestamp) return number is
  n_current_days number(38, 0);
begin
  select (to_date(to_char(input_date, 'MM/DD/YYYY'), 'MM/DD/YYYY') - to_date('19700101', 'YYYYMMDD')) into n_current_days from dual;
  return n_current_days;
end current_days_since_input_date;
/


create or replace function current_time_since_epoch return number is
  n_current_time number(38, 0);
begin
  select (to_date(to_char(sysdate, 'MM/DD/YYYY HH24:MI:SS'), 'MM/DD/YYYY HH24:MI:SS') - to_date('19700101', 'YYYYMMDD')) * 24 * 60 * 60 * 1000 into n_current_time from dual;
  return n_current_time;
end current_time_since_epoch;
/

create or replace function random_uuid return VARCHAR2 is
  v_uuid VARCHAR2(40);
begin
  select lower(regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5')) into v_uuid from dual;
  return v_uuid;
end random_uuid;
/
/* 
   Create one calculation set for each pricing env in the system 
*/
INSERT INTO cm_calculation_set (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, name, official)
SELECT RANDOM_UUID(), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
pricing_env_name, 0
FROM pricing_env 
;
/* 
   Create Source for margin-sensitivities 
*/
INSERT INTO cm_rf_source (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, source)
select  RANDOM_UUID(), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
(CASE source WHEN 'CALCULATE' THEN 'Calypso' ELSE source END) from margin_trade_sensitivity group by source 
;
/* 
   Create risk factors  
*/
INSERT INTO cm_rf_trade (id, tenant_id, version, calculation_set_id, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, trade_id, trade_sub_id, valuation_date,  party_id, counterparty_id, account_id, im_model, risk_type, product_class, qualifier, bucket, label1, label2, currency, amount, amount_base, source, pricing_env, uti, end_date)
select  RANDOM_UUID(), 0, 0, nvl(cm_calculation_set.id, '00000000-0000-0000-0000-000000000000'), nvl(collect_regulations,' ') , nvl(post_regulations, ' '), CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(), 
trade_id, trade_sub_id, current_days_since_input_date(from_tz( cast(margin_trade_sensitivity.valuation_date as timestamp),'GMT') at time zone (SELECT nvl(time_zone, (SELECT DBTIMEZONE FROM DUAL)) s FROM pricing_env where pricing_env_name = pricing_env)), party_id, cp_id, cm_account.id, im_model, risk_type, product_class, qualifier, bucket, label1, label2, amount_ccy, amount, amount_base, 
(CASE source WHEN 'CALCULATE' THEN 'Calypso' ELSE source END), pricing_env, uti, end_date 
from cm_account, margin_trade_sensitivity left join cm_calculation_set on pricing_env = cm_calculation_set.name
where margin_trade_sensitivity.margin_agreement_name = cm_account.name  
;
INSERT INTO cm_rf_trade_collect_reg(rf_id, collect_regulators)
select t.id, regexp_substr(t.creation_user, '[^,]+', 1, commas1.column_value)  as regulator from cm_rf_trade t, table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.creation_user, '[^,]+'))  + 1) as sys.OdciNumberList)) commas1 where regexp_substr(t.creation_user, '[^,]+', 1, commas1.column_value) is not NULL
;
INSERT INTO cm_rf_trade_post_reg (rf_id, post_regulators)
select t.id, regexp_substr(t.creation_user_type, '[^,]+', 1, commas.column_value)  as regulator from cm_rf_trade t, table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.creation_user_type, '[^,]+'))  + 1) as sys.OdciNumberList)) commas where regexp_substr(t.creation_user_type, '[^,]+', 1, commas.column_value) is not NULL
;
update cm_rf_trade set creation_user = '00000000-0000-0000-0000-000000000000', creation_user_type = 'urn:calypso:cloud:platform:iam:model:User'
;
/* 
   Create risk factors status 
*/
INSERT INTO cm_rf_status (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, source, status, import_date, calculation_set_id)
select  RANDOM_UUID(), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
source, 'Imported', valuation_date, calculation_set_id from cm_rf_trade group by source, valuation_date, calculation_set_id
;
/*    
 Create historical risk factors  
*/
INSERT INTO cm_rf_trade_hist (id, tenant_id, version, calculation_set_id, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, trade_id, trade_sub_id, valuation_date,  party_id, counterparty_id, account_id, im_model, risk_type, product_class, qualifier, bucket, label1, label2, currency, amount, amount_base, source, pricing_env, uti, end_date)
select  RANDOM_UUID(), 0, 0, nvl(cm_calculation_set.id, '00000000-0000-0000-0000-000000000000'), nvl(collect_regulations,' ') , nvl(post_regulations, ' '), CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(), 
trade_id, trade_sub_id, current_days_since_input_date(from_tz( cast(margin_trade_sensitivity_hist.valuation_date as timestamp),'GMT') at time zone (SELECT nvl(time_zone, (SELECT DBTIMEZONE FROM DUAL)) s FROM pricing_env where pricing_env_name = pricing_env)), party_id, cp_id, cm_account.id, im_model, risk_type, product_class, qualifier, bucket, label1, label2, amount_ccy, amount, amount_base, 
(CASE source WHEN 'CALCULATE' THEN 'Calypso' ELSE source END), pricing_env, uti, end_date 
from cm_account, margin_trade_sensitivity_hist left join cm_calculation_set on pricing_env = cm_calculation_set.name 
where margin_trade_sensitivity_hist.margin_agreement_name = cm_account.name and margin_trade_sensitivity_hist.pricing_env = cm_calculation_set.name
;
INSERT INTO cm_rf_trade_collect_reg_hist(rf_id, collect_regulators)
select t.id, regexp_substr(t.creation_user, '[^,]+', 1, commas1.column_value)  as regulator from cm_rf_trade_hist t, table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.creation_user, '[^,]+'))  + 1) as sys.OdciNumberList)) commas1 where regexp_substr(t.creation_user, '[^,]+', 1, commas1.column_value) is not NULL
;
INSERT INTO cm_rf_trade_post_reg_hist (rf_id, post_regulators)
select t.id, regexp_substr(t.creation_user_type, '[^,]+', 1, commas.column_value)  as regulator from cm_rf_trade_hist t, table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.creation_user_type, '[^,]+'))  + 1) as sys.OdciNumberList)) commas where regexp_substr(t.creation_user_type, '[^,]+', 1, commas.column_value) is not NULL
;
update cm_rf_trade_hist set creation_user = '00000000-0000-0000-0000-000000000000', creation_user_type = 'urn:calypso:cloud:platform:iam:model:User'
;

/* Create official flag based of Generate Exposure Trade of the Scheduled Task MARGIN_CALCULATOR*/
UPDATE cm_calculation_set
SET official = 1
WHERE name  IN
  (SELECT DISTINCT pricing_env
  FROM quartz_sched_task
  WHERE task_id IN
    (SELECT task_id FROM quartz_sched_task WHERE task_type = 'MARGIN_CALCULATOR'
    )
  AND task_id IN
    (SELECT task_id
    FROM quartz_sched_task_attr
    WHERE attr_name = 'Generate Exposure Trades'
    AND lower(attr_value)  = 'true'
    )
  ) 
;
/* Create new Calculation Set attribute derived from calculationSetName = pricingEnv  */
INSERT INTO quartz_sched_task_attr
  (task_id, attr_name, attr_value
  )
SELECT task_id,
  'Calculation Set Id',
  (SELECT id
  FROM cm_calculation_set
  WHERE name = quartz_sched_task.pricing_env
  )
FROM quartz_sched_task
WHERE task_type IN ('MARGIN_CALCULATOR','MARGIN_INPUT') 
;
drop function random_uuid
;
drop function current_time_since_epoch
;
