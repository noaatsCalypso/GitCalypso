INSERT INTO quartz_sched_task_attr (
    task_id,
    attr_name,
    attr_value,
    value_order
)
    SELECT
        task_id,
        'Calculation Set',
        'Default',
        0
    FROM
        quartz_sched_task
    WHERE
        task_type = 'MARGIN_OTC_CALCULATOR'
;
