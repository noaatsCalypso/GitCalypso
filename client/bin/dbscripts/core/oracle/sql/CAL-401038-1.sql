create or replace procedure SP_INSERT_CONFIG_GROUPING_MAP as 
begin
	declare
	configuration_name varchar(255);
	exist_config_grouping number;
	exist_table number;
begin
  select count(*) into exist_table from user_tables where table_name = UPPER('am_analysis_startup_grouping');
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
end SP_INSERT_CONFIG_GROUPING_MAP;
/

begin
SP_INSERT_CONFIG_GROUPING_MAP;
end;
/

drop procedure SP_INSERT_CONFIG_GROUPING_MAP
;
