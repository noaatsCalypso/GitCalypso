/*  Domain Value MarginInput.SCHEDULE.ProductClass Migration */
/*  Create a product mapping for each entry of this domain name */
INSERT
INTO cm_product_mapping
  (
    id,
    tenant_id,
    version,
    creation_user,
    creation_user_type,
    creation_date,
    last_update_user,
    last_update_user_type,
    last_update_date,
    product_type,
    product_class,
    source
  )
SELECT MD5(RANDOM()::TEXT || ':' || CURRENT_TIMESTAMP)::UUID,
  0,
  0,
  '00000000-0000-0000-0000-000000000000',
  'urn:calypso:cloud:platform:iam:model:User',
  FLOOR(EXTRACT(epoch FROM NOW())*1000),
  '00000000-0000-0000-0000-000000000000',
  'urn:calypso:cloud:platform:iam:model:User',
  FLOOR(EXTRACT(epoch FROM NOW())*1000),
  value,
  UPPER(description),
  'CUSTOM'
FROM domain_values
WHERE name = 'MarginInput.SCHEDULE.ProductClass'
and value not in ('CDSABSIndex',
'CDSABSIndexTranche',
'CDSIndex',
'CDSIndexDefinition',
'CDSIndexOption',
'CDSIndexTranche',
'CDSIndexTrancheOption',
'CDSNthDefault',
'CDSNthLoss',
'CFDConvertibleArbitrage',
'CFDDirectional',
'CFDPairTrading',
'CFDRiskArbitrage',
'CancellableCDS',
'CancellableCDSNthDefault',
'CancellableCDSNthLoss',
'CancellableSwap',
'CancellableXCCYSwap',
'CapFloor',
'CappedSwap',
'CappedSwapNonDeliverable',
'Commodity',
'CommodityCertificate',
'CommodityForward',
'CommodityIndexSwap',
'CommodityOTCOption2',
'CommoditySwap',
'CommoditySwap2',
'CommoditySwaption',
'ContingentCreditDefaultSwap',
'CreditDefaultSwap',
'CreditDefaultSwapABS',
'CreditDefaultSwapLoan',
'CreditDefaultSwaption',
'EquityCliquetOption',
'EquityForward',
'EquityIndex',
'EquityLinkedSwap',
'EquityStructuredOption',
'ExoticCapFloor',
'ExtendibleCDS',
'ExtendibleCDSNthDefault',
'ExtendibleCDSNthLoss',
'FRA',
'FRAInArrear',
'FRAStandard',
'FXCompoundOption',
'FXNDF',
'FXNDFSwap',
'FXOption',
'FXOptionForward',
'FXOptionStrategy',
'FXOptionStrip',
'FXOptionSwap',
'FxSwap',
'IRStructuredOption',
'OTCCommodityOption','OTCEquityOption',
'OTCEquityOptionVanilla',
'PerformanceSwap',
'PortfolioSwap',
'PortfolioSwapPosition',
'PositionFXExposure',
'PositionFXNDF',
'PreciousMetalDepositLease',
'PreciousMetalLeaseRateSwap',
'QuotableStructuredOption',
'ScriptableOTCProduct',
'SingleSwapLeg',
'SpreadCapFloor',
'SpreadLock',
'SpreadSwap',
'StructureProduct',
'StructuredTranche',
'Swap',
'SwapCrossCUrrency',
'SwapNonDeliverable',
'Swaption',
'TRSBasket',
'TotalReturnSwap',
'TriggerSwaption',
'VarianceOption',
'VarianceSwap',
'VolatilityIndex',
'Warrant',
'WarrantIssuance',
'XCCYSwap')
and not exists (select 1 from cm_product_mapping
where product_type = value)
;