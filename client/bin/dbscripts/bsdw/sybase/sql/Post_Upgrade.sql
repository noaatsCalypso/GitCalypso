
if exists (select 1 from sysobjects where name ='add_domain_values' and type='P')
begin
exec ('drop procedure add_domain_values')
end
go


if exists (select 1 from sysobjects where name ='add_column_if_not_exists' and type='P')
begin
exec ('drop procedure add_column_if_not_exists')
end
go

if exists (select 1 from sysobjects where name ='drop_pk_if_not_exists' and type='P')
begin
exec ('drop procedure drop_pk_if_not_exists')
end
go




