select * into ers_scenario_datasource_bkup from ers_scenario_datasource
go
select * into ers_scenario_rf_bkup from ers_scenario_rf
go
select * into ers_scenario_bkup from ers_scenario
go
IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'ers_scenario_datasource' AND syscolumns.name = 'source_path')
BEGIN
EXECUTE('update ers_scenario_datasource set scset_data_source = str_replace(scset_data_source, ''FromQuotes'', ''FromFiles''), source_type = ''MDIArchive'', source_filter = source_path where source_type = ''MDIFile''')
END
ELSE
BEGIN
EXECUTE('update ers_scenario_datasource  
set scset_data_source = str_replace(scset_data_source, ''FromQuotes'', ''FromFiles''), source_type = ''MDIArchive''
from ers_scenario_datasource ds
where ds.scset_data_source like ''%FromQuotes'' and ds.source_type = ''MDIFile'' and ds.source_id not like ''%.%'' 
and not exists(select 1 from ers_scenario_datasource dup where dup.scset_data_source = str_replace(ds.scset_data_source, ''FromQuotes'', ''FromFiles'') 
and ds.rf_risk_type = dup.rf_risk_type and ds.rf_ccy = dup.rf_ccy and ds.rf_index = dup.rf_index)')
END
go