/*  Remove all the references to the DataWarehouseRiskEngine engine */
DECLARE
   @cnt_engine_config_rows INT, @cnt_engine_param_rows INT
BEGIN
	SELECT @cnt_engine_config_rows=COUNT(*) FROM engine_config where engine_name in ('DataWarehouseRiskEngine')
    SELECT @cnt_engine_param_rows=COUNT(*) FROM engine_param where engine_name in ('DataWarehouseRiskEngine')

	IF (@cnt_engine_config_rows > 0 OR @cnt_engine_param_rows > 0) 
        BEGIN
			delete from ps_event_filter where engine_name in ('DataWarehouseRiskEngine')
			delete from ps_event_config where engine_name in ('DataWarehouseRiskEngine')
			delete from engine_param where engine_name in ('DataWarehouseRiskEngine')
			delete from engine_config where engine_name in ('DataWarehouseRiskEngine')
	    END
END
go
