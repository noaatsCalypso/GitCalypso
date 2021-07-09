DO $$
    DECLARE
        vScenarioName varchar(16) := 'all_fx';
        vCount number;
    BEGIN
        select count(*) into vCount from scenario_rule where scenario_name = vScenarioName;
        if vCount < 1 then
            insert into scenario_rule (scenario_name,class_name,comments,version_num,owner_name,is_parametric) values (vScenarioName,'com.calypso.tk.risk.ScenarioMarketData',null,0,'calypso_user',0);
        end if;

        select count(*) into vCount from scenario_items where scenario_name = vScenarioName;
        if vCount < 1 then
            insert into scenario_items (scenario_name,class_name,item_seq,attribute_name,attribute_value) values (vScenarioName,'com.calypso.tk.risk.ScenarioMarketData',0,'SPECIFIC','FX ANY ANY ANY');
            insert into scenario_items (scenario_name,class_name,item_seq,attribute_name,attribute_value) values (vScenarioName,'com.calypso.tk.risk.ScenarioMarketData',1,'SPECIFIC','FXVolatility ANY ANY ANY');
        end if;
    END
$$
;
