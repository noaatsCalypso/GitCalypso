delete from AN_VIEWER_CONFIG where ANALYSIS_NAME='CrossAssetPL' and VIEWER_CLASS_NAME='apps.risk.CrossAssetPLAnalysisViewer'
;

 


alter table calypso_seed drop primary key drop index
;

begin
 drop_column_if_exists('calypso_seed','seed_offset');
end;
;

alter table calypso_seed add constraint pk_calypso_seed 
      primary key (seed_name)
;

alter table referring_object modify rfg_tbl_name varchar2(128)
;

INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES ( 10000, 'DefaultClient', 'PLMark', 0, 'NonTransactional', 'LFU' )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES ( 7, 'FixingDatePolicyId', 1 )
;
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'curve_prepay', 'curve_prepay_hist', 0 )
;
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'curve_default', 'curve_default_hist', 0 )
;
INSERT INTO currency_default ( currency_code, rounding, rounding_method, iso_code, country, default_holidays, rate_index_code, default_day_count, group_list, spot_days, default_tenor, time_zone, rate_decimals, is_precious_metal_b ) VALUES ( 'SGD', 2.0, 'NEAREST', 'SGD', 'SINGAPORE', 'SIN', 'SOR', 'ACT/365', 'ASIAN', 2, 180, 'Asia/Singapore', -1, 0 )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'curve', 'curve_prepay', 'curve_id,curve_date', 'curve_id,curve_date', 'Curve', 'NONE' )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'curve', 'curve_default', 'curve_id,curve_date', 'curve_id,curve_date', 'Curve', 'NONE' )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_abs', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'incomingType', 'Mapping between External Message type and BO Message Type' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'incomingType', 'MT300', 'INC_FXCONFIRM' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'incomingType', 'MT305', 'INC_FXOPT_CONFIRM' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'incomingType', 'MT306', 'INC_FXOPT_CONFIRM' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddModifyTaskInternalReference', 'Allow User to Change Entry in Task Internal Reference' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddModifyTaskPriorityConfig', 'Allow User to Change Entry in Task Priority' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'TS_INCREASE_TASK_PRIORITY', 'Allow User to Increase Task Priority in TaskStation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'TS_DECREASE_TASK_PRIORITY', 'Allow User to Decrease Task Priority in TaskStation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'TS_FIX_TASK_PRIORITY', 'Allow User to Fix Task Priority in TaskStation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'CommoditySwap2', 'New implementation of Commodity Swap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'CommodityOTCOption2', 'New implementation of Commodity OTC Option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'TradeLevelOverride.Products', 'List of products implementing TradeLevelOverride' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'Swap', 'Swap is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'XCCySwap', 'XCCySwap is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'CancellableSwap', 'CancellableSwap is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'CapFloor', 'CapFloor is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'CappedSwap', 'CappedSwap is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'Swaption', 'Swaption is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'SpreadCapFloor', 'SpreadCapFloor is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'TradeLevelOverride.Products', 'SpreadSwap', 'SpreadSwap is TLO compatible' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'TradeLevelOverride.PricerKeys', 'List of pricer override keys' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'TradeLevelOverride.MdiKeys', 'List of market data item override keys' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'SwaptionSABRDirect', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'commodity.ForwardPriceMethods', 'Methods for calculating forward prices.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'Linear', 'Linearly interpolate price between the two closest dates stradling FixDate.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'Fixed', 'Price is taken from a specified pillar date independent of FixDate.'
)
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'Nearby', 'Price is taken from the first pillar date equal to or greater than the FixDate.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'SecondNearby', 'Price is taken from the first pillar date with a succeeding date that is equal to or greater than the FixDate.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'IceNearby', 'Price is taken from the first pillar date greater than the FixDate.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'Lme3M', 'Specific to LME futures contracts. Linearly interpolate but use a date 3 months hence.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'LmeCash', 'Specific to LME futures contracts. Linearly interpolate but use a date 2 days hence.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'sdiCompareKeys', 'SDI Comparison Keys to override default behaviour' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'CapSABRDirect', 'Generates SABR vol surface from Cap maturity quotes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'CapBpVol', 'Generates bpvol surface from Cap maturity quotes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'volSurfaceGenerator.commodity', 'Generators for Commodity Options' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator.commodity', 'CommodityDelta', 'VS Generator for Commodity Options' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'eXSPSystemVariables', 'Available SystemVariables for eXSP' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'AccumulatedCouponIncludingCurrentSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'AccumulatedCouponSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'CalculatedNotionalSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'CalculatedRateSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'CouponPeriodSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'CurrentNotionalSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'DaysSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'InitialNotionalSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'PreviousNotionalSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eXSPSystemVariables', 'PreviousRateSVar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AssignOverrideKeys', 'Allow the user to assign Trade Level Override keys to a trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyOverrideKeys', 'Allow the user to modify Trade Level Override keys in the Pricer Config' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreatePLMark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyPLMark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemovePLMark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'PLMark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CorrelationSurface.gensimple', 'BaseCorrelationLPM', 'Base Correlation Surface generator using the Large Homogeneous Pool Model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'AccountActivity', 'AccountActivity Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'VarianceSwap.subtype', 'VarianceSwap subtypes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FXOption.optionSubType', 'Types of FXOptions' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'PLMark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'commodityMktDataUsage', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodityMktDataUsage', 'FOR', 'Forecast Curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ExternalMessageField.Amounts', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ExternalMessageField.Fields', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ExternalMessageField.Roles', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'loanType', 'Revolver', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'taskPriorities', 'Task Priority List' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskPriorities', '0.LOW', 'Low priority' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskPriorities', '1.NORMAL', 'Normal priority' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskPriorities', '2.HIGH', 'High priority' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ExternalMessageField.Dates', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ExternalMessageField.References', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ExternalMessageField.MessageMapper', 'MessageMapper class prefix' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT300', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'EOD_PLMARKING', 'End of day PL Marking.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommoditySwap.PaymentFrequency', 'Payment frequencies for CommoditySwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommoditySwap.PaymentFrequency', 'PeriodicPaymentFrequency', 'Periodic' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommoditySwap.PaymentFrequency', 'DailyPaymentFrequency', 'Daily' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommoditySwap.PaymentFrequency', 'FutureContractPaymentFrequency', 'Contract' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommoditySwap.PaymentFrequency', 'BulletPaymentFrequency', 'Bullet' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommoditySwap.PaymentFrequency', 'WholePaymentFrequency', 'Whole' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodOptVolTypeDelta', 'Pricers for CommoditySwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodOptVolTypeDelta', '10', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodOptVolTypeDelta', '25', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'FutureOptionCommodity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTransfer', 'ResetWorkflowType', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'INTEREST_END', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM_TD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM_TD_REV', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM_SD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM_INC', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM_DEC', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM_CHG', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'NOM_MAT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeCancelStatus', 'CANCELED', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CapFloor.Pricer', 'PricerCapFloorBpVol', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CDSNthLoss.Pricer', 'PricerCDSNthLossLPM', 'NthLoss pricer using the Large Homogeneous Pool Model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CDSNthDefault.Pricer', 'PricerCDSNthDefaultOFM', 'NthDefault pricer using Gaussian one factor model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swap.Pricer', 'PricerXCCySwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swap.Pricer', 'PricerBRLSwap', 'Pricer for Brazilian Swap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swap.subtype', 'BRL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'GenericOption.Pricer', 'PricerCapFloortionLGMM', 'Linear Gauss Markov model to value option on caps/floors' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CDSIndexTranche.Pricer', 'PricerCDSIndexTrancheOFM', 'Pricer for CDSIndexTranche using the Gaussian one factor
model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CDSIndexTranche.Pricer', 'PricerCDSIndexTrancheLPM', 'Pricer for CDSIndexTranche using the Large Homogeneous Pool Model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.subtype', 'FX', 'FX' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.subtype', 'Commodity', 'Commodity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.subtype', 'Equity', 'Equity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.subtype', 'EquityIndex', 'EquityIndex' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.Pricer', 'PricerVarianceSwapFX', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.Pricer', 'PricerVarianceSwapCommodity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.Pricer', 'PricerVarianceSwapEquity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceSwap.Pricer', 'PricerVarianceSwapEquityIndex', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionVanilla'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionVanilla', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionBarrier'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionBarrier', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionDigital'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionDigital', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionFader'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionFader', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionAsian'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionAsian', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionVolFwd'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionVolFwd', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionRangeAccrual'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionRangeAccrual', '' )
;
delete from domain_values where name='FXOption.Pricer' and value='PricerFXOptionLookBack'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionLookBack', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityLinkedSwap.Pricer', 'PricerEquityLinkedSwapAccrual', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AssetPerformanceSwap.Pricer', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetPerformanceSwap.Pricer', 'PricerAssetPerformanceSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AssetPerformanceSwap.Pricer', 'PricerAssetPerformanceSwapAccrual', '' )
;
delete from domain_values where name='FXOption.subtype' and value='BARRIER'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.subtype', 'BARRIER', '' )
;
delete from domain_values where name = 'FXOption.subtype' and value='RANGEACCRUAL'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.subtype', 'RANGEACCRUAL', '' )
;
delete from domain_values where name= 'FXOption.subtype' and value='VOLFWD'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.subtype', 'VOLFWD', '' )
;
delete from domain_values where name='FXOption.subtype' and value='FADER'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.subtype', 'FADER', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : BARRIER_UP_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : BARRIER_UP_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : BARRIER_DOWN_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : BARRIER_DOWN_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_TYPE_A', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_TYPE_B', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'BARRIER : BARRIER', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_EXPIRY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_DOUBLE_ONE TOUCH', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_DOUBLE_NO TOUCH', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_ONE TOUCH_UP_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_NO TOUCH_UP_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_ONE TOUCH_DOWN_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'DIGITAL : DIGITAL_NO TOUCH_DOWN_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'ASIAN : AVERAGE RATE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'ASIAN : AVERAGE STRIKE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'ASIAN : GEOM AVERAGE RATE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'ASIAN : DBL_AVG', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'FADER : DECREASE NOTIONAL_BELOW', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'FADER : INCREASE NOTIONAL_BELOW', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'FADER : DECREASE NOTIONAL_ABOVE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'FADER : INCREASE NOTIONAL_ABOVE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'FIXED STRIKE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'LOOKBACK : FLOATING STRIKE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : DOWN_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : DOWN_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_IN_DOWN_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_IN_DOWN_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_OUT_DOWN_IN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_OUT_DOWN_OUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'VANILLA : PUT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.optionSubType', 'VANILLA : CALL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Repo.subtype', 'Pledge', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CREDIT_SUBSTITUTION_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'FutureLiquidationEventFilter', 'Future Liquidation Event Filter' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'feeCalculator', 'BPNominalRepo', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'feeCalculator', 'BPPrincipalRepo', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productFamily', 'AssetPerformanceSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'AssetPerformanceSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'quoteType', 'ImpliedCorrelation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'Comparison', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'CrossAssetPL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'EOD_BROKER_STATEMENT', 'EOD Broker Statement' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'EUROCLEAR_TRIPARTY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'PRICE_FIXING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'FUTURE_POSITION_EXPIRY', 'Future Process Expiry' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'SYNCHRONIZE_PC', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'GENERATE_FWD_POINTS', 'Generating Commodity Fwd Point underlyings as of valDate in the Schedule Task' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'GENERATE_COMM_FUTURES', 'Generating Commodity Futures as of valDate in the Schedule Task' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'GENERATE_COMM_VOL_POINTS', 'Generating Commodity Volatility Point underlyings as of valDate in the Schedule Task' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'WeightedPricing', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'Comparison', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'newEventTypeTradeAction', 'Specify trade action for the CallNotice product' )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CREDIT_SUBSTITUTION_EFFECT', 'Credit Substitution Effect', 65, 'NPV', 0 )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'RISK_OPTIMISE', 'true' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_CALIBRATION_INSTRUMENTS', 'CORE_SWAPTION' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_CALIBRATION_SCHEME', 'EXACT_STEP_SIGMA' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_CONTROL_VARIATE', 'true' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_LATTICE_NODES', '35' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_QUAD_ORDER', '20' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_LATTICE_CUTOFF', '6.0' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloortionLGMM', 'LGMM_LATTICE_NODES', '15' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloortionLGMM', 'LGMM_LATTICE_CUTOFF', '5.5' )
;

INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'QUAD', 'Legendre' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2F', 'QUAD', 'Legendre' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'QUAD_POINTS', '30' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2F', 'QUAD_POINTS', '30' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'USE_SMILE_VOL', 'false' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2F', 'USE_SMILE_VOL', 'false' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloorHagan', 'STRIKE_SPREAD_DIRECTION', 'CENTRAL' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloorHagan', 'STRIKE_SPREAD_EPSILON', '10' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_CALIBRATION_INSTRUMENTS', 'CORE_SWAPTION' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_CALIBRATION_SCHEME', 'EXACT_STEP_SIGMA' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_CONTROL_VARIATE', 'true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_LATTICE_CUTOFF', '6' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_LATTICE_NODES', '35' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_QUAD_ORDER', '20' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_RISK_OPTIMISE', 'true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_CASH_THRESHOLD', '7' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_SWAP_BY_REPLICATION', 'true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_RISK_OPTIMISE', 'true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_CASH_YIELD_CURVE_MODEL', 'LINEAR' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_SWAP_USE_BASIS_ADJ', 'false' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_BLACK_ON_HAGAN', 'true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_USE_EXACT_CONVEXITY_FUNC', 'true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_CASH_BY_REPLICATION', 'false' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_COMPUTE_CORRECTION', 'true' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_SWAP_YIELD_CURVE_MODEL', 'EXACT_BOND' )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'BP_VOL_TRANSFORMATION', 'EXACT' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NET_VOLATILITY', 'tk.core.PricerMeasure', 259, ' Total volatility (realized + unrealized)' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'REALIZED_VOLATILITY', 'tk.core.PricerMeasure', 260, 'realized volatility' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PV01_PER_REF_NAME', 'tk.core.TabularPricerMeasure', 271 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'LGMM_MEANREV_SCEN', 'tk.core.PricerMeasure', 275 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_STRIKE', 'tk.core.PricerMeasure', 254, 'Npv of the strike amount on a generic option' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_UNDERLYING', 'tk.core.PricerMeasure', 253, 'Npv of the underlying on
a generic option' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'TIME_VALUE', 'tk.core.PricerMeasure', 255, 'time value of option' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'ATM_STRIKE_AMOUNT', 'tk.core.PricerMeasure', 256, 'At the money strike amount' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'PAR_STRIKE', 'tk.core.PricerMeasure', 258, 'DF weighted average strike' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SALI_TREE_PAYOFFS', 'tk.core.PricerMeasure', 261, 'Sali tree payoffs' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'BREAK_EVEN_RATE_PAYLEG', 'tk.core.PricerMeasure', 264, '' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'BREAK_EVEN_RATE_RECLEG', 'tk.core.PricerMeasure', 265, '' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SABR_GREEKS', 'tk.core.PricerMeasure', 266, 'SABR model greeks' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SABR_MODEL', 'tk.core.PricerMeasure', 267, 'SABR model parameterisation'
)
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'GBM2F_GREEKS', 'tk.core.PricerMeasure', 268, 'Greeks for the GBM2F model
are computed and stored in client data' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LGMM_BESTFIT_ERROR', 'tk.core.PricerMeasure', 270, 'Graphs the best-fit error function' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURRENT_NOTIONAL', 'tk.core.PricerMeasure', 269 )
;

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DELTA_B4_UP_BARRIER', 'tk.core.PricerMeasure', 246 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DELTA_B4_DOWN_BARRIER', 'tk.core.PricerMeasure', 247 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_B4_UP_BARRIER', 'tk.core.PricerMeasure', 248 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_B4_DOWN_BARRIER', 'tk.core.PricerMeasure', 249 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SETTLEMENT_VALUE', 'tk.core.PricerMeasure', 257, 'discounted value of SETTLEMENT_AMOUNT' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURRENT_RATE', 'tk.core.PricerMeasure', 262 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PROJECTED_INTEREST', 'tk.core.PricerMeasure', 272 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCUMULATED_ACCRUAL', 'tk.core.PricerMeasure', 273 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NOTIONAL_ACCRUAL', 'tk.core.PricerMeasure', 274 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SETTLEMENT_AMOUNT_ACCRUAL', 'tk.core.PricerMeasure', 277 )
;
delete from pricing_param_name where param_name='VEGA_WEIGHT_SURFACE' and param_type='java.lang.String'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b ) VALUES ( 'VEGA_WEIGHT_SURFACE', 'java.lang.String', 'Weighted Volatility Surface Template
Name', 1 )
;
delete from pricing_param_name where param_name='USE_ATM_VOL' and param_type='java.lang.Boolean'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_ATM_VOL', 'java.lang.Boolean', 'true,false', 'FXOption : Determines if ATM vol is to be used for pricing exotics', 0, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'FX_OPTFWD_REVAL_FREQUENCY', 'java.lang.String', 'DLY,WK,MTH,NON',
'Frequency of revaluations for FX Option Forward and FX Option Swap trade to determine risk(position) date', 1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'FIXING_DATE_ACCRUAL', 'java.lang.Boolean', 'true,false', 'Realize
cashflows based off Fixing Date', 1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MAX_SIGMA', 'com.calypso.tk.core.Rate', '', 'The maximum value of the mode volatility to use in certain calibration methods', 1, 'MAX_SIGMA', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MIN_SIGMA', 'com.calypso.tk.core.Rate', '', 'The miniumu value of the mode volatility to use in certain calibration methods', 1, 'MIN_SIGMA', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MAX_MEAN_REVERSION', 'com.calypso.tk.core.Rate', '', 'The maximum value of the mode mean reversion to use in certain calibration methods', 1, 'MAX_MEAN_REVERSION', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MIN_MEAN_REVERSION', 'com.calypso.tk.core.Rate', '', 'The minimum value of the mode mean reversion to use in certain calibration methods', 1, 'MIN_MEAN_REVERSION', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name, default_value ) VALUES ( 'MISSING_HISTORICAL_PRICE_POLICY', 'java.lang.String', 'Class name for a policy to return historical prices when the exact date is missing.', 1, 'MISSING_HISTORICAL_PRICE_POLICY', '' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'BE_INCL_ACC', 'java.lang.Boolean', 'true,false', 'Specifies whether to include accrued interest when computing break-even rate and related measures.', 0, 'true' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'SUPPRESS_ROUNDING', 'java.lang.Boolean', 'true,false', 'Indicates
whether the pricer should attempt to suppress any rounding to produce smoother results', 0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'BP_VOL_TRANSFORMATION', 'java.lang.String', 'EXACT,HAGAN_APPROX,STREET_PROXY1,STREET_PROXY2,STREET_PROXY3,STREET_PROXY4,STREET_PROXY5', 'Transformation method for computing bp volatilities.', 1, 'BP_VOL_TRANSFORMATION', 'EXACT' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'BETA', 'java.lang.Double', '', 'SABR model parameter.', 0, 'BETA' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'SABR_CORRELATION', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'SABR_CORRELATION' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'ALPHA', 'com.calypso.tk.core.Rate', '', 'SABR model
parameter.', 0, 'ALPHA' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'VOLOFVOL', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'VOLOFVOL' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'ATMVOL', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'ATMVOL' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'SABRIMPLIEDVOL', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'SABRIMPLIEDVOL' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, is_global_b, display_name ) VALUES ( 'ACCRUAL_BOND_CONVENTION', 'java.lang.Boolean', 'true,false', 1, 'ACCRUAL_BOND_CONVENTION' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, is_global_b, display_name ) VALUES ( 'ADJUST_FOR_EXERCISE_FEES', 'java.lang.Boolean', 'true,false', 1, 'ADJUST_FOR_EXERCISE_FEES' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'PRIMARY_RISK', 'java.lang.String', 'Role of the Legal Entity to use to get the risky curves when pricing risky bonds', 0, 'PRIMARY_RISK' )
;
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ( 'COMM_INDEX_DEC', 'string', 0, 0, 0, 'Commodity,CommoditySwap,CommoditySwaption', 0 )
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc )
VALUES ( 22, 1, 'master_confirmation', 'master_confirmation_id', '1', 'sd_filter', 'MasterConfirmation', 'apps.refdata.MasterConfirmationWindow', 'Master Confirmation' )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 125, 'AccountActivity', 0, 1, 1 )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 126, 'ComparisonAnalysis', 1, 0, 1 )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'cu_fx_fixed', 'Curve Underlying FX Forward Fixed' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'curve_prepay', 'Curve Prepayment' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'curve_default', 'Curve Default' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'pc_abs', 'Pricer configuration for abs securities (ABS panel).' )
;


DELETE FROM domain_values WHERE name = 'volSurfaceGenerator' AND value = 'FXOptionDelta'
;
delete from domain_values where name = 'futureUnderType' and value = 'BRL'
;
INSERT INTO domain_values (name, value, description) values ('futureUnderType','BRL','')
;
INSERT INTO domain_values (name, value, description) values ('FutureMM.Pricer','PricerFutureMMBRL','')
;

UPDATE domain_values set value = 'Warrant.subtype' where name = 'domainName' and value = 'Warrant.Subtype'
;
UPDATE domain_values set name = 'Warrant.subtype' where name = 'Warrant.Subtype'
;
UPDATE domain_values set value = 'Certificate.subtype' where name = 'domainName' and value = 'Certificate.Subtype'
;
UPDATE domain_values set name = 'Certificate.subtype' where name = 'Certificate.Subtype'
;
DELETE ENGINE_CONFIG where engine_name = 'MatchingMessageEngine'
;
DELETE PS_EVENT_CONFIG where engine_name = 'MatchingMessageEngine'
;
DELETE PS_EVENT_FILTER where engine_name = 'MatchingMessageEngine'
;
DELETE DOMAIN_VALUES where name='engineName' and value = 'MatchingMessageEngine'
;
DELETE DOMAIN_VALUES where name='applicationName' and value = 'MatchingMessageEngine'
;


ALTER TABLE bo_ts_priority ADD hide_priorities VARCHAR2(64) NULL
;
UPDATE bo_ts_priority SET hide_priorities = '0' WHERE hide_low=1
;
UPDATE bo_ts_priority SET hide_priorities = hide_priorities||',1' WHERE hide_normal=1 AND hide_priorities IS NOT NULL
;
UPDATE bo_ts_priority SET hide_priorities = '1' WHERE hide_normal=1 AND hide_priorities IS NULL
;
UPDATE bo_ts_priority SET hide_priorities = hide_priorities||',2' WHERE hide_high=1 AND hide_priorities IS NOT NULL
;
UPDATE bo_ts_priority SET hide_priorities = '2' WHERE hide_high=1 AND hide_priorities IS NULL
;
UPDATE DOMAIN_VALUES set name = 'MatchingContext.Amounts' where name = 'ExternalMessageField.Amounts'
;
UPDATE DOMAIN_VALUES set name = 'MatchingContext.Dates' where name = 'ExternalMessageField.Dates'
;
UPDATE DOMAIN_VALUES set name = 'MatchingContext.Fields' where name = 'ExternalMessageField.Fields'
;
UPDATE DOMAIN_VALUES set name = 'MatchingContext.Roles' where name = 'ExternalMessageField.Roles'
;
UPDATE DOMAIN_VALUES set name = 'MatchingContext.References' where name = 'ExternalMessageField.References'
;

INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) VALUES (1000, 'mcc_npv_tol', 1)
;
INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) VALUES (1000, 'mcc_bag_tol', 1)
;
INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) VALUES (1000, 'mcc_time_tol', 1)
;

ALTER TABLE mcc_npv_tol ADD id numeric default 0 NOT NULL 
;
ALTER TABLE mcc_npv_tol ADD version_num numeric default 0 NULL
;
ALTER TABLE mcc_bag_tol ADD id numeric default 0 NOT NULL 
;
ALTER TABLE mcc_bag_tol ADD version_num numeric default 0 NULL
;
ALTER TABLE mcc_time_tol ADD id numeric default 0 NOT NULL 
;
ALTER TABLE mcc_time_tol ADD version_num numeric default 0 NULL
;

create or replace procedure mcc_npv_tol_tmp
AS

CURSOR c1 IS 
SELECT product_type, sub_type, branch_name, book_name, counterparty_name, currency, final_maturity, entity, tolerance_factor FROM mcc_npv_tol WHERE id = 0;

CURSOR last_id IS 
SELECT last_id FROM calypso_seed WHERE seed_name = 'mcc_npv_tol';

next_id             NUMBER := 0;
c_product_type      varchar(32);
c_sub_type          varchar(32);
c_branch_name       varchar(32);
c_book_name         varchar(32);
c_counterparty_name varchar(32);
c_currency          varchar(3);
c_final_maturity    varchar(15);
c_entity            varchar(12);
c_tolerance_factor  float := 0;


BEGIN
  OPEN last_id;
  FETCH last_id INTO next_id;
  CLOSE last_id;
  
  OPEN c1;
  
  LOOP
    
    FETCH c1 INTO c_product_type, c_sub_type, c_branch_name, c_book_name, c_counterparty_name, c_currency, c_final_maturity, c_entity, c_tolerance_factor;
    
    EXIT WHEN c1%NOTFOUND;
    
    next_id := next_id + 1;
    
    EXECUTE IMMEDIATE 'UPDATE mcc_npv_tol SET id = '||next_id||', version_num = 0 
    WHERE product_type = '||chr(39)||c_product_type||chr(39)||' 
    AND sub_type = '||chr(39)||c_sub_type||chr(39)||' 
    AND branch_name = '||chr(39)||c_branch_name||chr(39)||' 
    AND book_name = '||chr(39)||c_book_name||chr(39)||' 
    AND counterparty_name = '||chr(39)||c_counterparty_name||chr(39)||' 
    AND currency = '||chr(39)||c_currency||chr(39)||' 
    AND final_maturity = '||chr(39)||c_final_maturity||chr(39)||' 
    AND entity = '||chr(39)||c_entity||chr(39)||' 
    AND tolerance_factor = '||c_tolerance_factor; 
    
  END LOOP;
  
  next_id := next_id + 1;
  
  EXECUTE IMMEDIATE 'UPDATE calypso_seed SET last_id ='||next_id||' WHERE seed_name = ' ||chr(39)||'mcc_npv_tol' ||chr(39);
  
  CLOSE c1;
  COMMIT;
END mcc_npv_tol_tmp;
;

BEGIN
mcc_npv_tol_tmp;
END;
;

DROP PROCEDURE mcc_npv_tol_tmp
;

create or replace procedure mcc_bag_tol_tmp
AS

CURSOR c1 IS 
SELECT product_type, branch_name, book_name, currency, final_maturity, notional, bagatell_border FROM mcc_bag_tol WHERE id = 0;

CURSOR last_id IS 
SELECT last_id FROM calypso_seed WHERE seed_name = 'mcc_bag_tol';

next_id             NUMBER := 0;
c_product_type      varchar(32);
c_branch_name       varchar(32);
c_book_name         varchar(32);
c_currency          varchar(3);
c_final_maturity    varchar(15);
c_notional          varchar(64);
c_bagatell_border   float := 0;


BEGIN
  OPEN last_id;
  FETCH last_id INTO next_id;
  CLOSE last_id;
  
  OPEN c1;
  
  LOOP
    
    FETCH c1 INTO c_product_type, c_branch_name, c_book_name, c_currency, c_final_maturity, c_notional, c_bagatell_border;
    
    EXIT WHEN c1%NOTFOUND;
    
    next_id := next_id + 1;
    
    execute immediate 'UPDATE mcc_bag_tol SET id = '||next_id||', version_num = 0 
    WHERE product_type = '||chr(39)||c_product_type||chr(39)||' 
    AND branch_name = '||chr(39)||c_branch_name||chr(39)||' 
    AND book_name = '||chr(39)||c_book_name||chr(39)||'
    AND currency = '||chr(39)||c_currency||chr(39)||' 
    AND final_maturity = '||chr(39)||c_final_maturity||chr(39)||' 
    AND notional = '||chr(39)||c_notional||chr(39)||' 
    AND bagatell_border = '||c_bagatell_border;
    
  END LOOP;
  
  next_id := next_id + 1;
  
  EXECUTE IMMEDIATE 'UPDATE calypso_seed SET last_id ='||next_id||' WHERE seed_name =' ||chr(39)||'mcc_bag_tol' ||chr(39);
  
  CLOSE c1;
  COMMIT;
END mcc_bag_tol_tmp;
;

BEGIN
mcc_bag_tol_tmp;
END;
;

DROP PROCEDURE mcc_bag_tol_tmp
;


create or replace procedure mcc_time_tol_tmp
AS

CURSOR c1 IS 
SELECT product_type, time_tolerance FROM mcc_time_tol WHERE id = 0;

CURSOR last_id IS 
SELECT last_id FROM calypso_seed WHERE seed_name = 'mcc_time_tol';

next_id             NUMBER := 0;
c_product_type      varchar(32);
c_time_tolerance    varchar(5);


