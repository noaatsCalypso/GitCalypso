
delete from an_viewer_config where analysis_name='CrossAssetPL' and viewer_class_name='apps.risk.CrossAssetPLAnalysisViewer'
go

alter table calypso_seed drop constraint ct_primarykey
go

create procedure drop_seed_offset
as

declare @exists_flag int

 select @exists_flag = 0

 if exists  (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'calypso_seed'
        and syscolumns.name = 'seed_offset' )

begin
   exec ('alter table calypso_seed drop seed_offset')
 end
go

exec sp_procxmode 'drop_seed_offset', 'anymode'
go

exec drop_seed_offset
go

drop procedure drop_seed_offset 
go

alter table calypso_seed add constraint ct_primarykey PRIMARY KEY CLUSTERED (seed_name)
go

if not exists(select 1 from sysobjects , syscolumns 
              where sysobjects.id = syscolumns.id
              and sysobjects.name = 'referring_object'
              and syscolumns.name = 'rfg_tbl_name' )
begin
exec('alter table referring_object modify rfg_tbl_name varchar(128)')
end
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'CrossAssetPL', 'apps.risk.CrossAssetPLAnalysisViewer', 0 )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Comparison', 'apps.risk.ComparisonAnalysisViewer', 0 )
go
INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES ( 10000, 'DefaultClient', 'PLMark', 0, 'NonTransactional', 'LFU' )
go

delete from calypso_seed where last_id=7 and seed_name='FixingDatePolicyId'
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES ( 7, 'FixingDatePolicyId', 1 )
go
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'curve_prepay', 'curve_prepay_hist', 0 )
go
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'curve_default', 'curve_default_hist', 0 )
go
INSERT INTO currency_default ( currency_code, rounding, rounding_method, iso_code, country, default_holidays, rate_index_code, default_day_count, group_list, spot_days, default_tenor, time_zone, rate_decimals, is_precious_metal_b ) VALUES ( 'SGD', 2.0, 'NEAREST', 'SGD', 'SINGAPORE', 'SIN', 'SOR', 'ACT/365', 'ASIAN', 2, 180, 'Asia/Singapore', -1, 0 )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'curve', 'curve_prepay', 'curve_id,curve_date', 'curve_id,curve_date', 'Curve', 'NONE' )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'curve', 'curve_default', 'curve_id,curve_date', 'curve_id,curve_date', 'Curve', 'NONE' )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_abs', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
go
add_domain_values 'domainName', 'incomingType', 'Mapping between External Message type and BO Message Type' 
go
add_domain_values 'incomingType', 'MT300', 'INC_FXCONFIRM' 
go
add_domain_values 'incomingType', 'MT305', 'INC_FXOPT_CONFIRM'  
go
add_domain_values 'incomingType', 'MT306', 'INC_FXOPT_CONFIRM'  
go
add_domain_values 'function', 'AddModifyTaskInternalReference', 'Allow User to Change Entry in Task Internal Reference' 
go
add_domain_values 'function', 'AddModifyTaskPriorityConfig', 'Allow User to Change Entry in Task Priority'  
go
add_domain_values 'function', 'TS_INCREASE_TASK_PRIORITY', 'Allow User to Increase Task Priority in TaskStation'  
go
add_domain_values 'function', 'TS_DECREASE_TASK_PRIORITY', 'Allow User to Decrease Task Priority in TaskStation'  
go
add_domain_values 'function', 'TS_FIX_TASK_PRIORITY', 'Allow User to Fix Task Priority in TaskStation'  
go
add_domain_values 'productType', 'CommoditySwap2', 'New implementation of Commodity Swap' 
go
add_domain_values 'productType', 'CommodityOTCOption2', 'New implementation of Commodity OTC Option' 
go
add_domain_values 'domainName', 'TradeLevelOverride.Products', 'List of products implementing TradeLevelOverride'
go
add_domain_values 'TradeLevelOverride.Products', 'Swap', 'Swap is TLO compatible' 
go
add_domain_values 'TradeLevelOverride.Products', 'XCCySwap', 'XCCySwap is TLO compatible'  
go
add_domain_values 'TradeLevelOverride.Products', 'CancellableSwap', 'CancellableSwap is TLO compatible'  
go
add_domain_values 'TradeLevelOverride.Products', 'CapFloor', 'CapFloor is TLO compatible'  
go
add_domain_values 'TradeLevelOverride.Products', 'CappedSwap', 'CappedSwap is TLO compatible'  
go
add_domain_values 'TradeLevelOverride.Products', 'Swaption', 'Swaption is TLO compatible'  
go
add_domain_values 'TradeLevelOverride.Products', 'SpreadCapFloor', 'SpreadCapFloor is TLO compatible' 
go
add_domain_values 'TradeLevelOverride.Products', 'SpreadSwap', 'SpreadSwap is TLO compatible'  
go
add_domain_values 'domainName', 'TradeLevelOverride.PricerKeys', 'List of pricer override keys'  
go
add_domain_values 'domainName', 'TradeLevelOverride.MdiKeys', 'List of market data item override keys'  
go
add_domain_values 'volSurfaceGenerator', 'SwaptionSABRDirect', ''  
go
add_domain_values 'domainName', 'commodity.ForwardPriceMethods', 'Methods for calculating forward prices.'  
go
add_domain_values 'commodity.ForwardPriceMethods', 'Linear', 'Linearly interpolate price between the two closest dates stradling FixDate.' 
go
add_domain_values 'commodity.ForwardPriceMethods', 'Fixed', 'Price is taken from a specified pillar date independent of FixDate.'
go
add_domain_values 'commodity.ForwardPriceMethods', 'Nearby', 'Price is taken from the first pillar date equal to or greater than the FixDate.' 
go
add_domain_values 'commodity.ForwardPriceMethods', 'SecondNearby', 'Price is taken from the first pillar date with a succeeding date that is equal to or greater than the FixDate.' 
go
add_domain_values 'commodity.ForwardPriceMethods', 'IceNearby', 'Price is taken from the first pillar date greater than the FixDate.' 
go
add_domain_values 'commodity.ForwardPriceMethods', 'Lme3M', 'Specific to LME futures contracts. Linearly interpolate but use a date 3 months hence.' 
go
add_domain_values 'commodity.ForwardPriceMethods', 'LmeCash', 'Specific to LME futures contracts. Linearly interpolate but use a date 2 days hence.' 
go
add_domain_values 'domainName', 'sdiCompareKeys', 'SDI Comparison Keys to override default behaviour' 
go
add_domain_values 'volSurfaceGenerator', 'CapSABRDirect', 'Generates SABR vol surface from Cap maturity quotes' 
go
add_domain_values 'volSurfaceGenerator', 'CapBpVol', 'Generates bpvol surface from Cap maturity quotes'  
go
add_domain_values 'domainName', 'volSurfaceGenerator.commodity', 'Generators for Commodity Options'  
go
add_domain_values 'volSurfaceGenerator.commodity', 'CommodityDelta', 'VS Generator for Commodity Options' 
go
add_domain_values  'domainName', 'eXSPSystemVariables', 'Available SystemVariables for eXSP' 
go
add_domain_values  'eXSPSystemVariables', 'AccumulatedCouponIncludingCurrentSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'AccumulatedCouponSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'CalculatedNotionalSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'CalculatedRateSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'CouponPeriodSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'CurrentNotionalSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'DaysSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'InitialNotionalSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'PreviousNotionalSVar', '' 
go
add_domain_values  'eXSPSystemVariables', 'PreviousRateSVar', '' 
go
add_domain_values  'function', 'AssignOverrideKeys', 'Allow the user to assign Trade Level Override keys to a trade' 
go
add_domain_values  'function', 'ModifyOverrideKeys', 'Allow the user to modify Trade Level Override keys in the Pricer Config' 
go
add_domain_values  'function', 'CreatePLMark', '' 
go
add_domain_values  'function', 'ModifyPLMark', '' 
go
add_domain_values  'function', 'RemovePLMark', '' 
go
add_domain_values  'classAuditMode', 'PLMark', '' 
go
add_domain_values  'CorrelationSurface.gensimple', 'BaseCorrelationLPM', 'Base Correlation Surface generator using the Large Homogeneous Pool Model' 
go
add_domain_values  'REPORT.Types', 'AccountActivity', 'AccountActivity Report' 
go
add_domain_values  'domainName', 'VarianceSwap.subtype', 'VarianceSwap subtypes' 
go

