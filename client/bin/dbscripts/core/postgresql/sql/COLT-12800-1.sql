create table collateral_config_field_Dummy AS (select * from collateral_config_field where mcc_field='ACADIA_AUTO_DISPUTE')
;
insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (
select distinct mcc_id,'ACADIA_CALL_ABOVE_TOLERANCE' Col1, 'false' col2 from collateral_config_field_Dummy where mcc_field in ('ACADIA_AUTO_DISPUTE') and lower(mcc_value)='false'
union all
select distinct mcc_id,'ACADIA_CALL_ABOVE_TOLERANCE' Col1, 'true' col2 from collateral_config_field_Dummy where mcc_field in ('ACADIA_AUTO_DISPUTE') and lower(mcc_value)='true'
union all
select distinct mcc_id,'ACADIA_CALL_NOTIFICATION_TIME' Col1, 'No STP' col2 from collateral_config_field_Dummy where mcc_field in ('ACADIA_AUTO_DISPUTE'))
;
drop table  collateral_config_field_Dummy
;