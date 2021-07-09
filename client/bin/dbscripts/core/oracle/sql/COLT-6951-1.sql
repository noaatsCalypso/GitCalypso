DECLARE
	v_column_data_type number := 0;  
BEGIN
	select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'LE_HAIRCUT_NAME';
	if (v_column_data_type = 0) then
BEGIN
execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (
le_haircut_name varchar2 (256)  NULL,
po_haircut_name varchar2 (256)  NULL,
le_is_rehypothecable numeric NULL,
le_accept_rehyp varchar2 (256)  NULL,
le_collateral_rehyp varchar2 (256)  NULL)';
END;
end if;

select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'ACCEPT_REHYPOTHECATED';
	if (v_column_data_type = 0) then
BEGIN
execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (ACCEPT_REHYPOTHECATED varchar2 (8) NULL)';
END;
end if;

select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'COLLATERAL_REHYPOTHECATION';
	if (v_column_data_type = 0) then
BEGIN
execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (COLLATERAL_REHYPOTHECATION varchar2 (8) NULL)';
END;
end if;

execute immediate 'UPDATE collateral_config SET (po_haircut_name) = (SELECT (haircut_name) FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) 
WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)';

execute immediate 'UPDATE collateral_config SET (le_haircut_name) = (SELECT (haircut_name) FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) 
WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)';

execute immediate 'UPDATE collateral_config SET (le_is_rehypothecable) = (SELECT (rehypothecable_b) FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) 
WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)';

execute immediate 'UPDATE collateral_config SET le_accept_rehyp = accept_rehypothecated WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)';

execute immediate 'UPDATE collateral_config SET le_collateral_rehyp = collateral_rehypothecation WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)';

execute immediate 'UPDATE collateral_config SET accept_rehypothecated = ''NONE'' WHERE accept_rehypothecated is null AND le_is_rehypothecable = 1';
execute immediate 'UPDATE collateral_config SET le_accept_rehyp = ''NONE'' WHERE le_accept_rehyp is null AND le_is_rehypothecable = 1';
execute immediate 'UPDATE collateral_config SET collateral_rehypothecation = ''NONE'' WHERE collateral_rehypothecation is null AND le_is_rehypothecable = 1';
execute immediate 'UPDATE collateral_config SET le_collateral_rehyp = ''NONE'' WHERE le_collateral_rehyp is null and le_is_rehypothecable = 1';

END;

