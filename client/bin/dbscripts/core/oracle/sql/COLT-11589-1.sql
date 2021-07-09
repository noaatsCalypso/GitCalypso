delete from collateral_config_field where mcc_field in ('TRIPARTY_ACADIA_CALCULATION_TYPE', 'TRIPARTY_ACADIA_ALLOCATION_MODEL', 'TRIPARTY_CALCULATION_TYPE', 'TRIPARTY_ALLOCATION_MODEL') and mcc_value is null
/
create table collateral_config_field_temp AS ( select * from collateral_config_field where collateral_config_field.mcc_id in (select mcc_id from collateral_config where triparty_b=1) and collateral_config_field.mcc_field='TRIPARTY_ACADIA_MESSAGING' and collateral_config_field.mcc_value='true')
/
insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (select distinct mcc_id,'TRIPARTY_ACADIA_CALCULATION_TYPE', 'Delta' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in ('TRIPARTY_ACADIA_CALCULATION_TYPE', 'TRIPARTY_ACADIA_ALLOCATION_MODEL','TRIPARTY_CALCULATION_TYPE', 'TRIPARTY_ALLOCATION_MODEL')) and mcc_id in (select mcc_id from collateral_config_field_temp))
/
insert into collateral_config_field  (mcc_id, mcc_field, mcc_value) (select distinct mcc_id,'TRIPARTY_ACADIA_ALLOCATION_MODEL', 'MT569' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in ('TRIPARTY_ACADIA_ALLOCATION_MODEL','TRIPARTY_CALCULATION_TYPE', 'TRIPARTY_ALLOCATION_MODEL')) and mcc_id in (select mcc_id from collateral_config_field_temp))
/
drop table collateral_config_field_temp
/
create table collateral_config_field_temp AS (select * from collateral_config_field where collateral_config_field.mcc_id in (select mcc_id from collateral_config where triparty_b=1) and collateral_config_field.mcc_field='TRIPARTY_ACADIA_MESSAGING' and collateral_config_field.mcc_value='false')
/
insert into collateral_config_field  (mcc_id, mcc_field, mcc_value) (select distinct mcc_id, 'TRIPARTY_CALCULATION_TYPE', 'Net Exposure' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in ('TRIPARTY_ACADIA_CALCULATION_TYPE', 'TRIPARTY_ACADIA_ALLOCATION_MODEL','TRIPARTY_CALCULATION_TYPE', 'TRIPARTY_ALLOCATION_MODEL')) and mcc_id in (select mcc_id from collateral_config_field_temp))
/
insert into collateral_config_field  (mcc_id, mcc_field, mcc_value) (select distinct mcc_id, 'TRIPARTY_ALLOCATION_MODEL', 'Import MT569' from collateral_config_field where mcc_id not in (select mcc_id from collateral_config_field where mcc_field in ('TRIPARTY_ACADIA_CALCULATION_TYPE', 'TRIPARTY_ACADIA_ALLOCATION_MODEL', 'TRIPARTY_ALLOCATION_MODEL')) and mcc_id in (select mcc_id from collateral_config_field_temp))
/
drop table collateral_config_field_temp
/ 
