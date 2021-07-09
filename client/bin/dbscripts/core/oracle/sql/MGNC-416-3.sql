update margin_vm_definition set additional_column_index = -1, name = 'CVM', measure_name = 'CVM' where name in ('COLLATERIZED_VM')
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('NOTIONAL','DEFAULT',6,'','NOTIONAL',1,1,1)
;
update pricer_measure set measure_name = 'CVM' where measure_name = 'COLLATERIZED_VM'
;
update quartz_sched_task_attr set attr_value = regexp_replace(attr_value,'^(.*)COLLATERIZED_VM(.*)','\1CVM\2') where task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_OTC_VM_CALCULATOR') 
	and attr_name = 'VM Measures' 
;

