IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_group')
BEGIN
EXEC('alter table ersc_rule_group modify id varchar(36)')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_group')
BEGIN
EXEC('alter table ersc_rule_group modify created_meta_data_id varchar(36)')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_group')
BEGIN
EXEC('alter table ersc_rule_group modify updated_meta_data_id varchar(36)')
END
GO