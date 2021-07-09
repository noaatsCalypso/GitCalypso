begin
declare @iname varchar(50),@vsql varchar(100)
	exec('sp_rename ers_measure_config, ers_measure_config_back160')
end
go 