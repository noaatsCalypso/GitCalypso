if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go
if not exists (select 1 from sysobjects where name='ers_product_groups' and type='U')
begin
exec ('CREATE TABLE ers_limit_groups
   (
	group_type		varchar(64)    	NOT NULL,
	group_name		varchar(64)	NOT NULL,
	group_value		varchar(64)	NOT NULL
   )')
end
GO

if not exists (select 1 from sysobjects where name='ers_product_groups' and type='U')
begin
exec ('create table ers_product_groups (product_group varchar(64) null, product_type  varchar(64) null)')
end
go

insert into ers_limit_groups (group_type, group_name, group_value)(select 'ProductGroup', product_group, product_type from ers_product_groups)
go