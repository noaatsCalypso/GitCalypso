create or replace procedure drop_tables_in_risk_db
is
begin
declare
cursor c1 is
select table_name from user_tables where (table_name like 'CS_%' or table_name like 'DELETE_%');
tb int;
begin
for c1_rec in c1 LOOP
begin
select count(*) into tb from user_tables where table_name='CALYPSO_INFO';
if tb = 0 then
execute immediate 'drop table ' || c1_rec.table_name;
end if ;
end;
end loop;
end;
end;
/
begin
drop_tables_in_risk_db;
end;
/

create or replace procedure drop_view_in_risk_db
is
begin
declare
cursor c1 is
select object_name from user_objects where object_type='VIEW' and object_name like 'CS_%';
tb int;
begin
for c1_rec in c1 LOOP
begin
select count(*) into tb from user_tables where table_name='CALYPSO_INFO';
if tb = 0 then
execute immediate 'drop view ' || c1_rec.object_name;
end if ;
end;
end loop;
end;
end;
/
begin
drop_view_in_risk_db;
end;
/
begin 
drop_table_if_exists ('analysis_message');
end;
/
drop procedure drop_tables_in_risk_db
;
drop procedure drop_view_in_risk_db
;

begin
drop_table_if_exists ('analysis_datatable');
end;
/
begin
drop_table_if_exists ('store_schema');
end;
/
begin
drop_table_if_exists ('middletier_seed');
end;
/
begin
drop_table_if_exists ('column_projection');
end;
/
begin
drop_table_if_exists ('tenant');
end;
/
begin
drop_table_if_exists ('live_pl_output');
end;
/
begin
drop_table_if_exists ('live_ladder_output');
end;
/
