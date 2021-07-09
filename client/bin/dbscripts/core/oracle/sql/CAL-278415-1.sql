
delete from AN_VIEWER_CONFIG where ANALYSIS_NAME='CrossAssetPL' and VIEWER_CLASS_NAME='apps.risk.CrossAssetPLAnalysisViewer'
;


/* This is migration sql script for Oracle for upgrading from Calypso Rel903 to Rel904  */

UPDATE product_desc SET product_sub_type = 'Standard' WHERE product_type = 'Repo' AND product_sub_type = 'Callable'
;
UPDATE product_desc SET product_sub_type = 'Standard' WHERE product_type = 'Repo' AND product_sub_type = 'OpenTerm'
;
UPDATE product_desc SET product_sub_type = 'Standard' WHERE product_type = 'Repo' AND product_sub_type = 'MultiCollateral'
;
UPDATE product_desc SET product_sub_type = 'Triparty' WHERE product_type = 'Repo' AND product_sub_type = 'TripartyOpenTerm'
;
UPDATE product_desc SET product_sub_type = 'BSB' WHERE product_id IN (SELECT product_id FROM product_repo WHERE buysellback_b = 1)
;
insert into engine_config (engine_id, engine_name, engine_comment)
  select distinct -1, 'DiaryEngine', 'Generate Diary Trade in real time'
  from engine_config where not exists (select 1 from engine_config where engine_name = 'DiaryEngine')
;
update engine_config set engine_id = (select max(engine_id) + 1 from engine_config) where engine_name = 'DiaryEngine' and engine_id = -1
;

delete from domain_values where name = 'CommodityAveragingPolicy' and value = 'ATC'
;
delete from domain_values where name = 'CommodityAveragingPolicy' and value = 'CTA'
;
delete from domain_values where name = 'CommodityAveragingPolicy' and value = 'CTAWithFXRoll'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'Collateral', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'InventoryAggregations', 'Inventory Aggregations' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'SecurityLending', 'SecurityLending ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'SimpleTransfer', 'SimpleTransfer ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'PAYDOWN_PD_AMORT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'PAYDOWN_REALIZED_PL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineName', 'DiaryEngine', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'SecurityVersusCash', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'applicationName', 'DiaryEngine', 'DiaryEngine' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityFXAveragingPolicy', 'Custom Commodity FX Averaging Policy' )
;
delete from domain_values where name = 'CommodityFXAveragingPolicy' and value = 'ATC' and description = 'ATC'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingPolicy', 'ATC', 'ATC' )
;
delete from domain_values where name = 'CommodityFXAveragingPolicy' and value = 'CTA' and description = 'CTA'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingPolicy', 'CTA', 'CTA' )
;
delete from domain_values where name = 'CommodityFXAveragingPolicy' and value = 'CTAWithFXRoll' and description = 'CTAWithFXRoll'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingPolicy', 'CTAWithFXRoll', 'CTAWithFXRoll' )
;
delete from domain_values where name = 'CommodityFXAveragingPolicy' and value = 'Cumulative' and description = 'Cumulative'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingPolicy', 'Cumulative', 'Cumulative' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) 
  VALUES ( 'MAPPING_METHOD', 'java.lang.String', 'EXPECTED_LOSS_RATIO,EXPECTED_LOSS,MONEYNESS', 'Specifies the bespoke correlation mapping measure', 1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
  VALUES ( 'CONVERT_CF_TO_BASE_AT_PYMT_DATE', 'java.lang.Boolean', 'true,false', 'If true, converts cashflow amt to PE currency using fx rate on cf pymt date.', 1,
           'CONVERT_CF_TO_BASE_AT_PYMT_DATE', 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) 
  VALUES ( 'FX_RESET_LAG', 'java.lang.Integer', '', 'Number of days to add or subtract to cashflow pymt date.', 1, 'FX_RESET_LAG' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventPriceFixing', 'DiaryEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventProcessTrade', 'DiaryEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventRateReset', 'DiaryEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventTrade', 'DiaryEngine' )
;
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ( 'Back-Office', 'DiaryEngine', 'VerifiedEventFilter' )
;

delete from domain_values where name = 'NDS.subtype' and value = 'CSS'
;
delete from domain_values where name = 'NDS.subtype' and value = 'CCS'
;
insert into domain_values (name,value,description) VALUES ('NDS.subtype','CCS','')
;

delete from calypso_cache where limit_name = 'PricingEnv'
;

insert into calypso_cache (limit,app_name, limit_name, expiration, implementation, eviction) 
  values (100, 'DefaultServer','PricerConfig',0,'Calypso','LFU')
;

insert into calypso_cache (limit,app_name, limit_name, expiration, implementation, eviction) 
  values (100, 'DefaultClient','PricerConfig',0,'NonTransactional','LFU')

;
UPDATE swap_leg SET sample_weekday = 0 WHERE reset_averaging_b = 0
;


/* Update Patch Version */
UPDATE calypso_info
       SET patch_version='004',	
	   patch_date=TO_DATE('29/02/2008 12:00:00','DD/MM/YYYY HH-MI-SS')
;



