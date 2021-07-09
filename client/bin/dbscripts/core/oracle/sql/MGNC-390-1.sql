INSERT INTO margin_vm_definition (name,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV',-1,'','NPV',1,1)
;
INSERT INTO margin_vm_definition (name,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM',-1,'','VM',1,1)
;
INSERT INTO margin_vm_definition (name,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM_CASH',-1,'','VM_CASH',1,1)
;
INSERT INTO margin_vm_definition (name,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV_ADJ',-1,'','NPV_ADJ',1,1)
;
INSERT INTO margin_vm_definition (name,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('PAI',-1,'','PAI',0,0)
;
INSERT INTO margin_vm_definition (name,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM_EXPOSURE',-1,'','VM_EXPOSURE',0,1)
;
INSERT INTO margin_vm_definition (name,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('FUNDING_RATE',1,'','PAI_FUNDING_RATE',0,0)
;
DELETE pricer_measure where measure_name in ('VM','VM_CASH','VM_EXPOSURE','NPV_ADJ','FUNDING_RATE','PAI') 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('NPV_ADJ','margin.vm.pricer.PricerMeasureVariationMargin', 1500) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_CASH','margin.vm.pricer.PricerMeasureVariationMargin', 1501) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM','margin.vm.pricer.PricerMeasureVariationMargin', 1502) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_EXPOSURE','margin.vm.pricer.PricerMeasureVariationMargin', 1503) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('PAI','margin.vm.pricer.PricerMeasureVariationMargin', 1504) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('PAI_FUNDING_RATE','margin.vm.pricer.PricerMeasureVariationMargin', 1505) 
;