add_domain_values  'domainName', 'FXOption.optionSubType', 'Types of FXOptions' 
go
add_domain_values  'classAuthMode', 'PLMark', '' 
go

add_domain_values  'domainName', 'commodityMktDataUsage', '' 
go
add_domain_values  'commodityMktDataUsage', 'FOR', 'Forecast Curve' 
go
add_domain_values  'domainName', 'ExternalMessageField.Amounts', '' 
go
add_domain_values  'domainName', 'ExternalMessageField.Fields', '' 
go
add_domain_values  'domainName', 'ExternalMessageField.Roles', '' 
go
add_domain_values  'loanType', 'Revolver', '' 
go
add_domain_values  'domainName', 'taskPriorities', 'Task Priority List' 
go
add_domain_values  'taskPriorities', '0.LOW', 'Low priority' 
go
add_domain_values  'taskPriorities', '1.NORMAL', 'Normal priority' 
go
add_domain_values  'taskPriorities', '2.HIGH', 'High priority' 
go
add_domain_values  'domainName', 'ExternalMessageField.Dates', '' 
go
add_domain_values  'domainName', 'ExternalMessageField.References', '' 
go
add_domain_values  'domainName', 'ExternalMessageField.MessageMapper', 'MessageMapper class prefix' 
go
add_domain_values  'ExternalMessageField.MessageMapper', 'MT300', '' 
go
add_domain_values  'scheduledTask', 'EOD_PLMARKING', 'End of day PL Marking.' 
go

add_domain_values  'domainName', 'CommoditySwap.PaymentFrequency', 'Payment frequencies for CommoditySwap' 
go

add_domain_values  'CommoditySwap.PaymentFrequency', 'PeriodicPaymentFrequency', 'Periodic' 
go

add_domain_values  'CommoditySwap.PaymentFrequency', 'DailyPaymentFrequency', 'Daily' 
go

add_domain_values  'CommoditySwap.PaymentFrequency', 'FutureContractPaymentFrequency', 'Contract' 
go

add_domain_values  'CommoditySwap.PaymentFrequency', 'BulletPaymentFrequency', 'Bullet' 
go

add_domain_values  'CommoditySwap.PaymentFrequency', 'WholePaymentFrequency', 'Whole' 
go

add_domain_values  'domainName', 'CommodOptVolTypeDelta', 'Pricers for CommoditySwap' 
go

add_domain_values  'CommodOptVolTypeDelta', '10', '' 
go

add_domain_values  'CommodOptVolTypeDelta', '25', '' 
go

add_domain_values  'productType', 'FutureOptionCommodity', '' 
go
add_domain_values  'workflowRuleTransfer', 'ResetWorkflowType', '' 
go
add_domain_values  'accEventType', 'INTEREST_END', '' 
go
add_domain_values  'accEventType', 'NOM', '' 
go
add_domain_values  'accEventType', 'NOM_TD', '' 
go
add_domain_values  'accEventType', 'NOM_TD_REV', '' 
go
add_domain_values  'accEventType', 'NOM_SD', '' 
go
add_domain_values  'accEventType', 'NOM_INC', '' 
go
add_domain_values  'accEventType', 'NOM_DEC', '' 
go
add_domain_values  'accEventType', 'NOM_CHG', '' 
go
add_domain_values  'accEventType', 'NOM_MAT', '' 
go

add_domain_values  'tradeCancelStatus', 'CANCELED', '' 
go
add_domain_values  'CapFloor.Pricer', 'PricerCapFloorBpVol', '' 
go
add_domain_values  'CDSNthLoss.Pricer', 'PricerCDSNthLossLPM', 'NthLoss pricer using the Large Homogeneous Pool Model' 
go
add_domain_values  'CDSNthDefault.Pricer', 'PricerCDSNthDefaultOFM', 'NthDefault pricer using Gaussian one factor model' 
go
add_domain_values  'Swap.Pricer', 'PricerXCCySwap', '' 
go
add_domain_values  'Swap.Pricer', 'PricerBRLSwap', 'Pricer for Brazilian Swap' 
go
add_domain_values  'Swap.subtype', 'BRL', '' 
go
add_domain_values  'GenericOption.Pricer', 'PricerCapFloortionLGMM', 'Linear Gauss Markov model to value option on caps/floors' 
go
add_domain_values 'CDSIndexTranche.Pricer', 'PricerCDSIndexTrancheOFM', 'Pricer for CDSIndexTranche using the Gaussian one factor model' 
go
add_domain_values  'CDSIndexTranche.Pricer', 'PricerCDSIndexTrancheLPM', 'Pricer for CDSIndexTranche using the Large Homogeneous Pool Model' 
go
add_domain_values  'VarianceSwap.subtype', 'FX', 'FX' 
go
add_domain_values  'VarianceSwap.subtype', 'Commodity', 'Commodity' 
go
add_domain_values  'VarianceSwap.subtype', 'Equity', 'Equity' 
go
add_domain_values  'VarianceSwap.subtype', 'EquityIndex', 'EquityIndex' 
go
add_domain_values  'VarianceSwap.Pricer', 'PricerVarianceSwapFX', '' 
go
add_domain_values  'VarianceSwap.Pricer', 'PricerVarianceSwapCommodity', '' 
go
add_domain_values  'VarianceSwap.Pricer', 'PricerVarianceSwapEquity', '' 
go
add_domain_values  'VarianceSwap.Pricer', 'PricerVarianceSwapEquityIndex', '' 
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionVanilla', '' 
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionBarrier', '' 
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionDigital', '' 
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionFader', ''
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionAsian', '' 
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionVolFwd', '' 
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionRangeAccrual', '' 
go

add_domain_values  'FXOption.Pricer', 'PricerFXOptionLookBack', '' 
go
add_domain_values  'EquityLinkedSwap.Pricer', 'PricerEquityLinkedSwapAccrual', '' 
go
add_domain_values  'domainName', 'AssetPerformanceSwap.Pricer', '' 
go
add_domain_values  'AssetPerformanceSwap.Pricer', 'PricerAssetPerformanceSwap', '' 
go
add_domain_values  'AssetPerformanceSwap.Pricer', 'PricerAssetPerformanceSwapAccrual', '' 
go

