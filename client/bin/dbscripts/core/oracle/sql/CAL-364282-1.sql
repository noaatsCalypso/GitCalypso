delete from pricer_measure where measure_name = 'PRICE_UNDERLYING_INDEX'
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('PRICE_UNDERLYING_INDEX','tk.pricer.PricerMeasureCredit',925)
;
delete from pricer_measure where measure_name = 'ACCRUAL_FINANCING'
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('ACCRUAL_FINANCING','tk.pricer.PricerMeasureCredit',926)
;
delete from pricer_measure where measure_name = 'ACCRUAL_INDEX'
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('ACCRUAL_INDEX','tk.pricer.PricerMeasureCredit',927)
;
delete from pricer_measure where measure_name = 'MTM_INDEX'
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('MTM_INDEX','tk.pricer.PricerMeasureCredit',928)
;