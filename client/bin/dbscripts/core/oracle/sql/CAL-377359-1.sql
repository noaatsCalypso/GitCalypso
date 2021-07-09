declare 
y int;
x int;
BEGIN
	select max(vsize(CURRENCY_LIST)) into x from fee_config;
	select count(*) into y from fee_config;
	exception WHEN NO_DATA_FOUND THEN
	x:=0;
	y:=0;
	if (y = 0 or x <= 400) then
		execute immediate 'alter table fee_config modify (CURRENCY_LIST varchar2(400))';
	end if;
END;
/