add_domain_values  'FXOption.subtype', 'BARRIER', '' 
go

add_domain_values  'FXOption.subtype', 'RANGEACCRUAL', '' 
go

add_domain_values  'FXOption.subtype', 'VOLFWD', '' 
go

add_domain_values  'FXOption.subtype', 'FADER', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : BARRIER_UP_IN', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : BARRIER_UP_OUT', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : BARRIER_DOWN_IN', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : BARRIER_DOWN_OUT', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_IN', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_OUT', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_TYPE_A', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : DOUBLE_BARRIER_TYPE_B', '' 
go

add_domain_values  'FXOption.optionSubType', 'BARRIER : BARRIER', '' 
go

add_domain_values  'FXOption.optionSubType', 'DIGITAL : DIGITAL_EXPIRY', '' 
go

add_domain_values  'FXOption.optionSubType', 'DIGITAL : DIGITAL_DOUBLE_ONE TOUCH', '' 
go

add_domain_values  'FXOption.optionSubType', 'DIGITAL : DIGITAL_DOUBLE_NO TOUCH', '' 
go

add_domain_values  'FXOption.optionSubType', 'DIGITAL : DIGITAL_ONE TOUCH_UP_IN', '' 
go

add_domain_values  'FXOption.optionSubType', 'DIGITAL : DIGITAL_NO TOUCH_UP_OUT', ''
go

add_domain_values  'FXOption.optionSubType', 'DIGITAL : DIGITAL_ONE TOUCH_DOWN_IN', '' 
go

add_domain_values  'FXOption.optionSubType', 'DIGITAL : DIGITAL_NO TOUCH_DOWN_OUT', '' 
go

add_domain_values  'FXOption.optionSubType', 'ASIAN : AVERAGE RATE', '' 
go

add_domain_values  'FXOption.optionSubType', 'ASIAN : AVERAGE STRIKE', '' 
go

add_domain_values  'FXOption.optionSubType', 'ASIAN : GEOM AVERAGE RATE', '' 
go

add_domain_values  'FXOption.optionSubType', 'ASIAN : DBL_AVG', '' 
go

add_domain_values  'FXOption.optionSubType', 'FADER : DECREASE NOTIONAL_BELOW', '' 
go

add_domain_values  'FXOption.optionSubType', 'FADER : INCREASE NOTIONAL_BELOW', '' 
go
add_domain_values  'FXOption.optionSubType', 'FADER : DECREASE NOTIONAL_ABOVE', '' 
go

add_domain_values  'FXOption.optionSubType', 'FADER : INCREASE NOTIONAL_ABOVE', '' 
go
add_domain_values  'FXOption.optionSubType', 'FIXED STRIKE', '' 
go

add_domain_values  'FXOption.optionSubType', 'LOOKBACK : FLOATING STRIKE', '' 
go

add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_IN', '' 
go

add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_OUT', '' 
go

add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : DOWN_IN', '' 
go
add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : DOWN_OUT', '' 
go
add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_IN_DOWN_IN', '' 
go
add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_IN_DOWN_OUT', '' 
go
add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_OUT_DOWN_IN', '' 
go
add_domain_values  'FXOption.optionSubType', 'RANGE_ACCRUAL : UP_OUT_DOWN_OUT', '' 
go
add_domain_values  'FXOption.optionSubType', 'VANILLA : PUT', '' 
go
add_domain_values  'FXOption.optionSubType', 'VANILLA : CALL', '' 
go
add_domain_values  'Repo.subtype', 'Pledge', '' 
go
add_domain_values  'eco_pl_column', 'CREDIT_SUBSTITUTION_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values  'eventFilter', 'FutureLiquidationEventFilter', 'Future Liquidation Event Filter' 
go
add_domain_values  'feeCalculator', 'BPNominalRepo', '' 
go
add_domain_values  'feeCalculator', 'BPPrincipalRepo', '' 
go
add_domain_values  'productFamily', 'AssetPerformanceSwap', '' 
go
add_domain_values  'productType', 'AssetPerformanceSwap', '' 
go
add_domain_values  'quoteType', 'ImpliedCorrelation', '' 
go
add_domain_values  'riskAnalysis', 'Comparison', '' 
go
add_domain_values  'riskAnalysis', 'CrossAssetPL', '' 
go
add_domain_values  'scheduledTask', 'EOD_BROKER_STATEMENT', 'EOD Broker Statement' 
go
add_domain_values  'scheduledTask', 'EUROCLEAR_TRIPARTY', '' 
go
add_domain_values  'scheduledTask', 'PRICE_FIXING', '' 
go
add_domain_values  'scheduledTask', 'FUTURE_POSITION_EXPIRY', 'Future Process Expiry' 
go
add_domain_values  'scheduledTask', 'SYNCHRONIZE_PC', '' 
go
add_domain_values  'scheduledTask', 'GENERATE_FWD_POINTS', 'Generating Commodity Fwd Point underlyings as of valDate in the Schedule Task' 
go
add_domain_values  'scheduledTask', 'GENERATE_COMM_FUTURES', 'Generating Commodity Futures as of valDate in the Schedule Task' 
go
add_domain_values  'scheduledTask', 'GENERATE_COMM_VOL_POINTS', 'Generating Commodity Volatility Point underlyings as of valDate in the Schedule Task' 
go
add_domain_values  'riskPresenter', 'WeightedPricing', '' 
go
add_domain_values  'riskPresenter', 'Comparison', '' 
go
add_domain_values  'domainName', 'newEventTypeTradeAction', 'Specify trade action for the CallNotice product' )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CREDIT_SUBSTITUTION_EFFECT', 'Credit Substitution Effect', 65, 'NPV', 0 )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'RISK_OPTIMISE', 'true' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_CALIBRATION_INSTRUMENTS', 'CORE_SWAPTION' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_CALIBRATION_SCHEME', 'EXACT_STEP_SIGMA' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_CONTROL_VARIATE', 'true' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_LATTICE_NODES', '35' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_QUAD_ORDER', '20' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionLGMM', 'LGMM_LATTICE_CUTOFF', '6.0' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloortionLGMM', 'LGMM_LATTICE_NODES', '15' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloortionLGMM', 'LGMM_LATTICE_CUTOFF', '5.5' )
go

INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'QUAD', 'Legendre' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2F', 'QUAD', 'Legendre' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'QUAD_POINTS', '30' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2F', 'QUAD_POINTS', '30' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'USE_SMILE_VOL', 'false' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSpreadCapFloorGBM2F', 'USE_SMILE_VOL', 'false' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloorHagan', 'STRIKE_SPREAD_DIRECTION', 'CENTRAL' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerCapFloorHagan', 'STRIKE_SPREAD_EPSILON', '10' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_CALIBRATION_INSTRUMENTS', 'CORE_SWAPTION' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_CALIBRATION_SCHEME', 'EXACT_STEP_SIGMA' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_CONTROL_VARIATE', 'true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_LATTICE_CUTOFF', '6' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_LATTICE_NODES', '35' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_QUAD_ORDER', '20' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'LGMM_RISK_OPTIMISE', 'true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_CASH_THRESHOLD', '7' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_SWAP_BY_REPLICATION', 'true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_RISK_OPTIMISE', 'true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_CASH_YIELD_CURVE_MODEL', 'LINEAR' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_SWAP_USE_BASIS_ADJ', 'false' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_BLACK_ON_HAGAN', 'true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_USE_EXACT_CONVEXITY_FUNC', 'true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_CASH_BY_REPLICATION', 'false' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_COMPUTE_CORRECTION', 'true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'HAGAN_SWAP_YIELD_CURVE_MODEL', 'EXACT_BOND' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'BP_VOL_TRANSFORMATION', 'EXACT' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NET_VOLATILITY', 'tk.core.PricerMeasure', 259, ' Total volatility (realized + unrealized)' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'REALIZED_VOLATILITY', 'tk.core.PricerMeasure', 260, 'realized volatility' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PV01_PER_REF_NAME', 'tk.core.TabularPricerMeasure', 271 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'LGMM_MEANREV_SCEN', 'tk.core.PricerMeasure', 275 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_STRIKE', 'tk.core.PricerMeasure', 254, 'Npv of the strike amount on a generic option' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES
   ( 'NPV_UNDERLYING', 'tk.core.PricerMeasure', 253, 'Npv of the underlying on a generic option' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'TIME_VALUE', 'tk.core.PricerMeasure', 255, 'time value of option' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'ATM_STRIKE_AMOUNT', 'tk.core.PricerMeasure', 256, 'At the money strike amount' )
go
delete from pricer_measure where measure_name='PAR_STRIKE' and measure_id=258
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'PAR_STRIKE', 'tk.core.PricerMeasure', 258, 'DF weighted average strike' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SALI_TREE_PAYOFFS', 'tk.core.PricerMeasure', 261, 'Sali tree payoffs' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'BREAK_EVEN_RATE_PAYLEG', 'tk.core.PricerMeasure', 264, '' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'BREAK_EVEN_RATE_RECLEG', 'tk.core.PricerMeasure', 265, '' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SABR_GREEKS', 'tk.core.PricerMeasure', 266, 'SABR model greeks' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SABR_MODEL', 'tk.core.PricerMeasure', 267, 'SABR model parameterisation'
)
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES 
 ( 'GBM2F_GREEKS', 'tk.core.PricerMeasure', 268, 'Greeks for the GBM2F model are computed and stored in client data' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LGMM_BESTFIT_ERROR', 'tk.core.PricerMeasure', 270, 'Graphs the best-fit error function' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURRENT_NOTIONAL', 'tk.core.PricerMeasure', 269 )
go

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DELTA_B4_UP_BARRIER', 'tk.core.PricerMeasure', 246 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DELTA_B4_DOWN_BARRIER', 'tk.core.PricerMeasure', 247 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_B4_UP_BARRIER', 'tk.core.PricerMeasure', 248 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_B4_DOWN_BARRIER', 'tk.core.PricerMeasure', 249 )
go
delete from pricer_measure where measure_name='SETTLEMENT_VALUE' and measure_id=257
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'SETTLEMENT_VALUE', 'tk.core.PricerMeasure', 257, 'discounted value of SETTLEMENT_AMOUNT' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURRENT_RATE', 'tk.core.PricerMeasure', 262 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PROJECTED_INTEREST', 'tk.core.PricerMeasure', 272 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCUMULATED_ACCRUAL', 'tk.core.PricerMeasure', 273 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NOTIONAL_ACCRUAL', 'tk.core.PricerMeasure', 274 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SETTLEMENT_AMOUNT_ACCRUAL', 'tk.core.PricerMeasure', 277 )
go
delete from pricing_param_name where param_name='VEGA_WEIGHT_SURFACE' and param_type='java.lang.String'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b ) VALUES ( 'VEGA_WEIGHT_SURFACE', 'java.lang.String', 'Weighted Volatility Surface Template
Name', 1 )
go
delete from pricing_param_name where param_name='USE_ATM_VOL' and param_type='java.lang.Boolean'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_ATM_VOL', 'java.lang.Boolean', 'true,false', 'FXOption : Determines if ATM vol is to be used for pricing exotics', 0, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'FX_OPTFWD_REVAL_FREQUENCY', 'java.lang.String', 'DLY,WK,MTH,NON',
'Frequency of revaluations for FX Option Forward and FX Option Swap trade to determine risk(position) date', 1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES 
  ( 'FIXING_DATE_ACCRUAL', 'java.lang.Boolean', 'true,false', 'Realize cashflows based off Fixing Date', 1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MAX_SIGMA', 'com.calypso.tk.core.Rate', '', 'The maximum value of the mode volatility to use in certain calibration methods', 1, 'MAX_SIGMA', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MIN_SIGMA', 'com.calypso.tk.core.Rate', '', 'The miniumu value of the mode volatility to use in certain calibration methods', 1, 'MIN_SIGMA', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MAX_MEAN_REVERSION', 'com.calypso.tk.core.Rate', '', 'The maximum value of the mode mean reversion to use in certain calibration methods', 1, 'MAX_MEAN_REVERSION', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_MIN_MEAN_REVERSION', 'com.calypso.tk.core.Rate', '', 'The minimum value of the mode mean reversion to use in certain calibration methods', 1, 'MIN_MEAN_REVERSION', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name, default_value ) VALUES ( 'MISSING_HISTORICAL_PRICE_POLICY', 'java.lang.String', 'Class name for a policy to return historical prices when the exact date is missing.', 1, 'MISSING_HISTORICAL_PRICE_POLICY', '' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'BE_INCL_ACC', 'java.lang.Boolean', 'true,false', 'Specifies whether to include accrued interest when computing break-even rate and related measures.', 0, 'true' )
go
delete from pricing_param_name where param_name='SUPPRESS_ROUNDING'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES 
  ( 'SUPPRESS_ROUNDING', 'java.lang.Boolean', 'true,false', 'Indicates whether the pricer should attempt to suppress any rounding to produce smoother results', 0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES 
   ( 'BP_VOL_TRANSFORMATION', 'java.lang.String', 'EXACT,HAGAN_APPROX,STREET_PROXY1,STREET_PROXY2,STREET_PROXY3,STREET_PROXY4,STREET_PROXY5', 'Transformation method for computing bp volatilities.', 1, 'BP_VOL_TRANSFORMATION', 'EXACT' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'BETA', 'java.lang.Double', '', 'SABR model parameter.', 0, 'BETA' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'SABR_CORRELATION', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'SABR_CORRELATION' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES 
   ( 'ALPHA', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'ALPHA' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'VOLOFVOL', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'VOLOFVOL' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'ATMVOL', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'ATMVOL' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'SABRIMPLIEDVOL', 'com.calypso.tk.core.Rate', '', 'SABR model parameter.', 0, 'SABRIMPLIEDVOL' )
go
delete from pricing_param_name where param_name= 'ACCRUAL_BOND_CONVENTION'
go 
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, is_global_b, display_name ) VALUES ( 'ACCRUAL_BOND_CONVENTION', 'java.lang.Boolean', 'true,false', 1, 'ACCRUAL_BOND_CONVENTION' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, is_global_b, display_name ) VALUES ( 'ADJUST_FOR_EXERCISE_FEES', 'java.lang.Boolean', 'true,false', 1, 'ADJUST_FOR_EXERCISE_FEES' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'PRIMARY_RISK', 'java.lang.String', 'Role of the Legal Entity to use to get the risky curves when pricing risky bonds', 0, 'PRIMARY_RISK' )
go
delete from product_code where product_code='COMM_INDEX_DEC'
go
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ( 'COMM_INDEX_DEC', 'string', 0, 0, 0, 'Commodity,CommoditySwap,CommoditySwaption', 0 )
go
delete from referring_object where rfg_obj_id=22 and ref_obj_id=1
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc )
VALUES ( 22, 1, 'master_confirmation', 'master_confirmation_id', '1', 'sd_filter', 'MasterConfirmation', 'apps.refdata.MasterConfirmationWindow', 'Master Confirmation' )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 125, 'AccountActivity', 0, 1, 1 )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 126, 'ComparisonAnalysis', 1, 0, 1 )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'cu_fx_fixed', 'Curve Underlying FX Forward Fixed' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'curve_prepay', 'Curve Prepayment' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'curve_default', 'Curve Default' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'pc_abs', 'Pricer configuration for abs securities (ABS panel).' )
go

