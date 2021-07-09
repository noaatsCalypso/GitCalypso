DECLARE
	v_column_data_occr number := 0;  
BEGIN
	SELECT count(mcc_value) into v_column_data_occr  FROM collateral_config_field WHERE mcc_field = 'ACADIA_SOLE_VAL_AGENT';
	if (v_column_data_occr != 0) then
			execute immediate 'DELETE FROM collateral_config_field WHERE mcc_field = ''ACADIA_SOLE_VAL_AGENT''';		
	end if;
	
	execute immediate 'INSERT INTO COLLATERAL_CONFIG_FIELD (mcc_field, mcc_id, mcc_value)  SELECT ''ACADIA_SOLE_VAL_AGENT'', collateral_config.mcc_id , ''None'' FROM COLLATERAL_CONFIG';

End;
