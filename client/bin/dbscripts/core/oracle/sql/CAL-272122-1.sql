		CREATE OR REPLACE PROCEDURE add_strategy_if_not_exist
    (tab_name IN varchar2)
      
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER(tab_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        execute immediate 'create table '|| tab_name ||' (strategy_template_id numeric not null,
			template_name varchar(64) not null ,
			product_type varchar(32) not null, 
			product_subtype varchar(32) not null, 
			template_order numeric not null)';

                               
                                                 

   END IF;
END;
/
begin
 add_strategy_if_not_exist ('strategy_template_member');
end;
/

update strategy_template_member  set product_subtype='European' where product_type = 'Swaption' and (product_subtype = 'Standard' or product_subtype = 'NONE')
;
 


CREATE OR REPLACE PROCEDURE  official_pl_inact_update AS
    begin
        declare 
         cursor c1 is  select  commonpl_config.attribute_value configName from   an_param_items  commonpl_config,
         (select * from an_param_items where attribute_name = 'Aggregate Inactive Marks' ) tmp_inactive_mark
         where commonpl_config.param_name = tmp_inactive_mark.param_name (+)
         and commonpl_config.class_name = tmp_inactive_mark.class_name (+)
         and commonpl_config.attribute_name = 'PL_END_PL_CONFIG'
         and  tmp_inactive_mark.attribute_value  is null;
         an_profile_name_1   varchar2(400);
         l_single_quote CHAR(1) := '''';
         an_profile_name_2   varchar2(400);
         sql_stmt  VARCHAR2(200);
         x number;           
         begin   
      
			  select count(*) INTO x FROM user_tab_columns WHERE table_name='OFFICIAL_PL_CONFIG' and column_name='IS_AGGREGATEINACTIVEMARKS';           
              if x=0 then              
                 EXECUTE IMMEDIATE 'create table official_pl_config_back151 as select * from OFFICIAL_PL_CONFIG';
                 EXECUTE IMMEDIATE 'alter table OFFICIAL_PL_CONFIG  add  IS_AGGREGATEINACTIVEMARKS NUMBER(1) DEFAULT 1'; 
                 open c1;
				fetch c1 into an_profile_name_1;
				while c1%FOUND loop
					an_profile_name_2:= l_single_quote||an_profile_name_1||l_single_quote;
					sql_stmt := 'UPDATE OFFICIAL_PL_CONFIG set IS_AGGREGATEINACTIVEMARKS =0 where config_name='||an_profile_name_2;
					EXECUTE IMMEDIATE   sql_stmt;
				fetch c1 into an_profile_name_1;
				end loop;
             else
				dbms_output.put_line (' OFFICIAL_PL_CONFIG has IS_AGGREGATEINACTIVEMARKS column' );
             end if;
				      if c1%isopen then
        close c1;
       end if;

        exception
                when others then 
				      if c1%isopen then
        close c1;
       end if;

                dbms_output.put_line (' OFFICIAL_PL_CONFIG has IS_AGGREGATEINACTIVEMARKS column updation failed' );
		end;      
   end; 
/ 
BEGIN
   official_pl_inact_update;
end;       
/
drop procedure official_pl_inact_update
;
insert into scenario_quoted_product values ('FutureFX', 'FUTURE_FROM_QUOTE', 'INSTRUMENT_SPREAD')
;

create or replace procedure update_xccy_swap
is
begin
declare
cursor c1 is
select distinct p.product_id , x.pay_side_reset_b ,p.pay_leg_id , p.receive_leg_id ,s.ACT_INITIAL_EXCH_B from product_swap p , swap_leg s ,XCCY_SWAP_EXT_INFO x
where p.product_id = x.product_id and s.product_id = x.product_id;
begin
for c1_rec in c1 LOOP
begin
update XCCY_SWAP_EXT_INFO set adj_first_flw_b = 0 where product_id = c1_rec.product_id and c1_rec.ACT_INITIAL_EXCH_B=0;
end;
end loop;
end;
end;
/
begin
update_xccy_swap;
end;
/
drop procedure update_xccy_swap
;

/* diff */
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (832,'CheckLimits' )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('TransferMargin','When True, transfers the margin out of the sales book during PKS FX trade routing.' )
;
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SingleSwapLeg','com.calypso.apps.trading.CSATabTradeWindow',0 )
;
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (421008,'OMSEngine','Engine to connect to ullink' )
;
INSERT INTO engine_param ( engine_name, param_name, param_value ) VALUES ('OMSEngine','CLASS_NAME','com.calypso.engine.oms.OMSEngine' )
;
INSERT INTO engine_param ( engine_name, param_name, param_value ) VALUES ('OMSEngine','DISPLAY_NAME','OMS Engine' )
;
INSERT INTO engine_param ( engine_name, param_name, param_value ) VALUES ('OMSEngine','INSTANCE_NAME','engineserver' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SMILE_ADJ','tk.core.PricerMeasure',458,'Contribution of smile to PV. Usually the result of the difference PV - TV.' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('QUOTE_TYPE_PRICE','tk.core.PricerMeasure',466,'Used for bond. The price which matches the format of the quote type of bond.' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES ('INCLUDE_YIELD_CONVEXITY','java.lang.Boolean','true,false',' A boolean used to adjust the forward yield(s) to include convexity','INCLUDE_YIELD_CONVEXITY','false',0 )
;
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ('PRODUCT_TEMPLATE','string',0,0,0,'Bond',0 )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventLifeCycle','OMSEngine' )
;
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','OMSEngine','OMSEngineEventFilter' )
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (604,1,'product_warrant','product_id','1','sd_filter','Warrant','apps.trading.TradeWarrantWindow','Warrant' )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (3650,'OfficialPL',0,0,0 )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (3750,'OfficialPLRunStatus',0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (829,'DecSuppOrder','SIMULATED','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (830,'DecSuppOrder','LIMIT_VIOLATION','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (831,'DecSuppOrder','LIMIT_VIOLATION','AUTHORIZE','PENDING',1,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (832,'DecSuppOrder','LIMIT_VIOLATION','MANUAL_AUTHORIZE','PENDING',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (833,'DecSuppOrder','PARTIAL_EXEC','EXECUTE','EXECUTED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (834,'DecSuppOrder','PENDING','REJECT','REJECTED',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (835,'DecSuppOrder','PENDING','SEND','SENT',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (836,'DecSuppOrder','REJECTED','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (837,'DecSuppOrder','SENT','ACK','SENT',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (838,'DecSuppOrder','SENT','AMEND','SIMULATED',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (839,'DecSuppOrder','SENT','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (840,'DecSuppOrder','SENT','EXECUTE','EXECUTED',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (841,'DecSuppOrder','SENT','PARTIAL_EXECUTE','PARTIAL_EXEC',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (842,'DecSuppOrder','SENT','REJECT','REJECTED',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (843,'DecSuppOrder','SIMULATED','SEND_TO_MARKET','LIMIT_VIOLATION',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (845,'DecSuppOrder','PARTIAL_EXEC','PARTIAL_EXECUTE','PARTIAL_EXEC',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (846,'DecSuppOrder','PARTIAL_EXEC','AMEND','PARTIAL_EXEC',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (847,'DecSuppOrder','EXECUTED','AMEND','EXECUTED',0,1,'ALL','ALL',0,0,1,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (848,'DecSuppOrder','REJECTED','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
;
begin
add_domain_values ('domainName','creAttribute','additional attributes for cre') ;
end;
/
begin
add_domain_values ('creAttribute','ISIN','' );
end;
/
begin
add_domain_values ('creAttribute','CounterParty',''); 
end;
/
begin
add_domain_values ('creAttribute','BUY/SELL','') ;
end;
/
begin
add_domain_values ('creAttribute','FONumber','') ;
end;
/
begin
add_domain_values ('creAttribute','AccountingBook',''); 
end;
/
begin
add_domain_values ('creAttribute','MarketType','') ;
end;
/
begin
add_domain_values ('creAttribute','CptyRole','') ;
end;
/
begin
add_domain_values ('ProcessingConfig','ETDClearing.IsActive','false'); 
end;
/
begin
add_domain_values ('ProcessingConfig','ETDClearing.SecurityTransferGeneration','false'); 
end;
/
begin
add_domain_values ('ProcessingConfig','ETDClearing.ClearingAccountTransferGeneration','true'); 
end;
/
begin
add_domain_values ('feeDefinitionAttributes','MarginCall' ,'');
end;
/
begin
add_domain_values ('feeDefinitionAttributes','ETD.InventoryBucket' ,'');
end;
/
begin
add_domain_values ('feeDefinitionAttributes.ETD.InventoryBucket','Fees' ,'');
end;
/
begin
add_domain_values ('feeDefinitionAttributes.ETD.InventoryBucket','Commissions' ,'');
end;
/
begin
add_domain_values ('feeDefinitionAttributes.MarginCall','Always' ,'');
end;
/
begin
add_domain_values ('feeDefinitionAttributes.MarginCall','Never' ,'');
end;
/
begin
add_domain_values ('feeDefinitionAttributes.MarginCall','Account Level' ,'');
end;
/
begin
add_domain_values ('feeDefinitionAttributes','MarginCall.Cateend','');
end;
/
begin
add_domain_values ('feeDefinitionAttributes','Duplicate Fee Transfer' ,'');
end;
/
begin
add_domain_values ('inMemoryRiskServer','inmemoryriskserver' ,'');
end;
/
begin
add_domain_values ('domainName','InventoryCashBucketFactory','');
end;
/
begin
add_domain_values ('InventoryCashBucketFactory','ETD','New position balance type by transfer type for ETD') ;
end;
/
begin
add_domain_values ('engineParam','XFER_POS_AGGREGATION_NAME','Name of the Position Aggregation to use for TransferEngine gen') ;
end;
/
begin
add_domain_values ('workflowRuleTrade','ApplyRestatement','');
end;
/
begin
add_domain_values ('FXVolSurfaceGenerator','Spread_Default','Generator based on a spread oven an existing surface') ;
end;
/
begin
add_domain_values ('FXVolSurfaceGenerator','ReplicationHedge','Correlation based surface generator based on replication hedge') ;
end;
/
begin
add_domain_values ('FXVolSurfaceGenerator','GaussianCopula','Correlation based surface generator based on Gaussian Copula') ;
end;
/
begin
add_domain_values ('domainName','accountSubType','SubType of Account') ;
end;
/
begin
add_domain_values ('classAuditMode','TradeKeywordConfig','');
end;
/
begin
add_domain_values ('volatilityType','DIVIDEND','');
end;
/
begin
add_domain_values ('volatilityType','EquityVolatilityIndex','');
end;
/
begin
add_domain_values ('futureUnderType','DividendIndex','');
end;
/
begin
add_domain_values ('futureOptUnderType','DividendIndex','');
end;
/
begin
add_domain_values ('ExternalMessageField.MessageMapper','MT306','');
end;
/
begin
add_domain_values ('tradeKeyword','IsUpFrontFeeRounded','Indicates whether Upfront fee needs to be rounded or not rounded') ;
end;
/
begin
add_domain_values ('scheduledTask','OFFICIALPLARCHIVEMARKS','OfficialPLAnalysis Archive Marks/Purge Greeks.') ;
end;
/
begin
add_domain_values ('tradeAction','RESTATE','');
end;
/
begin
add_domain_values ('productType','FutureOptionDividendIndex','FutureOptionDividendIndex');
end;
/
begin
add_domain_values ('productType','FutureDividendIndex','FutureDividendIndex') ;
end;
/
begin
add_domain_values ('domainName','keyword.RestatementVersion','');
end;
/
begin
add_domain_values ('userAccessPermAttributes','Max.GenericComment','Type to be enforced by reports');
end;
/
begin
add_domain_values ('accountSubType','Clearing','Clearing Account' );
end;
/
begin
add_domain_values ('accountSubType','Security','');
end;
/
begin
add_domain_values ('accountSubType','None','');
end;
/
begin
add_domain_values ('corporateActionType','TRANSFORMATION.WRITE_DOWN','');
end;
/
begin
add_domain_values ('corporateActionType','TRANSFORMATION.WRITE_UP','');
end;
/
begin
add_domain_values ('CA.subtype','WRITE_DOWN','');
end;
/
begin
add_domain_values ('CA.subtype','WRITE_UP','');
end;
/
begin
add_domain_values ('eventClass','PSEventOfficialPL','');
end;
/
begin
add_domain_values ('function','ModifyTradeKeywordFavorite','Access permission to Create/Modify Trade Keyword Favorite Domains' );
end;
/
begin
add_domain_values ('productType','FutureEquity','');
end;
/
begin
add_domain_values ('sortMethod','SettleTradeDatePS','');
end;
/
begin
add_domain_values ('domainName','KeywordType','Specify list of Type supported in TradeKeyword' );
end;
/
begin
add_domain_values ('KeywordType','Account','');
end;
/
begin
add_domain_values ('KeywordType','Boolean','');
end;
/
begin
add_domain_values ('KeywordType','Double','');
end;
/
begin
add_domain_values ('KeywordType','Integer','');
end;
/
begin
add_domain_values ('KeywordType','JDate','');
end;
/
begin
add_domain_values ('KeywordType','JDatetime','');
end;
/
begin
add_domain_values ('KeywordType','LegalEntity','');
end;
/
begin
add_domain_values ('KeywordType','Long','');
end;
/
begin
add_domain_values ('KeywordType','String','');
end;
/
begin
add_domain_values ('ETOContractAttributes','PremiumPaymentConvention','convention for the premium payment' );
end;
/
begin
add_domain_values ('ETOContractAttributes.PremiumPaymentConvention','Conventional','');
end;
/
begin
add_domain_values ('ETOContractAttributes.PremiumPaymentConvention','VariationMargined','');
end;
/
begin
add_domain_values ('productInterfaceReportStyle','LegalAgreementHolder','LegalAgreementHolder ReportStyle' );
end;
/
begin
add_domain_values ('sdFilterCriterion.Factory','ListedContractAttribute','build Corporate Action Static Data Filter criteria' );
end;
/
begin
add_domain_values ('pricingScriptProductBase','BondExoticNote','');
end;
/
begin
add_domain_values ('function','Archive Purge of OfficialPL Marks','Allow User to archive or purge OfficialPL Marks' );
end;
/
begin
add_domain_values ('domainName','DividendIndex.subtype','DividendIndex product subtypes' );
end;
/
begin
add_domain_values ('DividendIndex.subtype','EquityIndex','DividendIndex based EquityIndex' );
end;
/
begin
add_domain_values ('PricingSheetMeasures','SMILE_ADJ' ,'');
end;
/
begin
add_domain_values ('mktDataVisuType.Volatility','FXVolatilitySpreadSurface','');
end;
/
begin
add_domain_values ('mktDataVisuType.Volatility','FXVolatilityCorrelationSurface','');
end;
/
begin
add_domain_values ('CreditDefaultSwap.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' );
end;
/
begin
add_domain_values ('CreditDefaultSwapLoan.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' );
end;
/
begin
add_domain_values ('CDSIndex.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' );
end;
/
begin
add_domain_values ('CDSIndexTranche.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' );
end;
/
begin
add_domain_values ('CDSNthLoss.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' );
end;
/
begin
add_domain_values ('CDSNthDefault.PricerMeasure','AVG_RECOVERY','Default Super User Pricer Measure' );
end;
/
begin
add_domain_values ('domainName','PositionKeeping.TransferMargin','If False, margin remains in the sales book, not transferred to risk taking books' );
end;
/
begin
add_domain_values ('PositionKeeping.TransferMargin','False' ,'');
end;
/
begin
add_domain_values ('domainName','PositionKeeping.CancelActions','All actions besides CANCEL that should be treated as trade cancelations in PKS' );
end;
/
begin
add_domain_values ('domainName','PositionKeeping.SplitActions','All actions besides SPLIT that should be treated as trade splits in PKS' );
end;
/
begin
add_domain_values ('domainName','PositionKeeping.TradeKeywordsToPropagate','All keywords from main trade to be propagated to the routed trades.' );
end;
/
begin
add_domain_values ('domainName','PositionKeeping.GlobalDayChangeRule','Day change rule for PKS. Defaults to FX' );
end;
/
begin
add_domain_values ('domainName','PositionKeeping.GlobalRiskCurrency','Global risk currency defined for PKS. Defaults to USD, if undefined.' );
end;
/
begin
add_domain_values ('domainName','PositionKeeping.DefaultTradeRegion','Default trade region to be used for routing.' );
end;
/
begin
add_domain_values ('domainName','PositionKeeping.DefaultTradePlatform','Default trade platform for routing.' );
end;
/
begin
add_domain_values ('domainName','ManualPartyName','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','manualSDITAG','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','manualSDITAG.70','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','manualSDITAG.71A','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','manualSDITAG.72','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','beneficiaryIdentifierPrefixes','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','agentIdentifierPrefixes','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','intermediary1IdentifierPrefixes','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','intermediary2IdentifierPrefixes','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('domainName','remitterIdentifierPrefixes','Domain used by Cash Manual SDI' );
end;
/
begin
add_domain_values ('DecSuppOrderStatus','LIMIT_VIOLATION','Order Status' );
end;
/
begin
add_domain_values ('DecSuppOrderStatus','EXECUTED','Order Status' );
end;
/
begin
add_domain_values ('DecSuppOrderStatus','PARTIAL_EXEC','Order Status' );
end;
/
begin
add_domain_values ('DecSuppOrderStatus','PENDING','Order Status' );
end;
/
begin
add_domain_values ('DecSuppOrderStatus','REJECTED','Order Status' );
end;
/
begin
add_domain_values ('DecSuppOrderStatus','SENT','Order Status' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','ACK','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','AMEND','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','AUTHORIZE','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','EXECUTE','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','MANUAL_AUTHORIZE','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','PARTIAL_EXECUTE','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','REJECT','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','SEND','Action on order' );
end;
/
begin
add_domain_values ('DecSuppOrderAction','SEND_TO_MARKET','Action on order' );
end;
/
begin
add_domain_values ('engineName','OMSEngine','Engine to connect to ullink' );
end;
/
begin
add_domain_values ('eventFilter','OMSEngineEventFilter','filter for Security Claim Transfer' );
end;
/
begin
add_domain_values ('classAuditMode','DecSuppOrder','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','AssetSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSABSIndex','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSABSIndexTranche','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSIndex','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSIndexDefinition','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSIndexOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSIndexTranche','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSIndexTrancheOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSNthDefault','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CDSNthLoss','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CFDConvertibleArbitrage','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CFDDirectional','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CFDPairTrading','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CFDRiskArbitrage','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CancellableCDS','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CancellableCDSNthDefault','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CancellableCDSNthLoss','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CancellableSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CancellableXCCySwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CapFloor','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CappedSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommodityCapFloor','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommodityCertificate','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommodityForward','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommodityIndexSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommodityOTCOption2','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommoditySwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommoditySwap2','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CommoditySwaption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CreditDefaultSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CreditDefaultSwapABS','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CreditDefaultSwapLoan','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CreditDefaultSwaption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CreditDrawDown','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CreditFacility','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','CreditTranche','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','ETOCommodity','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','ExtendibleCDS','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','ExtendibleCDSNthDefault','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','ExtendibleCDSNthLoss','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','ExtendibleSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FRA','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXCompoundOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXForward','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXForwardStart','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXNDF','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXNDFSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXOptionForward','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXOptionStrategy','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXOptionStrip','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXOptionSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXOrder','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXSpotReserve','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FXSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','GenericOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','IRStructuredOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','OTCCommodityOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','OTCEquityOption','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','OTCEquityOptionVanilla','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','PerformanceSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','PortfolioSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','PortfolioSwapPosition','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','PositionCash','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','PositionFXExposure','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','PositionFXNDF','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','RateIndexProduct','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','ScriptableOTCProduct','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','SkewSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','SpreadSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','TotalReturnSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','XCCySwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureBond','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureCDSIndex','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureCommodity','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureDividend','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureDividendIndex','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureEquity','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureEquityIndex','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureFX','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureMM','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionBond','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionCommodity','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionDividend','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionDividendIndex','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionEquity','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionEquityIndex','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionMM','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureOptionVolatility','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureStructuredFlows','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureSwap','');
end;
/
begin
add_domain_values ('perfMeasurement.Exposure.Notional','FutureVolatility','');
end;
/
begin
add_domain_values('CurveBasis.gen' ,'DoubleGlobal' ,'Generate two curves together. Requires multiple curve window.');
end;
/
begin
add_domain_values('CurveBasis.gen','DoubleGlobalM','Generate two curves together. Requires multiple curve window.');
end;
/

begin
add_domain_values('CurveBasis.gen','TripleGlobal','Generate three curves together. Requires multiple curve window.');
end;
/
begin
add_domain_values('CurveZero.gen','DoubleGlobalM','Generate two curves together. Requires multiple curve window.');
end;
/

/* end */
UPDATE product_tlock SET settlement_type='CASH_SETTLE_DIRTY_PRICE' WHERE settlement_type='CASH_SETTLE_PRICE'
;
insert into scenario_quoted_product values ('FutureStructuredFlows', 'FUTURE_FROM_QUOTE', 'INSTRUMENT_SPREAD')
;
declare
    x number;
BEGIN
    begin
    select count(*) INTO x FROM BENCHMARK;
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x > 0 THEN
		execute immediate 'update benchmark set publish_holidays = publish_frequency';
		execute immediate 'update benchmark set publish_frequency = publish_holiday';
   END IF;
END;
/
alter table fee_definition modify (fee_type varchar2(32))
/
create or replace procedure billing_fee_def
is
begin
declare 
cursor c1 is select distinct value from domain_values where name='BillingFeeType' and value not in (select fee_type from fee_definition);
amount_type_count number(22);
billing_fee_type varchar2(64);
fee_type_count number(22);

                begin
                   select count(*) into amount_type_count from domain_values where name='BillingFeeType' and value='AMOUNT';    
                   if (amount_type_count = 0) then
                	 insert into domain_values (name,value,description) values('BillingFeeType','AMOUNT','');
                   end if;
                   open c1;
                   fetch c1 into billing_fee_type;
                   while c1 %found
                   	 loop
                     select count(fee_type) into fee_type_count from fee_definition;
                     insert into fee_definition (fee_type, comments, is_in_pl_b, is_in_transfer_b, le_role, is_in_accounting_b, is_in_settle_amt_b, fee_code, def_calculator, product_list, version_num, offset_days, offset_business_b, is_allocated)
                 	 		values ( cast(billing_fee_type as varchar(32)), null, 0, 0 , 'CounterParty', 0, 0 , fee_type_count, null, null, 0, 0 ,0 ,0);
                	 fetch c1 into billing_fee_type;
                	 end loop;
                   close c1;
                   delete from domain_values where name='BillingFeeType';
                   delete from domain_values where name='domainname' and value = 'BillingFeeType';
                end;
end;
/
begin
billing_fee_def;
end;
/
drop procedure billing_fee_def
;
begin
add_column_if_not_exists ('cfd_detail','trading_gain_pay_meth','varchar(16) null');
end;
/
update cfd_detail set trading_gain_pay_meth = 'Effective Date' where trading_gain_pay_meth is null
;

update sched_task_attr set attr_name = 'Calculation Server Names' where attr_name= 'Calculation Server Name'
;

update referring_object 
set rfg_tbl_sel_cols = 'risk_config_name,analysis_name,trade_filter_name,pricing_env_name,param_name,view_name',
rfg_tbl_sel_types = '2,2,2,2,2,2'
where rfg_tbl_name = 'risk_config_item'
and rfg_tbl_join_cols = 'trade_filter_name'
;
INSERT INTO pricing_param_name ( 
	param_name, param_type, param_domain, param_comment, is_global_b, default_value ) 
	VALUES ( 'STUB_FORECAST_ADJ', 'java.lang.Boolean', 'true,false', 'Param controls stub tenor forecast curve retrieval', 1, 'false' )
;
/* CAL-271497 : set the value of the new status column to MOD on TAX_INFO records with the modif_date is set */

declare
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER('liq_tax');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
        execute immediate 'update liq_tax set status = ''MOD'' where status=''NEW'' and modif_date IS NOT NULL';
   END IF;
END;
 
/
declare
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER('liq_tax_hist');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
        execute immediate 'update liq_tax_hist set status = ''MOD'' where status=''NEW'' and modif_date IS NOT NULL';
   END IF;
END;
 
/

UPDATE calypso_info
    SET major_version=14,
        minor_version=4,
        sub_version=0,
        patch_version='003',
        version_date=TO_DATE('19/10/2015','DD/MM/YYYY')
;
