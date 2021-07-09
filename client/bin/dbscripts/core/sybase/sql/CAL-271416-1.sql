 

/* CAL-70752 */
update vol_surface
set vol_surf_generator = 'Default'
where vol_surface.vol_surf_generator  ='OFMCalibrationSimple'
or vol_surface.vol_surf_generator = 'OFMDefault'
or vol_surface.vol_surf_generator = 'OFMSimple'
or vol_surface.vol_surf_generator = 'SABRDirectBpVols'

go

/* Update volsurfaces using deprecated generators to use the Swaption generator. */
update vol_surface
set vol_surf_generator = 'Swaption'
where vol_surface.vol_surf_generator  ='OFMCalibration'
or vol_surface.vol_surf_generator = 'OFMCapsSwaptions'
or vol_surface.vol_surf_generator = 'OFMSwaptions'

go


/* Update curves using deprecated generators to use the BootStrap generator.*/
update curve
set curve_generator = 'BootStrap'
where curve_generator = 'BootStrapSimple'

go

/* Update correlation matrices using deprecated generators to use a null generator. */

update correlation_matrix
set generator_name = null
where (generator_name = 'MFMDefault'
or generator_name = 'Rebonato')

go

/* Remove references to the deprecated correlation matrix generators.*/
delete from domain_values 
where name = 'CovarianceMatrix.gen' 
and (value = 'MFMDefault' or value = 'Rebonato')

go

/*Remove references to the deprecated simple volsurface generators.*/
delete from domain_values
where name = 'VolSurface.genSimple'
and (value = 'OFMSimple' or value = 'OFMCalibrationSimple' or value = 'OFMDefault' or value = 'OFMSimple')

go

/*Remove references to the deprecated volsurface generators.*/
delete from domain_values
where name = 'volSurfaceGenerator'
and (value = 'OFMCalibration' or value = 'OFMCapsSwaptions' or value = 'OFMSwaptions')

go
update pc_pricer set product_pricer = 'PricerSingleSwapLegHagan' where product_pricer = 'PricerSingleSwapLegExotic'
go

delete from domain_values where name = 'SingleSwapLeg.Pricer' and value = 'PricerSingleSwapLegExotic'

go

update pc_pricer set product_pricer = 'PricerCapFloortionLGMM' where product_pricer = 'PricerGenericOption'

go

delete from domain_values where name = 'GenericOption.Pricer' and value = 'PricerGenericOption'

go

delete from pc_pricer where product_pricer = 'PricerGmc'
go

delete from domain_values where name = 'SingleSwapLeg.Pricer' and value = 'PricerGmc'

go

update pc_pricer set product_pricer = 'PricerCapFloor' where product_pricer = 'PricerCMSCapFloor'

go

delete from domain_values where name = 'CapFloor.Pricer' and value = 'PricerCMSCapFloor'

go

update pc_pricer set product_pricer = 'PricerSwap' where product_pricer = 'PricerCMSSwap'

go

delete from domain_values where name = 'Swap.Pricer' and value = 'PricerCMSSwap'

go

update pc_pricer set product_pricer = 'PricerLGMM1FForward' where product_pricer = 'PricerBondTarnLGMM'

go

delete from domain_values where name = 'Bond.Pricer' and value = 'PricerBondTarnLGMM'

go

delete from pc_pricer where product_pricer = 'PricerLGM'

go

delete from domain_values where value = 'PricerLGM'

go

delete from pc_pricer where product_pricer = 'PricerLGMM2F'

go

delete from domain_values where value = 'PricerLGMM2F'

go

delete from pc_pricer where product_pricer = 'PricerSwapMultiFactorModelIRFX'

go

delete from domain_values where name = 'Swap.Pricer' and value = 'PricerSwapMultiFactorModelIRFX'

go

update pc_pricer set product_pricer = 'PricerLGMM1FBackward' where product_pricer = 'PricerSwapOneFactorModel'

go

delete from domain_values where name = 'Swap.Pricer' and value = 'PricerSwapOneFactorModel'

go

update pc_pricer set product_pricer = 'PricerLGMM1FBackward' where product_pricer = 'PricerSwaptionOneFactorModel'

go

delete from domain_values where name = 'Swaption.Pricer' and value = 'PricerSwaptionOneFactorModel'

go

update pc_pricer set product_pricer = 'PricerCancellableSwap' where product_pricer = 'PricerCancSwapOneFactorModel'

go

delete from domain_values where name = 'CancellableSwap.Pricer' and value = 'PricerCancSwapOneFactorModel'
go

update pc_pricer set product_pricer = 'PricerExtendibleSwap' where product_pricer = 'PricerExtSwapOneFactorModel'

go

delete from domain_values where name = 'ExtendibleSwap' and value = 'PricerExtSwapOneFactorModel'

go

update pc_pricer set product_pricer = 'PricerLGMM1FForward' where product_pricer = 'PricerCapFloorMultiFactorModel'

go

delete from domain_values where name = 'CapFloor.Pricer' and value = 'PricerCapFloorMultiFactorModel'

go

update pc_pricer set product_pricer = 'PricerLGMM1FForward' where product_pricer = 'PricerSwapMultiFactorModel'

go

delete from domain_values where name = 'Swap.Pricer' and value = 'PricerSwapMultiFactorModel'

go

update pc_pricer set product_pricer = 'PricerLGMM1FForward' where product_pricer = 'PricerSwaptionMultiFactorModel'

go

delete from domain_values where name = 'Swaption.Pricer' and value = 'PricerSwaptionMultiFactorModel'

go

update pc_pricer set product_pricer = 'PricerSpreadCapFloorGBM2FHagan' where product_pricer = 'PricerSpreadCapFloor'

go

delete from domain_values where name= 'SpreadCapFloor.Pricer' and value = 'PricerSpreadCapFloor'

go

update pc_pricer set product_pricer = 'PricerCapFloor' where product_pricer = 'PricerCapFloorExotic'

go

delete from domain_values where name = 'CapFloor.Pricer' and value = 'PricerCapFloorExotic'

go

update pc_pricer set product_pricer = 'PricerCommoditySwap2' where product_pricer = 'PricerCommoditySwap'

go

delete from domain_values where name ='CommoditySwap.Pricer' and value = 'PricerCommoditySwap'

go

update pc_pricer set product_pricer='PricerCommodityOTCOption2'
where product_pricer='PricerOTCCommoditySwap'
go

delete from domain_values where name ='CommoditySwap.Pricer' and value ='PricerOTCCommoditySwap'
go
/* end */

/* CAL-70526 */

sp_rename 'calypso_tree_node.node_class_name', 'node_type'
go
update calypso_tree_node set node_type='Folder' where node_type like '%FolderView'
go
update calypso_tree_node set node_type='RiskAggregation' where node_type like '%CalypsoTreeViewRiskAggregationNode'
go
update calypso_tree_node set node_type='Visokio' where node_type like '%CalypsoTreeViewVisokioNode'
go
update calypso_tree_node set node_type='Workspace' where node_type like '%CalypsoTreeViewWorkspaceNode'
go

/* end */

/* CAL-73255 */
delete from pc_pricer where pricer_config_name='default' and product_type like 'EquityStructuredOption%'
go
/* end */

/* CAL-69135 */ 

if exists (select 1 from sysobjects where type='SF' and name='custom_rule_discriminator')
begin
exec('drop function custom_rule_discriminator')
end
go

CREATE FUNCTION custom_rule_discriminator(@name VARCHAR(255))
RETURNS VARCHAR(255)
AS
if(patindex('%MessageRule%', @name) != 0)
BEGIN
RETURN 'MessageRule'
END
if(patindex('%TradeRule%', @name) != 0)
BEGIN
RETURN 'TradeRule'
END
if(patindex('%TransferRule%', @name) != 0)
BEGIN
RETURN 'TransferRule'
END
if(patindex('%WorkFlowRule%', @name) != 0)
BEGIN
RETURN 'WorkFlowRule'
END
RETURN 'error'
go
/* end */ 
/*  CAL-64259 */

/* For CashSettleDefaultsAgreements */
add_domain_values 'CashSettleDefaultsAgreements','ANY','Default Agreement' 
go

add_column_if_not_exists 'cash_settle_dflt','agreement', 'varchar(255) default ''NONE'' not null'
go

update cash_settle_dflt set agreement = 'ANY' where agreement = NULL
go

/* BermudanTradeDate to be added in leAttributeType domain */

add_domain_values 'leAttributeType','BermudanTradeDate','' 
go 

/* end */
/*-------------------------------------------------------------------*/
/*It's been discovered that the added column is_compounding          */
/*in flow_cmp_period needs to be filled according to the setting of  */
/*compounding on the leg. If it remains empty although the leg is    */
/*compounding the swap pricer does not calculate an NPV on that leg. */
/*Hence the following update stmt is suggested:                      */
/*-------------------------------------------------------------------*/

