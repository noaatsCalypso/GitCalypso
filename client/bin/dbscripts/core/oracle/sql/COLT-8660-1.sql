DECLARE
	v_column_data_type number := 0;
  v_table_exists number := 0; 
BEGIN
	select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'LE_ELIGIBILITY_FILTERS';
	if (v_column_data_type = 0) then
BEGIN
execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (le_eligibility_filters blob NULL,le_eligibility_exclusion blob NULL)';
END;
end if;

select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'ELIGIBILITY_FILTERS';
	if (v_column_data_type = 0) then
		BEGIN
			execute immediate 
				'ALTER TABLE COLLATERAL_CONFIG ADD (eligibility_filters blob NULL)';		
				
		END;
	end if;
	
	select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'ELIGIBILITY_EXCLUSION';
	if (v_column_data_type = 0) then
		BEGIN
			execute immediate 
				'ALTER TABLE COLLATERAL_CONFIG ADD (eligibility_exclusion blob NULL)';		
				
		END;
	end if;
  
execute immediate 'UPDATE collateral_config SET le_eligibility_filters = eligibility_filters';
execute immediate 'UPDATE collateral_config SET le_eligibility_exclusion = eligibility_exclusion';

select count(*) into v_table_exists
		from user_tables where table_name = 'EXPOSURE_GROUP_DEFINITION';
	if (v_table_exists > 0) then
  BEGIN
  select count(*) into v_column_data_type from user_tab_columns where table_name = 'EXPOSURE_GROUP_DEFINITION' and column_name = 'LE_ELIGIBILITY_FILTERS';
	if (v_column_data_type = 0) then
		BEGIN
		execute immediate 'ALTER TABLE EXPOSURE_GROUP_DEFINITION ADD (le_eligibility_filters blob NULL, le_eligibility_exclusion blob NULL)';
		END;
	end if;

select count(*) into v_column_data_type from user_tab_columns where table_name = 'EXPOSURE_GROUP_DEFINITION' and column_name = 'ELIGIBILITY_FILTERS';
	if (v_column_data_type = 0) then
		BEGIN
			execute immediate 
				'ALTER TABLE EXPOSURE_GROUP_DEFINITION ADD (eligibility_filters blob NULL)';		
				
		END;
	end if;
	
	select count(*) into v_column_data_type from user_tab_columns where table_name = 'EXPOSURE_GROUP_DEFINITION' and column_name = 'ELIGIBILITY_EXCLUSION';
	if (v_column_data_type = 0) then
		BEGIN
			execute immediate 
				'ALTER TABLE EXPOSURE_GROUP_DEFINITION ADD (eligibility_exclusion blob NULL)';		
				
		END;
	end if;


  execute immediate 'UPDATE exposure_group_definition SET le_eligibility_filters = eligibility_filters';
  execute immediate 'UPDATE exposure_group_definition SET le_eligibility_exclusion = eligibility_exclusion';
  
  END;
  end if;

END;