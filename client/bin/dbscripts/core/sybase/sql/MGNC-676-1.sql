update quartz_sched_task_attr set attr_value = 'TYPEF' where task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_OTC_CALCULATOR') and attr_name = 'Methodology' and attr_value = 'HKEX'
go


