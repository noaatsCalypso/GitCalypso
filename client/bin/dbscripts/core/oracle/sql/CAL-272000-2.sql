declare 
    regriskasset number :=0 ;
begin
  SELECT count(*) INTO regriskasset FROM user_tab_cols WHERE table_name='REGRISK_ASSET' and column_name='ASSET_ID';
  IF regriskasset = 1 THEN
    execute immediate 'DROP TABLE regrisk_asset';
    execute immediate 'DROP TABLE regrisk_product';
  end if;
end;
/

declare
regrisk number :=0;
begin
    SELECT COUNT(*) INTO regrisk FROM calypso_database_upgrade_audit where name = 'CAL-272000' AND version = 1;
    IF regrisk = 1 THEN
        -- we have been run before
        -- so drop tables, that only core created and didn't use
        -- the regrisk_assetregrisk_product tables will be cleaned up by installation of regulatory risk module
        execute immediate 'DROP TABLE regrisk_bucket';   
        execute immediate 'DROP TABLE regrisk_bucket_name';  
        execute immediate 'DROP TABLE regrisk_bucket_cf';  
        execute immediate 'DROP TABLE regrisk_bucket_cf_position';  
        execute immediate 'DROP TABLE regrisk_bucket_co';  
        execute immediate 'DROP TABLE regrisk_bucket_co_position';  
        execute immediate 'DROP TABLE regrisk_bucket_eq_position';  
        execute immediate 'DROP TABLE regrisk_params';  
        execute immediate 'DROP TABLE regrisk_product_asset'; 
        execute immediate 'DROP TABLE regrisk_results'; 
        execute immediate 'DROP TABLE regrisk_risk_measure'; 
        execute immediate 'DROP TABLE regrisk_risk_measure_result'; 
        execute immediate 'DROP TABLE regrisk_rejected_trades'; 
    end if;
end;
/
    
declare
	x number:=0;
	begin
    SELECT COUNT(*) INTO x FROM calypso_database_upgrade_audit where name = 'CAL-272000' AND version = 1;
    IF x = 0 THEN
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=1000
            and seed_name='FTPPaymentSchedule'
            and seed_alloc_size=10;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'FTPPaymentSchedule',10 );
        end if;
    end;
     
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=1000
            and seed_name='FTPCostComponentRule'
            and seed_alloc_size=10;
        if x=0 then
            INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'FTPCostComponentRule',10 );
        end if;
    end;
     
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=1000
            and seed_name='FTPRateRetrievalConfig'
            and seed_alloc_size=10;
        if x=0 then
            INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'FTPRateRetrievalConfig',10 );
        end if;
    end;
     
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=1000
            and seed_name='LIQUIDITY_RULE'
            and seed_alloc_size=500;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'LIQUIDITY_RULE',500 );
        end if;
    end;
     
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=0
            and seed_name='HedgeAccountingScheme'
            and seed_alloc_size=1;
        if x=0 then
            INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeAccountingScheme',1 );
        end if;
    end;
    

    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=0
            and seed_name='DesignationRecords'
            and seed_alloc_size=1;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'DesignationRecords',1 );
        end if;
    end;
    
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=0
            and seed_name='RelationshipTradeItem'
            and seed_alloc_size=1;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'RelationshipTradeItem',1 );
        end if;
    end;
    
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=0
            and seed_name='HedgeRelationship'
            and seed_alloc_size=1;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationship',1 );
        end if;
    end;
    
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=0
            and seed_name='HedgeStrategy'
            and seed_alloc_size=1;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeStrategy',1 );
        end if;
    end;
    
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=0
            and seed_name='HedgeRelationshipConfig'
            and seed_alloc_size=500;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationshipConfig',500 );
        end if;
    end;
    
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=1000
            and seed_name='BenchmarkComposition'
            and seed_alloc_size=100;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'BenchmarkComposition',100 );
        end if;
    end;
    
    declare
      x number :=0 ;
    begin
        select count(*) into x from calypso_seed where last_id=1000
            and seed_name='Benchmark'
            and seed_alloc_size=100;
        if x=0 then
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'Benchmark',100 );
        end if;
    end;
end if;
end;
/
   
