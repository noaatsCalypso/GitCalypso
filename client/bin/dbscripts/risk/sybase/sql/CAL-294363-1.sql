if exists (select 1 from sysobjects where type='P' and name ='clear_objects')
begin
exec ('drop procedure clear_objects')
end
go
if exists (select 1 from sysobjects where type='P' and name ='clear_objects')
begin
exec ('drop procedure clear_view')
end
go
create procedure clear_objects
as
begin

declare @ObjectName VARCHAR(255)
declare drop_table_crsr cursor
 for
   select name from sysobjects where (name like 'cs_%' or name like 'delete_%') and type='U'
   open drop_table_crsr
   fetch drop_table_crsr into @ObjectName
 while (@@sqlstatus=0)
 begin
 if not exists (select 1 from sysobjects where name = 'calypso_info')
   begin
   execute ('drop table '+ @ObjectName)
   print "dropped tables"
   
   fetch drop_table_crsr into @ObjectName
 End
 end
 close drop_table_crsr
 deallocate cursor drop_table_crsr
end
go


exec clear_objects
go
create procedure clear_view
as
begin

declare @ObjectName VARCHAR(255)
declare drop_table_crsr cursor
 for
   select name from sysobjects where (name like 'cs_%' or name like 'delete_%') and type='V'
   open drop_table_crsr
   fetch drop_table_crsr into @ObjectName
 while (@@sqlstatus=0)
 begin
 if not exists (select 1 from sysobjects where name = 'calypso_info')
   begin
   execute ('drop view '+ @ObjectName)
   print "dropped view"
   
   fetch drop_table_crsr into @ObjectName
 End
 end
 close drop_table_crsr
 deallocate cursor drop_table_crsr
end
go
exec clear_view
go

drop procedure clear_objects
go
drop procedure clear_view
go

if exists (select 1 from sysobjects where type='U' and name ='analysis_message')
begin
exec ('drop table analysis_message')
end
go
 if exists (select 1 from sysobjects where type='U' and name ='analysis_datatable')
begin
exec ('drop table analysis_datatable')
end
go
if exists (select 1 from sysobjects where type='U' and name ='store_schema')
begin
exec ('drop table store_schema')
end
go
if exists (select 1 from sysobjects where type='U' and name ='middletier_seed')
begin
exec ('drop table middletier_seed')
end
go
if exists (select 1 from sysobjects where type='U' and name ='column_projection')
begin
exec ('drop table column_projection')
end
go
if exists (select 1 from sysobjects where type='U' and name ='tenant')
begin
exec ('drop table tenant')
end
go
if exists (select 1 from sysobjects where type='U' and name ='live_pl_output')
begin
exec ('drop table live_pl_output')
end
go
if exists (select 1 from sysobjects where type='U' and name ='live_ladder_output')
begin
exec ('drop table live_ladder_output')
end
go
 