add_domain_values 'futureUnderType','BRL','' 
go
add_domain_values 'FutureMM.Pricer','PricerFutureMMBRL',''
go

UPDATE domain_values set value = 'Warrant.subtype' where name = 'domainName' and value = 'Warrant.Subtype'
go
UPDATE domain_values set name = 'Warrant.subtype' where name = 'Warrant.Subtype'
go
UPDATE domain_values set value = 'Certificate.subtype' where name = 'domainName' and value = 'Certificate.Subtype'
go
UPDATE domain_values set name = 'Certificate.subtype' where name = 'Certificate.Subtype'
go

DELETE engine_config where engine_name = 'MatchingMessageEngine'
go
DELETE ps_event_config where engine_name = 'MatchingMessageEngine'
go
DELETE ps_event_filter where engine_name = 'MatchingMessageEngine'
go
DELETE domain_values where name='engineName' and value = 'MatchingMessageEngine'
go
DELETE domain_values where name='applicationName' and value = 'MatchingMessageEngine'
go

ALTER TABLE bo_ts_priority ADD hide_priorities VARCHAR(64) NULL
go
UPDATE bo_ts_priority SET hide_priorities = '0' WHERE hide_low=1
go
UPDATE bo_ts_priority SET hide_priorities = hide_priorities || ',1' WHERE hide_normal=1 AND hide_priorities IS NOT NULL
go
UPDATE bo_ts_priority SET hide_priorities = '1' WHERE hide_normal=1 AND hide_priorities IS NULL
go
UPDATE bo_ts_priority SET hide_priorities = hide_priorities || ',2' WHERE hide_high=1 AND hide_priorities IS NOT NULL
go
UPDATE bo_ts_priority SET hide_priorities = '2' WHERE hide_high=1 AND hide_priorities IS NULL
go

UPDATE domain_values set name = 'ExternalMessageField.Amounts' where name = 'MatchingContext.Amounts'
go
UPDATE domain_values set name = 'ExternalMessageField.Dates' where name = 'MatchingContext.Dates'
go
UPDATE domain_values set name = 'ExternalMessageField.Fields' where name = 'MatchingContext.Fields'
go
UPDATE domain_values set name = 'ExternalMessageField.Roles' where name = 'MatchingContext.Roles'
go
UPDATE domain_values set name = 'ExternalMessageField.References' where name = 'MatchingContext.References'
go

delete from calypso_seed where last_id=1000 and seed_name='mcc_npv_tol'
go
INSERT INTO calypso_seed (last_id, seed_name) VALUES (1000, 'mcc_npv_tol')
go
delete from calypso_seed where last_id=1000 and seed_name='mcc_bag_tol'
go
INSERT INTO calypso_seed (last_id, seed_name) VALUES (1000, 'mcc_bag_tol')
go
delete from calypso_seed where last_id=1000 and seed_name='mcc_time_tol'
go
INSERT INTO calypso_seed (last_id, seed_name) VALUES (1000, 'mcc_time_tol')
go

add_column_if_not_exists 'mcc_npv_tol','id' ,'NUMERIC DEFAULT 0 NOT NULL'
go
add_column_if_not_exists 'mcc_npv_tol','version_num','NUMERIC DEFAULT 0 NULL'
go
add_column_if_not_exists 'mcc_bag_tol','id', 'NUMERIC DEFAULT 0 NOT NULL'
go
add_column_if_not_exists 'mcc_bag_tol','version_num', 'NUMERIC DEFAULT 0 NULL'
go
add_column_if_not_exists 'mcc_time_tol','id', 'NUMERIC DEFAULT 0 NOT NULL'
go
add_column_if_not_exists 'mcc_time_tol','version_num', 'NUMERIC DEFAULT 0 NULL'
go


CREATE PROCEDURE mcc_npv_tol_tmp
AS

DECLARE @next_id             int
DECLARE @c_product_type      varchar(32)
DECLARE @c_sub_type          varchar(32)
DECLARE @c_branch_name       varchar(32)
DECLARE @c_book_name         varchar(32)
DECLARE @c_counterparty_name varchar(32)
DECLARE @c_currency          varchar(3)
DECLARE @c_final_maturity    varchar(15)
DECLARE @c_entity            varchar(12)
DECLARE @c_tolerance_factor  float
DECLARE @Status              int

BEGIN
 BEGIN TRANSACTION
 BEGIN
  
  DECLARE c1 CURSOR FOR SELECT product_type, sub_type, branch_name, book_name, counterparty_name, currency, final_maturity, entity, tolerance_factor
  FROM mcc_npv_tol
  WHERE id = 0
  SELECT @c_tolerance_factor = 0 
  
  SELECT @next_id = last_id FROM calypso_seed WHERE seed_name = 'mcc_npv_tol' 
  
  OPEN c1 
  SELECT @Status = 0
  
  WHILE (@Status = 0)
   BEGIN
    
    FETCH c1 into @c_product_type, @c_sub_type, @c_branch_name, @c_book_name, @c_counterparty_name, @c_currency, @c_final_maturity, @c_entity, @c_tolerance_factor
    SELECT @Status = @@sqlstatus
    SELECT @Status
    
    IF (@Status <> 0)
     CONTINUE
     
     BEGIN
      SELECT @next_id = @next_id + 1
      
      UPDATE mcc_npv_tol SET id = @next_id, version_num = 0
      WHERE product_type = @c_product_type 
      AND sub_type = @c_sub_type 
      AND branch_name = @c_branch_name 
      AND book_name = @c_book_name 
      AND counterparty_name = @c_counterparty_name 
      AND currency = @c_currency 
      AND final_maturity = @c_final_maturity 
      AND entity = @c_entity 
      AND tolerance_factor = @c_tolerance_factor 
     END
   END
   
   SELECT @next_id = @next_id + 1
   
   UPDATE calypso_seed SET last_id = @next_id WHERE seed_name = 'mcc_npv_tol'
   
   CLOSE c1 
   DEALLOCATE CURSOR c1
 END
 COMMIT TRANSACTION
END
go

exec sp_procxmode 'mcc_npv_tol_tmp', 'anymode'
go
exec mcc_npv_tol_tmp 
go

