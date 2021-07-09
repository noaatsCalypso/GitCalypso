DECLARE
	v_column_exists number :=0;
BEGIN
	select count(*) into v_column_exists from user_tab_cols where column_name = 'SOURCE_TYPE' and table_name = 'COLLATERAL_POOL_SOURCE';
	if(v_column_exists > 0) then
		execute immediate 'UPDATE COLLATERAL_POOL_SOURCE SET SOURCE_TYPE= ''Rehypothecable Assets'' WHERE source_type=''Rehypothecatable Assets''';
	end if;
	execute immediate 'DELETE FROM domain_values where name=''CollateralPool.sourceTypes'' and value = ''Rehypothecatable Assets''';
END;