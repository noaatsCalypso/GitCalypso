BEGIN
	DECLARE
		query VARCHAR2(4000);
		tablesToCheck list_of_names_t := list_of_names_t('ERSC_RULE_GROUP');
	BEGIN
		query := 'ALTER TABLE ersc_rule_group MODIFY (ID varchar2(36),
									CREATED_META_DATA_ID varchar2(36),
									UPDATED_META_DATA_ID varchar2(36))';
    run_query_if_tables_exist(tablesToCheck, query);
	END;
END;