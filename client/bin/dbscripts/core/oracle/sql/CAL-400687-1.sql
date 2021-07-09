/* Remove all the references to the DataWarehouseRiskEngine engine  */
DECLARE
   cnt_engine_config_rows INT;
  cnt_engine_param_rows INT; 
BEGIN
	SELECT COUNT(*) INTO cnt_engine_config_rows FROM engine_config where engine_name in ('DataWarehouseRiskEngine');
    SELECT COUNT(*) INTO cnt_engine_param_rows FROM engine_param where engine_name in ('DataWarehouseRiskEngine');
    
	IF ( cnt_engine_config_rows > 0 or cnt_engine_param_rows > 0 ) THEN
		delete from ps_event_filter where engine_name in ('DataWarehouseRiskEngine');
		delete from ps_event_config where engine_name in ('DataWarehouseRiskEngine');
		delete from engine_param where engine_name in ('DataWarehouseRiskEngine');
		delete from engine_config where engine_name in ('DataWarehouseRiskEngine');
	END IF;
END;
/

