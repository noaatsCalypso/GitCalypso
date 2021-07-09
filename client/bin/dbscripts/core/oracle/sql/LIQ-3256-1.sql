update domain_values set value ='SynthCollLiquidityPremiumCash' where name='ContextPosition.subtype' and value ='SyntheticCollateralizedLiquidityPremiumCash'
;
update domain_values set value ='SynthLiquidityPremiumCash' where name='ContextPosition.subtype' and value ='SyntheticLiquidityPremiumCash'
;
update domain_values set value ='SynthBasisCostCash' where name='ContextPosition.subtype' and value ='SyntheticBasisCostCash'
;
update domain_values set value ='SynthReferenceCostCash' where name='ContextPosition.subtype' and value ='SyntheticReferenceCostCash'
;

update pc_discount set sub_type ='SynthCollLiquidityPremiumCash' where sub_type ='SyntheticCollateralizedLiquidityPremiumCash'
;
update pc_discount set sub_type ='SynthLiquidityPremiumCash' where sub_type ='SyntheticLiquidityPremiumCash'
;
update pc_discount set sub_type ='SynthBasisCostCash' where sub_type ='SyntheticBasisCostCash'
;
update pc_discount set sub_type ='SynthReferenceCostCash' where sub_type ='SyntheticReferenceCostCash'
;
