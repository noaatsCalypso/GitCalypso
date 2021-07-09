if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go


if not exists (select 1 from sysobjects where name='ers_measure_config' and type='U')
begin
exec ('create table ers_measure_config (display_name varchar(64) null, service  varchar(64) null)')
end
go

update ers_measure_config set display_name = 'PV01' where service = 'CreditRisk' and measure = 'PV01' and display_name = 'Delta'
go
if not exists (select 1 from sysobjects where name='ers_analysis_configuration' and type='U')
begin
exec ('create table ers_analysis_configuration (analysis varchar(64) not null,
config_name varchar(32) not null,
attribute_name varchar(32) null,
attribute_value varchar(255) null,
inuse numeric not null,
order_id numeric not null,
additional varchar(255) null)')
end
go
delete from ers_analysis_configuration where analysis='HistSim' and config_name='groupings'
go
update ers_measure_config set display_name = 'PercNotional' where service = 'CreditRisk' and measure = 'Loan Equivalent' and display_name = 'Loan Equivalent'
go
