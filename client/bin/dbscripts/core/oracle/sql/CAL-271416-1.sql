
/* CAL-70752 */
update /*+ PARALLEL ( vol_surface ) */  vol_surface
set vol_surf_generator = 'Default'
where vol_surface.vol_surf_generator  ='OFMCalibrationSimple'
or vol_surface.vol_surf_generator = 'OFMDefault'
or vol_surface.vol_surf_generator = 'OFMSimple'
or vol_surface.vol_surf_generator = 'SABRDirectBpVols'
;

/* Update volsurfaces using deprecated generators to use the Swaption generator. */
update  /*+ PARALLEL ( vol_surface ) */ vol_surface
set vol_surf_generator = 'Swaption'
where vol_surface.vol_surf_generator  ='OFMCalibration'
or vol_surface.vol_surf_generator = 'OFMCapsSwaptions'
or vol_surface.vol_surf_generator = 'OFMSwaptions'
;


/* Update curves using deprecated generators to use the BootStrap generator.*/
update curve set curve_generator = 'BootStrap'
where curve_generator = 'BootStrapSimple'
;

/* Update correlation matrices using deprecated generators to use a null generator.*/
update correlation_matrix
set generator_name = null
where (generator_name = 'MFMDefault'
or generator_name = 'Rebonato')
;



/* Remove references to the deprecated correlation matrix generators.*/
delete from  domain_values 
where name = 'CovarianceMatrix.gen' 
and (value = 'MFMDefault' or value = 'Rebonato')
;

/* Remove references to the deprecated simple volsurface generators.*/
delete from  domain_values
where name = 'VolSurface.genSimple'
and (value = 'OFMSimple' or value = 'OFMCalibrationSimple' or value = 'OFMDefault' or value = 'OFMSimple')
;

/* Remove references to the deprecated volsurface generators.*/
delete from  domain_values
where name = 'volSurfaceGenerator'
and (value = 'OFMCalibration' or value = 'OFMCapsSwaptions' or value = 'OFMSwaptions')
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerSingleSwapLegHagan' where product_pricer = 'PricerSingleSwapLegExotic'
;

delete from domain_values where name = 'SingleSwapLeg.Pricer' and value = 'PricerSingleSwapLegExotic'
;

update  /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerCapFloortionLGMM' where product_pricer = 'PricerGenericOption'
;

delete from domain_values where name = 'GenericOption.Pricer' and value = 'PricerGenericOption'
;

delete from pc_pricer where product_pricer = 'PricerGmc'
;

delete from domain_values
where name = 'SingleSwapLeg.Pricer'
and value = 'PricerGmc'
;

update  /*+ PARALLEL (pc_pricer) */ pc_pricer
set product_pricer = 'PricerCapFloor'
where product_pricer = 'PricerCMSCapFloor'
;

delete from domain_values
where name = 'CapFloor.Pricer'
and value = 'PricerCMSCapFloor'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer
set product_pricer = 'PricerSwap'
where product_pricer = 'PricerCMSSwap'
;

delete from domain_values
where name = 'Swap.Pricer'
and value = 'PricerCMSSwap'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer
set product_pricer = 'PricerLGMM1FForward'
where product_pricer = 'PricerBondTarnLGMM'
;

delete from domain_values
where name = 'Bond.Pricer'
and value = 'PricerBondTarnLGMM'
;

delete from pc_pricer
where product_pricer = 'PricerLGM'
;

delete from domain_values
where value = 'PricerLGM'
;

delete from pc_pricer
where product_pricer = 'PricerLGMM2F'
;

delete from domain_values
where value = 'PricerLGMM2F'
;

delete from pc_pricer
where product_pricer = 'PricerSwapMultiFactorModelIRFX'
;

delete from domain_values
where name = 'Swap.Pricer'
and value = 'PricerSwapMultiFactorModelIRFX'
;

update pc_pricer
set product_pricer = 'PricerLGMM1FBackward'
where product_pricer = 'PricerSwapOneFactorModel'
;

delete from domain_values
where name = 'Swap.Pricer'
and value = 'PricerSwapOneFactorModel'
;

update pc_pricer
set product_pricer = 'PricerLGMM1FBackward'
where product_pricer = 'PricerSwaptionOneFactorModel'
;

delete from domain_values
where name = 'Swaption.Pricer'
and value = 'PricerSwaptionOneFactorModel'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer
set product_pricer = 'PricerCancellableSwap'
where product_pricer = 'PricerCancSwapOneFactorModel'
;

delete from domain_values where name = 'CancellableSwap.Pricer' and value = 'PricerCancSwapOneFactorModel'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerExtendibleSwap' where product_pricer = 'PricerExtSwapOneFactorModel'
;

delete from domain_values where name = 'ExtendibleSwap' and value = 'PricerExtSwapOneFactorModel'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerLGMM1FForward' where product_pricer = 'PricerCapFloorMultiFactorModel'
;

delete from domain_values where name = 'CapFloor.Pricer' and value = 'PricerCapFloorMultiFactorModel'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerLGMM1FForward' where product_pricer = 'PricerSwapMultiFactorModel'
;

delete from domain_values where name = 'Swap.Pricer' and value = 'PricerSwapMultiFactorModel'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerLGMM1FForward' where product_pricer = 'PricerSwaptionMultiFactorModel'
;

delete from domain_values where name = 'Swaption.Pricer' and value = 'PricerSwaptionMultiFactorModel'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerSpreadCapFloorGBM2FHagan' where product_pricer = 'PricerSpreadCapFloor'
;

delete from domain_values where name= 'SpreadCapFloor.Pricer' and value = 'PricerSpreadCapFloor'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerCapFloor' where product_pricer = 'PricerCapFloorExotic'
;

delete from domain_values where name = 'CapFloor.Pricer' and value = 'PricerCapFloorExotic'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer = 'PricerCommoditySwap2' where product_pricer = 'PricerCommoditySwap'
;

