create or replace function SP_INSERT_CONFIG_GROUPING_MAP()
RETURNS void LANGUAGE plpgsql
as $BODY$
DECLARE
  startup_grouping_record record;
  configuration_name VARCHAR(255);
  exist_config_grouping integer;
  exist_table integer;
begin
  select count(*) into exist_table from information_schema.tables where table_name = UPPER('am_analysis_startup_grouping');
  if (exist_table = 1)
  then
      for startup_grouping_record in (select config_id, grouping_id from am_analysis_startup_grouping) 
      loop
      select config_name into configuration_name from am_server_config_id_map where config_id = startup_grouping_record.config_id;
      select count(*) into exist_config_grouping from am_server_config_grouping_map where config_name = configuration_name and grouping_id = startup_grouping_record.grouping_id;
      if exist_config_grouping = 0
        then
            insert into am_server_config_grouping_map(config_name,grouping_id) values(configuration_name, startup_grouping_record.grouping_id);
      end if;
      end loop;
  end if;  
end;
$BODY$
;

DO $$ begin
  perform SP_INSERT_CONFIG_GROUPING_MAP();
END$$;

DROP FUNCTION SP_INSERT_CONFIG_GROUPING_MAP()
;