declare
	x number:=0;
	begin
    SELECT COUNT(*) INTO x FROM calypso_database_upgrade_audit where name = 'CAL-272000' AND version = 1;
    IF x = 0 THEN
	INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ExternalTrade.ANY.ANY','PricerExternalTrade' );
    
	declare
      x number :=0;
    begin
        SELECT count(*) INTO x FROM pricer_measure where measure_name='FTP_ALL_IN_RATE';
        if x=0 THEN
        	INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('FTP_ALL_IN_RATE','tk.pricer.PricerMeasureFTPAllInRate',414 );
        end if;
    end;
	
    INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PV01_PAYLEG','tk.core.PricerMeasure',464,'PV01 for Swap Pay Leg' );
    INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PV01_RECLEG','tk.core.PricerMeasure',465,'PV01 for Swap Receive Leg' );
    INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ('INDEX_SUBFAMILY','string',0,0,0,'CDSIndex',0 );
    INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ('INDEX_ACTIVE_VERSION','string',0,0,0,'CDSIndex',0 );
    INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('RESET_INFLATION_FROM_CURVE','java.lang.Boolean','true,false','',1,'false' );
    INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('ACCRUAL_ON_LAST_QUOTE','java.lang.Boolean','true,false','For Brazilian IGPM Inflation Swaps, calculate inflation performance factor based on last published inflation quotes.',1 );

	INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (10000,'DefaultClient','MasterConfirmation',0,'NonTransactional','LFU' );
    INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (20000,'DefaultServer','MasterConfirmation',0,'NonTransactional','LFU' );
    INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (10000,'DefaultServer','Benchmark',0,'Calypso','LFU' );
    INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (10000,'DefaultClient','Benchmark',0,'NonTransactional','LFU' );
    INSERT INTO calypso_hierarchy ( tree_id, tree_name, tree_type ) VALUES (500,'BASEL SA-CCR','COMMODITIES' );
    INSERT INTO calypso_hierarchy ( tree_id, tree_name, tree_type ) VALUES (501,'BASEL SA-MR','COMMODITIES' );
    INSERT INTO calypso_hierarchy ( tree_id, tree_name, tree_type ) VALUES (502,'BASEL SA-MR','EQUITIES' );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,100,'SA-CCR',0 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,101,'ELECTRICITY',100 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,102,'OIL_GAS',100 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,103,'METALS',100 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,104,'AGRICULTURAL',100 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,105,'OTHER',100 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,106,'SA-MR',0 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,107,'COAL',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,108,'CRUDE_OIL',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,109,'ELECTRICITY',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,110,'FREIGHT',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,111,'METALS',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,112,'NATURAL_GAS',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,113,'PRECIOUS_METALS',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,114,'OTHER',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,115,'GRAINS_OILSEED',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,116,'LIVESTOCK_DAIRY',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,117,'SOFTS_OTHER_AG',106 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,118,'NYMEX WTI',108 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,119,'ICE BRENT',108 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,120,'NYMEX SILVER',113 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,121,'NYSE LIFFE SILVER',113 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,122,'NYSE LIFFE GOLD',113 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,123,'UNLEADED GASOLINE',114 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,124,'LME ALUMINIUM',111 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,125,'LME COPPER',111 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,126,'ARABICA COFFEE',117 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,127,'CBOT CORN',115 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,128,'CBOT GOLD',113 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,129,'CBOT SILVER',114 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,130,'CBOT SOYBEAN',115 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,131,'ICE NATURAL GAS',112 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,132,'SA-MR',0 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,133,'SMALL',132 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,134,'LARGE',132 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,135,'EMERGING',133 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,136,'developed',133 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,137,'ALL',135 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,138,'ALL',136 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,139,'EMERGING',134 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,140,'DEVELOPED',134 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,141,'CONSUMER_UTILITIES',139 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,142,'TELECOM_INDUSTRIALS',139 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,143,'MATERIALS_ENERGY',139 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,144,'FINANCIAL_TECHNOLOGY',139 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,145,'CONSUMER_UTILITIES',140 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,146,'TELECOM_INDUSTRIALS',140 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,147,'MATERIALS_ENERGY',140 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,148,'FINANCIAL_TECHNOLOGY',140 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,149,'AAPL',145 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,150,'GE',146 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,151,'MSFT',148 );
    INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,152,'NYMEX NATURAL GAS',112 );
    add_domain_values( 'engineName','LiquidityPositionPersistenceEngine','Liquidity Context position persistence engine' );
    add_domain_values( 'eventClass','PSEventExternalMovement','Event type for Liquidity External Movement' );
    add_domain_values( 'scheduledTask','REINITIALIZE_CONTEXT_POSITIONS','Reinitialize context positions.' );
    add_domain_values( 'scheduledTask','CLEAN_UP_CONTEXT_POSITION','Scheduled Task to delete all data referenced by selected inactive Context Position Bucket Configs' );
    add_domain_values( 'productTypeReportStyle','ContextPosition','Context Position Report Style' );
    add_domain_values( 'eventFilter','LiquidityContextPositionEventFilter','Context Position Persistence engine event filter' );
    add_domain_values( 'tradeKeyword','LiquidityPositionRetailTrade','Trade keyword to identify Retail Trades in Liquidity Server' );
    add_domain_values( 'scheduledTask','REVERSE_INTRADAY_SETTLED','Reverse context positions for all MT940950 for the day' );
    add_domain_values( 'domainName','ContextPosition.subtype','ContextPosition subtypes' );
    add_domain_values( 'ContextPosition.subtype','Unknown','' );
    add_domain_values( 'ContextPosition.subtype','TradingCash','' );
    add_domain_values( 'ContextPosition.subtype','TradingSecurity','' );
    add_domain_values( 'ContextPosition.subtype','ReferenceCostCash','' );
    add_domain_values( 'ContextPosition.subtype','LiquidityPremiumCash','' );
    add_domain_values( 'ContextPosition.subtype','SyntheticReferenceCostCash','' );
    add_domain_values( 'ContextPosition.subtype','SyntheticBasisCostCash','' );
    add_domain_values( 'ContextPosition.subtype','SyntheticLiquidityPremiumCash','' );
    add_domain_values( 'ContextPosition.subtype','SyntheticCollateralizedLiquidityPremiumCash','' );
    add_domain_values( 'productType','ContextPosition','Context Position as a product type for registrating cross asset components' );
    add_domain_values( 'classAccessMode','ContextPositionFilters','' );
    add_domain_values( 'function','AddContextPositionFilters','AccessPermission for ability to add ContextPositionFilter' );
    add_domain_values( 'function','ModifyContextPositionFilters','AccessPermission for ability to modify ContextPositionFilter' );
    add_domain_values( 'function','RemoveContextPositionFilters','AccessPermission for ability to remove ContextPositionFilter' );
    add_domain_values( 'function','AddModifyContextPositionBucketConfigs','AccessPermission for ability to Add or Modify ContextPositionBucketConfigs' );
    add_domain_values( 'function','AddModifyContextPositionMovementAttributes','AccessPermission for ability to Add or Modify ContextPositionMovementAttributes' );
    add_domain_values( 'function','AddModifyContextPositionBucketScope','AccessPermission for ability to Add or Modify ContextPositionBucketScope' );
    add_domain_values( 'function','AddModifyContextPositionReinitializeJob','AccessPermission for ability to Add or Modify ContextPositionReinitializeJob' );
    add_domain_values( 'engineserver.types','LiquidityServer','' );
    add_domain_values( 'engineserver.unmanaged.types','LiquidityServer','' );
    add_domain_values( 'domainName','LiquidityServer.instances','' );
    add_domain_values( 'domainName','LiquidityServer.engines','' );
    add_domain_values( 'LiquidityServer.instances','liquidityserver','' );
    add_domain_values( 'LiquidityServer.engines','LiquidityPositionPersistenceEngine','' );
    add_domain_values( 'domainName','FtpCostComponentNames','FTP Cost Component names' );
    add_domain_values( 'FtpCostComponentNames','SWAP_COST','Swap Cost' );
    add_domain_values( 'FtpCostComponentNames','BASIS_COST','Basis Cost' );
    add_domain_values( 'FtpCostComponentNames','LIQUIDITY_PREMIUM','Liquidity Premium' );
    add_domain_values( 'FtpCostComponentNames','ADMINISTRATIVE_COST','Administrative Cost' );
    add_domain_values( 'FtpCostComponentNames','LAB_COST','LAB Cost' );
    add_domain_values( 'FtpCostComponentNames','FUNDING_PRINCIPAL_COST','Funding Risk' );
    add_domain_values( 'FtpCostComponentNames','THEORETICAL_BASIS_COST','Basis Cost at trade inception' );
    add_domain_values( 'FtpCostComponentNames','THEORETICAL_LIQUIDITY_PREMIUM','Liquidity premium at trade inception' );
    add_domain_values( 'FtpCostComponentNames','THEORETICAL_REFERENCE_COST','Reference Cost at trade inception' );
    add_domain_values( 'FtpCostComponentNames','MANAGEMENT_OVERLAY_COST','Management Overlay Cost' );
    add_domain_values( 'FtpCostComponentNames','CREDIT_COST','Credit Cost' );
    add_domain_values( 'FtpCostComponentNames','HEDGING_BM_SPREAD_COST','Hedging Benchmark Spread Risk' );
    add_domain_values( 'FtpCostComponentNames','FUNDING_BM_SPREAD_COST','Funding Benchmark Spread Risk' );
    add_domain_values( 'FtpCostComponentNames','COLL_LIQUIDITY_PREMIUM','Collateralized Liquidity Premium' );
    add_domain_values( 'workflowRuleTrade','TradeFTP','' );
    add_domain_values( 'eventFilter','FTPEngineEventFilter','Event filter for FTP Engine.' );
    add_domain_values( 'engineName','FTPEngine','FTP engine' );
    add_domain_values( 'tradeAction','FTP_TRADE_UPDATE','Action applied on trades processed and saved by the FTP engine' );
    add_domain_values( 'scheduledTask','EOD_FTP_COST_ACCRUAL','' );
    add_domain_values( 'scheduledTask','EOD_GENERATE_FTP_TRADE','' );
    add_domain_values( 'scheduledTask','GEN_LIQUIDITY_PREM_INDEX_QUOTES','' );
    add_domain_values( 'eventType','EX_EOD_FTP_COST_ACCRUAL_SUCCESS','The FTP cost accrual scheduled task was successful.' );
    add_domain_values( 'eventType','EX_EOD_FTP_COST_ACCRUAL_FAILURE','The FTP cost accrual scheduled task was not successful.' );
    add_domain_values( 'exceptionType','GEN_LIQUIDITY_PREM_INDEX_QUOTES_FAILURE','' );
    add_domain_values( 'exceptionType','EOD_FTP_COST_ACCRUAL_SUCCESS','' );
    add_domain_values( 'exceptionType','EOD_FTP_COST_ACCRUAL_FAILURE','' );
    add_domain_values( 'eventType','EX_EOD_GENERATE_FTP_TRADE_SUCCESS','The FTP trade generation scheduled task was successful.' );
    add_domain_values( 'eventType','EX_EOD_GENERATE_FTP_TRADE_FAILURE','The FTP trade generation scheduled task was not successful.' );
    add_domain_values( 'exceptionType','EOD_GENERATE_FTP_TRADE_SUCCESS','' );
    add_domain_values( 'exceptionType','EOD_GENERATE_FTP_TRADE_FAILURE','' );
    add_domain_values( 'exceptionType','FTP_ACCRUAL_GENERATION','Exception while generating accruals for a Trade.' );
    add_domain_values( 'exceptionType','FTP_COST_CONVERSION_CALCULATION','Exception while converting rate into index conventions for a Trade.' );
    add_domain_values( 'exceptionType','FTP_COST_CALCULATION','Exception while calculating the cost for a trade cost component.' );
    add_domain_values( 'exceptionType','FTP_SYNTHETIC_TRADE_EXPLODE','Exception while creatingpublishing synthetic trades.' );
    add_domain_values( 'flowType','FTP_COST','FTP Cost flow type' );
    add_domain_values( 'flowType','FUNDING_RISK','Funding Principal Cost flow type' );
    add_domain_values( 'function','ModifyFTPRule','Access permission to modify FTP rules' );
    add_domain_values( 'function','ViewFTPRule','Access permission to view FTP rules' );
    add_domain_values( 'domainName','CashMenuItemNames','Cash product specific MenuItem names' );
    add_domain_values( 'CashMenuItemNames','FTPCostComponent','FTP Cost Component menu item' );
    add_domain_values( 'CashMenuItemNames','FTPRefreshRule','FTP Refresh Rule menu item' );
    add_domain_values( 'domainName','FtpLiquidationConfig','FTP Liquidation Config' );
    add_domain_values( 'domainName','FtpPositionAggregation','FTP Position Aggregation' );
    add_domain_values( 'FtpLiquidationConfig','DEFAULT','FTP Liquidation Config value' );
    add_domain_values( 'domainName','FtpEngineProcessingStatus','Trade statuses accepted by FTP Engine' );
    add_domain_values( 'FtpEngineProcessingStatus','VERIFIED','' );
    add_domain_values( 'FtpEngineProcessingStatus','CANCELED','' );
    add_domain_values( 'FtpEngineProcessingStatus','TERMINATED','' );
    add_domain_values( 'flowType','FTP_ADMINISTRATIVE_COST','FTP Cost flow type' );
    add_domain_values( 'flowType','FTP_BASIS_COST','FTP Cost flow type' );
    add_domain_values( 'flowType','FTP_LAB_COST','FTP Cost flow type' );
    add_domain_values( 'flowType','FTP_SWAP_COST','FTP Reference Cost flow type' );
    add_domain_values( 'flowType','FTP_LIQUIDITY_PREMIUM','FTP Cost flow type' );
    add_domain_values( 'flowType','FTP_FUNDING_PRINCIPAL_COST','FTP Funding Cost flow type' );
    add_domain_values( 'flowType','FTP_MANAGEMENT_OVERLAY_COST','FTP Cost flow type' );
    add_domain_values( 'flowType','FTP_CREDIT_COST','FTP Cost flow type' );
    add_domain_values( 'flowType','FTP_HEDGING_BM_SPREAD_COST','FTP Cost flow type for HEDGING_BM_SPREAD_COST' );
    add_domain_values( 'flowType','FTP_FUNDING_BM_SPREAD_COST','FTP Cost flow type for FUNDING_BM_SPREAD_COST' );
    add_domain_values( 'flowType','FTP_COLL_LIQUIDITY_PREMIUM','FTP Cost flow type' );
    add_domain_values( 'currencyDefaultAttribute','LiquidityPremiumIndex','Currency Attribute to identify Liquidity Premium Cost Index Name' );
    add_domain_values( 'currencyDefaultAttribute','LiquidityPremiumIndexSource','Currency Attribute to identify Liquidity Premium Cost Source Name' );
    add_domain_values( 'tradeKeyword','BehavioralMaturityTenor','Trade Behavioral Maturity Tenor' );
    add_domain_values( 'tradeKeyword','FTPReferenceCostHedgeSwapTradeId','Hedge Trade Id for Reference Cost' );
    add_domain_values( 'tradeKeyword','FTPSyntheticHedgeIndex','Index Name for the Hedge trade to be synthetically created for auto calculation of FTP Costs' );
    add_domain_values( 'tradeKeyword','FTPSyntheticHedgeIndexSource','Index Source Name for the Hedge trade to be synthetically created for auto calculation of FTP Costs' );
    add_domain_values( 'tradeKeyword','FTPSyntheticHedgeIndexTenor','Index Tenor Name for the Hedge trade to be synthetically created for auto calculation of FTP Costs' );
    add_domain_values( 'tradeKeyword','FTPAccrualStartDate','Trade Keyword for providing the accrual start date for a particular trade that will override the trade start date' );
    add_domain_values( 'tradeKeyword','FTP_HEDGING_LEG','Leg type for Swap identifying the Leg that represents the Hedge value as PAY or RECEIVE' );
    add_domain_values( 'tradeKeyword','FTP_FUNDING_LEG','Leg type for Swap identifying the Leg that represents the Funded Trade value as PAY or RECEIVE' );
    add_domain_values( 'tradeKeyword','FTP_LIQUIDITY_PREMIUM_RATE_INDEX','Liquidity Premium Rate Index to be used for shifting curve when discounting liquidity premium hedge trades or positions' );
    add_domain_values( 'eventClass','PSEventLiquiditySyntheticTrade','' );
    add_domain_values( 'rateIndexAttributes','InputMethod','' );
    add_domain_values( 'rateIndexAttributes','MMLiquidTenor','' );
    add_domain_values( 'rateIndexAttributes','MMCurve','' );
    add_domain_values( 'rateIndexAttributes','MarketCurve','' );
    add_domain_values( 'rateIndexAttributes','BaseLiquidityPremium','' );
    add_domain_values( 'rateIndexAttributes','BaseRateIndex','' );
    add_domain_values( 'function','AddLiquidityRuleLimit','AccessPermission for ability to Add LiquidityLimitRule' );
    add_domain_values( 'function','ModifyLiquidityRuleLimit','AccessPermission for ability to Modify LiquidityLimitRule' );
    add_domain_values( 'function','DeleteLiquidityRuleLimit','AccessPermission for ability to Delete LiquidityLimitRule' );
    add_domain_values( 'domainName','BankingFlows.extendedType','Domain Name that defines BankingFlows Extended Type' );
    add_domain_values( 'BankingFlows.extendedType','ACCOUNT','Extended Type ACCOUNT' );
    add_domain_values( 'BankingFlows.extendedType','DEPOSIT','Extended Type DEPOSIT' );
    add_domain_values( 'BankingFlows.extendedType','LOAN','Extended Type LOAN' );
    add_domain_values( 'accountProperty','isLABPosition','Property that helps to identify if account positions are to processed for LAB' );
    add_domain_values( 'domainName','timeBucket','Domain Name that defines Time Buckets' );
    add_domain_values( 'timeBucket','800','Time bucket defined for 8:00 AM' );
    add_domain_values( 'timeBucket','900','Time bucket defined for 9:00 AM' );
    add_domain_values( 'timeBucket','1000','Time bucket defined for 10:00 AM' );
    add_domain_values( 'timeBucket','1100','Time bucket defined for 11:00 AM' );
    add_domain_values( 'timeBucket','1200','Time bucket defined for 12:00 PM' );
    add_domain_values( 'timeBucket','1300','Time bucket defined for 1:00 PM' );
    add_domain_values( 'timeBucket','1400','Time bucket defined for 2:00 AM' );
    add_domain_values( 'timeBucket','1500','Time bucket defined for 3:00 PM' );
    add_domain_values( 'timeBucket','1600','Time bucket defined for 4:00 PM' );
    add_domain_values( 'timeBucket','1700','Time bucket defined for 5:00 PM' );
    add_domain_values( 'timeBucket','1800','Time bucket defined for 6:00 PM' );
    add_domain_values( 'scheduledTask','REBUILD_LIQUIDITY_POSITIONS','Scheduled Task for rebuilding positions for liquidity management' );
    add_domain_values( 'currencyDefaultAttribute','SwiftMessage205AccountId','Currency Attribute to identify Account for an MT205 message' );
    add_domain_values( 'customCriterion','Liquidity','Enable custom TradeFilter criterion for Liquidity' );
    add_domain_values( 'scheduledTask','RESET_FLOATING_RATE_NOTES','Reset Liquidity Floating Rate Notes' );
    add_domain_values( 'scheduledTask','LIQUIDITY_UPGRADE_TASK','Liquidity Program based Upgrade tasks' );
    add_domain_values( 'InventorySecBucketFactory','CallableSec','Callable security position factory' );
    add_domain_values( 'function','TaskStation_SummaryPanelConfig_ADD','Allow User to add a summary panel configuration rule' );
    add_domain_values( 'function','TaskStation_SummaryPanelConfig_DELETE','Allow User to delete a summary panel configuration rule' );
    add_domain_values( 'function','TaskStation_SummaryPanelConfig_CHANGE','Allow User to chnage a summary panel configuration rule' );
    add_domain_values( 'domainName','CollateralPolicy','Collateral Policy for Credit Support Annex' );
    add_domain_values( 'domainName','surfaceExpiryTenors','Volatility surface expiry tenor' );
    add_domain_values( 'surfaceExpiryTenors','2D','' );
    add_domain_values( 'surfaceExpiryTenors','1W','' );
    add_domain_values( 'surfaceExpiryTenors','2W','' );
    add_domain_values( 'surfaceExpiryTenors','3W','' );
    add_domain_values( 'surfaceExpiryTenors','1M','' );
    add_domain_values( 'engineParam','MCC_PRICING_ENV','Specify the pricing-env to be used by the Market Conformity Module engines.' );
    add_domain_values( 'engineParam','MCC_FEED_NAME','Specify the market data feed name to be used by the Market Conformity Module engines.' );
    add_domain_values( 'engineParam','MCC_INTRA_MONITOR_PRICING_ENV','If true, Intraday Market Data Engine responds to external changes to market data and pricing environment.' );
    add_domain_values( 'engineParam','MCC_INTRA_FIXED_RATE','If true, Intraday Market Data Engine saves quotes every x minutes.' );
    add_domain_values( 'engineParam','MCC_INTRA_DELAY','Intraday Market Data Engine waits no. of minutes, executes tasks and starts the timers for subsequent executions .' );
    add_domain_values( 'engineParam','MCC_TRADE_FILTER_NAME','Redefine name of Market Conformity Engine trade filter from default MARKET_CONFORMITY.' );
    add_domain_values( 'engineParam','MCC_IGNORE_CONFIG_CHANGES','If true, trade filter configuration changes are ignored by the Market Conformity engine.' );
    add_domain_values( 'engineParam','MCC_DATE_KEYWORD','Set a trade keyword name that represents the trade entered datetime in Market Conformity Engine.' );
    add_domain_values( 'domainName','ExternalTrade.Pricer','Pricers for external trades' );
    add_domain_values( 'REPORT.Types','CAApplyTrade','CAApplyTrade Report' );
    add_domain_values( 'REPORT.Types','CAApplyTradeSimulation','CAApplyTradeSimulation Report' );
    add_domain_values( 'REPORT.Types','CAElectedOption','CAElectedOption Report' );
    add_domain_values( 'REPORT.Types','CAReconciliation','CAReconciliation Report' );
    add_domain_values( 'REPORT.Types','CA','CA Report' );
    add_domain_values( 'REPORT.Types','SecurityMatching','Security Matching Window' );
    add_domain_values( 'REPORT.Types','Rebase','Rebase Report' );
    add_domain_values( 'domainName','tradeUpfrontFeeType','Domain name to hold upfront fee definitions for all products accept CDS, LCDS and CDSIndex' );
    add_domain_values( 'tradeUpfrontFeeType','UPFRONT_FEE','Fee definition name for upfront fee for all products accept CDS, LCDS and CDSIndex' );
    add_domain_values( 'domainName','ExternalTrade.subtype','Types of External Trades' );
    add_domain_values( 'classAuthMode','Trade','Manual Trade Workflow Auth.' );
    add_domain_values( 'volatilityType','BOND_YIELD','Market Yield Volatility' );
    add_domain_values( 'ExternalMessageField.MessageMapper','MT340','' );
    add_domain_values( 'ExternalMessageField.MessageMapper','MT341','' );
    add_domain_values( 'feeCalculator','ISDARisklessAccrual','Fee calculator interface for riskless accrual part of upfront fee' );
    add_domain_values( 'feeCalculator','ISDARiskyAccrual','Fee calculator interface for risky accrual part of upfront fee' );
    add_domain_values( 'scheduledTask','SA_MR','' );
    add_domain_values( 'scheduledTask','SA_CCR','' );
    add_domain_values( 'scheduledTask','UPDATE_STATUS','' );
    add_domain_values( 'workflowRuleTrade','CheckValidDomiciliationChange','The rule checks if the book change on the trade is for the same domiciliation.' );
    add_domain_values( 'PLPositionProduct.Pricer','PricerSpreadCapFloorGBM2FHagan','' );
    add_domain_values( 'ExternalTrade.Pricer','PricerExternalTrade','' );
    add_domain_values( 'CreditDefaultSwap.subtype','SNAC','Subtype Standard North American Contract CDS. For choosing PricerCreditDefaultSwapFlat' );
    add_domain_values( 'eventClass','PSEventUpdateStatus','' );
    add_domain_values( 'exceptionType','TARGET2_INFO','' );
    add_domain_values( 'exceptionType','TARGET2_NOBIC','' );
    add_domain_values( 'exceptionType','TARGET2_EXCEPTION','' );
    add_domain_values( 'function','CreateQuoteValueAdjustment','Access permission to add a QuoteValueAdjustment' );
    add_domain_values( 'function','ModifyQuoteValueAdjustment','Access permission to modify a QuoteValueAdjustment' );
    add_domain_values( 'function','RemoveQuoteValueAdjustment','Access permission to remove a QuoteValueAdjustment' );
    add_domain_values( 'yieldMethod','Exp_ACT365','Exponential method using ACT365 convention' );
    add_domain_values( 'yieldMethod','MXN','Yield Method for Mexican Bonds.' );
    add_domain_values( 'FutureContractAttributes','UseIndexPrice','Use underlying Index to calculate Notional' );
    add_domain_values( 'FutureContractAttributes.UseIndexPrice','Yes','' );
    add_domain_values( 'FutureContractAttributes.UseIndexPrice','No','' );
    add_domain_values( 'sdFilterCriterion.Factory','Equity','build Equity Static Data Filter criteria' );
    add_domain_values( 'tradeKeyword','ReOpen','Applies to PricerBankofThailad. If set to true, the bond should be priced according to auction conventions (to calculate the interpolated rate, use BIBOR rates on trade date -2' );
    add_domain_values( 'domainName','keyword.ReOpen','' );
    add_domain_values( 'keyword.ReOpen','true','' );
    add_domain_values( 'keyword.ReOpen','false','' );
    add_domain_values( 'LifeCycleEvent','tk.lifecycle.event.BermudanExerciseEvent','Bermudan Exercise' );
    add_domain_values( 'LifeCycleEventProcessor','tk.lifecycle.processor.BermudanExerciseEventProcessor','Bermudan Exercise' );
    add_domain_values( 'LifeCycleEventTrigger','tk.lifecycle.trigger.BermudanExerciseTrigger','Pricing Script Bermudan Exercise' );
    add_domain_values( 'tradeKeyword','DividendReqAccountingEventAmount','' );
    add_domain_values( 'domainName','CABOPositionBalanceType','' );
    add_domain_values( 'domainName','propagateToCAElectionAttribute','' );
    add_domain_values( 'propagateToCAElectionAttribute','ContractDivRate','' );
    add_domain_values( 'MTMFeeType','UPFRONT_FEE','' );
    add_domain_values( 'productFamily','ExternalTrade','' );
    add_domain_values( 'productTypeReportStyle','ExternalTrade','' );
    add_domain_values( 'domainName','externalTradeFieldType','' );
    add_domain_values( 'externalTradeFieldType','Integer','' );
    add_domain_values( 'externalTradeFieldType','Boolean','' );
    add_domain_values( 'externalTradeFieldType','Double','' );
    add_domain_values( 'externalTradeFieldType','String','' );
    add_domain_values( 'externalTradeFieldType','JDate','' );
    add_domain_values( 'externalTradeFieldType','JDatetime','' );
    add_domain_values( 'externalTradeFieldType','List','' );
    add_domain_values( 'externalTradeFieldType','Product','' );
    add_domain_values( 'externalTradeFieldType','Category','' );
    add_domain_values( 'externalTradeFieldType','Amount','' );
    add_domain_values( 'externalTradeFieldType','Matrix','' );
    add_domain_values( 'domainName','ExternalTradeFieldSQL','' );
    add_domain_values( 'ExternalTradeFieldSQL','List','' );
    add_domain_values( 'ExternalTradeFieldSQL','Product','' );
    add_domain_values( 'ExternalTradeFieldSQL','Category','' );
    add_domain_values( 'ExternalTradeFieldSQL','Amount','' );
    add_domain_values( 'ExternalTradeFieldSQL','Matrix','' );
    add_domain_values( 'domainName','hedgeRelationshipDefinitionAttributes','' );
    add_domain_values( 'domainName','HedgeRelationshipDefinitionType','' );
    add_domain_values( 'domainName','workflowRuleHedgeRelationshipDefinition','' );
    add_domain_values( 'domainName','hedgeDefinitionAttributes','' );
    add_domain_values( 'domainName','hedgeAccountingSchemeAttributes','' );
    add_domain_values( 'domainName','hedgeAccountingSchemeStandard','' );
    add_domain_values( 'domainName','hedgeAccountingSchemeMethod','' );
    add_domain_values( 'domainName','hedgedRisk','' );
    add_domain_values( 'domainName','hedgeRelationshipConfigurationEndDateMethod','' );
    add_domain_values( 'domainName','hedgeRelationshipConfigurationStartDateMethod','' );
    add_domain_values( 'domainName','hedgeDefinitionType','' );
    add_domain_values( 'domainName','hedgeDefinitionSubclass','' );
    add_domain_values( 'domainName','hedgeDefinitionClassification','' );
    add_domain_values( 'scheduledTask','EOD_HEDGE_EFFECTIVENESS_ANALYSIS','' );
    add_domain_values( 'scheduledTask','EOD_HEDGE_VALUATION','' );
    add_domain_values( 'scheduledTask','EOD_HEDGE_LIQUIDATION','' );
    add_domain_values( 'scheduledTask','EOD_HEDGE_MARKING','' );
    add_domain_values( 'scheduledTask','HEDGE_EVENT_PROCESSING','' );
    add_domain_values( 'scheduledTask','EOD_HEDGE_PROCESSING','' );
    add_domain_values( 'workflowRuleTrade','CheckHedgeDefinition','' );
    add_domain_values( 'workflowRuleTrade','CheckHedgeRelationshipDefinition','' );
    add_domain_values( 'workflowRuleTrade','CheckHedgeRelationshipDefinitionWarning','' );
    add_domain_values( 'sdFilterCriterion.Factory','HedgeRelationship','' );
    add_domain_values( 'CustomAccountingFilterEvent','HedgeAccounting','' );
    add_domain_values( 'CustomTradeWindow','HedgeAccounting','' );
    add_domain_values( 'eventType','HEDGE_BALANCE_VALUATION','' );
    add_domain_values( 'eventType','HEDGE_DESIGNATION_VALUATION','' );
    add_domain_values( 'eventType','TRADE_VALUATION_RELATIONSHIP','' );
    add_domain_values( 'eventType','NEW_HEDGE_RELATIONSHIP','' );
    add_domain_values( 'eventType','MODIFY_HEDGE_RELATIONSHIP','' );
    add_domain_values( 'eventType','REMOVE_HEDGE_RELATIONSHIP','' );
    add_domain_values( 'eventType','EX_HEDGE_RELATIONSHIP_DEFINITION','Exception Generated when a trade in hedge relationship definition is modified' );
    add_domain_values( 'eventType','INACTIVE_RELATIONSHIP','Status of the Hedge Relationship' );
    add_domain_values( 'eventType','TERMINATED_RELATIONSHIP','Status of the Hedge Relationship' );
    add_domain_values( 'eventType','CANCELED_RELATIONSHIP','Status of the Hedge Relationship' );
    add_domain_values( 'eventType','INEFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' );
    add_domain_values( 'eventType','EFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' );
    add_domain_values( 'eventType','PENDING_RELATIONSHIP','Status of the Hedge Relationship' );
    add_domain_values( 'classAuditMode','HedgeDefinition','' );
    add_domain_values( 'classAuditMode','HedgeRelationshipDefinition','' );
    add_domain_values( 'classAuditMode','RelationshipTradeItem','' );
   
    add_domain_values( 'classAuditMode','HedgeRelationshipConfiguration','' );
   
    add_domain_values( 'classAuthMode','HedgeRelationshipDefinition','' );
   
    add_domain_values( 'classAuthMode','HedgeDefinition','' );
   
    add_domain_values( 'classAuthMode','HedgeRelationshipConfiguration','' );
   
    add_domain_values( 'classAuthMode','HedgePricerMeasureMapping','' );
   
    add_domain_values( 'engineName','RelationshipManagerEngine','' );
   
    add_domain_values( 'eventClass','PSEventHedgeAccountingValuation','' );
   
    add_domain_values( 'eventClass','PSEventHedgeRelationshipDefinition','' );
   
    add_domain_values( 'eventClass','PSEventHedgeEffectivenessTest','' );
   
    add_domain_values( 'eventClass','PSEventHedgeDesignationRecord','' );
   
    add_domain_values( 'eventFilter','HedgeRelationshipDefinitionEventFilter','' );
   
    add_domain_values( 'function','CreateHedgeRelationshipDefinition','Access permission to Add Hedge Relationship Definition' );
   
    add_domain_values( 'function','CreateHedgeDefinition','Access permission to Add Hedge Definition' );
   
    add_domain_values( 'function','CreateHedgePricerMeasureMapping','Access permission to Add Hedge Pricer Measure Mapping' );
   
    add_domain_values( 'function','ModifyHedgeRelationshipDefinition','Access permission to Modify Hedge Relationship Definition' );
   
    add_domain_values( 'function','ModifyHedgeDefinition','Access permission to Modify Hedge Definition' );
   
    add_domain_values( 'function','ModifyHedgePricerMeasureMapping','Access permission to Modify Hedge Pricer Measure Mapping' );
   
    add_domain_values( 'function','RemoveHedgeRelationshipDefinition','Access permission to Remove Hedge Relationship Definition' );
   
    add_domain_values( 'function','RemoveHedgeDefinition','Access permission to Remove Hedge Definition' );
   
    add_domain_values( 'function','RemoveHedgePricerMeasureMapping','Access permission to Remove Hedge Pricer Measure Mapping' );
   
    add_domain_values( 'riskAnalysis','HedgeEffectivenessTesting','Retrospective Hedge Effectiveness Testing' );
   
    add_domain_values( 'riskAnalysis','HedgeEffectivenessProTesting','Prospective Hedge Effectiveness Testing' );
   
    add_domain_values( 'HedgeRelationshipDefinitionType','Non-Qualifying Hedge','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','CVAMeasure','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','HedgeEffectivenessDocumentationReview','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','MaterialThreshold','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','MigrationDate','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','MigrationStatus','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','MigrationDeDesignationDate','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','MigrationHETPassCount','' );
   
    add_domain_values( 'hedgeRelationshipDefinitionAttributes','DeactivationDate','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Base Currency','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','OS Code','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','OS Description','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Baseline Amort. End Date','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Basis Amort. End Date','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Deferred Amort. End Date','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Holidays','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Curve Shifting','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Calculate Baseline Adjustment','' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Pricing Param FAS91_PREMDISC_YIELD','pricing parameter FAS91_PREMDISC_YIELD' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Pricing Param HYBRID_AMORTIZATION','pricing parameter HYBRID_AMORTIZATION' );
   
    add_domain_values( 'hedgeAccountingSchemeAttributes','Amortization Method','Amortization method for the trade adjustment' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Check List Template','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','De-designation Fee','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Default HAS','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Pricing Environment','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Accounting Hedge','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Prospective Validation Name','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Retrospective Validation Name','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Four-Eye Term Verification','' );
   
    add_domain_values( 'hedgeDefinitionAttributes','Liquidation Config','' );
   
    add_domain_values( 'hedgeDefinitionSubclass','Cash Flow Hedge','' );
   
    add_domain_values( 'hedgeDefinitionSubclass','Fair Value Hedge','' );
   
    add_domain_values( 'hedgeDefinitionSubclass','Translation Hedge','' );
   
    add_domain_values( 'hedgeDefinitionSubclass','Net Investment Hedge','' );
   
    add_domain_values( 'hedgeDefinitionSubclass','Non-Qualifying Hedge','' );
   
    add_domain_values( 'hedgeDefinitionType','Primary Hedge','' );
   
    add_domain_values( 'hedgeDefinitionType','Secondary Hedge','' );
   
    add_domain_values( 'hedgeAccountingSchemeStandard','FAS','' );
   
    add_domain_values( 'hedgeAccountingSchemeStandard','IAS','' );
   
    add_domain_values( 'hedgeAccountingSchemeMethod','Long Haul','' );
   
    add_domain_values( 'hedgeAccountingSchemeMethod','Shortcut','' );
   
    add_domain_values( 'hedgeAccountingSchemeTestingType','Prospective','' );
   
    add_domain_values( 'hedgeAccountingSchemeTestingType','Retrospective','' );
   
    add_domain_values( 'hedgeAccountingSchemeTestingType','Both','' );
   
    add_domain_values( 'hedgeAccountingSchemeValidationType','Day','' );
   
    add_domain_values( 'hedgeAccountingSchemeValidationType','Week','' );
   
    add_domain_values( 'hedgeDefinitionAttributes.Check List Template','HedgeDocumentationCheckList.tmpl','' );
   
    add_domain_values( 'hedgeDefinitionClassification','Hedge','' );
   
    add_domain_values( 'hedgeDefinitionClassification','Strategy','');
   
    add_domain_values( 'hedgeDefinitionClassification','Bundle','' );
   
    add_domain_values( 'hedgedRisk','Translation Risk','' );
   
    add_domain_values( 'hedgedRisk','Interest Rate Risk','' );
   
    add_domain_values( 'hedgedRisk','Interest Rate in Base','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationEndDateMethod','MaxEnteredDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationEndDateMethod','MaxMaturityDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationEndDateMethod','MaxTradeDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationEndDateMethod','MinEnteredDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationEndDateMethod','MinMaturityDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationEndDateMethod','MinTradeDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationStartDateMethod','MaxEnteredDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationStartDateMethod','MaxMaturityDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationStartDateMethod','MaxTradeDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationStartDateMethod','MinEnteredDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationStartDateMethod','MinMaturityDate','' );
   
    add_domain_values( 'hedgeRelationshipConfigurationStartDateMethod','MinTradeDate','' );
   
    add_domain_values( 'MirrorKeywords','Hedge','' );
   
    add_domain_values( 'workflowType','HedgeRelationshipDefinition','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','NONE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','CANCELED','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','EFFECTIVE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','INACTIVE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','PENDING','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','INEFFECTIVE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','TERMINATED','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','HYPOTHETICAL','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionStatus','UNAPPROVED','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','CANCEL','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','DESIGNATE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','DE_DESIGNATE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','NEW','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','REPROCESS','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','TERMINATE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','UPDATE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','MIGRATE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','APPROVE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','DEACTIVATE','' );
   
    add_domain_values( 'HedgeRelationshipDefinitionAction','END_SHORTCUT','' );
   
    add_domain_values( 'workflowRuleHedgeRelationshipDefinition','Reprocess','' );
   
    add_domain_values( 'workflowRuleHedgeRelationshipDefinition','ReprocessEconomic','' );
   
    add_domain_values( 'workflowRuleHedgeRelationshipDefinition','EndShortcut','' );
   
    add_domain_values( 'workflowRuleHedgeRelationshipDefinition','Approve','' );
   
    add_domain_values( 'workflowRuleHedgeRelationshipDefinition','CheckEndDate','' );
   
    add_domain_values( 'workflowRuleHedgeRelationshipDefinition','CheckFullTermination','' );
   
    add_domain_values( 'workflowRuleHedgeRelationshipDefinition','Deactivation','' );
   
    add_domain_values( 'buySideServer','buysideserver1','Default buy side server 1' );
   
    add_domain_values( 'buySideServer','buysideserver2','Default buy side server 2' );
   
    add_domain_values( 'buySideServer','buysideserver3','Default buy side server 3' );
   
    add_domain_values( 'function','ViewBenchmark','Allow User to query and view Benchmark entries' );
   
    add_domain_values( 'function','ViewBenchmarkRecord','Allow User to query and view Benchmark record entries' );
   
    add_domain_values( 'function','AuthorizeBenchmark','Access permission to Authorize Benchmarks' );
   
    add_domain_values( 'function','CreateBenchmark','Access permission to Create Benchmark' );
    add_domain_values( 'function','ModifyBenchmark','Access permission to Modify Benchmark' );
    add_domain_values( 'function','RemoveBenchmark','Access permission to Remove Benchmark' );
    add_domain_values( 'function','CreateBenchmarkRecord','Access permission to Create Benchmark records' );
    add_domain_values( 'function','ModifyBenchmarkRecord','Access permission to Modify Benchmark records' );
    add_domain_values( 'function','RemoveBenchmarkRecord','Access permission to Remove Benchmark records');
    add_domain_values( 'function','PortfolioWorkstationConfig','Function authorizing access to Portfolio Workstation configuration' );
    add_domain_values( 'function','PortfolioWorkstationViewServerConfig','Access permission to view Portfolio Workstation server configuration' );
    add_domain_values( 'function','PortfolioWorkstationAddModifyRemoveServerConfig','Access permission to edit Portfolio Workstation server configuration' );
    add_domain_values( 'function','PWSColumnViewConfig','Access permission to view Portfolio Workstation analyses columns' );
    add_domain_values( 'function','PWSColumnAddModifyRemoveConfig','Access permission to edit Portfolio Workstation analyses columns' );
    add_domain_values( 'function','PWSColumnSetViewConfig','Access permission to view Portfolio Workstation analyses columns sets' );
    add_domain_values( 'function','PWSColumnSetAddModifyRemoveConfig','Access permission to edit Portfolio Workstation analyses columns sets' );
    add_domain_values( 'function','PWSGroupingViewConfig','Access permission to view Portfolio Workstation columns groupings' );
    add_domain_values( 'function','PWSGroupingAddModifyRemoveConfig','Access permission to edit Portfolio Workstation columns groupings' );
    add_domain_values( 'function','PWSWidgetViewConfig','Access permission to view Portfolio Workstation widgets configuration' );
    add_domain_values( 'function','PWSWidgetAddModifyRemoveConfig','Access permission to edit Portfolio Workstation widgets configuration' );
    add_domain_values( 'function','PWSLayoutViewConfig','Access permission to view Portfolio Workstation layouts configuration' );
    add_domain_values( 'function','PWSLayoutAddModifyRemoveConfig','Access permission to edit Portfolio Workstation layouts configuration' );
    add_domain_values( 'function','PWSUnitViewConfig','Access permission to view Portfolio Workstation units configuration' );
    add_domain_values( 'function','PWSUnitAddModifyRemoveConfig','Access permission to edit Portfolio Workstation units configuration' );
    add_domain_values( 'function','AMGrouping','Access permission to view grouping information' );
    add_domain_values( 'function','AMModifyGrouping','Access permission to modify grouping information' );
    add_domain_values( 'classAuditMode','Benchmark','' );
    add_domain_values( 'classAuthMode','Benchmark','' );
    add_domain_values( 'scheduledTask','BENCHMARK_IMPORT','Import Benchmark compositions' );
    add_domain_values( 'scheduledTask','BENCHMARK_MIGRATE','Migrate Benchmarks from Carve out and Market Indices' );
    add_domain_values( 'scheduledTask','BENCHMARK_ARCHIVE','Archive Benchmarks above a given retention period' );
    add_domain_values( 'scheduledTask','EOD_PLMARKING_PRODUCT','Saving PLMarks by product under markType Product' );
    add_domain_values( 'scheduledTask','AM_ANALYSES_START','Start Portfolio Workstation preconfigured analyses, for chosen Funds' );
    add_domain_values( 'scheduledTask','AM_ANALYSES_STOP','Stop Portfolio Workstation preconfigured analyses, for chosen Funds' );
end if;
end;
/
