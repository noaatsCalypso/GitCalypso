 

if exists (select 1 from sysreferences , sysobjects 
           where sysobjects.id=sysreferences.tableid and 
                 sysobjects.name='calypso_tree_node')
begin 
     execute ('alter table calypso_tree_node drop constraint fk_calypso_tree_node')
end
go      
  

DELETE FROM pricer_measure where measure_name = 'EFFECTIVE_STRIKE'
go
DELETE FROM pricer_measure where measure_name = 'NPV_PAYLEG_NET'
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('NPV_PAYLEG_NET','tk.core.PricerMeasure',211)
go
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('EFFECTIVE_STRIKE','tk.core.PricerMeasure',215) 
go

/* BZ : 52340 - 02-07-2008 */

UPDATE an_param_items SET attribute_name = 'Trade_Attr_Count' 
WHERE attribute_name = 'PL_AttrNamesCount' AND class_name = 'com.calypso.tk.risk.EconomicPLParam' 
go 
     
UPDATE an_param_items SET attribute_name = 'Trade_Attr_Name_' + substring(attribute_name, 14, 10) 
WHERE attribute_name LIKE 'PL_ATTRNAME__%' AND class_name = 'com.calypso.tk.risk.EconomicPLParam' 
go 
     
UPDATE an_param_items SET attribute_name = 'Trade_Attr_Count' 
WHERE attribute_name = 'CA_ColumnNamesCount' 
AND class_name in ( 'com.calypso.tk.risk.CompositeAnalysisParam', 'com.calypso.tk.risk.CrossAssetPLParam') 
go 
     
UPDATE an_param_items SET attribute_name = 'Trade_Attr_Name_' + substring(attribute_name, 15, 10) 
WHERE attribute_name LIKE 'CA_ColumnName_%' 
AND class_name in ( 'com.calypso.tk.risk.CompositeAnalysisParam', 'com.calypso.tk.risk.CrossAssetPLParam') 
go 
/* end */

    
/* Credit Event Notification Date */

add_column_if_not_exists 'cdsbasket_events','effective_date', 'datetime null'
go

UPDATE cdsbasket_events SET effective_date = event_date WHERE effective_date IS NULL
go

 
add_column_if_not_exists 'product_cds','credit_event_effective_date', 'datetime null'
go

UPDATE product_cds SET credit_event_effective_date = credit_event_date WHERE credit_event_effective_date IS NULL
go 

/* End Credit Event Notification Date */


add_domain_values  'function','CreateFeedAddress','Access permission to create a feed address' 
go

add_domain_values 'function','ModifyFeedAddress','Access permission to modify a feed address' 
go

add_domain_values'function','RemoveFeedAddress','Access permission to remove a feed address' 
go


/* drop primary and unique constraints on MIME_TYPE table*/

drop_index_if_exists 'mime_type'
go


/*inserting the values for new column rel_trade_version*/
add_column_if_not_exists 'trade_role_alloc','rel_trade_version', 'numeric null'
go

update trade_role_alloc set trade_role_alloc.rel_trade_version = 
(select trade.version_num from trade where  trade_role_alloc.rel_trade_id= trade.trade_id ) where exists 
(select trade.version_num from trade where trade.trade_id = trade_role_alloc.rel_trade_id)
go

add_column_if_not_exists 'trade_role_alloc' ,'initial_amount', 'Float null'
go

update trade_role_alloc set initial_amount = amount
go


add_domain_values 'principalStructure','Accreting','' 
go

/* renaming the following names:                                */
/* Year end closing rate   -->  Year end closing spot rate      */  
/* Year end reval rate     -->  Year end outright rate          */
/* Month end closing rate  -->  Month end closing spot rate     */
/* Month end reval rate    -->  Month end outright rate         */
/* Yesterday closing rate  -->  Yesterday closing spot rate     */
/* Yesterday reval rate    -->  Yesterday outright rate         */
/* Current rate            -->  Current spot rate               */
/* Current reval rate      -->  Current outright rate           */
/*                                                              */

/* updating TWS's custom formulas */
UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Year__end__closing__rate',column_name),datalength('Year__end__closing__rate'),'Year__end__closing__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Year__end__closing__rate%'
go

UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Year__end__reval__rate',column_name),datalength('Year__end__reval__rate'),'Year__end__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Year__end__reval__rate%'
go

UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Month__end__closing__rate',column_name),datalength('Month__end__closing__rate'),'Month__end__closing__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Month__end__closing__rate%'
go

UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Month__end__reval__rate',column_name),datalength('Month__end__reval__rate'),'Month__end__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Month__end__reval__rate%'
go

UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Yesterday__closing__rate',column_name),datalength('Yesterday__closing__rate'),'Yesterday__closing__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Yesterday__closing__rate%'
go

UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Yesterday__reval__rate',column_name),datalength('Yesterday__reval__rate'),'Yesterday__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Yesterday__reval__rate%'
go

UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Current__rate',column_name),datalength('Current__rate'),'Current__spot__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Current__rate%'
go

UPDATE user_viewer_column
SET    column_name = stuff(column_name,charindex('Current__reval__rate',column_name),datalength('Current__reval__rate'),'Current__outright__rate')
WHERE  column_name like '%Formula%' and uv_usage='CUSTOM_COLS_RF_RiskAggregation' and column_name like '%Current__reval__rate%'
go

/* updating TWS's report templates */

/* year end columns */
UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Year end closing rate',attr_name),datalength('Year end closing rate'),'Year end closing spot rate')
WHERE  attr_name like '%Year end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Year end closing rate',attr_value),datalength('Year end closing rate'),'Year end closing spot rate')
WHERE  attr_value like '%Year end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Year end reval rate',attr_name),datalength('Year end reval rate'),'Year end outright rate')
WHERE  attr_name like '%Year end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Year end reval rate',attr_value),datalength('Year end reval rate'),'Year end outright rate')
WHERE  attr_value like '%Year end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go


/* month end columns */
UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Month end closing rate',attr_name),datalength('Month end closing rate'),'Month end closing spot rate')
WHERE  attr_name like '%Month end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Month end closing rate',attr_value),datalength('Month end closing rate'),'Month end closing spot rate')
WHERE  attr_value like '%Month end closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Month end reval rate',attr_name),datalength('Month end reval rate'),'Month end outright rate')
WHERE  attr_name like '%Month end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Month end reval rate',attr_value),datalength('Month end reval rate'),'Month end outright rate')
WHERE  attr_value like '%Month end reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go


/* yesterday columns */
UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Yesterday closing rate',attr_name),datalength('Yesterday closing rate'),'Yesterday closing spot rate')
WHERE  attr_name like '%Yesterday closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Yesterday closing rate',attr_value),datalength('Yesterday closing rate'),'Yesterday closing spot rate')
WHERE  attr_value like '%Yesterday closing rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Yesterday reval rate',attr_name),datalength('Yesterday reval rate'),'Yesterday outright rate')
WHERE  attr_name like '%Yesterday reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Yesterday reval rate',attr_value),datalength('Yesterday reval rate'),'Yesterday outright rate')
WHERE  attr_value like '%Yesterday reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go


/* current columns */
UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Current rate',attr_name),datalength('Current rate'),'Current spot rate')
WHERE  attr_name like '%Current rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Current rate',attr_value),datalength('Current rate'),'Current spot rate')
WHERE  attr_value like '%Current rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_name = stuff(attr_name,charindex('Current reval rate',attr_name),datalength('Current reval rate'),'Current outright rate')
WHERE  attr_name like '%Current reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go

UPDATE entity_attributes 
SET    attr_value = stuff(attr_value,charindex('Current reval rate',attr_value),datalength('Current reval rate'),'Current outright rate')
WHERE  attr_value like '%Current reval rate%'
       and entity_id in (SELECT template_id FROM report_template where report_type = 'RiskAggregation')
go


SELECT quote_name AS old_name, 'MM' + SUBSTRING(quote_name, 5, CHAR_LENGTH(quote_name)) AS new_name
        INTO cms_index_quote
        FROM rate_index
        WHERE quote_name LIKE 'Swap.%'
go


select * into quote_value_bak2 from quote_value
go
select * into rate_index_bak2 from rate_index
go


UPDATE quote_value
        SET quote_value.quote_name = cms_index_quote.new_name
        FROM quote_value, cms_index_quote
        WHERE quote_value.quote_name = cms_index_quote.old_name
go