DROP PROCEDURE mcc_npv_tol_tmp
go


CREATE PROCEDURE mcc_bag_tol_tmp
AS

DECLARE @next_id             int
DECLARE @c_product_type      varchar(32)
DECLARE @c_branch_name       varchar(32)
DECLARE @c_book_name         varchar(32)
DECLARE @c_currency          varchar(3)
DECLARE @c_final_maturity    varchar(15)
DECLARE @c_notional          varchar(12)
DECLARE @c_bagatell_border   float
DECLARE @Status              int

BEGIN
BEGIN TRANSACTION
 BEGIN
  
  DECLARE c1 CURSOR FOR SELECT product_type, branch_name, book_name, currency, final_maturity, notional, bagatell_border
  FROM mcc_bag_tol
  WHERE id = 0
  
  SELECT @next_id = last_id FROM calypso_seed WHERE seed_name = 'mcc_bag_tol' 
  
  OPEN c1 
  SELECT @Status = 0
  
  WHILE (@Status = 0)
   BEGIN
    
    FETCH c1 INTO @c_product_type, @c_branch_name, @c_book_name, @c_currency, @c_final_maturity, @c_notional, @c_bagatell_border
    SELECT @Status = @@sqlstatus
    SELECT @Status
    
    IF (@Status <> 0)
     CONTINUE
     
     BEGIN
      SELECT @next_id = @next_id + 1
      
      UPDATE mcc_bag_tol SET id = @next_id, version_num = 0
      WHERE product_type = @c_product_type 
      AND branch_name = @c_branch_name 
      AND book_name = @c_book_name 
      AND currency = @c_currency 
      AND final_maturity = @c_final_maturity 
      AND notional = @c_notional 
      AND bagatell_border = @c_bagatell_border 
     END
   END
   
   SELECT @next_id = @next_id + 1
   
   UPDATE calypso_seed SET last_id = @next_id WHERE seed_name = 'mcc_bag_tol'
   
   CLOSE c1 
   DEALLOCATE CURSOR c1
 END 
 COMMIT TRANACTION
END
go

exec sp_procxmode 'mcc_bag_tol_tmp', 'anymode'
go
exec mcc_bag_tol_tmp 
go

DROP PROCEDURE mcc_bag_tol_tmp
go


CREATE PROCEDURE mcc_time_tol_tmp
AS

DECLARE @next_id             int
DECLARE @c_product_type      varchar(32)
DECLARE @c_time_tolerance    varchar(32)
DECLARE @Status              int

BEGIN
BEGIN TRANSACTION
 BEGIN
  
  DECLARE c1 CURSOR FOR SELECT product_type, time_tolerance
  FROM mcc_time_tol
  WHERE id = 0
  
  SELECT @next_id = last_id FROM calypso_seed WHERE seed_name = 'mcc_time_tol' 
  
  OPEN c1 
  SELECT @Status = 0
  
  WHILE (@Status = 0)
   BEGIN
    
    FETCH c1 INTO @c_product_type, @c_time_tolerance
    SELECT @Status = @@sqlstatus
    SELECT @Status
    
    IF (@Status <> 0)
     CONTINUE
     
     BEGIN
      SELECT @next_id = @next_id + 1
      
      UPDATE mcc_time_tol SET id = @next_id, version_num = 0
      WHERE product_type = @c_product_type 
      AND time_tolerance = @c_time_tolerance 
      
     END
   END
   
   SELECT @next_id = @next_id + 1
   
   UPDATE calypso_seed SET last_id = @next_id WHERE seed_name = 'mcc_time_tol'
   
   CLOSE c1 
   DEALLOCATE CURSOR c1
 END 
 COMMIT TRANSACTION
END
go

exec sp_procxmode 'mcc_time_tol_tmp', 'anymode'
go
exec mcc_time_tol_tmp 
go

DROP PROCEDURE mcc_time_tol_tmp
go

add_domain_values 'function','ViewMarketConformityConfigDetail','Access permission to view Market Conformity tolerenace details'
go

add_domain_values 'function','ModifyMarketConformityConfigDetail','Access permission to modify Market Conformity tolerenace details'
go

add_column_if_not_exists 'currency_pair' ,'delta_display_ccy','varchar(32) null'
go 

add_column_if_not_exists 'currency_pair','pl_display_ccy', 'VARCHAR(32) NULL'
go

UPDATE currency_pair 
  SET delta_display_ccy = 'Secondary', pl_display_ccy = 'Secondary'
 WHERE pair_pos_ref_b  = 1 AND (delta_display_ccy is null OR pl_display_ccy is null)
go 

UPDATE currency_pair 
   SET delta_display_ccy = 'Primary', pl_display_ccy = 'Primary'
 WHERE pair_pos_ref_b  = 0 AND (delta_display_ccy is null OR pl_display_ccy is null)
go

UPDATE currency_pair 
   SET delta_display_ccy = 'Primary', pl_display_ccy = 'Primary'
 WHERE delta_display_ccy is null OR pl_display_ccy is null
go

UPDATE currency_pair SET delta_display_ccy = 'Secondary' WHERE delta_display_ccy = 'Quoting'
go
 
UPDATE currency_pair SET pl_display_ccy = 'Secondary' WHERE pl_display_ccy = 'Quoting'
go


/* BZ41149 */
UPDATE pc_surface SET desc_name = desc_name+'.ANY' WHERE desc_name LIKE '%Commodity%' AND desc_name NOT LIKE '%Commodity.%.%.%'
go

ALTER TABLE nds_ext_info ADD
fx_fixed_rate_b int default 0 null,
fx_timing varchar(16) null,
fx_fixed_rate float null,
fx_first_rate float null
go

UPDATE nds_ext_info SET fx_fixed_rate_b = 0 WHERE fx_fixed_rate_b is null
go

UPDATE nds_ext_info SET fx_timing = 'END_PER' WHERE fx_fixed_rate_b = 0
go

ALTER TABLE nds_ext_info modify fx_fixed_rate_b not null
go

update product_bond set allowed_redemption_type = 'Full' where allowed_redemption_type is null
go

add_column_if_not_exists 'basic_product', 'include_underlying_b', 'int default 0 null'
go


update feed_address
set quote_name = 'Inflation.'+rid.currency_code+'.'+rid.rate_index_code
from feed_address fa, rate_index_default rid
where
fa.quote_name like  'Inflation.%.%.%'
and fa.quote_name like 'Inflation.'+rid.currency_code+'.'+rid.rate_index_code+'.%'
and not Exists
(select 1
where
fa.quote_name ='Inflation.'+rid.currency_code+'.'+rid.rate_index_code)
go

DELETE FROM referring_object WHERE rfg_tbl_name='mrgcall_config' AND rfg_tbl_join_cols='sec_sd_filter_name'
go  

add_domain_values 'domainName','frequency','Custom frequencies'
go

if exists(select 1 from sysobjects where name='pc_pricer_bak')
begin
exec('select * into pc_pricer_bak_old from pc_pricer_bak')
exec('drop table pc_pricer_bak')
end
go

go
select * into pc_pricer_bak from pc_pricer
go

create procedure pc_pricer_tmp as
begin
declare
  c1 cursor for select pricer_config_name, product_type, product_pricer from pc_pricer
     where product_type = 'FXOption.ANY.ANY' and product_pricer = 'PricerFXOption'

