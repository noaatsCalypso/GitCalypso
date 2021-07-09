/* Upgrade Version */
delete from domain_values where name='ERSRiskServer.engines' and (value='DataWarehouseRiskEngine' or value='DataWareHouseRiskEngine')
go
insert into domain_values (name, value) values ('ERSRiskServer.engines', 'DataWareHouseRiskEngine')
go

delete from domain_values where name='engineName' and (value='DataWarehouseRiskEngine' or value='DataWareHouseRiskEngine')
go
insert into domain_values (name, value) values ('engineName', 'DataWareHouseRiskEngine')
go

update domain_values set value ='DataWareHouseRiskEngine'  where value='DataWarehouseRiskEngine'
go


delete from engine_param where engine_name = 'DataWarehouseRiskEngine' or engine_name='DataWareHouseRiskEngine'
go

insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','CLASS_NAME','com.calypso.engine.warehouse.DataWareHouseRiskEngine')
go
insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','DISPLAY_NAME','Data Warehouse Risk Engine')
go
insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','INSTANCE_NAME','enterpriseriskserver')
go
insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','STARTUP','true')
go 
/* Fix Risk Attribution Classname issue in HistSim */
update ers_risk_attribution set node_class=str_replace(node_class,'tk.risk.sim.',null) where node_class like '%tk.risk.sim.%'
go
