DO $$
declare		
x integer;		
y integer;		
begin		
	select coalesce(max(length(attr_column_name)),0) into x from attribute_config ;	
	select coalesce(count(*),0) into y from attribute_config ;		
	if (x <= 30 or y = 0) then	
		execute 'alter table attribute_config alter column attr_column_name type varchar(30)';
	end if;	
end;		
$$
;