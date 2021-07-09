INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id,measure_comment)        
values('PM_SIMM','tk.core.PricerMeasure',(select max(measure_id)+1 from pricer_measure),'PM_SIMM for margin flow')
;
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id,measure_comment)
values('PM_SCHEDULE','tk.core.PricerMeasure',(select max(measure_id)+1 from pricer_measure),'PM_SCHEDULE for margin flow')        
;