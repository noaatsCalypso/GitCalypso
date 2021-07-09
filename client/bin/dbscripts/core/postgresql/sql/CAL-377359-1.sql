DO $$
declare		
		
x integer;		
y integer;		
		
begin		
	select coalesce(max(length(currency_list)),0) into x from fee_config;	
	select coalesce(count(*),0) into y from fee_config;		
		
	if (x <=400 or y = 0) then	
		execute 'alter table fee_config alter column currency_list type varchar(400)';
	end if;	
		
end;		
$$
;