add_column_if_not_exists 'flow_cmp_period' ,'is_compounding','numeric default 1 not null'
go
 
update flow_cmp_period set is_compounding = 1 where product_id in (select distinct t.product_id from trade t, swap_leg s, flow_cmp_period f (parallel 5)
where s.product_id = t.product_id and s.compound_b = 1 and f.product_id = t.product_id)
go

/* CAL-75942 */

IF EXISTS (SELECT 1 FROM syscolumns WHERE id = object_id('product_els') AND name LIKE 'align_pay_dates_b')
begin
exec sp_rename 'product_els.align_pay_dates_b', 'date_calc_method'
end
go

/* end */

/* CAL-77413 */
DELETE  FROM report_panel_def where win_def_id IN (SELECT win_def_id FROM report_win_def (parallel 5) WHERE  def_name='TransferViewerWindow')
go
DELETE FROM report_win_def  WHERE  def_name='TransferViewerWindow'
go

/* end */
/* CAL-54713 : insert Trade panel in TransferViewerWindow so that the netted trade of a SimpleNetting transfer can be displayed */
insert into report_panel_def values (-1,-1,'Trade','Trade',null,null)
go
update report_panel_def set
panel_index=(select max(panel_index)+1 from report_panel_def (parallel 5) where win_def_id=(select win_def_id from report_win_def (parallel 5) where def_name='TransferViewerWindow')),
win_def_id=(select win_def_id from  report_win_def where def_name='TransferViewerWindow')
where exists (select 1 from report_panel_def (parallel 5)  where panel_name != 'Trade' and win_def_id=(select win_def_id from report_win_def (parallel 5) where def_name='TransferViewerWindow'))
and not exists (select 1 from report_panel_def (parallel 5)  where panel_name = 'Trade' and win_def_id=(select win_def_id from report_win_def (parallel 5) where def_name='TransferViewerWindow'))
and win_def_id=-1
go
delete report_panel_def where win_def_id=-1
go
/* End CAL-54713 */

/* CAL-76250 */
add_column_if_not_exists 'pos_info','cash_date_type','numeric default 0 null'
go
update pos_info set cash_date_type=date_type
go
sp_rename 'pos_info.date_type', 'product_date_type'
go
/* end */ 

/* CAL-76249 */
add_column_if_not_exists 'position_spec','cash_date_type','numeric default 1 not null'
go
update position_spec set cash_date_type=0
go
sp_rename 'position_spec.use_trade_date_b' , 'product_date_type'
go
/* end */ 

/* CAL-75935 */

delete from domain_values where name = 'CommodityResetCode' and value in ('COMMODITY_REFERENCE_PRICE', 'COMMODITY_PRICING_DATES')
go
/* end   */

/* CAL-77252 */

update commodity_leg2 
set leg.strike_price_unit = r.quote_unit,
leg.strike_price = leg.spread,
leg.spread = 0 from commodity_reset r, commodity_leg2 leg 
where leg.comm_reset_id = r.comm_reset_id 
and leg.leg_type = 2 
and leg.strike_price_unit is null
go

/* CAL-74583 */
if exists (select 1 from sysobjects where name='analysis_col_metadata')
begin
exec('DROP TABLE analysis_col_metadata')
end
go

if exists (select 1 from sysobjects where name='analysis_message')
begin
exec ('DROP TABLE analysis_message')
end
go

if exists (select 1 from sysobjects where name='analysis_metadata')
begin
exec ('DROP TABLE analysis_metadata')
end
go

/*end*/
/* CAL-77888 */

add_column_if_not_exists 'prod_comm_fwd','comm_reset_id', 'numeric null'
go

add_column_if_not_exists 'commodity_leg2', 'comm_reset_id', 'numeric null'
go

add_column_if_not_exists 'prod_comm_fwd','comm_leg_id','numeric null'
go

update prod_comm_fwd
set p.comm_reset_id = l.comm_reset_id
from prod_comm_fwd p,
commodity_leg2 l
where p.comm_leg_id = l.leg_id
and l.comm_reset_id > 0
and (p.comm_reset_id is null or p.comm_reset_id = 0)
go

/* end */

