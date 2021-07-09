/* Fix Risk Attribution Classname issue in HistSim */
update ers_risk_attribution set node_class=str_replace(node_class,'tk.risk.sim.',null) where node_class like '%tk.risk.sim.%'
go

/* Upgrade Version */
if not exists (select 1 from domain_values where name = 'ERSLimitServer.instances')
begin
	INSERT INTO domain_values ( name, value,description ) values ('ERSLimitServer.instances','enterpriseriskserver','')
	INSERT INTO domain_values ( name, value,description ) values ('ERSLimitServer.instances','erslimitserver','')
end
go


if not exists (select 1 from domain_values where name = 'ERSRiskServer.instances')
begin
	INSERT INTO domain_values ( name, value,description ) values ('ERSRiskServer.instances','enterpriseriskserver','')
	INSERT INTO domain_values ( name, value,description ) values ('ERSRiskServer.instances','ersriskserver','')
end
go

if not exists (select 1 from domain_values where name = 'ERSComplianceServer.instances')
begin
	INSERT INTO domain_values ( name, value,description ) values ('ERSComplianceServer.instances','enterpriseriskserver','')
	INSERT INTO domain_values ( name, value,description ) values ('ERSComplianceServer.instances','erscomplianceserver','')
end
go

begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='RiskEngineBroker'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'RiskEngineBroker',' ' )
end
end
go

begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='DataWarehouseRiskEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'DataWarehouseRiskEngine',' ' )
end
end
go

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