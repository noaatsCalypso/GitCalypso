if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go