add_column_if_not_exists 'conversion_factor_mark','entered_datetime','datetime null'
go
add_column_if_not_exists 'conversion_factor_mark','job_id','numeric null'
go
create procedure fill_cfactor_mark_header 
as 
begin
declare @n1 int , @n2 int, @user_name varchar(50), @vsql varchar(500)
select @n1=count(*) from sysobjects where name='conversion_factor_mark'
select @n2=count(*) from sysobjects where name='conversion_factor_mark_header'
if (@n1 = 1 and @n2=1 )
begin
	select @user_name='calypso_user'
	exec ('select * into c_mark_back_up from conversion_factor_mark')
	exec ('insert into conversion_factor_mark_header(valuation_date,pl_config_id,job_id,entered_datetime ) 
	select valuation_date, pl_config_id,max(job_id),max(entered_datetime) from conversion_factor_mark group by valuation_date, pl_config_id ')
	select @vsql='update conversion_factor_mark_header set user_name ='||char(39)||@user_name||char(39)
	exec(@vsql)
	
end
end
go

exec fill_cfactor_mark_header
go
drop procedure fill_cfactor_mark_header
go