UPDATE an_viewer_config SET viewer_class_name = 'apps.risk.JumpToDefaultReportFrameworkViewer' where analysis_name = 'JumpToDefault'
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES ( 8241, 'FX_RATE_RESET' )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'NAV', 'apps.risk.NAVAnalysisReportFrameworkViewer', 0 )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1504, 'UnexerciseOption' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1505, 'UnexerciseOption' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1506, 'UnexerciseOption' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1507, 'UnexerciseOption' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1509, 'UnexerciseOption' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1514, 'CheckSDI' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1515, 'CheckSDI' )
go
INSERT INTO calypso_seed ( last_id, seed_name ) VALUES ( 1000, 'process' )
go
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'curve_spread_header', 'curve_spread_hdr_hist', 0 )
go
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'trade_price', 'trade_price_hist', 0 )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'curve', 'curve_spread_header', 'curve_id,curve_date', 'curve_id,curve_date', 'Curve', 'Yield Spread Curve' )
go
add_domain_values 'productTypeReportStyle', 'FutureCommodity', 'FutureCommodity ReportStyle'  
go
add_domain_values 'productType', 'PLSweep', 'PLSweep'  
go
add_domain_values 'domainName', 'TradeKeywordCopier', 'Specify the Trade Keyword Copiers'  
go
add_domain_values 'disableReportTableFiltering', 'AccountMapping', ''  
go
add_domain_values 'domainName', 'AccountMappingAttributes', 'Specify the attributes for the Account Mapping'  
go
add_domain_values 'AccountMappingAttributes', 'CashStatement.TransferType', 'Transfer Type for the Simple Transfer'  
go
add_domain_values 'AccountMappingAttributes', 'MappingType', 'Mapping Type for same account mapping'  
go
add_domain_values 'domainName', 'ActionNotAmendBundle', 'Trade action that doesn''t update Bundle' 
go
add_domain_values 'domainName', 'ignoreTradeStatus', 'Status where the trade should be ignored for a given process'  
go
add_domain_values 'domainName', 'CommodityResetCode', 'Commodity reset code'  
go
add_domain_values 'CommodityResetCode', 'REFERENCE_PRICE', ''  
go
add_domain_values  'MsgAttributes.CashStatementProcess', 'SubStatement.GuaranteeFees', ''  
go
add_domain_values  'domainName', 'MessageViewer.MsgAttributes.DateAttributesToKeep', ''  
go
add_domain_values  'MessageViewer.MsgAttributes.DateAttributesToKeep', 'AckDatetime', ''  
go
add_domain_values  'keyword.CashStatementProcess', 'Automatic Guarantee Fees', ''  
go
add_domain_values  'keyword.CashStatementProcess', 'Manual CashSweeping', ''  
go
add_domain_values  'keyword.CashStatementProcess', ' NotSet', ''  
go
add_domain_values  'tradeKeyword', 'Booking Date', ''  
go
add_domain_values  'tradeKeyword', 'Booking Date (To)', ''  
go
add_domain_values  'tradeKeyword', 'BO Validation Date', ''  
go
add_domain_values  'systemKeyword', 'BO Validation Date', ''  
go
add_domain_values  'tradeKeyword', 'ImportedTrade', ''  
go
add_domain_values  'tradeTmplKeywords', 'QuantityUnit', 'keyword to indicate quantity units on the trade'  
go
add_domain_values  'leAttributeType', 'Tax Rate', '' 
go
add_domain_values  'function', 'AddModifyAccountMapping',''
go
add_domain_values  'function', 'RemoveAccountMapping',''
go
add_domain_values  'function', 'AddCashSettleDefault', 'AccessPermission for ability to add cash settle default'  
go
add_domain_values  'function', 'AmendCashSettleDefault', 'AccessPermission for ability to ammend cash settle default'  
go
add_domain_values  'function', 'RemoveCashSettleDefault', 'AccessPermission for ability to remove cash settle default'  
go
add_domain_values  'settlementType', 'AUCTION',''
go
add_domain_values  'classAuditMode', 'AccountMapping',''
go
add_domain_values  'domainName', 'EquityForward.Pricer', 'Pricer equityForward'  
go
add_domain_values  'domainName', 'UnavailabilityTransfer.Pricer', 'Pricers for UnavailabilityTransfer products'  
go
add_domain_values  'CurveZero.gen', 'BootStrapISDA', 'Simplified bootstrap used with ISDA standard CDS pricing'  
go
add_domain_values  'REPORT.Types', 'AccountMapping', 'AccountMapping Report'  
go
add_domain_values  'REPORT.Types', 'ReportStatus', 'ReportStatus Report'  
go
add_domain_values  'domainName', 'tradeUpsizeAction', 'AMEND Action applied on Existing Trade in case of EquityLinkedSwap NotionalIncrease' 
go
add_domain_values  'tradeUpsizeAction', 'AMEND', 'AMEND Action applied on Existing Trade in case of EquityLinkedSwap NotionalIncrease' 
go
add_domain_values  'domainName', 'tradeUnterminateAction', 'default is UNTERMINATE - used by CorporateActionHandler' 
go
add_domain_values  'domainName', 'hedgeRelationshipAttributes', 'hedgeRelationshipAttributes' 
go
add_domain_values  'hedgeStrategyAttributes', 'FairValueMeasure', 'Default Pricer Measure used in hedge accounting for fair value measurement' 
go
add_domain_values  'hedgeStrategyAttributes', 'FairValueMeasure.Swap', 'Default Pricer Measure used in hedge accounting for fair value measurement, when product is a swap' 
go
add_domain_values  'hedgeStrategyAttributes.Check List Template', 'HedgeDocumentationCheckList', 'The default check list template' 
go
add_domain_values  'hedgeStrategyAttributes', 'POSTINGS_ONLY_IF_COMPLIANT', 'POSTINGS_ONLY_IF_COMPLIANT' 
go
add_domain_values  'hedgeRelationshipAttributes', 'HedgeEffectivenessDocumentationReview', 'HedgeEffectivenessDocumentationReview' 
go
add_domain_values  'hedgeRelationshipAttributes', 'INEFFECTIVE_COMPLIANCE	', 'INEFFECTIVE_COMPLIANCE' 
go
add_domain_values  'domainName', 'EquityForward.subtype', 'EquityForward subtypes' 
go
add_domain_values  'domainName', 'MarginCall.DisputeRaison', 'Dispute Reasons of Margin Call' 
go
add_domain_values  'domainName', 'MarginCall.DisputeStatus', 'Dispute Status of Margin Call' 
go
add_domain_values  'classAuthMode', 'ReportBrowserConfig',''
go
add_domain_values  'classAuthMode', 'AccountInterestConfigRange',''
go
add_domain_values  'domainName', 'AccountProcessStatusCheck', 'List of ProcessStatusCheck for Accounts' 
go
add_domain_values  'AccountProcessStatusCheck', 'SubsidiaryAccount', 'check for Subsidiray Accounts' 
go
add_domain_values  'PositionBasedProducts', 'PLSweep',''
go
add_domain_values  'XferAttributes', 'isForecastSubstituted',''
go
add_domain_values  'systemKeyword', 'SimpleNetting',''
go
add_domain_values  'creditMktDataUsage.YIELD', 'CurveYield',''
go
add_domain_values  'systemKeyword', 'TerminationPayIntFlow',''
go
add_domain_values  'domainName', 'creditMktDataUsage.YIELD',''
go
add_domain_values  'scheduledTask', 'EOD_CAPLMARKING', 'End of day CAPL Marking.' 
go
add_domain_values  'scheduledTask', 'EOD_CAPLSWEEP', 'End of day scheduled task for CAPL Sweep' 
go
add_domain_values  'MESSAGE.Templates', 'SubsidiaryICStatementBookingDate.html',''
go
add_domain_values  'EquityStructuredOption.extendedType', 'Quanto', 'when option is quanto' 
go
add_domain_values  'EquityStructuredOption.extendedType', 'Compo', 'when option is compo' 
go
add_domain_values  'productType', 'EquityForward', 'EquityForward' 
go
add_domain_values  'workflowRuleTrade', 'SetBOValidationDate',''
go
add_domain_values  'domainName', 'EntitlementCheckFeed', 'Market feed name requiring entitlement check' 
go
add_domain_values  'domainName', 'CappedSwap.MDataSelector.StrikeRange', 'Cap and Floor levels for LPI pricing'  
go
add_domain_values  'CappedSwap.MDataSelector.StrikeRange', '0 to 2.5',''
go
add_domain_values  'CappedSwap.MDataSelector.StrikeRange', '0 to 3',''
go
add_domain_values  'CappedSwap.MDataSelector.StrikeRange', '3 to 5',''
go
add_domain_values  'CappedSwap.MDataSelector.StrikeRange', '0 to 5',''
go
add_domain_values  'CappedSwap.MDataSelector.StrikeRange', '0 to Infinity',''
go
add_domain_values  'workflowRuleMessage', 'UpdateTransfer',''
go
add_domain_values  'accEventType', 'BD_CST_S_SETTLED',''
go
add_domain_values  'domainName', 'accountProperty.PaymentFactory',''
go
add_domain_values  'accountProperty.PaymentFactory', 'False',''
go
add_domain_values  'accountProperty.PaymentFactory', 'True',''
go
add_domain_values  'accountProperty', 'GuaranteeFees', 'Boolean representing if account is a GuaranteeFees Account'  
go
add_domain_values  'domainName', 'accountProperty.GuaranteeFees',''
go
add_domain_values  'accountProperty.GuaranteeFees', 'False',''
go
add_domain_values  'accountProperty.GuaranteeFees', 'True',''
go
add_domain_values  'domainName', 'creditEventLookBackTenor',''
go
add_domain_values  'creditEventLookBackTenor', '2M',''
go
add_domain_values  'domainName', 'creditEventLookForwardTenor',''
go
add_domain_values  'creditEventLookForwardTenor', '2W',''
go
add_domain_values  'UnavailabilityTransfer.Pricer', 'PricerUnavailabilityTransfer',''
go
add_domain_values  'OTCEquityOption.Pricer', 'PricerBlack1FAnalyticDiscreteVanilla',''
go
add_domain_values  'Cash.subtype', 'Discount',''
go
add_domain_values  'SimpleMM.subtype', 'Discount',''
go
add_domain_values  'eventClass', 'PSEventFXRateReset',''
go
add_domain_values  'eventFilter', 'IgnoreTradesEventFilter', 'Ignore Trade which status is in the ''ignoreTradeStatus'' domain'  
go
add_domain_values  'eventFilter', 'BillingTradeMessageEventFilter', 'Filter to Exclude PSEventMessage events that are related to BillingTrades (that is; trades whose product is of type Billing)' 
go
add_domain_values  'eventFilter', 'BillingTradeTaskEventFilter', 'Filter to Exclude PSEventTask events that are related to BillingTrades (that is; trades whose product is of type Billing)' 
go
add_domain_values  'eventFilter', 'BillingTradeTradeEventFilter', 'Filter to Exclude PSEventTrade events that are related to BillingTrades (that is; trades whose product is of type Billing)' 
go
add_domain_values  'eventFilter', 'BillingTradeTransferEventFilter', 'Filter to Exclude PSEventTransfer events that are related to BillingTrades (that is; trades whose product is of type Billing)' 
go
add_domain_values  'eventType', 'EX_TRADE_AUTH',''
go
add_domain_values  'eventType', 'EX_FX_RATE_RESET',''
go
add_domain_values  'eventType', 'FX_RATE_RESET',''
go
add_domain_values  'exceptionType', 'TRADE_AUTH',''
go
add_domain_values  'exceptionType', 'CLAIM_RATE_MISSING',''
go
add_domain_values  'flowType', 'CASHSWEEPING',''
go
add_domain_values  'flowType', 'GUARANTEEFEES',''
go
add_domain_values  'function', 'CreateModifySalesB2BRoutingRule', 'Permission to Save SalesB2B Routing Rule' 
go
add_domain_values  'function', 'CreateModifyXccySplitRoutingRule', 'Permission to Save Xccy Split Routing Rule' 
go
add_domain_values  'function', 'CreateModifyXccySpotMismatchRoutingRule', 'Permission to Save Xccy Spotmismatch Routing Rule' 
go
add_domain_values  'function', 'CreateModifySpotRiskTransferRoutingRule', 'Permission to Save Spot Risk Transfer Routing Rule' 
go
add_domain_values  'function', 'CreateModifyFwdRiskTransferRoutingRule', 'Permission to Save Fwd Risk Transfer Routing Rule' 
go
add_domain_values  'function', 'CreateModifyBookSubstitutionRoutingRule', 'Permission to Save Book Substitution Routing Rule' 
go
add_domain_values  'function', 'RemoveSalesB2BRoutingRule', 'Permission to Remove SalesB2B Routing Rule' 
go
add_domain_values  'function', 'RemoveXccySplitRoutingRule', 'Permission to Remove Xccy Split Routing Rule' 
go
add_domain_values  'function', 'RemoveXccySpotMismatchRoutingRule', 'Permission to Remove Xccy Spotmismatch Routing Rule' 
go
add_domain_values  'function', 'RemoveSpotRiskTransferRoutingRule', 'Permission to Remove Spot Risk Transfer Routing Rule' 
go
add_domain_values  'function', 'RemoveFwdRiskTransferRoutingRule', 'Permission to Remove Fwd Risk Transfer Routing Rule' 
go
add_domain_values  'function', 'RemoveBookSubstitutionRoutingRule', 'Permission to Remove Book Substitution Routing Rule' 
go
add_domain_values 'billingCalculators', 'BillingCostOfLateSettlementCalculator' ,''
go
add_domain_values  'function', 'AddModifyIndividualAccountInterestRanges', 'Access permission to Add or Modify an Account Interest Config Range for a Specified account' 
go
add_domain_values  'function', 'SubmitAccountInterestUpdate', 'Access permission to Sumbit an Account Interest Update' 
go
add_domain_values  'function', 'ValidateAccountInterestUpdate', 'Access permission to Validate an Account Interest Update' 
go
add_domain_values  'marketDataType', 'CurveYield',''
go
add_domain_values  'productFamily', 'UnavailabilityTransfer',''
go
add_domain_values  'productType', 'UnavailabilityTransfer',''
go
add_domain_values  'riskAnalysis', 'InvestmentPerformance', 'Investment Performance Analysis' 
go
add_domain_values  'riskAnalysis', 'NAV', 'Net Asset Value Analysis' 
go
add_domain_values  'scheduledTask', 'CHECK_INC_STATEMENT',''
go
add_domain_values  'scheduledTask', 'FXOPTION_RATE_RESET', 'FX Option rate reset'  
go
add_domain_values  'tradeKeyword', 'ExercisedUnderSubID',''
go
add_domain_values  'tradeKeyword', 'ExercisedOptionSubID',''
go
add_domain_values  'MESSAGE.Templates', 'commodities.html',''
go
add_domain_values  'MESSAGE.Templates', 'commodities_cover.html',''
go
add_domain_values  'MESSAGE.Templates', 'EquityForwardConfirmation.html',''
go
add_domain_values  'InventoryPositions', 'CLIENT-ACTUAL-BOOKING',''
go
add_domain_values  'InventoryPositions', 'INTERNAL-ACTUAL-BOOKING',''
go
add_domain_values  'productTypeReportStyle', 'PreciousMetalDepositLease', 'PreciousMetalDepositLease ReportStyle'  
go
add_domain_values  'productTypeReportStyle', 'EquityForward', 'EquityForward ReportStyle' 
go
add_domain_values  'CommodityType', 'Emission', 'Commodities that are emissions related'  
go
add_domain_values  'bulkEntry.productType', 'Commodity',''
go
add_domain_values  'bulkEntry.productType', 'Equity',''
go
add_domain_values  'bulkEntry.productType', 'EquityStructuredOption', 'allow bulk and quick entry of vanilla equity option' 
go
add_domain_values  'function', 'PublishFeedQuotes', 'Access to view and publish quotes in Feed window' 
go
add_domain_values  'function', 'ViewFeedQuoteWindow', 'Access to view quotes in Feed window' 
go
add_domain_values  'CostingEvents', 'Trade', 'PSEventTrade occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' 
go
add_domain_values  'CostingEvents', 'Transfer', 'PSEventTransfer occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' 
go
add_domain_values  'CostingEvents', 'Message', 'PSEventMessage occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' 
go
add_domain_values  'CostingEvents', 'Task', 'PSEventTask occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' 
go
add_domain_values  'CostingEvents', 'AccountBilling', 'PSEventAccountBilling occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' 
go
add_domain_values  'domainName', 'CommodityCalcPeriod', 'conditional swap template keywords value' 
go
add_domain_values  'CommodityCalcPeriod', 'Bullet', 'The Effective Date.' 
go
add_domain_values  'CommodityCalcPeriod', 'Future Contract FND Payment Frequency', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month' 
go
add_domain_values  'CommodityCalcPeriod', 'Future Contract LTD Payment Frequency', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month' 
go
add_domain_values  'CommodityCalcPeriod', 'PeriodicWK', 'Each Calendar Week from and including the effective date to and including the Termination Date, including the first and last calendar days of each week.' 
go
add_domain_values  'CommodityCalcPeriod', 'PeriodicMTH', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' 
go
add_domain_values  'CommodityCalcPeriod', 'PeriodicQTR', 'Each Calendar Quarter from and including the effective date to and including the Termination Date, including the first and last calendar days of each quarter.' 
go
add_domain_values  'CommodityCalcPeriod', 'PeriodicIRConventionWK', 'Each Weekly Period from and including the effective date to and including the Termination Date, including the first and last calendar days of each week.' 
go
add_domain_values  'CommodityCalcPeriod', 'PeriodicIRConventionMTH', 'Each Monthly Period from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' 
go
add_domain_values  'CommodityCalcPeriod', 'PeriodicIRConventionQTR', 'Each Quarterly Period from and including the effective date to and including the Termination Date, including the first and last calendar days of each quarter.' 
go
add_domain_values  'CommodityCalcPeriod', 'ThirdWednesdayMTH', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' 
go
add_domain_values  'CommodityCalcPeriod', 'Whole', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' 
go
add_domain_values  'domainName', 'CommodityPricingDates', 'conditional template keywords value' 
go
add_domain_values  'CommodityPricingDates', 'BulletBullet', 'The Commodity Business Day equal to the Effective Date of the relevant calculatoin period' 
go
add_domain_values  'CommodityPricingDates', 'Future Contract FND Payment FrequencyContract Last Day', 'In respect of each Calculation Period, the Commodity Business Day which corresponds to the Notification Date of the relevant Futures Contract' 
go
add_domain_values  'CommodityPricingDates', 'Future Contract FND Payment FrequencyPenultimate', 'In respect of each Calculation Period, the Commodity Business Day immediately preceeding the Commodity Business Day which corresponds to the Notification Date of the relevant Futures Contract' 
go
add_domain_values  'CommodityPricingDates', 'Future Contract FND Payment FrequencyLast Three Days', 'In respect of each Calculation Period, the last three Commodity Business Days immediately preceeding and including the Notification Date of the relevant Futures Contract' 
go
add_domain_values  'CommodityPricingDates', 'Future Contract LTD Payment FrequencyContract Last Day', 'The last Commodity Business Day on which the relevant Futures Contract is scheduled to trade on the Exchange' 
go
add_domain_values  'CommodityPricingDates', 'Future Contract LTD Payment FrequencyPenultimate', 'In respect of each Calculation Period, the Commodity Business Day immediately preceeding the last Commodity Business Day on which the relevant Futures Contract is scheduled to trade on the Exchange' 
go
add_domain_values  'CommodityPricingDates', 'Future Contract LTD Payment FrequencyLast Three Days', 'In respect of each Calculation Period, the last three Commodity Business Days on which the relevant Futures Contract is scheduled to trade on the Exchange' 
go
add_domain_values  'CommodityPricingDates', 'PeriodicFirst Day', 'The first Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' 
go
add_domain_values  'CommodityPricingDates', 'PeriodicLast Day', 'The last Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' 
go
add_domain_values  'CommodityPricingDates', 'PeriodicWhole Period', 'Every Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' 
go
add_domain_values  'CommodityPricingDates', 'PeriodicIRConventionFirst Day', 'The first Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' 
go
add_domain_values  'CommodityPricingDates', 'PeriodicIRConvention LastDay', 'The last Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' 
go
add_domain_values  'CommodityPricingDates', 'PeriodicIRConventionWhole Period', 'Every Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' 
go
add_domain_values  'CommodityPricingDates', 'ThirdWednesdayThird Wednesday', 'The Commodity Business Day on which the Commodity Reference Price is published which precedes the Third Wednesday of the relevant calculation period' 
go
add_domain_values  'CommodityPricingDates', 'WholeFirst Day', 'The first Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' 
go
add_domain_values  'CommodityPricingDates', 'WholeLast Day', 'The last Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period'
go
add_domain_values  'CommodityPricingDates', 'WholeWhole Period', 'Every Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' 
go
add_domain_values  'domainName', 'EmissionAllowanceType', 'Emissions allowance types' 
go
add_domain_values  'domainName', 'CommodityResetType', 'Commodity reset defintion types' 
go
add_domain_values  'CommodityResetType', 'Emission', 'Emission based commodity reset type' 
go
add_domain_values  'domainName', 'EmissionComplianceType', 'Emission fungibility criteria type' 
go
add_domain_values  'EmissionComplianceType', 'Perpetual', 'Compliant with commodities with perpetual vintages' 
go
add_domain_values  'EmissionComplianceType', 'Range', 'compliant with commodities within a vintage range' 
go
add_domain_values  'EmissionComplianceType', 'Specific', 'Compliant with commodities with a specific vintage' 
go
add_domain_values  'EmissionComplianceType', 'UpperBound', 'Complaint with commodity that are before a specified vintage. Also known as "In compliance with"' 
go
add_domain_values  'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticVanilla', 'analytic Pricer for single equity vanilla option - using Black Scholes Merton model - can do forward start' 
go
add_domain_values  'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticDiscreteVanilla', 'analytic Pricer for single equity vanilla option - using Forward based Black Scholes Merton model - can do discrete dividends' 
go
add_domain_values  'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticCompo', 'analytic Pricer for single equity vanilla compo option - using Black Scholes Merton model'  
go
add_domain_values  'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticQuanto', 'analytic Pricer for single equity vanilla quanto option - using Black Scholes Merton model'  
go
add_domain_values  'EquityStructuredOption.Pricer', 'PricerBlack1FBinomialVanilla', 'binomial Pricer for single equity american vanilla option - use constant rates/vols - can do forward start price' 
go
add_domain_values  'plMeasure', 'Settlement_Date_PnL',''
go
add_domain_values  'plMeasure', 'Settlement_Date_PnL_Base',''
go
add_domain_values  'plMeasure', 'Intraday_Unrealized_Full_PnL',''
go
add_domain_values  'plMeasure', 'Trade_Cash_FX_Reval',''
go
add_domain_values  'plMeasure', 'Trade_Translation_PnL',''
go
add_domain_values  'plMeasure', 'Trade_Full_Base_PnL',''
go
add_domain_values  'plMeasure', 'Sweep_PnL',''
go
add_domain_values  'tradeKeyword', 'SuccessionEventIds',''
go
add_domain_values  'domainName', 'successionEventType', 'Succession Event Types' 
go
add_domain_values  'successionEventType', 'Merger',''
go
add_domain_values  'successionEventType', 'Split',''
go
add_domain_values  'successionEventType', 'Name Change',''
go
add_domain_values  'function', 'UsePublicPricingSheets', 'Permits Access to Pricing Sheets in the Public folder' 
go
add_domain_values  'function', 'ManagePublicPricingSheets', 'Permits Access to Pricing Sheets in the Public folder, regardless of user' 
go
add_domain_values  'function', 'PricingSheetAccessBackOffice', 'Permits Access to backoffice menu' 
go
add_domain_values  'function', 'PricingSheetConfigAccess', 'Permits Access to pricing sheet configuration' 
go
add_domain_values  'function', 'ControlPricingSheetMarketData', 'Permits Access to modify Pricing Env and Market Data in Pricing Sheets' 
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'UnavailabilityTransfer.ANY.ANY', 'PricerUnavailabilityTransfer' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'OTCEquityOption.ANY.European', 'PricerBlack1FAnalyticDiscreteVanilla' )
go
delete from pc_pricer where pricer_config_name='default' and product_type= 'EquityStructuredOption.ANY.European' and product_pricer='PricerBlack1FAnalyticVanilla' 
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.European', 'PricerBlack1FAnalyticVanilla' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.European', 'PricerBlackNFJuAnalyticVanilla' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.ANY', 'PricerBlackNFMonteCarlo' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Compo.European', 'PricerBlack1FAnalyticCompo' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Quanto.European', 'PricerBlack1FAnalyticQuanto' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.American', 'PricerBlack1FBinomialVanilla' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.BARRIER', 'PricerBlack1FAnalyticBarrier' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.DIGITAL', 'PricerBlack1FAnalyticDigital' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.ASIAN', 'PricerBlack1FMonteCarlo' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.LOOKBACK', 'PricerBlack1FMonteCarlo' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CLIQUET', 'PricerBlack1FMonteCarlo' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.COMPOUND', 'PricerBlack1FSemiAnalyticCompound' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CHOOSER', 'PricerBlack1FSemiAnalyticChooser' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'GenericOption.ANY.ANY', 'PricerCapFloortionLGMM' )
go
delete from pricer_measure where measure_name='UNREALIZED_CASH' and measure_class_name= 'tk.core.PricerMeasure' and measure_id=391
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'UNREALIZED_CASH', 'tk.core.PricerMeasure', 391 )
go
delete from pricer_measure where measure_name='HISTO_UNREALIZED_CASH' and measure_class_name= 'tk.core.PricerMeasure'  and measure_id=392
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_UNREALIZED_CASH', 'tk.core.PricerMeasure', 392 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURR_EFF_ATT', 'tk.core.PricerMeasure', 393 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURR_EFF_DET', 'tk.core.PricerMeasure', 394 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'UNSETTLED_REALIZED', 'tk.core.PricerMeasure', 395 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SETTLED_REALIZED', 'tk.core.PricerMeasure', 396 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_SETTLED_REALIZED', 'tk.core.PricerMeasure', 397 )
go
delete from pricer_measure where measure_name='THETA_PCT' and measure_class_name= 'tk.core.PricerMeasure' and measure_id=398
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'THETA_PCT', 'tk.core.PricerMeasure', 398 )
go
delete from pricer_measure where measure_name='VEGA_PCT' and measure_class_name= 'tk.core.PricerMeasure' and measure_id=399
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'VEGA_PCT', 'tk.core.PricerMeasure', 399 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MARKET_VALUE', 'tk.core.PricerMeasure', 400 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'EXPLODE_PV_QUOTE_CCY', 'tk.core.PricerMeasure', 401, 'The present value of just the cashflows that pay in the quoting currency' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'EXPLODE_PV_PRIM_CCY', 'tk.core.PricerMeasure', 402, 'The present value of just the cashflows that pay in the primary currency' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DEFAULT_COMP', 'tk.core.PricerMeasure', 403 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DEFAULT_ACCRUAL', 'tk.core.PricerMeasure', 404 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'NPV_INCLUDE_EXDIV_COUPON', 'java.lang.Boolean', 'true,false', 'Include Coupon if Exdiv before Spot in NPV', 1, 'true' )
go
delete from pricing_param_name where param_name='INTERPOLATE_ON_STUBS'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'INTERPOLATE_ON_STUBS', 'java.lang.Boolean', 'true,false', 'Flag controls whether or not the pricer makes any attempt to interpolate when there are stubs', 1, 'INTERPOLATE_ON_STUBS', 'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_CALIBRATE_TO_OTM_OPTIONS', 'java.lang.Boolean', 'true,false', 'Flag controls whether the calibration always uses OTM options.', 0, 'CALIBRATE_TO_OTM_OPTIONS', 'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'PREM_DISC_YIELD_RATE', 'java.lang.String', 'EFFECTIVE,DEFAULT', 'Yield Method to use in computing PREM_DISC_YIELD and NPV_DISC measures.', 1, 'DEFAULT' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'DIVIDEND_MODEL', 'java.lang.String', 'Continuous,Escrowed', 'Dividend pricing model choice', 1, 'Escrowed' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, default_value ) VALUES ( 'NUMERIC_RHO_SHIFT', 'java.lang.Double', 'numerical rho shift (typically 1% or 1bps)', 1, '0.01' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, default_value ) VALUES ( 'NUMERIC_RHO2_SHIFT', 'java.lang.Double', 'numerical rho2 shift (typically 10% or 1%). For discrete dividends, it represents the unknown dividend shift', 1, '0.01' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'NPV_DISC_LINEAR', 'java.lang.Boolean', 'true,false', 'Amortize Prem/Disc on a linear basis', 1, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'INCLUDE_FEES_BY_CCY', 'java.lang.Boolean', 'true,false', 'Include fees to swapleg based on currency', 1, 'false' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'AccountingEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'MessageEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'TransferEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'DiaryEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'PositionEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'CreEngine' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ( 'Back-Office', 'TransferEngine', 'IgnoreTradesEventFilter' )
go
add_column_if_not_exists 'wfw_transition', 'needs_man_auth_b', 'numeric  default 0 not null'
go

INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1502, 'PSEventTrade', 'ALLOCATED', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1504, 'PSEventTrade', 'EXERCISED', 'UNEXERCISE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Exercise action needs to be undone - it was applied by mistake.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1506, 'PSEventTrade', 'EXPIRED', 'UNEXPIRE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade undo expiry by Trader.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1512, 'PSEventTrade', 'PENDING', 'ACCEPT_NO_SDI', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is accepted without settlements. SDI will be handled by the settlements team.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1514, 'PSEventTrade', 'PENDING', 'AUTHORIZE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is authorized manually by Trade Support.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1516, 'PSEventTrade', 'PENDING', 'BO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by Trade Support. This action needs to be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1518, 'PSEventTrade', 'PENDING', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1520, 'PSEventTrade', 'PENDING', 'FO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by FO.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1522, 'PSEventTrade', 'PRICING', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'This is a system action. No user should be allowed access to this action.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1524, 'PSEventTrade', 'PRICING', 'EXECUTE_STP', 'PENDING', 1, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '"Trade is STP. CheckLimitNoExcess rule will need to be added to validate whether the trade satisfies the counterparty and trader limits. ERS system must be implemented for this rule to work."', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1526, 'PSEventTrade', 'PRICING', 'FO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by FO.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1530, 'PSEventTrade', 'VERIFIED', 'ALLOCATE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1532, 'PSEventTrade', 'VERIFIED', 'BOOKTRANSFER', 'TERMINATED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade has been transferred to a different book.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1534, 'PSEventTrade', 'VERIFIED', 'BO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by BO. This action should be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1536, 'PSEventTrade', 'VERIFIED', 'EXERCISE', 'EXERCISED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1538, 'PSEventTrade', 'VERIFIED', 'FO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by FO.', 0, 0, 1, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1540, 'PSEventTrade', 'VERIFIED', 'KNOCK_IN', 'KNOCKED_IN', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1542, 'PSEventTrade', 'VERIFIED', 'MATURE', 'MATURED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1544, 'PSEventTrade', 'VERIFIED', 'ROLLBACK', 'ROLLBACKED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1546, 'PSEventTrade', 'VERIFIED', 'SPLIT', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1501, 'PSEventTrade', 'ALLOCATED', 'ALLOCATE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1503, 'PSEventTrade', 'ALLOCATED', 'UPDATE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1505, 'PSEventTrade', 'EXPIRED', 'UNEXERCISE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1507, 'PSEventTrade', 'KNOCKED_IN', 'UN-KNOCK_IN', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade undo knock in.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1509, 'PSEventTrade', 'KNOCKED_OUT', 'UN-KNOCK_OUT', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade undo knock out.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1511, 'PSEventTrade', 'NONE', 'NEW', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 1, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1513, 'PSEventTrade', 'PENDING', 'AMEND', 'PENDING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1515, 'PSEventTrade', 'PENDING', 'AUTHORIZE_STP', 'VERIFIED', 1, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is STP.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1517, 'PSEventTrade', 'PENDING', 'BO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by Trade Support. This action needs to be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1519, 'PSEventTrade', 'PENDING', 'FO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by FO.', 0, 0, 1, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1521, 'PSEventTrade', 'PRICING', 'AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1523, 'PSEventTrade', 'PRICING', 'EXECUTE', 'PENDING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is executed manually by FO.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1525, 'PSEventTrade', 'PRICING', 'FO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by FO.', 0, 0, 1, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1529, 'PSEventTrade', 'VERIFIED', 'ALLOCATE', 'ALLOCATED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1531, 'PSEventTrade', 'VERIFIED', 'AMEND', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1533, 'PSEventTrade', 'VERIFIED', 'BO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by BO. This action needs to be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1535, 'PSEventTrade', 'VERIFIED', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1537, 'PSEventTrade', 'VERIFIED', 'EXPIRE', 'EXPIRED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is expired.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1539, 'PSEventTrade', 'VERIFIED', 'FO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by FO.', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1541, 'PSEventTrade', 'VERIFIED', 'KNOCK_OUT', 'KNOCKED_OUT', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1543, 'PSEventTrade', 'VERIFIED', 'RENEW', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1545, 'PSEventTrade', 'VERIFIED', 'ROLLOVER', 'ROLLOVERED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1547, 'PSEventTrade', 'VERIFIED', 'TERMINATE', 'TERMINATED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
go
if not exists (select 1 from sysobjects where name='cost_svr_event_type_master')
begin
exec ('create table cost_svr_event_type_master (id numeric not null , classname varchar(255) not null, account_provider_factory_class varchar(255) not null)')
end 
go
delete from cost_svr_event_type_master where id=1 and classname= 'com.calypso.tk.event.PSEventTrade'
go
INSERT INTO cost_svr_event_type_master ( id, classname, account_provider_factory_class ) VALUES ( 1, 'com.calypso.tk.event.PSEventTrade', 'com.calypso.tk.costing.model.billingtrade.providers.account.DefaultAccountProviderFactory' )
go
delete from cost_svr_event_type_master where id=2 and classname= 'com.calypso.tk.event.PSEventTransfer'
go
INSERT INTO cost_svr_event_type_master ( id, classname, account_provider_factory_class ) VALUES ( 2, 'com.calypso.tk.event.PSEventTransfer', 'com.calypso.tk.costing.model.billingtrade.providers.account.DefaultAccountProviderFactory' )
go
delete from cost_svr_event_type_master where id=3 and classname='com.calypso.tk.event.PSEventMessage'
go
INSERT INTO cost_svr_event_type_master ( id, classname, account_provider_factory_class ) VALUES ( 3, 'com.calypso.tk.event.PSEventMessage', 'com.calypso.tk.costing.model.billingtrade.providers.account.DefaultAccountProviderFactory' )
go
delete from cost_svr_event_type_master where id=4 and classname='com.calypso.tk.event.PSEventAccountBilling'
go
INSERT INTO cost_svr_event_type_master ( id, classname, account_provider_factory_class ) VALUES ( 4, 'com.calypso.tk.event.PSEventAccountBilling', 'com.calypso.tk.costing.model.billingtrade.providers.account.EventAccountBillingFactory' )
go
INSERT INTO cost_svr_event_type_master ( id, classname, account_provider_factory_class ) VALUES ( 5, 'com.calypso.tk.event.PSEventTask', 'com.calypso.tk.costing.model.billingtrade.providers.account.DefaultAccountProviderFactory' )
go

