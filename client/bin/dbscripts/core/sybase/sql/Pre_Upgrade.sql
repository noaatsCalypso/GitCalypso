
if exists (select 1 from sysobjects where name ='add_domain_values' and type='P')
begin
exec ('drop procedure add_domain_values')
end
go
if exists (select 1 from sysobjects where name ='delete_domain_values' and type='P')
begin
exec ('drop procedure delete_domain_values')
end
go

if exists (select 1 from sysobjects where name ='add_column_if_not_exists' and type='P')
begin
exec ('drop procedure add_column_if_not_exists')
end
go

if exists (select 1 from sysobjects where name ='drop_unique_if_exists' and type='P')
begin
exec ('drop procedure drop_unique_if_exists')
end
go

if exists (select 1 from sysobjects where name ='drop_pk_if_exists' and type='P')
begin
exec ('drop procedure drop_pk_if_exists')
end
go

if exists (select 1 from sysobjects where name ='drop_index_if_exists' and type='P')
begin
exec ('drop procedure drop_index_if_exists')
end
go

if exists (select 1 from sysobjects where name ='drop_column_if_exists' and type='P')
begin
exec ('drop procedure drop_column_if_exists')
end
go
if exists (select 1 from sysobjects where name ='rename_column_if_exists' and type='P')
begin
exec ('drop procedure rename_column_if_exists')
end
go
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
	declare @cnt int,
	@sql1 varchar(500) , @sql2 varchar(500)
	select @cnt=count(*) from domain_values where name=@name and @value=@value 
	select @cnt 
	if  (@cnt=0) 
	begin
	select @sql1 = 'insert into domain_values (name,value,description) 
	values ('||char(39)||@name||char(39)||','||char(39)||@value||char(39)||','||char(39)||@description||char(39)||')'
	exec(@sql1)
	end
	else
    begin
	select @sql2 = 'update domain_values 
	set description = '||char(39)||@description||char(39)||'where name='||char(39)||@name||char(39)|| ' and value='||char(39)||@value||char(39)
	exec(@sql2)
	end
	
end
go

create proc delete_domain_values(@name varchar(255),@value varchar(255))
as
begin
	declare @cnt int,
	@sql1 varchar(500) 
	select @cnt=count(*) from domain_values where name=@name and @value=@value 
	select @cnt 
	if  (@cnt=0) 
	begin
	select @sql1 = 'delete from domain_values where name ='||char(39)||@name||char(39)||' and value='||char(39)||@value||char(39)
	exec(@sql1)
	end
end
go


create proc drop_column_if_exists (@table_name varchar(255), @column_name varchar(255))
as
begin
declare @cnt int
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
if @cnt=1
exec ('alter table ' + @table_name + ' drop '+ @column_name)
end
go


CREATE PROCEDURE drop_pk_if_exists(@arg_table_name VARCHAR(255))
AS
begin
  declare @cnt int, @sql1 varchar(500) , @sql2 varchar(500)
  DECLARE @CONSTRAINT_NAME VARCHAR(255)
  select @cnt = count(*) from sysindexes i, sysobjects t WHERE t.name = @arg_table_name AND i.id = t.id AND (i.status & 2048) = 2048
  select @CONSTRAINT_NAME = i.name from sysindexes i, sysobjects t WHERE t.name = @arg_table_name AND i.id = t.id AND (i.status & 2048) = 2048
  and i.name is not null
  if @cnt =1 
  begin
  
  select  @sql2= ('ALTER TABLE ' + @arg_table_name + ' DROP CONSTRAINT ' + @CONSTRAINT_NAME)
 exec (@sql2)
 
  end
  end
go


CREATE PROCEDURE drop_unique_if_exists(@arg_table_name VARCHAR(255))
AS
	begin
	declare @cnt int
  DECLARE @CONSTRAINT_NAME VARCHAR(255)
  
  select @cnt = count(*) from sysindexes i, sysobjects t WHERE t.name = @arg_table_name AND i.id = t.id AND i.status = 2
  if @cnt=1
  begin
  exec ('SELECT '+ @CONSTRAINT_NAME +'= i.name FROM sysindexes i, sysobjects t WHERE t.name = '+@arg_table_name +'AND i.id = t.id AND i.status = 2')
  exec ('ALTER TABLE ' + @arg_table_name + ' DROP CONSTRAINT ' + @CONSTRAINT_NAME)
end
end
  
GO


create proc drop_index_if_exists(@arg_table_name VARCHAR(255))
AS
begin
declare @cnt int
DECLARE @index_name VARCHAR(255)
select @cnt=count(*) from sysindexes , sysobjects where sysobjects.id=sysindexes.id and sysobjects.name=@arg_table_name and sysindexes.indid!=0 
and sysindexes.status=0 and sysindexes.name != null
if @cnt=1
begin
exec ('select '+@index_name +' from sysindexes , sysobjects where sysobjects.id=sysindexes.id and sysobjects.name='+ @arg_table_name+' and sysindexes.indid!=0 
and sysindexes.status=0 and sysindexes.name != null')
exec ('drop index ' + @arg_table_name + '.' + @index_name)
end
end
go

create proc rename_column_if_exists (@table_name varchar(255), @column_name varchar(255) , @new_col_name varchar(255))
as
begin
declare @cnt int, @sql varchar(500)
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
if @cnt=1
select @sql = 'sp_rename ' ||char(34)||@table_name || '.' || @column_name ||char(34)|| ',' || @new_col_name
exec (@sql)
end
go