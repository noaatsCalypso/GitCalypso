update domain_values set value ='SynthCollLiquidityPremiumCash' where name='ContextPosition.subtype' and value ='SyntheticCollateralizedLiquidityPremiumCash'
go
update domain_values set value ='SynthLiquidityPremiumCash' where name='ContextPosition.subtype' and value ='SyntheticLiquidityPremiumCash'
go
update domain_values set value ='SynthBasisCostCash' where name='ContextPosition.subtype' and value ='SyntheticBasisCostCash'
go
update domain_values set value ='SynthReferenceCostCash' where name='ContextPosition.subtype' and value ='SyntheticReferenceCostCash'
go

update pc_discount set sub_type ='SynthCollLiquidityPremiumCash' where sub_type ='SyntheticCollateralizedLiquidityPremiumCash'
go
update pc_discount set sub_type ='SynthLiquidityPremiumCash' where sub_type ='SyntheticLiquidityPremiumCash'
go
update pc_discount set sub_type ='SynthBasisCostCash' where sub_type ='SyntheticBasisCostCash'
go
update pc_discount set sub_type ='SynthReferenceCostCash' where sub_type ='SyntheticReferenceCostCash'
go