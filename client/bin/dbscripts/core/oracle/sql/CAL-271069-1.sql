
DELETE FROM pricer_measure where measure_name = 'EFFECTIVE_STRIKE'
;
DELETE FROM pricer_measure where measure_name = 'NPV_PAYLEG_NET'
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('NPV_PAYLEG_NET','tk.core.PricerMeasure',211)
;
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('EFFECTIVE_STRIKE','tk.core.PricerMeasure',215) 
;
/* BZ : 52340 - 02-07-2008 */

UPDATE an_param_items SET attribute_name = 'Trade_Attr_Count' 
WHERE attribute_name = 'PL_AttrNamesCount' AND class_name = 'com.calypso.tk.risk.EconomicPLParam' 
; 
    
UPDATE an_param_items SET attribute_name = 'Trade_Attr_Name_' ||SUBSTR(attribute_name, 14, 10) 
WHERE attribute_name LIKE 'PL_ATTRNAME__%' AND class_name = 'com.calypso.tk.risk.EconomicPLParam' 
; 
     
UPDATE an_param_items SET attribute_name = 'Trade_Attr_Count' 
WHERE attribute_name = 'CA_ColumnNamesCount' 
AND class_name in ( 'com.calypso.tk.risk.CompositeAnalysisParam', 'com.calypso.tk.risk.CrossAssetPLParam') 
; 
     
UPDATE an_param_items SET attribute_name = 'Trade_Attr_Name_'||SUBSTR(attribute_name, 15, 10) 
WHERE attribute_name LIKE 'CA_ColumnName_%' 
AND class_name in ( 'com.calypso.tk.risk.CompositeAnalysisParam', 'com.calypso.tk.risk.CrossAssetPLParam') 
;

/* end */


 
/* Credit Event Notification Date  */



UPDATE cdsbasket_events SET effective_date = event_date WHERE effective_date IS NULL
;



UPDATE product_cds SET credit_event_effective_date = credit_event_date WHERE credit_event_effective_date IS NULL
;

/* End Credit Event Notification Date */

delete from domain_values where name = 'function' and value = 'CreateFeedAddress' and description = 'Access permission to create a feed address'
;
insert into domain_values (name,value,description) values ('function','CreateFeedAddress','Access permission to create a feed address')
;
delete from domain_values where name = 'function' and value = 'ModifyFeedAddress' and description = 'Access permission to modify a feed address'
;
insert into domain_values (name,value,description) values ('function','ModifyFeedAddress','Access permission to modify a feed address')
;
delete from domain_values where name = 'function' and value = 'RemoveFeedAddress' and description = 'Access permission to remove a feed address'
;
insert into domain_values (name,value,description) values ('function','RemoveFeedAddress','Access permission to remove a feed address')
;

/* drop foreign key */

 
begin
 drop_fk_on_table('calypso_tree_node');
end;
;
/*end*/


/* drop primary key and unique key for table mime_type*/


 

begin
 drop_pk_if_exists('mime_type');
end;
;

/*inserting the values for new column rel_trade_version*/
begin
add_column_if_not_exists ('trade_role_alloc','rel_trade_version','numeric null');
end;
/

update trade_role_alloc set trade_role_alloc.rel_trade_version = 
(select trade.version_num from trade where  trade_role_alloc.rel_trade_id= trade.trade_id ) where exists 
(select trade.version_num from trade where trade.trade_id = trade_role_alloc.rel_trade_id)
;

update trade_role_alloc set initial_amount = amount
;


delete from domain_values where name = 'principalStructure' and value = 'Accreting'
;
insert into domain_values(name,value,description) VALUES ('principalStructure','Accreting','')
;


/* renaming the following names:                               */
/* Year end closing rate   -->  Year end closing spot rate     */  
/* Year end reval rate     -->  Year end outright rate         */  
/* Month end closing rate  -->  Month end closing spot rate    */  
/* Month end reval rate    -->  Month end outright rate        */  
/* Yesterday closing rate  -->  Yesterday closing spot rate    */  
/* Yesterday reval rate    -->  Yesterday outright rate        */   
/* Current rate            -->  Current spot rate              */   
/* Current reval rate      -->  Current outright rate          */   
/*                                                             */

