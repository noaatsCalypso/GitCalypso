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
exec rename_column_if_exists 'userprefs_template','template_type','template_type_bak'
go
exec rename_column_if_exists 'userprefs_template','type','template_type'
go