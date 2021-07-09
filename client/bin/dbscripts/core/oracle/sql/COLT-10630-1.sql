DECLARE
	v_orig_table_exists NUMBER := 0;
	x number;
	y number;

BEGIN
	
	SELECT COUNT(*) INTO v_orig_table_exists FROM user_tables WHERE table_name = 'COLLATERAL_CONFIG';
	
	IF (v_orig_table_exists > 0) THEN
		
		BEGIN
		select max(vsize(CONCENTRATION_POSITION)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 16) then
		execute immediate 'alter table collateral_config modify (concentration_position varchar2(16))';
		end if;
		END;
		
		BEGIN
		select max(vsize(CONCENTRATION_SIDE)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table collateral_config modify (concentration_side varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(CONTRACT_DIRECTION)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (contract_direction  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(DISPUTE_TOL_PERC_BASIS)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 24) then
		execute immediate 'alter table collateral_config modify (dispute_tol_perc_basis  varchar2(24))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_IA_RATING_DIRECTION)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (le_ia_rating_direction  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_MTA_CURRENCY)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 3) then
		execute immediate 'alter table collateral_config modify (le_mta_currency  varchar2(3))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_THRES_CURRENCY)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 3) then
		execute immediate 'alter table collateral_config modify (le_thres_currency  varchar2(3))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_IA_RATING_DIRECTION)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (po_ia_rating_direction  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_MTA_CURRENCY)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 3) then
		execute immediate 'alter table collateral_config modify (po_mta_currency  varchar2(3))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_THRES_CURRENCY)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 3) then
		execute immediate 'alter table collateral_config modify (po_thres_currency  varchar2(3))';
		end if;
		END;
		
		BEGIN
		select max(vsize(POSITION_DATE_TYPE)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 24) then
		execute immediate 'alter table collateral_config modify (position_date_type  varchar2(24))';
		end if;
		END;
		
		BEGIN
		select max(vsize(POSITION_TYPE)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (position_type  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(SUBSTITUTION_CONTEXT)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 24) then
		execute immediate 'alter table collateral_config modify (substitution_context  varchar2(24))';
		end if;
		END;
		
		BEGIN
		select max(vsize(SUBSTITUTION_LEVEL)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 48) then
		execute immediate 'alter table collateral_config modify (substitution_level  varchar2(48))';
		end if;
		END;
		
		BEGIN
		select max(vsize(SUBSTITUTION_TYPE)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 24) then
		execute immediate 'alter table collateral_config modify (substitution_type  varchar2(24))';
		end if;
		END;
		
		BEGIN
		select max(vsize(UNDISPUTED_PERC_DISPUTE_B)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 24) then
		execute immediate 'alter table collateral_config modify (undisputed_perc_dispute_b  varchar2(24))';
		end if;
		END;
		
		BEGIN
		select max(vsize(WF_PRODUCT)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (wf_product  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(WF_SUBTYPE)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (wf_subtype  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PERIMETER_TYPE)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (perimeter_type  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_IA_DIRECTION)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table collateral_config modify (po_ia_direction  varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_IA_DIRECTION)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table collateral_config modify (le_ia_direction  varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(INTRADAY_PRICING_ENV_NAME)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (intraday_pricing_env_name  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(SIMULATION_PRICING_ENV_NAME)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table collateral_config modify (simulation_pricing_env_name  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_HAIRCUT_NAME)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 256) then
		execute immediate 'alter table collateral_config modify (po_haircut_name  varchar2(256))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_HAIRCUT_NAME)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 256) then
		execute immediate 'alter table collateral_config modify (le_haircut_name  varchar2(256))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_ACCEPT_REHYP)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table collateral_config modify (le_accept_rehyp  varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_COLLATERAL_REHYP)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table collateral_config modify (le_collateral_rehyp  varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(TERM_SETTLE_CCY_LIST)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 1024) then
		execute immediate 'alter table collateral_config modify (term_settle_ccy_list  varchar2(1024))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_TERM_CCY_LIST)) into x from collateral_config;
		select count(*) into y from collateral_config;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 1024) then
		execute immediate 'alter table collateral_config modify (le_term_ccy_list  varchar2(1024))';
		end if;
		END;
		
	END IF;
	
	SELECT COUNT(*) INTO v_orig_table_exists FROM user_tables WHERE table_name = 'EXPOSURE_GROUP_DEFINITION';
	
	IF (v_orig_table_exists > 0) THEN
		
		BEGIN
		select max(vsize(TERM_SETTLE_CCY_LIST)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 1024) then
		execute immediate 'alter table exposure_group_definition modify (term_settle_ccy_list  varchar2(1024))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_TERM_CCY_LIST)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 1024) then
		execute immediate 'alter table exposure_group_definition modify (le_term_ccy_list  varchar2(1024))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_HAIRCUT_NAME)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 256) then
		execute immediate 'alter table exposure_group_definition modify (po_haircut_name  varchar2(256))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_HAIRCUT_NAME)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 256) then
		execute immediate 'alter table exposure_group_definition modify (le_haircut_name  varchar2(256))';
		end if;
		END;
		
		BEGIN
		select max(vsize(HAIRCUT_TYPE)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 32) then
		execute immediate 'alter table exposure_group_definition modify (haircut_type  varchar2(32))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_ACCEPT_REHYP)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table exposure_group_definition modify (po_accept_rehyp  varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(PO_COLLATERAL_REHYP)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table exposure_group_definition modify (po_collateral_rehyp  varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_ACCEPT_REHYP)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table exposure_group_definition modify (le_accept_rehyp  varchar2(8))';
		end if;
		END;
		
		BEGIN
		select max(vsize(LE_COLLATERAL_REHYP)) into x from exposure_group_definition;
		select count(*) into y from exposure_group_definition;
		exception WHEN NO_DATA_FOUND THEN
		x:=0;
		y:=0;
		if (y = 0 or x <= 8) then
		execute immediate 'alter table exposure_group_definition modify (le_collateral_rehyp  varchar2(8))';
		end if;
		END;
		
		
		
	END IF;
	
END;