UPDATE rate_index
        SET rate_index.quote_name = cms_index_quote.new_name
        FROM rate_index, cms_index_quote
        WHERE rate_index.quote_name = cms_index_quote.old_name
go

DROP TABLE cms_index_quote
go




/* Begin Calibration Name Changes */
if exists (select 1 from sysobjects where name='calibration_template')
begin
exec('sp_rename calibration_template, calibration_instrument')
end
go

if exists (select 1 from sysobjects where name='calibration_template_override')
begin
exec ('sp_rename calibration_template_override, calibration_inst_override')
end
go

if exists (select 1 from sysobjects where name='template_ctx_model_param')
begin
exec('sp_rename template_ctx_model_param, inst_ctx_model_param')
end
go


if exists (select 1 from sysobjects where name='template_ctx_pricer_measure')
begin
exec('sp_rename template_ctx_pricer_measure, inst_ctx_pricer_measure')
end
go


if exists (select 1 from sysobjects where name='template_ctx')
begin
exec('sp_rename template_ctx, instrument_ctx')
end
go


if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'calibration_instrument'
        and syscolumns.name = 'template_index' )
begin
exec sp_rename 'calibration_instrument.template_index' , 'instrument_index'
end
go

if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'calibration_inst_override'
        and syscolumns.name = 'template_index' )
begin
exec sp_rename 'calibration_inst_override.template_index', 'instrument_index'
end
go

if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'inst_ctx_model_param'
        and syscolumns.name = 'template_index' )
begin
exec sp_rename 'inst_ctx_model_param.template_index', 'instrument_index'
end
go

if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'inst_ctx_pricer_measure'
        and syscolumns.name = 'template_index' )
begin
exec sp_rename 'inst_ctx_pricer_measure.template_index', instrument_index
end
go

if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'instrument_ctx'
        and syscolumns.name = 'template_index' )
begin
exec sp_rename 'instrument_ctx.template_index', 'instrument_index'
end
go

if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'instrument_ctx'
        and syscolumns.name = 'template_weight' )
begin
exec sp_rename 'instrument_ctx.template_weight', 'instrument_weight'
end
go


EXEC drop_pk_if_exists 'calibration_instrument'
go

EXEC drop_pk_if_exists 'calibration_inst_override'
go

EXEC drop_pk_if_exists 'inst_ctx_model_param'
go

EXEC drop_pk_if_exists 'inst_ctx_pricer_measure'
go

EXEC drop_pk_if_exists 'instrument_ctx'
go

EXEC drop_index_if_exists 'calibration_instrument'
go

EXEC drop_index_if_exists 'calibration_inst_override'
go

EXEC drop_index_if_exists 'inst_ctx_model_param'
go

EXEC drop_index_if_exists 'inst_ctx_pricer_measure'
go

EXEC drop_index_if_exists 'instrument_ctx'
go
/* End Calibration Name Changes */


/* BZ 53789 */
if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'commodity_fwd_point_generator'
        and syscolumns.name = 'fwdPointDateRule' )
begin
exec sp_rename 'commodity_fwd_point_generator.fwdPointDateRule', 'fwdpointdaterule'
end
go 


if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'commodity_fwd_point_generator'
        and syscolumns.name = 'pillarDateRule' )
begin
exec sp_rename 'commodity_fwd_point_generator.pillarDateRule', 'pillardaterule'
end
go

if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'commodity_fwd_point_generator'
        and syscolumns.name = 'dateFormat' )
begin
exec sp_rename 'commodity_fwd_point_generator.dateFormat', 'dateformat'
end
go

if exists (select 1  from sysobjects , syscolumns
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'commodity_fwd_point_generator'
        and syscolumns.name = 'noOfFwdPoints' )
begin
exec sp_rename 'commodity_fwd_point_generator.noOfFwdPoints', 'nooffwdpoints'
end
go

/* End 53789 */

/* BZ 54265 */
delete from domain_values where name = 'CommodityOTCOption2.Pricer' and value = 'PricerCommodityOTCOption2'
go

update pc_pricer set product_pricer = 'PricerCommodityOTCOption2LTBlack' where product_pricer = 'PricerCommodityOTCOption2'
go



UPDATE cash_settle_dflt
SET    termination_expiration_time=expiry_time, swaption_expiration_time=expiry_time
WHERE  expiry_time != -1 AND expiry_time IS NOT NULL
go

