update quartz_sched_task_attr set attr_value = 'IMPORT ACCOUNTS'
where task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_INPUT') 
and attr_name = 'Mode' and attr_value = 'IMPORT'
and task_id in (select task_id from quartz_sched_task_attr where attr_name = 'Risk Type Filter' and CHARINDEX('Risk_', attr_value ) = 0 )
go
update quartz_sched_task_attr set attr_value = 'IMPORT RISK FACTORS'
where task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_INPUT') 
and attr_name = 'Mode' and attr_value = 'IMPORT'
and task_id in (select task_id from quartz_sched_task_attr where attr_name = 'Risk Type Filter' and CHARINDEX('Risk_', attr_value ) = 0)
go
