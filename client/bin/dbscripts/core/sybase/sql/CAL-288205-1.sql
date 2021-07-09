/* "PRICING_SHEET_XML_GENERATION" doesnt exists for sybase as it is not supported in ASE yet */
add_column_if_not_exists  'option_contract','dateformat','numeric null' 
go
add_column_if_not_exists  'eto_contract','dateformat','numeric null' 
go

update option_contract set dateformat = 1 where  dateformat is null
go
update eto_contract set dateformat = 1 where  dateformat is null
go
if not exists (select 1 from sysobjects where name='official_pl_config_back15')
begin
exec ('select * into official_pl_config_back15 from official_pl_config')
end
go
if exists (select 1 from sysobjects , syscolumns where sysobjects.name='official_pl_config' and syscolumns.name='year_end_month' and syscolumns.usertype=2)
begin
exec ('alter table official_pl_config add yrmon numeric null')
exec ('alter table official_pl_config add yrmonth varchar(255) null')
end
go
add_column_if_not_exists 'official_pl_config','yrmon','numeric null'
go
add_column_if_not_exists 'official_pl_config','yrmonth','varchar(255) null'
go

create procedure update_yrmon  
as
begin
 update official_pl_config set  yrmonth = convert(varchar(255),year_end_month) + ' 1,1999' 
declare @yrmon int 
 declare  c1 cursor for 
 select isdate(yrmonth) from official_pl_config 
open c1 
fetch c1 into @yrmon 
WHILE (@@sqlstatus = 0)
begin
if @yrmon = 1 
begin
 update official_pl_config set yrmon = convert(numeric,datepart (month,convert(datetime,yrmonth) )) from official_pl_config where isdate(yrmonth)= 1 
end
else if @yrmon=0
begin   
 print  'wrong data' 
end 
 fetch c1 into @yrmon
end
close c1
deallocate cursor c1
end
go
if exists (select 1 from sysobjects , syscolumns where sysobjects.name='official_pl_config' and syscolumns.name='year_end_month' and syscolumns.usertype=2)
begin
exec ('exec update_yrmon')
end
go
drop procedure update_yrmon
go
if exists (select 1 from official_pl_config where yrmon is null )
begin
exec ('alter table official_pl_config drop yrmonth')
exec ('alter table official_pl_config drop yrmon')
end
else if not exists (select 1 from official_pl_config where yrmon is null)
begin
exec ('alter table official_pl_config drop yrmonth')
exec ('alter table official_pl_config drop year_end_month')
exec ('sp_rename "official_pl_config.yrmon", year_end_month')
end
go
UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='005',
        version_date='20160701'
go 

