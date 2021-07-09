if exists (select 1 from sysobjects where name = 'collateral_config_field_dummy')
begin
drop table collateral_config_field_dummy
end
go

if not exists (select 1 from sysobjects where name = 'collateral_config_field_dummy')
begin
select * into collateral_config_field_dummy from collateral_config_field where mcc_field='ACADIA_AUTO_DISPUTE'
end 
go

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config_field_dummy' AND syscolumns.name = 'mcc_field')
BEGIN

insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (
select distinct mcc_id,'ACADIA_CALL_ABOVE_TOLERANCE' Col1, 'false' col2 from collateral_config_field_dummy where mcc_field in ('ACADIA_AUTO_DISPUTE') and lower(mcc_value)='false')

insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (
select distinct mcc_id,'ACADIA_CALL_ABOVE_TOLERANCE' Col1, 'true' col2 from collateral_config_field_dummy where mcc_field in ('ACADIA_AUTO_DISPUTE') and lower(mcc_value)='true')

insert into collateral_config_field (mcc_id, mcc_field, mcc_value) (
select distinct mcc_id,'ACADIA_CALL_NOTIFICATION_TIME' Col1, 'No STP' col2 from collateral_config_field_dummy where mcc_field in ('ACADIA_AUTO_DISPUTE'))

end

go

if exists (select 1 from sysobjects where name = 'collateral_config_field_dummy')
begin
drop table collateral_config_field_dummy
end

go


