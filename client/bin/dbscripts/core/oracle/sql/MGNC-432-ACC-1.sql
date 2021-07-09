/* 
  Microservice Account Migration Script - This script needs to evolve to allow new clients to be able to migrate from the 
  old model MGNC 3.x to the latest microservice model)
   
*/

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
  Create cm_missing_account. This table will contain the currency, the csa status and threshold
*/
create table cm_missing_account 
 AS (select margin_agreement_name name, CAST('PRE_CSA' AS VARCHAR2(64)) csa_status, (CASE WHEN margin_regulator.post_currency is null THEN 'XXX' ELSE margin_regulator.post_currency END) currency, 
  (CASE WHEN margin_regulator.post_currency is null THEN 'XXX' ELSE margin_regulator.post_currency END) post_currency, 
  (CASE WHEN margin_regulator.collect_currency is null THEN 'XXX' ELSE margin_regulator.collect_currency  END) collect_currency,   50000000 post_threshold, 50000000 collect_threshold 
  from margin_regulator
  where margin_agreement_name not in (select name from cm_account)
  and (active_to is null or active_to > CURRENT_DATE) and source = 'INTERNAL')
;
/* 
 Create a Mapping between account and currency
 First - use sensitivities pricing to extract the pe base currency - These account are considered CSA_IN_PLACE
*/
create table cm_account_ref as 
select ms.margin_agreement_name name, pe.base_currency currency, CAST('CSA_IN_PLACE' AS VARCHAR2(64)) csa_status
from
(select margin_agreement_name, pricing_env, row_number() over(partition  by margin_agreement_name order by valuation_date desc) as rn  from margin_sensitivity)  ms, pricing_env pe
where ms.rn = 1 and pe.pricing_env_name = ms.pricing_env 
;
/* 
 Add extra record to the mapping table
 Second - use a custom IM_PRICING_ENV attribute of the Collateral Contract 
*/
insert into cm_account_ref(name, currency, csa_status) 
(select ma.name, pe.base_currency, case when regexp_like(im_name.mcc_value, '_PHASE[0-9]+_') 
									then 'PRE_CSA'
									else 'CSA_IN_PLACE'
								   end
	from pricing_env pe, collateral_config_field ccf, cm_missing_account ma, collateral_config_field im_name
	where ccf.mcc_id in (select mcc_id from collateral_config_field where mcc_field = 'IM_PORTFOLIO_NAME' and regexp_replace(mcc_value, '_PHASE[0-9]+_', '_') = ma.name
	and ma.name not in (select name from cm_account_ref))
	and im_name.mcc_id = ccf.mcc_id
	and im_name.mcc_field = 'IM_PORTFOLIO_NAME'
	and pe.pricing_env_name = ccf.mcc_value
	and ccf.mcc_field = 'IM_PRICING_ENV')

;
/* 
  Now update the currency, post_currency, collect_currency of the cm_missing_account table from the cm_account_ref
*/
update cm_missing_account 
set currency = (select currency from cm_account_ref where cm_account_ref.name = cm_missing_account.name)
where currency = 'XXX' and cm_missing_account.name in (select name from cm_account_ref)
;
update cm_missing_account set post_currency = currency, collect_currency = currency 
where post_currency = 'XXX'
;
/* 
  Now update the csa_status of the cm_missing_account table from the cm_account_ref
*/
update cm_missing_account 
set csa_status = (select csa_status from cm_account_ref where cm_account_ref.name = cm_missing_account.name)
where cm_missing_account.name in (select name from cm_account_ref)
;
/* 
  Create cm_account for accounts which where not migrated yet. Picked up the Margin Currency from the Pricing Env Base ccy of the IM_PRICING_ENV Addiitonal Info of the Contract with IM_PORTFOLIO_NAME attribute
  equal to the margin_agreement_name
*/
insert into cm_account (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, 
                        name, currency, methodology, accountdetails_id, csadetails_id, calculator_type)
select RANDOM_UUID(), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(), 
       cm_missing_account.name, cm_missing_account.currency, 'SIMM', RANDOM_UUID(), RANDOM_UUID(), null 
from cm_missing_account
;
/* Create cm_account_details for newly created accounts */
insert into cm_account_details (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date)
(select accountdetails_id, 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH() 
 from cm_account a, cm_missing_account ma 
 where  ma.name = a.name and accountdetails_id not in (select id from cm_account_details))
