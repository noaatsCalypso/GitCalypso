/* Risk factor migration*/
/* Using all the existing risk factor to create the calculation set */
INSERT INTO cm_calculation_set (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, name, official)
SELECT lower(newid(1)), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', datediff(ms,convert(bigdatetime,'19700101',106), convert(varchar,getdate(),106)),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', datediff(ms,convert(bigdatetime,'19700101',106), convert(varchar,getdate(),106)),
pricing_env, 0
FROM cm_rf_trade where pricing_env is not null
GROUP BY pricing_env
go 
INSERT INTO cm_calculation_set (id, tenant_id, version, creation_user, creation_user_type, creation_date, last_update_user, last_update_user_type, last_update_date, name, official)
SELECT lower(newid(1)), 0, 0, '00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', datediff(ms,convert(bigdatetime,'19700101',106), convert(varchar,getdate(),106)),'00000000-0000-0000-0000-000000000000', 'urn:calypso:cloud:platform:iam:model:User', datediff(ms,convert(bigdatetime,'19700101',106), convert(varchar,getdate(),106)),
pricing_env, 0
FROM cm_rf_trade_hist where pricing_env is not null and pricing_env not in (select pricing_env from cm_rf_trade)
GROUP BY pricing_env
go 
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
go 
/* Add calculation_set on the risk_factor table based on the pricing_env name the risk factor is linked to*/
UPDATE cm_rf_trade
SET calculation_set_id =
  (SELECT id FROM cm_calculation_set WHERE name = pricing_env
  )
go 
/* Add calculation_set on the risk_factor table based on the pricing_env name the risk factor is linked to*/
UPDATE cm_rf_trade_hist
SET calculation_set_id =
  (SELECT id FROM cm_calculation_set WHERE name = pricing_env
  )
go
/* don't migrate rf_status table or calculation request. We should retrigger calculation in case we need the info*/
TRUNCATE TABLE cm_rf_status
go
TRUNCATE TABLE cm_rf_status_hist
go
TRUNCATE TABLE cm_simm_calc_request
go
TRUNCATE TABLE cm_simm_calc_request_hist
go
