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
rename_column_if_exists ('userprefs_template','template_type','template_type_bak');
end;
/
begin
rename_column_if_exists ('userprefs_template','type','template_type');
end;
/