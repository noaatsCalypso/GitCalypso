/* Scheduling Engine Main Entry Changes */

select * into main_entry_bkgfx14 from main_entry_prop
go
drop table main_entry_prop
go

select * into main_entry_prop from main_entry_prop_bak14 
go

if exists (Select 1 from sysobjects where name ='mainent_schd' and type='P')
begin
exec ('drop proc mainent_schd')
end
go

create  procedure mainent_schd as 
begin
declare
  c1 cursor for 
  select property_name, user_name,substring(property_name,1,charindex('Action',property_name)-1),
  property_value from main_entry_prop where property_value = 'refdata.ScheduledTaskTreeFrame'
 
OPEN c1
declare   @prefix_code varchar(16)
declare   @prop_value varchar(256)
declare   @user_name varchar(255)
declare   @property_name varchar(255)

fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

WHILE (@@sqlstatus = 0)

begin

    select @prefix_code = substring(@property_name,1,charindex('Action',@property_name)-1) from main_entry_prop 
	where @prop_value = 'refdata.ScheduledTaskTreeFrame'

    delete from main_entry_prop where property_name like   
	@prefix_code+'%' and user_name =@user_name
    
fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

end
close c1
deallocate cursor c1
end
go
exec mainent_schd
go
if exists (Select 1 from sysobjects where name ='mainent_schd_new' and type='P')
begin
exec ('drop proc mainent_schd_new')
end
go

create  procedure mainent_schd_new  as 
begin
declare
  c1 cursor for 
  select property_name, user_name,substring(property_name,1,charindex('Action',property_name)-1),
  property_value from main_entry_prop where property_value = 'refdata.ScheduledTaskWindow' 
 
OPEN c1
declare   @prefix_code varchar(16)
declare   @prop_value varchar(256)
declare   @user_name varchar(255)
declare   @property_name varchar(255)

fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

WHILE (@@sqlstatus = 0)

begin
 select @prefix_code = substring(property_name,1,charindex('Action',property_name)-1) from main_entry_prop 
	where property_value = 'refdata.ScheduledTaskWindow' 
 update main_entry_prop set property_value='scheduling.ScheduledTaskListWindow'where property_name IN (   
	@prefix_code+'Action', 
	@prefix_code+'Image',   
	@prefix_code+'Label',    
	@prefix_code+'Accelerator',   
	@prefix_code+'Mnemonic',   
	@prefix_code+'Tooltip') and user_name =@user_name and property_value=@prop_value 

fetch c1 into @property_name, @user_name, @prefix_code, @prop_value

end
close c1
deallocate cursor c1
end
go

exec mainent_schd_new
go
create table me_temp1 (prop_name varchar(200), user_name varchar(200))
go
create  procedure pop_me_temp1 as 
begin
declare
  c1 cursor for 
   
 select user_name,substring(property_name,1,charindex('Action',property_name)-1) from main_entry_prop_bak14 where property_value = 'refdata.ScheduledTaskTreeFrame'

OPEN c1
declare   @user_name varchar(255)
declare   @property_name varchar(255)

fetch c1 into @user_name ,@property_name

WHILE (@@sqlstatus = 0)

begin

    insert into me_temp1 select property_value, user_name from main_entry_prop_bak14
	where (property_value like @property_name+' %' or property_value like '% ' + @property_name or property_value like '% '+ @property_name +' %') 
	and user_name = @user_name 
	
fetch c1 into @user_name ,@property_name


end
close c1
deallocate cursor c1
end
go
exec pop_me_temp1
go
create table me_temp2 (user_name varchar(200), prop_value varchar(200) )
go
insert into me_temp2 select user_name,substring(property_name,1,charindex('Action',property_name)-1) from main_entry_prop_bak14 where property_value = 'refdata.ScheduledTaskTreeFrame'
go
alter table me_temp1 add n int identity 
go
alter table me_temp1 add n int identity
go
alter table me_temp2 add prop_name varchar(200) null
go
update me_temp2 set prop_name = (select prop_name from me_temp1 where me_temp1.n = me_temp2.n)
go
create procedure me_removespace as 
begin
declare
c1 cursor for
select user_name, prop_value, prop_name from me_temp2
open c1
declare @user_name varchar(200)
declare @prop_value varchar(200)
declare @prop_name varchar(200)

fetch c1 into @user_name, @prop_value, @prop_name
while (@@sqlstatus=0)
begin 
update main_entry_prop set property_value = str_replace(@prop_name,@prop_value + ' ', null) where property_value like @prop_value+' %' and 
property_name like '%'+'SubMenu' and user_name=@user_name

update main_entry_prop set property_value = str_replace(@prop_name,' '+@prop_value,null ) where property_value like '% '+ @prop_value and 
property_name like '%'+'SubMenu' and user_name=@user_name

update main_entry_prop set property_value = str_replace(@prop_name,' '+ @prop_value + ' ',' ') where property_value like '% '+ @prop_value +' %' and 
property_name like '%'+'SubMenu' and user_name=@user_name
fetch c1 into @user_name, @prop_value, @prop_name
end
close c1
deallocate cursor c1
end
go
exec me_removespace
go
drop procedure me_removespace
go
drop procedure mainent_schd_new
go
drop procedure pop_me_temp1
go
drop procedure mainent_schd
go
drop table me_temp1
go
drop table me_temp2
go
