create table white_spaces (table_name varchar(50) null, column_name varchar(50))
go
insert into white_spaces select o.name , c.name from sysobjects o , syscolumns c where o.id=c.id and c.name='user_name' or c.name='entered_name'
go
if exists (select 1 from sysobjects where name='white_space_column' and type ='P')
begin
exec('drop procedure white_space_column')
end
go

create  procedure white_space_column  as 
begin
declare
  c1 cursor for 
 select table_name,column_name from white_spaces 
OPEN c1
declare   @oname varchar(200)
declare   @cname varchar(256) 
declare @total numeric 
declare @v_sql varchar(500)
fetch c1 into @oname, @cname

WHILE (@@sqlstatus = 0)

begin
SELECT @v_sql = 'select @total = count(*) from '|| @oname || ' where ' || @cname ||' like '|| char(39)|| '% '||char(39)||' or ' || @cname || ' like '||char(39)||' %'||char(39)
 exec (@v_sql)
           IF @total > 0  
		   begin 
          print "The table '%1!' and column '%2!'.", @oname, @cname
        END
  fetch c1 into @oname, @cname
end
close c1
deallocate cursor c1
end
go
exec white_space_column
go