delete from domain_values where name ='CommoditySwap.Pricer' and value = 'PricerCommoditySwap'
;

update /*+ PARALLEL (pc_pricer) */ pc_pricer set product_pricer='PricerCommodityOTCOption2'
where product_pricer='PricerOTCCommoditySwap'
;

delete from domain_values where name ='CommoditySwap.Pricer' and value ='PricerOTCCommoditySwap'
;

/* end */ 

/* CAL-83039 */
 

begin
  add_column_if_not_exists('wfw_transition','NEEDS_MAN_AUTH_B','int');
end;
;

/* CAL-70526 */




update /*+ PARALLEL (c alypso_tree_node ) */ calypso_tree_node set node_type='Folder' where node_type like '%FolderView'
;
update /*+ PARALLEL (c alypso_tree_node ) */ calypso_tree_node set node_type='RiskAggregation' where node_type like '%CalypsoTreeViewRiskAggregationNode'
;
update /*+ PARALLEL (c alypso_tree_node ) */ calypso_tree_node set node_type='Visokio' where node_type like '%CalypsoTreeViewVisokioNode'
;
update /*+ PARALLEL (c alypso_tree_node ) */ calypso_tree_node set node_type='Workspace' where node_type like '%CalypsoTreeViewWorkspaceNode'
;
/* end */ 

/*CAL-73255*/

delete from pc_pricer where PRICER_CONFIG_NAME='default' and PRODUCT_TYPE like 'EquityStructuredOption%'
;
/* end */ 


/* CAL-69135 */ 
CREATE OR REPLACE FUNCTION custom_rule_discriminator (name IN varchar2) RETURN varchar2
IS
BEGIN
IF instr(name,'MessageRule') <> 0 THEN
RETURN 'MessageRule';
ELSIF instr(name,'TradeRule') <> 0 THEN
RETURN 'TradeRule';
ELSIF instr(name,'TransferRule') <> 0 THEN
RETURN 'TransferRule';
ELSIF instr(name,'WorkflowRule') <> 0 THEN
RETURN 'WorkflowRule';
ELSE
RETURN 'error';
END IF;
END custom_rule_discriminator;
;
/* end */


/*  CAL-64259 */

/* For CashSettleDefaultsAgreements */

 

begin
  add_column_if_not_exists('cash_settle_dflt','AGREEMENT','varchar2(255)');
end;
;



BEGIN
  DECLARE cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO cnt FROM domain_values WHERE name = 'CashSettleDefaultsAgreements';
  IF(cnt != 0) THEN
    delete from domain_values where name = 'CashSettleDefaultsAgreements';
   END IF;
 END;
END;
;

insert into domain_values (name,value,description) VALUES ('CashSettleDefaultsAgreements','ANY','Default Agreement')
;

update /*+ PARALLEL ( cash_settle_dflt) */  cash_settle_dflt set agreement = 'ANY' where agreement is NULL
;

/* BermudanTradeDate to be added in leAttributeType domain */

insert into domain_values (name,value,description) VALUES ('leAttributeType','BermudanTradeDate','')
;

/*-------------------------------------------------------------------*/
/*It's been discovered that the added column is_compounding          */
/*in flow_cmp_period needs to be filled according to the setting of  */
/*compounding on the leg. If it remains empty although the leg is    */
/*compounding the swap pricer does not calculate an NPV on that leg. */
/*Hence the following update stmt is suggested:                      */
/*-------------------------------------------------------------------*/


 

begin
  add_column_if_not_exists('flow_cmp_period','is_compounding','number');
end;
;

update /*+ PARALLEL ( flow_cmp_period ) */ flow_cmp_period set is_compounding = 1 where product_id in (select distinct t.product_id from trade t, swap_leg s, flow_cmp_period f
where s.product_id = t.product_id and s.compound_b = 1 and f.product_id = t.product_id)
;


/* CAL-77413 */
DELETE  FROM report_panel_def where win_def_id IN (SELECT win_def_id FROM report_win_def  WHERE  def_name='TransferViewerWindow')
;
DELETE FROM report_win_def  WHERE  def_name='TransferViewerWindow'
;

/* end */

/* CAL-54713 : insert Trade panel in TransferViewerWindow so that the netted trade of a SimpleNetting transfer can be displayed */

