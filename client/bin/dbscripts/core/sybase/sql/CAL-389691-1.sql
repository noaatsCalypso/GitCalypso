if exists (select 1 from sysobjects where name='core_quotevalue')
begin
exec ('drop table core_quotevalue')
end
go