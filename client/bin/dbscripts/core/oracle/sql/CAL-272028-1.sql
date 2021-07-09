declare
  x number :=0 ;
begin
  SELECT count(*) INTO x FROM user_tab_columns WHERE table_name=upper('liq_info') and column_name=upper('liq_agg_only_b') ;
  IF x!=0 THEN
    execute immediate 'update liq_config_name set config_level = 
(SELECT 
MAX(CASE liq_agg_only_b WHEN 1 THEN ''1'' ELSE ''0,1'' END) as config_level
FROM liq_info where liq_info.liq_config_id = liq_config_name.id
group by liq_info.liq_config_id
) where config_level is null';
  END IF;
end;
;
declare
  x number :=0 ;
begin
  SELECT count(*) INTO x FROM user_tab_columns WHERE table_name=upper('liq_info') and column_name=upper('liq_agg_only_b') ;
  IF x!=0 THEN
    execute immediate 'alter table liq_info drop column liq_agg_only_b';
  END IF;
end;
;

declare
  x number :=0 ;
begin
  SELECT count(*) INTO x FROM user_tab_columns WHERE table_name=upper('liq_config_name') and column_name=upper('config_level') ;
  IF x=0 THEN
    execute immediate 'alter table liq_config_name add  config_level varchar2(32)';
  END IF;
end;
;
declare
  x number :=0 ;
begin
  SELECT count(*) INTO x FROM user_tab_columns WHERE table_name=upper('liq_config_name') and column_name=upper('trade_filter_name') ;
  IF x=0 THEN
    execute immediate 'alter table liq_config_name add  trade_filter_name varchar2(255)';
  END IF;
end;
;


update liq_config_name set config_level = '0,1' where config_level is null
;

update liq_config_name set trade_filter_name = (
select domain_values.description from domain_values where 
domain_values.name = 'LiquidationConfigTradeFilter' and domain_values.value = liq_config_name.name and exists (select 1 from domain_values ref where ref.name='LiquidationConfigTradeFilter'))
;
delete domain_values where name = 'domainName' and value = 'LiquidationConfigTradeFilter'
;
delete domain_values where name = 'LiquidationConfigTradeFilter'
;
declare 
c int; 
begin  
select count(*) into c from engine_param where engine_name='TransferEngine' and param_name='XFER_POS_AGGREGATION_NAME';
if c = 0 then
insert into engine_param(engine_name, param_name, param_value)
select 'TransferEngine', 'XFER_POS_AGGREGATION_NAME', LISTAGG(value, ',') WITHIN GROUP (order by name) as param_value from domain_values 
where name = 'XferPosAggregation';

delete domain_values where name = 'XferPosAggregation';

