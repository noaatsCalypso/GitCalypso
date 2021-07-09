BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_RULE_RESULT_TRADE','ENTITY_MODIF_METADATA');
	BEGIN
		query := 'UPDATE ersc_rule_result_trade t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
    run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_SANCTION_ITEM','ENTITY_MODIF_METADATA');
	BEGIN
	query := 'UPDATE ersc_sanction_item t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
	run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_RULE_PORTFOLIO','ENTITY_MODIF_METADATA');
	BEGIN
	query := 'UPDATE ersc_rule_portfolio t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
	run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_RULE_CHECK_RESULT');
	BEGIN
	query := 'UPDATE ersc_rule_check_result t
		SET
		creation_user = ''00112233-4455-6677-8899-aabbccddeeff'',
		creation_date = 0,
		last_update_user = ''00112233-4455-6677-8899-aabbccddeeff'',
		last_update_date = 0
		';
	run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_RULE_CHECK','ENTITY_MODIF_METADATA');
	BEGIN
	query := 'UPDATE ersc_rule_check t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
	run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_RULE','ENTITY_MODIF_METADATA');
	BEGIN
	query := 'UPDATE ersc_rule t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
	run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_RULE_RESULT','ENTITY_MODIF_METADATA');
	BEGIN
	query := 'UPDATE ersc_rule_result t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
		run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_DATA_REVISION','ENTITY_MODIF_METADATA');
	BEGIN
	query := 'UPDATE ersc_data_revision t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
	run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/

BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_JOB','ENTITY_MODIF_METADATA');
	BEGIN
	query := 'UPDATE ersc_job t
		SET
		creation_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		creation_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
		ELSE 0
		END,
		last_update_user =
		CASE WHEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.user_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE ''00112233-4455-6677-8899-aabbccddeeff''
		END,
		last_update_date =
		CASE WHEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id) IS NOT NULL
		THEN (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
		ELSE 0
		END
		';
		run_query_if_tables_exist(tablesToCheck, query);
	END;
END;
/