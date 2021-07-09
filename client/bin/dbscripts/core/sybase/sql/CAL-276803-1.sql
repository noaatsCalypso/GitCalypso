if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go
delete from ers_analysis_configuration where analysis = 'HistSim' and attribute_value='Total' and inuse=0
go