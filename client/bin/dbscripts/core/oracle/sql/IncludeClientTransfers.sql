insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (select mcc_id, 'CLIENT_TRANSFERS', 'Include as Client' from collateral_config where mcc_id not in (select mcc_id from collateral_config_field where mcc_field = 'CLIENT_TRANSFERS'))
;
