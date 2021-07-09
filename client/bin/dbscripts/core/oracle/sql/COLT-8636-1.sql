DECLARE
	v_column_data_type number := 0;  
BEGIN
	select count(*) into v_column_data_type from user_tab_columns where table_name = 'CONCENTRATION_LIMIT' and column_name = 'BREAKDOWN';
	if (v_column_data_type = 0) then
		BEGIN
			execute immediate 
				'ALTER TABLE CONCENTRATION_LIMIT ADD (parent_limit_id number(22) null)';
			execute immediate 
				'ALTER TABLE CONCENTRATION_LIMIT ADD (breakdown varchar(256) null)';
			execute immediate 
				'ALTER TABLE CONCENTRATION_LIMIT ADD (depth number(22) null)';
				
			execute immediate 
				'ALTER TABLE COLLATERAL_CONCENTRATION ADD (limit_id number(22) null)';
			execute immediate 
				'ALTER TABLE COLLATERAL_CONCENTRATION ADD (breakdown_key varchar(256) null)';
					
		END;
	end if;
	
		select count(*) into v_column_data_type from user_tab_columns where table_name = 'CONCENTRATION_LIMIT' and column_name = 'PERCENTAGE_BASIS';
	if (v_column_data_type = 0) then
		BEGIN
			execute immediate 
				'ALTER TABLE CONCENTRATION_LIMIT ADD (PERCENTAGE_BASIS varchar(64) null)';		
				
		END;
	end if;
	
			execute immediate 'UPDATE concentration_limit SET BREAKDOWN = ''Currency Filter'' where rule_id in (select id from concentration_rule where type=''Category'') and breakdown is null and currencies is not null';
			execute immediate 'UPDATE concentration_limit SET BREAKDOWN = ''Static Data Filter'' where rule_id in (select id from concentration_rule where type=''Category'') and breakdown is null and sd_filter is not null';
			
			execute immediate 'UPDATE concentration_limit SET BREAKDOWN = ''Issuer'' where rule_id in (select id from concentration_rule where type=''Issuer'') and breakdown is null';
			execute immediate 'UPDATE concentration_limit SET BREAKDOWN = ''Security'' where rule_id in (select id from concentration_rule where type=''Issue'') and breakdown is null';

			execute immediate  'UPDATE concentration_limit SET PERCENTAGE_BASIS = ''Total Issued''  where rule_id in (select id from concentration_rule where type=''Issue'')';
			execute immediate  'UPDATE concentration_limit SET PERCENTAGE_BASIS = ''Total Collateral Value''  where rule_id in (select id from concentration_rule where type=''Category'')';
			execute immediate  'UPDATE concentration_limit SET PERCENTAGE_BASIS = ''Total Collateral Value''  where rule_id in (select id from concentration_rule where type=''Issuer'')';

			execute immediate 'UPDATE concentration_limit SET DEPTH=0 where DEPTH is null';
END;