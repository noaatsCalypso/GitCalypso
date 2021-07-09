
if exists (select 1 from sysobjects where name ='task_enrichment_proc' and type='P')
begin
exec ('drop procedure task_enrichment_proc')
end
go

create proc task_enrichment_proc 
as
begin
declare @cnt1 int
declare @cnt2 int
select @cnt1=count(*) from sysobjects where name = 'task_enrichment' and type='U'
if @cnt1 = 1 
	exec ('select @cnt2=count(*) from task_enrichment')
	if @cnt2=0 
	exec ('truncate table task_enrichment_field_config')
else if @cnt1=0
	exec ('truncate table task_enrichment_field_config')
end
go

exec task_enrichment_proc 
go
