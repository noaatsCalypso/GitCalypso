DO $$
declare		
		
cnt_engine_config_rows integer;		
cnt_engine_param_rows integer;		
		
begin		
	select COUNT(*) into cnt_engine_config_rows from engine_config where engine_name in ('DataWarehouseRiskEngine');
    select COUNT(*) into cnt_engine_param_rows  from engine_param where engine_name in ('DataWarehouseRiskEngine');
	
	if ( cnt_engine_config_rows > 0 or cnt_engine_param_rows > 0) then	
		delete from ps_event_filter where engine_name in ('DataWarehouseRiskEngine');
		delete from ps_event_config where engine_name in ('DataWarehouseRiskEngine');
		delete from engine_param where engine_name in ('DataWarehouseRiskEngine');
		delete from engine_config where engine_name in ('DataWarehouseRiskEngine');
	end if;	
		
end;		
$$
;
