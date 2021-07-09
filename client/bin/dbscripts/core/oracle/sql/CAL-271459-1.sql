alter table sched_task_attr drop primary key
/
begin
add_column_if_not_exists ('sched_task_attr','value_order','numeric DEFAULT 0');
end;
/
update sched_task_attr set value_order=0 where value_order=null
/

ALTER TABLE sched_task_attr ADD CONSTRAINT sct_primarykey PRIMARY KEY ( task_id, attr_name, value_order )
/
 
BEGIN
add_domain_values('userAttributes','Pricing Sheet Default Book','');
END;
/
BEGIN
add_domain_values('userAttributes','Pricing Sheet Pricing Environment','');
END;
/
BEGIN
add_domain_values('userAttributes','Default Ad-Hoc Calculation Server','');
END;
/
BEGIN
add_domain_values('userAttributes','Default Ad-Hoc Presentation Server','');
END;
/
BEGIN
add_domain_values('userAttributes','Default Dispatcher','');
END;
/
BEGIN
add_domain_values('function','ControlPricingSheetMarketData', '');
END;
/
BEGIN
add_domain_values('function','ManagePublicPricingSheets', '');
END;
/
BEGIN
add_domain_values('function','UsePublicPricingSheets', '');
END;
/
BEGIN
add_domain_values('function','AddModifyTSTab', '');
END;
/
BEGIN
add_domain_values('function','ModifyTSCatalogOrdering', '');
END;
/
BEGIN
add_domain_values('function','ModifyTSTabFiltering', '');
END;
/
BEGIN
add_domain_values('function','ModifyTSTabPlan', '');
END;
/
BEGIN
add_domain_values('function','ModifyTaskStationGlobalFilter', '');
END;
/
BEGIN
add_domain_values('function','RemoveTSTab', '');
END;
/
BEGIN
add_domain_values('function','TASK_STATION_SHOW_FILTER', '');
END;
/
BEGIN
add_domain_values('function','ViewOnlyGroupTaskStation', '');
END;
/
BEGIN
add_domain_values('function','ViewOtherTaskStation', '');
END;
/
BEGIN
add_domain_values('function','CreateMktDataServerConfig', '');
END;
/
BEGIN
add_domain_values('function','ModifyMktDataServerConfig', '');
END;
/
BEGIN
add_domain_values('function','RemoveMktDataServerConfig', '');
END;
/
BEGIN
add_domain_values('function','MktDataServerAllowForceGenerate', '');
END;
/
BEGIN
add_domain_values('function','MktDataServerAllowMultiSelection', '');
END;
/
BEGIN
add_domain_values('MirrorKeywords','CurrencyPair', '');
END;
/

