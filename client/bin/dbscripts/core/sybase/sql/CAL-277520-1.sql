/* Upgrade Version */

/* Fix Risk Attribution Classname issue in HistSim */
update ers_risk_attribution set node_class=str_replace(node_class,'tk.risk.sim.',null) where node_class like '%tk.risk.sim.%'
go

alter table 
   ers_grouping 
modify 
   attr1_name varchar(64),
   attr1_value varchar(64),
   attr2_name varchar(64),
   attr2_value varchar(64),
   attr3_name varchar(64),
   attr3_value varchar(64),
   attr4_name varchar(64),
   attr4_value varchar(64),
   attr5_name varchar(64),
   attr5_value varchar(64),
   attr6_name varchar(64),
   attr6_value varchar(64),
   attr7_name varchar(64),
   attr7_value varchar(64),
   attr8_name varchar(64),
   attr8_value varchar(64),
   attr9_name varchar(64),
   attr9_value varchar(64),
   group_id varchar(64)
go

/* Make scenario set description unique CAL-197473 */
update ers_scenario_set set description = convert(varchar,scset_id)+'-'+description
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
select @c= count(*) from engine_config where engine_name='DataWareHouseRiskEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'DataWareHouseRiskEngine',' ' )
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

begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='ERSComplianceEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'ERSComplianceEngine',' ' )
end
end
go