insert into report_panel_def values (-1,-1,'Trade','Trade',null,null)
;
update /*+ PARALLEL (  report_panel_def ) */ report_panel_def set
panel_index=(select max(panel_index)+1 from report_panel_def where win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow')),
win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow')
where exists (select 1 from report_panel_def where panel_name != 'Trade' and win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow'))
and not exists (select 1 from report_panel_def where panel_name = 'Trade' and win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow'))
and win_def_id=-1
;
delete report_panel_def where win_def_id=-1
;
/* End CAL-54713 */


/* CAL-76250 */

update /*+ PARALLEL (  pos_info ) */ pos_info set cash_date_type=date_type
;

/* end */ 


/* CAL-76249 */

update /*+ PARALLEL (  position_spec ) */ position_spec set cash_date_type=0
;

/* end */

/* CAL-75935 */ 

delete from domain_values where name = 'CommodityResetCode' and value in ('COMMODITY_REFERENCE_PRICE', 'COMMODITY_PRICING_DATES')
;
/* end */


/* CAL-77252 */
update /*+ PARALLEL (  commodity_leg2  ) */ commodity_leg2 leg set (leg.strike_price_unit, leg.strike_price, leg.spread)
=(select r.quote_unit,leg.spread,0 
from commodity_reset r 
where leg.comm_reset_id = r.comm_reset_id)
where leg.leg_type = 2 
and leg.strike_price_unit is null
;
/* end */

/* CAL-74583 */

declare 
v_cnt number :=0;
begin
select count(*) into v_cnt from user_tables where table_name=upper('analysis_col_metadata') ;
if v_cnt = 1 then
execute immediate 'DROP TABLE analysis_col_metadata';
end if;
end;
;

declare 
v_cnt number :=0;
begin
select count(*) into v_cnt from user_tables where table_name=upper('analysis_message') ;
if v_cnt = 1 then
execute immediate 'DROP TABLE analysis_message';
end if;
end;
;


declare 
v_cnt number :=0;
begin
select count(*) into v_cnt from user_tables where table_name=upper('analysis_metadata') ;
if v_cnt = 1 then
execute immediate 'DROP TABLE analysis_metadata';
end if;
end;
;
 

/* CAL-77888 */
 

begin
  add_column_if_not_exists('prod_comm_fwd','comm_leg_id','int');
end;
;

begin
  add_column_if_not_exists('prod_comm_fwd','comm_reset_id','int');
end;
;
 

update /*+ PARALLEL (  prod_comm_fwd )  */ prod_comm_fwd p
set (p.comm_reset_id) =
(select l.comm_reset_id
from commodity_leg2 l
where l.leg_id = p.comm_leg_id
and l.comm_reset_id > 0
)
where (p.comm_reset_id is null or p.comm_reset_id = 0)
;
/* end */

UPDATE an_viewer_config SET viewer_class_name = 'apps.risk.JumpToDefaultReportFrameworkViewer' where analysis_name = 'JumpToDefault'
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES ( 8241, 'FX_RATE_RESET' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1504, 'UnexerciseOption' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1505, 'UnexerciseOption' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1506, 'UnexerciseOption' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1507, 'UnexerciseOption' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1509, 'UnexerciseOption' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1514, 'CheckSDI' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 1515, 'CheckSDI' )
;
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'curve_spread_header', 'curve_spread_hdr_hist', 0 )
;
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'trade_price', 'trade_price_hist', 0 )
;

INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, RELATION_CATEGORY,special_comment ) VALUES ( 'curve', 'curve_spread_header', 'curve_id,curve_date', 'curve_id,curve_date', 'Curve', 'Yield Spread Curve')
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'FutureCommodity', 'FutureCommodity ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'PLSweep', 'PLSweep' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'TradeKeywordCopier', 'Specify the Trade Keyword Copiers' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'AccountMapping', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AccountMappingAttributes', 'Specify the attributes for the Account Mapping' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AccountMappingAttributes', 'CashStatement.TransferType', 'Transfer Type for the Simple Transfer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AccountMappingAttributes', 'MappingType', 'Mapping Type for same account mapping' )
;
delete from domain_values where name='domainName' and value= 'ActionNotAmendBundle'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ActionNotAmendBundle', 'Trade action that doesn''t update Bundle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ignoreTradeStatus', 'Status where the trade should be ignored for a given process' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityResetCode', 'Commodity reset code' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityResetCode', 'REFERENCE_PRICE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'SubStatement.GuaranteeFees', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MessageViewer.MsgAttributes.DateAttributesToKeep', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MessageViewer.MsgAttributes.DateAttributesToKeep', 'AckDatetime', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Automatic Guarantee Fees', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Manual CashSweeping', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', ' NotSet', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Booking Date', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Booking Date (To)', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'BO Validation Date', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'BO Validation Date', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'ImportedTrade', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeTmplKeywords', 'QuantityUnit', 'keyword to indicate quantity units on the trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'Tax Rate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddModifyAccountMapping', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveAccountMapping', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddCashSettleDefault', 'AccessPermission for ability to add cash settle default' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AmendCashSettleDefault', 'AccessPermission for ability to ammend cash settle default' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveCashSettleDefault', 'AccessPermission for ability to remove cash settle default' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'settlementType', 'AUCTION', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'AccountMapping', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EquityForward.Pricer', 'Pricer equityForward' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'UnavailabilityTransfer.Pricer', 'Pricers for UnavailabilityTransfer products' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveZero.gen', 'BootStrapISDA', 'Simplified bootstrap used with ISDA standard CDS pricing' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'AccountMapping', 'AccountMapping Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'ReportStatus', 'ReportStatus Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'tradeUpsizeAction', 'AMEND Action applied on Existing Trade in case of EquityLinkedSwap NotionalIncrease' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeUpsizeAction', 'AMEND', 'AMEND Action applied on Existing Trade in case of EquityLinkedSwap NotionalIncrease' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'tradeUnterminateAction', 'default is UNTERMINATE - used by CorporateActionHandler' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'hedgeRelationshipAttributes', 'hedgeRelationshipAttributes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyAttributes', 'FairValueMeasure', 'Default Pricer Measure used in hedge accounting for fair value measurement' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyAttributes', 'FairValueMeasure.Swap', 'Default Pricer Measure used in hedge accounting for fair value measurement, when product is a swap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyAttributes.Check List Template', 'HedgeDocumentationCheckList', 'The default check list template' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyAttributes', 'POSTINGS_ONLY_IF_COMPLIANT', 'POSTINGS_ONLY_IF_COMPLIANT' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeRelationshipAttributes', 'HedgeEffectivenessDocumentationReview', 'HedgeEffectivenessDocumentationReview' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeRelationshipAttributes', 'INEFFECTIVE_COMPLIANCE	', 'INEFFECTIVE_COMPLIANCE' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EquityForward.subtype', 'EquityForward subtypes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MarginCall.DisputeRaison', 'Dispute Reasons of Margin Call' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MarginCall.DisputeStatus', 'Dispute Status of Margin Call' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'ReportBrowserConfig', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'AccountInterestConfigRange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AccountProcessStatusCheck', 'List of ProcessStatusCheck for Accounts' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AccountProcessStatusCheck', 'SubsidiaryAccount', 'check for Subsidiray Accounts' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PositionBasedProducts', 'PLSweep', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'XferAttributes', 'isForecastSubstituted', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'SimpleNetting', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditMktDataUsage.YIELD', 'CurveYield', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'TerminationPayIntFlow', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'creditMktDataUsage.YIELD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'EOD_CAPLMARKING', 'End of day CAPL Marking.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'EOD_CAPLSWEEP', 'End of day scheduled task for CAPL Sweep' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'SubsidiaryICStatementBookingDate.html', '' )
;

