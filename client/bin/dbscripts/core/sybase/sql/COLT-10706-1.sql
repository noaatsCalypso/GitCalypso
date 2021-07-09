BEGIN

EXECUTE('UPDATE collateral_config SET contract_direction = ''GROSS-UNILATERAL-POSITIVE'' WHERE contract_direction = ''NET-UNILATERAL - POSITIVE''')
EXECUTE('UPDATE exposure_group_definition SET contract_direction = ''GROSS-UNILATERAL-POSITIVE'' WHERE contract_direction = ''NET-UNILATERAL - POSITIVE''')

END
