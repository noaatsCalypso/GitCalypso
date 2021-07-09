/* Migration script From the first MS Account Model to the second MS Account Model - Only execute if the tables are empty. */
/* This is the conversion used for clients between 16.1.0.26 and 16.1.0.33 */
/* Migration for clients from a 3.x or a 4.x version is done in a MGNC-432 scripts */
/* Create the regulators from regulator parameters*/
DECLARE
    vCount INTEGER;
BEGIN
    SELECT COUNT(*) INTO vCount FROM cm_simm_regulator;
    IF (vCount = 0) THEN
        -- Regulator names source from the previous cm_simm_regulator_parameters, taking those without account
        EXECUTE IMMEDIATE 'INSERT INTO cm_simm_regulator (id, tenant_id, version, creation_date, creation_user,
          creation_user_type, last_update_date, last_update_user, last_update_user_type, name)
          (SELECT p.id, p.tenant_id, p.version, p.creation_date, p.creation_user, p.creation_user_type,
          p.last_update_date, p.last_update_user, p.last_update_user_type, p.regulator
          FROM cm_simm_regulator_parameters p
          WHERE p.simmmarginaccount_id is null)';
    END IF;
END;
/

create or replace function random_uuid return VARCHAR2 is
  v_uuid VARCHAR2(40);
begin
  select lower(regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5')) into v_uuid from dual;
  return v_uuid;
end random_uuid;
/


/* Add post/collect currencies to simm accounts and csa detail with CSA_IN_PLACE status */
/* Before 16.1.0.33, MGNC 5.8.x, asymetric accounts were not supported, */
/* Before 16.1.0.33, MGNC 5.8.x, all accounts are assumed to be official accounts, not PreCsa */
DECLARE
    vCount INTEGER;
BEGIN
    SELECT COUNT(*) INTO vCount FROM cm_simm_account;
    IF (vCount = 0) THEN
    	EXECUTE IMMEDIATE 'INSERT INTO cm_simm_account (id, active_from, active_to) (SELECT s.id, s.active_from, s.active_to from cm_simm_accounts s, cm_account a where s.id= a.accountdetails_id)';
        EXECUTE IMMEDIATE 'UPDATE cm_simm_account s SET post_currency = (SELECT a.currency FROM cm_account a WHERE a.accountdetails_id = s.id), collect_currency = (SELECT a.currency FROM cm_account a WHERE a.accountdetails_id = s.id), post_threshold = 50000000, collect_threshold = 50000000';
        EXECUTE IMMEDIATE 'UPDATE cm_account SET csadetails_id = random_uuid()';
    	EXECUTE IMMEDIATE 'INSERT INTO cm_csa_account_details(id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, csa_status) (SELECT a.csadetails_id, a.tenant_id, a.version, a.creation_user, a.creation_user_type, a.creation_date, a.last_update_user, a.last_update_user_type, a.last_update_date, ''CSA_IN_PLACE'' from cm_simm_accounts s, cm_account a where s.id= a.accountdetails_id)'; 
    END IF;
END;
/

/* Populate new flat simm params*/
DECLARE
    vCount INTEGER;
BEGIN
    SELECT COUNT(*) INTO vCount FROM cm_flat_simm_param;
    IF (vCount = 0) THEN
		-- Default params (no account)
		EXECUTE IMMEDIATE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT p.id, p.tenant_id, p.version, p.creation_date, p.creation_user, p.creation_user_type,
		  p.last_update_date, p.last_update_user, p.last_update_user_type,
		  rp.regulator, rp.simmmarginaccount_id, null, p.parameter_type, p.value, p.criteria
		  FROM cm_simm_regulator_parameters rp, cm_simm_parameters p
		  WHERE rp.id = p.regulatorparameter_id and rp.simmmarginaccount_id is null)';
		  
		--Post/Collect regulators, augmenting their meta from the account details
		EXECUTE IMMEDIATE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid() id, s.tenant_id, s.version,
		  s.creation_date, s.creation_user, s.creation_user_type,
		  s.last_update_date, s.last_update_user, s.last_update_user_type,
		  pr.post_regulators, pr.simmmarginaccount_id, ''Pay'', null, null, null
		  FROM cm_simm_post_regulators pr, cm_account_details s
		  WHERE pr.simmmarginaccount_id = s.id)';
		  
		EXECUTE IMMEDIATE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid() id, s.tenant_id, s.version,
		  s.creation_date, s.creation_user, s.creation_user_type,
		  s.last_update_date, s.last_update_user, s.last_update_user_type,
		  cr.collect_regulators, cr.simmmarginaccount_id, ''Receive'', null, null, null
		  FROM cm_simm_collect_regulators cr, cm_account_details s
		  WHERE cr.simmmarginaccount_id = s.id)'; 
		  
		  
		-- Actual parameters: copy the Post (Pay) param with the same id, and generate a collect one with new id
		EXECUTE IMMEDIATE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT p.id, p.tenant_id, p.version, p.creation_date, p.creation_user, p.creation_user_type,
		  p.last_update_date, p.last_update_user, p.last_update_user_type,
		  rp.regulator, rp.simmmarginaccount_id, ''Pay'', p.parameter_type, p.value, p.criteria
		  FROM cm_simm_regulator_parameters rp, cm_simm_parameters p
		  WHERE rp.id = p.regulatorparameter_id and rp.simmmarginaccount_id is not null)';
		  
		EXECUTE IMMEDIATE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT random_uuid(), p.tenant_id,
		  p.version, p.creation_date, p.creation_user, p.creation_user_type, p.last_update_date,
		  p.last_update_user, p.last_update_user_type,
		  rp.regulator, rp.simmmarginaccount_id, ''Receive'', p.parameter_type, p.value, p.criteria
		  FROM cm_simm_regulator_parameters rp, cm_simm_parameters p
		  WHERE rp.id = p.regulatorparameter_id and rp.simmmarginaccount_id is not null)';  
		  
		-- Housekeeping: remove unneeded zeros
		EXECUTE IMMEDIATE 'UPDATE cm_flat_simm_param
		  SET value = null
		  WHERE parameter_type IN (''LocalRegSIMM'', ''ScheduleProduct'')';  
    END IF;

END;
/

drop function random_uuid
;
/
