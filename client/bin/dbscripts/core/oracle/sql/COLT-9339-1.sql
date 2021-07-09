DECLARE
                v_column_exists number :=0;
                v_table_exists number := 0;
BEGIN
				update collateral_config set contract_direction = 'NET - BILATERAL' where contract_direction = 'BILATERAL';
                update collateral_config set contract_direction = 'NET - UNILATERAL' where contract_direction = 'UNILATERAL';
                
				select count(*) into v_table_exists from user_tables where table_name = 'exposure_group_definition';
	
	if (v_table_exists > 0) then
				
                select count(*) into v_column_exists from user_tab_cols where column_name = 'CONTRACT_DIRECTION' and table_name = 'EXPOSURE_GROUP_DEFINITION';
                if(v_column_exists < 1) then
                                execute immediate 'ALTER TABLE EXPOSURE_GROUP_DEFINITION ADD(CONTRACT_DIRECTION varchar2 (24) NULL)';
                end if;
                
                select count(*) into v_column_exists from user_tab_cols where column_name = 'SECURED_PARTY' and table_name = 'EXPOSURE_GROUP_DEFINITION';
                if(v_column_exists < 1) then
                                execute immediate 'ALTER TABLE EXPOSURE_GROUP_DEFINITION ADD (SECURED_PARTY varchar2 (24) NULL)';
                end if;

                execute immediate 'update exposure_group_definition set contract_direction = (select collateral_config.contract_direction from collateral_config where exposure_group_definition.mrg_call_def = collateral_config.mcc_id) where contract_direction=''''';
                execute immediate 'update exposure_group_definition set secured_party = (select collateral_config.secured_party from collateral_config where exposure_group_definition.mrg_call_def = collateral_config.mcc_id) where secured_party=''''';
                execute immediate 'update exposure_group_definition set contract_direction = (select collateral_config.contract_direction from collateral_config where exposure_group_definition.mrg_call_def = collateral_config.mcc_id) where contract_direction is null';
                execute immediate 'update exposure_group_definition set secured_party = (select collateral_config.secured_party from collateral_config where exposure_group_definition.mrg_call_def = collateral_config.mcc_id) where secured_party is null';
	end if;
END;