/* diff oct 08 */
begin 
add_domain_values( 'scheduledTask', 'CHAIN', '' );
end;
/
begin 
add_domain_values( 'domainName', 'CustomStaticDataFilter', 'Custom Static Data Filter Names' );
END;
/			
BEGIN
add_domain_values('domainName','InventorySecBucketFactory','' );
END;
/
BEGIN
add_domain_values('InventorySecBucketFactory','ProductSubtypePersistent','New position balance types driven by trade subtypes' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureBond','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureCDSIndex','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureCommodity','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureDividend','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureEquity','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureEquityIndex','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureFX','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureMM','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureStructuredFlows','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureSwap','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('PLMktSpread','FutureVolatility','Market spread effect will be computed for this product when explaining P and L' );
END;
/
BEGIN
add_domain_values('workflowRuleTrade','ApplyTradeActionOnTransfers','' );
END;
/
BEGIN
add_domain_values('IncomingSwiftTrade','MT360','' );
END;
/
BEGIN
add_domain_values('IncomingSwiftTrade','MT361','' );
END;
/
BEGIN
add_domain_values('IncomingSwiftTrade','MT362','' );
END;
/
BEGIN
add_domain_values('IncomingSwiftTrade','MT364','' );
END;
/
BEGIN
add_domain_values ('IncomingSwiftTrade','MT365','' );
END;
/
BEGIN
add_domain_values('laAdditionalField','VERSION','Legal Agreement version' );
END;
/
BEGIN
add_domain_values('laAdditionalField','SUBTYPE','Legal Agreement subtype' );
END;
/
BEGIN
add_domain_values('tradeCancelStatus','CANCEL','Default Status for CANCEL trades' );
END;
/
BEGIN
add_domain_values('domainName','OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','Status where the trade is to be excluded from official PL. Should be a subset of domain tradeStatus.' );
END;
/
BEGIN
add_domain_values('OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','PRICING','Trade status to be excluded from official PL' );
END;
/
BEGIN
add_domain_values('OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','HYPO_TRADE','Trade status to be excluded from official PL' );
END;
/
BEGIN
add_domain_values('OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','SALES_TRADE','Trade status to be excluded from official PL' );
END;
/
BEGIN
add_domain_values('domainName','billingStatementFlowType','Types of cash flows' );
END;
/
BEGIN
add_domain_values('domainName','BillingAdjFlowType','Types of cash flows' );
END;
/
BEGIN
add_domain_values('workflowRuleTrade','CloseUnCloseBillingStatement','' );
END;
/
BEGIN
add_domain_values('tradeTmplKeywords','BOND_CLEANPRICE_DISPLAY_FORMAT','keyword to indicate Bond price display format (decimals or quote base)' );
END;
/
BEGIN
add_domain_values('domainName','reportWindowPlugins:tradeBrowser','Trade Browser plugins' );
END;
/
BEGIN
add_domain_values('domainName','CountryPerTimezone','Country Per Timezone' );
END;
/
BEGIN
add_domain_values('CountryPerTimezone','IST','INMU' );
END;
/
BEGIN
add_domain_values('CountryPerTimezone','CST','CNBE' );
END;
/
BEGIN
add_domain_values('domainName','PositionFXExposure.Pricer','Pricer for trades created with PositionFXExposure' );
END;
/
BEGIN
add_domain_values('domainName','tradeRolloverAction','Rollover kind actions' );
END;
/
BEGIN
add_domain_values('tradeRolloverAction','ROLLOVER','' );
END;
/
BEGIN
add_domain_values('tradeRolloverAction','CLOSEANDREOPEN','' );
END;
/
BEGIN
add_domain_values('leAttributeType','ROLLOVER_USE_BUS.DAYS','' );
END;
/
BEGIN
add_domain_values('classAuthMode','StatementConfig','' );
END;
/
BEGIN
add_domain_values('classAuditMode','StatementConfig','' );
END;
/
BEGIN
add_domain_values('PositionBasedProducts','Warrant','Warrant out of box position based product' );
END;
/
BEGIN
add_domain_values('domainName','XferUpdateTransfer','Extra Update Transfer' );
END;
/
BEGIN
add_domain_values('domainName','XferNotCancelableAttribute','List of Attributes Not Cancelable Transfer' );
END;
/
BEGIN
add_domain_values('XferNotCancelableAttribute','StatementTradeId','' );
END;
/
BEGIN
add_domain_values('futureOptUnderType','Equity','' );
END;
/
BEGIN
add_domain_values('ExternalMessageField.MessageMapper','MT360','' );
END;
/
BEGIN
add_domain_values('ExternalMessageField.MessageMapper','MT361','' );
END;
/
BEGIN
add_domain_values('ExternalMessageField.MessageMapper','MT362','' );
END;
/
BEGIN
add_domain_values('ExternalMessageField.MessageMapper','MT364','' );
END;
/
BEGIN
add_domain_values('ExternalMessageField.MessageMapper','MT365','' );
END;
/
BEGIN
add_domain_values('tradeAction','CLOSEANDREOPEN','Rollover without link' );
END;
/
BEGIN
add_domain_values('scheduledTask','EOD_TD_WAC','' );
END;
/
BEGIN
add_domain_values('scheduledTask','EOD_OFFICIALPL','End of day OfficialPLAnalysis Marking.' );
END;
/
BEGIN
add_domain_values('scheduledTask','OFFICIALPLBOOTSTRAP','BootStrap process marking.' );
END;
/
BEGIN
add_domain_values('scheduledTask','OFFICIALPLCORRECTIONS','OfficialPLAnalysis Marking Corrections.' );
END;
/
BEGIN
add_domain_values('scheduledTask','OFFICIALPLPURGEMARKS','OfficialPLAnalysis Purge Marks.' );
END;
/
BEGIN
add_domain_values('scheduledTask','OFFICIALPLEXPORT','OfficialPLAnalysis Export Report.' );
END;
/
BEGIN
add_domain_values('scheduledTask','PL_GREEKS_INPUT','Scheduled task to create greeks for Live PL.' );
END;
/
BEGIN
add_domain_values('MESSAGE.Templates','BillingStatement.txt','' );
END;
/
BEGIN
add_domain_values('tradeStatus','CLOSED','' );
END;
/
BEGIN
add_domain_values('workflowRuleTrade','CheckPLUnitValidation','' );
END;
/
BEGIN
add_domain_values('riskAnalysis','OfficialPL','' );
END;
/
BEGIN
add_domain_values('reportWindowPlugins:tradeBrowser','SecFinanceTradeReportExtension','' );
END;
/
BEGIN
add_domain_values('MESSAGE.Templates','structuredflows.html','' );
END;
/
BEGIN
add_domain_values('riskPresenter','OfficialPL','OfficialPL Analysis' );
END;
/
BEGIN
add_domain_values('productTypeReportStyle','BillingStatement','' );
END;
/
BEGIN
add_domain_values('productTypeReportStyle','FXForward','FXForward ReportStyle' );
END;
/
BEGIN
add_domain_values('bulkEntry.productType','Repo','allow bulk and quick entry of standard Menoy Fill Repo' );
END;
/
BEGIN
add_domain_values('XferAttributesForMatching','BusinessReason','' );
END;
/
BEGIN
add_domain_values('tradeKeyword','ADR Fee','' );
END;
/
BEGIN
add_domain_values('tradeKeyword','ADR Currency','' );
END;
/
BEGIN
add_domain_values('tradeKeyword','ReversedAllocationTrade','Indicates the triparty trade being reversed' );
END;
/
BEGIN
add_domain_values('tradeKeyword','FromTripartyAllocation','Keyword created by the triparty allocation process' );
END;
/
BEGIN
add_domain_values('function','CreateModifyPLMethodologyConfig','Allow User to view any PLMethodologyConfig' );
END;
/
BEGIN
add_domain_values('function','ViewPLMethodologyConfig','Allow User to Add/Modify/delete PLMethodologyConfig' );
END;
/
BEGIN
add_domain_values('function','CreateModifyOfficialPLConfig','Allow User to Add/Modify/delete OfficialPLConfig' );
END;
/
BEGIN
add_domain_values('function','ViewOfficialPLConfig','Allow User to view any OfficialPLConfig' );
END;
/
BEGIN
add_domain_values('function','RemoveResetPLConfig','Allow User to delete OfficialPLConfig Marks' );
END;
/
BEGIN
add_domain_values('function','ViewResetPLConfig','Allow User to view ResetPLConfig' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_MTM_PnL','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_Accrual_PnL','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_Accretion_PnL','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_Other_PnL','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_MTM_PnL','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_Accrual_PnL','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_Other_PnL','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_MTM_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_Accrual_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_Accretion_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Unrealized_Other_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_MTM_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_Accrual_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_Accretion_PnL_Base','' );
END;
/
BEGIN
add_domain_values('plMeasure','Realized_Other_PnL_Base','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedMTM','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedAccrual','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedAccretion','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','UnrealizedOther','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','RealizedMTM','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','RealizedAccrual','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','RealizedAccretion','' );
END;
/
BEGIN
add_domain_values('PricerMeasurePnlAllEOD','RealizedOther','' );
END;
/
BEGIN
add_domain_values('domainName','bookAttribute.PositionRolloverBy','' );
END;
/
BEGIN
add_domain_values('bookAttribute.PositionRolloverBy','Currency','' );
END;
/
BEGIN
add_domain_values('bookAttribute.PositionRolloverBy','CurrencyPair','' );
END;
/
BEGIN
add_domain_values('domainName','MTMFeeType','' );
END;
/
BEGIN
add_domain_values('domainName','AccretionFeeType','' );
END;
/
BEGIN
add_domain_values('domainName','ExcludePnLFeeType','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','BRK','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','TERM_FEE_MTM','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','CDX_FEE_MTM','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','EXERCISE_FEE','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','PLTRANSFER_CLOSE','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','PLTRANSFER_OPEN','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','PL_TRANSFER','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','PREMIUM','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','REBATE','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','TERMINATION_FEE','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','CDX_FEE_ACCRD','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','TERM_FEE_ACCRD','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','REDEMPTION_FEE','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','CREDIT_DFLT_AMT','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','UPFRONT_FEE','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','CAPITALGAIN-TERM','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','FINANCING-TERM','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','DIV-TERM','' );
END;
/
BEGIN
add_domain_values('MTMFeeType','INTEREST-TERM','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','CLOSING_BALANCE','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','ADJUSTMENT_FEE','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','FXOPT_MARGIN','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','CASH_ADJUSTMENT','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','OPENING_BALANCE','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','MARKET_VALUE','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','FAR_MARGIN','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','SPOT_MARGIN','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','DE_DESIGNATION','' );
END;
/
BEGIN
add_domain_values('ExcludePnLFeeType','CA_SALES_MARGIN','' );
END;
/
BEGIN
add_domain_values('domainName','EuclidFeeIndicators','Define the list of Euroclear Fees Indicators (e.g. E7)' );
END;
/
BEGIN
add_domain_values('EuclidFeeIndicators','E6','Euroclear Fee Indicator' );
END;
/
BEGIN
add_domain_values('EuclidFeeIndicators','E7','Euroclear Fee Indicator' );
END;
/
BEGIN
add_domain_values('CustomStaticDataFilter','XProd','To activate SD Filter for XProd product extensions' );
END;
/
BEGIN 
add_domain_values('PositionBasedProducts','FutureSwap', 'FutureSwap out of box position based product'); 
END; 
/

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='008',
        version_date=TO_DATE('10/10/2014','DD/MM/YYYY') 
