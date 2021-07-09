DECLARE        
        v_rows_exists number := 0;
		v_table_exists number := 0;
 
BEGIN	
		select count(*) into v_table_exists from user_tables where table_name = 'COLLATERAL_CONFIG_FIELD_DUMMY';
		
		if (v_table_exists > 0) then
		execute immediate 'drop table COLLATERAL_CONFIG_FIELD_DUMMY';
		end if;
		
		select count(*) into v_rows_exists from collateral_config_field where mcc_field='ACADIA_AUTO_DISPUTE';
        
		if (v_rows_exists > 0) then
		
				execute immediate 'create table COLLATERAL_CONFIG_FIELD_DUMMY AS (
				select * from collateral_config_field where mcc_field=''ACADIA_AUTO_DISPUTE'')';
				
				execute immediate 'insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (
				select distinct mcc_id,''ACADIA_CALL_ABOVE_TOLERANCE'' Col1, ''false'' col2 from COLLATERAL_CONFIG_FIELD_DUMMY where mcc_field in (''ACADIA_AUTO_DISPUTE'') and lower(mcc_value)=''false'')';
				
				execute immediate 'insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (
				select distinct mcc_id,''ACADIA_CALL_ABOVE_TOLERANCE'' Col1, ''true'' col2 from COLLATERAL_CONFIG_FIELD_DUMMY where mcc_field in (''ACADIA_AUTO_DISPUTE'') and lower(mcc_value)=''true'')';
				
				execute immediate 'insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (
				select distinct mcc_id,''ACADIA_CALL_NOTIFICATION_TIME'' Col1, ''No STP'' col2 from COLLATERAL_CONFIG_FIELD_DUMMY where mcc_field in (''ACADIA_AUTO_DISPUTE''))';
		
		end if;
		select count(*) into v_table_exists from user_tables where table_name = 'COLLATERAL_CONFIG_FIELD_DUMMY';
		
		if (v_table_exists > 0) then
		execute immediate 'drop table COLLATERAL_CONFIG_FIELD_DUMMY';
		end if;
END;
/