UPDATE cash_settle_dflt
SET    termination_earliest_exer_time=earliest_ex_time, swaption_earliest_exer_time=earliest_ex_time
WHERE  earliest_ex_time != -1 AND earliest_ex_time IS NOT NULL
go



/* 52654 */
add_domain_values 'domainName','CashSettleDefaultsAgreements','' 
go

add_domain_values  'CashSettleDefaultsAgreements','Deutsche Rahmenvertrag','' 
go

add_domain_values  'CashSettleDefaultsAgreements','ISDA','' 
go


/* End 52654 */

add_domain_values  'function', 'ViewUnconsumedEvent', 'AdminFrame Permission to View Unconsumed Event' 
go

/*BZ*/

INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 503, 'NotAllocationChild' )
go
INSERT INTO calypso_seed ( last_id, seed_name ) VALUES ( 1000, 'callAccount' )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'pricer_config', 'pc_calib_def_trade', 'pricer_config_name', 'pricer_config_name', 'PricerConfig', 'NONE' )
go
add_domain_values 'domainName', 'ForwardLadderProduct', 'Products that are supported in Forward Ladder Analysis'  
go
add_domain_values   'domainName', 'TradeRejectAction', 'Actions categorized as Reject' 
go
add_domain_values   'ForwardLadderProduct', 'FX', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXForward', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXSwap', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXNDF', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXTTM', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXSpotReserve', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXOptionForward', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXOptionSwap', '' 
go
add_domain_values   'ForwardLadderProduct', 'FXOption', '' 
go
add_domain_values   'ForwardLadderProduct', 'FutureFX', '' 
go
add_domain_values   'ForwardLadderProduct', 'FutureMM', '' 
go
add_domain_values   'ForwardLadderProduct', 'FutureBond', '' 
go
add_domain_values   'ForwardLadderProduct', 'Cash', '' 
go
add_domain_values   'ForwardLadderProduct', 'SimpleMM', '' 
go
add_domain_values   'ForwardLadderProduct', 'CallNotice', '' 
go
add_domain_values   'ForwardLadderProduct', 'FRA', '' 
go
add_domain_values   'ForwardLadderProduct', 'SimpleTransfer', '' 
go
add_domain_values   'ForwardLadderProduct', 'Swap', '' 
go
add_domain_values   'ForwardLadderProduct', 'PositionCash', '' 
go
add_domain_values   'ForwardLadderProduct', 'CommoditySwap2', '' 
go
add_domain_values   'ForwardLadderProduct', 'CommodityOTCOption2', '' 
go
add_domain_values   'ForwardLadderProduct', 'PreciousMetalDepositLease', '' 
go
add_domain_values   'ForwardLadderProduct', 'PreciousMetalLeaseRateSwap', '' 
go
add_domain_values   'PerformanceSwap.Pricer', 'PricerPerformanceSwapAccrual', 'PerformanceSwap accrual pricer' 
go
add_domain_values   'PerformanceSwap.subtype', 'MarketIndex', 'MarketIndex based PerformanceSwap' 
go
add_domain_values   'domainName', 'PerformanceSwap.subtype', 'PerformanceSwap product subtypes' 
go
add_domain_values   'volSurfaceGenerator', 'FutureOptionBpVol', 'Generates BP vols for FutureOptions' 
go
add_domain_values   'domainName', 'CommoditySettleMethod', 'Commodity Settle Method' 
go
add_domain_values   'rate_index_type', 'Bond', '' 
go
add_domain_values   'domainName', 'creditEventProtocolType', 'Credit Event Protocol Types' 
go
add_domain_values   'creditEventProtocolType', 'Rebate', '' 
go
add_domain_values   'creditEventProtocolType', 'NoRebate', '' 
go
add_domain_values   'creditEventProtocolType', 'Calypso', '' 
go
add_domain_values   'creditEventProtocolType', 'SettleDate', '' 
go
add_domain_values   'domainName', 'VarianceOption.Pricer', 'Pricers for VarianceOption' 
go
add_domain_values   'REPORT.Types', 'CompositeAnalysis', 'Composite Analysis Report' 
go
add_domain_values   'REPORT.Templates', 'default_no_header.html', 'Default HTML Report Template - no header' 
go
add_domain_values   'domainName', 'VarianceOption.subtype', 'VarianceOption subtypes' 
go
add_domain_values   'SingleSwapLeg.Pricer', 'PricerGmc', 'Pricer for exsp based equity linked structures' 
go
add_domain_values   'SingleSwapLeg.Pricer', 'PricerSingleSwapLegDemoExotic', 'Demo pricer for Single Swap Leg for a class of exsp based legs' 
go
add_domain_values   'rateIndexAttributes', 'RATE_INDEX_CODE.T3750', '' 
go
add_domain_values   'rateIndexAttributes', 'RATE_INDEX_CODE.H15', '' 
go
add_domain_values   'workflowRuleTrade', 'TTMCheckAction', 'This rule applies the trade action (cancel) of parent trade to its child SpotReserve trade.' 
go
add_domain_values   'domainName', 'FXOptionBarrier.OptionList', '' 
go
add_domain_values   'FXOptionBarrier.OptionList', 'BARRIER', '' 
go
add_domain_values   'FXOptionBarrier.OptionList', 'DIGITAL', '' 
go
add_domain_values   'FXOptionBarrier.OptionList', 'RANGEACCRUAL', '' 
go

