if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go
update ers_limit set attr1_name = 'Counterparty' where service = 'Credit Risk' and attr1_name = 'Legal Entity'
go
update ers_limit_pending set attr1_name = 'Counterparty' where service = 'Credit Risk' and attr1_name = 'Legal Entity'
go
update ers_limit_authorise set attr1_name = 'Counterparty' where service = 'Credit Risk' and attr1_name = 'Legal Entity'
go
update ers_limit_authorise_reject set attr1_name = 'Counterparty' where service = 'Credit Risk' and attr1_name = 'Legal Entity'
go
update ers_limit_report_detail set report_value = 'Counterparty' where report_value = 'Legal Entity'
go
