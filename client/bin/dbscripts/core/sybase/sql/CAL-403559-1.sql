begin
	declare
	@x int , @y int
	begin
		select @x = max(len(attr_column_name)) from attribute_config
		select @y = count(*) from attribute_config
		if (@x <= 30 or @y = 0)
		begin 
			exec ('alter table attribute_config modify attr_column_name varchar(30) not null')
		end
	end
end
go