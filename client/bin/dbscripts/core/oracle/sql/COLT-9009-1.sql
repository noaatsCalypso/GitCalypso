DECLARE
	v_column_data_type number := 0;  
BEGIN
	select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'ACADIA_B';
	if (v_column_data_type = 0) then
			execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (acadia_b numeric null)';		
	end if;
	
	execute immediate 'update collateral_config set acadia_b = 1 where  (select mcc_value from collateral_config_field collateral_config_field  where MCC_FIELD = ''ACADIA_AMPID'' and collateral_config.mcc_id = collateral_config_field.mcc_id) is not null';
End;
