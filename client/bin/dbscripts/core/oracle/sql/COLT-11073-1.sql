DECLARE        
                v_column_exists number :=0;
                v_table_exists number := 0;
 
BEGIN
				select count(*) into v_table_exists from user_tables where table_name = 'COLLATERAL_CONTEXT';
        
		if (v_table_exists > 0) then
		
				select count(*) into v_column_exists from user_tab_cols where column_name = 'WORKFLOW_SUBTYPE' and table_name = 'COLLATERAL_CONTEXT';
                
				if(v_column_exists > 0) then
						execute immediate 'update collateral_context set workflow_subtype = ''From Entry Type'' where  workflow_subtype = ''From Processing Type'' ';
        		end if;
        
        		select count(*) into v_column_exists from user_tab_cols where column_name = 'WORKFLOW_PRODUCT' and table_name = 'COLLATERAL_CONTEXT';
        
        		if(v_column_exists > 0) then
						execute immediate 'update collateral_context set workflow_product = ''From Entry Type'' where  workflow_product = ''From Processing Type'' ';
        		end if;
		
		end if;
		
END;	