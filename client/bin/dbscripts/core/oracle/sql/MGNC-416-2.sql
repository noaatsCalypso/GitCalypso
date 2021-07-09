update margin_vm_definition set flip_sign = 1 where name in ('NPV', 'NPV_ADJ', 'VM_CASH', 'VM', 'VM_EXPOSURE', 'PAI')
;
delete margin_vm_definition where product_type = 'XCCySwap'
;
update margin_vm_definition set leg = 'DEFAULT' where leg is null
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('VM_COUPON','DEFAULT',2,'','VM_COUPON',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('VM_COUPON','PAY',2,'SwapCrossCurrency','VM_COUPON_PAY',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('VM_COUPON','REC',2,'SwapCrossCurrency','VM_COUPON_REC',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('VM_PRINCIPAL','PAY',3,'SwapCrossCurrency','VM_PRINCIPAL_PAY',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('VM_PRINCIPAL','REC',3,'SwapCrossCurrency','VM_PRINCIPAL_REC',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('VM_PRINCIPAL_PRI','DEFAULT',4,'','VM_PRINCIPAL_PRI',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('VM_PRINCIPAL_SEC','DEFAULT',5,'','VM_PRINCIPAL_SEC',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('COLLATERIZED_VM','DEFAULT',6,'','COLLATERIZED_VM',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('PV01','DEFAULT',7,'','PV01',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign) 
	values ('DELTA','DEFAULT',8,'','DELTA',1,1,1)
;
update quartz_sched_task_attr set attr_value = 'COLLATERIZED_VM,VM,NPV,NPV_ADJ,VM_CASH' where task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_OTC_VM_CALCULATOR') and attr_name = 'VM Measures' 
;