if not exists (select 1 from sysobjects where name='cost_svr_predicate_master')
begin
exec ('create table cost_svr_predicate_master (id numeric not null , description varchar(255) not null , factory_classname varchar(255) not null)')
end
go

delete from cost_svr_predicate_master where id=0 
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 0, 'Always True/Satisfied', 'com.calypso.tk.costing.model.predicate.instance.util.PredicateAlwaysTrueFactory' )
go
delete from cost_svr_predicate_master where id=1
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 1, 'Filter on Trade attribute: Trade-Currency', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeCurrencyFactory' )
go
delete from cost_svr_predicate_master where id=3 
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 3, 'Filter on Trade attribute: Trade-Status', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeStatusFactory' )
go
delete from cost_svr_predicate_master where id=4
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 4, 'Filter on the UTC Data-Time at which the event occurred.', 'com.calypso.tk.costing.model.predicate.instance.event.PredicateEventOccurrenceInstantFactory' )
go
delete from cost_svr_predicate_master where id=5
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 5, 'Filter on Trade attribute: Trade-Date', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeDateFactory' )
go
delete from cost_svr_predicate_master where id=6
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 6, 'Filter using a StaticDataFilter against a Trade object instance', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeStaticDataFilterFactory' )
go
delete from cost_svr_predicate_master where id=7
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 7, 'Filter on Processing-Organisation attribute of the Book with which the Trade is associated', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeProcessingOrganisationFactory' )
go
delete from cost_svr_predicate_master where id=8
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 8, 'Filter on Trade attributes(Trade-Role AND Trade-Legal-Entity) submitted to TradeRoleFinder', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeRoleFactory' )
go
delete from cost_svr_predicate_master where id=9
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 9, 'Filter using a StaticDataFilter against a Transfer object instance (and, potentially, its related Trade)', 'com.calypso.tk.costing.model.predicate.instance.transfer.PredicateTransferStaticDataFilterFactory' )
go
delete from cost_svr_predicate_master where id=10
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 10, 'Filter using a StaticDataFilter against a Message object instance (and, potentially, its related Transfer and Trade)', 'com.calypso.tk.costing.model.predicate.instance.message.PredicateMessageStaticDataFilterFactory' )
go
delete from cost_svr_predicate_master where id=11
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 11, 'Filter on Transfer attributes(Transfer-Role AND Transfer-Legal-Entity) submitted to TransferRoleFinder', 'com.calypso.tk.costing.model.predicate.instance.transfer.PredicateTransferRoleFactory' )
go
delete from cost_svr_predicate_master where id=12
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 12, 'Filter on Processing-Organisation attribute of the Book with which the Transfer is associated', 'com.calypso.tk.costing.model.predicate.instance.transfer.PredicateTransferProcessingOrganisationFactory' )
go
delete from cost_svr_predicate_master where id=13
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 13, 'Filter on Transfer attribute: Settlement-Currency', 'com.calypso.tk.costing.model.predicate.instance.transfer.PredicateTransferCurrencyFactory' )
go
delete from cost_svr_predicate_master where id=14
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 14, 'Filter on Trade attribute (being in range): Principal-Amount', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeRangePrincipalPercentFactory' )
go

INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 16, 'Filter on Task attribute: Processing Organisation', 'com.calypso.tk.costing.model.predicate.instance.task.PredicateTaskProcessingOrganisationFactory' )
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 17, 'Filter using a StaticDataFilter against a Task object instance', 'com.calypso.tk.costing.model.predicate.instance.task.PredicateTaskStaticDataFilterFactory' )
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 18, 'Filter on Trade attribute: Workflow-Action [derived from Trade.getAction()]', 'com.calypso.tk.costing.model.predicate.instance.trade.PredicateTradeActionFactory' )
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 19, 'Filter on Transfer attribute: Settlement Amount', 'com.calypso.tk.costing.model.predicate.instance.transfer.PredicateTransferRangeSettlementAmountPercentFactory' )
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 20, 'Filter on Processing-Organisation (Sender / Receiver attribute) of a Message', 'com.calypso.tk.costing.model.predicate.instance.message.PredicateMessageProcessingOrganisationFactory' )
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 21, 'Filter on Message attributes(Trade-Role AND Trade-Legal-Entity) submitted to TradeRoleFinder', 'com.calypso.tk.costing.model.predicate.instance.message.PredicateMessageRoleFactory' )
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 22, 'Filter on ProcessingOrganisation attribute of Account object', 'com.calypso.tk.costing.model.predicate.instance.account.PredicateAccountProcessingOrganisationFactory' )
go
INSERT INTO cost_svr_predicate_master ( id, description, factory_classname ) VALUES ( 23, 'Filter using a StaticDataFilter against an Account object instance', 'com.calypso.tk.costing.model.predicate.instance.account.PredicateAccountStaticDataFilterFactory' )
go
if not exists (select 1 from sysobjects where name='cost_svr_predicate_template')
begin
exec ('create table cost_svr_predicate_template (id numeric not null , predicate_id numeric not null  , predicate_parameter_key varchar(128) not null)')
end
go

