DECLARE        
        v_rows_exists number := 0;
		v_table_exists number := 0;
 
BEGIN	
		select count(*) into v_table_exists from user_tables where table_name = 'PRICER_MEASURE';
		
		if (v_table_exists > 0) then
		   select count(*) into v_rows_exists from PRICER_MEASURE where measure_name in ('PM_SIMM','PM_SCHEDULE');		
			if (v_rows_exists < 1) then		
				execute immediate 'INSERT INTO pricer_measure(measure_name, measure_class_name, measure_id,measure_comment) 
				values(''PM_SIMM'',''tk.core.PricerMeasure'',(select max(measure_id)+1 from pricer_measure),''PM_SIMM for margin'')';
				
				execute immediate 'INSERT INTO pricer_measure(measure_name, measure_class_name, measure_id,measure_comment) 
				values(''PM_SCHEDULE'',''tk.core.PricerMeasure'',(select max(measure_id)+1 from pricer_measure),''PM_SCHEDULE for margin'')';		
			end if;
		end if;
		
END;
/