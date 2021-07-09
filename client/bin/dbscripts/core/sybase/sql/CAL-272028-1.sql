 
if not exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'liq_config_name'
        and syscolumns.name = 'config_level' )
begin
    exec ('alter table liq_config_name add config_level varchar(32) null')
	end
go
declare @vsql varchar(500)
if exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='liq_info' and syscolumns.name ='liq_agg_only_b' )
begin
select @vsql ='update liq_config_name set config_level = 
(SELECT MAX(CASE liq_agg_only_b WHEN 1 THEN '||char(39)||'1'||char(39)||' ELSE '||char(39)||'0,1'||char(39)||' END) as config_level
FROM liq_info where liq_info.liq_config_id = liq_config_name.id
group by liq_info.liq_config_id
) where config_level is null'
exec (@vsql)
end
go

if exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name ='liq_info' and syscolumns.name ='liq_agg_only_b' )
begin
exec ('alter table liq_info drop liq_agg_only_b')
end
go
update liq_config_name set config_level = '0,1' where config_level is null
go

add_column_if_not_exists 'liq_config_name','trade_filter_name','varchar(255) null'
go
update liq_config_name set trade_filter_name = (
select domain_values.description from domain_values where 
domain_values.name = 'LiquidationConfigTradeFilter' and domain_values.value = liq_config_name.name and exists (select 1 from domain_values ref where ref.name='LiquidationConfigTradeFilter'))
go
delete domain_values where name = 'domainName' and value = 'LiquidationConfigTradeFilter'
go
delete domain_values where name = 'LiquidationConfigTradeFilter'
go

declare @string varchar(255)
if not exists (select 1 from engine_param where engine_name='TransferEngine' and param_name='XFER_POS_AGGREGATION_NAME')
begin  
  update domain_values set @string = @string + value + ',',value=value where name = 'XferPosAggregation'
  select @string
  insert into engine_param(engine_name, param_name, param_value)
  values ('TransferEngine', 'XFER_POS_AGGREGATION_NAME', @string)

  delete domain_values where name = 'XferPosAggregation'
end
go


