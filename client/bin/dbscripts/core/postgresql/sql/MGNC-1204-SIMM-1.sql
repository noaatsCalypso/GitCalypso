CREATE OR REPLACE FUNCTION current_time_since_epoch()
	RETURNS bigint
	LANGUAGE 'plpgsql' AS $$
    DECLARE   
		n_current_time bigint;
BEGIN
  select extract(epoch from statement_timestamp())*1000 into n_current_time;
  return n_current_time;
END
$$
;

INSERT INTO cm_calculation_set (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, name, official)
SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
pricing_env, 0
FROM cm_rf_trade where pricing_env is not null
GROUP BY pricing_env 
;
INSERT INTO cm_calculation_set (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, name, official)
SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', CURRENT_TIME_SINCE_EPOCH(),
pricing_env, 0
FROM cm_rf_trade_hist where pricing_env is not null and pricing_env not in (select pricing_env from cm_rf_trade) 
GROUP BY pricing_env 
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
/* Add calculation_set on the risk_factor table based on the pricing_env name the risk factor is linked to*/
UPDATE cm_rf_trade
SET calculation_set_id =
  (SELECT id FROM cm_calculation_set WHERE name = pricing_env
  )
;
/* Add calculation_set on the risk_factor table based on the pricing_env name the risk factor is linked to*/
UPDATE cm_rf_trade_hist
SET calculation_set_id =
  (SELECT id FROM cm_calculation_set WHERE name = pricing_env
  )
;
/* don't migrate rf_status table or calculation request. We should retrigger calculation in case we need the info*/
TRUNCATE TABLE cm_rf_status
;
TRUNCATE TABLE cm_rf_status_hist
;
TRUNCATE TABLE cm_simm_calc_request
;
TRUNCATE TABLE cm_simm_calc_request_hist
;
DROP FUNCTION current_time_since_epoch()
;