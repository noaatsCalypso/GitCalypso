
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
  select regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5') into v_uuid from dual;
  return v_uuid;
end random_uuid;
/

/*  Risk factor migration */
/*  Using all the existing risk factor to create the calculation set */
INSERT INTO cm_calculation_set (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, name, official)
SELECT lower(RANDOM_UUID()), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
pricing_env, 0
FROM cm_rf_trade where pricing_env is not null
GROUP BY pricing_env 
;
INSERT INTO cm_calculation_set (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, name, official)
SELECT lower(RANDOM_UUID()), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
pricing_env, 0
FROM cm_rf_trade_hist where pricing_env is not null and pricing_env not in (select pricing_env from cm_rf_trade) 
GROUP BY pricing_env 
;

drop function random_uuid
;
/

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
/* Add calculation_set on the risk_factor table based on the pricing_env name the risk factor is linked to*/
UPDATE cm_rf_trade
SET calculation_set_id =
  (SELECT id FROM cm_calculation_set WHERE name = pricing_env
  )
;
UPDATE cm_rf_trade
SET calculation_set_id = '00000000-0000-0000-0000-000000000000'
where pricing_env is null
;
/* Add calculation_set on the risk_factor table based on the pricing_env name the risk factor is linked to*/
UPDATE cm_rf_trade_hist
SET calculation_set_id =
  (SELECT id FROM cm_calculation_set WHERE name = pricing_env
  )
;
UPDATE cm_rf_trade_hist
SET calculation_set_id = '00000000-0000-0000-0000-000000000000'
where pricing_env is null
;
/* don't migrate rf_status table or calculation request. We should retrigger calculation in case we need the info*/
DECLARE
    vCount INTEGER;
BEGIN
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_rf_trade_post_reg' and lower(C.CONSTRAINT_NAME) = 'fk_post_rf_id';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_rf_trade_post_reg drop constraint fk_post_rf_id';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_rf_trade_collect_reg' and lower(C.CONSTRAINT_NAME) = 'fk_collect_rf_id';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_rf_trade_collect_reg drop constraint fk_collect_rf_id';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_rf_what_if_post_reg' and lower(C.CONSTRAINT_NAME) = 'fk_what_if_post_rf_id';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_rf_what_if_post_reg drop constraint fk_what_if_post_rf_id';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_rf_what_if_collect_reg' and lower(C.CONSTRAINT_NAME) = 'fk_what_if_collect_rf_id';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_rf_what_if_collect_reg drop constraint fk_what_if_collect_rf_id';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_rf_what_if' and lower(C.CONSTRAINT_NAME) = 'fk_rf_what_if_request';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_rf_what_if drop constraint fk_rf_what_if_request';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_simm_what_if_req2calc' and lower(C.CONSTRAINT_NAME) = 'fk_simm_what_if_calc';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_simm_what_if_req2calc drop constraint fk_simm_what_if_calc';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_simm_what_if_req2calc' and lower(C.CONSTRAINT_NAME) = 'fk_simm_what_if_req';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_simm_what_if_req2calc drop constraint fk_simm_what_if_req';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_simm_what_if_request_errors' and lower(C.CONSTRAINT_NAME) = 'fk_cm_simm_what_if_request';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_simm_what_if_request_errors drop constraint fk_cm_simm_what_if_request';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_simm_calc_request_errors' and lower(C.CONSTRAINT_NAME) = 'fk_cm_simm_calc_request';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_simm_calc_request_errors drop constraint fk_cm_simm_calc_request';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_rf_status_errors' and lower(C.CONSTRAINT_NAME) = 'fk_cm_rf_status';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_rf_status_errors drop constraint fk_cm_rf_status';
    END IF;
END;
/
TRUNCATE TABLE cm_rf_status
;
TRUNCATE TABLE cm_rf_status_hist
;
TRUNCATE TABLE cm_simm_calc_request
;
TRUNCATE TABLE cm_simm_calc_request_hist
;
TRUNCATE TABLE cm_simm_calc_request_errors
;
