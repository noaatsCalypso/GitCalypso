begin 
declare @new_id int 
declare @c int 
select @new_id= max(measure_id)+1 from pricer_measure
select @c= count(*) from pricer_measure where measure_name in ('PM_SIMM','PM_SCHEDULE')

if @c = 0 and @new_id > 0 
begin
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id,measure_comment)        
		values('PM_SIMM','tk.core.PricerMeasure',@new_id,'PM_SIMM') 
INSERT INTO pricer_measure (measure_name, measure_class_name, measure_id,measure_comment)
		values('PM_SCHEDULE','tk.core.PricerMeasure',(@new_id+1),'PM_SCHEDULE') 
end 

end 
go