/* updating TWS's custom formulas */
UPDATE user_viewer_column
SET    column_name = replace(column_name,'Year__end__closing__rate','Year__end__closing__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Year__end__closing__rate%'
;

UPDATE user_viewer_column
SET    column_name = replace(column_name,'Year__end__reval__rate','Year__end__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Year__end__reval__rate%'
;

UPDATE user_viewer_column
SET    column_name = replace(column_name,'Month__end__closing__rate','Month__end__closing__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Month__end__closing__rate%'
;

UPDATE user_viewer_column
SET    column_name = replace(column_name,'Month__end__reval__rate','Month__end__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Month__end__reval__rate%'
;

UPDATE user_viewer_column
SET    column_name = replace(column_name,'Yesterday__closing__rate','Yesterday__closing__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Yesterday__closing__rate%'
;

UPDATE user_viewer_column
SET    column_name = replace(column_name,'Yesterday__reval__rate','Yesterday__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Yesterday__reval__rate%'
;

UPDATE user_viewer_column
SET    column_name = replace(column_name,'Current__rate','Current__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Current__rate%'
;

UPDATE user_viewer_column
SET    column_name = replace(column_name,'Current__reval__rate','Current__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Current__reval__rate%'
;

/* updating TWS's report templates */

/* year end columns */
UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Year end closing rate','Year end closing spot rate')
WHERE  attr_name like '%Year end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Year end closing rate','Year end closing spot rate')
WHERE  attr_value like '%Year end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Year end reval rate','Year end outright rate')
WHERE  attr_name like '%Year end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Year end reval rate','Year end outright rate')
WHERE  attr_value like '%Year end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;


/* month end columns */
UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Month end closing rate','Month end closing spot rate')
WHERE  attr_name like '%Month end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Month end closing rate','Month end closing spot rate')
WHERE  attr_value like '%Month end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Month end reval rate','Month end outright rate')
WHERE  attr_name like '%Month end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Month end reval rate','Month end outright rate')
WHERE  attr_value like '%Month end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;


/* yesterday columns */
UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Yesterday closing rate','Yesterday closing spot rate')
WHERE  attr_name like '%Yesterday closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Yesterday closing rate','Yesterday closing spot rate')
WHERE  attr_value like '%Yesterday closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Yesterday reval rate','Yesterday outright rate')
WHERE  attr_name like '%Yesterday reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Yesterday reval rate','Yesterday outright rate')
WHERE  attr_value like '%Yesterday reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;


/* current columns */
UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Current rate','Current spot rate')
WHERE  attr_name like '%Current rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Current rate','Current spot rate')
WHERE  attr_value like '%Current rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_name = replace(attr_name,'Current reval rate','Current outright rate')
WHERE  attr_name like '%Current reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

UPDATE entity_attributes 
SET    attr_value = replace(attr_value,'Current reval rate','Current outright rate')
WHERE  attr_value like '%Current reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
;

CREATE TABLE cms_index_quote AS
        (SELECT quote_name AS old_name, CONCAT('MM', SUBSTR(quote_name, 5)) AS new_name
        FROM rate_index
        WHERE quote_name LIKE 'Swap.%')
;

create table quote_value_bak2 as select * from quote_value
;
create table rate_index_bak2 as select * from rate_index
;

UPDATE quote_value quotes
        SET quote_name =
                (SELECT new_name FROM cms_index_quote cms_names
                WHERE cms_names.old_name = quotes.quote_name)
        WHERE exists
                (SELECT 'X' FROM cms_index_quote cms_names
                WHERE cms_names.old_name = quotes.quote_name)
;

UPDATE rate_index rate_indices
        SET quote_name =
                (SELECT new_name FROM cms_index_quote cms_names
                WHERE cms_names.old_name = rate_indices.quote_name)
        WHERE exists
                (SELECT 'X' FROM cms_index_quote cms_names
                WHERE cms_names.old_name = rate_indices.quote_name)