BEGIN
  OPEN last_id;
  FETCH last_id INTO next_id;
  CLOSE last_id;
  
  OPEN c1;
  
  LOOP
    
    FETCH c1 INTO c_product_type, c_time_tolerance;
    
    EXIT WHEN c1%NOTFOUND;
    
    next_id := next_id + 1;
    
    execute immediate 'UPDATE mcc_time_tol SET id = '||next_id||', version_num = 0 
    WHERE product_type = '||chr(39)||c_product_type||chr(39)||' 
    AND time_tolerance = '||chr(39)||c_time_tolerance||chr(39); 
    
  END LOOP;
  
  next_id := next_id + 1;
  
  EXECUTE IMMEDIATE 'UPDATE calypso_seed SET last_id ='||next_id||' WHERE seed_name =' ||chr(39)||'mcc_time_tol' ||chr(39);
  
  CLOSE c1;
  COMMIT;
END mcc_time_tol_tmp;
;

BEGIN
mcc_time_tol_tmp;
END;
;

DROP PROCEDURE mcc_time_tol_tmp
;


INSERT INTO domain_values(name,value,description) values
('function','ViewMarketConformityConfigDetail','Access permission to view Market Conformity tolerenace details')
;

INSERT INTO domain_values(name,value,description) values
('function','ModifyMarketConformityConfigDetail','Access permission to modify Market Conformity tolerenace details')
;

 

begin
 add_column_if_not_exists('currency_pair','delta_display_ccy','varchar2(32)');
end;
;

begin
 add_column_if_not_exists('currency_pair','pl_display_ccy','varchar2(32)');
end;
; 


UPDATE currency_pair 
  SET delta_display_ccy = 'Secondary', pl_display_ccy = 'Secondary'
 WHERE pair_pos_ref_b  = 1 AND (delta_display_ccy is null OR pl_display_ccy is null)
;  
UPDATE currency_pair 
   SET delta_display_ccy = 'Primary', pl_display_ccy = 'Primary'
 WHERE pair_pos_ref_b  = 0 AND (delta_display_ccy is null OR pl_display_ccy is null)
;  
UPDATE currency_pair 
   SET delta_display_ccy = 'Primary', pl_display_ccy = 'Primary'
 WHERE delta_display_ccy is null OR pl_display_ccy is null
;  
UPDATE currency_pair SET delta_display_ccy = 'Secondary' WHERE delta_display_ccy = 'Quoting'
;
UPDATE currency_pair SET pl_display_ccy = 'Secondary' WHERE pl_display_ccy = 'Quoting'
;


/* BZ 41149 */
UPDATE pc_surface SET desc_name = CONCAT(desc_name,'.ANY') WHERE desc_name LIKE '%Commodity%' AND desc_name NOT LIKE '%Commodity.%.%.%'
;

ALTER TABLE nds_ext_info ADD (
  fx_fixed_rate_b numeric(1) default 0 null,
  fx_timing varchar2(16) null,
  fx_fixed_rate float null,
  fx_first_rate float null)
;
UPDATE nds_ext_info SET fx_fixed_rate_b = 0 WHERE fx_fixed_rate_b is null
;
UPDATE nds_ext_info SET fx_timing = 'END_PER' WHERE fx_fixed_rate_b = 0
;
ALTER TABLE nds_ext_info modify fx_fixed_rate_b not null
;

update product_bond set allowed_redemption_type = 'Full' where allowed_redemption_type is null
;

alter table basic_product add include_underlying_b int default 0 null
;

create or replace procedure date2timestamp as
begin
declare cursor c1 is select table_name, column_name from user_tab_columns
        where data_type = 'DATE';
v_sql varchar(512);
begin
for c1_rec in c1 loop
 v_sql := 'alter table '||c1_rec.table_name||' modify '||c1_rec.column_name||' timestamp';
 execute immediate v_sql;
 end loop;
end;
end date2timestamp;
;

begin
 date2timestamp;
end;
;

update feed_address
set quote_name =
(select 'Inflation.'||rid.currency_code||'.'||rid.rate_index_code
from rate_index_default rid
where
feed_address.quote_name like 'Inflation.'||rid.currency_code||'.'||rid.rate_index_code||'.%')
where
exists
(select 1
from rate_index_default rid
where
feed_address.quote_name like  'Inflation.%.%.%'
and feed_address.quote_name like 'Inflation.'||rid.currency_code||'.'||rid.rate_index_code||'.%')
;

DELETE FROM referring_object WHERE rfg_tbl_name='mrgcall_config' AND rfg_tbl_join_cols='sec_sd_filter_name'  
;  

INSERT INTO domain_values(name,value,description) VALUES ('domainName','frequency','Custom frequencies')
;


begin
 add_column_if_not_exists('pricing_env','day_change_rule','VARCHAR2(32)');
end;
;


create table pc_pricer_bak as select * from pc_pricer
;

create or replace procedure pc_pricer_tmp as
begin
declare
cursor c1 is select PRICER_CONFIG_NAME, PRODUCT_TYPE, PRODUCT_PRICER from pc_pricer
        where PRODUCT_TYPE = 'FXOption.ANY.ANY' and PRODUCT_PRICER = 'PricerFXOption';
v_sql_ins1 varchar(512);
v_sql_ins2 varchar(512);
v_sql_ins3 varchar(512);
v_sql_ins4 varchar(512);
v_sql_ins5 varchar(512);
v_sql_ins6 varchar(512);
v_sql_ins7 varchar(512);
v_sql_ins8 varchar(512);
v_sql_ins9 varchar(512);
v_sql_del varchar(512);
begin
for c1_rec in c1 loop

  v_sql_ins1 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.FADER'||chr(39)||','||chr(39)||'PricerFXOptionFader'||chr(39)||')';

  execute immediate v_sql_ins1;

  v_sql_ins2 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.VOLFWD'||chr(39)||','||chr(39)||'PricerFXOptionVolFwd'||chr(39)||')';

  execute immediate v_sql_ins2;

  v_sql_ins3 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.DIGITAL'||chr(39)||','||chr(39)||'PricerFXOptionDigital'||chr(39)||')';

  execute immediate v_sql_ins3;

  v_sql_ins4 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.American'||chr(39)||','||chr(39)||'PricerFXOptionVanilla'||chr(39)||')';

  execute immediate v_sql_ins4;

  v_sql_ins5 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.LOOKBACK'||chr(39)||','||chr(39)||'PricerFXOptionLookBack'||chr(39)||')';

  execute immediate v_sql_ins5;

  v_sql_ins6 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.ASIAN'||chr(39)||','||chr(39)||'PricerFXOptionAsian'||chr(39)||')';

  execute immediate v_sql_ins6;

 v_sql_ins7 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.BARRIER'||chr(39)||','||chr(39)||'PricerFXOptionBarrier'||chr(39)||')';

  execute immediate v_sql_ins7;

  v_sql_ins8 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.European'||chr(39)||','||chr(39)||'PricerFXOptionVanilla'||chr(39)||')';

  execute immediate v_sql_ins8;

  v_sql_ins9 := 'insert into pc_pricer (PRICER_CONFIG_NAME,PRODUCT_TYPE,PRODUCT_PRICER) values ('
        ||chr(39)||c1_rec.PRICER_CONFIG_NAME||chr(39)||','||chr(39)||'FXOption.ANY.RANGEACCRUAL'||chr(39)||','||chr(39)||'PricerFXOptionRangeAccrual'||chr(39)||')';

  execute immediate v_sql_ins9;

end loop;

 delete from pc_pricer where PRODUCT_TYPE = 'FXOption.ANY.ANY' and PRODUCT_PRICER = 'PricerFXOption';
 commit;

end;
end pc_pricer_tmp;
;

begin
  pc_pricer_tmp;
end;
;

drop procedure pc_pricer_tmp
;

INSERT INTO domain_values (name, value, description) values ('feeCalculator' , 'MarginPtsPVBaseSpot', '')
;

DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_RISKY_PRIM'
;
DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_MTM_PRIM'
;
DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_RISKY_SEC'
;
DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_MTM_SEC'
;
DELETE FROM pricer_measure where measure_name = 'DELTA_RISKY_PRIM'
;
DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_PRIM'
;
DELETE FROM pricer_measure where measure_name = 'DELTA_RISKY_SEC'
;
DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_SEC'
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment) 
  VALUES('FWD_DELTA_RISKY_PRIM','tk.core.PricerMeasure',252,'Delta where MTM currency is secondary')
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment) 
  VALUES('FWD_DELTA_RISKY_SEC','tk.core.PricerMeasure',251,'Delta where MTM currency is primary')
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment) 
  VALUES('DELTA_RISKY_SEC','tk.core.PricerMeasure',243,'Delta where MTM currency is primary replaces DELTA_W_PREMIUM')
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment) 
  VALUES('DELTA_RISKY_PRIM','tk.core.PricerMeasure',244,'Delta where MTM currency is secondary')
;
ALTER TABLE tws_risk_node ADD dispatcher_name char(32) null
;

INSERT INTO domain_values(name,value,description) VALUES ('Swaption.subtype','FT European','')
;
INSERT INTO domain_values(name,value,description) VALUES ('Swaption.subtype','FT American','')
;
INSERT INTO domain_values(name,value,description) VALUES ('Swaption.subtype','FT Bermudan','')
;

create table ps_event_bak as select * from ps_event
;

update report_win_def set use_book_hrchy = 0, use_color=0 where def_name = 'RiskAggregation'
;

delete from domain_values where name = 'scheduledTask' and value = 'SAVE_POSITION_SNAPSHOT'
;
insert into domain_values values ('scheduledTask',  'SAVE_POSITION_SNAPSHOT', 'Task to store snapshots of positions')
;

create table cu_future_tmptable(
contract_id number,
contract_rank number,
cu_currency char(3) default null,
quote_name varchar(255) default null,
user_name varchar(32) default null
)
;

insert into cu_future_tmptable
select cu.contract_id, cu.contract_rank, under.cu_currency, under.quote_name, under.user_name
from future_contract fc, date_rule dr, cu_future cu, curve_underlying under
where 
fc.trading_rule = dr.date_rule_id
and
cu.contract_id = fc.contract_id
and
dr.add_months > 0
and 
cu.contract_rank <= dr.add_months
and 
under.cu_id = cu.cu_id
;

create or replace procedure cu_future_tmp
AS

CURSOR c1 IS select * from cu_future_tmptable;
CURSOR last_id IS 
select last_id from calypso_seed where seed_name = 'refdata';
trade_seed_id int;
contract_id   int;
contract_rank int;
currency      varchar(3);
quote_name    varchar(255);
user_name     varchar(32);

begin

  open last_id;
  FETCH last_id into trade_seed_id;
  close last_id;
  open c1;
    LOOP
    FETCH c1 into contract_id, contract_rank, currency, quote_name, user_name;
       if c1%NOTFOUND then exit;
       end if;
       IF user_name is null THEN
       user_name := 'calypso_user';
       END IF;
       trade_seed_id := trade_seed_id + 1;
       execute immediate 'INSERT INTO cu_future (cu_id, contract_id, contract_rank, serial_b)
       values('||trade_seed_id||','||contract_id||','||contract_rank||',1)';       
       execute immediate 'INSERT INTO curve_underlying (cu_id, cu_type, cu_currency, quote_name, user_name, version_num)
       values('||trade_seed_id||','||chr(39)||'CurveUnderlyingFuture'||chr(39)||','||chr(39)||currency||chr(39)||','||chr(39)||quote_name||chr(39)||','||chr(39)||user_name||chr(39)||',0)';
    END LOOP;
    trade_seed_id := trade_seed_id + 1;
    execute immediate 'update calypso_seed set last_id ='||trade_seed_id||' where seed_name =' ||chr(39)||'refdata' ||chr(39);
  close c1;
  commit;
end;
;

begin
cu_future_tmp;
end;
;

drop procedure cu_future_tmp
;

drop table cu_future_tmptable
;

alter table bond_pool_factor add (int_shrt_reim float, prin_shrt_reim float, writedown_reim float)
;

update bond_pool_factor set int_shrt_reim=int_shrt*-1,int_shrt=0 where int_shrt < 0
;
update bond_pool_factor set prin_shrt_reim=prin_shrt*-1,prin_shrt=0 where prin_shrt < 0
;
update bond_pool_factor set writedown_reim=writedown*-1,writedown=0 where writedown < 0
;


/* temp stored proc to change exising char(1) to int         */
/* do it this way because many of the columns are defined    */
/* as NOT NULL in the data-model                             */
/* so we drop/replace, add as NULL, then let xml decide the  */
/* nullability of the column                                 */

create or replace procedure char2int (tab_name IN varchar, col_name IN varchar) as
begin
declare 
v_sql varchar(512);
begin

v_sql := 'alter table '||tab_name||' rename column '||col_name||' to '||col_name||'_tmp';
execute immediate v_sql;

v_sql := 'alter table '||tab_name||' add '||col_name||' int';
execute immediate v_sql;

v_sql := 'update '||tab_name||' set '||col_name||' = to_number('||col_name||'_tmp)';
execute immediate v_sql;

v_sql := 'alter table '||tab_name||' drop column '||col_name||'_tmp';
execute immediate v_sql;

end;
end char2int;
;


alter table an_viewer_config drop primary key drop index
;
alter table pc_info drop primary key drop index
;

begin
 char2int('ACCOUNT_TRANS','TRANSLATION_B');
end;
;

begin
 char2int('ACCRETION_INDEX','RESET_BUSDAY_B');
end;
;

begin
 char2int('ACCRETION_INDEX','RESET_DEFAULT_B');
end;
;

begin
 char2int('ACCRETION_INDEX_HIST','RESET_BUSDAY_B');
end;
;

begin
 char2int('ACCRETION_INDEX_HIST','RESET_DEFAULT_B');
end;
;

begin
 char2int('ACC_ACCOUNT','AUTOMATIC_B');
end;
;

begin
 char2int('ACC_ACCOUNT','BILLING_B');
end;
;

begin
 char2int('ACC_ACCOUNT','INTEREST_BEARING');
end;
;

begin
 char2int('ACC_ACCOUNT','LIMIT_B');
end;
;

begin
 char2int('ACC_ACCOUNT','STATEMENT');
end;
;

begin
 char2int('ACC_ACCOUNT','STATEMENT_B');
end;
;

begin
 char2int('ACC_ACCOUNT','TRADE_DATE_B');
end;
;

begin
 char2int('ACC_ACCOUNT_INTEREST','IS_PENALTY_B');
end;
;

begin
 char2int('ACC_EVENT_CONFIG','IS_FEE');
end;
;

begin
 char2int('ACC_INTEREST_CONFIG','IS_COMPOUND_B');
end;
;

begin
 char2int('ACC_INTEREST_CONFIG','IS_PENALTY_B');
end;
;

begin
 char2int('ACC_INTEREST_CONFIG','IS_TIERED_B');
end;
;

begin
 char2int('ACC_INTEREST_CONFIG','IS_WHOLE_BALANCE_B');
end;
;

begin
 char2int('ACC_INTEREST_RANGE','APPLY_ON_SPREAD_B');
end;
;

begin
 char2int('ACC_INTEREST_RANGE','IS_AMOUNT_B');
end;
;

