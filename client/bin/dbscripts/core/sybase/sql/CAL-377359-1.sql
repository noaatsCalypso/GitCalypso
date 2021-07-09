IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'fee_config' AND syscolumns.name = 'currency_list')
BEGIN
declare @y numeric,@x numeric
select @y = count(*)  from fee_config 
select @x = max(len(currency_list)) from fee_config
if (@y = 0 or @x <= 400)               
BEGIN
EXECUTE('ALTER TABLE fee_config MODIFY currency_list VARCHAR(400)')
END
END
go