;

DROP TABLE cms_index_quote
;


/* Begin Calibration Name Changes */
CREATE OR REPLACE PROCEDURE rename_calibration_table (tabName IN varchar2, newTabName IN varchar2) AS
x number :=0 ;
BEGIN
	BEGIN
	SELECT count(*) INTO x FROM user_tab_cols WHERE table_name=UPPER(tabName);
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
    IF x > 0 THEN
    	EXECUTE IMMEDIATE 'ALTER TABLE ' ||tabName|| ' RENAME TO ' ||newTabName|| '';
    END IF;
END rename_calibration_table;
;

CREATE OR REPLACE PROCEDURE rename_template_index_column (tabName IN varchar2) AS
x number :=0 ;
BEGIN
	BEGIN
	SELECT count(*) INTO x FROM user_tab_cols WHERE table_name=UPPER(tabName) AND column_name=UPPER('template_index');
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
    IF x > 0 THEN
    	EXECUTE IMMEDIATE 'ALTER TABLE ' ||tabName|| ' RENAME COLUMN template_index TO instrument_index';
    END IF;
END rename_template_index_column;
;

CREATE OR REPLACE PROCEDURE rename_template_weight_column (tabName IN varchar2) AS
x number :=0 ;
BEGIN
	BEGIN
	SELECT count(*) INTO x FROM user_tab_cols WHERE table_name=UPPER(tabName) AND column_name=UPPER('template_weight');
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
    IF x > 0 THEN
    	EXECUTE IMMEDIATE 'ALTER TABLE ' ||tabName|| ' RENAME COLUMN template_weight TO instrument_weight';
    END IF;
END rename_template_weight_column;
;

 

BEGIN
 rename_calibration_table('calibration_template', 'calibration_instrument');
END;
;
BEGIN
 rename_template_index_column('calibration_instrument');
END;
;
BEGIN
 drop_pk_if_exists('calibration_instrument');
END;
;
BEGIN
  drop_uq_on_table('calibration_instrument');
END;
;

BEGIN
 rename_calibration_table('calibration_template_override', 'calibration_inst_override');
END;
;
BEGIN
 rename_template_index_column('calibration_inst_override');
END;
;
BEGIN
 drop_pk_if_exists('calibration_inst_override');
END;
;
BEGIN
  drop_uq_on_table('calibration_inst_override');
END;
;

BEGIN
 rename_calibration_table('template_ctx_model_param', 'inst_ctx_model_param');
END;
;
BEGIN
 rename_template_index_column('inst_ctx_model_param');
END;
;
BEGIN
 drop_pk_if_exists('inst_ctx_model_param');
END;
;
BEGIN
  drop_uq_on_table('inst_ctx_model_param');
END;
;

BEGIN
 rename_calibration_table('template_ctx_pricer_measure', 'inst_ctx_pricer_measure');
END;
;
BEGIN
 rename_template_index_column('inst_ctx_pricer_measure');
END;
;
BEGIN
 drop_pk_if_exists('inst_ctx_pricer_measure');
END;
;
BEGIN
  drop_uq_on_table('inst_ctx_pricer_measure');
END;
;

BEGIN
 rename_calibration_table('template_context', 'instrument_ctx');
END;
;
BEGIN
 rename_template_index_column('instrument_ctx');
END;
;
BEGIN
 rename_template_weight_column('instrument_ctx');
END;
;
BEGIN
 drop_pk_if_exists('instrument_ctx');
END;
;
BEGIN
  drop_uq_on_table('instrument_ctx');
END;
;
/* End Calibration Name Changes */


insert into domain_values (name,value,description) values ('function', 'ViewUnconsumedEvent', 'AdminFrame Permission to View Unconsumed Event')
;

/* BZ 54265 */
delete from domain_values where name = 'CommodityOTCOption2.Pricer' and value = 'PricerCommodityOTCOption2'
;

update pc_pricer set product_pricer = 'PricerCommodityOTCOption2LTBlack' where product_pricer = 'PricerCommodityOTCOption2'
;

