DELETE domain_values where name='engineEventPoolPolicies' and value = 'tk.util.TradeLiquidatoinSequencePolicy'
go
DELETE domain_values where name='engineEventPoolPolicies' and value = 'tk.util.TransferInventorySequencePolicy'
go
DELETE domain_values where name='engineEventPoolPolicyAliases' and value = 'Inventory'
go
UPDATE domain_values set description='Sequence Policy for the LiquidationEngine' where name='engineEventPoolPolicies' and value='tk.util.TradeLiquidationSequencePolicy'
go