/* diff 143. */

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_CCR_EAD','tk.pricer.PricerMeasureEAD',5000,'Basel III Exposure at Default' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_CCR_PFE','tk.pricer.PricerMeasurePFE',5001,'Basel III Potential Future Exposure' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_CCR_CVA','tk.pricer.PricerMeasureCVA',5002,'Fast CVA' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_CCR_CVA01','tk.pricer.PricerMeasureCVA01',5003,'Fast CVA Delta (1bps CDS shift)' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_CCR_CVA_SPREAD','tk.pricer.PricerMeasureCVASpread',5004,'Fast CVA Spread for swaps' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_CCR_KCVA','tk.pricer.PricerMeasureKCVA',5005,'Basel III Capital CVA' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_MR_IR_CAPITAL','tk.pricer.PricerMeasureIRCapital',5006,'Basel III IR Capital' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_MR_FX_CAPITAL','tk.pricer.PricerMeasureFXCapital',5007,'Basel III FX Capital' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_MR_CO_CAPITAL','tk.pricer.PricerMeasureCOCapital',5008,'Basel III CO Capital' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_MR_EQ_CAPITAL','tk.pricer.PricerMeasureEQCapital',5009,'Basel III EQ Capital' )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (827,'DecSuppOrder','NONE','SIMULATE','SIMULATED',1,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (828,'DecSuppOrder','SIMULATED','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'AUDIT_FILTER',500 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'decsupporder',1 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1,'analysis_output_page',1 )
go
add_domain_values  'function','AddModifyCashLiquidityManagerRegionalPreference','AccessPermission for ability to Add or Modify Cash Liquidity Manager Regional Preferences' 
go
add_domain_values  'function','AddModifyClassificationItem','Access Permission for ability to Add or Modify any Classification Item like Factor, Attribute, Criterion, Classification, Level, NamedList, Remaps' 
go
add_domain_values  'classAccessMode','ClassificationFactors','' 
go
add_domain_values  'classAccessMode','ClassificationAttributes','' 
go
add_domain_values  'classAccessMode','ClassificationCriteria','' 
go
add_domain_values  'classAccessMode','Classifications','' 
go
add_domain_values  'classAccessMode','ClassificationLevels','' 
go
add_domain_values  'classAccessMode','ClassificationRemaps','' 
go
add_domain_values  'classAccessMode','ClassificationNamedLists','' 
go
add_domain_values  'FtpCostComponentNames','OVERNIGHT_CASH_SWEEP_COST','Overnight Cash Sweep Cost' 
go
add_domain_values  'FtpCostComponentNames','OVERNIGHT_CASH_INTEREST_COST','Overnight CASH INTEREST Cost' 
go
add_domain_values  'FtpCostComponentNames','SECURITIZED_FUNDING_CASH_SWEEP_COST','Securitized Funding Cash Sweep Cost' 
go
add_domain_values  'FtpCostComponentNames','SECURITIZED_FUNDING_INTEREST_COST','Securitized Funding Interest Cost' 
go
add_domain_values  'FtpCostComponentNames','SECURITIZED_FUNDING_SECURITY_SWEEP_COST','Securitized Funding Security Sweep Cost' 
go
add_domain_values  'scheduledTask','GEN_FUNDING_FTP_ACCRUALS','' 
go
add_domain_values  'flowType','FTP_ON_CASH_CARRY','FTP Cost flow type' 
go
add_domain_values  'flowType','FTP_SEC_SEC_CARRY','FTP Cost flow type' 
go
add_domain_values  'flowType','FTP_ON_SWEEP','FTP Cost flow type' 
go
add_domain_values  'flowType','FTP_SEC_CASH_SWEEP','FTP Cost flow type' 
go
add_domain_values  'flowType','FTP_SEC_SEC_SWEEP','FTP Cost flow type' 
go
add_domain_values  'currencyDefaultAttribute','FtpFundingIndex','Funding index that is used when creating the benchmark index for FTP rules.' 
go
add_domain_values  'currencyDefaultAttribute','FtpFundingIndexTenor','Funding index tenor that is used when creating the benchmark index for FTP rules.' 
go
add_domain_values  'domainName','TreasuryOperatingModel','Treasury Operating Model' 
go
add_domain_values  'domainName','BOPosition.DrillDown.Cash.Balance.ShowAllMovements','specify the balance which will show all movements on drilldown' 
go
add_domain_values  'domainName','BOPosition.DrillDown.Security.Balance.ShowAllMovements','specify the balance which will show all movements on drilldown' 
go
add_domain_values  'domainName','PortfolioSwap.subtype','subtype for portfolio Swap products' 
go
add_domain_values  'domainName','PortfolioSwapPosition.subtype','subtype for portfolioSwapPosition products' 
go
add_domain_values  'domainName','accFeeLiquidation','Sell Trade Fees Liquidation' 
go
add_domain_values  'domainName','PropagateLEAttribute','List of LE Attribute to be propagated to Transfers' 
go
add_domain_values  'domainName','messageExcludeTemplates','List of Template to be excluded from macthing' 
go
add_domain_values  'messageExcludeTemplates','MT530','' 
go
add_domain_values  'messageExcludeTemplates','sese.030.001','' 
go
add_domain_values  'domainName','messageExcludeAction','List of Action (Trade/Transfer to be excluded from macthing' 
go
add_domain_values  'domainName','auditFilterOperators','' 
go
add_domain_values 'auditFilterOperators','ALL_IN' ,''
go
add_domain_values 'auditFilterOperators','NOT_ALL_IN','' 
go
add_domain_values 'auditFilterOperators','NOT_IN','' 
go
add_domain_values  'domainName','auditFilterType','' 
go
add_domain_values  'auditFilterType','Trade','tk.core.Trade' 
go
add_domain_values  'classAuditMode','AuditFilter','' 
go
add_domain_values  'cdsPmtLagType','As per Section 8.6 of the Definitions','' 
go
add_domain_values  'cdsPmtLagType','Section 8.6/Not to exceed thirty business days','' 
go
add_domain_values  'domainName','FXFlexiForward.Pricer','Pricers for FX flexi forward trades' 
go
add_domain_values  'domainName','FXFlexiForward.subtype','Types of FXFlexiForward' 
go
add_domain_values  'domainName','FXFlexiForwardMerchantFX.ExportBillDiscountRollDays','Merchant FX Export Bill discount Roll Days' 
go
add_domain_values  'classAuthMode','AuditFilter','' 
go
add_domain_values  'PositionBasedProducts','PortfolioSwap','' 
go
add_domain_values  'XferAttributes','OriginatingPrimaryId','' 
go
add_domain_values  'systemKeyword','FXFlexiForwardParentTradeId','Indicates the parent flexi-forward trade id for the take-up FXForward trade' 
go
add_domain_values  'systemKeyword','FXFlexiForwardTakeupForwardTrade','Value true indicates the FXForward trade represents a take-up on the FXFlexiForward' 
go
add_domain_values  'systemKeyword','FXFlexiForwardSightBillSpread','The SightBillSpread applied during the take-up on the FXFlexiForward' 
go
add_domain_values  'systemKeyword','FXFlexiForwardHRRMargin','The HRR Margin applied during the take-up on the FXFlexiForward' 
go
add_domain_values  'tradeKeyword','FXFlexiForwardParentTradeId','Indicates the parent flexi-forward trade id for the take-up FXForward trade' 
go
add_domain_values  'tradeKeyword','FXFlexiForwardTakeupForwardTrade','Value true indicates the FXForward trade represents a take-up on the FXFlexiForward' 
go
add_domain_values  'tradeKeyword','FXFlexiForwardSightBillSpread','The SightBillSpread applied during the take-up on the FXFlexiForward' 
go
add_domain_values  'tradeKeyword','FXFlexiForwardHRRMargin','The HRR Margin applied during the take-up on the FXFlexiForward' 
go
add_domain_values  'domainName','InventoryClosurePositions','List of positions to check during closure' 
go
add_domain_values  'XferAttributes','NettingRunConfig','' 
go
add_domain_values  'workflowRuleTransfer','CheckRecalcNettingRun','' 
go
add_domain_values  'workflowRuleTransfer','SetAttributes','' 
go
add_domain_values  'scheduledTask','CALIBRATE','Scheduled task to Recalibrate and persist Model Calibratio' 
go
add_domain_values  'scheduledTask','EOD_PORTFOLIO_SWAP','Spot PL Sweep' 
go
add_domain_values  'userAttributes','FXFlexiForward Default Start Tenor','' 
go
add_domain_values  'userAttributes','FXFlexiForward Default End Tenor','' 
go
add_domain_values  'userAttributes','FXFlexiForward Default Window Type','' 
go
add_domain_values  'userAttributes','FXFlexiForward Default TakeUp Type','' 
go
add_domain_values  'userAttributes','FXFlexiForward Default ShortDays Strategy','' 
go
add_domain_values  'domainName','FXSwapMarginLookup','FXSwap (or FXNDFSwap sales margin look-up. Acceptable values: ''Near'', ''Far'', ''Both''.' 
go
add_domain_values  'domainName','DisplayFXShortDatedPointsPositiveTime','Indicates if the deal-station should display points for short dated trades in flipped sign. Acceptable values: ''True'', ''False''.' 
go
add_domain_values  'accEventType','COT_FX_CCY','' 
go
add_domain_values  'accEventType','COT_REV_FX_CCY','' 
go
add_domain_values  'accEventType','NOM_CLEAN_FX_CCY','' 
go
add_domain_values  'AccountSetup','CHECK_CLOSE_SETTLE_ACCOUNT','false' 
go
add_domain_values  'FXFlexiForward.Pricer','PricerFXFlexiForward','' 
go
add_domain_values  'CreditDefaultSwap.Pricer','PricerCreditDefaultSwapQuanto','' 
go
add_domain_values  'FXOption.Pricer','PricerFXOptionVanillaHeston','Heston model valuation of vanilla options' 
go
add_domain_values  'FXOption.Pricer','PricerFXOptionBarrierHestonMC','Heston model valuation of barrier options using Monte Carlo' 
go
add_domain_values  'FXOption.Pricer','PricerFXOptionBarrierHestonFD','Heston model valuation of barrier options using Finite Differences' 
go
add_domain_values  'FXFlexiForward.subtype','TakeUpSchedule','' 
go
add_domain_values  'FXFlexiForward.subtype','MerchantFX','' 
go
add_domain_values  'FXFlexiForwardMerchantFX.ExportBillDiscountingRollDays','30','' 
go
add_domain_values  'eventFilter','PortfolioSwapEventFilter','filter for Portfolio Swap and Position Engine' 
go
add_domain_values  'eventClass','PSEventTriggerTrade','' 
go
add_domain_values  'eventClass','PSEventPositionKeepingProcessedTrade','An event to signify the persistence of position-keeping processing information for a trade.' 
go
add_domain_values  'eventType','EX_FLEXIFORWARD_LATE_TAKEUP_SUCCESS','The FLEXIFORWARD_LATE_TAKEUP scheduled task was successful.' 
go
add_domain_values  'eventType','EX_FLEXIFORWARD_LATE_TAKEUP_FAILURE','The FLEXIFORWARD_LATE_TAKEUP scheduled task was not successful.' 
go
add_domain_values  'exceptionType','FLEXIFORWARD_LATE_TAKEUP_SUCCESS','' 
go
add_domain_values  'exceptionType','FLEXIFORWARD_LATE_TAKEUP_FAILURE','' 
go
add_domain_values  'eventType','EX_MERCHANTFX_ROLLOVER_SUCCESS','The MERCHANTFX_ROLLOVER scheduled task was successful.' 
go
add_domain_values  'eventType','EX_MERCHANTFX_ROLLOVER_FAILURE','The MERCHANTFX_ROLLOVER scheduled task was not successful.' 
go
add_domain_values  'exceptionType','MERCHANTFX_ROLLOVER_SUCCESS','' 
go
add_domain_values  'exceptionType','MERCHANTFX_ROLLOVER_FAILURE','' 
go
add_domain_values  'function','CreateAuditFilter','Access permission to create an Audit Filter' 
go
add_domain_values  'function','ModifyAuditFilter','Access permission to modify an Audit Filter' 
go
add_domain_values  'function','DeleteAuditFilter','Access permission to delete an Audit Filter' 
go
add_domain_values  'function','ViewOnlySameGroupAuditEntry','Access permission to restrict ability to view audit value whose modified user belongs to the same group as current user' 
go
add_domain_values  'restriction','ViewOnlySameGroupAuditEntry','' 
go
add_domain_values  'function','CheckPermForAuthTrade','Access permission to Restrict ability to Authorize trade without permission on action' 
go
add_domain_values  'function','ModifyTradeDateTime','Access permission to Restrict ability to Modify trade datetime' 
go
add_domain_values  'function','AddModifyLECommonRole','Access permission to Add/Modify Legal Entity common role' 
go
add_domain_values  'function','RemoveLECommonRole','Access permission to Remove Legal Entity common role' 
go
add_domain_values  'function','AddModifyLEDedicatedRole','Access permission to Add/Modify Legal Entity dedicated role' 
go
add_domain_values  'function','RemoveLEDedicatedRole','Access permission to Remove Legal Entity dedicated role' 
go
add_domain_values  'restriction','CheckPermForAuthTrade','' 
go
add_domain_values  'restriction','ModifyTradeDateTime','' 
go
add_domain_values  'marketDataUsage','CLOSING_TRADE','usage type for Repo Underlying Curve Mapping with Cost to Close pricing' 
go
add_domain_values  'CLOSING_TRADE.ANY.ANY','CurveRepo','Open CurveRepoSelector for usage CLOSING_TRADE in PricerConfig > Product Specific' 
go
add_domain_values  'productType','FXFlexiForward','' 
go
add_domain_values  'scheduledTask','FLEXIFORWARD_LATE_TAKEUP','Scheduled Task to update the FlexiForward TakeUp Schedule trades' 
go
add_domain_values  'scheduledTask','MERCHANTFX_ROLLOVER','Scheduled Task to rollover the FlexiForward MerchantFX trades' 
go
add_domain_values  'yieldMethod','Exponential','' 
go
add_domain_values  'productTypeReportStyle','FXFlexiForward','FXFlexiForward ReportStyle' 
go
add_domain_values  'productTypeReportStyle','FXFlexiForwardTakeUpSchedule','FXFlexiForward ReportStyle for TakeUpSchedule sub-type' 
go
add_domain_values  'productTypeReportStyle','FXFlexiForwardMerchantFX','FXFlexiForward ReportStyle for MerchantFX sub-type' 
go
add_domain_values  'productTypeReportStyle','PortfolioSwap','' 
go
add_domain_values  'bulkEntry.productType','PortfolioSwap','' 
go
add_domain_values  'keyword.CATradeBasis','CCPN','Special Ex - Trade was executed cum coupon' 
go
add_domain_values  'keyword.CATradeBasis','XCPN','Special Ex - Trade was executed ex coupon' 
go
add_domain_values  'keyword.CATradeBasis','CWAR','Special Ex - Trade was executed cum warrants' 
go
add_domain_values  'keyword.CATradeBasis','XWAR','Special Ex - Trade was executed ex warrants' 
go
add_domain_values  'sdFilterCriterion.Factory','PortfolioSwap','' 
go
add_domain_values  'sdFilterCriterion.Factory','FXFlexiForwardTakeUpSchedule','FXFlexiForward TakeUpSchedule Static Data Filter criteria' 
go
add_domain_values  'sdFilterCriterion.Factory','FXFlexiForwardMerchantFX','FXFlexiForward MerchantFX Static Data Filter criteria' 
go
add_domain_values  'domainName','CommonLERole','' 
go
add_domain_values  'CommonLERole','Issuer','' 
go
add_domain_values  'CommonLERole','MarketPlace','' 
go
add_domain_values  'function','ResetPLConfig','Allow User to delete OfficialPLConfig Marks' 
go
add_domain_values  'function','Bulk Import of OfficialPL Marks','Allow User to import OfficialPL Marks' 
go
add_domain_values  'function','Generate Conversion Factors','Allow User to generate OfficialPL ConversionFactor Marks' 
go
add_domain_values  'workflowRuleTransfer','PropagateLEAttribute','' 
go
add_domain_values  'workflowRuleTransfer','PropagateSDIAttribute','' 
go
add_domain_values 'PricingSheetMeasures','SA_CCR_EAD' ,''
go
add_domain_values 'PricingSheetMeasures','SA_CCR_PFE','' 
go
add_domain_values 'PricingSheetMeasures','SA_CCR_CVA' ,''
go
add_domain_values 'PricingSheetMeasures','SA_CCR_CVA01' ,''
go
add_domain_values 'PricingSheetMeasures','SA_CCR_CVA_SPREAD' ,''
go
add_domain_values 'PricingSheetMeasures','SA_CCR_KCVA','' 
go
add_domain_values 'PricingSheetMeasures','SA_MR_IR_CAPITAL','' 
go
add_domain_values 'PricingSheetMeasures','SA_MR_FX_CAPITAL','' 
go
add_domain_values 'PricingSheetMeasures','SA_MR_CO_CAPITAL','' 
go
add_domain_values 'PricingSheetMeasures','SA_MR_EQ_CAPITAL','' 
go
add_domain_values  'domainName','keywords2CopyUponFXFlexiForwardTakeUp','List of Keywords to copy from original FXFlexiForward trade to FXForward trade created upon take-up.' 
go
add_domain_values  'keywords2CopyUponFXFlexiForwardTakeUp','TradePlatform','' 
go
add_domain_values  'keywords2CopyUponFXFlexiForwardTakeUp','TradeRegion','' 
go
add_domain_values  'domainName','keywords2CopyToMerchantFXTakeUpOffset','List of Keywords to copy from original MerchantFX trade to new MerchantFX Offset trade created upon take-up.' 
go
add_domain_values  'keywords2CopyToMerchantFXTakeUpOffset','TradePlatform','' 
go
add_domain_values  'keywords2CopyToMerchantFXTakeUpOffset','TradeRegion','' 
go
add_domain_values  'domainName','keywords2CopyToMerchantFXRollover','List of Keywords to copy from original MerchantFX trade to new MerchantFX trade created upon rollover.' 
go
add_domain_values  'keywords2CopyToMerchantFXRollover','TradePlatform','' 
go
add_domain_values  'keywords2CopyToMerchantFXRollover','TradeRegion','' 
go
add_domain_values  'domainName','keywords2CopyToMerchantFXRolloverOffset','List of Keywords to copy from original MerchantFX trade to new MerchantFX Offset trade created upon rollover.' 
go
add_domain_values  'keywords2CopyToMerchantFXRolloverOffset','TradePlatform','' 
go
add_domain_values  'keywords2CopyToMerchantFXRolloverOffset','TradeRegion','' 
go
add_domain_values  'domainName','keywords2CopyToMerchantFXTerminate','List of Keywords to copy from original MerchantFX trade to new MerchantFX trade created upon termination.' 
go
add_domain_values  'keywords2CopyToMerchantFXTerminate','TradePlatform','' 
go
add_domain_values  'keywords2CopyToMerchantFXTerminate','TradeRegion','' 
go
add_domain_values  'MESSAGE.Templates','TerminationConfirmationFXO.html','' 
go
add_domain_values  'MESSAGE.Templates','ExerciseConfirmationFXO.html','' 
go
add_domain_values  'MESSAGE.Templates','FXOConfirmation.html','' 
go
add_domain_values  'domainName','keepUpFrontFeeType','' 
go
add_domain_values  'keepUpFrontFeeType','UPFRONT_FEE','' 
go
add_domain_values  'scheduledTask','AM_RISK_ANALYSIS','Snapshot preconfigured analyses for chosen Funds' 
go
add_domain_values  'domainName','RatingEquivalenceType','Rating Equivalence type' 
go
add_domain_values  'DecSuppOrderStatus','NONE','Order Status' 
go
add_domain_values  'DecSuppOrderStatus','SIMULATED','Order Status' 
go
add_domain_values  'DecSuppOrderStatus','CANCELED','Order Status' 
go
add_domain_values  'DecSuppOrderAction','NEW','Action on order' 
go
add_domain_values  'DecSuppOrderAction','SIMULATE','Action on order' 
go
add_domain_values  'DecSuppOrderAction','CANCEL','Action on order' 
go
add_domain_values  'workflowType','DecSuppOrder','Decision Support Order follows its own workflow' 
go
add_domain_values  'lifeCycleEntityType','DecSuppOrder','Decision support order has its own life cycle' 
go
add_domain_values  'domainName','DecSuppOrderAction','' 
go
add_domain_values  'domainName','workflowRuleDecSuppOrder','' 
go
add_domain_values  'domainName','DecSuppOrderStatus','' 
go
add_domain_values  'eventType','NEW_DECSUPPORDER','NEW_DECSUPPORDER' 
go

add_column_if_not_exists 'quote_value','price_source_name','varchar(64) null'
go

UPDATE sd_filter_element
   SET element_name = str_replace(element_name, 'LEGAL_AGREEMENT.', 'Legal Agreement Additional Field.')
 WHERE element_name like 'LEGAL_AGREEMENT.%'
go

UPDATE sd_filter_domain
   SET element_name = str_replace(element_name, 'LEGAL_AGREEMENT.', 'Legal Agreement Additional Field.')
 WHERE element_name like 'LEGAL_AGREEMENT.%'
go

add_column_if_not_exists 'product_call_info','expiry_delivery_rollday','numeric null'
go
add_column_if_not_exists 'product_call_info','expiry_delivery_frequency','varchar(12) null'
go
add_column_if_not_exists 'product_call_info','expiry_delivery_holidays','varchar(128) null'
go
add_column_if_not_exists 'product_call_info','expiry_delivery_dateroll','varchar(18) null'
go

update product_call_info 
set expiry_delivery_rollday = convert(numeric ,code_value) from product_sec_code 
where product_sec_code.product_id=product_call_info.product_id and product_call_info.call_type='cancellable' and product_call_info.exercise_type='bermudan'
and product_sec_code.sec_code='expirydeliveryrollday'
go

update product_call_info 
set expiry_delivery_frequency = code_value from product_sec_code 
where product_sec_code.product_id=product_call_info.product_id and product_call_info.call_type='cancellable' and product_call_info.exercise_type='bermudan'
and product_sec_code.sec_code='expirydeliveryfrequency'
go
update product_call_info 
set expiry_delivery_holidays = code_value from product_sec_code 
where product_sec_code.product_id=product_call_info.product_id and product_call_info.call_type='cancellable' and product_call_info.exercise_type='bermudan'
and product_sec_code.sec_code='expirydeliveryholidays'
go
update product_call_info 
set expiry_delivery_dateroll = code_value from product_sec_code 
where product_sec_code.product_id=product_call_info.product_id and product_call_info.call_type='cancellable' and product_call_info.exercise_type='bermudan'
and product_sec_code.sec_code='ExpiryDeliveryDateRoll'
go


add_column_if_not_exists 'curve_commodity_hdr_hist','value_type', 'varchar(30) null'
go
update an_param_items set attribute_value = 'Instrument Tenor' where attribute_value = 'Volatility Tenor' 
and param_name in (select param_name from an_param_items where attribute_name='MktType' and attribute_value<>'Volatility')
go

update domain_values 
set value ='AVG_RECOVERY' 
where value='AVG_EXPOSURE' and name in ('CreditDefaultSwap.PricerMeasure', 'CreditDefaultSwapLoan.PricerMeasure', 'CDSIndex.PricerMeasure', 'CDSIndexTranche.PricerMeasure','CDSNthLoss.PricerMeasure','CDSNthDefault.PricerMeasure')
go

add_column_if_not_exists 'swaption_ext_info' , 'threshold_unit_type','varchar(32) null'
go

update swaption_ext_info set threshold_unit_type='PERCENT' where threshold_unit_type is null
go
update xccy_swap_ext_info set fx_reset_offset=0, fx_reset_holidays=null, fx_reset_id=0, default_fx_reset_b=1 where fx_reset_b=0
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='004',
        version_date='20150529'
go

