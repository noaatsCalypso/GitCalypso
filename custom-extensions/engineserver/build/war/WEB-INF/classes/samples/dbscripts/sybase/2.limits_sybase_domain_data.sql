
begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='ERSLimitEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'ERSLimitEngine',' ' )
end
end
go

begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='ERSCreditEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'ERSCreditEngine',' ' )
end
end
go

alter table ers_measure_parms add keycolumn numeric(10, 0) identity
go
begin tran
delete ers_measure_parms where keycolumn not in (select max( keycolumn )
from ers_measure_parms group by measure, parameter_name, parameter_value)
go
commit tran
go
alter table ers_measure_parms drop keycolumn
go

if not exists (select * from ers_measure_parms where measure = 'Settlement' and parameter_name = 'Flow Types' and parameter_value = 'PRINCIPAL')
begin
   insert ers_measure_parms(measure,parameter_name,parameter_value) VALUES ('Settlement', 'Flow Types', 'PRINCIPAL')
end
if not exists (select * from ers_measure_parms where measure = 'Settlement' and parameter_name = 'Ignore CLS' and parameter_value = 'No')
begin
   insert ers_measure_parms(measure,parameter_name,parameter_value) VALUES ('Settlement', 'Ignore CLS', 'No')
end
go

