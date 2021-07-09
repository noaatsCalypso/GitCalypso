update quartz_sched_task_attr set attr_name = 'Save Results' where attr_name = 'Save Results ? ' and exists (select NULL from quartz_sched_task st where st.task_id = quartz_sched_task_attr.task_id and st.task_type = 'ERS_ANALYSIS')
go