add_domain_values   'workflowRuleTrade', 'CancelRemainderOfPartialExercise', '' 
go
add_domain_values   'productType', 'VarianceOption', 'VarianceOption' 
go
add_domain_values   'CommodityOTCOption2.Pricer', 'PricerCommodityOTCOption2LTBlack', 'Pricer for the CommodityOTCOption2 product' 
go
add_domain_values   'CommodityOTCOption2.Pricer', 'PricerCommodityOTCOption2Clewlow', 'Pricer for the CommodityOTCOption2 product' 
go
add_domain_values   'classAuthMode', 'PeriodDistribution', '' 
go
add_domain_values   'classAuthMode', 'IntradayConfiguration', '' 
go
add_domain_values   'classAuditMode', 'PeriodDistribution', '' 
go
add_domain_values   'classAuditMode', 'IntradayConfiguration', '' 
go
add_domain_values   'workflowRuleTrade', 'NotAllocationChild', 'Returns true if the trade is not allocated from a block trade.' 
go
add_domain_values   'CommoditySettleMethod', 'COMMODITY', 'Commodity Settle Method' 
go
add_domain_values   'Swap.Pricer', 'PricerSwapDemoExotic', '' 
go
add_domain_values   'Swap.Pricer', 'PricerSwapLGM', 'Pricer for a Swap with a Bermudan cancellable schedule.' 
go
add_domain_values   'Bond.Pricer', 'PricerBondDemoExotic', '' 
go
add_domain_values   'FutureMM.Pricer', 'PricerFutureMMBpVol', 'Pricer for FutureOptions using BP vol' 
go
add_domain_values   'VarianceOption.subtype', 'FX', 'FX' 
go
add_domain_values   'VarianceOption.subtype', 'Commodity', 'Commodity' 
go
add_domain_values   'VarianceOption.subtype', 'Equity', 'Equity' 
go
add_domain_values   'VarianceOption.subtype', 'EquityIndex', 'EquityIndex' 
go
add_domain_values   'VarianceOption.Pricer', 'PricerVarianceOptionFX', '' 
go
add_domain_values   'VarianceOption.Pricer', 'PricerVarianceOptionCommodity', '' 
go
add_domain_values   'VarianceOption.Pricer', 'PricerVarianceOptionEquity', '' 
go
add_domain_values   'VarianceOption.Pricer', 'PricerVarianceOptionEquityIndex', '' 
go
add_domain_values   'FXOption.Pricer', 'PricerFXOptionDigitalWBarriers', '' 
go
add_domain_values   'FXOption.Pricer', 'PricerFXOptionForwardStarting', '' 
go
add_domain_values   'domainName', 'EquityLinkedSwap.subtype', '' 
go
add_domain_values   'EquityLinkedSwap.subtype', 'TotalReturn', '' 
go
add_domain_values   'EquityLinkedSwap.subtype', 'PriceReturn', '' 
go
add_domain_values   'EquityLinkedSwap.subtype', 'Dividend', '' 
go
add_domain_values   'FXOption.subtype', 'FWDSTART', '' 
go
add_domain_values   'FXOption.subtype', 'DIGITALWITHBARRIER', '' 
go
add_domain_values   'eventType', 'EX_BSBDATA', '' 
go
add_domain_values   'exceptionType', 'BSBDATA', '' 
go
add_domain_values   'function', 'ModifyMimeTypes', 'Access permission to Modify MIME Types' 
go
add_domain_values   'function', 'ViewOtherTaskStation', 'Access permission to view other users TaskStation' 
go
add_domain_values   'function', 'ViewOnlyGroupTaskStation', 'Access permission to view TaskStation only for users in the same group' 
go