delete from domain_values where name='EquityStructuredOption.extendedType' and value= 'Quanto' and description='when option is quanto'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.extendedType', 'Quanto', 'when option is quanto' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.extendedType', 'Compo', 'when option is compo' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'EquityForward', 'EquityForward' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'SetBOValidationDate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EntitlementCheckFeed', 'Market feed name requiring entitlement check' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CappedSwap.MDataSelector.StrikeRange', 'Cap and Floor levels for LPI pricing' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CappedSwap.MDataSelector.StrikeRange', '0 to 2.5', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CappedSwap.MDataSelector.StrikeRange', '0 to 3', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CappedSwap.MDataSelector.StrikeRange', '3 to 5', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CappedSwap.MDataSelector.StrikeRange', '0 to 5', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CappedSwap.MDataSelector.StrikeRange', '0 to Infinity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'UpdateTransfer', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'BD_CST_S_SETTLED', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'accountProperty.PaymentFactory', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty.PaymentFactory', 'False', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty.PaymentFactory', 'True', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty', 'GuaranteeFees', 'Boolean representing if account is a GuaranteeFees Account' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'accountProperty.GuaranteeFees', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty.GuaranteeFees', 'False', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty.GuaranteeFees', 'True', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'creditEventLookBackTenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditEventLookBackTenor', '2M', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'creditEventLookForwardTenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditEventLookForwardTenor', '2W', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'UnavailabilityTransfer.Pricer', 'PricerUnavailabilityTransfer', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'OTCEquityOption.Pricer', 'PricerBlack1FAnalyticDiscreteVanilla', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Cash.subtype', 'Discount', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SimpleMM.subtype', 'Discount', '' )
;
delete from domain_values where name='eventClass' and value='PSEventFXRateReset'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventClass', 'PSEventFXRateReset', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'IgnoreTradesEventFilter', 'Ignore Trade which status is in the ''ignoreTradeStatus'' domain' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'BillingTradeMessageEventFilter', 'Filter to Exclude PSEventMessage events that are related to BillingTrades (that is; trades whose product is of type Billing)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'BillingTradeTaskEventFilter', 'Filter to Exclude PSEventTask events that are related to BillingTrades (that is; trades whose product is of type Billing)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'BillingTradeTradeEventFilter', 'Filter to Exclude PSEventTrade events that are related to BillingTrades (that is; trades whose product is of type Billing)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'BillingTradeTransferEventFilter', 'Filter to Exclude PSEventTransfer events that are related to BillingTrades (that is; trades whose product is of type Billing)' )
;
delete from domain_values where name='eventType' and value='EX_TRADE_AUTH'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'EX_TRADE_AUTH', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'EX_FX_RATE_RESET', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'FX_RATE_RESET', '' )
;
delete from domain_values where name='exceptionType' and value='TRADE_AUTH'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'TRADE_AUTH', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'CLAIM_RATE_MISSING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'flowType', 'CASHSWEEPING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'flowType', 'GUARANTEEFEES', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateModifySalesB2BRoutingRule', 'Permission to Save SalesB2B Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateModifyXccySplitRoutingRule', 'Permission to Save Xccy Split Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateModifyXccySpotMismatchRoutingRule', 'Permission to Save Xccy Spotmismatch Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateModifySpotRiskTransferRoutingRule', 'Permission to Save Spot Risk Transfer Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateModifyFwdRiskTransferRoutingRule', 'Permission to Save Fwd Risk Transfer Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateModifyBookSubstitutionRoutingRule', 'Permission to Save Book Substitution Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveSalesB2BRoutingRule', 'Permission to Remove SalesB2B Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveXccySplitRoutingRule', 'Permission to Remove Xccy Split Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveXccySpotMismatchRoutingRule', 'Permission to Remove Xccy Spotmismatch Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveSpotRiskTransferRoutingRule', 'Permission to Remove Spot Risk Transfer Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveFwdRiskTransferRoutingRule', 'Permission to Remove Fwd Risk Transfer Routing Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveBookSubstitutionRoutingRule', 'Permission to Remove Book Substitution Routing Rule' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'billingCalculators', 'BillingCostOfLateSettlementCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddModifyIndividualAccountInterestRanges', 'Access permission to Add or Modify an Account Interest Config Range for a Specified account' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'SubmitAccountInterestUpdate', 'Access permission to Sumbit an Account Interest Update' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ValidateAccountInterestUpdate', 'Access permission to Validate an Account Interest Update' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataType', 'CurveYield', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productFamily', 'UnavailabilityTransfer', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'UnavailabilityTransfer', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'InvestmentPerformance', 'Investment Performance Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'NAV', 'Net Asset Value Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'CHECK_INC_STATEMENT', '' )
;
delete from domain_values where name='scheduledTask' and value= 'FXOPTION_RATE_RESET'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'FXOPTION_RATE_RESET', 'FX Option rate reset' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'ExercisedUnderSubID', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'ExercisedOptionSubID', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'commodities.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'commodities_cover.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'EquityForwardConfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-ACTUAL-BOOKING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-ACTUAL-BOOKING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'PreciousMetalDepositLease', 'PreciousMetalDepositLease ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'EquityForward', 'EquityForward ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityType', 'Emission', 'Commodities that are emissions related' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'bulkEntry.productType', 'Commodity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'bulkEntry.productType', 'Equity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'bulkEntry.productType', 'EquityStructuredOption', 'allow bulk and quick entry of vanilla equity option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'PublishFeedQuotes', 'Access to view and publish quotes in Feed window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ViewFeedQuoteWindow', 'Access to view quotes in Feed window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CostingEvents', 'Trade', 'PSEventTrade occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CostingEvents', 'Transfer', 'PSEventTransfer occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CostingEvents', 'Message', 'PSEventMessage occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CostingEvents', 'Task', 'PSEventTask occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CostingEvents', 'AccountBilling', 'PSEventAccountBilling occurrences can be processed by the CostingEngine (given appropriate CostingGrid configuration -- see MainEntry.Configuration.Fees,Haricuts,MarginCalls.CostingGrids)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityCalcPeriod', 'conditional swap template keywords value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'Bullet', 'The Effective Date.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'Future Contract FND Payment Frequency', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'Future Contract LTD Payment Frequency', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'PeriodicWK', 'Each Calendar Week from and including the effective date to and including the Termination Date, including the first and last calendar days of each week.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'PeriodicMTH', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'PeriodicQTR', 'Each Calendar Quarter from and including the effective date to and including the Termination Date, including the first and last calendar days of each quarter.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'PeriodicIRConventionWK', 'Each Weekly Period from and including the effective date to and including the Termination Date, including the first and last calendar days of each week.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'PeriodicIRConventionMTH', 'Each Monthly Period from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'PeriodicIRConventionQTR', 'Each Quarterly Period from and including the effective date to and including the Termination Date, including the first and last calendar days of each quarter.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'ThirdWednesdayMTH', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityCalcPeriod', 'Whole', 'Each Calendar Month from and including the effective date to and including the Termination Date, including the first and last calendar days of each month.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPricingDates', 'conditional template keywords value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'BulletBullet', 'The Commodity Business Day equal to the Effective Date of the relevant calculatoin period' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'Future Contract FND Payment FrequencyContract Last Day', 'In respect of each Calculation Period, the Commodity Business Day which corresponds to the Notification Date of the relevant Futures Contract' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'Future Contract FND Payment FrequencyPenultimate', 'In respect of each Calculation Period, the Commodity Business Day immediately preceeding the Commodity Business Day which corresponds to the Notification Date of the relevant Futures Contract' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'Future Contract FND Payment FrequencyLast Three Days', 'In respect of each Calculation Period, the last three Commodity Business Days immediately preceeding and including the Notification Date of the relevant Futures Contract' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'Future Contract LTD Payment FrequencyContract Last Day', 'The last Commodity Business Day on which the relevant Futures Contract is scheduled to trade on the Exchange' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'Future Contract LTD Payment FrequencyPenultimate', 'In respect of each Calculation Period, the Commodity Business Day immediately preceeding the last Commodity Business Day on which the relevant Futures Contract is scheduled to trade on the Exchange' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'Future Contract LTD Payment FrequencyLast Three Days', 'In respect of each Calculation Period, the last three Commodity Business Days on which the relevant Futures Contract is scheduled to trade on the Exchange' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'PeriodicFirst Day', 'The first Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'PeriodicLast Day', 'The last Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'PeriodicWhole Period', 'Every Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'PeriodicIRConventionFirst Day', 'The first Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'PeriodicIRConvention LastDay', 'The last Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'PeriodicIRConventionWhole Period', 'Every Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'ThirdWednesdayThird Wednesday', 'The Commodity Business Day on which the Commodity Reference Price is published which precedes the Third Wednesday of the relevant calculation period' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'WholeFirst Day', 'The first Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'WholeLast Day', 'The last Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPricingDates', 'WholeWhole Period', 'Every Commodity Business Day on which the Commodity Reference Price is published for the relevant calculation period' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EmissionAllowanceType', 'Emissions allowance types' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityResetType', 'Commodity reset defintion types' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityResetType', 'Emission', 'Emission based commodity reset type' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EmissionComplianceType', 'Emission fungibility criteria type' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EmissionComplianceType', 'Perpetual', 'Compliant with commodities with perpetual vintages' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EmissionComplianceType', 'Range', 'compliant with commodities within a vintage range' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EmissionComplianceType', 'Specific', 'Compliant with commodities with a specific vintage' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EmissionComplianceType', 'UpperBound', 'Complaint with commodity that are before a specified vintage. Also known as "In compliance with"' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticVanilla', 'analytic Pricer for single equity vanilla option - using Black Scholes Merton model - can do forward start' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticDiscreteVanilla', 'analytic Pricer for single equity vanilla option - using Forward based Black Scholes Merton model - can do discrete dividends' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticCompo', 'analytic Pricer for single equity vanilla compo option - using Black Scholes Merton model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticQuanto', 'analytic Pricer for single equity vanilla quanto option - using Black Scholes Merton model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Settlement_Date_PnL', '' )
;
delete from domain_values where name = 'plMeasure' and value= 'Settlement_Date_PnL_Base'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Settlement_Date_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Unrealized_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Trade_Cash_FX_Reval', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Trade_Translation_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Trade_Full_Base_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Sweep_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'SuccessionEventIds', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'successionEventType', 'Succession Event Types' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'successionEventType', 'Merger', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'successionEventType', 'Split', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'successionEventType', 'Name Change', '' )
;
delete from domain_values where name= 'function' and value= 'UsePublicPricingSheets'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'UsePublicPricingSheets', 'Permits Access to Pricing Sheets in the Public folder' )
;
delete from domain_values where name='function' and value= 'ManagePublicPricingSheets'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ManagePublicPricingSheets', 'Permits Access to Pricing Sheets in the Public folder, regardless of user' )
;
delete from domain_values where name='function' and value='PricingSheetAccessBackOffice'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'PricingSheetAccessBackOffice', 'Permits Access to backoffice menu' )
;
delete from domain_values where name='function' and value='PricingSheetConfigAccess'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'PricingSheetConfigAccess', 'Permits Access to pricing sheet configuration' )
;
delete from pc_pricer where pricer_config_name='default' and product_type='UnavailabilityTransfer.ANY.ANY' and product_pricer ='PricerUnavailabilityTransfer'
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'UnavailabilityTransfer.ANY.ANY', 'PricerUnavailabilityTransfer' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'OTCEquityOption.ANY.European', 'PricerBlack1FAnalyticDiscreteVanilla' )
;
delete from pc_pricer where pricer_config_name='default' and product_type= 'EquityStructuredOption.ANY.European' and product_pricer='PricerBlack1FAnalyticVanilla' 
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.European', 'PricerBlack1FAnalyticVanilla' )
;
delete from pc_pricer where pricer_config_name='default' and product_type= 'EquityStructuredOption.ANY.European' 
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.European', 'PricerBlack1FAnalyticDiscreteVanilla' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.European', 'PricerBlackNFJuAnalyticVanilla' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.ANY', 'PricerBlackNFMonteCarlo' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Compo.European', 'PricerBlack1FAnalyticCompo' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Quanto.European', 'PricerBlack1FAnalyticQuanto' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.American', 'PricerBlack1FBinomialVanilla' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.BARRIER', 'PricerBlack1FAnalyticBarrier' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.DIGITAL', 'PricerBlack1FAnalyticDigital' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.ASIAN', 'PricerBlack1FMonteCarlo' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.LOOKBACK', 'PricerBlack1FMonteCarlo' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CLIQUET', 'PricerBlack1FMonteCarlo' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.COMPOUND', 'PricerBlack1FSemiAnalyticCompound' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CHOOSER', 'PricerBlack1FSemiAnalyticChooser' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'GenericOption.ANY.ANY', 'PricerCapFloortionLGMM' )
;
delete from pricer_measure where measure_name= 'UNREALIZED_CASH' and measure_class_name= 'tk.core.PricerMeasure' and measure_id=391
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'UNREALIZED_CASH', 'tk.core.PricerMeasure', 391 )
;
delete from pricer_measure where measure_name='HISTO_UNREALIZED_CASH' and measure_class_name= 'tk.core.PricerMeasure' and  measure_id= 392
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_UNREALIZED_CASH', 'tk.core.PricerMeasure', 392 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURR_EFF_ATT', 'tk.core.PricerMeasure', 393 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CURR_EFF_DET', 'tk.core.PricerMeasure', 394 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'UNSETTLED_REALIZED', 'tk.core.PricerMeasure', 395 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SETTLED_REALIZED', 'tk.core.PricerMeasure', 396 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_SETTLED_REALIZED', 'tk.core.PricerMeasure', 397 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MARKET_VALUE', 'tk.core.PricerMeasure', 400 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'EXPLODE_PV_QUOTE_CCY', 'tk.core.PricerMeasure', 401, 'The present value of just the cashflows that pay in the quoting currency' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'EXPLODE_PV_PRIM_CCY', 'tk.core.PricerMeasure', 402, 'The present value of just the cashflows that pay in the primary currency' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DEFAULT_COMP', 'tk.core.PricerMeasure', 403 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DEFAULT_ACCRUAL', 'tk.core.PricerMeasure', 404 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'NPV_INCLUDE_EXDIV_COUPON', 'java.lang.Boolean', 'true,false', 'Include Coupon if Exdiv before Spot in NPV', 1, 'true' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'LGMM_CALIBRATE_TO_OTM_OPTIONS', 'java.lang.Boolean', 'true,false', 'Flag controls whether the calibration always uses OTM options.', 0, 'CALIBRATE_TO_OTM_OPTIONS', 'true' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'PREM_DISC_YIELD_RATE', 'java.lang.String', 'EFFECTIVE,DEFAULT', 'Yield Method to use in computing PREM_DISC_YIELD and NPV_DISC measures.', 1, 'DEFAULT' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'DIVIDEND_MODEL', 'java.lang.String', 'Continuous,Escrowed', 'Dividend pricing model choice', 1, 'Escrowed' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, default_value ) VALUES ( 'NUMERIC_RHO_SHIFT', 'java.lang.Double', 'numerical rho shift (typically 1% or 1bps)', 1, '0.01' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, default_value ) VALUES ( 'NUMERIC_RHO2_SHIFT', 'java.lang.Double', 'numerical rho2 shift (typically 10% or 1%). For discrete dividends, it represents the unknown dividend shift', 1, '0.01' )
;
delete from pricing_param_name where param_name='NPV_DISC_LINEAR' and param_type='java.lang.Boolean'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'NPV_DISC_LINEAR', 'java.lang.Boolean', 'true,false', 'Amortize Prem/Disc on a linear basis', 1, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'INCLUDE_FEES_BY_CCY', 'java.lang.Boolean', 'true,false', 'Include fees to swapleg based on currency', 1, 'false' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'AccountingEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'MessageEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'TransferEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'DiaryEngine' )
;
delete from ps_event_config where event_config_name='Back-Office' and event_class='PSEventFXRateReset' and engine_name='PositionEngine' 
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'PositionEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventFXRateReset', 'CreEngine' )
;
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ( 'Back-Office', 'TransferEngine', 'IgnoreTradesEventFilter' )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1502, 'PSEventTrade', 'ALLOCATED', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1504, 'PSEventTrade', 'EXERCISED', 'UNEXERCISE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Exercise action needs to be undone - it was applied by mistake.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1506, 'PSEventTrade', 'EXPIRED', 'UNEXPIRE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade undo expiry by Trader.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1512, 'PSEventTrade', 'PENDING', 'ACCEPT_NO_SDI', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is accepted without settlements. SDI will be handled by the settlements team.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1514, 'PSEventTrade', 'PENDING', 'AUTHORIZE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is authorized manually by Trade Support.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1516, 'PSEventTrade', 'PENDING', 'BO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by Trade Support. This action needs to be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1518, 'PSEventTrade', 'PENDING', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1520, 'PSEventTrade', 'PENDING', 'FO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by FO.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1522, 'PSEventTrade', 'PRICING', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'This is a system action. No user should be allowed access to this action.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1524, 'PSEventTrade', 'PRICING', 'EXECUTE_STP', 'PENDING', 1, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '"Trade is STP. CheckLimitNoExcess rule will need to be added to validate whether the trade satisfies the counterparty and trader limits. ERS system must be implemented for this rule to work."', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1526, 'PSEventTrade', 'PRICING', 'FO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by FO.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1530, 'PSEventTrade', 'VERIFIED', 'ALLOCATE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1532, 'PSEventTrade', 'VERIFIED', 'BOOKTRANSFER', 'TERMINATED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade has been transferred to a different book.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1534, 'PSEventTrade', 'VERIFIED', 'BO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by BO. This action should be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1536, 'PSEventTrade', 'VERIFIED', 'EXERCISE', 'EXERCISED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1538, 'PSEventTrade', 'VERIFIED', 'FO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by FO.', 0, 0, 1, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1540, 'PSEventTrade', 'VERIFIED', 'KNOCK_IN', 'KNOCKED_IN', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1542, 'PSEventTrade', 'VERIFIED', 'MATURE', 'MATURED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1544, 'PSEventTrade', 'VERIFIED', 'ROLLBACK', 'ROLLBACKED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1546, 'PSEventTrade', 'VERIFIED', 'SPLIT', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1501, 'PSEventTrade', 'ALLOCATED', 'ALLOCATE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1503, 'PSEventTrade', 'ALLOCATED', 'UPDATE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1505, 'PSEventTrade', 'EXPIRED', 'UNEXERCISE', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1507, 'PSEventTrade', 'KNOCKED_IN', 'UN-KNOCK_IN', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade undo knock in.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1509, 'PSEventTrade', 'KNOCKED_OUT', 'UN-KNOCK_OUT', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade undo knock out.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1511, 'PSEventTrade', 'NONE', 'NEW', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 1, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1513, 'PSEventTrade', 'PENDING', 'AMEND', 'PENDING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1515, 'PSEventTrade', 'PENDING', 'AUTHORIZE_STP', 'VERIFIED', 1, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is STP.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1517, 'PSEventTrade', 'PENDING', 'BO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by Trade Support. This action needs to be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1519, 'PSEventTrade', 'PENDING', 'FO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by FO.', 0, 0, 1, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1521, 'PSEventTrade', 'PRICING', 'AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1523, 'PSEventTrade', 'PRICING', 'EXECUTE', 'PENDING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is executed manually by FO.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1525, 'PSEventTrade', 'PRICING', 'FO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by FO.', 0, 0, 1, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1529, 'PSEventTrade', 'VERIFIED', 'ALLOCATE', 'ALLOCATED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1531, 'PSEventTrade', 'VERIFIED', 'AMEND', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1533, 'PSEventTrade', 'VERIFIED', 'BO_AMEND', 'PRICING', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is amended by BO. This action needs to be accepted / rejected by Supervisor.', 0, 0, 0, 0, 0, 1 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1535, 'PSEventTrade', 'VERIFIED', 'CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1537, 'PSEventTrade', 'VERIFIED', 'EXPIRE', 'EXPIRED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is expired.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1539, 'PSEventTrade', 'VERIFIED', 'FO_CANCEL', 'CANCELED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, 'Trade is cancelled by FO.', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1541, 'PSEventTrade', 'VERIFIED', 'KNOCK_OUT', 'KNOCKED_OUT', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1543, 'PSEventTrade', 'VERIFIED', 'RENEW', 'VERIFIED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1545, 'PSEventTrade', 'VERIFIED', 'ROLLOVER', 'ROLLOVERED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES ( 1547, 'PSEventTrade', 'VERIFIED', 'TERMINATE', 'TERMINATED', 0, 1, 'EquityStructuredOption', 'ALL', 0, 0, 0, '', 0, 0, 0, 0, 0, 0 )
;