delete from cost_svr_predicate_template where id=1
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 1, 1, 'TradeCurrencySet' )
go
delete from cost_svr_predicate_template where id=3
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 3, 3, 'TradeStatusSet' )
go
delete from cost_svr_predicate_template where id=5
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 5, 4, 'TimePeriod.TimeZoneIdentifier' )
go
delete from cost_svr_predicate_template where id=6
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 6, 4, 'TimePeriod.TimeStart.Local.timespec' )
go
delete from cost_svr_predicate_template where id=7
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 7, 4, 'TimePeriod.TimeEnd.Local.timespec' )
go
delete from cost_svr_predicate_template where id=8
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 8, 4, 'TimePeriod.DateRuleNames.Set' )
go
delete from cost_svr_predicate_template where id=9
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 9, 4, 'TimePeriod.HolidayCodes.Set' )
go
delete from cost_svr_predicate_template where id=10
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 10, 4, 'TimePeriod.IncludeHolidays.boolean' )
go
delete from cost_svr_predicate_template where id=11
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 11, 5, 'TimePeriod.TimeZoneIdentifier' )
go
delete from cost_svr_predicate_template where id=12
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 12, 5, 'TimePeriod.TimeStart.Local.timespec' )
go
delete from cost_svr_predicate_template where id=13
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 13, 5, 'TimePeriod.TimeEnd.Local.timespec' )
go
delete from cost_svr_predicate_template where id=14
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 14, 5, 'TimePeriod.DateRuleNames.Set' )
go
delete from cost_svr_predicate_template where id=15
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 15, 5, 'TimePeriod.HolidayCodes.Set' )
go
delete from cost_svr_predicate_template where id=16
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 16, 5, 'TimePeriod.IncludeHolidays.boolean' )
go
delete from cost_svr_predicate_template where id=17
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 17, 6, 'TradeStaticDataFilter' )
go
delete from cost_svr_predicate_template where id=18
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 18, 7, 'TradeProcessingOrganisation' )
go
delete from cost_svr_predicate_template where id=19
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 19, 8, 'TradeRole.Role' )
go
delete from cost_svr_predicate_template where id=20
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 20, 8, 'TradeRole.LegalEntity' )
go
delete from cost_svr_predicate_template where id=21
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 21, 9, 'TransferStaticDataFilter' )
go
delete from cost_svr_predicate_template where id=22
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 22, 10, 'MessageStaticDataFilter' )
go
delete from cost_svr_predicate_template where id=23
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 23, 11, 'TransferRole.Role' )
go
delete from cost_svr_predicate_template where id=24
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 24, 11, 'TransferRole.LegalEntity' )
go
delete from cost_svr_predicate_template where id=25
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 25, 12, 'TransferProcessingOrganisation' )
go
delete from cost_svr_predicate_template where id=26
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 26, 13, 'TransferSettlementCurrencySet' )
go
delete from cost_svr_predicate_template where id=27
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 27, 14, 'Range.Minimum' )
go
delete from cost_svr_predicate_template where id=28
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 28, 14, 'Range.Maximum' )
go
delete from cost_svr_predicate_template where id=29
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 29, 14, 'Range.Percentage' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 30, 16, 'TaskProcessingOrganisation' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 31, 17, 'TaskStaticDataFilter' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 32, 18, 'TradeActionSet' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 33, 19, 'Range.Minimum' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 34, 19, 'Range.Maximum' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 35, 19, 'Range.Percentage' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 36, 20, 'MessageProcessingOrganisation' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 37, 21, 'MessageRole.Role' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 38, 21, 'MessageRole.LegalEntity' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 39, 22, 'AccountProcessingOrganisation' )
go
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 40, 23, 'AccountStaticDataFilter' )
go
if not exists (select 1 from sysobjects where name='cost_svr_event_type_predicate')
begin
exec ('create table cost_svr_event_type_predicate (event_type_id numeric not null, predicate_id int not null)')
end
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=0
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 0 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=1
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 1 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=3
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 3 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=4
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 4 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=5
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 5 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=6
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 6 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=7
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 7 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=8
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 8 )
go
delete from cost_svr_event_type_predicate where event_type_id = 1 and predicate_id=14
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 14 )
go
delete from cost_svr_event_type_predicate where event_type_id = 2 and predicate_id=0
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 0 )
go
delete from cost_svr_event_type_predicate where event_type_id = 2 and predicate_id=4
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 4 )
go
delete from cost_svr_event_type_predicate where event_type_id =2 and predicate_id=9
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 9 )
go
delete from cost_svr_event_type_predicate where event_type_id = 2 and predicate_id=11
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 11 )
go
delete from cost_svr_event_type_predicate where event_type_id = 2 and predicate_id=12
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 12 )
go
delete from cost_svr_event_type_predicate where event_type_id = 2 and predicate_id=13
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 13 )
go
delete from cost_svr_event_type_predicate where event_type_id = 3 and predicate_id=0
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 3, 0 )
go
delete from cost_svr_event_type_predicate where event_type_id = 3 and predicate_id=4
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 3, 4 )
go
delete from cost_svr_event_type_predicate where event_type_id = 3 and predicate_id=10
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 3, 10 )
go

INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 5, 4 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 5, 16 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 5, 17 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 18 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 19 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 3, 20 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 3, 21 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 4, 22 )
go
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 4, 23 )
go
if not exists (select 1 from sysobjects where name='cost_svr_event_type_calc_methd')
begin
exec ('create table cost_svr_event_type_calc_methd (event_type_id numeric not null, calculation_method_id numeric not null )')
end
go
delete from cost_svr_event_type_calc_methd where event_type_id = 1 and calculation_method_id=1
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 1, 1 )
go
delete from cost_svr_event_type_calc_methd where event_type_id = 1 and calculation_method_id=2
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 1, 2 )
go
delete from cost_svr_event_type_calc_methd where event_type_id = 2 and calculation_method_id=1
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 2, 1 )
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 2, 4 )
go
delete from cost_svr_event_type_calc_methd where event_type_id = 3 and calculation_method_id=1
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 3, 1 )
go
delete from cost_svr_event_type_calc_methd where event_type_id = 4 and calculation_method_id=1
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 4, 1 )
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 5, 1 )
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 5, 3 )
go
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 2, 5 )
go
if not exists (select 1 from sysobjects where name='cost_svr_event_type_valn_methd')
begin
exec ('create table cost_svr_event_type_valn_methd (event_type_id numeric not null ,valuation_method_id numeric not null)')
end
go
delete from cost_svr_event_type_valn_methd where event_type_id=1 and valuation_method_id=1
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 1, 1 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=1 and valuation_method_id=2
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 1, 2 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=1 and valuation_method_id=3
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 1, 3 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=1 and valuation_method_id=8
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 1, 8 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=2 and valuation_method_id=1
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 2, 1 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=2 and valuation_method_id=4
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 2, 4 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=2 and valuation_method_id=5
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 2, 5 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=2 and valuation_method_id=8
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 2, 8 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=3 and valuation_method_id=1
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 3, 1 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=3 and valuation_method_id=6
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 3, 6 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=3 and valuation_method_id=7
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 3, 7 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=3 and valuation_method_id=8
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 3, 8 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=4 and valuation_method_id=1
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 4, 1 )
go
delete from cost_svr_event_type_valn_methd where event_type_id=4 and valuation_method_id=8
go
INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 4, 8 )
go