add_domain_values   'restriction', 'ViewOnlyGroupTaskStation', '' 
go
add_domain_values   'principalStructure', 'Accreting', '' 
go
add_domain_values   'scheduledTask', 'NAT_CLEARING_IMPORT', 'Import The National Clearing Directory' 
go
add_domain_values   'scheduledTask', 'CHECK_NAT_CLEARING_DATA', 'Check The National Clearing Directory' 
go
add_domain_values   'scheduledTask', 'ACCOUNT_DORMANT', 'Move accounts to Dormant Status'
go
add_domain_values   'tickSize', '0.01', '' 
go
add_domain_values   'tickSize', '0.04', '' 
go
add_domain_values   'tickSize', '0.1', '' 
go
add_domain_values   'tickSize', '1', '' 
go
add_domain_values   'tickSize', '2', '' 
go
add_domain_values   'tickSize', '4', '' 
go
add_domain_values   'tickSize', '12', '' 
go
add_domain_values   'tickSize', '400', '' 
go
add_domain_values   'tickSize', '1000', '' 
go
add_domain_values   'tickSize', '10000', '' 
go
add_domain_values   'MESSAGE.Templates', 'cds2003Confirm.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'BondTRS_TS_Confirm.html', '' 
go
add_domain_values   'MESSAGE.Templates', 'VarianceOptionConfirmation.html', '' 
go
add_domain_values   'riskPresenter', 'JumpToDefault', '' 
go
add_domain_values   'riskPresenter', 'ResetRisk', 'ResetRisk Analysis' 
go
add_domain_values   'riskPresenter', 'CrossAssetPL', 'CrossAssetPL Analysis' 
go
add_domain_values   'FutureContractAttributes', 'PeakSetting', 'peak settings for electricity future contract' 
go
add_domain_values   'FutureContractAttributes.PeakSetting', 'None', '' 
go
add_domain_values   'FutureContractAttributes.PeakSetting', 'On Peak', '' 
go
add_domain_values   'FutureContractAttributes.PeakSetting', 'Off Peak', '' 
go
add_domain_values   'FutureContractAttributes.PeakSetting', 'Base Load', '' 
go
add_domain_values   'FutureOptionContractAttributes', 'Quote Decimals', 'quote decimals for display' 
go
add_domain_values   'FutureContractAttributes', 'IsDefaultDeliverableFutureContract', 'default deliverable future contract for the commodity - used in certificate pricing' 
go
add_domain_values   'FutureContractAttributes.IsDefaultDeliverableFutureContract', 'Yes', '' 
go
add_domain_values   'FutureContractAttributes.IsDefaultDeliverableFutureContract', 'No', '' 
go
add_domain_values   'productTypeReportStyle', 'ADR', 'ADR ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'AssetPerformanceSwap', 'AssetPerformanceSwap ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'ETOEquity', 'ETOEquity ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'ETOEquityIndex', 'ETOEquityIndex ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'FutureEquity', 'FutureEquity ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'FutureEquityIndex', 'FutureEquityIndex ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'OTCEquityOption', 'OTCEquityOption ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'VarianceSwap', 'VarianceSwap ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'VarianceOption', 'VarianceOption ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'CommodityIndexSwap', 'CommodityIndexSwap ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'EquityLinkedSwap', 'EquityLinkedSwap ReportStyle' 
go
add_domain_values   'CommodityPaymentFrequency', 'FutureContractFND', 'FutureContractFND' 
go
add_domain_values   'domainName', 'CommodityType', 'Supported behavioral types of physically represented Commodities' 
go
add_domain_values   'CommodityType', 'Commodity', 'Commodities' 
go
add_domain_values   'CommodityType', 'Storage Based', 'Commodities that are physically stored at a location for a cost. (ie Agriculture)' 
go
add_domain_values   'CommodityType', 'Vintage Based', 'Commodities that are traded based on vintage year(ie Emmision Credits)' 
go
add_domain_values   'CommodityType', 'Electricity', 'Commodities that are electricity related' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOD.ON', 'Balance of the Day On Peak' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOD.OFF', 'Balance of the Day Off Peak' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOW.ON', 'Balance of the Week On Peak' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOW.OFF', 'Balance of the Week Off Peak' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOM.ON', 'Balance of the Month On Peak' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOM.OFF', 'Balance of the Month Off Peak' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOY.ON', 'Balance of the Year On Peak' 
go
add_domain_values   'CommodityElectricityQuoteTypes', 'BOY.OFF', 'Balance of the Year Off Peak' 
go
add_domain_values   'domainName', 'auditReportRestrictable', 'Restricts viewing access to audit data' 
go
add_domain_values   'domainName', 'PropagateBlockTradeChangesAction', 'Name of the action applied to a child trade while propagating changes to block trade.' 
go
add_domain_values   'domainName', 'AllocationSupported', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'Equity', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'Future', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'ETO', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'Bond', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'CreditDefaultSwap', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'BondOption', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'Cash', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'AllocationSupported', 'UnitizedFund', 'Enables Allocation menu item on trade window' 
go
add_domain_values   'hyperSurfaceGenerators', 'CommodityElectricity ', '' 
go
add_domain_values   'domainName', 'interpolatorInflation', '' 
go
add_domain_values   'interpolatorInflation', 'InterpolatorInflation', '' 
go
add_domain_values   'domainName', 'CurveSeasonality.interpolator', '' 
go
add_domain_values   'CurveSeasonality.interpolator', 'InterpolatorSeasDefault', '' 
go
add_domain_values   'systemKeyword', 'SalesMarginHedge Book', '' 
go
add_domain_values   'tradeKeyword', 'SalesMarginHedge Book', '' 
go
add_domain_values   'function', 'AddModifyWHTAttribute', 'Allow User to Add/Modify Entry in WithholdingTaxAttribute' 
go
add_domain_values   'function', 'RemoveWHTAttribute', 'Allow User to Remove Entry in WithholdingTaxAttribute' 
go
add_domain_values   'domainName', 'WHTAccountAttribute', 'Types of Attribute to be attached to a WithholdingTax Account' 
go
add_domain_values   'domainName', 'WHTBookAttribute', 'Types of Attribute to be attached to a WithholdingTax Book' 
go
add_domain_values   'domainName', 'WHTLEAttribute', 'Types of Attribute to be attached to a WithholdingTax Legal Entity' 
go
add_domain_values   'workflowRuleTrade', 'SetCallAccountId', '' 
go
add_domain_values   'function', 'ProcessAccountInterest', 'Allow User to Process Account Interest from Account Window' 
go
add_domain_values   'workflowRuleTransfer', 'SetAccountMvtDate', '' 
go
add_domain_values   'function', 'UpdateAccountDormantDates', 'Allow User to Update Dormants Dates from Account Window' 
go
add_domain_values   'function', 'ViewCustXferPoSettlementPanel', 'Allow User to View PO Panel in CustomerXfer Trade' 
go
add_domain_values   'function', 'ViewCustXferXCCYPanel', 'Allow User to View XCCY Panel in CustomerXfer Trade' 
go
add_domain_values   'function', 'ViewCustXferAdditionalPanel', 'Allow User to View Additional Panel in CustomerXfer Trade' 
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'MODEL', 'tk.core.PricerMeasure', 322, 'Representation of the pricing model used' )
go

