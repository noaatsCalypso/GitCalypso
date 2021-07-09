create or replace procedure int2char (tab_name IN varchar, col_name IN varchar, isnull_name IN varchar) as
begin
declare
v_sql varchar(512);
begin

 v_sql := 'alter table '||tab_name||' add calypso_temp_col varchar2(64) '||isnull_name;
 execute immediate v_sql;

 v_sql := 'update '||tab_name||' set calypso_temp_col = to_char('||col_name||')';
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' drop column '||col_name;
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' add '||col_name||' varchar2(64) '||isnull_name;
 execute immediate v_sql;

 v_sql := 'update '||tab_name||' set '||col_name||' = calypso_temp_col';
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' drop column calypso_temp_col';
 execute immediate v_sql;

end;
end int2char;
;

alter table ERS_EXPOSURE drop primary key
;

begin
 int2char('ERS_EXPOSURE','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_EXPOSURE','AGREEMENT_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_EXPOSURE_MEASURE','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_LIMIT_BREACH','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_LIMIT_COMMENT','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_LIMIT_DRILLDOWN','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_LIMIT_USAGE','EVENT_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_PREDEAL_CHECK','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_SETTLEMENT','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_TENOR_VIOLATION','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

begin
 int2char('ERS_LIMIT_RESERVE','TRADE_ID', 'DEFAULT 0 NOT NULL');
end;
;

drop procedure int2char
;
