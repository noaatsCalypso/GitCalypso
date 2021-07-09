if exists (select 1 from sysobjects where name ='add_domain_values' and type='P')
begin
exec ('drop procedure add_domain_values')
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

add_domain_values 'remittanceType','Repayment',''
go

add_domain_values 'remittanceType','IntradayRepayment',''
go

add_domain_values 'CustomerTransfer.subtype','Repayment',''
go

add_domain_values 'CustomerTransfer.subtype','IntradayRepayment',''
go

add_domain_values 'systemKeyword','needToDoInterestCleanup','';
go