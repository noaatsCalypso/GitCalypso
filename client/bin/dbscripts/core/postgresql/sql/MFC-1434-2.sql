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
call rename_column_if_exists ('userprefs_template','template_type','template_type_bak')
;
call rename_column_if_exists ('userprefs_template','type','template_type')
;