begin
 char2int('ACC_INTEREST_RANGE','IS_FIXED_B');
end;
;

begin
 char2int('ACC_RULE','CHECKPE_B');
end;
;

begin
 char2int('ACC_RULE','DAILY_CLOSING');
end;
;

begin
 char2int('ACC_RULE','FIRSTLAST_B');
end;
;

begin
 char2int('ACC_STATEMENT','IS_CASH');
end;
;

begin
 char2int('ACC_STATEMENT_CFG','IS_PAYMENT');
end;
;

begin
 char2int('ACC_STATEMENT_CFG','NO_MVT');
end;
;

begin
 char2int('ACC_STATEMENT_CFG','ZERO_BALANCE');
end;
;

begin
 char2int('ACC_SWEEP_CFG','AGGREGATE_B');
end;
;

begin
 char2int('ACC_SWEEP_CFG','MAX_BAL_B');
end;
;

begin
 char2int('ACC_SWEEP_CFG','MIN_BAL_B');
end;
;

begin
 char2int('ACC_SWEEP_CFG','XFER_PIVOT_ONLY');
end;
;

begin
 char2int('ADVICE_CONFIG','ALWAYS_SEND');
end;
;

begin
 char2int('ADVICE_CONFIG','INACTIVE');
end;
;

begin
 char2int('ADVICE_CONFIG','MATCHING');
end;
;

begin
 char2int('ADVICE_DOCUMENT','ADVICE_SENT');
end;
;

begin
 char2int('ADVICE_DOCUMENT','IS_BINARY');
end;
;

begin
 char2int('ADVICE_DOCUMENT','IS_COMPRESSED');
end;
;

begin
 char2int('ADVICE_DOC_HIST','ADVICE_SENT');
end;
;

begin
 char2int('ADVICE_DOC_HIST','IS_BINARY');
end;
;

begin
 char2int('ADVICE_DOC_HIST','IS_COMPRESSED');
end;
;

begin
 char2int('AN_VIEWER_CONFIG','READ_VIEWER_B');
end;
;

begin
 char2int('ASIAN_PARAMETERS','ADJUSTED');
end;
;

begin
 char2int('ASIAN_PARAMETERS','CUSTOM');
end;
;

begin
 char2int('ASIAN_PARAMETERS','ROLL_ON_DAY');
end;
;

begin
 char2int('ASIAN_PARAMETERS','ROLL_ON_END_DATE');
end;
;

begin
 char2int('BOND_ASSET_BACKED','DELAY_BUS_DAY_B');
end;
;

begin
 char2int('BOND_ASSET_BACKED','PAYDOWN_BUS_DAY_B');
end;
;

begin
 char2int('BOND_DEFAULTS','FIXED_B');
end;
;

begin
 char2int('BOND_INFO','COMMISSION_PAID_B');
end;
;

begin
 char2int('BO_AUDIT','ALLOW_UNDO_B');
end;
;

begin
 char2int('BO_AUDIT_HIST','ALLOW_UNDO_B');
end;
;

begin
 char2int('BO_CRE','MATCHING');
end;
;

begin
 char2int('BO_CRE_HIST','MATCHING');
end;
;

begin
 char2int('BO_MESSAGE','DOC_EDITED_B');
end;
;

begin
 char2int('BO_MESSAGE','EXTERNAL_B');
end;
;

begin
 char2int('BO_MESSAGE','MATCHING_B');
end;
;

begin
 char2int('BO_MESSAGE_HIST','DOC_EDITED_B');
end;
;

begin
 char2int('BO_MESSAGE_HIST','EXTERNAL_B');
end;
;

begin
 char2int('BO_MESSAGE_HIST','MATCHING_B');
end;
;

begin
 char2int('BO_POSTING','MATCHING');
end;
;

begin
 char2int('BO_POSTING_HIST','MATCHING');
end;
;

begin
 char2int('BO_TRANSFER','AVAILABLE');
end;
;

begin
 char2int('BO_TRANSFER','IS_FIXED');
end;
;

begin
 char2int('BO_TRANSFER','IS_KNOWN');
end;
;

begin
 char2int('BO_TRANSFER','IS_PAYMENT');
end;
;

begin
 char2int('BO_TRANSFER','IS_RETURN');
end;
;

begin
 char2int('BO_TRANSFER','NETTED_TRANSFER');
end;
;

begin
 char2int('BO_TRANSFER_HIST','AVAILABLE');
end;
;

begin
 char2int('BO_TRANSFER_HIST','IS_FIXED');
end;
;

begin
 char2int('BO_TRANSFER_HIST','IS_KNOWN');
end;
;

begin
 char2int('BO_TRANSFER_HIST','IS_PAYMENT');
end;
;

begin
 char2int('BO_TRANSFER_HIST','IS_RETURN');
end;
;

begin
 char2int('BO_TRANSFER_HIST','NETTED_TRANSFER');
end;
;

begin
 char2int('CALYPSO_DATATYPE','IS_DEFAULT_NULL');
end;
;

begin
 char2int('CALYPSO_DATATYPE','IS_NULLABILITY_SET');
end;
;

begin
 char2int('CALYPSO_DATATYPE','IS_NULLABLE');
end;
;

begin
 char2int('CALYPSO_TABLE_EXT','IS_STATIC_DATA');
end;
;

begin
 char2int('CALYPSO_TREE_NODE','LEAF_B');
end;
;

begin
 char2int('CAP_SWAP_EXT_INFO','P_DIG_CAP_B');
end;
;

begin
 char2int('CAP_SWAP_EXT_INFO','P_EX_FIRST_B');
end;
;

begin
 char2int('CAP_SWAP_EXT_INFO','P_INCLUDE_SPREAD_B');
end;
;

begin
 char2int('CAP_SWAP_EXT_INFO','R_DIG_CAP_B');
end;
;

begin
 char2int('CAP_SWAP_EXT_INFO','R_EX_FIRST_B');
end;
;

begin
 char2int('CAP_SWAP_EXT_INFO','R_INCLUDE_SPREAD_B');
end;
;

begin
 char2int('CASH_FLOW_COMPOUND','BASIS_CONVERT_B');
end;
;

begin
 char2int('CASH_FLOW_COMPOUND','FIXED_RATE_B');
end;
;

begin
 char2int('CASH_FLOW_COMPOUND','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_COUPON','FIXED_RATE_B');
end;
;

begin
 char2int('CASH_FLOW_COUPON','IS_MM');
end;
;

begin
 char2int('CASH_FLOW_COUPON','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_COUPON','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_FLOW_DIV','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_OPTCPN','AVERAGING_B');
end;
;

begin
 char2int('CASH_FLOW_OPTCPN','DISCOUNT_B');
end;
;

begin
 char2int('CASH_FLOW_OPTCPN','INTERPOLATED_B');
end;
;

begin
 char2int('CASH_FLOW_OPTCPN','IS_MM');
end;
;

begin
 char2int('CASH_FLOW_OPTCPN','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_OPTCPN','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_FLOW_OPTION','AVERAGING_B');
end;
;

begin
 char2int('CASH_FLOW_OPTION','DISCOUNT_B');
end;
;

begin
 char2int('CASH_FLOW_OPTION','INTERPOLATED_B');
end;
;

