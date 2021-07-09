add_column_if_not_exists 'collateral_config','po_haircut_type', 'varchar(32) null'
go

add_column_if_not_exists 'collateral_config','le_haircut_type', 'varchar(32) null'
go

add_column_if_not_exists 'exposure_group_definition','le_haircut_type', 'varchar(32) null'
go

UPDATE collateral_config SET po_haircut_type = haircut_type, le_haircut_type = haircut_type FROM mrgcall_config WHERE mrgcall_config.mrg_call_def = collateral_config.mcc_id and po_haircut_type is null and le_haircut_type is null
go
if exists (select 1 from sysobjects where sysobjects.name = 'exposure_group_definition')
begin
UPDATE exposure_group_definition SET le_haircut_type = haircut_type where le_haircut_type is null
end
go
