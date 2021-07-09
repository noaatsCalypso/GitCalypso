create proc add_column_if_not_exists (@table_name varchar(255), @column_name varchar(255) , @datatype varchar(255))
as
begin
declare @cnt int
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
if @cnt=0
exec ('alter table ' + @table_name + ' add '+ @column_name +' ' + @datatype)
end
go

create proc add_domain_values(@name varchar(255),@value varchar(255),@description varchar(255))
as
begin
	declare @cnt int
	select @cnt=count(*) from domain_values where name=@name and @value=@value 
	select @cnt 
	if  (@cnt=0) 
	insert into domain_values (name,value,description) values (@name,@value,@description)
	else 
	delete from domain_values where name=@name and value=@value
	insert into domain_values (name,value,description) values (@name,@value,@description)
end
go


CREATE PROCEDURE drop_pk_if_exists(@arg_table_name VARCHAR(255))
AS

  DECLARE @CONSTRAINT_NAME VARCHAR(255)
  DECLARE @SQL VARCHAR(500)

  SELECT @CONSTRAINT_NAME = i.name
  FROM sysindexes i, sysobjects t
  WHERE t.name = @arg_table_name AND i.id = t.id AND (i.status & 2048) = 2048  
  SELECT @SQL = 'ALTER TABLE ' + @arg_table_name + ' DROP CONSTRAINT ' + @CONSTRAINT_NAME 
  EXEC (@SQL)
GO
