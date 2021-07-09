IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_group') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule_group 
	SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
	THEN ''00112233-4455-6677-8899-aabbccddeeff''
	ELSE (SELECT m.user_info FROM entity_modif_metadata m)
	END
	from ersc_rule_group t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_group') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule_group set 
	creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
	THEN 0
	ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
	END
	from ersc_rule_group t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_group') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule_group set 
	last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
	THEN ''00112233-4455-6677-8899-aabbccddeeff''
	ELSE (SELECT m.user_info FROM entity_modif_metadata m)
	END
	from ersc_rule_group t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_group') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule_group set 
	last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
	THEN 0
	ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
	END
	from ersc_rule_group t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO
