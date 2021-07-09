update quartz_sched_task_attr sta set attr_name = 'Save Results' where sta.attr_name = 'Save Results ? ' and exists (select NULL from quartz_sched_task st where st.task_id = sta.task_id and st.task_type = 'ERS_ANALYSIS')
;