CREATE OR REPLACE PROCEDURE add_cost_svr_event_type_master
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_event_type_master (id number not null , classname varchar2(255) not null, account_provider_factory_class varchar2(255) not null)';
    END IF;
END add_cost_svr_event_type_master;
;

BEGIN
add_cost_svr_event_type_master('cost_svr_event_type_master');
END;
;

drop PROCEDURE add_cost_svr_event_type_master
;

CREATE OR REPLACE PROCEDURE add_cost_svr_predicate_master
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_predicate_master (id number not null , description varchar2(255) not null , factory_classname varchar2(255) not null)';
    END IF;
END add_cost_svr_predicate_master;
;

BEGIN
add_cost_svr_predicate_master('cost_svr_predicate_master');
END;
;

drop PROCEDURE add_cost_svr_predicate_master
;

CREATE OR REPLACE PROCEDURE add_cost_svr_ptemplate
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_predicate_template (id number not null , predicate_id number not null  , predicate_parameter_key varchar2(128) not null)';
    END IF;
END add_cost_svr_ptemplate;
;

BEGIN
add_cost_svr_ptemplate('cost_svr_predicate_template');
END;
;

drop PROCEDURE add_cost_svr_ptemplate
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 30, 16, 'TaskProcessingOrganisation' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 31, 17, 'TaskStaticDataFilter' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 32, 18, 'TradeActionSet' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 33, 19, 'Range.Minimum' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 34, 19, 'Range.Maximum' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 35, 19, 'Range.Percentage' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 36, 20, 'MessageProcessingOrganisation' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 37, 21, 'MessageRole.Role' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 38, 21, 'MessageRole.LegalEntity' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 39, 22, 'AccountProcessingOrganisation' )
;
INSERT INTO cost_svr_predicate_template ( id, predicate_id, predicate_parameter_key ) VALUES ( 40, 23, 'AccountStaticDataFilter' )
;

