create or replace function current_time_since_epoch return number is
  n_current_time number(38, 0);
begin
  select (to_date(to_char(sysdate, 'MM/DD/YYYY HH24:MI:SS'), 'MM/DD/YYYY HH24:MI:SS') - to_date('19700101', 'YYYYMMDD')) * 24 * 60 * 60 * 1000 into n_current_time from dual;
  return n_current_time;
end current_time_since_epoch;
/
create or replace function random_uuid return VARCHAR2 is
  v_uuid VARCHAR2(40);
begin
  select lower(regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5')) into v_uuid from dual;
  return v_uuid;
end random_uuid;
/

/*  Insert values from the domain value MarginInput.SCHEDULE.ProductClass into product mapping */
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
SELECT RANDOM_UUID(),
  0,
  0,
  '00000000-0000-0000-0000-000000000000',
  'urn:calypso:cloud:platform:iam:model:User',
  CURRENT_TIME_SINCE_EPOCH(),
  '00000000-0000-0000-0000-000000000000',
  'urn:calypso:cloud:platform:iam:model:User',
  CURRENT_TIME_SINCE_EPOCH(),
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

drop function random_uuid
;
drop function current_time_since_epoch
;