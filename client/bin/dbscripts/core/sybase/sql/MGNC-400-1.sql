update quartz_sched_task set task_type = 'MARGIN_OTC_VM_CALCULATOR' where task_type = 'MARGIN_VM_CALCULATOR'
go
update quartz_sched_task_exec set task_type = 'MARGIN_OTC_VM_CALCULATOR' where task_type = 'MARGIN_VM_CALCULATOR'
go
update domain_values set value = 'MARGIN_OTC_VM_CALCULATOR_ST_ID' where name = 'MarginEngine' and value = 'MARGIN_VM_CALCULATOR_ST_ID'
go