open c1

declare @_pricer_config_name varchar(128)
declare @_product_type       varchar(128)
declare @_product_pricer     varchar(128)

fetch c1 into @_pricer_config_name, @_product_type, @_product_pricer

  while (@@sqlstatus = 0)
    begin
      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.FADER','PricerFXOptionFader')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.VOLFWD','PricerFXOptionVolFwd')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.DIGITAL','PricerFXOptionDigital')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.American','PricerFXOptionVanilla')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.LOOKBACK','PricerFXOptionLookBack')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.ASIAN','PricerFXOptionAsian')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.BARRIER','PricerFXOptionBarrier')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.European','PricerFXOptionVanilla')

      insert into pc_pricer (pricer_config_name, product_type, product_pricer) values
             (@_pricer_config_name,'FXOption.ANY.RANGEACCRUAL','PricerFXOptionRangeAccrual')

              fetch c1 into @_pricer_config_name, @_product_type, @_product_pricer
    end
    commit

close c1

  delete from pc_pricer where product_type = 'FXOption.ANY.ANY' and product_pricer = 'PricerFXOption'

deallocate cursor c1
end
go

exec sp_procxmode 'pc_pricer_tmp','anymode'
go

exec pc_pricer_tmp
go

drop procedure pc_pricer_tmp
go

add_domain_values 'feeCalculator' , 'MarginPtsPVBaseSpot', ''
go

DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_RISKY_PRIM'
go
DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_MTM_PRIM'
go
DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_RISKY_SEC'
go
DELETE FROM pricer_measure where measure_name = 'FWD_DELTA_MTM_SEC'
go
DELETE FROM pricer_measure where measure_name = 'DELTA_RISKY_PRIM'
go
DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_PRIM'
go
DELETE FROM pricer_measure where measure_name = 'DELTA_RISKY_SEC'
go
DELETE FROM pricer_measure where measure_name = 'DELTA_MTM_SEC'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('FWD_DELTA_RISKY_PRIM','tk.core.PricerMeasure',252,'Delta where MTM currency is secondary')
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('FWD_DELTA_RISKY_SEC','tk.core.PricerMeasure',251,'Delta where MTM currency is primary')
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('DELTA_RISKY_SEC','tk.core.PricerMeasure',243,'Delta where MTM currency is primary replaces DELTA_W_PREMIUM')
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('DELTA_RISKY_PRIM','tk.core.PricerMeasure',244,'Delta where MTM currency is secondary')
go

delete from pricer_measure where measure_name='DELTA_B4_UP_BAR' and measure_class_name='tk.core.PricerMeasure'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('DELTA_B4_UP_BAR','tk.core.PricerMeasure',246,'Barr Delta')
go
delete from pricer_measure where measure_name='DELTA_B4_DOWN_BAR' and measure_class_name='tk.core.PricerMeasure'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('DELTA_B4_DOWN_BAR','tk.core.PricerMeasure',247,'Barr Delta')
go
delete from pricer_measure where measure_name='MDELTA_B4_UP_BAR' and measure_class_name='tk.core.PricerMeasure'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('MDELTA_B4_UP_BAR','tk.core.PricerMeasure',248,'Barr Delta')
go
delete from pricer_measure where measure_name='MDELTA_B4_DOWN_BAR' and measure_class_name='tk.core.PricerMeasure'
go

INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('MDELTA_B4_DOWN_BAR','tk.core.PricerMeasure',249,'Barr Delta')
go

add_column_if_not_exists 'tws_risk_node','dispatcher_name', 'VARCHAR(32) NULL'
go

add_domain_values 'Swaption.subtype','FT European','' 
go
add_domain_values 'Swaption.subtype','FT American','' 
go
add_domain_values 'Swaption.subtype','FT Bermudan','' 
go

select * into ps_event_bak from ps_event 
go

update report_win_def set use_book_hrchy = 0, use_color=0 where def_name = 'RiskAggregation'
go
 
add_domain_values 'scheduledTask',  'SAVE_POSITION_SNAPSHOT', 'Task to store snapshots of positions' 
go


create procedure cu_future_tmp as

create table cu_future_tmptable(
contract_id int null,
contract_rank int null,
cu_currency char(3) null,
quote_name varchar(255) null,
user_name varchar(32) null
)

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

DECLARE c1 CURSOR FOR select * from cu_future_tmptable

declare @contract_id        int
declare @contract_rank       int
declare @trade_seed_id int
declare @curreny varchar(3)
declare @quote_name varchar(255)
declare @user_name varchar(32)

select @contract_id = 0
select @contract_rank = 0
select @trade_seed_id = last_id from calypso_seed where seed_name = 'refdata'

BEGIN

OPEN c1
fetch c1 into @contract_id, @contract_rank, @curreny, @quote_name, @user_name
  while (@@sqlstatus = 0)
    begin
   	    select @trade_seed_id = @trade_seed_id + 1
	    insert into cu_future (cu_id, contract_id, contract_rank, serial_b)
	    values(@trade_seed_id,@contract_id,@contract_rank,1)
            insert into curve_underlying (cu_id, cu_type, cu_currency, quote_name, user_name, version_num)
            values(@trade_seed_id,'CurveUnderlyingFuture', @curreny, @quote_name, @user_name, 0)
            fetch c1 into @contract_id, @contract_rank, @curreny, @quote_name, @user_name
    end

    select @trade_seed_id = @trade_seed_id + 1

    update calypso_seed set last_id = @trade_seed_id where seed_name = 'refdata'
    


    commit

CLOSE c1

DEALLOCATE  cursor c1

end
go

exec sp_procxmode 'cu_future_tmp', 'anymode'  
go 

exec cu_future_tmp  
go

drop table cu_future_tmptable
go

drop procedure cu_future_tmp
go

alter table bond_pool_factor add int_shrt_reim float null
go
alter table bond_pool_factor add prin_shrt_reim float null
go
alter table bond_pool_factor add writedown_reim float null
go

update bond_pool_factor set int_shrt_reim=int_shrt*-1,int_shrt=0 where int_shrt < 0
go
update bond_pool_factor set prin_shrt_reim=prin_shrt*-1,prin_shrt=0 where prin_shrt < 0
go
update bond_pool_factor set writedown_reim=writedown*-1,writedown=0 where writedown < 0
go
 
update product_variance_swap set underlying_id = 0 where underlying_id is NULL
go

UPDATE pc_param SET param_value = 'CORE_SWAPTION' WHERE 
 param_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND param_value = 'DIAGONAL_SWAPTION'
go

UPDATE pc_param SET param_value = 'CORE_SWAPTION_ATM' WHERE 
 param_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND param_value = 'DIAGONAL_SWAPTION_ATM'
go

UPDATE pricing_param_items SET attribute_value = 'CORE_SWAPTION' WHERE 
 attribute_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND attribute_value = 'DIAGONAL_SWAPTION'
go

UPDATE pricing_param_items SET attribute_value = 'CORE_SWAPTION_ATM' WHERE 
 attribute_name = 'LGMM_CALIBRATION_INSTRUMENTS' AND attribute_value = 'DIAGONAL_SWAPTION_ATM'
go

