DELETE DOMAIN_VALUES where name='engineEventPoolPolicies' and value = 'tk.util.TradeLiquidatoinSequencePolicy'
;
DELETE DOMAIN_VALUES where name='engineEventPoolPolicies' and value = 'tk.util.TransferInventorySequencePolicy'
;
DELETE DOMAIN_VALUES where name='engineEventPoolPolicyAliases' and value = 'Inventory'
;
UPDATE DOMAIN_VALUES set description='Sequence Policy for the LiquidationEngine' where name='engineEventPoolPolicies' and value='tk.util.TradeLiquidationSequencePolicy'
;
