INSERT INTO account_trans(account_id, order_id, attribute, value, translated_value, translation_b) (SELECT DISTINCT(account_id), MAX(order_id)+1, 'ClearingCashAccount', 'True', null, 1 from account_trans where account_id in (select distinct account_id from account_trans where Attribute = 'MarginCall' and value is not null and account_id not in (select distinct(account_id) from account_trans where attribute = 'ClearingCashAccount' and value is not null ) ) group by account_id)
/
update report_win_def set use_pricing_env=1 where def_name='BOPosition'
/
DECLARE v_domain_exists NUMBER := 0; BEGIN SELECT COUNT(*) INTO v_domain_exists FROM domain_values WHERE name = 'MTMFlowsIncludedInSFR'; IF v_domain_exists > 0 THEN INSERT INTO domain_values(name, value, description) SELECT 'NPVReversalFlows', value, description FROM domain_values WHERE name = 'ClearingNPVFlowNames' AND value NOT IN (SELECT value FROM domain_values WHERE name = 'MTMFlowsIncludedInSFR'); UPDATE domain_values SET name = 'NPVFlows' WHERE name = 'MTMFlowsIncludedInSFR'; DELETE FROM domain_values WHERE name = 'ClearingNPVFlowNames'; DELETE FROM domain_values WHERE name = 'domainName' AND value = 'ClearingNPVFlowNames'; DELETE FROM domain_values WHERE name = 'domainName' AND value = 'MTMFlowsIncludedInSFR'; END IF; END;
/
UPDATE currency_default_attr SET attribute_name = 'LCHClearingTransferSettleLag' WHERE attribute_name = 'SwapClearSpotDays' AND currency_code NOT IN (SELECT currency_code FROM currency_default_attr WHERE attribute_name = 'LCHClearingTransferSettleLag')
/
DELETE FROM bo_workflow_rule WHERE rule_name = 'ETDTradeEnrichment'
/
