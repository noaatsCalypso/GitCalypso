begin
	declare
	@x int , @y int

	begin

		select @x = max(len(config_name)) from reutersdss_config_name
		select @y = count(*) from reutersdss_config_name
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_config_name modify config_name varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(rpt_tmplt_name)) from reutersdss_rpt_templates
		select @y = count(*) from reutersdss_rpt_templates
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_rpt_templates modify rpt_tmplt_name varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(rpt_col_tmplt_name)) from reutersdss_rpt_cols
		select @y = count(*) from reutersdss_rpt_cols
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_rpt_cols modify rpt_col_tmplt_name varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(col_name)) from reutersdss_rpt_cols
		select @y = count(*) from reutersdss_rpt_cols
		if (@x <= 255 or @y = 0)

		begin 
			exec ('alter table reutersdss_rpt_cols modify col_name varchar(255)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(instrument_tmplt_name)) from reutersdss_instruments
		select @y = count(*) from reutersdss_instruments
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_instruments modify instrument_tmplt_name varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(iden_name)) from reutersdss_instruments
		select @y = count(*) from reutersdss_instruments
		if (@x <= 255 or @y = 0)

		begin 
			exec ('alter table reutersdss_instruments modify iden_name varchar(255)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(iden_desc)) from reutersdss_instruments
		select @y = count(*) from reutersdss_instruments
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_instruments modify iden_desc varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(schedules_tmplt_name)) from reutersdss_schedules
		select @y = count(*) from reutersdss_schedules
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_schedules modify schedules_tmplt_name varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(typename)) from reutersdss_mapping
		select @y = count(*) from reutersdss_mapping
		if (@x <= 96 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping modify typename varchar(96)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(intf_value)) from reutersdss_mapping
		select @y = count(*) from reutersdss_mapping
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping modify intf_value varchar(255)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(calypso_value)) from reutersdss_mapping
		select @y = count(*) from reutersdss_mapping
		if (@x <= 255 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping modify calypso_value varchar(255)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(intf_value)) from reutersdss_mapping_rules
		select @y = count(*) from reutersdss_mapping_rules
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping_rules modify intf_value varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(calypso_value)) from reutersdss_mapping_rules
		select @y = count(*) from reutersdss_mapping_rules
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping_rules modify calypso_value varchar(64)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(rule_name)) from reutersdss_mapping_rules
		select @y = count(*) from reutersdss_mapping_rules
		if (@x <= 255 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping_rules modify rule_name varchar(255)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(rule_value)) from reutersdss_mapping_rules
		select @y = count(*) from reutersdss_mapping_rules
		if (@x <= 255 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping_rules modify rule_value varchar(255)')
		end
	end
end

go


begin
	declare
	@x int , @y int

	begin

		select @x = max(len(rule_group)) from reutersdss_mapping_rules
		select @y = count(*) from reutersdss_mapping_rules
		if (@x <= 64 or @y = 0)

		begin 
			exec ('alter table reutersdss_mapping_rules modify rule_group varchar(64)')
		end
	end
end

go