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
go