INSERT INTO cost_svr_event_type_valn_methd ( event_type_id, valuation_method_id ) VALUES ( 5, 1 )
go
if not exists (select 1 from sysobjects where name='cost_svr_calc_method_master')
begin
exec ('create table cost_svr_calc_method_master ( id numeric not null , factory_classname varchar(255) not null)')
end
go
delete from cost_svr_calc_method_master where id = 1 and factory_classname= 'com.calypso.tk.costing.model.calculator.method.calculation.instance.util.CalculationMoneyConstantFactory'
go
INSERT INTO cost_svr_calc_method_master ( id, factory_classname ) VALUES ( 1, 'com.calypso.tk.costing.model.calculator.method.calculation.instance.util.CalculationMoneyConstantFactory' )
go
delete from cost_svr_calc_method_master where id = 2 and factory_classname= 'com.calypso.tk.costing.model.calculator.method.calculation.instance.trade.CalculationTradePriceByFixedPercentFactory'
go
INSERT INTO cost_svr_calc_method_master ( id, factory_classname ) VALUES ( 2, 'com.calypso.tk.costing.model.calculator.method.calculation.instance.trade.CalculationTradePriceByFixedPercentFactory' )
go
INSERT INTO cost_svr_calc_method_master ( id, factory_classname ) VALUES ( 3, 'com.calypso.tk.costing.model.calculator.method.calculation.instance.task.CalculationTaskDurationByMoneyConstantFactory' )
go
INSERT INTO cost_svr_calc_method_master ( id, factory_classname ) VALUES ( 4, 'com.calypso.tk.costing.model.calculator.method.calculation.instance.transfer.CalculationTransferSettlementAmountByFixedPercentFactory' )
go
INSERT INTO cost_svr_calc_method_master ( id, factory_classname ) VALUES ( 5, 'com.calypso.tk.costing.model.calculator.method.calculation.instance.transfer.CalculationTransferCostOfLateSettlementFactory' )
go

if not exists (select 1 from sysobjects where name='cost_svr_calc_method_template')
begin
exec ('create table cost_svr_calc_method_template (id numeric not null ,  method_id numeric not null , parameter_key varchar(128) not null)')
end
go
delete from cost_svr_calc_method_template where id = 1 and method_id=1 and parameter_key='MoneyAmountValue'
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 1, 1, 'MoneyAmountValue' )
go
delete from cost_svr_calc_method_template where id = 2 and method_id=1 and parameter_key='MoneyCurrencyCode'
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 2, 1, 'MoneyCurrencyCode' )
go
delete from cost_svr_calc_method_template where id = 3 and method_id=2 and parameter_key='Percentage'
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 3, 2, 'Percentage' )
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 4, 3, 'MoneyAmountValue' )
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 5, 3, 'MoneyCurrencyCode' )
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 6, 4, 'Percentage' )
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 7, 5, 'Currency' )
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 8, 5, 'DayCount' )
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 9, 5, 'Index' )
go
INSERT INTO cost_svr_calc_method_template ( id, method_id, parameter_key ) VALUES ( 10, 5, 'AvgMean' )
go
if not exists (select 1 from sysobjects where name='cost_svr_cval_method_master')
begin
exec ('create table cost_svr_cval_method_master (id numeric not null , factory_classname varchar(255) not null)')
end
go
delete from cost_svr_cval_method_master where id=1
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 1, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.util.ValuationMethodCurrentDateFactory' )
go
delete from cost_svr_cval_method_master where id=2
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 2, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.trade.ValuationMethodTradeTradeDateFactory' )
go
delete from cost_svr_cval_method_master where id=3
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 3, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.trade.ValuationMethodTradeSettleDateFactory' )
go
delete from cost_svr_cval_method_master where id=4
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 4, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.transfer.ValuationMethodTransferSettleDateFactory' )
go
delete from cost_svr_cval_method_master where id=5
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 5, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.transfer.ValuationMethodTransferValueDateFactory' )
go
delete from cost_svr_cval_method_master where id=6
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 6, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.message.ValuationMethodMessageSettleDateFactory' )
go
delete from cost_svr_cval_method_master where id=7
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 7, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.message.ValuationMethodMessageCreationDateFactory' )
go
delete from cost_svr_cval_method_master where id=8
go
INSERT INTO cost_svr_cval_method_master ( id, factory_classname ) VALUES ( 8, 'com.calypso.tk.costing.model.calculator.method.valuation.instance.util.ValuationMethodEventOccurrenceInstantFactory' )
go

if not exists (select 1 from sysobjects where name='cost_svr_billee_spec_master')
begin
exec ('create table cost_svr_billee_spec_master (id numeric not null , factory_classname varchar(255) not null)')
end
go
delete from cost_svr_billee_spec_master where id=1
go
INSERT INTO cost_svr_billee_spec_master ( id, factory_classname ) VALUES ( 1, 'com.calypso.tk.costing.model.billee.instance.trade.TradeBilleeResolutionSpecificationDefaultFactory' )
go
delete from cost_svr_billee_spec_master where id=2
go
INSERT INTO cost_svr_billee_spec_master ( id, factory_classname ) VALUES ( 2, 'com.calypso.tk.costing.model.billee.instance.transfer.TransferBilleeResolutionSpecificationDefaultFactory' )
go
delete from cost_svr_billee_spec_master where id=3
go
INSERT INTO cost_svr_billee_spec_master ( id, factory_classname ) VALUES ( 3, 'com.calypso.tk.costing.model.billee.instance.message.MessageBilleeResolutionSpecificationDefaultFactory' )
go
INSERT INTO cost_svr_billee_spec_master ( id, factory_classname ) VALUES ( 4, 'com.calypso.tk.costing.model.billee.instance.task.TaskBilleeResolutionSpecificationDefaultFactory' )
go
INSERT INTO cost_svr_billee_spec_master ( id, factory_classname ) VALUES ( 5, 'com.calypso.tk.costing.model.billee.instance.account.AccountBilleeResolutionSpecificationDefaultFactory' )
go
if not exists (select 1 from sysobjects where name='cost_app_mapper_calc_method')
begin
exec ('create table cost_app_mapper_calc_method (id numeric not null , client_lookup_key varchar(128) not null , label_display_name varchar(128) not null , classname_panel_renderer varchar(255) not null, classname_panel_parameter_map varchar(255) not null)')
end 
go
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 1, 'ALL_CONSTANT', 'Constant', 'com.calypso.apps.refdata.costing.InputPanelRendererImplMoney', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplMoney' )
go
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 2, 'TRADE_PRICE_PERCENTAGE', 'Trade Principal Percentage', 'com.calypso.apps.refdata.costing.InputPanelRendererImplPercent', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplPercentage' )
go
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 3, 'TASK_DURATION', 'Task Duration (Hours) By Rate', 'com.calypso.apps.refdata.costing.InputPanelRendererImplMoney', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplMoney' )
go
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 4, 'TRANSFER_SETTLEMENT_AMOUNT_PERCENTAGE', 'Transfer Settlement-Amount Percentage', 'com.calypso.apps.refdata.costing.InputPanelRendererImplPercent', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplPercentage' )
go
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 5, 'TRANSFER_COST_OF_LATE_SETTLEMENT', 'Transfer Cost Of Late Settlement', 'com.calypso.apps.refdata.costing.InputPanelRenererImplCostOfLateSettlement', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplCOLSDefault' )
go
delete from an_viewer_config where analysis_name='CrossAssetPL' and viewer_class_name='apps.risk.CrossAssetPLAnalysisViewer' and read_viewer_b=0
go
UPDATE an_viewer_config SET viewer_class_name = 'apps.risk.JumpToDefaultReportFrameworkViewer' where analysis_name = 'JumpToDefault'
go
add_column_if_not_exists 'position','incep_settle_date','datetime null'
go
/* update the incep_settle_date on position with min(settle_date) from corresponding settle_position */
update position set position.incep_settle_date = ( 
                                select min(settle_date) from settle_position spos (parallel 5)
                                WHERE position.product_id = spos.product_id 
                                AND position.book_id = spos.book_id 
                                AND position.pos_agg_id = spos.pos_agg_id 
                                group by spos.product_id, spos.book_id, spos.pos_agg_id)
go

/* update the incep_trade_date on position to be the same as incep_settle_date if the position doesn't have any corresponding 'Trade Date'  settle_position */

update position set incep_trade_date = incep_settle_date 
where not exists 
	(select * from settle_position (parallel 5)
	where settle_position.product_id = position.product_id 
	and settle_position.book_id = position.book_id 
	and settle_position.pos_agg_id = position.pos_agg_id 
	and settle_position.date_type = 'Trade Date') 
go

/* CAL-81594 */

DELETE from domain_values where name='riskAnalysis' and value='WhatIf'
go

EXEC drop_unique_if_exists 'rate_index'
go

if not exists (select 1 from sysobjects o, sysindexes i where o.id=i.id and o.name= 'calypso_seed' and (i.status & 2048) = 2048)
begin 
exec ('alter table calypso_seed add constraint ct_primarykey primary key (seed_name)')
end
go

/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='000',
        version_date='20100129'
go

