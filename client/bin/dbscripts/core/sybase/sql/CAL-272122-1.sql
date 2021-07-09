if not exists (select 1 from sysobjects where name='strategy_template_member' and type='U')
begin
exec ('create table strategy_template_member (strategy_template_id numeric not null,
			template_name varchar(64) not null ,
			product_type varchar(32) not null, 
			product_subtype varchar(32) not null, 
			template_order numeric not null)')
end
go

update strategy_template_member  set product_subtype='European' where product_type = 'Swaption' and (product_subtype = 'Standard' or product_subtype = 'NONE')
go
insert into scenario_quoted_product values ('FutureStructuredFlows', 'FUTURE_FROM_QUOTE', 'INSTRUMENT_SPREAD')
go

if not exists (select 1 FROM sysobjects o , syscolumns c WHERE o.name='official_pl_config' and c.name='is_aggregateinactivemarks' and o.id=c.id)           
			  begin
                 exec ('select * into official_pl_config_back151 from official_pl_config')
                 exec ('alter table official_pl_config  add  is_aggregateinactivemarks numeric default 1 null') 
               end
go
CREATE  procedure official_pl_inact_update AS
   begin
declare
  c1 cursor for 
		 select  commonpl_config.attribute_value from an_param_items  commonpl_config,
         (select * from an_param_items where attribute_name = 'Aggregate Inactive Marks' ) tmp_inactive_mark
         where commonpl_config.param_name = tmp_inactive_mark.param_name and commonpl_config.class_name = tmp_inactive_mark.class_name 
         and commonpl_config.attribute_name = 'PL_END_PL_CONFIG' and  tmp_inactive_mark.attribute_value  is null
				open c1
				declare @an_profile_name_1 varchar(200) , @sql_stmt varchar(500)
				fetch c1 into @an_profile_name_1
				while (@@sqlstatus = 0)
					begin
				select @sql_stmt = 'update official_pl_config set is_aggregateinactivemarks =0 where config_name='||char(39)||@an_profile_name_1||char(39)
					EXEC (@sql_stmt)
				end 
fetch c1 into @an_profile_name_1			 
       		close c1
			deallocate cursor c1 
  end
go
if not exists (select 1 FROM sysobjects o , syscolumns c WHERE o.name='official_pl_config' and c.name='is_aggregateinactivemarks' and o.id=c.id)           
			  begin
/* begin */

                 exec ('official_pl_inact_update')
               end
go
 
drop procedure  official_pl_inact_update
go


insert into scenario_quoted_product values ('FutureFX', 'FUTURE_FROM_QUOTE', 'INSTRUMENT_SPREAD')
go

create procedure update_xccy_swap
as
BEGIN
declare  @act_initial_exch_b numeric
declare @product_id numeric
declare c1 cursor
for
select distinct p.product_id , s.act_initial_exch_b from product_swap p , swap_leg s ,xccy_swap_ext_info x
where p.product_id = x.product_id and s.product_id = x.product_id
open c1
fetch c1 into @product_id , @act_initial_exch_b
while (@@sqlstatus = 0)
begin
update xccy_swap_ext_info set adj_first_flw_b = 0 where product_id = @product_id and @act_initial_exch_b=0
fetch c1 into @product_id , @act_initial_exch_b
end
close c1
deallocate cursor c1
end
go

exec update_xccy_swap
go
drop procedure update_xccy_swap
go




/*diff */

INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (832,'CheckLimits' )
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('TransferMargin','When True, transfers the margin out of the sales book during PKS FX trade routing.' )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SingleSwapLeg','com.calypso.apps.trading.CSATabTradeWindow',0 )
go

INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (421008,'OMSEngine','Engine to connect to ullink' )
go
INSERT INTO engine_param ( engine_name, param_name, param_value ) VALUES ('OMSEngine','CLASS_NAME','com.calypso.engine.oms.OMSEngine' )
go
INSERT INTO engine_param ( engine_name, param_name, param_value ) VALUES ('OMSEngine','DISPLAY_NAME','OMS Engine' )
go
INSERT INTO engine_param ( engine_name, param_name, param_value ) VALUES ('OMSEngine','INSTANCE_NAME','engineserver' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SMILE_ADJ','tk.core.PricerMeasure',458,'Contribution of smile to PV. Usually the result of the difference PV - TV.' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('QUOTE_TYPE_PRICE','tk.core.PricerMeasure',466,'Used for bond. The price which matches the format of the quote type of bond.' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES ('INCLUDE_YIELD_CONVEXITY','java.lang.Boolean','true,false',' A boolean used to adjust the forward yield(s) to include convexity','INCLUDE_YIELD_CONVEXITY','false',0 )
go
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ('PRODUCT_TEMPLATE','string',0,0,0,'Bond',0 )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventLifeCycle','OMSEngine' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','OMSEngine','OMSEngineEventFilter' )
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (604,1,'product_warrant','product_id','1','sd_filter','Warrant','apps.trading.TradeWarrantWindow','Warrant' )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (3650,'OfficialPL',0,0,0 )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (3750,'OfficialPLRunStatus',0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (829,'DecSuppOrder','SIMULATED','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (830,'DecSuppOrder','LIMIT_VIOLATION','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (831,'DecSuppOrder','LIMIT_VIOLATION','AUTHORIZE','PENDING',1,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (832,'DecSuppOrder','LIMIT_VIOLATION','MANUAL_AUTHORIZE','PENDING',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (833,'DecSuppOrder','PARTIAL_EXEC','EXECUTE','EXECUTED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (834,'DecSuppOrder','PENDING','REJECT','REJECTED',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (835,'DecSuppOrder','PENDING','SEND','SENT',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (836,'DecSuppOrder','REJECTED','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (837,'DecSuppOrder','SENT','ACK','SENT',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (838,'DecSuppOrder','SENT','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (839,'DecSuppOrder','SENT','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (840,'DecSuppOrder','SENT','EXECUTE','EXECUTED',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (841,'DecSuppOrder','SENT','PARTIAL_EXECUTE','PARTIAL_EXEC',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (842,'DecSuppOrder','SENT','REJECT','REJECTED',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (843,'DecSuppOrder','SIMULATED','SEND_TO_MARKET','LIMIT_VIOLATION',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (845,'DecSuppOrder','PARTIAL_EXEC','PARTIAL_EXECUTE','PARTIAL_EXEC',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (846,'DecSuppOrder','PARTIAL_EXEC','AMEND','PARTIAL_EXEC',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (847,'DecSuppOrder','EXECUTED','AMEND','EXECUTED',0,1,'ALL','ALL',0,0,1,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (848,'DecSuppOrder','REJECTED','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
go
add_domain_values 'domainName','creAttribute','additional attributes for cre' 
go
add_domain_values 'creAttribute','ISIN','' 
go
add_domain_values 'creAttribute','CounterParty','' 
go
add_domain_values 'creAttribute','BUY/SELL','' 
go
add_domain_values 'creAttribute','FONumber','' 
go
add_domain_values 'creAttribute','AccountingBook','' 
go
add_domain_values 'creAttribute','MarketType','' 
go
add_domain_values 'creAttribute','CptyRole','' 
go
add_domain_values 'ProcessingConfig','ETDClearing.IsActive','false' 
go
add_domain_values 'ProcessingConfig','ETDClearing.SecurityTransferGeneration','false' 
go
add_domain_values 'ProcessingConfig','ETDClearing.ClearingAccountTransferGeneration','true' 
go
add_domain_values 'feeDefinitionAttributes','MarginCall' ,''
go
add_domain_values 'feeDefinitionAttributes','ETD.InventoryBucket' ,''
go
add_domain_values 'feeDefinitionAttributes.ETD.InventoryBucket','Fees' ,''
go
add_domain_values 'feeDefinitionAttributes.ETD.InventoryBucket','Commissions' ,''
go
add_domain_values 'feeDefinitionAttributes.MarginCall','Always' ,''
go
add_domain_values 'feeDefinitionAttributes.MarginCall','Never' ,''
go
add_domain_values 'feeDefinitionAttributes.MarginCall','Account Level' ,''
go
add_domain_values 'feeDefinitionAttributes','MarginCall.Category' ,''
go
add_domain_values 'feeDefinitionAttributes','Duplicate Fee Transfer' ,''
go
add_domain_values 'inMemoryRiskServer','inmemoryriskserver' ,''
go
add_domain_values 'domainName','InventoryCashBucketFactory','' 
go
add_domain_values 'InventoryCashBucketFactory','ETD','New position balance type by transfer type for ETD' 
go
add_domain_values 'engineParam','XFER_POS_AGGREGATION_NAME','Name of the Position Aggregation to use for TransferEngine gen' 
go
add_domain_values 'workflowRuleTrade','ApplyRestatement','' 
go
add_domain_values 'FXVolSurfaceGenerator','Spread_Default','Generator based on a spread oven an existing surface' 
go
add_domain_values 'FXVolSurfaceGenerator','ReplicationHedge','Correlation based surface generator based on replication hedge' 
go
add_domain_values 'FXVolSurfaceGenerator','GaussianCopula','Correlation based surface generator based on Gaussian Copula' 
go
add_domain_values 'domainName','accountSubType','SubType of Account' 
go
add_domain_values 'classAuditMode','TradeKeywordConfig','' 
go
add_domain_values 'volatilityType','DIVIDEND','' 
go
add_domain_values 'volatilityType','EquityVolatilityIndex','' 
go
add_domain_values 'futureUnderType','DividendIndex','' 
go
add_domain_values 'futureOptUnderType','DividendIndex','' 
go
add_domain_values 'ExternalMessageField.MessageMapper','MT306','' 
go
add_domain_values 'tradeKeyword','IsUpFrontFeeRounded','Indicates whether Upfront fee needs to be rounded or not rounded' 
go
add_domain_values 'scheduledTask','OFFICIALPLARCHIVEMARKS','OfficialPLAnalysis Archive Marks/Purge Greeks.' 
go
add_domain_values 'tradeAction','RESTATE','' 
go
add_domain_values 'productType','FutureOptionDividendIndex','FutureOptionDividendIndex' 
go
add_domain_values 'productType','FutureDividendIndex','FutureDividendIndex' 
go
add_domain_values 'domainName','keyword.RestatementVersion','' 
go
add_domain_values 'userAccessPermAttributes','Max.GenericComment','Type to be enforced by reports' 
go
add_domain_values 'accountSubType','Clearing','Clearing Account' 
go
add_domain_values 'accountSubType','Security','' 
go
add_domain_values 'accountSubType','None','' 
go
add_domain_values 'corporateActionType','TRANSFORMATION.WRITE_DOWN','' 
go
add_domain_values 'corporateActionType','TRANSFORMATION.WRITE_UP','' 
go
add_domain_values 'CA.subtype','WRITE_DOWN','' 
go
add_domain_values 'CA.subtype','WRITE_UP','' 
go
add_domain_values 'eventClass','PSEventOfficialPL','' 
go
add_domain_values 'function','ModifyTradeKeywordFavorite','Access permission to Create/Modify Trade Keyword Favorite Domains' 
go
add_domain_values 'productType','FutureEquity','' 
go
add_domain_values 'sortMethod','SettleTradeDatePS','' 
go
add_domain_values 'domainName','KeywordType','Specify list of Type supported in TradeKeyword' 
go
add_domain_values 'KeywordType','Account','' 
go
add_domain_values 'KeywordType','Boolean','' 
go
add_domain_values 'KeywordType','Double','' 
go
add_domain_values 'KeywordType','Integer','' 
go
add_domain_values 'KeywordType','JDate','' 
go
add_domain_values 'KeywordType','JDatetime','' 
go
add_domain_values 'KeywordType','LegalEntity','' 
go
add_domain_values 'KeywordType','Long','' 
go
add_domain_values 'KeywordType','String','' 
go
add_domain_values 'ETOContractAttributes','PremiumPaymentConvention','convention for the premium payment' 
go
add_domain_values 'ETOContractAttributes.PremiumPaymentConvention','Conventional','' 
go
add_domain_values 'ETOContractAttributes.PremiumPaymentConvention','VariationMargined','' 
go
add_domain_values 'productInterfaceReportStyle','LegalAgreementHolder','LegalAgreementHolder ReportStyle' 
go
add_domain_values 'sdFilterCriterion.Factory','ListedContractAttribute','build Corporate Action Static Data Filter criteria' 
go
add_domain_values 'pricingScriptProductBase','BondExoticNote','' 
go
add_domain_values 'function','Archive Purge of OfficialPL Marks','Allow User to archive or purge OfficialPL Marks' 
go
add_domain_values 'domainName','DividendIndex.subtype','DividendIndex product subtypes' 
go
add_domain_values 'DividendIndex.subtype','EquityIndex','DividendIndex based EquityIndex' 
go
add_domain_values 'PricingSheetMeasures','SMILE_ADJ' ,''
go
add_domain_values 'mktDataVisuType.Volatility','FXVolatilitySpreadSurface','' 
go
add_domain_values 'mktDataVisuType.Volatility','FXVolatilityCorrelationSurface','' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'domainName','PositionKeeping.TransferMargin','If False, margin remains in the sales book, not transferred to risk taking books' 
go
add_domain_values 'PositionKeeping.TransferMargin','False' ,''
go
add_domain_values 'domainName','PositionKeeping.CancelActions','All actions besides CANCEL that should be treated as trade cancelations in PKS' 
go
add_domain_values 'domainName','PositionKeeping.SplitActions','All actions besides SPLIT that should be treated as trade splits in PKS' 
go
add_domain_values 'domainName','PositionKeeping.TradeKeywordsToPropagate','All keywords from main trade to be propagated to the routed trades.' 
go
add_domain_values 'domainName','PositionKeeping.GlobalDayChangeRule','Day change rule for PKS. Defaults to ''FX''' 
go
add_domain_values 'domainName','PositionKeeping.GlobalRiskCurrency','Global risk currency defined for PKS. Defaults to USD, if undefined.' 
go
add_domain_values 'domainName','PositionKeeping.DefaultTradeRegion','Default trade region to be used for routing.' 
go
add_domain_values 'domainName','PositionKeeping.DefaultTradePlatform','Default trade platform for routing.' 
go
add_domain_values 'domainName','ManualPartyName','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','manualSDITAG','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','manualSDITAG.70','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','manualSDITAG.71A','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','manualSDITAG.72','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','beneficiaryIdentifierPrefixes','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','agentIdentifierPrefixes','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','intermediary1IdentifierPrefixes','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','intermediary2IdentifierPrefixes','Domain used by Cash Manual SDI' 
go
add_domain_values 'domainName','remitterIdentifierPrefixes','Domain used by Cash Manual SDI' 
go
add_domain_values 'DecSuppOrderStatus','LIMIT_VIOLATION','Order Status' 
go
add_domain_values 'DecSuppOrderStatus','EXECUTED','Order Status' 
go
add_domain_values 'DecSuppOrderStatus','PARTIAL_EXEC','Order Status' 
go
add_domain_values 'DecSuppOrderStatus','PENDING','Order Status' 
go
add_domain_values 'DecSuppOrderStatus','REJECTED','Order Status' 
go
add_domain_values 'DecSuppOrderStatus','SENT','Order Status' 
go
add_domain_values 'DecSuppOrderAction','ACK','Action on order' 
go
add_domain_values 'DecSuppOrderAction','AMEND','Action on order' 
go
add_domain_values 'DecSuppOrderAction','AUTHORIZE','Action on order' 
go
add_domain_values 'DecSuppOrderAction','EXECUTE','Action on order' 
go
add_domain_values 'DecSuppOrderAction','MANUAL_AUTHORIZE','Action on order' 
go
add_domain_values 'DecSuppOrderAction','PARTIAL_EXECUTE','Action on order' 
go
add_domain_values 'DecSuppOrderAction','REJECT','Action on order' 
go
add_domain_values 'DecSuppOrderAction','SEND','Action on order' 
go
add_domain_values 'DecSuppOrderAction','SEND_TO_MARKET','Action on order' 
go
add_domain_values 'engineName','OMSEngine','Engine to connect to ullink' 
go
add_domain_values 'eventFilter','OMSEngineEventFilter','filter for Security Claim Transfer' 
go
add_domain_values 'classAuditMode','DecSuppOrder','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','AssetSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSABSIndex','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSABSIndexTranche','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSIndex','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSIndexDefinition','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSIndexOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSIndexTranche','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSIndexTrancheOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSNthDefault','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CDSNthLoss','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CFDConvertibleArbitrage','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CFDDirectional','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CFDPairTrading','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CFDRiskArbitrage','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CancellableCDS','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CancellableCDSNthDefault','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CancellableCDSNthLoss','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CancellableSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CancellableXCCySwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CapFloor','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CappedSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommodityCapFloor','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommodityCertificate','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommodityForward','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommodityIndexSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommodityOTCOption2','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommoditySwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommoditySwap2','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CommoditySwaption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CreditDefaultSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CreditDefaultSwapABS','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CreditDefaultSwapLoan','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CreditDefaultSwaption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CreditDrawDown','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CreditFacility','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','CreditTranche','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','ETOCommodity','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','ExtendibleCDS','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','ExtendibleCDSNthDefault','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','ExtendibleCDSNthLoss','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','ExtendibleSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FRA','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXCompoundOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXForward','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXForwardStart','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXNDF','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXNDFSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXOptionForward','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXOptionStrategy','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXOptionStrip','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXOptionSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXOrder','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXSpotReserve','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FXSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','GenericOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','IRStructuredOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','OTCCommodityOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','OTCEquityOption','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','OTCEquityOptionVanilla','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','PerformanceSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','PortfolioSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','PortfolioSwapPosition','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','PositionCash','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','PositionFXExposure','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','PositionFXNDF','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','RateIndexProduct','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','ScriptableOTCProduct','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','SkewSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','SpreadSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','TotalReturnSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','XCCySwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureBond','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureCDSIndex','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureCommodity','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureDividend','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureDividendIndex','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureEquity','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureEquityIndex','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureFX','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureMM','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionBond','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionCommodity','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionDividend','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionDividendIndex','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionEquity','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionEquityIndex','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionMM','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureOptionVolatility','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureStructuredFlows','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureSwap','' 
go
add_domain_values 'perfMeasurement.Exposure.Notional','FutureVolatility','' 
go
add_domain_values 'CurveBasis.gen' ,'DoubleGlobal' ,'Generate two curves together. Requires multiple curve window.'
go
add_domain_values 'CurveBasis.gen','DoubleGlobalM','Generate two curves together. Requires multiple curve window.'
go
add_domain_values 'CurveBasis.gen','TripleGlobal','Generate three curves together. Requires multiple curve window.'
go
add_domain_values 'CurveZero.gen','DoubleGlobalM','Generate two curves together. Requires multiple curve window.'
go
/* end */
UPDATE product_tlock SET settlement_type='CASH_SETTLE_DIRTY_PRICE' WHERE settlement_type='CASH_SETTLE_PRICE'
go
INSERT INTO pricing_param_name ( 
	param_name, param_type, param_domain, param_comment, is_global_b, default_value ) 
	VALUES ( 'STUB_FORECAST_ADJ', 'java.lang.Boolean', 'true,false', 'Param controls stub tenor forecast curve retrieval', 1, 'false' )
go


exec rename_column_if_exists 'benchmark','publish_frequency','publish_holidays'
go
exec rename_column_if_exists 'benchmark','publish_holiday','publish_frequency'
go


if exists (select 1 from sysobjects where name = 'billing_fee_def' and type='P') 
begin 
exec('DROP PROCEDURE billing_fee_def')
end
go
create procedure billing_fee_def
as
begin
declare c1 cursor for select distinct value from domain_values where name='BillingFeeType' and value not in (select fee_type from fee_definition)
declare @amount_type_count int
declare @billing_fee_type varchar(64)
declare @fee_type_count int

       begin
              select @amount_type_count=count(*) from domain_values where name='BillingFeeType' and value='AMOUNT'    
              if (@amount_type_count = 0)
              insert into domain_values (name,value,description) values('BillingFeeType','AMOUNT','')
       open c1
              fetch c1 into @billing_fee_type
       while (@@sqlstatus = 0)
              begin
              select @fee_type_count=count(fee_type)  from fee_definition
              insert into fee_definition (fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, fee_code, def_calculator, product_list, version_num, offset_days, offset_business_b, is_allocated)
                values (CONVERT(VARCHAR(32),@billing_fee_type), null, 0, 0 , 'CounterParty', 0, 0 , @fee_type_count, null, null, 0, 0 ,0 ,0)
       fetch c1 into @billing_fee_type
              end
              close c1
              deallocate cursor c1
              delete from domain_values where name='BillingFeeType'
              delete from domain_values where name='domainName' and value = 'BillingFeeType'
       end
end
go
exec billing_fee_def
go
drop proc billing_fee_def
go
add_column_if_not_exists 'cfd_detail','trading_gain_pay_meth','varchar(16) null'
go

update cfd_detail set trading_gain_pay_meth = 'Effective Date' where trading_gain_pay_meth is null
go

update sched_task_attr set attr_name = 'Calculation Server Names' where attr_name= 'Calculation Server Name'
go

update referring_object
set rfg_tbl_sel_cols = 'risk_config_name,analysis_name,trade_filter_name,pricing_env_name,param_name,view_name',
rfg_tbl_sel_types = '2,2,2,2,2,2'
where rfg_tbl_name = 'risk_config_item'
and rfg_tbl_join_cols = 'trade_filter_name'
go

/* CAL-271497 : set the value of the new status column to MOD on TAX_INFO records with the modif_date is set */
if exists (select 1 from sysobjects where type='U' and name='liq_tax_hist')
begin
declare @vsql1 varchar(200)
begin
select @vsql1 = 'update liq_tax_hist set status = '||char(39)||'MOD'||char(39)||' where status='||char(39)||'NEW'||char(39)||' and modif_date IS NOT NULL'
exec (@vsql1)
end
end
go

if exists(select 1 from sysobjects where type='U' and name='liq_tax_hist')
begin
declare @vsql1 varchar(200)
begin
select @vsql1 = 'update liq_tax_hist set status = '||char(39)||'MOD'||char(39)||' where status='||char(39)||'NEW'||char(39)||' and modif_date IS NOT NULL'
exec (@vsql1)
end
end
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=4,
        sub_version=0,
        patch_version='003',
        version_date='20150930'
go 

