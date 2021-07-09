create procedure SP_INSERT_CONFIG_GROUPING_MAP
as
begin
declare @config_id INT, @grouping_id INT, @config_name VARCHAR(255), @exist_table INT
declare config_cursor cursor 
for
  select config_id, grouping_id from am_analysis_startup_grouping

select @exist_table=count(*) from sysobjects where name = 'am_analysis_startup_grouping' and type='U'
if @exist_table=1
begin
    open config_cursor
    fetch config_cursor into @config_id, @grouping_id
    while (@@sqlstatus=0)
      begin
        select @config_name=config_name from am_server_config_id_map where config_id = @config_id 
        if not exists (select 1 from am_server_config_grouping_map where config_name=@config_name and grouping_id=@grouping_id) 
            begin
              insert into am_server_config_grouping_map(config_name, grouping_id) values (@config_name, @grouping_id)
            end
        fetch config_cursor into @config_id, @grouping_id
      end
    close config_cursor
    deallocate cursor config_cursor
end
end
go

exec sp_procxmode 'SP_INSERT_CONFIG_GROUPING_MAP', 'anymode'
go

exec SP_INSERT_CONFIG_GROUPING_MAP
go

if exists (select 1 from sysobjects where name = 'SP_INSERT_CONFIG_GROUPING_MAP'
                                    and type = 'P')
   begin
     exec('drop procedure SP_INSERT_CONFIG_GROUPING_MAP')
   end
go
