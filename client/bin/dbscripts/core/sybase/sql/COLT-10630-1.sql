BEGIN
declare 
@x int,@y int,@size int 

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'concentration_position')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(concentration_position)) from collateral_config
if (@y = 0 or @x <= 16)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY concentration_position VARCHAR(16)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'concentration_side')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(concentration_side)) from collateral_config
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY concentration_side VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'contract_direction')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(contract_direction)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY contract_direction VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'dispute_tol_perc_basis')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(dispute_tol_perc_basis)) from collateral_config
if (@y = 0 or @x <= 24)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY dispute_tol_perc_basis VARCHAR(24)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_ia_rating_direction')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(le_ia_rating_direction)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_ia_rating_direction VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_mta_currency')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(le_mta_currency)) from collateral_config
if (@y = 0 or @x <= 3)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_mta_currency VARCHAR(3)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_thres_currency')
BEGIN
select @y = count(*)  from collateral_config 
select @x= max(len(le_thres_currency)) from collateral_config
if (@y = 0 or @x <= 3)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_thres_currency VARCHAR(3)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'po_ia_rating_direction')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(po_ia_rating_direction)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY po_ia_rating_direction VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'po_mta_currency')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(po_mta_currency)) from collateral_config
if (@y = 0 or @x <= 3)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY po_mta_currency VARCHAR(3)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'po_thres_currency')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(po_thres_currency)) from collateral_config
if (@y = 0 or @x <= 3)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY po_thres_currency VARCHAR(3)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'position_date_type')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(position_date_type)) from collateral_config
if (@y = 0 or @x <= 24)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY position_date_type VARCHAR(24)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'position_type')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(position_type)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY position_type VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'substitution_context')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(substitution_context)) from collateral_config
if (@y = 0 or @x <= 24)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY substitution_context VARCHAR(24)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'substitution_level')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(substitution_level)) from collateral_config
if (@y = 0 or @x <= 48)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY substitution_level VARCHAR(48)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'substitution_type')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(substitution_type)) from collateral_config
if (@y = 0 or @x <= 24)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY substitution_type VARCHAR(24)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'undisputed_perc_dispute_b')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(undisputed_perc_dispute_b)) from collateral_config
if (@y=0 or @x<= 24)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY undisputed_perc_dispute_b VARCHAR(24)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'wf_product')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(wf_product)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY wf_product VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'wf_subtype')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(wf_subtype)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY wf_subtype VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'perimeter_type')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(perimeter_type)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY perimeter_type VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'po_ia_direction')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(po_ia_direction)) from collateral_config
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY po_ia_direction VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_ia_direction')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(le_ia_direction)) from collateral_config
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_ia_direction VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'intraday_pricing_env_name')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(intraday_pricing_env_name)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY intraday_pricing_env_name VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'simulation_pricing_env_name')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(simulation_pricing_env_name)) from collateral_config
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY simulation_pricing_env_name VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'po_haircut_name')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(po_haircut_name)) from collateral_config
if (@y = 0 or @x <= 256)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY po_haircut_name VARCHAR(256)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_haircut_name')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(le_haircut_name)) from collateral_config
if (@y = 0 or @x <= 256)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_haircut_name VARCHAR(256)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_accept_rehyp')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(le_accept_rehyp)) from collateral_config
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_accept_rehyp VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_collateral_rehyp')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(le_collateral_rehyp)) from collateral_config
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_collateral_rehyp VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'term_settle_ccy_list')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(term_settle_ccy_list)) from collateral_config
if (@y = 0 or @x <= 1024)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY term_settle_ccy_list VARCHAR(1024)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_term_ccy_list')
BEGIN
select @y = count(*)  from collateral_config 
select @x = max(len(le_term_ccy_list)) from collateral_config
if (@y = 0 or @x <= 1024)               
BEGIN
EXECUTE('ALTER TABLE collateral_config MODIFY le_term_ccy_list VARCHAR(1024)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'term_settle_ccy_list')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x= max(len(term_settle_ccy_list)) from exposure_group_definition
if (@y = 0 or @x <= 1024)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY term_settle_ccy_list VARCHAR(1024)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'le_term_ccy_list')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(le_term_ccy_list)) from exposure_group_definition
if (@y = 0 or @x <= 1024)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY le_term_ccy_list VARCHAR(1024)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'po_haircut_name')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(po_haircut_name)) from exposure_group_definition
if (@y = 0 or @x <= 256)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY po_haircut_name VARCHAR(256)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'le_haircut_name')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(le_haircut_name)) from exposure_group_definition
if (@y = 0 or @x <= 256)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY le_haircut_name VARCHAR(256)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'haircut_type')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(haircut_type)) from exposure_group_definition
if (@y = 0 or @x <= 32)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY haircut_type VARCHAR(32)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'po_accept_rehyp')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(po_accept_rehyp)) from exposure_group_definition
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY po_accept_rehyp VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'po_collateral_rehyp')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(po_collateral_rehyp)) from exposure_group_definition
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY po_collateral_rehyp VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'le_accept_rehyp')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(le_accept_rehyp)) from exposure_group_definition
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY le_accept_rehyp VARCHAR(8)')
END
END

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'le_collateral_rehyp')
BEGIN
select @y = count(*)  from exposure_group_definition 
select @x = max(len(le_collateral_rehyp)) from exposure_group_definition
if (@y = 0 or @x <= 8)               
BEGIN
EXECUTE('ALTER TABLE exposure_group_definition MODIFY le_collateral_rehyp VARCHAR(8)')
END
END

END
GO
