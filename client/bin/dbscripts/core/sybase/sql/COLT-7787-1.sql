if not exists (select 1 from sysobjects where name='module_upgrade_scripts' and type='U')
	execute ('create table module_upgrade_scripts (name varchar(128) not null, module_name varchar(128), user_name varchar(128), execution_date date)')
declare @v_sync varchar(255)
select @v_sync = 'schema-synchronization'
execute ('delete from module_upgrade_scripts where name = @v_sync')
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_1.03.03_WorkflowEntity.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
declare @v_max_state_id_theoretical int
declare @v_max_state_id_actual int
declare @v_entity_type varchar(255)
select @v_max_state_id_actual = ISNULL(max(state_id),0) from entity_state
select @v_max_state_id_theoretical = last_id from calypso_seed where seed_name = 'workflow' 
IF @v_max_state_id_actual>@v_max_state_id_theoretical 
BEGIN 
	UPDATE calypso_seed SET last_id = @v_max_state_id_actual where seed_name = 'workflow'
	commit
END
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_1.04.00_TargetConfiguration.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
if exists (select 1 from sysobjects where name='target_configuration' and type='U')
	if exists (select 1 from sysobjects where name='optimization_configuration' and type='U')
		IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'optimization_configuration' AND syscolumns.name = 'target_id') 
			begin 
				execute ('alter table target_configuration add id int default 0 not null, version int default 0 not null, name varchar(128) default "", description varchar(256) default ""') 
				execute ('ALTER TABLE optimization_configuration ADD target_id int default 0 not null') 
				execute ('UPDATE target_configuration SET id = config_id, name = type') 
				execute ('UPDATE optimization_configuration SET target_id = id') 
			end
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_1.05.08_AllocationRuleTarget.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
if exists (select 1 from sysobjects where name='target_configuration' and type='U')
	if exists (select 1 from sysobjects where name='optimization_configuration' and type='U')
	begin
		declare @cnt int
		select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'optimization_configuration' and syscolumns.name = 'optimization_type'
		if @cnt=0
			execute('alter table optimization_configuration add optimization_type varchar(64)')
		select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'optimization_configuration' and syscolumns.name = 'target_id'
		if @cnt=0
			execute('alter table optimization_configuration add target_id int')
		select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'optimization_configuration' and syscolumns.name = 'optimizer'
		if @cnt=0
			execute('alter table optimization_configuration add optimizer varchar(64)')
		execute('UPDATE target_configuration SET type = ''Distribution-rule'' WHERE type = ''Allocation-rule'' AND id in (SELECT target_id FROM optimization_configuration WHERE optimization_type IN (''CoverDistribution'',''FinalDistribution''))')
		execute('UPDATE optimization_configuration SET optimizer = ''Distribution-rule'' WHERE optimizer = ''Allocation-rule'' and optimization_type IN (''CoverDistribution'',''FinalDistribution'')')
	end
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
if not exists (select 1 from sysobjects where name='module_upgrade_scripts' and type='U')
	execute('create table module_upgrade_scripts (name varchar(128) not null, module_name varchar(128), user_name varchar(128), execution_date date)')
go
IF OBJECT_ID('add_column_if_not_exists') IS NOT NULL
	drop procedure add_column_if_not_exists
go
CREATE PROCEDURE add_column_if_not_exists (@table_name varchar(255), @column_name varchar(255) , @datatype varchar(255))
as
begin
	declare @cnt int
	select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
	if @cnt=0
		execute('alter table ' + @table_name + ' add '+ @column_name +' ' + @datatype)
end
if not exists (select 1 from sysobjects where sysobjects.name = 'mrgcall_config')
	execute('create table mrgcall_config (mrg_call_def numeric null)')
go
go
add_column_if_not_exists 'mrgcall_config', 'account_id', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'additional_fields', 'image null' 
go
add_column_if_not_exists 'mrgcall_config', 'agency_list', 'varchar(255) null'
go
add_column_if_not_exists 'mrgcall_config', 'book_list', 'varchar(1024) null'
go
add_column_if_not_exists 'mrgcall_config', 'clearing_member_id', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'collateral_dates', 'image null'
go
add_column_if_not_exists 'mrgcall_config', 'concentration_position', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'concentration_side', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'contract_direction', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'contract_dispute_tol_amount', 'float null'
go
add_column_if_not_exists 'mrgcall_config', 'contract_dispute_tol_perc_b', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'credit_multiplier', ' float null'
go
add_column_if_not_exists 'mrgcall_config', 'eligibility_filters', 'image null'
go
add_column_if_not_exists 'mrgcall_config', 'exclude_from_optimizer', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'exposure_type_list', 'varchar(1024) null'
go
add_column_if_not_exists 'mrgcall_config', 'is_initial_margin', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'le_ia_rating_direction', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'le_mta_currency', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'le_rating_config', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'le_thres_currency', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'notes', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'po_ia_rating_direction', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'po_mta_currency', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'po_rating_config', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'po_thres_currency', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'position_date_type', 'varchar(128) null'
alter table mrgcall_config replace position_date_type default 'POSITION_DATE_DEFAULT'
go
update mrgcall_config set position_date_type = 'POSITION_DATE_DEFAULT' where position_date_type is null
go
add_column_if_not_exists 'mrgcall_config', 'position_type', 'varchar(128) null'
alter table mrgcall_config replace position_type default 'THEORETICAL'
go
update mrgcall_config set position_type = 'THEORETICAL' where position_type is null
go
add_column_if_not_exists 'mrgcall_config', 'rounding_before_mta_b', 'numeric null'
go
add_column_if_not_exists 'mrgcall_config', 'secured_party', 'varchar(128) null'
go
add_column_if_not_exists 'mrgcall_config', 'substitution_context', 'varchar(128) null'
alter table mrgcall_config replace substitution_context default 'Pay Margin'
go
update mrgcall_config set substitution_context = 'Pay Margin' where substitution_context is null
go
add_column_if_not_exists 'mrgcall_config', 'substitution_level', 'varchar(128) null'
alter table mrgcall_config replace substitution_level default 'Inherited from Optimization Configuration'
go
update mrgcall_config set substitution_level = 'Inherited from Optimization Configuration' where substitution_level is null
go
add_column_if_not_exists 'mrgcall_config', 'substitution_type', 'varchar(128) null'
alter table mrgcall_config replace substitution_type default 'Never'
go
update mrgcall_config set substitution_type = 'Never' where substitution_type is null
go
add_column_if_not_exists 'mrgcall_config', 'parent_id', 'numeric null'
go
if not exists (select 1 from sysobjects where sysobjects.name = 'collateral_config')
	execute('create table collateral_config (mcc_id numeric null)')
