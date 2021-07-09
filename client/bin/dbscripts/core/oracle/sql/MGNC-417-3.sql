DELETE margin_vm_definition where product_type = 'XCCySwap'
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV','PAY',-1,'SwapCrossCurrency','NPV_PAYLEG',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV','REC',-1,'SwapCrossCurrency','NPV_RECLEG',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV_ADJ','PAY',-1,'SwapCrossCurrency','NPV_ADJ_PAY',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV_ADJ','REC',-1,'SwapCrossCurrency','NPV_ADJ_REC',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM_CASH','PAY',-1,'SwapCrossCurrency','VM_CASH_PAY',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM_CASH','REC',-1,'SwapCrossCurrency','VM_CASH_REC',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM','PAY',-1,'SwapCrossCurrency','VM_PAY',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM','REC',-1,'SwapCrossCurrency','VM_REC',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV','NEAR',-1,'FXSwap','NPV_NEAR',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV','FAR',-1,'FXSwap','NPV_FAR',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV_ADJ','NEAR',-1,'FXSwap','NPV_ADJ_NEAR',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('NPV_ADJ','FAR',-1,'FXSwap','NPV_ADJ_FAR',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM_CASH','NEAR',-1,'FXSwap','VM_CASH_NEAR',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM_CASH','FAR',-1,'FXSwap','VM_CASH_FAR',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM','NEAR',-1,'FXSwap','VM_NEAR',1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative) 
	values ('VM','FAR',-1,'FXSwap','VM_FAR',1,1)
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('NPV_ADJ_PAY','margin.vm.pricer.PricerMeasureVariationMargin', 1506) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_CASH_PAY','margin.vm.pricer.PricerMeasureVariationMargin', 1507) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_PAY','margin.vm.pricer.PricerMeasureVariationMargin', 1508) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('NPV_ADJ_REC','margin.vm.pricer.PricerMeasureVariationMargin', 1509) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_CASH_REC','margin.vm.pricer.PricerMeasureVariationMargin', 1510) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_REC','margin.vm.pricer.PricerMeasureVariationMargin', 1511) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('NPV_ADJ_NEAR','margin.vm.pricer.PricerMeasureVariationMargin', 1512) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_CASH_NEAR','margin.vm.pricer.PricerMeasureVariationMargin', 1513) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_NEAR','margin.vm.pricer.PricerMeasureVariationMargin', 1514) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('NPV_ADJ_FAR','margin.vm.pricer.PricerMeasureVariationMargin', 1515) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_CASH_FAR','margin.vm.pricer.PricerMeasureVariationMargin', 1516) 
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id) 
 	values ('VM_FAR','margin.vm.pricer.PricerMeasureVariationMargin', 1517) 
;

