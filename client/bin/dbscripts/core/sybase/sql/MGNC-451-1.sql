INSERT INTO scenario_rule (scenario_name,class_name,comments,version_num,owner_name,is_parametric) 
	values ('FXQuotes1pct','com.calypso.tk.risk.ScenarioRuleQuotes',null,0,'',0)
go
INSERT INTO scenario_items (scenario_name, class_name, item_seq, attribute_name, attribute_value)
	values ('FXQuotes1pct','com.calypso.tk.risk.ScenarioRuleQuotes',0,'LOAD_QUOTES_NAME','Y')
go
INSERT INTO scenario_items (scenario_name, class_name, item_seq, attribute_name, attribute_value)
	values ('FXQuotes1pct','com.calypso.tk.risk.ScenarioRuleQuotes',0,'SPECIFIC','0 FX. 1 %(rel)')
go