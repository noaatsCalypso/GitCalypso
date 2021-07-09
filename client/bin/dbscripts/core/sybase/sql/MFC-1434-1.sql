create proc rename_column_if_exists (@table_name varchar(255), @column_name varchar(255) , @new_col_name varchar(255))
as
begin
declare @cnt int, @sql varchar(500)
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
if @cnt=1
select @sql = 'sp_rename ' ||char(34)||@table_name || '.' || @column_name ||char(34)|| ',' || @new_col_name
exec (@sql)
end
go
exec rename_column_if_exists 'userprefs_preferences','preference_type','preference_type_bak'
go
exec rename_column_if_exists 'userprefs_preferences','type','preference_type'
go
exec rename_column_if_exists 'userprefs_preferences', 'preference_key','preference_key_bak'
go
exec rename_column_if_exists 'userprefs_preferences', 'key','preference_key'
go
exec rename_column_if_exists 'userprefs_preferences','preference_value','preference_value_bak'
go
exec rename_column_if_exists 'userprefs_preferences','value','preference_value'
go
exec rename_column_if_exists 'dashboard_config_layout','layout_owner','layout_owner_bak'
go
exec rename_column_if_exists 'dashboard_config_layout','owner','layout_owner'
go
exec rename_column_if_exists 'dashboard_config_layout','layout_type','layout_type_bak'
go
exec rename_column_if_exists 'dashboard_config_layout','type','layout_type'
go
exec rename_column_if_exists 'dashboard_config_dashboard','dashboard_name','dashboard_name_bak'
go
exec rename_column_if_exists 'dashboard_config_dashboard','name','dashboard_name'
go
exec rename_column_if_exists 'dashboard_config_dashboard','dashboard_owner','dashboard_owner_bak'
go
exec rename_column_if_exists 'dashboard_config_dashboard','owner','dashboard_owner'
go
exec rename_column_if_exists 'dashboard_config_dashboard','dashboard_type','dashboard_type_bak'
go
exec rename_column_if_exists 'dashboard_config_dashboard','type','dashboard_type'
go
exec rename_column_if_exists 'dashboard_config_dashboard','is_shared','is_shared_bak'
go
exec rename_column_if_exists 'dashboard_config_dashboard','shared','is_shared'
go
exec rename_column_if_exists 'dashboard_config_widget_attr','attribute_name','attribute_name_bak'
go
exec rename_column_if_exists 'dashboard_config_widget_attr','name','attribute_name'
go
exec rename_column_if_exists 'dashboard_config_widget_attr','attribute_value','attribute_value_bak'
go
exec rename_column_if_exists 'dashboard_config_widget_attr','value','attribute_value'
go
exec rename_column_if_exists 'dashboard_config_widget_attr','attribute_type','attribute_type_bak'
go
exec rename_column_if_exists 'dashboard_config_widget_attr','type','attribute_type'
go
exec rename_column_if_exists 'userprefs_template_crit','criteria_name','criteria_name_bak'
go
exec rename_column_if_exists 'userprefs_template_crit','name','criteria_name'
go
exec rename_column_if_exists 'userprefs_template_crit','criteria_value','criteria_value_bak'
go
exec rename_column_if_exists 'userprefs_template_crit','value','criteria_value'
go
exec rename_column_if_exists 'userprefs_template','template_name','template_name_bak'
go
exec rename_column_if_exists 'userprefs_template','name','template_name'
go
