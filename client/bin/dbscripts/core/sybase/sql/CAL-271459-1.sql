 
drop_pk_if_exists 'sched_task_attr'
go

add_column_if_not_exists 'sched_task_attr','value_order', 'numeric DEFAULT 0'
go

update sched_task_attr set value_order=0 where value_order=null
go
ALTER TABLE sched_task_attr ADD CONSTRAINT sct_primarykey PRIMARY KEY CLUSTERED ( task_id, attr_name, value_order ) 
go
add_domain_values 'userAttributes','Pricing Sheet Default Book',''
go
add_domain_values 'userAttributes','Pricing Sheet Pricing Environment',''
go
add_domain_values 'userAttributes','Default Ad-Hoc Calculation Server',''
go
add_domain_values 'userAttributes','Default Ad-Hoc Presentation Server',''
go
add_domain_values 'userAttributes','Default Dispatcher',''
go
add_domain_values 'function','ControlPricingSheetMarketData', ''
go
add_domain_values 'function','ManagePublicPricingSheets', ''
go
add_domain_values 'function','UsePublicPricingSheets', ''
go
add_domain_values 'function','AddModifyTSTab', ''
go
add_domain_values 'function','ModifyTSCatalogOrdering', ''
go
add_domain_values 'function','ModifyTSTabFiltering', ''
go
add_domain_values 'function','ModifyTSTabPlan', ''
go
add_domain_values 'function','ModifyTaskStationGlobalFilter', ''
go
add_domain_values 'function','RemoveTSTab', ''
go
add_domain_values 'function','TASK_STATION_SHOW_FILTER', ''
go
add_domain_values 'function','ViewOnlyGroupTaskStation', ''
go
add_domain_values 'function','ViewOtherTaskStation', ''
go
add_domain_values 'function','CreateMktDataServerConfig', ''
go
add_domain_values 'function','ModifyMktDataServerConfig', ''
go
add_domain_values 'function','RemoveMktDataServerConfig', ''
go
add_domain_values 'function','MktDataServerAllowForceGenerate', ''
go
add_domain_values 'function','MktDataServerAllowMultiSelection', ''
go

/* diff oct 08 */


