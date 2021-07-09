CREATE OR REPLACE PROCEDURE rename_column_if_exists ( tab_name in varchar(255) ,  col_name varchar(255), new_col_name varchar(255) )
LANGUAGE plpgsql
AS $$
begin
declare
x int;
dyn_sql text;
begin
  select count(*) into x from information_schema.columns  
  WHERE table_name = tab_name and columns.column_name=col_name;
  if x = 1 then
  dyn_sql = 'alter table ' || tab_name || ' rename  column '||col_name||' to '||new_col_name;
  execute dyn_sql;
  end if;
  end;
  end;
  $$;

call rename_column_if_exists ('userprefs_preferences','preference_type','preference_type_bak')
;
call rename_column_if_exists ('userprefs_preferences','type','preference_type')
;
call rename_column_if_exists ('userprefs_preferences', 'preference_key','preference_key_bak')
;
call rename_column_if_exists ('userprefs_preferences', 'key','preference_key')
;
call rename_column_if_exists ('userprefs_preferences','preference_value','preference_value_bak')
;
call rename_column_if_exists ('userprefs_preferences','value','preference_value')
;
call rename_column_if_exists ('dashboard_config_layout','layout_owner','layout_owner_bak')
;
call rename_column_if_exists ('dashboard_config_layout','owner','layout_owner')
;
call rename_column_if_exists ('dashboard_config_layout','layout_type','layout_type_bak')
;
call rename_column_if_exists ('dashboard_config_layout','type','layout_type')
;
call rename_column_if_exists ('dashboard_config_dashboard','dashboard_name','dashboard_name_bak')
;
call rename_column_if_exists ('dashboard_config_dashboard','name','dashboard_name')
;
call rename_column_if_exists ('dashboard_config_dashboard','dashboard_owner','dashboard_owner_bak')
;
call rename_column_if_exists ('dashboard_config_dashboard','owner','dashboard_owner')
;
call rename_column_if_exists ('dashboard_config_dashboard','dashboard_type','dashboard_type_bak')
;
call rename_column_if_exists ('dashboard_config_dashboard','type','dashboard_type')
;
call rename_column_if_exists ('dashboard_config_dashboard','is_shared','is_shared_bak')
;
call rename_column_if_exists ('dashboard_config_dashboard','shared','is_shared')
;
call rename_column_if_exists ('dashboard_config_widget_attr','attribute_name','attribute_name_bak')
;
call rename_column_if_exists ('dashboard_config_widget_attr','name','attribute_name')
;
call rename_column_if_exists ('dashboard_config_widget_attr','attribute_value','attribute_value_bak')
;
call rename_column_if_exists ('dashboard_config_widget_attr','value','attribute_value')
;
call rename_column_if_exists ('dashboard_config_widget_attr','attribute_type','attribute_type_bak')
;
call rename_column_if_exists ('dashboard_config_widget_attr','type','attribute_type')
;
call rename_column_if_exists ('userprefs_template_crit','criteria_name','criteria_name_bak')
;
call rename_column_if_exists ('userprefs_template_crit','name','criteria_name')
;
call rename_column_if_exists ('userprefs_template_crit','criteria_value','criteria_value_bak')
;
call rename_column_if_exists ('userprefs_template_crit','value','criteria_value')
;
call rename_column_if_exists ('userprefs_template','template_name','template_name_bak')
;
call rename_column_if_exists ('userprefs_template','name','template_name')
;
