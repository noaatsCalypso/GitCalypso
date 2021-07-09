
update ers_measure_config 
     set measure= 'Issuer Market Value'
     where display_name = 'Isser Market Risk'
go


/* Update Version */
if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go 

/* Update Version */
if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go

update ers_measure_config 
     set measure= 'Issuer Market Value'
     where display_name = 'Isser Market Risk'
go