delete from pricer_measure where measure_name ='NPV_CANCEL'  and measure_class_name= 'tk.core.PricerMeasure' and  measure_id =321 and  measure_comment='Npv of the right to cancel a trade'
go

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'NPV_CANCEL', 'tk.core.PricerMeasure', 321, 'Npv of the right to cancel a trade' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH', 'tk.pricer.PricerMeasureCumulativeCash', 309 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH_PRINCIPAL', 'tk.pricer.PricerMeasureCumulativeCash', 314 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH_INTEREST', 'tk.pricer.PricerMeasureCumulativeCash', 311 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUMULATIVE_CASH_FEES', 'tk.pricer.PricerMeasureCumulativeCash', 312 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'IMPLIED_IN_RANGE', 'tk.core.PricerMeasure', 315 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'LIQUIDATION_EFFECT', 'tk.core.PricerMeasure', 313 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCRUAL_BS', 'tk.core.PricerMeasure', 316 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REALIZED', 'tk.pricer.PricerMeasureRealized', 317 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ORIGINAL_PREMIUM_DISCOUNT', 'tk.core.PricerMeasure', 320 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'ACCRUAL_REALIZED', 'tk.core.PricerMeasure', 323 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'AVG_PRICE_CLEAN', 'tk.core.PricerMeasure', 324 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'AVG_PRICE_DIRTY', 'tk.core.PricerMeasure', 325 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CDS_PREMIUM', 'tk.core.PricerMeasure', 326 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CLEAN_REALIZED', 'tk.core.PricerMeasure', 327 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CLEAN_UNREALIZED', 'tk.core.PricerMeasure', 328 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FACE_VALUE', 'tk.core.PricerMeasure', 329 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_TOTAL', 'tk.core.PricerMeasure', 330 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_SETTLED', 'tk.core.PricerMeasure', 331 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FEES_UNSETTLED', 'tk.core.PricerMeasure', 332 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NOTIONAL_FACTORED', 'tk.core.PricerMeasure', 333 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NOTIONAL_PAR', 'tk.core.PricerMeasure', 334 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'QUANTITY', 'tk.core.PricerMeasure', 335 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'TOTAL_INTEREST', 'tk.core.PricerMeasure', 336 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'UNSETTLED_QUANTITY', 'tk.core.PricerMeasure', 337 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MARKET_PRICE', 'tk.core.PricerMeasure', 338 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'FX_RATE', 'tk.core.PricerMeasure', 339 )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ( 'default', 'ANY', 'IGNORE_QUANTO', 'false' )
go

