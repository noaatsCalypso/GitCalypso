begin
exec('delete from collateral_config_field where mcc_field in (''TRIPARTY_ACADIA_CALCULATION_TYPE'', ''TRIPARTY_ACADIA_ALLOCATION_MODEL'', ''TRIPARTY_CALCULATION_TYPE'', ''TRIPARTY_ALLOCATION_MODEL'') and mcc_value is null')
end

begin
exec('select * into collateral_config_field_temp from collateral_config_field where collateral_config_field.mcc_id in (select mcc_id from collateral_config where triparty_b=1) and collateral_config_field.mcc_field=''TRIPARTY_ACADIA_MESSAGING'' and collateral_config_field.mcc_value=''true'' ')
end

begin
exec('insert into collateral_config_field  (mcc_id, mcc_field, mcc_value)   select distinct mcc_id,''TRIPARTY_ACADIA_CALCULATION_TYPE'' as ''TRIPARTY_ACADIA_CALCULATION_TYPE'', ''Delta'' as ''Delta'' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in (''TRIPARTY_ACADIA_CALCULATION_TYPE'', ''TRIPARTY_ACADIA_ALLOCATION_MODEL'',''TRIPARTY_CALCULATION_TYPE'', ''TRIPARTY_ALLOCATION_MODEL'')) and mcc_id in (select mcc_id from collateral_config_field_temp)')
end

begin
exec('insert into collateral_config_field  (mcc_id, mcc_field, mcc_value)   select distinct mcc_id,''TRIPARTY_ACADIA_ALLOCATION_MODEL'' as ''TRIPARTY_ACADIA_ALLOCATION_MODEL'', ''MT569'' as ''MT569'' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in (''TRIPARTY_ACADIA_ALLOCATION_MODEL'',''TRIPARTY_CALCULATION_TYPE'', ''TRIPARTY_ALLOCATION_MODEL'')) and mcc_id in (select mcc_id from collateral_config_field_temp)')
end

begin
exec('drop table collateral_config_field_temp')
end

begin
exec('select * into collateral_config_field_temp from collateral_config_field where collateral_config_field.mcc_id in (select mcc_id from collateral_config where triparty_b=1) and collateral_config_field.mcc_field=''TRIPARTY_ACADIA_MESSAGING'' and collateral_config_field.mcc_value=''false''')
end

begin
exec('insert into collateral_config_field  (mcc_id, mcc_field, mcc_value)  select distinct mcc_id, ''TRIPARTY_CALCULATION_TYPE'' as ''TRIPARTY_CALCULATION_TYPE'', ''Net Exposure'' as ''Net Exposure'' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in (''TRIPARTY_ACADIA_CALCULATION_TYPE'', ''TRIPARTY_ACADIA_ALLOCATION_MODEL'',''TRIPARTY_CALCULATION_TYPE'', ''TRIPARTY_ALLOCATION_MODEL'')) and mcc_id in (select mcc_id from collateral_config_field_temp)')
end

begin
exec('insert into collateral_config_field  (mcc_id, mcc_field, mcc_value)   select distinct mcc_id, ''TRIPARTY_ALLOCATION_MODEL'' as ''TRIPARTY_ALLOCATION_MODEL'', ''Import MT569'' as ''Import MT569'' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in (''TRIPARTY_ACADIA_CALCULATION_TYPE'', ''TRIPARTY_ACADIA_ALLOCATION_MODEL'', ''TRIPARTY_ALLOCATION_MODEL'')) and mcc_id in (select mcc_id from collateral_config_field_temp)')
end

begin
exec('drop table collateral_config_field_temp')
end






