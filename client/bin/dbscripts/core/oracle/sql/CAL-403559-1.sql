declare

x number;
y number;

begin
	select vsize(attr_column_name) into x from attribute_config;
	select count(*) into y from attribute_config;
	exception WHEN NO_DATA_FOUND THEN
	x:=0;
	y:=0;
	execute immediate 'alter table attribute_config modify attr_column_name varchar2(30)';
	WHEN OTHERS THEN 
	x:=0;
	y:=0;
	if (x <= 30 or y = 0) then
		execute immediate 'alter table attribute_config modify attr_column_name varchar2(30)';
	end if;

end;
/
