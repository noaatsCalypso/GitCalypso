DO $$
    DECLARE
        vCount integer;
    BEGIN
        select count(*) into vCount from cm_simm_regulator;
		
		IF (vCount = 0) THEN
			EXECUTE 'INSERT INTO cm_simm_regulator (id, tenant_id, version, creation_date, creation_user,
			creation_user_type, last_update_date, last_update_user, last_update_user_type, name)
			(SELECT p.id, p.tenant_id, p.version, p.creation_date, p.creation_user, p.creation_user_type,
			p.last_update_date, p.last_update_user, p.last_update_user_type, p.regulator
			FROM cm_simm_regulator_parameters p
			WHERE p.simmmarginaccount_id is null)';
		END IF;
    END
$$
;

DO $$
    DECLARE
        vCount integer;
    BEGIN
        select count(*) into vCount from cm_simm_accounts;
		
		IF (vCount = 0) THEN
			EXECUTE 'INSERT INTO cm_simm_account (id, active_from, active_to) (SELECT s.id, s.active_from, s.active_to from cm_simm_accounts s, cm_account a where s.id= a.accountdetails_id)';
			EXECUTE 'UPDATE cm_simm_account s SET post_currency = (SELECT a.currency FROM cm_account a WHERE a.accountdetails_id = s.id), collect_currency = (SELECT a.currency FROM cm_account a WHERE a.accountdetails_id = s.id), post_threshold = 50000000, collect_threshold = 50000000';
	        EXECUTE 'UPDATE cm_account SET csadetails_id = uuid_in(md5(random()::text || clock_timestamp()::text)::cstring)';
	    	EXECUTE 'INSERT INTO cm_csa_account_details(id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, csa_status) (SELECT a.csadetails_id, a.tenant_id, a.version, a.creation_user, a.creation_user_type, a.creation_date, a.last_update_user, a.last_update_user_type, a.last_update_date, ''CSA_IN_PLACE'' from cm_simm_accounts s, cm_account a where s.id= a.accountdetails_id)'; 
        END IF;
    END
$$
;

DO $$
    DECLARE
        vCount integer;
    BEGIN
        select count(*) into vCount from cm_flat_simm_param;
		
	IF (vCount = 0) THEN
		EXECUTE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT p.id, p.tenant_id, p.version, p.creation_date, p.creation_user, p.creation_user_type,
		  p.last_update_date, p.last_update_user, p.last_update_user_type,
		  rp.regulator, rp.simmmarginaccount_id, null, p.parameter_type, p.value, p.criteria
		  FROM cm_simm_regulator_parameters rp, cm_simm_parameters p
		  WHERE rp.id = p.regulatorparameter_id and rp.simmmarginaccount_id is null)';

		EXECUTE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
		  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
		  accountdetails_id, direction, parameter_type, value, criteria)
		  (SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) id, s.tenant_id,
		  s.version,
		  s.creation_date, s.creation_user, s.creation_user_type,
		  s.last_update_date, s.last_update_user, s.last_update_user_type,
		  pr.post_regulators, pr.simmmarginaccount_id, 'Pay', null, null, null
		  FROM cm_simm_post_regulators pr, cm_account_details s
		  WHERE pr.simmmarginaccount_id = s.id)';

		EXECUTE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
			  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
			  accountdetails_id, direction, parameter_type, value, criteria)
			  (SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) id, s.tenant_id,
			  s.version,
			  s.creation_date, s.creation_user, s.creation_user_type,
			  s.last_update_date, s.last_update_user, s.last_update_user_type,
			  cr.collect_regulators, cr.simmmarginaccount_id, 'Receive', null, null, null
			  FROM cm_simm_collect_regulators cr, cm_account_details s
			  WHERE cr.simmmarginaccount_id = s.id)';

		EXECUTE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
			  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
			  accountdetails_id, direction, parameter_type, value, criteria)
			  (SELECT p.id, p.tenant_id, p.version, p.creation_date, p.creation_user, p.creation_user_type,
			  p.last_update_date, p.last_update_user, p.last_update_user_type,
			  rp.regulator, rp.simmmarginaccount_id, 'Pay', p.parameter_type, p.value, p.criteria
			  FROM cm_simm_regulator_parameters rp, cm_simm_parameters p
			  WHERE rp.id = p.regulatorparameter_id and rp.simmmarginaccount_id is not null)';

		EXECUTE 'INSERT INTO cm_flat_simm_param (id, tenant_id, version, creation_date, creation_user,
			  creation_user_type, last_update_date, last_update_user, last_update_user_type, regulator,
			  accountdetails_id, direction, parameter_type, value, criteria)
			  (SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring), p.tenant_id,
			  p.version, p.creation_date, p.creation_user, p.creation_user_type, p.last_update_date,
			  p.last_update_user, p.last_update_user_type,
			  rp.regulator, rp.simmmarginaccount_id, 'Receive', p.parameter_type, p.value, p.criteria
			  FROM cm_simm_regulator_parameters rp, cm_simm_parameters p
			  WHERE rp.id = p.regulatorparameter_id and rp.simmmarginaccount_id is not null)';

		EXECUTE 'UPDATE cm_flat_simm_param
			  SET value = null
			  WHERE parameter_type IN ('LocalRegSIMM', 'ScheduleProduct')';
			  
        END IF;
    END
$$
;


