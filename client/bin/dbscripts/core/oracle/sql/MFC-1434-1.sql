CREATE OR REPLACE PROCEDURE rename_column_if_exists

    (tab_name IN user_tab_columns.table_name%TYPE,

     col_name IN user_tab_columns.column_name%TYPE,

     new_col_name IN varchar2)
AS
    x number;

BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER(tab_name) and column_name=upper(col_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
        EXECUTE IMMEDIATE 'alter table ' || tab_name || ' rename  column '||col_name||' to '||new_col_name;
    END IF;
END;
/
begin
rename_column_if_exists ('userprefs_preferences','preference_type','preference_type_bak');
end;
/
begin
rename_column_if_exists ('userprefs_preferences','type','preference_type');
end;
/
begin
rename_column_if_exists ('userprefs_preferences', 'preference_key','preference_key_bak');
end;
/
begin
rename_column_if_exists ('userprefs_preferences', 'key','preference_key');
end;
/
begin
rename_column_if_exists ('userprefs_preferences','preference_value','preference_value_bak');
end;
/
begin
rename_column_if_exists ('userprefs_preferences','value','preference_value');
end;
/
begin
rename_column_if_exists ('dashboard_config_layout','layout_owner','layout_owner_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_layout','owner','layout_owner');
end;
/
begin
rename_column_if_exists ('dashboard_config_layout','layout_type','layout_type_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_layout','type','layout_type');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','dashboard_name','dashboard_name_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','name','dashboard_name');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','dashboard_owner','dashboard_owner_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','owner','dashboard_owner');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','dashboard_type','dashboard_type_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','type','dashboard_type');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','is_shared','is_shared_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_dashboard','shared','is_shared');
end;
/
begin
rename_column_if_exists ('dashboard_config_widget_attr','attribute_name','attribute_name_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_widget_attr','name','attribute_name');
end;
/
begin
rename_column_if_exists ('dashboard_config_widget_attr','attribute_value','attribute_value_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_widget_attr','value','attribute_value');
end;
/
begin
rename_column_if_exists ('dashboard_config_widget_attr','attribute_type','attribute_type_bak');
end;
/
begin
rename_column_if_exists ('dashboard_config_widget_attr','type','attribute_type');
end;
/
begin
rename_column_if_exists ('userprefs_template_crit','criteria_name','criteria_name_bak');
end;
/
begin
rename_column_if_exists ('userprefs_template_crit','name','criteria_name');
end;
/
begin
rename_column_if_exists ('userprefs_template_crit','criteria_value','criteria_value_bak');
end;
/
begin
rename_column_if_exists ('userprefs_template_crit','value','criteria_value');
end;
/
begin
rename_column_if_exists ('userprefs_template','template_name','template_name_bak');
end;
/
begin
rename_column_if_exists ('userprefs_template','name','template_name');
end;
/
