BEGIN
	EXECUTE('INSERT INTO collateral_config_field (mcc_field, mcc_id, mcc_value) SELECT ''ACADIA_SOLE_VAL_AGENT'', collateral_config.mcc_id , ''None'' FROM collateral_config')
END
