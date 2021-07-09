DECLARE
	v_column_exists number :=0;
    v_table_exists number := 0;
BEGIN
	
	update collateral_config set contract_direction = 'GROSS-UNILATERAL-POSITIVE' where contract_direction = 'NET-UNILATERAL - POSITIVE';
	
	select count(*) into v_table_exists from user_tables where table_name = 'EXPOSURE_GROUP_DEFINITION';

	if(v_table_exists > 0) then
	 select count(*) into v_column_exists from user_tab_cols where column_name = 'CONTRACT_DIRECTION' and table_name = 'EXPOSURE_GROUP_DEFINITION';
	end if;
	
	if(v_column_exists > 0) then
		execute immediate  'update exposure_group_definition set contract_direction = ''GROSS-UNILATERAL-POSITIVE'' where contract_direction = ''NET-UNILATERAL - POSITIVE''';
	end if;
END;