;
/* Create cm_simm_account for newly created accounts */
INSERT INTO cm_simm_account (id, post_currency, collect_currency, post_threshold, collect_threshold)
(select accountdetails_id, ma.post_currency, ma.collect_currency, ma.post_threshold, ma.collect_threshold
 from cm_account a, cm_missing_account ma 
 where ma.name = a.name and accountdetails_id not in (select id from cm_simm_account))
;
 
/* Create cm_csa_account_details for newly created accounts */
INSERT INTO cm_csa_account_details(id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, csa_status) 
(SELECT a.csadetails_id, a.tenant_id, a.version, a.creation_user, a.creation_user_type, a.creation_date, a.last_update_user, a.last_update_user_type, a.last_update_date, ma.csa_status
 from cm_simm_account s, cm_account a, cm_missing_account ma 
 where s.id=a.accountdetails_id  and ma.name = a.name and a.csadetails_id not in (select id from cm_csa_account_details))
;

/* Create Post/Collect regulators, augmenting their meta from the account details*/ 
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid() id, cm.tenant_id, cm.version,
		  cm.creation_date, cm.creation_user, cm.creation_user_type,
		  cm.last_update_date, cm.last_update_user, cm.last_update_user_type,
		  regexp_substr(mr.post_regulations, '[^,]+', 1, commas.column_value), cm.accountdetails_id, 'Pay', null, null, null
		  from margin_regulator mr, cm_account cm, table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(mr.post_regulations, '[^,]+'))  + 1) as sys.OdciNumberList)) commas 
		  where mr.margin_agreement_name = cm.name and (mr.active_to is null or mr.active_to > CURRENT_DATE) and source = 'INTERNAL' and post_regulations is not null
		  and cm.name in (select name from cm_missing_account))
;
		  
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid() id, cm.tenant_id, cm.version,
		  cm.creation_date, cm.creation_user, cm.creation_user_type,
		  cm.last_update_date, cm.last_update_user, cm.last_update_user_type,
		  regexp_substr(mr.collect_regulations, '[^,]+', 1, commas.column_value), cm.accountdetails_id, 'Receive', null, null, null
		  from margin_regulator mr, cm_account cm, table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(mr.collect_regulations, '[^,]+'))  + 1) as sys.OdciNumberList)) commas 
		  where mr.margin_agreement_name = cm.name and (mr.active_to is null or mr.active_to > CURRENT_DATE) and source = 'INTERNAL' and collect_regulations is not null
		  and cm.name in (select name from cm_missing_account))
; 
		  

/* Actual parameters: Notional Factors */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid() id, cm.tenant_id, cm.version,
		  cm.creation_date, cm.creation_user, cm.creation_user_type,
		  cm.last_update_date, cm.last_update_user, cm.last_update_user_type,
		  p.regulator, cm.accountdetails_id, (CASE p.direction WHEN 'PAY' THEN 'Pay' ELSE 'Receive' END), 'NotionalFactor', p.factor, p.isda_product
		  from margin_regulator_addon p, cm_account cm 
		  where p.margin_agreement_name = cm.name and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  and cm.name in (select name from cm_missing_account))
;
		  

/* Actual parameters: Fixed Amount */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid() id, cm.tenant_id, cm.version,
		  cm.creation_date, cm.creation_user, cm.creation_user_type,
		  cm.last_update_date, cm.last_update_user, cm.last_update_user_type,
		  p.regulator, cm.accountdetails_id, (CASE p.direction WHEN 'PAY' THEN 'Pay' ELSE 'Receive' END), 'FixedAmount', p.fixed_amount, p.currency
		  from margin_regulator_fixed_amount p, cm_account cm 
		  where p.margin_agreement_name = cm.name and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  and cm.name in (select name from cm_missing_account))
;
/* Actual parameters: Fixed Multiplier */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid() id, cm.tenant_id, cm.version,
		  cm.creation_date, cm.creation_user, cm.creation_user_type,
		  cm.last_update_date, cm.last_update_user, cm.last_update_user_type,
		  p.regulator, cm.accountdetails_id, (CASE p.direction WHEN 'PAY' THEN 'Pay' ELSE 'Receive' END), 'Multiplier', p.multiplier, p.product_class
		  from margin_regulator_multiplier p, cm_account cm 
		  where p.margin_agreement_name = cm.name and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  and cm.name in (select name from cm_missing_account))
