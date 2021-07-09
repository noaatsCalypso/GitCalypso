delete from pricer_measure where measure_name = 'PRICE_UNDERLYING_INDEX'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('PRICE_UNDERLYING_INDEX','tk.pricer.PricerMeasureCredit',925)
go
delete from pricer_measure where measure_name = 'ACCRUAL_FINANCING'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('ACCRUAL_FINANCING','tk.pricer.PricerMeasureCredit',926)
go
delete from pricer_measure where measure_name = 'ACCRUAL_INDEX'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('ACCRUAL_INDEX','tk.pricer.PricerMeasureCredit',927)
go
delete from pricer_measure where measure_name = 'MTM_INDEX'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES ('MTM_INDEX','tk.pricer.PricerMeasureCredit',928)
go