CREATE OR REPLACE PROCEDURE add_cost_svr_etpredicate 
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_event_type_predicate (event_type_id number not null, predicate_id int not null)';
    END IF;
END add_cost_svr_etpredicate ;
;

BEGIN
add_cost_svr_etpredicate('cost_svr_event_type_predicate');
END;
;

drop PROCEDURE add_cost_svr_etpredicate 
;

INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 5, 4 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 5, 16 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 5, 17 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 1, 18 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 2, 19 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 3, 20 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 3, 21 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 4, 22 )
;
INSERT INTO cost_svr_event_type_predicate ( event_type_id, predicate_id ) VALUES ( 4, 23 )
;
CREATE OR REPLACE PROCEDURE add_cost_methd 
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_event_type_calc_methd (event_type_id number not null, calculation_method_id number not null)';
    END IF;
END add_cost_methd ;
;

BEGIN
add_cost_methd('cost_svr_event_type_calc_methd');
END;
;

drop PROCEDURE add_cost_methd 
;

INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 5, 1 )
;
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 5, 3 )
;
INSERT INTO cost_svr_event_type_calc_methd ( event_type_id, calculation_method_id ) VALUES ( 2, 5 )
;
CREATE OR REPLACE PROCEDURE add_cost_sevtvaln_methd
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_event_type_valn_methd (event_type_id number not null ,valuation_method_id number not null)';
    END IF;
