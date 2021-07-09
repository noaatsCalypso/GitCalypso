DECLARE
	v_column_exists number :=0;
                table_exists number :=0;
 
BEGIN
 
                select count(*) into v_column_exists from user_tab_cols where column_name = 'PO_HAIRCUT_TYPE' and table_name = 'COLLATERAL_CONFIG';
                select count(*) into table_exists from user_tables where table_name = 'EXPOSURE_GROUP_DEFINITION';
                if(v_column_exists < 1) then
                                execute immediate 'ALTER TABLE collateral_config ADD PO_HAIRCUT_TYPE varchar2(32) NULL';
                end if;
                
                select count(*) into v_column_exists from user_tab_cols where column_name = 'LE_HAIRCUT_TYPE' and table_name = 'COLLATERAL_CONFIG';
                if(v_column_exists < 1) then
                                execute immediate 'ALTER TABLE collateral_config ADD le_haircut_type varchar2 (32) NULL';
                end if;
                
                  select count(*) into v_column_exists from user_tab_cols where column_name = 'LE_HAIRCUT_TYPE' and table_name = 'EXPOSURE_GROUP_DEFINITION';
                if(table_exists > 0 and v_column_exists < 1) then
                                    execute immediate 'ALTER TABLE EXPOSURE_GROUP_DEFINITION ADD LE_HAIRCUT_TYPE varchar2(32) NULL';
                end if;
                execute immediate 'update collateral_config set (po_haircut_type, le_haircut_type) = (select haircut_type, haircut_type from mrgcall_config where mrgcall_config.mrg_call_def = collateral_config.mcc_id) where po_haircut_type is null and le_haircut_type is null';
                 if(table_exists > 0) then
                execute immediate 'update exposure_group_definition set le_haircut_type = haircut_type where le_haircut_type is null';
                end if;
END;
/