add_domain_values 'MirrorKeywords','CurrencyPair', ''
go
add_domain_values  'domainName', 'CustomStaticDataFilter', 'Custom Static Data Filter Names'  
go
add_domain_values 'domainName','InventorySecBucketFactory',''  
go
add_domain_values 'InventorySecBucketFactory','ProductSubtypePersistent','New position balance types driven by trade subtypes'  
go
add_domain_values 'PLMktSpread','FutureBond','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureCDSIndex','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureCommodity','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureDividend','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureEquity','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureEquityIndex','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureFX','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureMM','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureStructuredFlows','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureSwap','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'PLMktSpread','FutureVolatility','Market spread effect will be computed for this product when explaining P and L'  
go
add_domain_values 'workflowRuleTrade','ApplyTradeActionOnTransfers',''  
go
add_domain_values 'IncomingSwiftTrade','MT360',''  
go
add_domain_values 'IncomingSwiftTrade','MT361',''  
go
add_domain_values 'IncomingSwiftTrade','MT362',''  
go
add_domain_values 'IncomingSwiftTrade','MT364',''  
go
add_domain_values  'IncomingSwiftTrade','MT365',''  
go
add_domain_values 'laAdditionalField','VERSION','Legal Agreement version'  
go
add_domain_values 'laAdditionalField','SUBTYPE','Legal Agreement subtype'  
go
add_domain_values 'tradeCancelStatus','CANCEL','Default Status for CANCEL trades'  
go
add_domain_values 'domainName','OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','Status where the trade is to be excluded from official PL. Should be a subset of domain tradeStatus.'  
go
add_domain_values 'OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','PRICING','Trade status to be excluded from official PL'  
go
add_domain_values 'OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','HYPO_TRADE','Trade status to be excluded from official PL'  
go
add_domain_values 'OFFICIAL_PL_NONEXECUTED_TRADE_STATUS','SALES_TRADE','Trade status to be excluded from official PL'  
go
add_domain_values 'domainName','billingStatementFlowType','Types of cash flows'  
go
add_domain_values 'domainName','BillingAdjFlowType','Types of cash flows'  
go
add_domain_values 'workflowRuleTrade','CloseUnCloseBillingStatement',''  
go
add_domain_values 'tradeTmplKeywords','BOND_CLEANPRICE_DISPLAY_FORMAT','keyword to indicate Bond price display format (decimals or quote base '  
go
add_domain_values 'domainName','reportWindowPlugins:tradeBrowser','Trade Browser plugins'  
go
add_domain_values 'domainName','CountryPerTimezone','Country Per Timezone'  
go
add_domain_values 'CountryPerTimezone','IST','INMU'  
go
add_domain_values 'CountryPerTimezone','CST','CNBE'  
go
add_domain_values 'domainName','PositionFXExposure.Pricer','Pricer for trades created with PositionFXExposure'  
go
add_domain_values 'domainName','tradeRolloverAction','Rollover kind actions'  
go
add_domain_values 'tradeRolloverAction','ROLLOVER',''  
go
add_domain_values 'tradeRolloverAction','CLOSEANDREOPEN',''  
go
add_domain_values 'leAttributeType','ROLLOVER_USE_BUS.DAYS',''  
go
add_domain_values 'classAuthMode','StatementConfig',''  
go
add_domain_values 'classAuditMode','StatementConfig',''  
go
add_domain_values 'PositionBasedProducts','Warrant','Warrant out of box position based product'  
go
add_domain_values 'domainName','XferUpdateTransfer','Extra Update Transfer'  
go
add_domain_values 'domainName','XferNotCancelableAttribute','List of Attributes Not Cancelable Transfer'  
go
add_domain_values 'XferNotCancelableAttribute','StatementTradeId',''  
go
add_domain_values 'futureOptUnderType','Equity',''  
go
add_domain_values 'ExternalMessageField.MessageMapper','MT360',''  
go
add_domain_values 'ExternalMessageField.MessageMapper','MT361',''  
go
add_domain_values 'ExternalMessageField.MessageMapper','MT362',''  
go
add_domain_values 'ExternalMessageField.MessageMapper','MT364',''  
go
add_domain_values 'ExternalMessageField.MessageMapper','MT365',''  
go
add_domain_values 'tradeAction','CLOSEANDREOPEN','Rollover without link'  
go
add_domain_values 'scheduledTask','EOD_TD_WAC',''  
go
add_domain_values 'scheduledTask','EOD_OFFICIALPL','End of day OfficialPLAnalysis Marking.'  
go
add_domain_values 'scheduledTask','OFFICIALPLBOOTSTRAP','BootStrap process marking.'  
go
add_domain_values 'scheduledTask','OFFICIALPLCORRECTIONS','OfficialPLAnalysis Marking Corrections.'  
go
add_domain_values 'scheduledTask','OFFICIALPLPURGEMARKS','OfficialPLAnalysis Purge Marks.'  
go
add_domain_values 'scheduledTask','OFFICIALPLEXPORT','OfficialPLAnalysis Export Report.'  
go
add_domain_values 'scheduledTask','PL_GREEKS_INPUT','Scheduled task to create greeks for Live PL.'  
go
add_domain_values 'MESSAGE.Templates','BillingStatement.txt',''  
go
add_domain_values 'tradeStatus','CLOSED',''  
go
add_domain_values 'workflowRuleTrade','CheckPLUnitValidation',''  
go
add_domain_values 'riskAnalysis','OfficialPL',''  
go
add_domain_values 'reportWindowPlugins:tradeBrowser','SecFinanceTradeReportExtension',''  
go
add_domain_values 'MESSAGE.Templates','structuredflows.html',''  
go
add_domain_values 'riskPresenter','OfficialPL','OfficialPL Analysis'  
go
add_domain_values 'productTypeReportStyle','BillingStatement',''  
go
add_domain_values 'productTypeReportStyle','FXForward','FXForward ReportStyle'  
go
add_domain_values 'bulkEntry.productType','Repo','allow bulk and quick entry of standard Menoy Fill Repo'  
go
add_domain_values 'XferAttributesForMatching','BusinessReason',''  
go
add_domain_values 'tradeKeyword','ADR Fee',''  
go
add_domain_values 'tradeKeyword','ADR Currency',''  
go
add_domain_values 'tradeKeyword','ReversedAllocationTrade','Indicates the triparty trade being reversed'  
go
add_domain_values 'tradeKeyword','FromTripartyAllocation','Keyword created by the triparty allocation process'  
go
add_domain_values 'function','CreateModifyPLMethodologyConfig','Allow User to view any PLMethodologyConfig'  
go
add_domain_values 'function','ViewPLMethodologyConfig','Allow User to Add/Modify/delete PLMethodologyConfig'  
go
add_domain_values 'function','CreateModifyOfficialPLConfig','Allow User to Add/Modify/delete OfficialPLConfig'  
go
add_domain_values 'function','ViewOfficialPLConfig','Allow User to view any OfficialPLConfig'  
go
add_domain_values 'function','RemoveResetPLConfig','Allow User to delete OfficialPLConfig Marks'  
go
add_domain_values 'function','ViewResetPLConfig','Allow User to view ResetPLConfig'  
go
add_domain_values 'plMeasure','Unrealized_MTM_PnL',''  
go
add_domain_values 'plMeasure','Unrealized_Accrual_PnL',''  
go
add_domain_values 'plMeasure','Unrealized_Accretion_PnL',''  
go
add_domain_values 'plMeasure','Unrealized_Other_PnL',''  
go
add_domain_values 'plMeasure','Realized_MTM_PnL',''  
go
add_domain_values 'plMeasure','Realized_Accrual_PnL',''  
go
add_domain_values 'plMeasure','Realized_Other_PnL',''  
go
add_domain_values 'plMeasure','Unrealized_PnL_Base',''  
go
add_domain_values 'plMeasure','Realized_PnL_Base',''  
go
add_domain_values 'plMeasure','Unrealized_MTM_PnL_Base',''  
go
add_domain_values 'plMeasure','Unrealized_Accrual_PnL_Base',''  
go
add_domain_values 'plMeasure','Unrealized_Accretion_PnL_Base',''  
go
add_domain_values 'plMeasure','Unrealized_Other_PnL_Base',''  
go
add_domain_values 'plMeasure','Realized_MTM_PnL_Base',''  
go
add_domain_values 'plMeasure','Realized_Accrual_PnL_Base',''  
go
add_domain_values 'plMeasure','Realized_Accretion_PnL_Base',''  
go
add_domain_values 'plMeasure','Realized_Other_PnL_Base',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','UnrealizedMTM',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','UnrealizedAccrual',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','UnrealizedAccretion',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','UnrealizedOther',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','RealizedMTM',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','RealizedAccrual',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','RealizedAccretion',''  
go
add_domain_values 'PricerMeasurePnlAllEOD','RealizedOther',''  
go
add_domain_values 'domainName','bookAttribute.PositionRolloverBy',''  
go
add_domain_values 'bookAttribute.PositionRolloverBy','Currency',''  
go
add_domain_values 'bookAttribute.PositionRolloverBy','CurrencyPair',''  
go
add_domain_values 'domainName','MTMFeeType',''  
go
add_domain_values 'domainName','AccretionFeeType',''  
go
add_domain_values 'domainName','ExcludePnLFeeType',''  
go
add_domain_values 'MTMFeeType','BRK',''  
go
add_domain_values 'MTMFeeType','TERM_FEE_MTM',''  
go
add_domain_values 'MTMFeeType','CDX_FEE_MTM',''  
go
add_domain_values 'MTMFeeType','EXERCISE_FEE',''  
go
add_domain_values 'MTMFeeType','PLTRANSFER_CLOSE',''  
go
add_domain_values 'MTMFeeType','PLTRANSFER_OPEN',''  
go
add_domain_values 'MTMFeeType','PL_TRANSFER',''  
go
add_domain_values 'MTMFeeType','PREMIUM',''  
go
add_domain_values 'MTMFeeType','REBATE',''  
go
add_domain_values 'MTMFeeType','TERMINATION_FEE',''  
go
add_domain_values 'MTMFeeType','CDX_FEE_ACCRD',''  
go
add_domain_values 'MTMFeeType','TERM_FEE_ACCRD',''  
go
add_domain_values 'MTMFeeType','REDEMPTION_FEE',''  
go
add_domain_values 'MTMFeeType','CREDIT_DFLT_AMT',''  
go
add_domain_values 'MTMFeeType','UPFRONT_FEE',''  
go
add_domain_values 'MTMFeeType','CAPITALGAIN-TERM',''  
go
add_domain_values 'MTMFeeType','FINANCING-TERM',''  
go
add_domain_values 'MTMFeeType','DIV-TERM',''  
go
add_domain_values 'MTMFeeType','INTEREST-TERM',''  
go
add_domain_values 'ExcludePnLFeeType','CLOSING_BALANCE',''  
go
add_domain_values 'ExcludePnLFeeType','ADJUSTMENT_FEE',''  
go
add_domain_values 'ExcludePnLFeeType','FXOPT_MARGIN',''  
go
add_domain_values 'ExcludePnLFeeType','CASH_ADJUSTMENT',''  
go
add_domain_values 'ExcludePnLFeeType','OPENING_BALANCE',''  
go
add_domain_values 'ExcludePnLFeeType','MARKET_VALUE',''  
go
add_domain_values 'ExcludePnLFeeType','FAR_MARGIN',''  
go
add_domain_values 'ExcludePnLFeeType','SPOT_MARGIN',''  
go
add_domain_values 'ExcludePnLFeeType','DE_DESIGNATION',''  
go
add_domain_values 'ExcludePnLFeeType','CA_SALES_MARGIN',''  
go
add_domain_values 'domainName','EuclidFeeIndicators','Define the list of Euroclear Fees Indicators (e.g. E7)'  
go
add_domain_values 'EuclidFeeIndicators','E6','Euroclear Fee Indicator'  
go
add_domain_values 'EuclidFeeIndicators','E7','Euroclear Fee Indicator'  
go
add_domain_values 'CustomStaticDataFilter','XProd','To activate SD Filter for XProd product extensions'  
go
add_domain_values 'PositionBasedProducts','FutureSwap','FutureSwap out of box position based product' 
go 
UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='008',
        version_date='20141010'
go 