go
add_column_if_not_exists 'collateral_config', 'wf_product', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config', 'wf_subtype', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config', 'perimeter_type', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config', 'po_ia_direction', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config', 'le_ia_direction', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config', 'settlement_offset', 'numeric null'
go
add_column_if_not_exists 'collateral_config', 'settlement_holidays', 'varchar(128) null'
go
if not exists (select 1 from sysobjects where sysobjects.name = 'collateral_config_new_migrated')
	execute('create table collateral_config_new_migrated (mcc_id numeric null)')
go
add_column_if_not_exists 'collateral_config_new_migrated', 'account_id', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'additional_fields', 'image null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'agency_list', 'varchar(255) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'book_list', 'varchar(1024) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'clearing_member_id', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'collateral_dates', 'image null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'concentration_position', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'concentration_side', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'contract_direction', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'contract_dispute_tol_amount', 'float null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'contract_dispute_tol_perc_b', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'credit_multiplier', ' float null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'eligibility_filters', 'image null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'exclude_from_optimizer', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'exposure_type_list', 'varchar(1024) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'is_initial_margin', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'le_ia_rating_direction', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'le_mta_currency', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'le_rating_config', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'le_thres_currency', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'notes', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'po_ia_rating_direction', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'po_mta_currency', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'po_rating_config', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'po_thres_currency', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'position_date_type', 'varchar(128) null'
alter table collateral_config_new_migrated replace position_date_type default 'POSITION_DATE_DEFAULT'
go
update collateral_config_new_migrated set position_date_type = 'POSITION_DATE_DEFAULT' where position_date_type is null
go
add_column_if_not_exists 'collateral_config_new_migrated', 'position_type', 'varchar(128) null'
alter table collateral_config_new_migrated replace position_type default 'THEORETICAL'
go
update collateral_config_new_migrated set position_type = 'THEORETICAL' where position_type is null
go
add_column_if_not_exists 'collateral_config_new_migrated', 'rounding_before_mta_b', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'secured_party', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'substitution_context', 'varchar(128) null'
alter table collateral_config_new_migrated replace substitution_context default 'Pay Margin'
go
update collateral_config_new_migrated set substitution_context = 'Pay Margin' where substitution_context is null
go
add_column_if_not_exists 'collateral_config_new_migrated', 'substitution_level', 'varchar(128) null'
alter table collateral_config_new_migrated replace substitution_level default 'Inherited from Optimization Configuration'
go
update collateral_config_new_migrated set substitution_level = 'Inherited from Optimization Configuration' where substitution_level is null
go
add_column_if_not_exists 'collateral_config_new_migrated',  'substitution_type', 'varchar(128) null'
alter table collateral_config_new_migrated replace substitution_type default 'Never'
go
update collateral_config_new_migrated set substitution_type = 'Never' where substitution_type is null
go
add_column_if_not_exists 'collateral_config_new_migrated', 'wf_product', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'wf_subtype', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'perimeter_type', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'po_ia_direction', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'le_ia_direction', 'varchar(128) null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'settlement_offset', 'numeric null'
go
add_column_if_not_exists 'collateral_config_new_migrated', 'settlement_holidays', 'varchar(128) null'
go
drop procedure add_column_if_not_exists
go
if not exists (select 1 from module_upgrade_scripts where name in ('upgrade_1.05.10_CollateralConfig_SchemaConflict.sql', 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql') and module_name = 'collateral')
BEGIN
	INSERT into collateral_config_new_migrated (
				mcc_id,
				account_id,
				additional_fields,
				agency_list,
				book_list,
				clearing_member_id,
				collateral_dates,
				concentration_position,
				concentration_side,
				contract_direction,
				contract_dispute_tol_amount,
				contract_dispute_tol_perc_b,
				credit_multiplier,
				eligibility_filters,
				exclude_from_optimizer,
				exposure_type_list,
				is_initial_margin,
				le_ia_rating_direction,
				le_mta_currency,
				le_rating_config,
				le_thres_currency,
				notes,
				po_ia_rating_direction,
				po_mta_currency,
				po_rating_config,
				po_thres_currency,
				position_date_type,
				position_type,
				rounding_before_mta_b,
				secured_party,
				substitution_context,
				substitution_level,
				substitution_type,
				wf_product,
				wf_subtype,
				perimeter_type,
				po_ia_direction,
				le_ia_direction,
				settlement_offset,			
				settlement_holidays
			) SELECT 
				mcc.mrg_call_def,
				mcc.account_id,
				cc.additional_fields,
				mcc.agency_list,
				mcc.book_list,
				mcc.clearing_member_id,
				cc.collateral_dates,
				mcc.concentration_position,
				mcc.concentration_side,
				mcc.contract_direction,
				mcc.contract_dispute_tol_amount,
				mcc.contract_dispute_tol_perc_b,
				mcc.credit_multiplier,
				cc.eligibility_filters,
				mcc.exclude_from_optimizer,
				mcc.exposure_type_list,
				mcc.is_initial_margin,
				mcc.le_ia_rating_direction,
				mcc.le_mta_currency,
				mcc.le_rating_config,
				mcc.le_thres_currency,
				mcc.notes,
				mcc.po_ia_rating_direction,
				mcc.po_mta_currency,
				mcc.po_rating_config,
				mcc.po_thres_currency,
				mcc.position_date_type,
				mcc.position_type,
				mcc.rounding_before_mta_b,
				mcc.secured_party,
				mcc.substitution_context,
				mcc.substitution_level,
				mcc.substitution_type,
				cc.wf_product,
				cc.wf_subtype,
				cc.perimeter_type,
				cc.po_ia_direction,
				cc.le_ia_direction,
				cc.settlement_offset,			
				cc.settlement_holidays
			FROM mrgcall_config mcc, collateral_config cc
			WHERE cc.mcc_id = mcc.mrg_call_def
	INSERT into collateral_config_new_migrated (
				mcc_id,
				account_id,
				additional_fields,
				agency_list,
				book_list,
				clearing_member_id,
				collateral_dates,
				concentration_position,
				concentration_side,
				contract_direction,
				contract_dispute_tol_amount,
				contract_dispute_tol_perc_b,
				credit_multiplier,
				eligibility_filters,
				exclude_from_optimizer,
				exposure_type_list,
				is_initial_margin,
				le_ia_rating_direction,
				le_mta_currency,
				le_rating_config,
				le_thres_currency,
				notes,
				po_ia_rating_direction,
				po_mta_currency,
				po_rating_config,
				po_thres_currency,
				position_date_type,
				position_type,
				rounding_before_mta_b,
				secured_party,
				substitution_context,
				substitution_level,
				substitution_type
			) SELECT 
				mrg_call_def,
				account_id,
				additional_fields,
				agency_list,
				book_list,
				clearing_member_id,
				collateral_dates,
				concentration_position,
				concentration_side,
				contract_direction,
				contract_dispute_tol_amount,
				contract_dispute_tol_perc_b,
				credit_multiplier,
				eligibility_filters,
				exclude_from_optimizer,
				exposure_type_list,
				is_initial_margin,
				le_ia_rating_direction,
				le_mta_currency,
				le_rating_config,
				le_thres_currency,
				notes,
				po_ia_rating_direction,
				po_mta_currency,
				po_rating_config,
				po_thres_currency,
				position_date_type,
				position_type,
				rounding_before_mta_b,
				secured_party,
				substitution_context,
				substitution_level,
				substitution_type
			FROM mrgcall_config
			WHERE NOT EXISTS (SELECT collateral_config.mcc_id FROM collateral_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def)
	drop table collateral_config
	execute('sp_rename  collateral_config_new_migrated, collateral_config')
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values ('upgrade_1.05.10_CollateralConfig_SchemaConflict.sql', 'collateral', user_name(), getDate())
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values ('upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql', 'collateral', user_name(), getDate())
END
go

	execute('ALTER TABLE  collateral_config  MODIFY concentration_position varchar(16) null')
	execute('ALTER TABLE  collateral_config  MODIFY concentration_side varchar(16) null')
	execute('ALTER TABLE  collateral_config  MODIFY contract_direction varchar(32) null')
	execute('ALTER TABLE  collateral_config  MODIFY le_mta_currency varchar(3) null')
	execute('ALTER TABLE  collateral_config  MODIFY le_thres_currency varchar(3) null')
	execute('ALTER TABLE  collateral_config  MODIFY po_mta_currency varchar(3) null')
	execute('ALTER TABLE  collateral_config  MODIFY po_thres_currency varchar(3) null')
	execute('ALTER TABLE  collateral_config  MODIFY position_date_type varchar(32) null')
	execute('ALTER TABLE  collateral_config  MODIFY secured_party varchar(32) null')
	execute('ALTER TABLE  collateral_config  MODIFY position_type varchar(16) null')
	execute('ALTER TABLE  collateral_config  MODIFY substitution_level varchar(64) null')
	execute('ALTER TABLE  collateral_config  MODIFY wf_product varchar(32) null')
	execute('ALTER TABLE  collateral_config  MODIFY wf_subtype varchar(32) null')
	execute('ALTER TABLE  collateral_config  MODIFY po_ia_direction varchar(32) null')
	execute('ALTER TABLE  collateral_config  MODIFY le_ia_direction varchar(32) null')

	if  exists (select 1 from sysobjects as sysobjects, syscolumns as syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' and syscolumns.name = 'po_mta_perc_basis')
	BEGIN
		execute('ALTER TABLE  collateral_config  MODIFY po_mta_perc_basis varchar(32) null')
		execute('ALTER TABLE  collateral_config  MODIFY le_mta_perc_basis varchar(32) null')
		execute('ALTER TABLE  collateral_config  MODIFY po_thresh_perc_basis varchar(32) null')
		execute('ALTER TABLE  collateral_config  MODIFY le_thresh_perc_basis varchar(32) null')
	END

if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	alter table collateral_config replace position_date_type default 'POSITION_DATE_DEFAULT'
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	update collateral_config set position_date_type = 'POSITION_DATE_DEFAULT' where position_date_type is null
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	alter table collateral_config replace position_type default 'THEORETICAL'
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	update collateral_config set position_type = 'THEORETICAL' where position_type is null
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	alter table collateral_config replace substitution_context default 'Pay Margin'
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	update collateral_config set substitution_context = 'Pay Margin' where substitution_context is null
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	alter table collateral_config replace substitution_level default 'Inherited from Optimization Configuration'
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	update collateral_config set substitution_level = 'Inherited from Optimization Configuration' where substitution_level is null
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	alter table collateral_config replace substitution_type default 'Never'
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	update collateral_config set substitution_type = 'Never' where substitution_type is null
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql' and module_name = 'collateral')
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values ('upgrade_1.05.10_CollateralConfig_SchemaConflict_v2.sql', 'collateral', user_name(), getDate())
go
IF NOT EXISTS(SELECT 1 FROM sysobjects WHERE sysobjects.name = 'eligible_books_kv')
	execute('create table eligible_books_kv (id int not null, name VARCHAR(255) not null, type VARCHAR(255) not null, value VARCHAR(255) not null, internal_id int not null)')
go
IF NOT EXISTS(SELECT 1 FROM calypso_seed WHERE seed_name = 'collateral-key-value')
begin
insert into calypso_seed (last_id, seed_name, seed_alloc_size) values (1, 'collateral-key-value', 500)
end
go
DECLARE intern_cur CURSOR FOR 
    SELECT last_id from calypso_seed where seed_name = 'collateral-key-value'
go
DECLARE cur CURSOR FOR  
SELECT A.mrg_call_def, A.parent_id FROM mrgcall_config A
go
IF OBJECT_ID('insertRow') IS NOT NULL
	drop procedure insertRow
go
CREATE PROCEDURE insertRow
    @m_id int, 
    @m_name varchar(50),
    @m_type varchar(50),
    @m_value varchar(50),
    @m_internid int
AS
    insert into eligible_books_kv (id, name, type, value, internal_id) values (@m_id, @m_name, @m_type, @m_value, @m_internid)
go 
IF OBJECT_ID('updateSeed') IS NOT NULL
	drop procedure updateSeed
go
CREATE PROCEDURE updateSeed
	@m_internid int
As
	update calypso_seed set last_id = @m_internid where seed_name = 'collateral-key-value'
go
if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.05.10_EligibleBooks.sql' and module_name = 'collateral')
begin
DECLARE @my_id int
DECLARE @my_parent_id int
DECLARE @my_type VARCHAR(50)
DECLARE @my_type_string VARCHAR(50)
DECLARE @my_name VARCHAR(50)
DECLARE @my_book_name VARCHAR(50)
DECLARE @my_type_enum VARCHAR(50)
DECLARE @my_all_books VARCHAR(50)
DECLARE @my_key_id VARCHAR(50)
DECLARE @my_type_integer VARCHAR(50)
DECLARE @my_legal_entity_type VARCHAR(50)
DECLARE @my_attribute VARCHAR(50)
DECLARE @my_value VARCHAR(50)
DECLARE @my_true VARCHAR(50)
DECLARE @my_collateral_holding VARCHAR(50)
DECLARE @my_po_contract VARCHAR(50)
DECLARE @my_parent_po_contract VARCHAR(50)
DECLARE @my_po_parent_contract VARCHAR(50)
DECLARE @my_parent_po_parent_contract VARCHAR(50)
DECLARE @my_sql_request VARCHAR(5000)
DECLARE @ParmDefinition varchar(500)
DECLARE @my_id_str VARCHAR(50)
SET @my_type = 'Type'
SET @my_type_string = 'TYPE_STRING'
SET @my_name = 'Name'
SET @my_book_name = 'Book name'
SET @my_type_enum = 'TYPE_ENUM'
SET @my_all_books = 'All Books in perimeter'
SET @my_key_id = 'Key Id'
SET @my_type_integer = 'TYPE_INTEGER'
SET @my_legal_entity_type = 'Legal Entity Books'
SET @my_attribute = 'Attribute'
SET @my_collateral_holding = 'CollateralHolding'
SET @my_po_contract = 'Contract - PO books'
SET @my_parent_po_contract = 'Contract - Parent LE books'
SET @my_po_parent_contract = 'Parent contract - PO books'
SET @my_parent_po_parent_contract= 'Parent contract - Parent LE books'
SET @my_true = 'true'
SET @my_value = 'Value'
DECLARE @my_internal_id int
OPEN intern_cur
FETCH NEXT FROM intern_cur INTO @my_internal_id
CLOSE intern_cur
OPEN cur   
FETCH NEXT FROM cur INTO @my_id, @my_parent_id
WHILE @@FETCH_STATUS = 0   
BEGIN 
SET @my_id_str = convert(VARCHAR(50), @my_id)
if @my_parent_id < 0
begin
EXECUTE insertRow @my_id, @my_type, @my_type_string, @my_name, @my_internal_id
EXECUTE insertRow @my_id, @my_book_name, @my_type_enum, @my_all_books, @my_internal_id
EXECUTE insertRow @my_id, @my_key_id, @my_type_integer, @my_id_str, @my_internal_id
EXECUTE insertRow @my_id, @my_legal_entity_type, @my_type_enum, @my_po_contract, @my_internal_id
SET @my_internal_id = @my_internal_id + 1
EXECUTE insertRow @my_id, @my_type, @my_type_string, @my_attribute, @my_internal_id
EXECUTE insertRow @my_id, @my_attribute, @my_type_string, @my_collateral_holding, @my_internal_id
EXECUTE insertRow @my_id, @my_value, @my_type_string, @my_true, @my_internal_id
EXECUTE insertRow @my_id, @my_key_id, @my_type_integer, @my_id_str, @my_internal_id
EXECUTE insertRow @my_id, @my_legal_entity_type, @my_type_enum, @my_parent_po_contract, @my_internal_id
SET @my_internal_id = @my_internal_id + 1
end
else
begin
EXECUTE insertRow @my_id, @my_type, @my_type_string, @my_name, @my_internal_id
EXECUTE insertRow @my_id, @my_book_name, @my_type_enum, @my_all_books, @my_internal_id
EXECUTE insertRow @my_id, @my_key_id, @my_type_integer, @my_id_str, @my_internal_id
EXECUTE insertRow @my_id, @my_legal_entity_type, @my_type_enum, @my_po_parent_contract, @my_internal_id
SET @my_internal_id = @my_internal_id + 1
EXECUTE insertRow @my_id, @my_type, @my_type_string, @my_attribute, @my_internal_id
EXECUTE insertRow @my_id, @my_attribute, @my_type_string, @my_collateral_holding, @my_internal_id
EXECUTE insertRow @my_id, @my_value, @my_type_string, @my_true, @my_internal_id
EXECUTE insertRow @my_id, @my_key_id, @my_type_integer, @my_id_str, @my_internal_id
EXECUTE insertRow @my_id, @my_legal_entity_type, @my_type_enum, @my_parent_po_parent_contract, @my_internal_id
SET @my_internal_id = @my_internal_id + 1
end
FETCH NEXT FROM cur INTO @my_id, @my_parent_id 
END
SET @my_internal_id = @my_internal_id + 500
EXECUTE updateSeed @my_internal_id
CLOSE cur   
insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values ('upgrade_1.05.10_EligibleBooks.sql', 'collateral', user_name(), getDate())
end
drop proc insertRow
drop proc updateSeed
DEALLOCATE cur
DEALLOCATE intern_cur
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_1.05.11_CollateralConfig_IntradayPricingEnv_v01.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
	if not exists (select 1 from sysobjects where sysobjects.name = 'collateral_config')
		execute('create table collateral_config (mcc_id numeric null, intraday_pricing_env_name varchar(128) null)')
	else if not exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' and syscolumns.name = 'intraday_pricing_env_name') 
		execute('alter table collateral_config add intraday_pricing_env_name varchar(128) null')
		if not exists (select 1 from sysobjects where sysobjects.name = 'clearing_member_configuration')
		begin		
			execute('update collateral_config set
					collateral_config.intraday_pricing_env_name = clearing_member_configuration.intraday_pricing_env_name
					from collateral_config left outer join clearing_member_configuration
					on collateral_config.clearing_member_id = clearing_member_configuration.id')
		end
		
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_1.06.00_CollateralConfig_SettlementOffset.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_1.06.00_mrgcall_config_currency_SchemaChange.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
if exists (select 1 from sysobjects where sysobjects.name = 'mrgcall_config_currency')
begin
	if exists (select 1 from sysobjects where sysobjects.name = 'collateral_config_currency')
		begin
		      declare @cnt int
		      select @cnt=count(*) from collateral_config_currency
              if @cnt<=0
                begin			  
					execute('drop table collateral_config_currency')
					execute ('sp_rename mrgcall_config_currency, collateral_config_currency')
				end	
		end
end
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_1.06.03_mrgcall_field_SchemaChange.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
if exists (select 1 from sysobjects where sysobjects.name = 'mrgcall_field')
begin
	if exists (select 1 from sysobjects where sysobjects.name = 'collateral_config_field')
		execute('drop table collateral_config_field')
	execute ('sp_rename mrgcall_field, collateral_config_field')
end
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
if not exists (select 1 from sysobjects where name='module_upgrade_scripts' and type='U')
	execute('create table module_upgrade_scripts (name varchar(128) not null, module_name varchar(128), user_name varchar(128), execution_date date)')
go
IF OBJECT_ID('add_column_if_not_exists') IS NOT NULL
	drop procedure add_column_if_not_exists
go
CREATE PROCEDURE add_column_if_not_exists (@table_name varchar(255), @column_name varchar(255) , @datatype varchar(255))
as
begin
	declare @cnt int
	select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
	if @cnt=0
		execute('alter table ' + @table_name + ' add '+ @column_name +' ' + @datatype)
end
go
add_column_if_not_exists 'collateral_config', 'po_mta_perc_basis', 'varchar(32) null'
go

add_column_if_not_exists 'collateral_config', 'le_mta_perc_basis', 'varchar(32) null'
go

add_column_if_not_exists 'collateral_config', 'po_thresh_perc_basis', 'varchar(32) null'
go

add_column_if_not_exists 'collateral_config', 'le_thresh_perc_basis', 'varchar(32) null'
go

	if exists (select 1 from sysobjects where sysobjects.name = 'mrgcall_credit_rating')
		 begin
			execute('add_column_if_not_exists ''mrgcall_credit_rating'', ''threshold_percent_basis'', ''varchar(32) null''')
			execute('add_column_if_not_exists ''mrgcall_credit_rating'', ''mta_percent_basis'', ''varchar(32) null''')
			execute('add_column_if_not_exists ''mrgcall_credit_rating'', ''ia_percent_basis'', ''varchar(32) null''') 
	end

if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_1.06.04_percent_basis.sql' and module_name = 'collateral')
begin
execute('update collateral_config set po_mta_perc_basis = ''MARGIN_CALL'' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''MC_PERCENT'')')
execute('update collateral_config set po_mta_perc_basis = ''SEC_FIN_SECURITY_VALUE'' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''DIRTY_PERCENT'')')
execute('update collateral_config set po_mta_perc_basis = ''NOMINAL'' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''NOMINAL_PERCENT'')')
execute('update collateral_config set po_mta_perc_basis = ''PRINCIPAL_AMOUNT'' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''PERCENT'')')
execute('update mrgcall_config set po_mta_type = ''PERCENT'' where po_mta_type in (''MC_PERCENT'', ''DIRTY_PERCENT'', ''NOMINAL_PERCENT'')')

execute('update collateral_config set le_mta_perc_basis = ''MARGIN_CALL'' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''MC_PERCENT'')')
execute('update collateral_config set le_mta_perc_basis = ''SEC_FIN_SECURITY_VALUE'' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''DIRTY_PERCENT'')')
execute('update collateral_config set le_mta_perc_basis = ''NOMINAL'' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''NOMINAL_PERCENT'')')
execute('update collateral_config set le_mta_perc_basis = ''PRINCIPAL_AMOUNT'' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''PERCENT'')')
execute('update mrgcall_config set le_mta_type = ''PERCENT'' where le_mta_type in (''MC_PERCENT'', ''DIRTY_PERCENT'', ''NOMINAL_PERCENT'')')

execute('update collateral_config set po_thresh_perc_basis = ''MARGIN_CALL'' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''MC_PERCENT'')')
execute('update collateral_config set po_thresh_perc_basis = ''SEC_FIN_SECURITY_VALUE'' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''DIRTY_PERCENT'')')
execute('update collateral_config set po_thresh_perc_basis = ''NOMINAL'' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''NOMINAL_PERCENT'')')
execute('update collateral_config set po_thresh_perc_basis = ''PRINCIPAL_AMOUNT'' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''PERCENT'')')
execute('update mrgcall_config set po_thres_type = ''PERCENT'' where po_thres_type in ('' MC_PERCENT'', ''DIRTY_PERCENT'', ''NOMINAL_PERCENT'')')

execute('update collateral_config set le_thresh_perc_basis = ''MARGIN_CALL'' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = '' MC_PERCENT'')')
execute('update collateral_config set le_thresh_perc_basis = ''SEC_FIN_SECURITY_VALUE'' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = ''DIRTY_PERCENT'')')
execute('update collateral_config set le_thresh_perc_basis = '' NOMINAL'' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = ''NOMINAL_PERCENT'')')
execute('update collateral_config set le_thresh_perc_basis = ''PRINCIPAL_AMOUNT'' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = ''PERCENT'')')
execute('update mrgcall_config set le_thres_type = ''PERCENT'' where le_thres_type in (''MC_PERCENT'', ''DIRTY_PERCENT'', ''NOMINAL_PERCENT'')')

if exists (select 1 from sysobjects where sysobjects.name = 'mrgcall_credit_rating')
BEGIN
execute('update mrgcall_credit_rating set threshold_percent_basis = ''MARGIN_CALL'' where threshold_type = ''MC_PERCENT''')
execute('update mrgcall_credit_rating set threshold_percent_basis = ''SEC_FIN_SECURITY_VALUE'' where threshold_type = ''DIRTY_PERCENT ''')
execute('update mrgcall_credit_rating set threshold_percent_basis = ''NOMINAL'' where threshold_type = ''NOMINAL_PERCENT''')
execute('update mrgcall_credit_rating set threshold_percent_basis = ''PRINCIPAL_AMOUNT'' where threshold_type = ''PERCENT''')
execute('update mrgcall_credit_rating set threshold_type = ''PERCENT'' where threshold_type in (''MC_PERCENT'', ''DIRTY_PERCENT'', ''NOMINAL_PERCENT'')')

execute('update mrgcall_credit_rating set mta_percent_basis = ''MARGIN_CALL'' where mta_type = ''MC_PERCENT''')
execute('update mrgcall_credit_rating set mta_percent_basis = ''SEC_FIN_SECURITY_VALUE'' where mta_type = ''DIRTY_PERCENT''')
execute('update mrgcall_credit_rating set mta_percent_basis = ''NOMINAL'' where mta_type = ''NOMINAL_PERCENT''')
execute('update mrgcall_credit_rating set mta_percent_basis = ''PRINCIPAL_AMOUNT'' where mta_type = ''PERCENT''')
execute('update mrgcall_credit_rating set mta_type = ''PERCENT'' where mta_type in (''MC_PERCENT'', ''DIRTY_PERCENT'', ''NOMINAL_PERCENT'')')

execute('update mrgcall_credit_rating set ia_percent_basis = ''MARGIN_CALL'' where ia_type = ''MC_PERCENT''')
execute('update mrgcall_credit_rating set ia_percent_basis = ''SEC_FIN_SECURITY_VALUE'' where ia_type = ''DIRTY_PERCENT''')
execute('update mrgcall_credit_rating set ia_percent_basis = ''NOMINAL'' where ia_type = ''NOMINAL_PERCENT''')
execute('update mrgcall_credit_rating set ia_percent_basis = ''PRINCIPAL_AMOUNT'' where ia_type = ''PERCENT''')
execute('update mrgcall_credit_rating set ia_type = ''PERCENT'' where ia_type in (''MC_PERCENT'', ''DIRTY_PERCENT'', ''NOMINAL_PERCENT'')')
END
insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values ('upgrade_1.06.04_percent_basis.sql', 'collateral', user_name(), getDate())
end
go

if not exists (select 1 from sysobjects where sysobjects.name = 'margin_call_entries')
begin
	execute('create table margin_call_entries (id numeric)')
end
go

if not exists(select 1 from sysobjects, syscolumns where sysobjects.id = syscolumns.id AND sysobjects.name = 'margin_call_entries' AND syscolumns.name = 'collateral_context_id') 
	begin 
		execute ('alter table margin_call_entries add collateral_context_id int default 0') 
	end

if not exists(select 1 from sysobjects, syscolumns where sysobjects.id = syscolumns.id AND sysobjects.name = 'margin_call_entries' AND syscolumns.name = 'collateral_context_name') 
	begin 
		execute ('alter table margin_call_entries add collateral_context_name varchar(128) null') 
	end
go

if exists (select 1 from sysobjects where name='collateral_context' and type='U')
BEGIN
        if exists (select 1 from sysobjects where name='margin_call_entries' and type='U')

                begin
                        if not exists(select 1 from sysobjects, syscolumns where sysobjects.id = syscolumns.id AND sysobjects.name = 'margin_call_entries' AND syscolumns.name = 'collateral_context_id') 
                                begin 
                                        execute ('alter table margin_call_entries add collateral_context_id int default 0') 
                                end
                        if not exists(select 1 from sysobjects, syscolumns where sysobjects.id = syscolumns.id AND sysobjects.name = 'margin_call_entries' AND syscolumns.name = 'collateral_context_name') 
                                begin 
                                        execute ('alter table margin_call_entries add collateral_context_name varchar(128) null') 
                                end
                        if exists(select 1 from margin_call_entries where collateral_context_id is null)
                                begin
                                        declare @v_default_context_id int, @v_default_context_name varchar(128)
                                        begin
if exists (select 1 from sysobjects where name='collateral_context' and type='U')
BEGIN
                                                execute('select @v_default_context_id=id from collateral_context where is_default = 1')
                                               execute('select @v_default_context_name=name from collateral_context where is_default = 1')
                                                execute(' update margin_call_entries set collateral_context_id = @v_default_context_id, collateral_context_name = @v_default_context_name where collateral_context_id is null')
END
                                                insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values ('upgrade_2.00.00_Entry_with_default_context.sql', 'collateral', user_name(), getDate())
                                        end
                                end
                end
END

go
if not exists (select 1 from sysobjects where name='module_upgrade_scripts' and type='U')
	execute('create table module_upgrade_scripts (name varchar(128) not null, module_name varchar(128), user_name varchar(128), execution_date date)')
go

if exists (select 1 from sysobjects where name='collateral_config' and type='U')
   IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.name = 'collateral_config' and syscolumns.name = 'val_time_offset_id' and sysobjects.id = syscolumns.id)
	execute('alter table collateral_config add val_time_offset_id numeric(18) default 0')
go

if exists (select 1 from sysobjects where name='optimization_configuration' and type='U')
IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.name = 'optimization_configuration' and syscolumns.name = 'optimization_date_offset' and sysobjects.id = syscolumns.id)
	execute('alter table optimization_configuration add optimization_date_offset numeric(18) default 0')
go

IF OBJECT_ID('date_rule_insert') IS NOT NULL
	drop procedure date_rule_insert
go
CREATE PROCEDURE date_rule_insert
@my_internal_id numeric(18) , 
    @my_rule_name varchar(50) ,
    @my_date_roll varchar(50) ,
    @my_rel_type varchar(50) 
AS
    insert into date_rule (date_rule_id, date_rule_name, date_rule_type, date_rule_month, date_rule_day, date_rule_rank, date_rule_weekday,add_days,bus_cal_b,check_holidays,date_roll,add_months,rel_type,version_num,add_bus_days_b) values (@my_internal_id, @my_rule_name, 10, 1, 0, 0, 0, 0, 1, 0, @my_date_roll, 0, @my_rel_type, 0, 0)
go

IF OBJECT_ID('rel_date_rule_insert') IS NOT NULL
	drop procedure rel_date_rule_insert
go
CREATE PROCEDURE rel_date_rule_insert
    @my_internal_id numeric(18), 
    @my_rule_name varchar(50),
	@my_offset numeric(18),
	@my_relrule numeric(18),
    @my_date_roll varchar(50),
    @my_rel_type varchar(50)
AS
    insert into date_rule (date_rule_id, date_rule_name, date_rule_type, date_rule_month, date_rule_day, date_rule_rank, date_rule_weekday, add_days, bus_cal_b, rel_rule, check_holidays, date_roll, add_months, rel_type, version_num, add_bus_days_b) values (@my_internal_id, @my_rule_name, 9, 1, 0, 0, 0, @my_offset, 1, @my_relrule, 0, @my_date_roll, 0, @my_rel_type, 0, 0)
go

IF OBJECT_ID('updateSeed') IS NOT NULL
	drop procedure updateSeed
go
CREATE PROCEDURE updateSeed
	@m_internid numeric(18)
As
	update calypso_seed set last_id = @m_internid where seed_name = 'refdata'
go

IF OBJECT_ID('updateMrgCallConfig') IS NOT NULL
	drop procedure updateMrgCallConfig
go
CREATE PROCEDURE updateMrgCallConfig
	@my_internal_id numeric(18)
As
	update mrgcall_config set date_rule_id = @my_internal_id where date_rule_id is null or date_rule_id = 0
go


IF OBJECT_ID('updateCollateralConfig') IS NOT NULL
                drop procedure updateCollateralConfig
go
if exists (select 1 from sysobjects where name='collateral_config' and type='U')
exec ('CREATE PROCEDURE updateCollateralConfig
                @my_internal_id numeric(18)
As
                update collateral_config set val_time_offset_id = @my_internal_id where val_time_offset_id = 0 or val_time_offset_id is null')
go

IF OBJECT_ID('updateOptimizationConfig') IS NOT NULL
                drop procedure updateOptimizationConfig
go
if exists (select 1 from sysobjects where name='optimization_configuration' and type='U')
BEGIN
execute('CREATE PROCEDURE updateOptimizationConfig
        @offset numeric(18)
As
        update optimization_configuration set optimization_date_offset = @offset')
END

if exists (select 1 from sysobjects where name='collateral_context' and type='U') 
BEGIN
		execute('DECLARE intern_cur CURSOR FOR 
			SELECT last_id from calypso_seed where seed_name = ''refdata''')
				

		execute('DECLARE valudate_cur CURSOR FOR 
			select value_date_days from collateral_context where is_default = 1')
END   

if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_2.00.00_valuation_time.sql' and module_name = 'collateral')
BEGIN
execute('insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (''upgrade_2.00.00_valuation_time.sql'', ''collateral'', user_name(), getDate())')
DECLARE @my_int1 numeric(18)
DECLARE @my_int500 numeric(18)
DECLARE @my_rule_name VARCHAR(50)
DECLARE @my_val_rule_name VARCHAR(50)
DECLARE @my_date_roll VARCHAR(50)
DECLARE @my_rel_type VARCHAR(50)
DECLARE @my_date_roll_prec VARCHAR(50)
DECLARE @my_offset numeric(18)
DECLARE @my_ref_data VARCHAR(50)
DECLARE @my_count numeric(18)
DECLARE @my_relrule numeric(18)
DECLARE @my_internal_id numeric(18)
DECLARE @value_date_days numeric(18)

SET @my_int1 = 1
SET @my_int500 = 500
SET @my_rule_name = 'COL_MIGR_DAILY_BUS'
SET @my_val_rule_name = 'COL_MIGR_VAL_REL'
SET @my_date_roll = 'FOLLOWING'
SET @my_rel_type = 'Absolute'
SET @my_date_roll_prec = 'PRECEDING'
SET @my_ref_data = 'refdata'


if exists (select 1 from sysobjects where name='collateral_context' and type='U')
begin

OPEN intern_cur
FETCH NEXT FROM intern_cur INTO @my_internal_id

OPEN valudate_cur
FETCH NEXT FROM valudate_cur INTO @value_date_days

exec date_rule_insert @my_internal_id, @my_rule_name,  @my_date_roll, @my_rel_type

SET @value_date_days = -1 * @value_date_days
SET @my_relrule = @my_internal_id
SET @my_internal_id = @my_internal_id+1

exec rel_date_rule_insert @my_internal_id, @my_val_rule_name, @value_date_days, @my_relrule, @my_date_roll_prec, @my_rel_type

SET @my_internal_id = @my_internal_id-1
exec updateMrgCallConfig @my_internal_id

SET @my_internal_id = @my_internal_id+1

IF OBJECT_ID('updateCollateralConfig') IS NOT NULL
exec updateCollateralConfig @my_internal_id

IF OBJECT_ID('updateOptimizationConfig') IS NOT NULL
begin
execute(' updateOptimizationConfig @value_date_days')
END

SET @my_internal_id = @my_internal_id+500
exec updateSeed @my_internal_id


drop proc date_rule_insert
drop proc rel_date_rule_insert
drop proc updateSeed
drop proc updateMrgCallConfig
drop proc p1

IF OBJECT_ID('updateCollateralConfig') IS NOT NULL
drop proc updateCollateralConfig

IF OBJECT_ID('updateOptimizationConfig') IS NOT NULL
drop proc updateCollateralConfig

CLOSE intern_cur
CLOSE valudate_cur

DEALLOCATE intern_cur
DEALLOCATE valudate_cur
end
end

if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_2.00.00_valuation_time.sql' and module_name = 'collateral')
BEGIN
execute('insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (''upgrade_2.00.00_valuation_time.sql'', ''collateral'', user_name(), getDate())')
END



go

declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_2.03.04_collateral_engine.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
begin
declare @c int
declare @n int
    select @n=isnull(max(engine_id)+1,0) from engine_config
                select @c=count(*) from engine_config where engine_name='CollateralManagementEngine'
                if @c = 0
                                INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'CollateralManagementEngine','Collateral Management Engine')
 
end
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
if not exists (select 1 from sysobjects where sysobjects.name = 'config_adhoc_details')
	execute('create table config_adhoc_details (id numeric null)')
go
go
add_column_if_not_exists 'config_adhoc_details', 'val_time', 'datetime null'
go
add_column_if_not_exists 'config_adhoc_details', 'val_time_seconds', 'numeric null'
go
add_column_if_not_exists 'collateral_config', 'val_time_seconds', 'numeric null'
go
add_column_if_not_exists 'collateral_config', 'notification_time_seconds', 'numeric null'
go
add_column_if_not_exists 'collateral_config', 'substitution_time_seconds', 'numeric null'
go

if not exists (select 1 from module_upgrade_scripts where name = 'upgrade_2.04.00_valuation_time_to_seconds.sql' and module_name = 'collateral')
BEGIN
	execute('update config_adhoc_details set val_time_seconds = isnull((datepart(ss, val_time) + 60 * datepart(mi, val_time) + 3600 * datepart(hh, val_time)), 64800)')
	execute('update collateral_config set val_time_seconds = isnull((select time_value from (select collateral_config.mcc_id id, (datepart(ss, mrgcall_config.val_time) + 60 * datepart(mi, mrgcall_config.val_time) + 3600 * datepart(hh, mrgcall_config.val_time)) time_value from mrgcall_config, collateral_config where collateral_config.mcc_id = mrgcall_config.mrg_call_def) time_temp_table where time_temp_table.id = collateral_config.mcc_id), 64800)')
	execute('update collateral_config set notification_time_seconds = isnull((select time_value from (select collateral_config.mcc_id id, (datepart(ss, mrgcall_config.not_time) + 60 * datepart(mi, mrgcall_config.not_time) + 3600 * datepart(hh, mrgcall_config.not_time)) time_value from mrgcall_config, collateral_config where collateral_config.mcc_id = mrgcall_config.mrg_call_def) time_temp_table where time_temp_table.id = collateral_config.mcc_id), 64800)')
	execute('update collateral_config set substitution_time_seconds = isnull((select time_value from (select collateral_config.mcc_id id, (datepart(ss, mrgcall_config.subst_time) + 60 * datepart(mi, mrgcall_config.subst_time) + 3600 * datepart(hh, mrgcall_config.subst_time)) time_value from mrgcall_config, collateral_config where collateral_config.mcc_id = mrgcall_config.mrg_call_def) time_temp_table where time_temp_table.id = collateral_config.mcc_id), 64800)')
	execute('insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (''upgrade_2.04.00_valuation_time_to_seconds.sql'', ''collateral'', user_name(), getDate())')
END

go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_2.05.00_multiple_buffers.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
if not exists (select 1 from sysobjects where sysobjects.name = 'collateral_config_buffer')
begin
	execute('create table collateral_config_buffer (mrg_call_def int, type varchar(255), buffer_method varchar(255), value float, currency_code varchar(3))')
	execute('INSERT INTO collateral_config_buffer (mrg_call_def, type, buffer_method, value, currency_code) SELECT c.mcc_id, ''Contractual'', ''Multiplier'',  c.credit_multiplier, null FROM collateral_config c, mrgcall_config mcc WHERE c.mcc_id=mcc.mrg_call_def AND c.credit_multiplier <> 0')
end
	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
declare @v_script_filename varchar(128)set @v_script_filename = 'upgrade_2.07.00_rounding_typo.sql'
if not exists (select 1 from module_upgrade_scripts where name = @v_script_filename and module_name = 'collateral')
begin
if not exists (select 1 from sysobjects where sysobjects.name = 'entity_attributes')
Begin
	execute('UPDATE entity_attributes SET attr_name = ''Discount Currency'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''Discount Curency''')

	execute('UPDATE entity_attributes SET attr_name = ''PO Rounding Delivery Method'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''PO Rouding Delivery Method''')

	execute('UPDATE entity_attributes SET attr_name = ''PO Rounding Delivery Amount'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''PO Rouding Delivery Amount''')

	execute('UPDATE entity_attributes SET attr_name = ''PO Rounding Return Method'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''PO Rouding Return Method''')

	execute('UPDATE entity_attributes SET attr_name = ''PO Rounding Return Amount'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''PO Rouding Return Amount''')

	execute('UPDATE entity_attributes SET attr_name = ''LE Rounding Delivery Method'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''LE Rouding Delivery Method''')

	execute('UPDATE entity_attributes SET attr_name = ''LE Rounding Delivery Amount'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''LE Rouding Delivery Amount''')

	execute('UPDATE entity_attributes SET attr_name = ''LE Rounding Return Method'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''LE Rouding Return Method''')

	execute('UPDATE entity_attributes SET attr_name = ''LE Rounding Return Amount'' WHERE entity_type = ''ReportTemplate'' AND attr_name = ''LE Rouding Return Amount''')
END

	execute('UPDATE sd_filter_element SET element_name = ''PO Rounding Delivery Method'' WHERE element_name = ''PO Rouding Delivery Method''')

	execute('UPDATE sd_filter_element SET element_name = ''PO Rounding Delivery Amount'' WHERE element_name = ''PO Rouding Delivery Amount''')

	execute('UPDATE sd_filter_element SET element_name = ''PO Rounding Return Method'' WHERE element_name = ''PO Rouding Return Method''')

	execute('UPDATE sd_filter_element SET element_name = ''PO Rounding Return Amount'' WHERE element_name = ''PO Rouding Return Amount''')

	execute('UPDATE sd_filter_element SET element_name = ''LE Rounding Delivery Method'' WHERE element_name = ''LE Rouding Delivery Method''')

	execute('UPDATE sd_filter_element SET element_name = ''LE Rounding Delivery Amount'' WHERE element_name = ''LE Rouding Delivery Amount''')

	execute('UPDATE sd_filter_element SET element_name = ''LE Rounding Return Method'' WHERE element_name = ''LE Rouding Return Method''')

	execute('UPDATE sd_filter_element SET element_name = ''LE Rounding Return Amount'' WHERE element_name = ''LE Rouding Return Amount''')


	execute('UPDATE sd_filter_domain SET element_name = ''PO Rounding Delivery Method'' WHERE element_name = ''PO Rouding Delivery Method''')

	execute('UPDATE sd_filter_domain SET element_name = ''PO Rounding Delivery Amount'' WHERE element_name = ''PO Rouding Delivery Amount''')

	execute('UPDATE sd_filter_domain SET element_name = ''PO Rounding Return Method'' WHERE element_name = ''PO Rouding Return Method''')

	execute('UPDATE sd_filter_domain SET element_name = ''PO Rounding Return Amount'' WHERE element_name = ''PO Rouding Return Amount''')

	execute('UPDATE sd_filter_domain SET element_name = ''LE Rounding Delivery Method'' WHERE element_name = ''LE Rouding Delivery Method''')

	execute('UPDATE sd_filter_domain SET element_name = ''LE Rounding Delivery Amount'' WHERE element_name = ''LE Rouding Delivery Amount''')

	execute('UPDATE sd_filter_domain SET element_name = ''LE Rounding Return Method'' WHERE element_name = ''LE Rouding Return Method''')

	execute('UPDATE sd_filter_domain SET element_name = ''LE Rounding Return Amount'' WHERE element_name = ''LE Rouding Return Amount''')

	insert into module_upgrade_scripts (name, module_name, user_name, execution_date) values (@v_script_filename, 'collateral', user_name(), getDate())
end
go
