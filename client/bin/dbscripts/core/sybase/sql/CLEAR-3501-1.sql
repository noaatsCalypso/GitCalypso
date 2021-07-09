INSERT INTO account_trans(account_id, 
                          order_id, 
                          attribute, 
                          value, 
                          translated_value, 
                          translation_b)
                  (SELECT DISTINCT(account_id), 
                          MAX(order_id)+1, 
                          'ClearingCashAccount', 
                          'True', 
                          null, 
                          1 
                    from account_trans 
                    where account_id in 
                    	(select distinct account_id 
                         from account_trans 
                         where attribute = 'MarginCall' 
                         and value is not null
                         and account_id not in 
                         	(select distinct(account_id) 
                         	from account_trans 
                         	where attribute = 'ClearingCashAccount' 
                         	and value is not null
                         	)
						) 
                    group by account_id)
go
update report_win_def set use_pricing_env=1 where def_name='BOPosition'
go
declare @v_domain int 
SELECT @v_domain = count(*) FROM domain_values WHERE name = 'MTMFlowsIncludedInSFR' 
if (@v_domain > 0) 
 BEGIN 
      INSERT INTO domain_values(name, value, description) 
         SELECT 'NPVReversalFlows', value, description 
         FROM domain_values 
         WHERE name = 'ClearingNPVFlowNames' AND value NOT IN 
            (SELECT value FROM domain_values WHERE name = 'MTMFlowsIncludedInSFR') 
      UPDATE domain_values SET name = 'NPVFlows' WHERE name = 'MTMFlowsIncludedInSFR' 
DELETE FROM domain_values WHERE name = 'ClearingNPVFlowNames' 
      DELETE FROM domain_values WHERE name = 'domainName' AND value = 'ClearingNPVFlowNames' 
      DELETE FROM domain_values WHERE name = 'domainName' AND value = 'MTMFlowsIncludedInSFR' 
 end 
go 
update currency_default_attr set attribute_name = 'LCHClearingTransferSettleLag' 
where attribute_name = 'SwapClearSpotDays' 
and currency_code not in (select currency_code from currency_default_attr where attribute_name = 'LCHClearingTransferSettleLag')
go
DELETE FROM bo_workflow_rule WHERE rule_name = 'ETDTradeEnrichment'
go