/* End BZ 54265 */

/* Begin 52654 */
/* 52654 - replace cash settle defaults exprity time and earliest exercise time */
/* with termination_expiration_time, termination_earliest_exer_time,            */
/* swaption_expiration_time,  swaption_earliest_term_time                       */


UPDATE cash_settle_dflt
SET    termination_expiration_time=expiry_time, swaption_expiration_time=expiry_time
WHERE  expiry_time != -1 AND expiry_time IS NOT NULL
;

UPDATE cash_settle_dflt
SET    termination_earliest_exer_time=earliest_ex_time, swaption_earliest_exer_time=earliest_ex_time
WHERE  earliest_ex_time != -1 AND earliest_ex_time IS NOT NULL
;


INSERT INTO domain_values(name,value,description) VALUES ('domainName','CashSettleDefaultsAgreements','')
;

INSERT INTO domain_values(name,value,description) VALUES ('CashSettleDefaultsAgreements','Deutsche Rahmenvertrag','')
;

INSERT INTO domain_values(name,value,description) VALUES ('CashSettleDefaultsAgreements','ISDA','')
;


/* end 52654 */

INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 503, 'NotAllocationChild' )
;
INSERT INTO calypso_seed ( last_id, seed_name ) VALUES ( 1000, 'callAccount' )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_calib_def_trade', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ForwardLadderProduct', 'Products that are supported in Forward Ladder Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'TradeRejectAction', 'Actions categorized as Reject' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FX', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXForward', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXNDF', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXTTM', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXSpotReserve', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXOptionForward', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXOptionSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXOption', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FutureFX', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FutureMM', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FutureBond', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'Cash', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'SimpleMM', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'CallNotice', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FRA', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'SimpleTransfer', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'Swap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'PositionCash', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'CommoditySwap2', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'CommodityOTCOption2', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'PreciousMetalDepositLease', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'PreciousMetalLeaseRateSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PerformanceSwap.Pricer', 'PricerPerformanceSwapAccrual', 'PerformanceSwap accrual pricer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PerformanceSwap.subtype', 'MarketIndex', 'MarketIndex based PerformanceSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'PerformanceSwap.subtype', 'PerformanceSwap product subtypes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'FutureOptionBpVol', 'Generates BP vols for FutureOptions' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommoditySettleMethod', 'Commodity Settle Method' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'rate_index_type', 'Bond', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'creditEventProtocolType', 'Credit Event Protocol Types' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditEventProtocolType', 'Rebate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditEventProtocolType', 'NoRebate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditEventProtocolType', 'Calypso', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditEventProtocolType', 'SettleDate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'VarianceOption.Pricer', 'Pricers for VarianceOption' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'CompositeAnalysis', 'Composite Analysis Report' )
;
delete from domain_values where name =  'REPORT.Templates' and value = 'default_no_header.html'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Templates', 'default_no_header.html', 'Default HTML Report Template - no header' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'VarianceOption.subtype', 'VarianceOption subtypes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SingleSwapLeg.Pricer', 'PricerGmc', 'Pricer for exsp based equity linked structures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SingleSwapLeg.Pricer', 'PricerSingleSwapLegDemoExotic', 'Demo pricer for Single Swap Leg for a class of exsp based legs' )
;
delete from domain_values where name = 'rateIndexAttributes'  and  value = 'RATE_INDEX_CODE.T3750'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'rateIndexAttributes', 'RATE_INDEX_CODE.T3750', '' )
;
delete from domain_values where name = 'rateIndexAttributes'  and  value = 'RATE_INDEX_CODE.H15'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'rateIndexAttributes', 'RATE_INDEX_CODE.H15', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'TTMCheckAction', 'This rule applies the trade action (cancel) of parent trade to its child SpotReserve trade.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FXOptionBarrier.OptionList', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOptionBarrier.OptionList', 'BARRIER', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOptionBarrier.OptionList', 'DIGITAL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOptionBarrier.OptionList', 'RANGEACCRUAL', '' )
;
delete from domain_values where name = 'workflowRuleTrade'  and value = 'CancelRemainderOfPartialExercise'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'CancelRemainderOfPartialExercise', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'VarianceOption', 'VarianceOption' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityOTCOption2.Pricer', 'PricerCommodityOTCOption2LTBlack', 'Pricer for the CommodityOTCOption2 product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityOTCOption2.Pricer', 'PricerCommodityOTCOption2Clewlow', 'Pricer for the CommodityOTCOption2 product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'PeriodDistribution', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'IntradayConfiguration', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'PeriodDistribution', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'IntradayConfiguration', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'NotAllocationChild', 'Returns true if the trade is not allocated from a block trade.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommoditySettleMethod', 'COMMODITY', 'Commodity Settle Method' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swap.Pricer', 'PricerSwapDemoExotic', '' )
;
delete from domain_values where name='Swap.Pricer' and value = 'PricerSwapLGM' and description = 'Pricer for a Swap with a Bermudan cancellable schedule.'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swap.Pricer', 'PricerSwapLGM', 'Pricer for a Swap with a Bermudan cancellable schedule.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Bond.Pricer', 'PricerBondDemoExotic', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureMM.Pricer', 'PricerFutureMMBpVol', 'Pricer for FutureOptions using BP vol' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.subtype', 'FX', 'FX' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.subtype', 'Commodity', 'Commodity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.subtype', 'Equity', 'Equity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.subtype', 'EquityIndex', 'EquityIndex' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.Pricer', 'PricerVarianceOptionFX', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.Pricer', 'PricerVarianceOptionCommodity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.Pricer', 'PricerVarianceOptionEquity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VarianceOption.Pricer', 'PricerVarianceOptionEquityIndex', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionDigitalWBarriers', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionForwardStarting', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EquityLinkedSwap.subtype', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityLinkedSwap.subtype', 'TotalReturn', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityLinkedSwap.subtype', 'PriceReturn', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityLinkedSwap.subtype', 'Dividend', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.subtype', 'FWDSTART', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.subtype', 'DIGITALWITHBARRIER', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'EX_BSBDATA', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'BSBDATA', '' )
;
delete from domain_values where name = 'function' and value = 'ModifyMimeTypes' and description = 'Access permission to Modify MIME Types'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyMimeTypes', 'Access permission to Modify MIME Types' )
;
delete from domain_values where name='function' and value='ViewOtherTaskStation'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ViewOtherTaskStation', 'Access permission to view other users TaskStation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ViewOnlyGroupTaskStation', 'Access permission to view TaskStation only for users in the same group' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'restriction', 'ViewOnlyGroupTaskStation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'NAT_CLEARING_IMPORT', 'Import The National Clearing Directory' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'CHECK_NAT_CLEARING_DATA', 'Check The National Clearing Directory' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'ACCOUNT_DORMANT', 'Move accounts to Dormant Status' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '0.01', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '0.04', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '0.1', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '1', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '2', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '4', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '12', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '400', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '1000', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tickSize', '10000', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'cds2003Confirm.html', '' )
;
delete from domain_values where name='MESSAGE.Templates' and value='BondTRS_TS_Confirm.html'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'BondTRS_TS_Confirm.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'VarianceOptionConfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'JumpToDefault', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'ResetRisk', 'ResetRisk Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'CrossAssetPL', 'CrossAssetPL Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes', 'PeakSetting', 'peak settings for electricity future contract' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes.PeakSetting', 'None', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes.PeakSetting', 'On Peak', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes.PeakSetting', 'Off Peak', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes.PeakSetting', 'Base Load', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureOptionContractAttributes', 'Quote Decimals', 'quote decimals for display' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes', 'IsDefaultDeliverableFutureContract', 'default deliverable future contract for the commodity - used in certificate pricing' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes.IsDefaultDeliverableFutureContract', 'Yes', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes.IsDefaultDeliverableFutureContract', 'No', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'ADR', 'ADR ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'AssetPerformanceSwap', 'AssetPerformanceSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'ETOEquity', 'ETOEquity ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'ETOEquityIndex', 'ETOEquityIndex ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'FutureEquity', 'FutureEquity ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'FutureEquityIndex', 'FutureEquityIndex ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'OTCEquityOption', 'OTCEquityOption ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'VarianceSwap', 'VarianceSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'VarianceOption', 'VarianceOption ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'CommodityIndexSwap', 'CommodityIndexSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'EquityLinkedSwap', 'EquityLinkedSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'FutureContractFND', 'FutureContractFND' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityType', 'Supported behavioral types of physically represented Commodities' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityType', 'Commodity', 'Commodities' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityType', 'Storage Based', 'Commodities that are physically stored at a location for a cost. (ie Agriculture)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityType', 'Vintage Based', 'Commodities that are traded based on vintage year(ie Emmision Credits)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityType', 'Electricity', 'Commodities that are electricity related' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOD.ON', 'Balance of the Day On Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOD.OFF', 'Balance of the Day Off Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOW.ON', 'Balance of the Week On Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOW.OFF', 'Balance of the Week Off Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOM.ON', 'Balance of the Month On Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOM.OFF', 'Balance of the Month Off Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOY.ON', 'Balance of the Year On Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityElectricityQuoteTypes', 'BOY.OFF', 'Balance of the Year Off Peak' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'auditReportRestrictable', 'Restricts viewing access to audit data' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'PropagateBlockTradeChangesAction', 'Name of the action applied to a child trade while propagating changes to block trade.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AllocationSupported', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'Equity', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'Future', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'ETO', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'Bond', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'CreditDefaultSwap', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'BondOption', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'Cash', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'AllocationSupported', 'UnitizedFund', 'Enables Allocation menu item on trade window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSurfaceGenerators', 'CommodityElectricity ', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'interpolatorInflation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'interpolatorInflation', 'InterpolatorInflation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CurveSeasonality.interpolator', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveSeasonality.interpolator', 'InterpolatorSeasDefault', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'SalesMarginHedge Book', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'SalesMarginHedge Book', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddModifyWHTAttribute', 'Allow User to Add/Modify Entry in WithholdingTaxAttribute' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveWHTAttribute', 'Allow User to Remove Entry in WithholdingTaxAttribute' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'WHTAccountAttribute', 'Types of Attribute to be attached to a WithholdingTax Account' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'WHTBookAttribute', 'Types of Attribute to be attached to a WithholdingTax Book' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'WHTLEAttribute', 'Types of Attribute to be attached to a WithholdingTax Legal Entity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'SetCallAccountId', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ProcessAccountInterest', 'Allow User to Process Account Interest from Account Window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTransfer', 'SetAccountMvtDate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'UpdateAccountDormantDates', 'Allow User to Update Dormants Dates from Account Window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ViewCustXferPoSettlementPanel', 'Allow User to View PO Panel in CustomerXfer Trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ViewCustXferXCCYPanel', 'Allow User to View XCCY Panel in CustomerXfer Trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ViewCustXferAdditionalPanel', 'Allow User to View Additional Panel in CustomerXfer Trade' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'MODEL', 'tk.core.PricerMeasure', 322, 'Representation of the pricing model used' )
;
delete from pricer_measure where measure_name ='NPV_CANCEL'  and measure_class_name= 'tk.core.PricerMeasure' and  measure_id =321 and  measure_comment='Npv of the right to cancel a trade'
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_CANCEL', 'tk.core.PricerMeasure', 321, 'Npv of the right to cancel a trade' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH', 'tk.pricer.PricerMeasureCumulativeCash', 309 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH_PRINCIPAL', 'tk.pricer.PricerMeasureCumulativeCash', 314 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH_INTEREST', 'tk.pricer.PricerMeasureCumulativeCash', 311 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH_FEES', 'tk.pricer.PricerMeasureCumulativeCash', 312 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'IMPLIED_IN_RANGE', 'tk.core.PricerMeasure', 315 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'LIQUIDATION_EFFECT', 'tk.core.PricerMeasure', 313 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCRUAL_BS', 'tk.core.PricerMeasure', 316 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REALIZED', 'tk.pricer.PricerMeasureRealized', 317 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ORIGINAL_PREMIUM_DISCOUNT', 'tk.core.PricerMeasure', 320 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCRUAL_REALIZED', 'tk.core.PricerMeasure', 323 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'AVG_PRICE_CLEAN', 'tk.core.PricerMeasure', 324 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'AVG_PRICE_DIRTY', 'tk.core.PricerMeasure', 325 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CDS_PREMIUM', 'tk.core.PricerMeasure', 326 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CLEAN_REALIZED', 'tk.core.PricerMeasure', 327 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CLEAN_UNREALIZED', 'tk.core.PricerMeasure', 328 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FACE_VALUE', 'tk.core.PricerMeasure', 329 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_TOTAL', 'tk.core.PricerMeasure', 330 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_SETTLED', 'tk.core.PricerMeasure', 331 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_UNSETTLED', 'tk.core.PricerMeasure', 332 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NOTIONAL_FACTORED', 'tk.core.PricerMeasure', 333 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NOTIONAL_PAR', 'tk.core.PricerMeasure', 334 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'QUANTITY', 'tk.core.PricerMeasure', 335 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'TOTAL_INTEREST', 'tk.core.PricerMeasure', 336 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'UNSETTLED_QUANTITY', 'tk.core.PricerMeasure', 337 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MARKET_PRICE', 'tk.core.PricerMeasure', 338 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FX_RATE', 'tk.core.PricerMeasure', 339 )
;
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'IGNORE_QUANTO', 'false' )
;
delete from pricing_param_name where param_name='CALL_BPVOL' and param_type='com.calypso.tk.core.Spread' and  param_comment='Call option basis point volatility' and is_global_b=0
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'CALL_BPVOL', 'com.calypso.tk.core.Spread', '', 'Call option basis point volatility', 0 )
;
delete from pricing_param_name where param_name='PUT_BPVOL' and param_type='com.calypso.tk.core.Spread' and  param_comment='Put option basis point volatility' and is_global_b=0
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'PUT_BPVOL', 'com.calypso.tk.core.Spread', '', 'Put option basis point volatility', 0 )
;
delete from pricing_param_name where param_name='BPVOL' and param_type='com.calypso.tk.core.Spread' and  param_comment='Basis point volatility' and  is_global_b=0
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'BPVOL', 'com.calypso.tk.core.Spread', '', 'Basis point volatility', 0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'IGNORE_QUANTO', 'java.lang.Boolean', 'true,false', 'Ignore the quanto effect in pricing', 1, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_BASKET_COMPONENT_PRICING', 'java.lang.Boolean', 'true,false', 'Indicates that the MarketIndex based PerformanceSwapAccrual pricing should use the weighted basket component pricing.', 0, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_YIELD_AMORTIZATION', 'java.lang.Boolean', 'true,false', 'Use yield amortization for calculating bond premium discount', 1, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_ACCOUNTING_BOOK_PROFILE', 'java.lang.Boolean', 'true,false', 'Use accounting book profile for PL', 1, 'true' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventAggLiquidatedPosition', 'AccountingEngine' )
;

begin
add_column_if_not_exists ('trd_rolealloc_hist','rel_trade_version','numeric null');
end; 
/

update trd_rolealloc_hist set trd_rolealloc_hist.rel_trade_version = (select trade_hist.version_num 
from trade_hist where  trd_rolealloc_hist.rel_trade_id= trade_hist.trade_id ) 
where exists (select trade_hist.version_num from trade_hist where trade_hist.trade_id = trd_rolealloc_hist.rel_trade_id) 
;

update trd_rolealloc_hist set initial_amount = amount 
;

DELETE FROM domain_values
WHERE name = 'quoteType'
AND value = 'Future32'
;

INSERT INTO domain_values
VALUES ('quoteType', 'Future32', NULL)
;

UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='002',
        version_date=TO_DATE('26/06/2008','DD/MM/YYYY')
;


