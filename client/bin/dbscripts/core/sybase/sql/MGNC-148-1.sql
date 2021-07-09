if exists (select 1 from syscolumns where object_id('margin_bucket')=syscolumns.id)
begin
exec('drop table margin_bucket')
exec('drop table margin_ccy_to_level')
exec('drop table margin_concentration_risk')
exec('drop table margin_correlation')
exec('drop table margin_weights')
exec('drop table margin_rates')

end
go
