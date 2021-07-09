/* Upgrade Version */
delete from domain_values where name='ERSRiskServer.engines' and (value='DataWarehouseRiskEngine' or value='DataWareHouseRiskEngine')
;
insert into domain_values (name, value) values ('ERSRiskServer.engines', 'DataWareHouseRiskEngine')
;

delete from domain_values where name='engineName' and (value='DataWarehouseRiskEngine' or value='DataWareHouseRiskEngine')
;
insert into domain_values (name, value) values ('engineName', 'DataWareHouseRiskEngine')
;

update domain_values set value ='DataWareHouseRiskEngine'  where value='DataWarehouseRiskEngine'
;


delete from engine_param where engine_name = 'DataWarehouseRiskEngine' or engine_name= 'DataWareHouseRiskEngine'
;

insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','CLASS_NAME','com.calypso.engine.warehouse.DataWareHouseRiskEngine')
;
delete from engine_param where engine_name='DataWareHouseRiskEngine' and param_name='DISPLAY_NAME'
;
insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','DISPLAY_NAME','Data Warehouse Risk Engine')
;
delete from engine_param where engine_name='DataWareHouseRiskEngine' and param_name='INSTANCE_NAME'
;
insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','INSTANCE_NAME','enterpriseriskserver')
;
delete from engine_param where engine_name='DataWareHouseRiskEngine' and param_name='STARTUP'
;
insert into engine_param (engine_name,param_name,param_value) values ('DataWareHouseRiskEngine','STARTUP','true')
; 
