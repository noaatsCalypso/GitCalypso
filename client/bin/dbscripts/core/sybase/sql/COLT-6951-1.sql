IF NOT EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_haircut_name')
BEGIN 
        EXECUTE('ALTER TABLE collateral_config ADD le_haircut_name varchar(256) NULL')
        EXECUTE('ALTER TABLE collateral_config ADD po_haircut_name varchar(256) NULL')
        EXECUTE('ALTER TABLE collateral_config ADD le_is_rehypothecable numeric NULL')
        EXECUTE('ALTER TABLE collateral_config ADD le_accept_rehyp varchar(256) NULL')
        EXECUTE('ALTER TABLE collateral_config ADD le_collateral_rehyp varchar(256) NULL')
END
    
IF NOT EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'accept_rehypothecated')
BEGIN 
		EXECUTE('ALTER TABLE collateral_config ADD accept_rehypothecated varchar(8) NULL')
END
  
IF NOT EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'collateral_rehypothecation')
BEGIN 
        EXECUTE('ALTER TABLE collateral_config ADD collateral_rehypothecation varchar(8) NULL')
END
    
EXECUTE('UPDATE collateral_config SET po_haircut_name = (SELECT (haircut_name) FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)')
  
EXECUTE('UPDATE collateral_config SET le_haircut_name = (SELECT (haircut_name) FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)')
  
EXECUTE('UPDATE collateral_config SET le_is_rehypothecable = (SELECT (rehypothecable_b) FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)')
  
EXECUTE('UPDATE collateral_config SET le_accept_rehyp = accept_rehypothecated WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)')
  
EXECUTE('UPDATE collateral_config SET le_collateral_rehyp = collateral_rehypothecation WHERE EXISTS (SELECT * FROM mrgcall_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)')

EXECUTE('UPDATE collateral_config SET accept_rehypothecated = ''NONE'' WHERE accept_rehypothecated IS NULL AND le_is_rehypothecable = 1')
EXECUTE('UPDATE collateral_config SET le_accept_rehyp = ''NONE'' WHERE le_accept_rehyp IS NULL AND le_is_rehypothecable = 1')
EXECUTE('UPDATE collateral_config SET collateral_rehypothecation = ''NONE'' WHERE collateral_rehypothecation IS NULL AND le_is_rehypothecable = 1')
EXECUTE('UPDATE collateral_config SET le_collateral_rehyp = ''NONE'' WHERE le_collateral_rehyp IS NULL AND le_is_rehypothecable = 1')