;
/* Actual parameters: Schedule */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, criteria)
		  (SELECT random_uuid() id, cm.tenant_id, cm.version,
		  cm.creation_date, cm.creation_user, cm.creation_user_type,
		  cm.last_update_date, cm.last_update_user, cm.last_update_user_type,
		  p.regulator, cm.accountdetails_id, (CASE p.direction WHEN 'PAY' THEN 'Pay' ELSE 'Receive' END), 'ScheduleProduct', p.isda_product
		  from margin_regulator_schedule p, cm_account cm 
		  where p.margin_agreement_name = cm.name and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  and cm.name in (select name from cm_missing_account))
;
/* Actual parameters: LocalReg */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, criteria)
		  (SELECT random_uuid() id, cm.tenant_id, cm.version,
		  cm.creation_date, cm.creation_user, cm.creation_user_type,
		  cm.last_update_date, cm.last_update_user, cm.last_update_user_type,
		  p.regulator, cm.accountdetails_id, (CASE p.direction WHEN 'PAY' THEN 'Pay' ELSE 'Receive' END), 'LocalRegSIMM', p.isda_product
		  from margin_local_simm_regulator p, cm_account cm 
		  where p.margin_agreement_name = cm.name and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  and cm.name in (select name from cm_missing_account))
;
/* Global parameters: Notional Factors */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user, creation_user_type, last_update_date, 
		  last_update_user, last_update_user_type, regulator, accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid(), 0, 0, CURRENT_TIME_SINCE_EPOCH(), '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
		  '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', p.regulator, null, null, 'NotionalFactor', p.factor, p.isda_product
		  from margin_regulator_addon p 
		  where p.margin_agreement_name is null and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  )
;
/* Global parameters: Fixed Amount */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid(), 0, 0, CURRENT_TIME_SINCE_EPOCH(), '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
		  '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', 
		  p.regulator, null, null, 'FixedAmount', p.fixed_amount, p.currency
		  from margin_regulator_fixed_amount p
		  where p.margin_agreement_name is null and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  )
;
/* Global parameters: Fixed Multiplier */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid(), 0, 0, CURRENT_TIME_SINCE_EPOCH(), '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
		  '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', 
		  p.regulator, null, null, 'Multiplier', p.multiplier, p.product_class
		  from margin_regulator_multiplier p
		  where p.margin_agreement_name is null and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  )
;
/* Global parameters: Schedule */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, criteria)
		  (SELECT random_uuid(), 0, 0, CURRENT_TIME_SINCE_EPOCH(), '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
		  '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', 
		  p.regulator, null, null, 'ScheduleProduct', p.isda_product
		  from margin_regulator_schedule p
		  where p.margin_agreement_name is null and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  )
;
/* Global parameters: LocalReg */
INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, criteria)
		  (SELECT random_uuid(), 0, 0, CURRENT_TIME_SINCE_EPOCH(), '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
		  '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', 
		  p.regulator, null, null, 'LocalRegSIMM', p.isda_product
		  from margin_local_simm_regulator p
		  where p.margin_agreement_name is null and (p.active_to is null or p.active_to > CURRENT_DATE) and source = 'INTERNAL' 
		  )
;		  
/* Global parameters: Keep only one per regulator, parameter_type and criteria */
DELETE from cm_flat_simm_param
WHERE rowid IN
  (SELECT rid
  FROM
    (SELECT rowid rid,
      row_number() over (partition BY regulator, parameter_type, criteria order by regulator) rn
    FROM cm_flat_simm_param
	WHERE accountdetails_id is null
    )
  WHERE rn <> 1
  ) 
;
/* Global parameters: Create the cm_simm_regulator */
INSERT INTO cm_simm_regulator (id, tenant_id, version, creation_date, creation_user,
          creation_user_type, last_update_date, last_update_user, last_update_user_type, name)
          (SELECT random_uuid(), 0, 0, CURRENT_TIME_SINCE_EPOCH(), '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
		  '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', p.regulator
          FROM (select distinct regulator from cm_flat_simm_param where accountdetails_id is null or parameter_type is null) p)
;          
drop table cm_missing_account
;
drop function random_uuid
;
drop function current_time_since_epoch
;
drop table cm_account_ref
;