UPDATE pricing_param_name SET param_domain = 'CORE_SWAPTION,CORE_AND_SHORT_SWAPTION,CORE_SWAPTION_ATM,CORE_AND_SHORT_SWAPTION_ATM' 
 WHERE param_name = 'LGMM_CALIBRATION_INSTRUMENTS'
go

UPDATE pricing_param_name SET default_value = 'CORE_SWAPTION' WHERE param_name = 'LGMM_CALIBRATION_INSTRUMENTS'
go

create table underlying (
 underlying_id int not null,
 product_id int not null,
 underlying_type varchar(32) not null,
 reset_instance varchar(16) not null,
constraint pk_underlying primary key clustered (underlying_id))
go

alter table underlying add pvs_id int null
go

create procedure pvs_tmp as
begin
declare 
c1 cursor for  select pd.product_type, 
                     pvs.underlying_id, 
                     pd.product_id,
                     pvs.product_id 
               from 
                     product_desc pd, 
                     product_variance_swap pvs
              where 
                     pd.product_id=pvs.underlying_id 
              for read only


open c1 

declare @_product_type varchar(16)
declare @_underlying_id int 
declare @_pdproduct_id int 
declare @_pvsid int
declare @_counter int 

select @_counter = 1

fetch c1 into @_product_type, @_underlying_id, @_pdproduct_id, @_pvsid
  while (@@sqlstatus = 0) 
    begin

	insert into underlying (underlying_id, product_id, underlying_type, reset_instance, pvs_id)
        values (@_counter, @_pdproduct_id, @_product_type, 'CLOSE', @_pvsid)

      fetch c1 into @_product_type, @_underlying_id, @_pdproduct_id, @_pvsid
      select @_counter = @_counter + 1
      
    end 
commit
close c1
deallocate cursor c1
end
go

exec sp_procxmode 'pvs_tmp', 'anymode'
go

exec pvs_tmp
go

update product_variance_swap set underlying_id = (select u.underlying_id from underlying u where u.pvs_id=product_variance_swap.product_id) 
go

alter table underlying drop pvs_id 
go

drop procedure pvs_tmp 
go


DELETE FROM pricer_measure where measure_name = 'REAL_RHO'
go
DELETE FROM pricer_measure where measure_name = 'REAL_RHO2'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('REAL_RHO','tk.core.PricerMeasure',236,'')
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('REAL_RHO2','tk.core.PricerMeasure',237,'')
go

add_column_if_not_exists 'eventClass','PSEventMarketConformity','' 
go

delete from domain_values where name like 'VarianceSwap%'
go
delete from domain_values where value like 'VarianceSwap%'
go

add_column_if_not_exists 'domainName', 'productInterfaceReportStyle', 'Product Interface ReportStyles - used by Trade Browser to retrieve column names and values'
go
add_domain_value 'domainName', 'productTypeReportStyle', 'Product Interface ReportStyles - used by Trade Browser to retrieve column names and values')
go
add_domain_value 'productInterfaceReportStyle', 'CashFlowGeneratorBased', 'CashFlowGeneratorBased ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'CashSettled', 'CashSettled ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'CollateralBased', 'CollateralBased ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'CommodityBased', 'CommodityBased ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'CreditRisky', 'CreditRisky ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'FXBased', 'FXBased ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'FXProductBased', 'FXProductBased ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'Option', 'Option ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'RepoBased', 'RepoBased ReportStyle'
go
add_domain_value 'productInterfaceReportStyle', 'SpecificResetBased', 'SpecificResetBased ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'Bond', 'Bond ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CA', 'CA ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CapFloor', 'CapFloor ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CDSIndex', 'CDSIndex ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CDSIndexTranche', 'CDSIndexTranche ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CDSNthLoss', 'CDSNthLoss ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'Collateral', 'Collateral ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CommodityCapFloor', 'CommodityCapFloor ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CommodityForward', 'CommodityForward ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CommodityOTCOption2', 'CommodityOTCOption2 ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CommoditySwap', 'CommoditySwap ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CommoditySwap2', 'CommoditySwap2 ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CommoditySwaption', 'CommoditySwaption ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CreditDefaultSwap', 'CreditDefaultSwap ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'CreditDefaultSwaption', 'CreditDefaultSwaption ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'Equity', 'Equity ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'FacilityRepo', 'FacilityRepo ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'FutureBond', 'FutureBond ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'FutureFX', 'FutureFX ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'FXOption', 'FXOption ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'FXOptionForward', 'FXOptionForward ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'FXOptionStrip', 'FXOptionStrip ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'FXTakeUp', 'FXTakeUp ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'MarginCall', 'MarginCall ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'OTCCommodityOption', 'OTCCommodityOption ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'Repo', 'Repo ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'SimpleMM', 'SimpleMM ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'SimpleRepo', 'SimpleRepo ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'SpreadCapFloor', 'SpreadCapFloor ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'SpreadSwap', 'SpreadSwap ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'StructuredProduct', 'StructuredProduct ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'Swap', 'Swap ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'Swaption', 'Swaption ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'TotalReturnSwap', 'TotalReturnSwap ReportStyle'
go
add_domain_value 'productTypeReportStyle', 'Warrant', 'Warrant ReportStyle'
go

if not exists (select 1 from sysobjects where name='product_commodity_swap2')
begin
exec('create table product_commodity_swap2 (
	product_id numeric,
	pay_leg_id numeric,
        receive_leg_id numeric,
	currency_code  varchar(3),
	averaging_policy varchar(64),
	custom_flows_b numeric,
	flows_blob  image null,
	avg_rounding_policy  varchar(64),
  constraint pk_product_comm_swap2 primary key (product_id))')
end
go

if not exists (select 1 from sysobjects where name='cf_sch_gen_params')
begin
exec('create table cf_sch_gen_params (
	product_id  numeric,
	start_date  datetime,
	end_date  datetime,
	payment_lag  numeric,
	payment_calendar  varchar(64),
	fixing_date_policy numeric,
	fixing_calendar  varchar(64),
	payment_offset_bus_b  numeric,
	payment_day numeric,
	payment_date_rule numeric,
constraint ct_primarykey primary key (product_id))')
end 
go

if not exists (select 1 from sysobjects where name='product_commodity_otcoption2')
begin
exec ('create table product_commodity_otcoption2  (
	product_id  numeric,
	leg_id  numeric,
	buy_sell  varchar(4),
	option_type  varchar(4),
	currency_code varchar(3),
	averaging_policy  varchar(64),
	custom_flows_b numeric,
	flows_blob image null,
	avg_rounding_policy  varchar(64),
constraint pk_prod_comm_otc_op2 primary key (product_id))')
end 
go

if not exists (select 1 from sysobjects where name='commodity_leg2')
begin
exec ('create table commodity_leg2 (
	leg_id numeric,
	leg_type numeric,
	strike_price float,
	strike_price_unit varchar(32),
	comm_reset_id  numeric,
	spread float,
	fx_reset_id numeric,
	fx_calendar varchar(64),
	cashflow_locks numeric,
	cashflow_changed numeric,
	quantity float,
	quantity_unit varchar(32),
	per_period varchar(32),
	version numeric,
	round_unit_conv_b numeric,
constraint pk_comm_leg2 primary key (leg_id))')
end
go

UPDATE calypso_info
SET  patch_version='002',
patch_date='20070830'
go

