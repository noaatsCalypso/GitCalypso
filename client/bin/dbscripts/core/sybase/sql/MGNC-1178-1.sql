if not exists (select scenario_name from scenario_rule where scenario_name = 'all_fx')
begin
  insert into scenario_items (scenario_name,class_name,item_seq,attribute_name,attribute_value) values ('all_fx','com.calypso.tk.risk.ScenarioMarketData',0,'SPECIFIC','FX ANY ANY ANY')
  insert into scenario_rule (scenario_name,class_name,comments,version_num,owner_name,is_parametric) values ('all_fx','com.calypso.tk.risk.ScenarioMarketData',null,0,'calypso_user',0)
end
go

if not exists (select scenario_name from scenario_items where scenario_name = 'all_fx')
begin
  insert into scenario_items (scenario_name,class_name,item_seq,attribute_name,attribute_value) values ('all_fx','com.calypso.tk.risk.ScenarioMarketData',0,'SPECIFIC','FX ANY ANY ANY')
  insert into scenario_items (scenario_name,class_name,item_seq,attribute_name,attribute_value) values ('all_fx','com.calypso.tk.risk.ScenarioMarketData',1,'SPECIFIC','FXVolatility ANY ANY ANY')
end
go