END add_cost_sevtvaln_methd;
;

BEGIN
add_cost_sevtvaln_methd('cost_svr_event_type_valn_methd');
END;
;

drop PROCEDURE add_cost_sevtvaln_methd
;

CREATE OR REPLACE PROCEDURE add_cost_svr_cmmaster 
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_calc_method_master ( id number not null , factory_classname varchar2(255) not null)';
    END IF;
END add_cost_svr_cmmaster ;
;

BEGIN
add_cost_svr_cmmaster ('cost_svr_calc_method_master');
END;
;

drop PROCEDURE add_cost_svr_cmmaster 
;


CREATE OR REPLACE PROCEDURE add_cost_svr_cmtemplate 
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_calc_method_template (id number not null ,  method_id number not null , parameter_key varchar2(128) not null)';
    END IF;
END add_cost_svr_cmtemplate ;
;

BEGIN
add_cost_svr_cmtemplate('cost_svr_calc_method_template');
END;
;

drop PROCEDURE add_cost_svr_cmtemplate 
;

CREATE OR REPLACE PROCEDURE add_cscmethod_master 
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_cval_method_master (id number not null , factory_classname varchar2(255) not null)';
    END IF;
END add_cscmethod_master ;
;

BEGIN
add_cscmethod_master ('cost_svr_cval_method_master');
END;
;