begin
 char2int('CASH_FLOW_OPTION','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_OPTION','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_FLOW_PRICHG','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('CASH_FLOW_PRICHG','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_PRICHG','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_FLOW_PRICHG','NORMALIZE_FOR_NOTL');
end;
;

begin
 char2int('CASH_FLOW_PRIN_ADJ','RESET_B');
end;
;

begin
 char2int('CASH_FLOW_SIMPLE','BASIS_CONVERT_B');
end;
;

begin
 char2int('CASH_FLOW_SIMPLE','FIXED_RATE_B');
end;
;

begin
 char2int('CASH_FLOW_SIMPLE','INTERPOLATED_B');
end;
;

begin
 char2int('CASH_FLOW_SIMPLE','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_SIMPLE','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_FLOW_SPREAD','BASIS_CONVERT_B');
end;
;

begin
 char2int('CASH_FLOW_SPREAD','FIXED_RATE_B');
end;
;

begin
 char2int('CASH_FLOW_SPREAD','INTERPOLATED_B');
end;
;

begin
 char2int('CASH_FLOW_SPREAD','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLOW_SPREAD','MANUAL_RESET_B1');
end;
;

begin
 char2int('CASH_FLOW_SPREAD','MANUAL_RESET_B2');
end;
;

begin
 char2int('CASH_FLW_DIV_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLW_SIM_HIST','BASIS_CONVERT_B');
end;
;

begin
 char2int('CASH_FLW_SIM_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('CASH_FLW_SIM_HIST','INTERPOLATED_B');
end;
;

begin
 char2int('CASH_FLW_SIM_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLW_SIM_HIST','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_FLW_SPR_HIST','BASIS_CONVERT_B');
end;
;

begin
 char2int('CASH_FLW_SPR_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('CASH_FLW_SPR_HIST','INTERPOLATED_B');
end;
;

begin
 char2int('CASH_FLW_SPR_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_FLW_SPR_HIST','MANUAL_RESET_B1');
end;
;

begin
 char2int('CASH_FLW_SPR_HIST','MANUAL_RESET_B2');
end;
;

begin
 char2int('CASH_F_COMM','CUST_FIXN_DATES_B');
end;
;

begin
 char2int('CASH_F_COMM','DIGITAL_B');
end;
;

begin
 char2int('CASH_F_COMM','FIXED_PRICE_B');
end;
;

begin
 char2int('CASH_F_COMM','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_F_COMM','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_F_PRCHG_HIST','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('CASH_F_PRCHG_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('CASH_F_PRCHG_HIST','MANUAL_RESET_B');
end;
;

begin
 char2int('CASH_F_PRCHG_HIST','NORMALIZE_FOR_NOTL');
end;
;

begin
 char2int('CASH_SETTLE_DATE','REVIEWED');
end;
;

begin
 char2int('CASH_SETTLE_DFLT','SWAPTION_AUTO_EX');
end;
;

begin
 char2int('CASH_SETTLE_HIST','OPTIONAL_SETTLE');
end;
;

begin
 char2int('CASH_SETTLE_INFO','OPTIONAL_SETTLE');
end;
;

begin
 char2int('CASH_SET_DT_HIST','REVIEWED');
end;
;

begin
 char2int('CCB_BLOTTER','PUBLIC_B');
end;
;

begin
 char2int('CDSABSINDEX_DEF','FEE_OFFSET_BUS_B');
end;
;

begin
 char2int('CDSABSINDEX_DEF','ONTHERUN_B');
end;
;

begin
 char2int('CDSABSINDEX_DEF','SETTLE_OFFSET_BUS_B');
end;
;

begin
 char2int('CDSABS_PREM_LEG','CUSTOM_ROLL_B');
end;
;

begin
 char2int('CDSABS_PREM_LEG','REFOB_SCH_BUS_DAY_B');
end;
;

begin
 char2int('CDSABS_PREM_LEG','STEP_UP_B');
end;
;

begin
 char2int('CDSABS_PREM_LEG','USE_REFOB_SCH_B');
end;
;

begin
 char2int('CDSABS_PROT_LEG','ESCROW_B');
end;
;

begin
 char2int('CDSABS_PROT_LEG','INTEREST_SHFALL_COMPD');
end;
;

begin
 char2int('CDSABS_PROT_LEG','PMT_OFST_BUS_DAY_B');
end;
;

begin
 char2int('CDSABS_PROT_LEG','WAC_B');
end;
;

begin
 char2int('CDSINDEX_DEF','FEE_OFFSET_BUS_B');
end;
;

begin
 char2int('CDSINDEX_DEF','FUNDED_B');
end;
;

begin
 char2int('CDSINDEX_DEF','SETTLE_OFFSET_BUS_B');
end;
;

begin
 char2int('CFD_DETAIL','NET_POSITION');
end;
;

begin
 char2int('CFD_DETAIL','NO_PERF');
end;
;

begin
 char2int('CFD_FIN_GRID','DIFF_SPREADS');
end;
;

begin
 char2int('COMMODITY_LEG','CUSTOM_ROLLING_DAY_B');
end;
;

begin
 char2int('COMMODITY_LEG','MANUAL_FIRST_FIXING_B');
end;
;

begin
 char2int('COMMODITY_LEG','PAYMENT_AT_END_B');
end;
;

begin
 char2int('COMMODITY_LEG','PAYMENT_OFFSET_BUS_B');
end;
;

begin
 char2int('CONTRACT_EXT_REF','IS_MASTER');
end;
;

begin
 char2int('CONVERSION_RESET','IS_RESET');
end;
;

begin
 char2int('CORRELATION_MATRIX','IS_SIMPLE');
end;
;

begin
 char2int('CORR_MATRIX_HIST','IS_SIMPLE');
end;
;

begin
 char2int('CORR_SURFACE','IS_SIMPLE');
end;
;

begin
 char2int('COUNTRY','ENABLED_B');
end;
;

begin
 char2int('CQE_RULE_HDR','ENABLED_B');
end;
;

begin
 char2int('CURRENCY_DEFAULT','IS_PRECIOUS_METAL_B');
end;
;

begin
 char2int('CURRENCY_PAIR','BASE_B');
end;
;

begin
 char2int('CURRENCY_PAIR','DIRECT_B');
end;
;

begin
 char2int('CURRENCY_PAIR','FIXED_B');
end;
;

begin
 char2int('CURRENCY_PAIR','PRIMARY_DELTA_TERM_B');
end;
;

begin
 char2int('CURVE','SAVE_NON_BLOB');
end;
;

begin
 char2int('CURVE_HIST','SAVE_NON_BLOB');
end;
;

begin
 char2int('CURVE_MEMBER','INCLUDED_B');
end;
;

begin
 char2int('CURVE_MEMBER_HIST','INCLUDED_B');
end;
;

begin
 char2int('CUR_SPLIT','EOD_SPLIT');
end;
;

begin
 char2int('CUR_SPLIT','RT_SPLIT');
end;
;

begin
 char2int('CU_BASIS_SWAP','BASE_AVG_B');
end;
;

begin
 char2int('CU_BASIS_SWAP','BASE_CMP_SPREAD_B');
end;
;

begin
 char2int('CU_BASIS_SWAP','BASE_COMPOUND_B');
end;
;

begin
 char2int('CU_BASIS_SWAP','BASIS_AVG_B');
end;
;

begin
 char2int('CU_BASIS_SWAP','BASIS_CMP_SPREAD_B');
end;
;

begin
 char2int('CU_BASIS_SWAP','BASIS_COMPOUND_B');
end;
;

begin
 char2int('CU_BASIS_SWAP','FACTOR_QUOTED');
end;
;

begin
 char2int('CU_BASIS_SWAP','SPC_LAG_B');
end;
;

begin
 char2int('CU_BASIS_SWAP','SPC_LAG_BUS_CAL_B');
end;
;

begin
 char2int('CU_BONDSPREAD','MAN_FIRST_RESET_B');
end;
;

begin
 char2int('CU_CDS','FEE_OFFSET_BUS_B');
end;
;

begin
 char2int('CU_CDS','HAS_FEE_B');
end;
;

begin
 char2int('CU_CDS','OFFSET_BUS_DAY_B');
end;
;

begin
 char2int('CU_COMM_BASIS_SWAP','SPECIFIC_B');
end;
;

begin
 char2int('CU_COMM_SWAP','SPECIFIC_B');
end;
;

begin
 char2int('CU_COMM_SWAP_BUTTERFLY','SPECIFIC_B');
end;
;

begin
 char2int('CU_COMM_SWAP_SPREAD','SPECIFIC_B');
end;
;

begin
 char2int('CU_FRA','SPECIFIC_B');
end;
;

begin
 char2int('CU_MONEYMARKET','IS_DISCOUNT');
end;
;

begin
 char2int('CU_MONEYMARKET','SPECIFIC_B');
end;
;

begin
 char2int('CU_SWAP','PRINCIPAL_ACTUAL_B');
end;
;

begin
 char2int('CU_SWAP','SPC_LAG_B');
end;
;

begin
 char2int('CU_SWAP','SPC_LAG_BUS_CAL_B');
end;
;

begin
 char2int('C_FLW_CMPD_HIST','BASIS_CONVERT_B');
end;
;

begin
 char2int('C_FLW_CMPD_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('C_FLW_CMPD_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('C_FLW_COUPON_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('C_FLW_COUPON_HIST','IS_MM');
end;
;

begin
 char2int('C_FLW_COUPON_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('C_FLW_COUPON_HIST','MANUAL_RESET_B');
end;
;

begin
 char2int('C_FLW_OPTCPN_HIST','AVERAGING_B');
end;
;

begin
 char2int('C_FLW_OPTCPN_HIST','DISCOUNT_B');
end;
;

begin
 char2int('C_FLW_OPTCPN_HIST','INTERPOLATED_B');
end;
;

begin
 char2int('C_FLW_OPTCPN_HIST','IS_MM');
end;
;

begin
 char2int('C_FLW_OPTCPN_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('C_FLW_OPTCPN_HIST','MANUAL_RESET_B');
end;
;

begin
 char2int('C_FLW_OPTION_HIST','AVERAGING_B');
end;
;

begin
 char2int('C_FLW_OPTION_HIST','DISCOUNT_B');
end;
;

begin
 char2int('C_FLW_OPTION_HIST','INTERPOLATED_B');
end;
;

begin
 char2int('C_FLW_OPTION_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('C_FLW_OPTION_HIST','MANUAL_RESET_B');
end;
;

begin
 char2int('DATE_RULE','ADD_BUS_DAYS_B');
end;
;

begin
 char2int('DATE_RULE','BUS_CAL_B');
end;
;

begin
 char2int('DTS_RECORD','PARSED_OK');
end;
;

begin
 char2int('DTS_RECORD_MSGS','FIXED_B');
end;
;

begin
 char2int('ECO_PL_COL_NAME','EXCL_CALC_B');
end;
;

begin
 char2int('EQ_LINKED_LEG','TAX_REFUND');
end;
;

begin
 char2int('EQ_LINK_LEG_HIST','TAX_REFUND');
end;
;

begin
 char2int('ETO_CONTRACT','AUTO_EXERCISE');
end;
;

begin
 char2int('ETO_CONTRACT','SETTLE_BUS_DAY_B');
end;
;

begin
 char2int('ETO_CONTRACT','USE_EXCHANGE_SPOT_DAYS');
end;
;

begin
 char2int('EVENT_AGG_LIQPOS','IS_DELETED');
end;
;

begin
 char2int('EVENT_LIQPOS','IS_DELETED');
end;
;

begin
 char2int('EVENT_TRANSFER','IS_RESET_B');
end;
;

begin
 char2int('EVENT_TRANSFER','OLD_KNOWN_B');
end;
;

begin
 char2int('EVENT_TYPE_ACTION','CANCELLED_B');
end;
;

begin
 char2int('EVENT_TYPE_ACTION','CLEANUP_B');
end;
;

begin
 char2int('EVENT_UNLIQPOS','IS_DELETED');
end;
;

begin
 char2int('EVT_TYPE_ACT_HIST','CANCELLED_B');
end;
;

begin
 char2int('EVT_TYPE_ACT_HIST','CLEANUP_B');
end;
;

begin
 char2int('EXSP_AVAR','IS_AMOUNT');
end;
;

begin
 char2int('EXSP_QVAR_OVERRIDE','RESET_BUS_LAG_B');
end;
;

begin
 char2int('EXSP_QVAR_OVERRIDE','RESET_IN_ARREAR_B');
end;
;

begin
 char2int('EXSP_TSVAR','SAMPLING_OVERRRIDE');
end;
;

begin
 char2int('EXSP_TSVAR_SAMP_PARAMS','CUSTOM_ROL_DAY_B');
end;
;

begin
 char2int('EXSP_TSVAR_SAMP_PARAMS','DEF_RESET_OFF_B');
end;
;

begin
 char2int('EXSP_TSVAR_SAMP_PARAMS','RESETCUTOFFBUSDAYB');
end;
;

begin
 char2int('EXSP_TSVAR_SAMP_PARAMS','RESET_OFF_BUSDAY_B');
end;
;

begin
 char2int('EXSP_TSVAR_SCHEDULE_PARAMETERS','CUSTOM_ROL_DAY_B');
end;
;

begin
 char2int('EXTERNAL_CASH_FLOW_COUPON','FIXED_RATE_B');
end;
;

begin
 char2int('EXTERNAL_CASH_FLOW_COUPON','IS_MM');
end;
;

begin
 char2int('EXTERNAL_CASH_FLOW_COUPON','MANUAL_AMT_B');
end;
;

begin
 char2int('EXTERNAL_CASH_FLOW_COUPON','MANUAL_RESET_B');
end;
;

begin
 char2int('EXTERNAL_C_FLW_COUPON_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('EXTERNAL_C_FLW_COUPON_HIST','IS_MM');
end;
;

begin
 char2int('EXTERNAL_C_FLW_COUPON_HIST','MANUAL_AMT_B');
end;
;

begin
 char2int('EXTERNAL_C_FLW_COUPON_HIST','MANUAL_RESET_B');
end;
;

begin
 char2int('FEE_BILLING','BUS_DAYS_B');
end;
;

begin
 char2int('FEE_DEFINITION','IS_IN_ACCOUNTING_B');
end;
;

begin
 char2int('FEE_DEFINITION','IS_IN_PL_B');
end;
;

begin
 char2int('FEE_DEFINITION','IS_IN_SETTLE_AMT_B');
end;
;

begin
 char2int('FEE_DEFINITION','IS_IN_TRANSFER_B');
end;
;

begin
 char2int('FILTER_SET_ELEMENT','IS_VALUE');
end;
;

begin
 char2int('FLOW_CMP_PERIOD','INTERPOLATED_B');
end;
;

begin
 char2int('FLOW_CMP_PERIOD','MANUAL_RESET_B');
end;
;

begin
 char2int('FLOW_SPREAD_HIST','SPREAD_MANUAL_RSET');
end;
;

begin
 char2int('FLOW_SPREAD_INFO','SPREAD_MANUAL_RSET');
end;
;

begin
 char2int('FLW_CMP_PERD_HIST','INTERPOLATED_B');
end;
;

begin
 char2int('FLW_CMP_PERD_HIST','MANUAL_RESET_B');
end;
;

begin
 char2int('FOLDER','PRIVATE_B');
end;
;

begin
 char2int('FOLDER','SHARED_B');
end;
;

begin
 char2int('FUND','INTERNAL_B');
end;
;

begin
 char2int('FUND','POOLED_B');
end;
;

begin
 char2int('FUND','UNITIZED_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','ADD_BUS_DAY_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','BENCH_ADD_DAYS_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','FST_DEL_ADD_DAYS_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','FST_DEL_M_BEGIN_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','LAST_DEL_M_END_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','RELATIVE_MONTH_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','TRADEDAY_MTH_END_B');
end;
;

begin
 char2int('FUTURE_CONTRACT','VAR_UNDERLYING_AMT');
end;
;

begin
 char2int('FUTURE_CTD','IS_CTD_B');
end;
;

begin
 char2int('FXLINKED_BOOK_SUBSTITUTION','ACTIVE');
end;
;

begin
 char2int('FX_OPT_EXP_TZ','USE_AS_VOL_DATECUT');
end;
;

begin
 char2int('FX_RATE_SPREADS','MANUAL_SPREAD');
end;
;

begin
 char2int('FX_RATE_SPREADS','PERCENT_SPREAD');
end;
;

begin
 char2int('FX_RESET','MANUAL_B');
end;
;

begin
 char2int('FX_RESET','PREFERRED_B');
end;
;

begin
 char2int('FX_RESET','RESET_BUS_LAG_B');
end;
;

begin
 char2int('FX_SPOTRES_VD_SCH','CUSTOM_MARGIN_B');
end;
;

begin
 char2int('FX_SPOT_RISK_TRANS','USE_NOTIONAL');
end;
;

begin
 char2int('HEDGE_STRATEGY','IS_CHECKED_B');
end;
;

begin
 char2int('INCOMING_CONFIG','MATCHING_B');
end;
;

begin
 char2int('INDUSTRY_HIERARCHY','ALLOW_MULTI_CLASS');
end;
;

begin
 char2int('INDUSTRY_HIERARCHY_MAP','IS_ISSUER');
end;
;

begin
 char2int('INDUSTRY_HIERARCHY_MAP','IS_PRIMARY_CLASSIFICATION');
end;
;

begin
 char2int('LEGAL_ENTITY','CLASSIFICATION');
end;
;

begin
 char2int('LE_ATTR_CODE','MANDATORY_B');
end;
;

begin
 char2int('LE_ATTR_CODE','SEARCHABLE_B');
end;
;

begin
 char2int('LE_ATTR_CODE','UNIQUE_B');
end;
;

begin
 char2int('LE_LEGAL_AGREEMENT','IS_MASTER_B');
end;
;

begin
 char2int('LE_SETTLE_DELIVERY','DIRECT_B');
end;
;

begin
 char2int('LE_SETTLE_DELIVERY','MESSAGE_TO_AGENT');
end;
;

begin
 char2int('LE_SETTLE_DELIVERY','MESSAGE_TO_INT');
end;
;

begin
 char2int('LE_SETTLE_DELIVERY','PREFERRED_B');
end;
;

begin
 char2int('LIMIT_CONFIG_LIMIT','INCLUDE_SUBLIMIT');
end;
;

begin
 char2int('LIMIT_CRIT_GROUP','IS_IN_B');
end;
;

begin
 char2int('LIMIT_USAGE','IS_TENTATIVE_B');
end;
;

begin
 char2int('LIQ_INFO','BY_TRADE_DATE_B');
end;
;

begin
 char2int('LIQ_INFO','ENTERED_DATE_B');
end;
;

begin
 char2int('LIQ_INFO','HEDGING_B');
end;
;

begin
 char2int('LIQ_INFO','USE_POS_ENGINE');
end;
;

begin
 char2int('LIQ_POSITION','IS_DELETED');
end;
;

begin
 char2int('LIQ_POSITION_HIST','IS_DELETED');
end;
;

begin
 char2int('MANUAL_SDI','CLASSIFICATION');
end;
;

begin
 char2int('MESSAGE_RULE','IS_SENT');
end;
;

begin
 char2int('MRGCALL_CONFIG','INCLUDE_IM_B');
end;
;

begin
 char2int('MRGCALL_CONFIG','LIMIT_PERC_B');
end;
;

begin
 char2int('MRGCALL_CONFIG','MAX_ADJ_PERC_B');
end;
;

begin
 char2int('MRGCALL_CONFIG','MIN_ADJ_PERC_B');
end;
;

begin
 char2int('MRGCALL_CONFIG','REHYPOTHECABLE_B');
end;
;

begin
 char2int('NDS_EXT_INFO','FX_DEFAULT_RESET_B');
end;
;

begin
 char2int('OBSERVABLE','IS_PRODUCT');
end;
;

begin
 char2int('OPTION_CONTRACT','ADD_BUS_DAY_B');
end;
;

begin
 char2int('OPTION_CONTRACT','FST_DEL_ADD_DAYS_B');
end;
;

begin
 char2int('OPTION_CONTRACT','FST_DEL_M_BEGIN_B');
end;
;

begin
 char2int('OPTION_CONTRACT','LAST_DEL_M_END_B');
end;
;

begin
 char2int('OPTION_CONTRACT','RELATIVE_MONTH_B');
end;
;

begin
 char2int('OPTION_CONTRACT','TRADEDAY_M_END_B');
end;
;

begin
 char2int('OPTION_DELIVERABLE','CALC_BUS_DAY_B');
end;
;

begin
 char2int('OPTION_DELIVERABLE','IS_PRODUCT');
end;
;

begin
 char2int('OPTION_DELIVERABLE','RECEIVE_B');
end;
;

begin
 char2int('OPT_DELIV_HIST','CALC_BUS_DAY_B');
end;
;

begin
 char2int('OPT_DELIV_HIST','IS_PRODUCT');
end;
;

begin
 char2int('OPT_DELIV_HIST','RECEIVE_B');
end;
;

begin
 char2int('ORDERS','CROSS_OVER_B');
end;
;

begin
 char2int('PC_INFO','IS_UNDERLYING');
end;
;

begin
 char2int('PERFORMANCE_LEG','CPN_CUSTOM_ROLL_B');
end;
;

begin
 char2int('PERFORMANCE_LEG','CPN_OFF_BUS_DAY_B');
end;
;

begin
 char2int('PERFORMANCE_LEG','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('PERFORMANCE_LEG','RET_CUSTOM_ROLL_B');
end;
;

begin
 char2int('PERFORMANCE_LEG','RET_OFF_BUS_DAY_B');
end;
;

begin
 char2int('PERFORMANCE_LEG','RET_RESET_OFFSET_B');
end;
;

begin
 char2int('PERFORMANCE_LEG','RET_RESET_ROLL_B');
end;
;

begin
 char2int('PERF_LEG_HIST','CPN_CUSTOM_ROLL_B');
end;
;

begin
 char2int('PERF_LEG_HIST','CPN_OFF_BUS_DAY_B');
end;
;

begin
 char2int('PERF_LEG_HIST','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('PERF_LEG_HIST','RET_CUSTOM_ROLL_B');
end;
;

begin
 char2int('PERF_LEG_HIST','RET_OFF_BUS_DAY_B');
end;
;

begin
 char2int('PERF_LEG_HIST','RET_RESET_OFFSET_B');
end;
;

begin
 char2int('PERF_LEG_HIST','RET_RESET_ROLL_B');
end;
;

begin
 char2int('POSITION_SPEC','USE_TRADE_DATE_B');
end;
;

begin
 char2int('POS_AGG_CONF','CUSTODIAN_B');
end;
;

begin
 char2int('POS_AGG_CONF','LONG_SHORT_B');
end;
;

begin
 char2int('POS_AGG_CONF','STRATEGY_B');
end;
;

begin
 char2int('POS_AGG_CONF','TRADER_B');
end;
;

begin
 char2int('POS_INFO','CASH_POS_B');
end;
;

begin
 char2int('POS_INFO','PRODUCT_POS_B');
end;
;

begin
 char2int('PRD_CDSIDX_TRAOPT','AUTO_EXERCISE_B');
end;
;

begin
 char2int('PRD_CDSIDX_TRAOPT','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRD_CDSIDX_TRAOPT','STRADDLE_B');
end;
;

begin
 char2int('PRD_COLL_HIST','FROM_SUBST_B');
end;
;

begin
 char2int('PRD_COLL_HIST','IS_MARGIN_CALL');
end;
;

begin
 char2int('PRD_COLL_HIST','OVERRIDE_VALUE_B');
end;
;

begin
 char2int('PRD_COLL_HIST','PASS_THROUGH_B');
end;
;

begin
 char2int('PRD_COLL_HIST','SUBSTITUTED_B');
end;
;

begin
 char2int('PRD_COLL_HIST','THIRD_PARTY_CUST_B');
end;
;

begin
 char2int('PRD_RESET_HIST','INT_CLEANUP');
end;
;

begin
 char2int('PRD_SECLEND_HIST','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRD_SECLEND_HIST','FEE_MARK_LINK_B');
end;
;

begin
 char2int('PRD_SECLEND_HIST','OPEN_TERM_B');
end;
;

begin
 char2int('PRD_SECLEND_HIST','SUBSTITUTION_B');
end;
;

begin
 char2int('PRD_SIMPREPO_HIST','DISCOUNT_B');
end;
;

begin
 char2int('PRD_SIMPREPO_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('PRD_SMP_MM_HIST','DISCOUNT_B');
end;
;

begin
 char2int('PRD_SMP_MM_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('PRD_SMP_MM_HIST','LOAN_B');
end;
;

begin
 char2int('PRICER_CONFIG','LAZY_REFRESH_B');
end;
;

begin
 char2int('PRICING_PARAM_NAME','IS_GLOBAL_B');
end;
;

begin
 char2int('PRICING_SHEET_CFG','PRIVATE_B');
end;
;

begin
 char2int('PRODUCT_ADR','IS_SPONSORED');
end;
;

begin
 char2int('PRODUCT_ADR','PAY_DIVIDEND');
end;
;

begin
 char2int('PRODUCT_ASSET_SWAP','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_ASSET_SWAP','PAY_ASSET_B');
end;
;

begin
 char2int('PRODUCT_ASSET_SWAP','USE_ASSET_AMORT_B');
end;
;

begin
 char2int('PRODUCT_ASSET_SWAP','USE_ASSET_SCH_B');
end;
;

begin
 char2int('PRODUCT_BASKET','MULTIPLY_TRADED_B');
end;
;

begin
 char2int('PRODUCT_BOND','AMORTIZING_B');
end;
;

begin
 char2int('PRODUCT_BOND','AMORTIZING_FV_B');
end;
;

begin
 char2int('PRODUCT_BOND','APPLY_WITHHOLD_TAX_B');
end;
;

begin
 char2int('PRODUCT_BOND','CPN_OFF_BUS_DAY_B');
end;
;

begin
 char2int('PRODUCT_BOND','CUSTOM_COUPONS_B');
end;
;

begin
 char2int('PRODUCT_BOND','EXDIVIDEND_BUS_B');
end;
;

begin
 char2int('PRODUCT_BOND','FIXED_B');
end;
;

begin
 char2int('PRODUCT_BOND','FLOATER_B');
end;
;

begin
 char2int('PRODUCT_BOND','NOT_OFF_BUS_DAY_B');
end;
;

begin
 char2int('PRODUCT_BOND','ODD_FIRST_COUPON');
end;
;

begin
 char2int('PRODUCT_BOND','ODD_LAST_COUPON');
end;
;

begin
 char2int('PRODUCT_BOND','PRE_PAID_B');
end;
;

begin
 char2int('PRODUCT_BOND','RESET_BUS_LAG_B');
end;
;

begin
 char2int('PRODUCT_BOND','RESET_IN_ARREARS_B');
end;
;

begin
 char2int('PRODUCT_BOND','STUB_USE_ACCRUAL');
end;
;

begin
 char2int('PRODUCT_BROKERAGE','RECALC_COM');
end;
;

begin
 char2int('PRODUCT_BSB','DISCOUNT_B');
end;
;

begin
 char2int('PRODUCT_BSB','IS_REPO_B');
end;
;

begin
 char2int('PRODUCT_CA','BY_TRADE');
end;
;

begin
 char2int('PRODUCT_CA','IS_DEACTIVATED');
end;
;

begin
 char2int('PRODUCT_CA','IS_EXDATE_INCLUSIVE');
end;
;

begin
 char2int('PRODUCT_CA','IS_OPTIONAL');
end;
;

begin
 char2int('PRODUCT_CA','IS_RECDATE_INCLUSIVE');
end;
;

begin
 char2int('PRODUCT_CALL_INFO','SETTLEMENT_LAG_BUS_DAY_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','AMORTIZING_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','CAPITALIZE_INT');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','DISC_CASH_FLOW_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','FST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','LOAN_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','LST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','NOTICE_BUS_DAYS_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','OPEN_TERM_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT','ROLL_OVER_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','AMORTIZING_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','CAPITALIZE_INT');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','DISC_CASH_FLOW_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','FST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','LOAN_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','LST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','NOTICE_BUS_DAYS_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','OPEN_TERM_B');
end;
;

begin
 char2int('PRODUCT_CALL_NOT_HIST','ROLL_OVER_B');
end;
;

begin
 char2int('PRODUCT_CANCDS','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_CANCDSDEF','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_CANCDSLOSS','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','ATM_PAYOFF_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','CPN_OFF_BUS_DAY_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','CPN_PAY_AT_END_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','CUSTOM_ROL_DAY_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','DEF_RESET_OFF_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','FST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','INCL_FIRST_DAY_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','INCL_LAST_DAY_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','LST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','PRIOR_RESET_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','RESETCUTOFFBUSDAYB');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','RESET_AVERAGING_B');
end;
;

begin
 char2int('PRODUCT_CAP_FLOOR','RESET_OFF_BUSDAY_B');
end;
;

begin
 char2int('PRODUCT_CASH','AMORTIZING_B');
end;
;

begin
 char2int('PRODUCT_CASH','CAPITALIZE_INT');
end;
;

begin
 char2int('PRODUCT_CASH','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CASH','DEF_RESET_OFFSET_B');
end;
;

begin
 char2int('PRODUCT_CASH','DISC_CASH_FLOW_B');
end;
;

begin
 char2int('PRODUCT_CASH','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_CASH','FLOATER_B');
end;
;

begin
 char2int('PRODUCT_CASH','FST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CASH','LST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CASH','MAN_FIRST_RESET_B');
end;
;

begin
 char2int('PRODUCT_CASH','OPEN_TERM_B');
end;
;

begin
 char2int('PRODUCT_CASH','RESET_OFF_BUSDAY_B');
end;
;

begin
 char2int('PRODUCT_CASH','ROLL_OVER_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','AMORTIZING_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','CAPITALIZE_INT');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','DEF_RESET_OFFSET_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','DISC_CASH_FLOW_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','FLOATER_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','FST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','LST_STB_CUST_IDX_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','MAN_FIRST_RESET_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','OPEN_TERM_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','RESET_OFF_BUSDAY_B');
end;
;

begin
 char2int('PRODUCT_CASH_HIST','ROLL_OVER_B');
end;
;

begin
 char2int('PRODUCT_CDS','ALL_GUARANTEES_B');
end;
;

begin
 char2int('PRODUCT_CDS','CAP_SETTLE_B');
end;
;

begin
 char2int('PRODUCT_CDS','CAP_SETTLE_BUS_B');
end;
;

begin
 char2int('PRODUCT_CDS','CONV_BOND_B');
end;
;

begin
 char2int('PRODUCT_CDS','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CDS','DIG_CAP_B');
end;
;

begin
 char2int('PRODUCT_CDS','DISPUTE_RES_B');
end;
;

begin
 char2int('PRODUCT_CDS','ESCROW_B');
end;
;

begin
 char2int('PRODUCT_CDS','EXTRA_DAY_ACCRUALB');
end;
;

begin
 char2int('PRODUCT_CDS','EX_FIRST_B');
end;
;

begin
 char2int('PRODUCT_CDS','INCLUDE_SPREAD_B');
end;
;

begin
 char2int('PRODUCT_CDS','MONOLINE_SUPPL_B');
end;
;

begin
 char2int('PRODUCT_CDS','MULTIPLE_VAL_DAY_B');
end;
;

begin
 char2int('PRODUCT_CDS','NOTICE_INFO_AVAILABLE');
end;
;

begin
 char2int('PRODUCT_CDS','NOTICE_PHYSICAL_SETTLEMENT');
end;
;

begin
 char2int('PRODUCT_CDS','PART_ASSIGN_LOAN_B');
end;
;

begin
 char2int('PRODUCT_CDS','PART_LOAN_B');
end;
;

begin
 char2int('PRODUCT_CDS','PART_PARTICIPAT_B');
end;
;

begin
 char2int('PRODUCT_CDS','PMT_OFST_BUS_DAY_B');
end;
;

begin
 char2int('PRODUCT_CDS','PORT_INCL_ACCR_B');
end;
;

begin
 char2int('PRODUCT_CDS','QUOTE_INCL_ACCR_B');
end;
;

begin
 char2int('PRODUCT_CDS','RESTRUCT_SUPPL_B');
end;
;

begin
 char2int('PRODUCT_CDS','SINGLE_PREMIUM_B');
end;
;

begin
 char2int('PRODUCT_CDS','SUCCESSOR_B');
end;
;

begin
 char2int('PRODUCT_CDS','TERMINATED_B');
end;
;

begin
 char2int('PRODUCT_CDSABS','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CDSABS','OPT_EARLY_TERMINATION');
end;
;

begin
 char2int('PRODUCT_CDSABS','TERMINATED_B');
end;
;

begin
 char2int('PRODUCT_CDSABSIDX','TERMINATED_B');
end;
;

begin
 char2int('PRODUCT_CDSIDX','FUNDED_B');
end;
;

begin
 char2int('PRODUCT_CDSIDX','TERMINATED_B');
end;
;

begin
 char2int('PRODUCT_CDSIDXOPT','AUTO_EXERCISE_B');
end;
;

begin
 char2int('PRODUCT_CDSIDXOPT','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_CDSIDXOPT','STRADDLE_B');
end;
;

begin
 char2int('PRODUCT_CDSNTHDFLT','GUARANTEED_B');
end;
;

begin
 char2int('PRODUCT_CDSNTHLOSS','CROSS_SUBORDINATED_B');
end;
;

begin
 char2int('PRODUCT_CDSNTHLOSS','GUARANTEED_B');
end;
;

begin
 char2int('PRODUCT_CDSTRANCHE','FUNDED_B');
end;
;

begin
 char2int('PRODUCT_CDSTRANCHE','TERMINATED_B');
end;
;

begin
 char2int('PRODUCT_CDS_OPTION','AUTO_EXERCISE_B');
end;
;

begin
 char2int('PRODUCT_CDS_OPTION','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_CDS_OPTION','STRADDLE_B');
end;
;

begin
 char2int('PRODUCT_CIS','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_CIS','TERM_MANDATORY');
end;
;

begin
 char2int('PRODUCT_CIS','TOTAL_RETURN_B');
end;
;

begin
 char2int('PRODUCT_CODE','MANDATORY_B');
end;
;

begin
 char2int('PRODUCT_CODE','SEARCHABLE_B');
end;
;

begin
 char2int('PRODUCT_CODE','UNIQUE_B');
end;
;

begin
 char2int('PRODUCT_COLLATERAL','FROM_SUBST_B');
end;
;

begin
 char2int('PRODUCT_COLLATERAL','IS_MARGIN_CALL');
end;
;

begin
 char2int('PRODUCT_COLLATERAL','OVERRIDE_VALUE_B');
end;
;

begin
 char2int('PRODUCT_COLLATERAL','PASS_THROUGH_B');
end;
;

begin
 char2int('PRODUCT_COLLATERAL','SUBSTITUTED_B');
end;
;

begin
 char2int('PRODUCT_COLLATERAL','THIRD_PARTY_CUST_B');
end;
;

begin
 char2int('PRODUCT_COMMODITY_SWAP','CALC_OFFSET_DAYS_B');
end;
;

begin
 char2int('PRODUCT_COMMODITY_SWAP','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_COMMODITY_SWAP','OPT_SCHEDULE_LOCK');
end;
;

begin
 char2int('PRODUCT_COMMODITY_SWAPTION','CALC_OFFSET_DAYS_B');
end;
;

begin
 char2int('PRODUCT_COMMODITY_SWAPTION','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_COMMODITY_SWAPTION','STRADDLE_B');
end;
;

begin
 char2int('PRODUCT_COMMOD_MM','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_COMMOD_MM','DISCOUNT_B');
end;
;

begin
 char2int('PRODUCT_COMMOD_MM','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_COMMOD_MM','LOAN_B');
end;
;

begin
 char2int('PRODUCT_CUSTXFER','CABLE_FEE_EX');
end;
;

begin
 char2int('PRODUCT_CUSTXFER','CHARGE_BENE_B');
end;
;

begin
 char2int('PRODUCT_CUSTXFER','CORR_FEE_EX');
end;
;

begin
 char2int('PRODUCT_CUSTXFER','LIFT_FEE_EX');
end;
;

begin
 char2int('PRODUCT_CUSTXFER','REM_FEE_EX');
end;
;

begin
 char2int('PRODUCT_DESC','NEEDS_RESET_B');
end;
;

begin
 char2int('PRODUCT_DESC_HIST','NEEDS_RESET_B');
end;
;

begin
 char2int('PRODUCT_ELS','AUTO_ADJ_SWP_NOT_B');
end;
;

begin
 char2int('PRODUCT_ELS','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_ELS','HAS_TWO_PERF_LEG_B');
end;
;

begin
 char2int('PRODUCT_ELS','MANU_NOT_B');
end;
;

begin
 char2int('PRODUCT_ELS_HIST','AUTO_ADJ_SWP_NOT_B');
end;
;

begin
 char2int('PRODUCT_ELS_HIST','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_ELS_HIST','HAS_TWO_PERF_LEG_B');
end;
;

begin
 char2int('PRODUCT_ELS_HIST','MANU_NOT_B');
end;
;

begin
 char2int('PRODUCT_EQUITY','PAY_DIVIDEND');
end;
;

begin
 char2int('PRODUCT_EXTCDS','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_EXTCDSDEF','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_EXTCDSLOSS','SETTLE_LAG_BUS_B');
end;
;

begin
 char2int('PRODUCT_FRA','DEF_RESET_OFF_B');
end;
;

begin
 char2int('PRODUCT_FRA','INTERPOLATED_B');
end;
;

begin
 char2int('PRODUCT_FRA','SETTLE_IN_ARREAR_B');
end;
;

begin
 char2int('PRODUCT_FX_OPTION','CALC_OFFSET_DAYS_B');
end;
;

begin
 char2int('PRODUCT_FX_OPTION','OPT_CAL_BUS_B');
end;
;

begin
 char2int('PRODUCT_FX_ORDER','IS_FORWARD');
end;
;

begin
 char2int('PRODUCT_FX_ORDER','IS_SPOT_RES');
end;
;

begin
 char2int('PRODUCT_FX_TTM','SPOT_RESERVE');
end;
;

begin
 char2int('PRODUCT_INTRA_MM','DISCOUNT_B');
end;
;

begin
 char2int('PRODUCT_INTRA_MM','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_INTRA_MM','LOAN_B');
end;
;

begin
 char2int('PRODUCT_INTRA_MM','USE_HALF_DAY');
end;
;

begin
 char2int('PRODUCT_MMKT','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_MMKT','FIXED_B');
end;
;

begin
 char2int('PRODUCT_MMKT','IS_DISCOUNT');
end;
;

begin
 char2int('PRODUCT_MMKT','RESET_IN_ARREARS_B');
end;
;

begin
 char2int('PRODUCT_OTCCOM_OPT','BUS_DAY_B');
end;
;

begin
 char2int('PRODUCT_OTCCOM_OPT','FWD_SETTING_B');
end;
;

begin
 char2int('PRODUCT_OTCCOM_OPT','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('PRODUCT_OTCEQTYOPT','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('PRODUCT_OTCEQ_OPT','BUS_DAY_B');
end;
;

begin
 char2int('PRODUCT_OTCEQ_OPT','FWD_SETTING_B');
end;
;

begin
 char2int('PRODUCT_OTCEQ_OPT','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('PRODUCT_OTCOPTION','AUTOMATIC_EXERCISE');
end;
;

begin
 char2int('PRODUCT_PLEDGE','IS_OPEN_TERM');
end;
;

begin
 char2int('PRODUCT_PM_DEPO_LEASE','SPOT_PRICE_FIXED_B');
end;
;

begin
 char2int('PRODUCT_REPO','BUYSELLBACK_B');
end;
;

begin
 char2int('PRODUCT_REPO','CASH_XFER_B');
end;
;

begin
 char2int('PRODUCT_REPO','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_REPO','DISPATCH_XFER_B');
end;
;

begin
 char2int('PRODUCT_REPO','HOLD_IN_CUSTODY_B');
end;
;

begin
 char2int('PRODUCT_REPO','SINGLE_COLL_B');
end;
;

begin
 char2int('PRODUCT_REPO','SUBSTITUTION_B');
end;
;

begin
 char2int('PRODUCT_REPO','TRIPARTY_REPO_B');
end;
;

begin
 char2int('PRODUCT_REPO','ZAR_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','BUYSELLBACK_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','CASH_XFER_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','DISPATCH_XFER_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','HOLD_IN_CUSTODY_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','SINGLE_COLL_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','SUBSTITUTION_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','TRIPARTY_REPO_B');
end;
;

begin
 char2int('PRODUCT_REPO_HIST','ZAR_B');
end;
;

begin
 char2int('PRODUCT_RESET','INT_CLEANUP');
end;
;

begin
 char2int('PRODUCT_SECLENDING','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_SECLENDING','FEE_MARK_LINK_B');
end;
;

begin
 char2int('PRODUCT_SECLENDING','OPEN_TERM_B');
end;
;

begin
 char2int('PRODUCT_SECLENDING','SUBSTITUTION_B');
end;
;

begin
 char2int('PRODUCT_SIMPLEREPO','DISCOUNT_B');
end;
;

begin
 char2int('PRODUCT_SIMPLEREPO','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_SIMPLEXFER','IS_PLEDGE');
end;
;

begin
 char2int('PRODUCT_SIMPLEXFER','IS_RETURN');
end;
;

begin
 char2int('PRODUCT_SIMPLE_MM','DISCOUNT_B');
end;
;

begin
 char2int('PRODUCT_SIMPLE_MM','FIXED_RATE_B');
end;
;

begin
 char2int('PRODUCT_SIMPLE_MM','LOAN_B');
end;
;

begin
 char2int('PRODUCT_SINGLESWAPLEG','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_SINGLESWAPLEG','IS_PAY_B');
end;
;

begin
 char2int('PRODUCT_SPR_CAP_FL','DEF_RESET_LAG_B1');
end;
;

begin
 char2int('PRODUCT_SPR_CAP_FL','DEF_RESET_LAG_B2');
end;
;

begin
 char2int('PRODUCT_SPR_CAP_FL','RESET_LAG_BUSD_B1');
end;
;

begin
 char2int('PRODUCT_SPR_CAP_FL','RESET_LAG_BUSD_B2');
end;
;

begin
 char2int('PRODUCT_STOCKLOAN','IS_DAP');
end;
;

begin
 char2int('PRODUCT_STOCKLOAN','LOAN_B');
end;
;

begin
 char2int('PRODUCT_STOCKLOAN','RETURN_B');
end;
;

begin
 char2int('PRODUCT_SWAP','CALC_OFFSET_DAYS_B');
end;
;

begin
 char2int('PRODUCT_SWAP','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_SWAP','OPT_SCHEDULE_LOCK');
end;
;

begin
 char2int('PRODUCT_SWAPTION','CALC_OFFSET_DAYS_B');
end;
;

begin
 char2int('PRODUCT_SWAPTION','CONST_MATURITY_B');
end;
;

begin
 char2int('PRODUCT_SWAPTION','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_SWAPTION','IS_XCCY');
end;
;

begin
 char2int('PRODUCT_SWAPTION','STRADDLE_B');
end;
;

begin
 char2int('PRODUCT_TRS','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PRODUCT_TRS','FEE_GUARANTEED');
end;
;

begin
 char2int('PRODUCT_TRS','TERMINATED_B');
end;
;

begin
 char2int('PRODUCT_TRS','USE_ASSET_AMORT_B');
end;
;

begin
 char2int('PRODUCT_WARRANT','AUTOMATIC_EXERCISE');
end;
;

begin
 char2int('PRODUCT_WARRANT','BARRIER');
end;
;

begin
 char2int('PROD_COMM_CAPFLR','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PROD_COMM_CAPFLR','CUSTOM_ROLLING_DAY_B');
end;
;

begin
 char2int('PROD_COMM_CAPFLR','DERIVED_QUOTE');
end;
;

begin
 char2int('PROD_COMM_CAPFLR','MANUAL_FIRST_FIXING_B');
end;
;

begin
 char2int('PROD_COMM_CAPFLR','PAYMENT_AT_END_B');
end;
;

begin
 char2int('PROD_COMM_CAPFLR','PAYMENT_OFFSET_BUS_B');
end;
;

begin
 char2int('PROD_COMM_FWD','CUSTOM_FLOWS_B');
end;
;

begin
 char2int('PROD_COMM_FWD','PAYMENT_AT_END_B');
end;
;

begin
 char2int('PROD_COMM_FWD','PAYMENT_OFFSET_BUS_B');
end;
;

begin
 char2int('PR_OTCEQTYOPT_HIST','IS_FX_RATE_FIXED');
end;
;

begin
 char2int('PR_OTCOPTION_HIST','AUTOMATIC_EXERCISE');
end;
;

begin
 char2int('PS_EVENT_CFG_NAME','IS_DEFAULT_B');
end;
;

begin
 char2int('PUT_CALL_DATE','INTEREST_CLEANUP_B');
end;
;

begin
 char2int('PUT_CALL_DT_HIST','INTEREST_CLEANUP_B');
end;
;

begin
 char2int('QE_QP_HIERARCHY','ENABLED_B');
end;
;

begin
 char2int('QE_QP_HIERARCHY','PREFERRED_B');
end;
;

begin
 char2int('QE_QP_PARAM','ENABLED_B');
end;
;

begin
 char2int('QVAR_OVERRIDE','RESET_BUS_LAG_B');
end;
;

begin
 char2int('QVAR_OVERRIDE','RESET_IN_ARREAR_B');
end;
;

begin
 char2int('RATE_INDEX','END_TO_END_B');
end;
;

begin
 char2int('RATE_INDEX_DEFAULT','NO_AUTO_INTERP_B');
end;
;

begin
 char2int('RATE_INDEX_DEFAULT','PAYMENT_BUS_LAG_B');
end;
;

begin
 char2int('RATE_INDEX_DEFAULT','PAY_IN_ARREAR_B');
end;
;

begin
 char2int('RATE_INDEX_DEFAULT','RESET_BUS_LAG_B');
end;
;

begin
 char2int('RATE_INDEX_DEFAULT','RESET_IN_ARREAR_B');
end;
;

begin
 char2int('RECON_INVEN_RUN','INCLUDE_CASH');
end;
;

begin
 char2int('RECON_INVEN_RUN','INCLUDE_SEC');
end;
;

begin
 char2int('RECON_INVEN_RUN','PAY_REC_B');
end;
;

begin
 char2int('REF_ENTITY','IS_SHARED_B');
end;
;

begin
 char2int('REF_ENTITY_OB','PRIMARY_REF_OB');
end;
;

begin
 char2int('REPORT_TEMPLATE','IS_HIDDEN');
end;
;

begin
 char2int('REPORT_TEMPLATE','PRIVATE_B');
end;
;

begin
 char2int('REPORT_WIN_DEF','USE_BOOK_HRCHY');
end;
;

begin
 char2int('REPORT_WIN_DEF','USE_COLOR');
end;
;

begin
 char2int('REPORT_WIN_DEF','USE_PRICING_ENV');
end;
;

begin
 char2int('RISK_CONFIG_ITEM','APPEND_TIMESTAMP_B');
end;
;

begin
 char2int('RISK_CONFIG_ITEM','ASOFDATE_B');
end;
;

begin
 char2int('RISK_CONFIG_ITEM','DISPLAY_B');
end;
;

begin
 char2int('RISK_CONFIG_ITEM','DISTRIBUTED_B');
end;
;

begin
 char2int('RISK_CONFIG_ITEM','GENERATE_MKDATA_B');
end;
;

begin
 char2int('RISK_CONFIG_ITEM','PRINT_B');
end;
;

begin
 char2int('RISK_CONFIG_ITEM','SAVE_B');
end;
;

begin
 char2int('RISK_ON_DEMAND_ITEM','KILL_IF_LAST_B');
end;
;

begin
 char2int('RISK_ON_DEMAND_ITEM','MANUAL_B');
end;
;

begin
 char2int('RISK_PRESENTER_ITEM','KILL_IF_LAST_B');
end;
;

begin
 char2int('RISK_PRESENTER_ITEM','MANUAL_B');
end;
;

begin
 char2int('SALES_B2B_TRD_CFG','PV_FWD_AMT');
end;
;

begin
 char2int('SALES_B2B_TRD_CFG','TRANSFER_MARGIN');
end;
;

begin
 char2int('SCENARIO_RULE','IS_PARAMETRIC');
end;
;

begin
 char2int('SCHED_TASK','EXECUTE_B');
end;
;

begin
 char2int('SCHED_TASK','EXEC_HOL');
end;
;

begin
 char2int('SCHED_TASK','IS_DEACTIVATED');
end;
;

begin
 char2int('SCHED_TASK','PRIVATE_B');
end;
;

begin
 char2int('SCHED_TASK','PUBLISH_B');
end;
;

begin
 char2int('SCHED_TASK','READ_ONLY_SRVR_B');
end;
;

begin
 char2int('SCHED_TASK','SEND_EMAIL_B');
end;
;

begin
 char2int('SCHED_TASK','SKIP_EXEC_B');
end;
;

begin
 char2int('SCHED_TASK_EXEC','EXEC_STATUS_B');
end;
;

begin
 char2int('SD_FILTER_ELEMENT','IS_VALUE');
end;
;

begin
 char2int('SEND_CONFIG','BY_GATEWAY_B');
end;
;

begin
 char2int('SEND_CONFIG','BY_METHOD_B');
end;
;

begin
 char2int('SEND_CONFIG','PUBLISH_B');
end;
;

begin
 char2int('SEND_CONFIG','SAVE_B');
end;
;

begin
 char2int('SEND_CONFIG','SEND_B');
end;
;

begin
 char2int('SEND_COPY_CONFIG','BY_GATEWAY_B');
end;
;

begin
 char2int('SEND_COPY_CONFIG','BY_METHOD_B');
end;
;

begin
 char2int('SPR_SWAP_LEG','DEF_RESET_LAG_B1');
end;
;

begin
 char2int('SPR_SWAP_LEG','DEF_RESET_LAG_B2');
end;
;

begin
 char2int('SPR_SWAP_LEG','RESET_LAG_BUSD_B1');
end;
;

begin
 char2int('SPR_SWAP_LEG','RESET_LAG_BUSD_B2');
end;
;

begin
 char2int('SPR_SWAP_LEG_HIST','DEF_RESET_LAG_B1');
end;
;

begin
 char2int('SPR_SWAP_LEG_HIST','DEF_RESET_LAG_B2');
end;
;

begin
 char2int('SPR_SWAP_LEG_HIST','RESET_LAG_BUSD_B1');
end;
;

begin
 char2int('SPR_SWAP_LEG_HIST','RESET_LAG_BUSD_B2');
end;
;

begin
 char2int('SWAPTION_EXT_INFO','AUTO_EXERCISE');
end;
;

begin
 char2int('SWAPTION_EXT_INFO','MULTIPLE_EXERCISE');
end;
;

begin
 char2int('SWAPTION_EXT_INFO','OPT_SCHEDULE_LOCK');
end;
;

begin
 char2int('SWAPTION_EXT_INFO','PARTIAL_EXERCISE');
end;
;

begin
 char2int('SWAP_LEG','COMPOUND_B');
end;
;

begin
 char2int('SWAP_LEG','CPN_OFF_BUS_DAY_B');
end;
;

begin
 char2int('SWAP_LEG','CPN_PAY_AT_END_B');
end;
;

begin
 char2int('SWAP_LEG','CUSTOM_ROL_DAY_B');
end;
;

begin
 char2int('SWAP_LEG','DEF_RESET_OFF_B');
end;
;

begin
 char2int('SWAP_LEG','FST_STB_INTRP_B');
end;
;

begin
 char2int('SWAP_LEG','INCLUDE_FIRST_B');
end;
;

begin
 char2int('SWAP_LEG','INCLUDE_LAST_B');
end;
;

begin
 char2int('SWAP_LEG','LST_STB_INTRP_B');
end;
;

begin
 char2int('SWAP_LEG','MAN_FIRST_DATE_B');
end;
;

begin
 char2int('SWAP_LEG','MAN_FIRST_RESET_B');
end;
;

begin
 char2int('SWAP_LEG','PRIOR_RESET_B');
end;
;

begin
 char2int('SWAP_LEG','RESETCUTOFFBUSDAYB');
end;
;

begin
 char2int('SWAP_LEG','RESET_AVERAGING_B');
end;
;

begin
 char2int('SWAP_LEG','RESET_OFF_BUSDAY_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','COMPOUND_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','CPN_OFF_BUS_DAY_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','CPN_PAY_AT_END_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','CUSTOM_ROL_DAY_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','DEF_RESET_OFF_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','FST_STB_INTRP_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','INCLUDE_FIRST_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','INCLUDE_LAST_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','LST_STB_INTRP_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','MAN_FIRST_DATE_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','MAN_FIRST_RESET_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','PRIOR_RESET_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','RESETCUTOFFBUSDAYB');
end;
;

begin
 char2int('SWAP_LEG_HIST','RESET_AVERAGING_B');
end;
;

begin
 char2int('SWAP_LEG_HIST','RESET_OFF_BUSDAY_B');
end;
;

begin
 char2int('TEMPLATE_BUNDLE','PRIVATE_B');
end;
;

begin
 char2int('TEMPLATE_PRODUCT','PRIVATE_B');
end;
;

begin
 char2int('TEMPLATE_PRODUCT','PROD_TEMP_B');
end;
;

begin
 char2int('TEMPLATE_PRODUCT','RELATIVE_DATE');
end;
;

begin
 char2int('TERMINATION_EVENTS','GRACE_PERIOD_B');
end;
;

begin
 char2int('TERMINATION_EVENTS','GRACE_PERIOD_BUS_B');
end;
;

begin
 char2int('TERMINATION_EVENTS','MULTIPLE_HOLDER_B');
end;
;

begin
 char2int('TRADE','EXCHANGE_TRADED');
end;
;

begin
 char2int('TRADE_BUNDLE','ONE_MESSAGE');
end;
;

begin
 char2int('TRADE_FILTER','CACHING_B');
end;
;

begin
 char2int('TRADE_HIST','EXCHANGE_TRADED');
end;
;

begin
 char2int('TRADE_NOTE','PERMANENT_B');
end;
;

begin
 char2int('TRADE_NOTE','PROCESSED_B');
end;
;

begin
 char2int('TRADE_OPENQTY_HIST','IS_LIQUIDABLE');
end;
;

begin
 char2int('TRADE_OPENQTY_HIST','IS_RETURN');
end;
;

begin
 char2int('TRADE_OPEN_QTY','IS_LIQUIDABLE');
end;
;

begin
 char2int('TRADE_OPEN_QTY','IS_RETURN');
end;
;

begin
 char2int('TRADE_TMPL_KEYWORD','PRIVATE_B');
end;
;

begin
 char2int('TRIGGER_INFO','DEFAULT_OFFSET_B');
end;
;

begin
 char2int('TRIGGER_INFO','IS_ATM_PAYOFF');
end;
;

begin
 char2int('TRIGGER_INFO','TRIGGER_BUS_B');
end;
;

begin
 char2int('TR_COMM_LEG','DERIVED_QUOTE_B');
end;
;

begin
 char2int('USER_DEFAULTS','SHOW_TRADE_MENU_B');
end;
;

begin
 char2int('USER_LOGIN_HIST','LOGIN_SUCC');
end;
;

begin
 char2int('USER_VIEWER_DEF','PFOL_ASOF_VDATE_B');
end;
;

begin
 char2int('USER_VIEWER_DEF','REAL_TIME_B');
end;
;

begin
 char2int('VOL_SURFACE','IS_SIMPLE_B');
end;
;

begin
 char2int('VOL_SURFACE','PRICE_VOL_B');
end;
;

begin
 char2int('VOL_SURFACE','VOL_FWD_B');
end;
;

begin
 char2int('VOL_SURFACE_HIST','IS_SIMPLE_B');
end;
;

begin
 char2int('VOL_SURFACE_HIST','PRICE_VOL_B');
end;
;

begin
 char2int('VOL_SURFACE_HIST','VOL_FWD_B');
end;
;

begin
 char2int('VOL_SURF_UND_CAP','STRIKE_REL_B');
end;
;

begin
 char2int('VOL_SURF_UND_FOPT','STRIKE_REL_B');
end;
;

begin
 char2int('VOL_SURF_UND_OPT','STRIKE_REL_B');
end;
;

begin
 char2int('VOL_SURF_UND_SWPT','FIXED_RATE_REL_B');
end;
;

begin
 char2int('VOL_SURF_UND_SWPT','PAY_FIXED_B');
end;
;

begin
 char2int('WORK_SPACE','REAL_TIME_CHANGE');
end;
;

begin
 char2int('WORK_SPACE','SHOW_ALL_TRADES');
end;
;

begin
 char2int('WORK_SPACE','SHOW_SELECTED');
end;
;

begin
 char2int('WORK_SPACE','USE_EXCL_FILTERS');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','ADJ_FIRST_FLW_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','DEFAULT_FX_RESET_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','FX_RESET_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','PAY_SIDE_RESET_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','USE_IDX_RST_DATE_B');
end;
;

begin
 char2int('XSP_PVAR','IS_USED');
end;
;

begin
 char2int('XSP_QVAR','IS_USED');
end;
;

begin
 char2int('XSP_XCPN','INTERPRET_AS_AMOUNT');
end;
;

begin
 char2int('XSP_XCPN','RATE_LWR_INC');
end;
;

begin
 char2int('XSP_XCPN','RATE_UPR_INC');
end;
;

begin
 char2int('XSP_XCPN','RESETCUTOFFBUSDAYB');
end;
;

begin
 char2int('XSP_XCPN','RNG_ACC_ENBLD');
end;
;

begin
 char2int('XSP_XCPN','RNG_ACC_LWR_INC');
end;
;

begin
 char2int('XSP_XCPN','RNG_ACC_UPR_INC');
end;
;

begin
 char2int('XSP_XCPN','UPR_BND_FLEXI_LOCKED');
end;
;

update product_variance_swap set underlying_id = 0 where underlying_id is NULL
;

UPDATE pc_param SET param_value = 'CORE_SWAPTION' WHERE 
 param_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND param_value = 'DIAGONAL_SWAPTION'
;

UPDATE pc_param SET param_value = 'CORE_SWAPTION_ATM' WHERE 
 param_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND param_value = 'DIAGONAL_SWAPTION_ATM'
;

UPDATE pricing_param_items SET attribute_value = 'CORE_SWAPTION' WHERE
 attribute_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND attribute_value = 'DIAGONAL_SWAPTION'
;

UPDATE pricing_param_items SET attribute_value = 'CORE_SWAPTION_ATM' 
 WHERE attribute_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND attribute_value = 'DIAGONAL_SWAPTION_ATM'
;

UPDATE pricing_param_name SET param_domain = 'CORE_SWAPTION,CORE_AND_SHORT_SWAPTION,CORE_SWAPTION_ATM,CORE_AND_SHORT_SWAPTION_ATM' 
 WHERE param_name = 'LGMM_CALIBRATION_INSTRUMENTS'
;

UPDATE pricing_param_name SET default_value = 'CORE_SWAPTION' WHERE param_name = 'LGMM_CALIBRATION_INSTRUMENTS'
;

create table underlying (
 underlying_id int not null,
 product_id int not null,
 underlying_type varchar2(32) not null,
 reset_instance varchar2(16) not null,
constraint pk_underlying primary key (underlying_id))
;

create sequence pvs_seq start with 1 increment by 1
;

alter table underlying add (pvs_id int)
;

create or replace procedure pvs_tmp as
begin
declare 
cursor c1 is  select pd.product_type, 
                     pvs.underlying_id, 
                     pd.product_id,
                     pvs.product_id pvsid
               from 
                     product_desc pd, 
                     product_variance_swap pvs
              where 
                     pd.product_id=pvs.underlying_id;

begin
for c1_rec in c1 LOOP
 insert into underlying (underlying_id, product_id, underlying_type, reset_instance, pvs_id) 
  values (pvs_seq.nextval, c1_rec.product_id, c1_rec.product_type, 'CLOSE', c1_rec.pvsid);
end loop;
end;
end pvs_tmp;
;

begin
  pvs_tmp;
end;
;

update product_variance_swap set underlying_id = (select u.underlying_id from underlying u where u.pvs_id=product_variance_swap.product_id)
;

alter table underlying drop column pvs_id
;

drop sequence pvs_seq
;

drop procedure pvs_tmp
;

DELETE FROM pricer_measure where measure_name = 'REAL_RHO'
;  
DELETE FROM pricer_measure where measure_name = 'REAL_RHO2'
;  
INSERT INTO pricer_measure (measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('REAL_RHO','tk.core.PricerMeasure',236,'')
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
 VALUES('REAL_RHO2','tk.core.PricerMeasure',237,'')
;  

INSERT INTO domain_values (name, value, description) values ('eventClass','PSEventMarketConformity','')
;

delete from domain_values where name like 'VarianceSwap%'
;
delete from domain_values where value like 'VarianceSwap%'
;

delete from pricer_measure where measure_name='DELTA_B4_UP_BAR' and measure_id=246
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('DELTA_B4_UP_BAR','tk.core.PricerMeasure',246,'Barr Delta')
;
delete from pricer_measure where measure_name='DELTA_B4_DOWN_BAR' and measure_id=247
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('DELTA_B4_DOWN_BAR','tk.core.PricerMeasure',247,'Barr Delta')
;
delete from pricer_measure where measure_name='MDELTA_B4_UP_BAR' and measure_id=248
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('MDELTA_B4_UP_BAR','tk.core.PricerMeasure',248,'Barr Delta')
;
delete from pricer_measure where measure_name='MDELTA_B4_DOWN_BAR' and measure_id=249
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('MDELTA_B4_DOWN_BAR','tk.core.PricerMeasure',249,'Barr Delta')
;

INSERT INTO domain_values VALUES ('domainName', 'productInterfaceReportStyle', 'Product Interface ReportStyles - used by Trade Browser to retrieve column names and values')
;
INSERT INTO domain_values VALUES ('domainName', 'productTypeReportStyle', 'Product Interface ReportStyles - used by Trade Browser to retrieve column names and values')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'CashFlowGeneratorBased', 'CashFlowGeneratorBased ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'CashSettled', 'CashSettled ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'CollateralBased', 'CollateralBased ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'CommodityBased', 'CommodityBased ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'CreditRisky', 'CreditRisky ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'FXBased', 'FXBased ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'FXProductBased', 'FXProductBased ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'Option', 'Option ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'RepoBased', 'RepoBased ReportStyle')
;
INSERT INTO domain_values VALUES ('productInterfaceReportStyle', 'SpecificResetBased', 'SpecificResetBased ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'Bond', 'Bond ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CA', 'CA ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CapFloor', 'CapFloor ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CDSIndex', 'CDSIndex ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CDSIndexTranche', 'CDSIndexTranche ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CDSNthLoss', 'CDSNthLoss ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'Collateral', 'Collateral ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CommodityCapFloor', 'CommodityCapFloor ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CommodityForward', 'CommodityForward ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CommodityOTCOption2', 'CommodityOTCOption2 ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CommoditySwap', 'CommoditySwap ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CommoditySwap2', 'CommoditySwap2 ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CommoditySwaption', 'CommoditySwaption ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CreditDefaultSwap', 'CreditDefaultSwap ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'CreditDefaultSwaption', 'CreditDefaultSwaption ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'Equity', 'Equity ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'FacilityRepo', 'FacilityRepo ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'FutureBond', 'FutureBond ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'FutureFX', 'FutureFX ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'FXOption', 'FXOption ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'FXOptionForward', 'FXOptionForward ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'FXOptionStrip', 'FXOptionStrip ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'FXTakeUp', 'FXTakeUp ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'MarginCall', 'MarginCall ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'OTCCommodityOption', 'OTCCommodityOption ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'Repo', 'Repo ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'SimpleMM', 'SimpleMM ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'SimpleRepo', 'SimpleRepo ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'SpreadCapFloor', 'SpreadCapFloor ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'SpreadSwap', 'SpreadSwap ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'StructuredProduct', 'StructuredProduct ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'Swap', 'Swap ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'Swaption', 'Swaption ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'TotalReturnSwap', 'TotalReturnSwap ReportStyle')
;
INSERT INTO domain_values VALUES ('productTypeReportStyle', 'Warrant', 'Warrant ReportStyle')
;

create table product_commodity_swap2 (
	PRODUCT_ID int,
	PAY_LEG_ID int,
	RECEIVE_LEG_ID int,
	CURRENCY_CODE  varchar2(3),
	AVERAGING_POLICY varchar(64),
	CUSTOM_FLOWS_B  int,
	FLOWS_BLOB  blob,
	AVG_ROUNDING_POLICY  varchar2(64),
  constraint pk_product_comm_swap2 primary key (product_id))
;

create table cf_sch_gen_params (
	product_id  int,
	start_date  timestamp,
	end_date  timestamp,
	payment_lag  int,
	payment_calendar  varchar2(64),
	fixing_date_policy int,
	fixing_calendar  varchar2(64),
	payment_offset_bus_b  int,
	payment_day int,
	payment_date_rule int,
constraint pk_cf_sch_gen_parms primary key (product_id))
;

create table product_commodity_otcoption2  (
	product_id  int,
	leg_id  int,
	buy_sell  varchar2(4),
	option_type  varchar2(4),
	currency_code varchar2(3),
	averaging_policy  varchar2(64),
	custom_flows_b int,
	flows_blob blob,
	avg_rounding_policy  varchar2(64),
constraint pk_prod_comm_otc_op2 primary key (product_id))
;

create table commodity_leg2 (
	leg_id int,
	leg_type int,
	strike_price float,
	strike_price_unit varchar2(32),
	comm_reset_id  int,
	spread float,
	fx_reset_id int,
	fx_calendar varchar2(64),
	cashflow_locks int,
	cashflow_changed int,
	quantity float,
	quantity_unit varchar2(32),
	per_period varchar2(32),
	version int,
	round_unit_conv_b int,
constraint pk_comm_leg2 primary key (leg_id))
;


/* Update Patch Version */
UPDATE calypso_info
SET  patch_version='002',
patch_date = to_date('30/08/2007 12:00:00','DD/MM/YYYY HH:MI:SS')
;     