delete from pricing_param_name where param_name='CALL_BPVOL' and param_type='com.calypso.tk.core.Spread' and  param_comment='Call option basis point volatility' and is_global_b=0
go

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'CALL_BPVOL', 'com.calypso.tk.core.Spread', '', 'Call option basis point volatility', 0 )
go

delete from pricing_param_name where param_name='PUT_BPVOL' and param_type='com.calypso.tk.core.Spread' and  param_comment='Put option basis point volatility' and is_global_b=0
go

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'PUT_BPVOL', 'com.calypso.tk.core.Spread', '', 'Put option basis point volatility', 0 )
go

delete from pricing_param_name where param_name='BPVOL' and param_type='com.calypso.tk.core.Spread' and  param_comment='Basis point volatility' and  is_global_b=0
go

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'BPVOL', 'com.calypso.tk.core.Spread', '', 'Basis point volatility', 0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'IGNORE_QUANTO', 'java.lang.Boolean', 'true,false', 'Ignore the quanto effect in pricing', 1, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_BASKET_COMPONENT_PRICING', 'java.lang.Boolean', 'true,false', 'Indicates that the MarketIndex based PerformanceSwapAccrual pricing should use the weighted basket component pricing.', 0, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_YIELD_AMORTIZATION', 'java.lang.Boolean', 'true,false', 'Use yield amortization for calculating bond premium discount', 1, 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_ACCOUNTING_BOOK_PROFILE', 'java.lang.Boolean', 'true,false', 'Use accounting book profile for PL', 1, 'true' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventAggLiquidatedPosition', 'AccountingEngine' )
go


add_column_if_not_exists 'trd_rolealloc_hist','rel_trade_version', 'numeric null'
go


update trd_rolealloc_hist set trd_rolealloc_hist.rel_trade_version = (select trade_hist.version_num 
from trade_hist where  trd_rolealloc_hist.rel_trade_id= trade_hist.trade_id ) 
where exists (select trade_hist.version_num from trade_hist where trade_hist.trade_id = trd_rolealloc_hist.rel_trade_id) 
go

add_column_if_not_exists 'trd_rolealloc_hist','initial_amount', 'Float null'
go

update trd_rolealloc_hist set initial_amount = amount
go

DELETE FROM domain_values
WHERE name = 'quoteType'
AND value = 'Future32'
go

add_domain_values 'quoteType', 'Future32', NULL
go

UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='002',
        version_date='20080626'
go




