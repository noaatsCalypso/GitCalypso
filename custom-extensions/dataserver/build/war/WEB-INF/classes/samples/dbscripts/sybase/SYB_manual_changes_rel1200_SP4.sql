if exists (select 1 from sysobjects where name ='drop_pk_if_exists' and type='P')
begin
exec ('drop procedure drop_pk_if_exists')
end
go

CREATE PROCEDURE drop_pk_if_exists(@arg_table_name VARCHAR(255))
AS

  DECLARE @CONSTRAINT_NAME VARCHAR(255)
  DECLARE @SQL VARCHAR(500),@SQL1 VARCHAR(500) 
  declare @vol_surface_id varchar(25), @vol_surface_date varchar(25)
  
  select @vol_surface_id = 'vol_surface_id'
  select @vol_surface_date = 'vol_surface_date' 
  SELECT @CONSTRAINT_NAME = i.name
  FROM sysindexes i, sysobjects t
  WHERE t.name = @arg_table_name AND i.id = t.id AND (i.status & 2048) = 2048
  
  SELECT @SQL = 'ALTER TABLE ' + @arg_table_name + ' DROP CONSTRAINT ' + @CONSTRAINT_NAME
  EXEC (@SQL)
  select @SQL1= 'ALTER TABLE ' + @arg_table_name + ' ADD CONSTRAINT ' + @CONSTRAINT_NAME + ' primary key ('+ @vol_surface_id + ',' + @vol_surface_date +')'
  exec (@SQL1)
GO

drop_pk_if_exists 'vol_surface_point_type_swap'
go
