update margin_vm_definition set additional_column_index = -1, name = 'CVM', measure_name = 'CVM' where name in ('COLLATERIZED_VM')
go
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('NOTIONAL','DEFAULT',6,'','NOTIONAL',1,1,1)
go
update pricer_measure set measure_name = 'CVM' where measure_name = 'COLLATERIZED_VM'
go
update quartz_sched_task_attr set attr_value = 'CVM,VM,NPV,NPV_ADJ,VM_CASH' where task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_OTC_VM_CALCULATOR') and attr_name = 'VM Measures' 
go