end if; 
end;
;

    
/* diff 14.3 */

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_CCR_EAD','tk.pricer.PricerMeasureEAD',5000,'Basel III Exposure at Default' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_CCR_PFE','tk.pricer.PricerMeasurePFE',5001,'Basel III Potential Future Exposure' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_CCR_CVA','tk.pricer.PricerMeasureCVA',5002,'Fast CVA' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_CCR_CVA01','tk.pricer.PricerMeasureCVA01',5003,'Fast CVA Delta (1bps CDS shift);' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_CCR_CVA_SPREAD','tk.pricer.PricerMeasureCVASpread',5004,'Fast CVA Spread for swaps' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_CCR_KCVA','tk.pricer.PricerMeasureKCVA',5005,'Basel III Capital CVA' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_MR_IR_CAPITAL','tk.pricer.PricerMeasureIRCapital',5006,'Basel III IR Capital' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_MR_FX_CAPITAL','tk.pricer.PricerMeasureFXCapital',5007,'Basel III FX Capital' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_MR_CO_CAPITAL','tk.pricer.PricerMeasureCOCapital',5008,'Basel III CO Capital' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment )  VALUES ('SA_MR_EQ_CAPITAL','tk.pricer.PricerMeasureEQCapital',5009,'Basel III EQ Capital' )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (827,'DecSuppOrder','NONE','SIMULATE','SIMULATED',1,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (828,'DecSuppOrder','SIMULATED','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size )  VALUES (1000,'AUDIT_FILTER',500 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size )  VALUES (1000,'decsupporder',1 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size )  VALUES (1,'analysis_output_page',1 )
;
begin
add_domain_values('function','AddModifyCashLiquidityManagerRegionalPreference','AccessPermission for ability to Add or Modify Cash Liquidity Manager Regional Preferences' );
end;
/
begin
add_domain_values('function','AddModifyClassificationItem','Access Permission for ability to Add or Modify any Classification Item like Factor, Attribute, Criterion, Classification, Level, NamedList, Remaps' );
end;
/
begin
add_domain_values('classAccessMode','ClassificationFactors','' );
end;
/
begin
add_domain_values('classAccessMode','ClassificationAttributes','' );
end;
/
begin
add_domain_values('classAccessMode','ClassificationCriteria','' );
end;
/
begin
add_domain_values('classAccessMode','Classifications','' );
end;
/
begin
add_domain_values('classAccessMode','ClassificationLevels','' );
end;
/
begin
add_domain_values('classAccessMode','ClassificationRemaps','' );
end;
/
begin
add_domain_values('classAccessMode','ClassificationNamedLists','' );
end;
/
begin
add_domain_values('FtpCostComponentNames','OVERNIGHT_CASH_SWEEP_COST','Overnight Cash Sweep Cost' );
end;
/
begin
add_domain_values('FtpCostComponentNames','OVERNIGHT_CASH_INTEREST_COST','Overnight CASH INTEREST Cost' );
end;
/
begin
add_domain_values('FtpCostComponentNames','SECURITIZED_FUNDING_CASH_SWEEP_COST','Securitized Funding Cash Sweep Cost' );
end;
/
begin
add_domain_values('FtpCostComponentNames','SECURITIZED_FUNDING_INTEREST_COST','Securitized Funding Interest Cost' );
end;
/
begin
add_domain_values('FtpCostComponentNames','SECURITIZED_FUNDING_SECURITY_SWEEP_COST','Securitized Funding Security Sweep Cost' );
end;
/
begin
add_domain_values('scheduledTask','GEN_FUNDING_FTP_ACCRUALS','' );
end;
/
begin
add_domain_values('flowType','FTP_ON_CASH_CARRY','FTP Cost flow type' );
end;
/
begin
add_domain_values('flowType','FTP_SEC_SEC_CARRY','FTP Cost flow type' );
end;
/
begin
add_domain_values('flowType','FTP_ON_SWEEP','FTP Cost flow type' );
end;
/
begin
add_domain_values('flowType','FTP_SEC_CASH_SWEEP','FTP Cost flow type' );
end;
/
begin
add_domain_values('flowType','FTP_SEC_SEC_SWEEP','FTP Cost flow type' );
end;
/
begin
add_domain_values('currencyDefaultAttribute','FtpFundingIndex','Funding index that is used when creating the benchmark index for FTP rules.' );
end;
/
begin
add_domain_values('currencyDefaultAttribute','FtpFundingIndexTenor','Funding index tenor that is used when creating the benchmark index for FTP rules.' );
end;
/
begin
add_domain_values('domainName','TreasuryOperatingModel','Treasury Operating Model' );
end;
/
begin
add_domain_values('domainName','BOPosition.DrillDown.Cash.Balance.ShowAllMovements','specify the balance which will show all movements on drilldown' );
end;
/
begin
add_domain_values('domainName','BOPosition.DrillDown.Security.Balance.ShowAllMovements','specify the balance which will show all movements on drilldown' );
end;
/
begin
add_domain_values('domainName','PortfolioSwap.subtype','subtype for portfolio Swap products' );
end;
/
begin
add_domain_values('domainName','PortfolioSwapPosition.subtype','subtype for portfolioSwapPosition products' );
end;
/
begin
add_domain_values('domainName','accFeeLiquidation','Sell Trade Fees Liquidation' );
end;
/
begin
add_domain_values('domainName','PropagateLEAttribute','List of LE Attribute to be propagated to Transfers' );
end;
/
begin
add_domain_values('domainName','messageExcludeTemplates','List of Template to be excluded from macthing' );
end;
/
begin
add_domain_values('messageExcludeTemplates','MT530','' );
end;
/
begin
add_domain_values('messageExcludeTemplates','sese.030.001','' );
end;
/
begin
add_domain_values('domainName','messageExcludeAction','List of Action (Trade/Transfer); to be excluded from macthing' );
end;
/
begin
add_domain_values('domainName','auditFilterOperators','' );
end;
/
begin
add_domain_values('auditFilterOperators','ALL_IN','' );
end;
/
begin
add_domain_values('auditFilterOperators','NOT_ALL_IN' ,'');
end;
/
begin
add_domain_values('auditFilterOperators','NOT_IN','' );
end;
/
begin
add_domain_values('domainName','auditFilterType','' );
end;
/
begin
add_domain_values('auditFilterType','Trade','tk.core.Trade');
end;
/
begin
add_domain_values('classAuditMode','AuditFilter','' );
end;
/
begin
add_domain_values('cdsPmtLagType','As per Section 8.6 of the Definitions','' );
end;
/
begin
add_domain_values('cdsPmtLagType','Section 8.6/Not to exceed thirty business days','' );
end;
/
begin
add_domain_values('domainName','FXFlexiForward.Pricer','Pricers for FX flexi forward trades' );
end;
/
begin
add_domain_values('domainName','FXFlexiForward.subtype','Types of FXFlexiForward' );
end;
/
begin
add_domain_values('domainName','FXFlexiForwardMerchantFX.ExportBillDiscountRollDays','Merchant FX Export Bill discount Roll Days' );
end;
/
begin
add_domain_values('classAuthMode','AuditFilter','' );
end;
/
begin
add_domain_values('PositionBasedProducts','PortfolioSwap','' );
end;
/
begin
add_domain_values('XferAttributes','OriginatingPrimaryId','' );
end;
/
begin
add_domain_values('systemKeyword','FXFlexiForwardParentTradeId','Indicates the parent flexi-forward trade id for the take-up FXForward trade' );
end;
/
begin
add_domain_values('systemKeyword','FXFlexiForwardTakeupForwardTrade','Value true indicates the FXForward trade represents a take-up on the FXFlexiForward' );
end;
/
begin
add_domain_values('systemKeyword','FXFlexiForwardSightBillSpread','The SightBillSpread applied during the take-up on the FXFlexiForward' );
end;
/
begin
add_domain_values('systemKeyword','FXFlexiForwardHRRMargin','The HRR Margin applied during the take-up on the FXFlexiForward' );
end;
/
begin
add_domain_values('tradeKeyword','FXFlexiForwardParentTradeId','Indicates the parent flexi-forward trade id for the take-up FXForward trade' );
end;
/
begin
add_domain_values('tradeKeyword','FXFlexiForwardTakeupForwardTrade','Value true indicates the FXForward trade represents a take-up on the FXFlexiForward' );
end;
/
begin
add_domain_values('tradeKeyword','FXFlexiForwardSightBillSpread','The SightBillSpread applied during the take-up on the FXFlexiForward' );
end;
/
begin
add_domain_values('tradeKeyword','FXFlexiForwardHRRMargin','The HRR Margin applied during the take-up on the FXFlexiForward' );
end;
/
begin
add_domain_values('domainName','InventoryClosurePositions','List of positions to check during closure' );
end;
/
begin
add_domain_values('XferAttributes','NettingRunConfig','' );
end;
/
begin
add_domain_values('workflowRuleTransfer','CheckRecalcNettingRun','' );
end;
/
begin
add_domain_values('workflowRuleTransfer','SetAttributes','' );
end;
/
begin
add_domain_values('scheduledTask','CALIBRATE','Scheduled task to Recalibrate and persist Model Calibratio' );
end;
/
begin
add_domain_values('scheduledTask','EOD_PORTFOLIO_SWAP','Spot PL Sweep' );
end;
/
begin
add_domain_values('userAttributes','FXFlexiForward Default Start Tenor','' );
end;
/
begin
add_domain_values('userAttributes','FXFlexiForward Default End Tenor','' );
end;
/
begin
add_domain_values('userAttributes','FXFlexiForward Default Window Type','' );
end;
/
begin
add_domain_values('userAttributes','FXFlexiForward Default TakeUp Type','' );
end;
/
begin
add_domain_values('userAttributes','FXFlexiForward Default ShortDays Strategy','' );
end;
/
begin
add_domain_values('domainName','FXSwapMarginLookup','FXSwap (or FXNDFSwap) sales margin look-up. Acceptable values: Near, Far, Both.' );
end;
/
begin
add_domain_values('domainName','DisplayFXShortDatedPointsPositiveTime','Indicates if the deal-station should display points for short dated trades in flipped sign. Acceptable values: True, False.' );
end;
/
begin
add_domain_values('accEventType','COT_FX_CCY','' );
end;
/
begin
add_domain_values('accEventType','COT_REV_FX_CCY','' );
end;
/
begin
add_domain_values('accEventType','NOM_CLEAN_FX_CCY','' );
end;
/
begin
add_domain_values('AccountSetup','CHECK_CLOSE_SETTLE_ACCOUNT','false' );
end;
/
begin
add_domain_values('FXFlexiForward.Pricer','PricerFXFlexiForward','' );
end;
/
begin
add_domain_values('CreditDefaultSwap.Pricer','PricerCreditDefaultSwapQuanto','' );
end;
/
begin
add_domain_values('FXOption.Pricer','PricerFXOptionVanillaHeston','Heston model valuation of vanilla options' );
end;
/
begin
add_domain_values('FXOption.Pricer','PricerFXOptionBarrierHestonMC','Heston model valuation of barrier options using Monte Carlo' );
end;
/
begin
add_domain_values('FXOption.Pricer','PricerFXOptionBarrierHestonFD','Heston model valuation of barrier options using Finite Differences' );
end;
/
begin
add_domain_values('FXFlexiForward.subtype','TakeUpSchedule','' );
end;
/
begin
add_domain_values('FXFlexiForward.subtype','MerchantFX','' );
end;
/
begin
add_domain_values('FXFlexiForwardMerchantFX.ExportBillDiscountingRollDays','30','' );
end;
/
begin
add_domain_values('eventFilter','PortfolioSwapEventFilter','filter for Portfolio Swap and Position Engine' );
end;
/
begin
add_domain_values('eventClass','PSEventTriggerTrade','' );
end;
/
begin
add_domain_values('eventClass','PSEventPositionKeepingProcessedTrade','An event to signify the persistence of position-keeping processing information for a trade.' );
end;
/
begin
add_domain_values('eventType','EX_FLEXIFORWARD_LATE_TAKEUP_SUCCESS','The FLEXIFORWARD_LATE_TAKEUP scheduled task was successful.' );
end;
/
begin
add_domain_values('eventType','EX_FLEXIFORWARD_LATE_TAKEUP_FAILURE','The FLEXIFORWARD_LATE_TAKEUP scheduled task was not successful.' );
end;
/
begin
add_domain_values('exceptionType','FLEXIFORWARD_LATE_TAKEUP_SUCCESS','' );
end;
/
begin
add_domain_values('exceptionType','FLEXIFORWARD_LATE_TAKEUP_FAILURE','' );
end;
/
begin
add_domain_values('eventType','EX_MERCHANTFX_ROLLOVER_SUCCESS','The MERCHANTFX_ROLLOVER scheduled task was successful.' );
end;
/
begin
add_domain_values('eventType','EX_MERCHANTFX_ROLLOVER_FAILURE','The MERCHANTFX_ROLLOVER scheduled task was not successful.' );
end;
/
begin
add_domain_values('exceptionType','MERCHANTFX_ROLLOVER_SUCCESS','' );
end;
/
begin
add_domain_values('exceptionType','MERCHANTFX_ROLLOVER_FAILURE','' );
end;
/
begin
add_domain_values('function','CreateAuditFilter','Access permission to create an Audit Filter' );
end;
/
begin
add_domain_values('function','ModifyAuditFilter','Access permission to modify an Audit Filter' );
end;
/
begin
add_domain_values('function','DeleteAuditFilter','Access permission to delete an Audit Filter' );
end;
/
begin
add_domain_values('function','ViewOnlySameGroupAuditEntry','Access permission to restrict ability to view audit value whose modified user belongs to the same group as current user' );
end;
/
begin
add_domain_values('restriction','ViewOnlySameGroupAuditEntry','' );
end;
/
begin
add_domain_values('function','CheckPermForAuthTrade','Access permission to Restrict ability to Authorize trade without permission on action' );
end;
/
begin
add_domain_values('function','ModifyTradeDateTime','Access permission to Restrict ability to Modify trade datetime' );
end;
/
begin
add_domain_values('function','AddModifyLECommonRole','Access permission to Add/Modify Legal Entity common role' );
end;
/
begin
add_domain_values('function','RemoveLECommonRole','Access permission to Remove Legal Entity common role' );
end;
/
begin
add_domain_values('function','AddModifyLEDedicatedRole','Access permission to Add/Modify Legal Entity dedicated role' );
end;
/
begin
add_domain_values('function','RemoveLEDedicatedRole','Access permission to Remove Legal Entity dedicated role' );
end;
/
begin
add_domain_values('restriction','CheckPermForAuthTrade','' );
end;
/
begin
add_domain_values('restriction','ModifyTradeDateTime','' );
end;
/
begin
add_domain_values('marketDataUsage','CLOSING_TRADE','usage type for Repo Underlying Curve Mapping with Cost to Close pricing' );
end;
/
begin
add_domain_values('CLOSING_TRADE.ANY.ANY','CurveRepo','Open CurveRepoSelector for usage CLOSING_TRADE in PricerConfig > Product Specific' );
end;
/
begin
add_domain_values('productType','FXFlexiForward','' );
end;
/
begin
add_domain_values('scheduledTask','FLEXIFORWARD_LATE_TAKEUP','Scheduled Task to update the FlexiForward TakeUp Schedule trades' );
end;
/
begin
add_domain_values('scheduledTask','MERCHANTFX_ROLLOVER','Scheduled Task to rollover the FlexiForward MerchantFX trades' );
end;
/
begin
add_domain_values('yieldMethod','Exponential','' );
end;
/
begin
add_domain_values('productTypeReportStyle','FXFlexiForward','FXFlexiForward ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','FXFlexiForwardTakeUpSchedule','FXFlexiForward ReportStyle for TakeUpSchedule sub-type' );
end;
/
begin
add_domain_values('productTypeReportStyle','FXFlexiForwardMerchantFX','FXFlexiForward ReportStyle for MerchantFX sub-type' );
end;
/
begin
add_domain_values('productTypeReportStyle','PortfolioSwap','' );
end;
/
begin
add_domain_values('bulkEntry.productType','PortfolioSwap','' );
end;
/
begin
add_domain_values('keyword.CATradeBasis','CCPN','Special Ex - Trade was executed cum coupon' );
end;
/
begin
add_domain_values('keyword.CATradeBasis','XCPN','Special Ex - Trade was executed ex coupon' );
end;
/
begin
add_domain_values('keyword.CATradeBasis','CWAR','Special Ex - Trade was executed cum warrants' );
end;
/
begin
add_domain_values('keyword.CATradeBasis','XWAR','Special Ex - Trade was executed ex warrants' );
end;
/
begin
add_domain_values('sdFilterCriterion.Factory','PortfolioSwap','' );
end;
/
begin
add_domain_values('sdFilterCriterion.Factory','FXFlexiForwardTakeUpSchedule','FXFlexiForward TakeUpSchedule Static Data Filter criteria' );
end;
/
begin
add_domain_values('sdFilterCriterion.Factory','FXFlexiForwardMerchantFX','FXFlexiForward MerchantFX Static Data Filter criteria' );
end;
/
begin
add_domain_values('domainName','CommonLERole','' );
end;
/
begin
add_domain_values('CommonLERole','Issuer','' );
end;
/
begin
add_domain_values('CommonLERole','MarketPlace','' );
end;
/
begin
add_domain_values('function','ResetPLConfig','Allow User to delete OfficialPLConfig Marks' );
end;
/
begin
add_domain_values('function','Bulk Import of OfficialPL Marks','Allow User to import OfficialPL Marks' );
end;
/
begin
add_domain_values('function','Generate Conversion Factors','Allow User to generate OfficialPL ConversionFactor Marks' );
end;
/
begin
add_domain_values('workflowRuleTransfer','PropagateLEAttribute','' );
end;
/
begin
add_domain_values('workflowRuleTransfer','PropagateSDIAttribute','' );
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_CCR_EAD' ,'');
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_CCR_PFE','' );
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_CCR_CVA','' );
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_CCR_CVA01' ,'');
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_CCR_CVA_SPREAD','' );
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_CCR_KCVA','' );
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_MR_IR_CAPITAL' ,'');
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_MR_FX_CAPITAL','' );
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_MR_CO_CAPITAL','' );
end;
/
begin
add_domain_values('PricingSheetMeasures','SA_MR_EQ_CAPITAL','' );
end;
/
begin
add_domain_values('domainName','keywords2CopyUponFXFlexiForwardTakeUp','List of Keywords to copy from original FXFlexiForward trade to FXForward trade created upon take-up.' );
end;
/
begin
add_domain_values('keywords2CopyUponFXFlexiForwardTakeUp','TradePlatform','' );
end;
/
begin
add_domain_values('keywords2CopyUponFXFlexiForwardTakeUp','TradeRegion','' );
end;
/
begin
add_domain_values('domainName','keywords2CopyToMerchantFXTakeUpOffset','List of Keywords to copy from original MerchantFX trade to new MerchantFX Offset trade created upon take-up.' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXTakeUpOffset','TradePlatform','' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXTakeUpOffset','TradeRegion','' );
end;
/
begin
add_domain_values('domainName','keywords2CopyToMerchantFXRollover','List of Keywords to copy from original MerchantFX trade to new MerchantFX trade created upon rollover.' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXRollover','TradePlatform','' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXRollover','TradeRegion','' );
end;
/
begin
add_domain_values('domainName','keywords2CopyToMerchantFXRolloverOffset','List of Keywords to copy from original MerchantFX trade to new MerchantFX Offset trade created upon rollover.' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXRolloverOffset','TradePlatform','' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXRolloverOffset','TradeRegion','' );
end;
/
begin
add_domain_values('domainName','keywords2CopyToMerchantFXTerminate','List of Keywords to copy from original MerchantFX trade to new MerchantFX trade created upon termination.' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXTerminate','TradePlatform','' );
end;
/
begin
add_domain_values('keywords2CopyToMerchantFXTerminate','TradeRegion','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','TerminationConfirmationFXO.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','ExerciseConfirmationFXO.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','FXOConfirmation.html','' );
end;
/
begin
add_domain_values('domainName','keepUpFrontFeeType','' );
end;
/
begin
add_domain_values('keepUpFrontFeeType','UPFRONT_FEE','' );
end;
/
begin
add_domain_values('scheduledTask','AM_RISK_ANALYSIS','Snapshot preconfigured analyses for chosen Funds' );
end;
/
begin
add_domain_values('domainName','RatingEquivalenceType','Rating Equivalence type' );
end;
/
begin
add_domain_values('DecSuppOrderStatus','NONE','Order Status' );
end;
/
begin
add_domain_values('DecSuppOrderStatus','SIMULATED','Order Status' );
end;
/
begin
add_domain_values('DecSuppOrderStatus','CANCELED','Order Status' );
end;
/
begin
add_domain_values('DecSuppOrderAction','NEW','Action on order' );
end;
/
begin
add_domain_values('DecSuppOrderAction','SIMULATE','Action on order' );
end;
/
begin
add_domain_values('DecSuppOrderAction','CANCEL','Action on order' );
end;
/
begin
add_domain_values('workflowType','DecSuppOrder','Decision Support Order follows its own workflow' );
end;
/
begin
add_domain_values('lifeCycleEntityType','DecSuppOrder','Decision support order has its own life cycle' );
end;
/
begin
add_domain_values('domainName','DecSuppOrderAction','' );
end;
/
begin
add_domain_values('domainName','workflowRuleDecSuppOrder','' );
end;
/
begin
add_domain_values('domainName','DecSuppOrderStatus','' );
end;
/
begin
add_domain_values('eventType','NEW_DECSUPPORDER','NEW_DECSUPPORDER' );
end;
/
begin
add_column_if_not_exists ('quote_value','price_source_name','varchar2(64) null');
end;
/

UPDATE sd_filter_element
   SET element_name = REPLACE(element_name, 'LEGAL_AGREEMENT.', 'Legal Agreement Additional Field.')
 WHERE element_name like 'LEGAL_AGREEMENT.%'
;

UPDATE sd_filter_domain
   SET element_name = REPLACE(element_name, 'LEGAL_AGREEMENT.', 'Legal Agreement Additional Field.')
 WHERE element_name like 'LEGAL_AGREEMENT.%'
;

begin
add_column_if_not_exists ('product_call_info','expiry_delivery_rollday','number null');
end;
/
begin
add_column_if_not_exists ('product_call_info','expiry_delivery_frequency','varchar2(12) null');
end;
/
begin
add_column_if_not_exists ('product_call_info','expiry_delivery_holidays','varchar2(128) null');
end;
/
begin
add_column_if_not_exists ('product_call_info','expiry_delivery_dateroll','varchar2(18) null');
end;
/

 

merge into product_call_info A
USING product_sec_code B on (A.product_id = B.product_id and A.call_type='Cancellable' and A.exercise_type='Bermudan' and B.sec_code='ExpiryDeliveryRollDay'
)
when matched then
UPDATE SET A.expiry_delivery_rollday = B.code_value
;
merge into product_call_info A
USING product_sec_code B on (A.product_id = B.product_id and A.call_type='Cancellable' and A.exercise_type='Bermudan' 
and B.sec_code='ExpiryDeliveryFrequency')
when matched then
UPDATE SET A.expiry_delivery_frequency= B.code_value
;
merge into product_call_info A
USING product_sec_code B on (A.product_id = B.product_id and A.call_type='Cancellable' and A.exercise_type='Bermudan' 
and B.sec_code='ExpiryDeliveryHolidays')
when matched then
UPDATE SET A.expiry_delivery_holidays= B.code_value
;
merge into product_call_info A
USING product_sec_code B on (A.product_id = B.product_id and A.call_type='Cancellable' and A.exercise_type='Bermudan' 
and B.sec_code='ExpiryDeliveryDateRoll')
when matched then
UPDATE SET A.expiry_delivery_dateroll= B.code_value
;

begin 
add_column_if_not_exists ('curve_commodity_hdr_hist','value_type','varchar2(30) null');
end;
/
update an_param_items /*+ PARALLEL ( an_param_items ) */ set attribute_value = 'Instrument Tenor' where attribute_value = 'Volatility Tenor' 
and param_name in (select param_name from an_param_items where attribute_name='MktType' and attribute_value<>'Volatility')
;

update domain_values 
set value ='AVG_RECOVERY' 
where value='AVG_EXPOSURE' and name in ('CreditDefaultSwap.PricerMeasure', 'CreditDefaultSwapLoan.PricerMeasure', 'CDSIndex.PricerMeasure', 'CDSIndexTranche.PricerMeasure','CDSNthLoss.PricerMeasure','CDSNthDefault.PricerMeasure')
;

begin 
add_column_if_not_exists ('swaption_ext_info','threshold_unit_type','varchar2(32) null');
end;
/
update swaption_ext_info set threshold_unit_type='PERCENT' where threshold_unit_type is null
;

update xccy_swap_ext_info set fx_reset_offset=0, fx_reset_holidays=null, fx_reset_id=0, default_fx_reset_b=1 where fx_reset_b=0
;

UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='004',
        version_date=TO_DATE('29/05/2015','DD/MM/YYYY') 
;