create or replace procedure char2int (tab_name IN varchar, col_name IN varchar, isnull_name IN varchar) as
begin
declare
v_sql varchar(512);
begin

 v_sql := 'alter table '||tab_name||' add calypso_temp_col int '||isnull_name;
 execute immediate v_sql;

 v_sql := 'update '||tab_name||' set calypso_temp_col = to_number('||col_name||')';
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' drop column '||col_name;
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' add '||col_name||' int '||isnull_name;
 execute immediate v_sql;

 v_sql := 'update '||tab_name||' set '||col_name||' = calypso_temp_col';
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' drop column calypso_temp_col';
 execute immediate v_sql;

end;
end char2int;
;



begin
  char2int('ERS_LOG','ISEXCEPTION','NULL');
end;
;

begin
  char2int('ERS_RESULT_HISTORY', 'IS_PACKED', 'DEFAULT 0 NOT NULL');
end;
;

begin
 char2int('ERS_RUN', 'IS_LIVE', 'DEFAULT 0 NOT NULL');
end;
;

begin
 char2int('ERS_RUN','IS_PACKED', 'DEFAULT 0 NOT NULL');
end;
;

begin
 char2int('ERS_RUN_HISTORY','IS_LIVE', 'DEFAULT 0 NOT NULL');
end;
;

begin
 char2int('ERS_RUN_HISTORY','IS_PACKED', 'DEFAULT 0 NOT NULL');
end;
;

begin
 char2int('ERS_RUN_PARAM','TRADE_EXPLODE', 'DEFAULT 0 NOT NULL');
end;
;

begin
 char2int('ERS_RUN_PARAM','ASOFDATE', 'DEFAULT 0 NOT NULL');
end;
;

drop procedure char2int
;
