DECLARE
	v_column_exists number :=0;
BEGIN
	select count(*) into v_column_exists from user_tab_cols where column_name = 'SOURCE_TYPE' and table_name = 'COLLATERAL_POOL_SOURCE';
	if(v_column_exists > 0) then
    	execute immediate 'UPDATE COLLATERAL_POOL_SOURCE SET SOURCE_TYPE=''Other'' where SOURCE_TYPE IS NULL';
	end if;
END;