 

delete from an_viewer_config where analysis_name='CrossAssetPL' and viewer_class_name='apps.risk.CrossAssetPLAnalysisViewer'
go


/* This is migration sql script for Sybase for upgrading from Calypso Rel903 to Rel904  */


create procedure drop_index
as
begin
declare @indexName varchar(255)
declare drop_indexes_crsr cursor
for
select sysindexes.name from sysindexes ,sysobjects where sysobjects.id=sysindexes.id and sysobjects.name='exsp_quotable_variable' and sysindexes.indid!=0
open drop_indexes_crsr
fetch drop_indexes_crsr into @indexName
while (@@sqlstatus=0)
 begin
   if @indexName='ct_primarykey'
       begin
           execute ('alter table exsp_quotable_variable drop constraint '+ @indexName)
       end
   else
        begin
           execute ('drop index exsp_quotable_variable.'+ @indexName)
        end

   fetch drop_indexes_crsr into @indexName
 End

close drop_indexes_crsr
deallocate cursor drop_indexes_crsr
end
go

exec drop_index
go

drop procedure drop_index
go
                                  

UPDATE product_desc SET product_sub_type = 'Standard' WHERE product_type = 'Repo' AND product_sub_type = 'Callable'
go
UPDATE product_desc SET product_sub_type = 'Standard' WHERE product_type = 'Repo' AND product_sub_type = 'OpenTerm'
go
UPDATE product_desc SET product_sub_type = 'Standard' WHERE product_type = 'Repo' AND product_sub_type = 'MultiCollateral'
go
UPDATE product_desc SET product_sub_type = 'Triparty' WHERE product_type = 'Repo' AND product_sub_type = 'TripartyOpenTerm'
go
UPDATE product_desc SET product_sub_type = 'BSB' WHERE product_id IN (SELECT product_id FROM product_repo WHERE buysellback_b = 1)
go

insert into engine_config (engine_id, engine_name, engine_comment)
  select distinct -1, 'DiaryEngine', 'Generate Diary Trade in real time'
  from engine_config where not exists (select 1 from engine_config where engine_name = 'DiaryEngine')
go

update engine_config set engine_id = (select max(engine_id) + 1 from engine_config) where engine_name = 'DiaryEngine' and engine_id = -1
go
 
delete from domain_values where name = 'CommodityAveragingPolicy' and value = 'ATC'
go
delete from domain_values where name = 'CommodityAveragingPolicy' and value = 'CTA'
go
delete from domain_values where name = 'CommodityAveragingPolicy' and value = 'CTAWithFXRoll'
go


add_domain_values 'disableReportTableFiltering', 'Collateral', '' 
go
add_domain_values   'domainName', 'InventoryAggregations', 'Inventory Aggregations' 
go
add_domain_values   'productTypeReportStyle', 'SecurityLending', 'SecurityLending ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'SimpleTransfer', 'SimpleTransfer ReportStyle' 
go
add_domain_values   'accEventType', 'PAYDOWN_PD_AMORT', '' 
go
add_domain_values   'accEventType', 'PAYDOWN_REALIZED_PL', '' 
go
add_domain_values   'engineName', 'DiaryEngine', '' 
go
add_domain_values   'productType', 'SecurityVersusCash', '' 
go
add_domain_values   'applicationName', 'DiaryEngine', 'DiaryEngine' 
go
add_domain_values   'domainName', 'CommodityFXAveragingPolicy', 'Custom Commodity FX Averaging Policy' 
go
add_domain_values   'CommodityFXAveragingPolicy', 'ATC', 'ATC' 
go
add_domain_values   'CommodityFXAveragingPolicy', 'CTA', 'CTA' 
go
add_domain_values   'CommodityFXAveragingPolicy', 'CTAWithFXRoll', 'CTAWithFXRoll' 
go
add_domain_values   'CommodityFXAveragingPolicy', 'Cumulative', 'Cumulative' 
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) 
  VALUES ( 'MAPPING_METHOD', 'java.lang.String', 'EXPECTED_LOSS_RATIO,EXPECTED_LOSS,MONEYNESS', 'Specifies the bespoke correlation mapping measure', 1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
  VALUES ( 'CONVERT_CF_TO_BASE_AT_PYMT_DATE', 'java.lang.Boolean', 'true,false', 'If true, converts cashflow amt to PE currency using fx rate on cf pymt date.', 1,
           'CONVERT_CF_TO_BASE_AT_PYMT_DATE', 'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) 
  VALUES ( 'FX_RESET_LAG', 'java.lang.Integer', '', 'Number of days to add or subtract to cashflow pymt date.', 1, 'FX_RESET_LAG' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventPriceFixing', 'DiaryEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventProcessTrade', 'DiaryEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventRateReset', 'DiaryEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ( 'Back-Office', 'PSEventTrade', 'DiaryEngine' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ( 'Back-Office', 'DiaryEngine', 'VerifiedEventFilter' )
go

delete from domain_values where name = 'NDS.subtype' and value = 'CSS'
go
add_domain_values'NDS.subtype','CCS','' 
go

delete from calypso_cache where limit_name = 'PricingEnv'
go
insert into calypso_cache (limit,app_name, limit_name, expiration, implementation, eviction) 
  values (100, 'DefaultServer','PricerConfig',0,'Calypso','LFU')
go
insert into calypso_cache (limit,app_name, limit_name, expiration, implementation, eviction) 
  values (100, 'DefaultClient','PricerConfig',0,'NonTransactional','LFU')
go

UPDATE swap_leg SET sample_weekday = 0 WHERE reset_averaging_b = 0
go

/* Update Patch Version */
UPDATE calypso_info
       SET  patch_version='004',
	   version_date='20080229'
go

