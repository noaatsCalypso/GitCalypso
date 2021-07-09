if exists (select 1 from syscolumns where object_id('margin_concentration_risk')=syscolumns.id)
begin
exec('drop table margin_concentration_risk')
end
go