drop PROCEDURE add_cscmethod_master 
;

 
CREATE OR REPLACE PROCEDURE add_csb_spec_master 
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_svr_billee_spec_master (id number not null , factory_classname varchar2(255) not null)';
    END IF;
END add_csb_spec_master ;
;

BEGIN
add_csb_spec_master('cost_svr_billee_spec_master');
END;
;

drop PROCEDURE add_csb_spec_master 
;


CREATE OR REPLACE PROCEDURE add_cost_app_mcmethod  
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table cost_app_mapper_calc_method (id number not null , client_lookup_key varchar2(128) not null , label_display_name varchar2(128) not null , classname_panel_renderer varchar2(255) not null, classname_panel_parameter_map varchar2(255) not null)';
    END IF;
END add_cost_app_mcmethod;
;

BEGIN
add_cost_app_mcmethod ('cost_app_mapper_calc_method');
END;
;

drop PROCEDURE add_cost_app_mcmethod  
;

INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 1, 'ALL_CONSTANT', 'Constant', 'com.calypso.apps.refdata.costing.InputPanelRendererImplMoney', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplMoney' )
;
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 2, 'TRADE_PRICE_PERCENTAGE', 'Trade Principal Percentage', 'com.calypso.apps.refdata.costing.InputPanelRendererImplPercent', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplPercentage' )
;
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 3, 'TASK_DURATION', 'Task Duration (Hours) By Rate', 'com.calypso.apps.refdata.costing.InputPanelRendererImplMoney', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplMoney' )
;
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 4, 'TRANSFER_SETTLEMENT_AMOUNT_PERCENTAGE', 'Transfer Settlement-Amount Percentage', 'com.calypso.apps.refdata.costing.InputPanelRendererImplPercent', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplPercentage' )
;
INSERT INTO cost_app_mapper_calc_method ( id, client_lookup_key, label_display_name, classname_panel_renderer, classname_panel_parameter_map ) VALUES ( 5, 'TRANSFER_COST_OF_LATE_SETTLEMENT', 'Transfer Cost Of Late Settlement', 'com.calypso.apps.refdata.costing.InputPanelRenererImplCostOfLateSettlement', 'com.calypso.apps.refdata.costing.InputPanelParameterMapMakerCalculationMethodImplCOLSDefault' )
;

UPDATE an_viewer_config SET viewer_class_name = 'apps.risk.JumpToDefaultReportFrameworkViewer' where analysis_name = 'JumpToDefault'
;

update position pos set pos.incep_settle_date =
( select min(settle_date) from settle_position spos 
WHERE pos.product_id = spos.product_id 
AND pos.book_id = spos.book_id 
AND pos.pos_agg_id = spos.pos_agg_id 
group by product_id, book_id, pos_agg_id)
;

/* update the incep_trade_date on position to be the same as incep_settle_date if the position doesn't have any corresponding 'Trade Date'  settle_position */

update position set incep_trade_date = incep_settle_date 
where not exists 
	(select * from settle_position 
	where settle_position.product_id = position.product_id 
	and settle_position.book_id = position.book_id 
	and settle_position.pos_agg_id = position.pos_agg_id 
	and settle_position.date_type = 'Trade Date') 
;
/* CAL-81594 */

DELETE from domain_values where name='riskAnalysis' and value='WhatIf'
;

 


begin
 drop_uk_if_exists('REPORT_VIEW');
end;
;

 


BEGIN
add_pk_if_not_exists('calypso_seed','seed_name','ct_pkseed');
END;
;


/*  Update Version */

UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('29/01/2010','DD/MM/YYYY')
;
