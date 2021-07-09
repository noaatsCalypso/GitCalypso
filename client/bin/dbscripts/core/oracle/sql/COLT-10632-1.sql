DECLARE
	v_orig_table_exists NUMBER := 0;
	v_new_table_exists NUMBER := 0;
	v_orig_column_exists NUMBER := 0;
BEGIN
	
	SELECT COUNT(*) INTO v_orig_table_exists FROM user_tables WHERE table_name = 'COLLATERAL_CONFIG';
	
	IF (v_orig_table_exists > 0) THEN
	
		SELECT COUNT(*) INTO v_new_table_exists FROM user_tables WHERE table_name = 'COLLATERAL_CONFIG_BIN';
		
		IF (v_new_table_exists = 0) THEN
			EXECUTE IMMEDIATE 'CREATE TABLE collateral_config_bin (mcc_id NUMERIC NOT NULL, additional_fields BLOB NULL, collateral_dates BLOB NULL, eligibility_filters BLOB NULL, eligibility_exclusion BLOB NULL, le_eligibility_filters BLOB NULL, le_eligibility_exclusion BLOB NULL)';
		END IF;
		
		EXECUTE IMMEDIATE 'INSERT INTO collateral_config_bin (mcc_id) SELECT collateral_config.mcc_id FROM collateral_config WHERE NOT EXISTS (SELECT collateral_config_bin.mcc_id FROM collateral_config,collateral_config_bin WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id)';
    
		SELECT COUNT(*) INTO v_orig_column_exists FROM user_tab_cols WHERE column_name = 'ADDITIONAL_FIELDS' AND table_name = 'COLLATERAL_CONFIG';
		IF (v_orig_column_exists > 0) THEN
			EXECUTE IMMEDIATE 'UPDATE collateral_config_bin ccb SET ccb.additional_fields = (SELECT cc.additional_fields FROM collateral_config cc WHERE cc.mcc_id = ccb.mcc_id)';
		END IF;
		
		SELECT COUNT(*) INTO v_orig_column_exists FROM user_tab_cols WHERE column_name = 'COLLATERAL_DATES' AND table_name = 'COLLATERAL_CONFIG';
		IF (v_orig_column_exists > 0) THEN
			EXECUTE IMMEDIATE 'UPDATE collateral_config_bin ccb SET ccb.collateral_dates = (SELECT cc.collateral_dates FROM collateral_config cc WHERE cc.mcc_id = ccb.mcc_id)';
		END IF;
		
		SELECT COUNT(*) INTO v_orig_column_exists FROM user_tab_cols WHERE column_name = 'ELIGIBILITY_FILTERS' AND table_name = 'COLLATERAL_CONFIG';
		IF (v_orig_column_exists > 0) THEN
			EXECUTE IMMEDIATE 'UPDATE collateral_config_bin ccb SET ccb.eligibility_filters = (SELECT cc.eligibility_filters FROM collateral_config cc WHERE cc.mcc_id = ccb.mcc_id)';
		END IF;
		
		SELECT COUNT(*) INTO v_orig_column_exists FROM user_tab_cols WHERE column_name = 'ELIGIBILITY_EXCLUSION' AND table_name = 'COLLATERAL_CONFIG';
		IF (v_orig_column_exists > 0) THEN
			EXECUTE IMMEDIATE 'UPDATE collateral_config_bin ccb SET ccb.eligibility_exclusion = (SELECT cc.eligibility_exclusion FROM collateral_config cc WHERE cc.mcc_id = ccb.mcc_id)';
		END IF;
		
		SELECT COUNT(*) INTO v_orig_column_exists FROM user_tab_cols WHERE column_name = 'LE_ELIGIBILITY_FILTERS' AND table_name = 'COLLATERAL_CONFIG';
		IF (v_orig_column_exists > 0) THEN
			EXECUTE IMMEDIATE 'UPDATE collateral_config_bin ccb SET ccb.le_eligibility_filters = (SELECT cc.le_eligibility_filters FROM collateral_config cc WHERE cc.mcc_id = ccb.mcc_id)';
		END IF;
		
		SELECT COUNT(*) INTO v_orig_column_exists FROM user_tab_cols WHERE column_name = 'LE_ELIGIBILITY_EXCLUSION' AND table_name = 'COLLATERAL_CONFIG';
		IF (v_orig_column_exists > 0) THEN
			EXECUTE IMMEDIATE 'UPDATE collateral_config_bin ccb SET ccb.le_eligibility_exclusion = (SELECT cc.le_eligibility_exclusion FROM collateral_config cc WHERE cc.mcc_id = ccb.mcc_id)';
		END IF;
		
	END IF;
	
END;