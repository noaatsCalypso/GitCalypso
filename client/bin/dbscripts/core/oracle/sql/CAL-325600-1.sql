delete from pricer_measure where measure_id = 5000 and measure_name = 'SA_CCR_EAD'
;
delete from pricer_measure where measure_id = 5001 and measure_name = 'SA_CCR_PFE'
;
delete from pricer_measure where measure_id = 5002 and measure_name = 'SA_CCR_CVA'
;
delete from pricer_measure where measure_id = 5003 and measure_name = 'SA_CCR_CVA01'
;
delete from pricer_measure where measure_id = 5004 and measure_name = 'SA_CCR_CVA_SPREAD'
;
delete from pricer_measure where measure_id = 5005 and measure_name = 'SA_CCR_KCVA'
;
delete from pricer_measure where measure_id = 5006 and measure_name = 'SA_MR_IR_CAPITAL'
;
delete from pricer_measure where measure_id = 5007 and measure_name = 'SA_MR_FX_CAPITAL'
;
delete from pricer_measure where measure_id = 5008 and measure_name = 'SA_MR_CO_CAPITAL'
;
delete from pricer_measure where measure_id = 5009 and measure_name = 'SA_MR_EQ_CAPITAL'
;
delete from pricer_measure where measure_id = 5200 and measure_name = 'MCPFE'
;
delete from pricer_measure where measure_id = 5201 and measure_name = 'MCCptyPFE'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_CCR_EAD'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_CCR_PFE'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_CCR_CVA'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_CCR_CVA01'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_CCR_CVA_SPREAD'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_CCR_KCVA'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_MR_IR_CAPITAL'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_MR_FX_CAPITAL'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_MR_CO_CAPITAL'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'SA_MR_EQ_CAPITAL'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'MCPFE'
;
delete from domain_values where Name = 'PricingSheetMeasures' and Value = 'MCCptyPFE'
;