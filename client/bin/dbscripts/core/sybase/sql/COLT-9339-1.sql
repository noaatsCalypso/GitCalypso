EXECUTE('UPDATE collateral_config SET contract_direction = ''NET - BILATERAL'' WHERE contract_direction = ''BILATERAL''')

EXECUTE('UPDATE collateral_config SET contract_direction = ''NET - UNILATERAL'' WHERE contract_direction = ''UNILATERAL''')

EXECUTE('UPDATE exposure_group_definition SET contract_direction = (SELECT collateral_config.contract_direction FROM collateral_config WHERE exposure_group_definition.mrg_call_def = collateral_config.mcc_id) WHERE contract_direction='' ''')

EXECUTE('UPDATE exposure_group_definition SET secured_party = (SELECT collateral_config.secured_party FROM collateral_config WHERE exposure_group_definition.mrg_call_def = collateral_config.mcc_id) WHERE secured_party='' ''')

EXECUTE('UPDATE exposure_group_definition SET contract_direction = (SELECT collateral_config.contract_direction FROM collateral_config WHERE exposure_group_definition.mrg_call_def = collateral_config.mcc_id) WHERE contract_direction IS NULL')

EXECUTE('UPDATE exposure_group_definition SET secured_party = (SELECT collateral_config.secured_party FROM collateral_config WHERE exposure_group_definition.mrg_call_def = collateral_config.mcc_id) WHERE secured_party IS NULL')
