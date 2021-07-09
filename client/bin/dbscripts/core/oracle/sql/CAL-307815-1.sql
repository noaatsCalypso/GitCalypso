
declare 
x number :=0 ;
sql1 varchar2(500);
begin
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('official_pl_aggregate_item') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 1 THEN
sql1:= 'update official_pl_aggregate_item set adj_status='||chr(39)||'Adjusted'||chr(39)||' where adj_status='
||chr(39)||'Imported {&} Adjusted'||chr(39);
	dbms_output.put_line('sql1');
	execute immediate (sql1);
END IF;
End ;
/

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('official_pl_mark') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 1 THEN
EXECUTE IMMEDIATE 'update official_pl_mark set adj_status='||chr(39)||'Adjusted'||chr(39)||' 
where adj_status='||chr(39)||'Imported {&} Adjusted'||chr(39); 
END IF;
End ;
/

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('official_pl_aggregate_item_hist') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 1 THEN
EXECUTE IMMEDIATE 'update official_pl_mark_hist set adj_status='||chr(39)||'Adjusted'||chr(39)||' 
where adj_status='||chr(39)||'Imported {&} Adjusted'||chr(39);
END IF;
End ;
/


