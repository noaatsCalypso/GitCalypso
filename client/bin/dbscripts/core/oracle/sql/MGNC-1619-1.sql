INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign)
        values ('CVM','NEAR',-1,'FXSwap','CVM_NEAR',1,1,1)
;
INSERT INTO margin_vm_definition (name,leg,additional_column_index,product_type,measure_name,intraday,cumulative,flip_sign)
        values ('CVM','FAR',-1,'FXSwap','CVM_FAR',1,1,1)
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id)
        values ('CVM_NEAR','margin.vm.pricer.PricerMeasureVariationMargin', 533)
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id)
        values ('CVM_FAR','margin.vm.pricer.PricerMeasureVariationMargin', 532)
;

