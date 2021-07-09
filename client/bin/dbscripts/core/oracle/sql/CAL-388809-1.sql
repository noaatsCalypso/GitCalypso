DECLARE
	cnt_column_exists INT;
BEGIN
	
	execute immediate 'create table ers_scenario_datasource_bkup as select * from ers_scenario_datasource';
	execute immediate 'create table ers_scenario_rf_bkup as select * from ers_scenario_rf';
	execute immediate 'create table ers_scenario_bkup as select * from ers_scenario';
	
	select count(*) INTO cnt_column_exists FROM user_tab_cols WHERE upper(table_name)='ERS_SCENARIO_DATASOURCE' AND upper(column_name) = 'SOURCE_PATH';
	IF cnt_column_exists > 0 THEN
		execute immediate 'update ers_scenario_datasource set scset_data_source = replace(scset_data_source, ''FromQuotes'', ''FromFiles''), source_type = ''MDIArchive'', source_filter = source_path where source_type = ''MDIFile''';
	ELSE
		execute immediate 'update ers_scenario_datasource ds 
		set ds.scset_data_source = replace(ds.scset_data_source, ''FromQuotes'', ''FromFiles''), ds.source_type = ''MDIArchive'' 
		where ds.scset_data_source like ''%FromQuotes'' and ds.source_type = ''MDIFile'' and ds.source_id not like ''%.%'' 
		and not exists(select 1 from ers_scenario_datasource dup where dup.scset_data_source = replace(ds.scset_data_source, ''FromQuotes'', ''FromFiles'') 
		and ds.rf_risk_type = dup.rf_risk_type and ds.rf_ccy = dup.rf_ccy and ds.rf_index = dup.rf_index)';
	END IF;
	
END;
/
