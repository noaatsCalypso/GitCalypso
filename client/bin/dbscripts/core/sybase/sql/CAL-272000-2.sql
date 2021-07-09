declare @regriskasset int
begin
  select @regriskasset=count(*) from sysobjects , syscolumns 
        where sysobjects.id = syscolumns.id
        and sysobjects.name = 'regrisk_asset'
        and syscolumns.name = 'asset_id'
  
  if (@regriskasset = 1)
  begin
    exec('drop table regrisk_asset')
    exec('drop table regrisk_product')
  end
end
go


declare @x int
begin
    select @x=count(*) from calypso_database_upgrade_audit where name = 'CAL-272000' and version = 1
    if (@x = 1)
    begin
    -- we have been run before
        -- so drop tables, that only core created and didn't use
        -- the regrisk_asset/regrisk_product tables will be cleaned up by installation of regulatory risk module
        exec('drop table regrisk_bucket')
        exec('drop table regrisk_bucket_name')
        exec('drop table regrisk_bucket_cf')
        exec('drop table regrisk_bucket_cf_position')
        exec('drop table regrisk_bucket_co')
        exec('drop table regrisk_bucket_co_position')
        exec('drop table regrisk_bucket_eq_position')
        exec('drop table regrisk_params')
        exec('drop table regrisk_product_asset')
        exec('drop table regrisk_results')
        exec('drop table regrisk_risk_measure')
        exec('drop table regrisk_risk_measure_result')
        exec('drop table regrisk_rejected_trades')
    end
    else
    -- no install, regrisk_* tables will not be now created
    -- N.B. this applies to version 2 of script, if version 3 created then above would need changing to version <=2
    begin
        if not exists (select 1 from sysobjects where type='U' and name='calypso_hierarchy')
        begin
        exec ('create table calypso_hierarchy ( tree_id numeric not null,  tree_name varchar(255) not null,  tree_type varchar(255) not null )')
        exec ('ALTER TABLE calypso_hierarchy ADD CONSTRAINT pk_calypso_hierarchy2 PRIMARY KEY ( tree_id )')
        end


        if not exists (select 1 from sysobjects where type='U' and name='calypso_hierarchy_node_value')
        begin
        exec ('create table calypso_hierarchy_node_value ( node_id numeric  not null,  node_value varchar(255) not null )')
        exec ('ALTER TABLE calypso_hierarchy_node_value ADD CONSTRAINT pk_calypso_hierarchy1 PRIMARY KEY ( node_id, node_value )')
        end


        if not exists (select 1 from sysobjects where type='U' and name='calypso_hierarchy_node')
        begin
        exec ('CREATE TABLE calypso_hierarchy_node ( tree_id numeric  not null,  node_id numeric not null,  node_name varchar(255) not null,  parent_node_id numeric  not null )')
        exec ('ALTER TABLE calypso_hierarchy_node ADD CONSTRAINT pk_calypso_hierarchy3 PRIMARY KEY ( tree_id, node_id )')
        end

         
        INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ExternalTrade.ANY.ANY','PricerExternalTrade' )

		if not exists (select 1 from pricer_measure where measure_name ='FTP_ALL_IN_RATE')
		begin
        INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ('FTP_ALL_IN_RATE','tk.pricer.PricerMeasureFTPAllInRate',414 )
		end

        INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PV01_PAYLEG','tk.core.PricerMeasure',464,'PV01 for Swap Pay Leg' )

        INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PV01_RECLEG','tk.core.PricerMeasure',465,'PV01 for Swap Receive Leg' )

        INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ('INDEX_SUBFAMILY','string',0,0,0,'CDSIndex',0 )

        INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list, version_num ) VALUES ('INDEX_ACTIVE_VERSION','string',0,0,0,'CDSIndex',0 )

        INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('RESET_INFLATION_FROM_CURVE','java.lang.Boolean','true,false','',1,'false' )

        INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('ACCRUAL_ON_LAST_QUOTE','java.lang.Boolean','true,false','For Brazilian IGPM Inflation Swaps, calculate inflation performance factor based on last published inflation quotes.',1 )

        if not exists (select 1 from calypso_seed where seed_name ='FTPPaymentSchedule')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'FTPPaymentSchedule',10 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='FTPCostComponentRule')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'FTPCostComponentRule',10 )
            end

        if not exists (select 1 from calypso_seed where seed_name ='FTPRateRetrievalConfig')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'FTPRateRetrievalConfig',10 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='LIQUIDITY_RULE')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'LIQUIDITY_RULE',500 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='HedgeAccountingScheme')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeAccountingScheme',1 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='DesignationRecords')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'DesignationRecords',1 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='RelationshipTradeItem')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'RelationshipTradeItem',1 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='HedgeRelationship')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationship',1 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='HedgeStrategy')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeStrategy',1 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='HedgeRelationshipConfig')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationshipConfig',500 )
        end

        if not exists (select 1 from calypso_seed where seed_name ='BenchmarkComposition')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'BenchmarkComposition',100 )
        end


        if not exists (select 1 from calypso_seed where seed_name ='Benchmark')
        begin
        INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'Benchmark',100 )
        end


        INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (10000,'DefaultClient','MasterConfirmation',0,'NonTransactional','LFU' )

        INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (20000,'DefaultServer','MasterConfirmation',0,'NonTransactional','LFU' )

        INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (10000,'DefaultServer','Benchmark',0,'Calypso','LFU' )

        INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES (10000,'DefaultClient','Benchmark',0,'NonTransactional','LFU' )

        INSERT INTO calypso_hierarchy ( tree_id, tree_name, tree_type ) VALUES (500,'BASEL SA-CCR','COMMODITIES' )

        INSERT INTO calypso_hierarchy ( tree_id, tree_name, tree_type ) VALUES (501,'BASEL SA-MR','COMMODITIES' )

        INSERT INTO calypso_hierarchy ( tree_id, tree_name, tree_type ) VALUES (502,'BASEL SA-MR','EQUITIES' )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,100,'SA-CCR',0 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,101,'ELECTRICITY',100 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,102,'OIL_GAS',100 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,103,'METALS',100 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,104,'AGRICULTURAL',100 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (500,105,'OTHER',100 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,106,'SA-MR',0 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,107,'COAL',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,108,'CRUDE_OIL',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,109,'ELECTRICITY',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,110,'FREIGHT',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,111,'METALS',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,112,'NATURAL_GAS',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,113,'PRECIOUS_METALS',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,114,'OTHER',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,115,'GRAINS_OILSEED',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,116,'LIVESTOCK_DAIRY',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,117,'SOFTS_OTHER_AG',106 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,118,'NYMEX WTI',108 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,119,'ICE BRENT',108 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,120,'NYMEX SILVER',113 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,121,'NYSE LIFFE SILVER',113 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,122,'NYSE LIFFE GOLD',113 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,123,'UNLEADED GASOLINE',114 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,124,'LME ALUMINIUM',111 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,125,'LME COPPER',111 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,126,'ARABICA COFFEE',117 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,127,'CBOT CORN',115 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,128,'CBOT GOLD',113 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,129,'CBOT SILVER',114 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,130,'CBOT SOYBEAN',115 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,131,'ICE NATURAL GAS',112 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,132,'SA-MR',0 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,133,'SMALL',132 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,134,'LARGE',132 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,135,'EMERGING',133 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,136,'developed',133 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,137,'ALL',135 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,138,'ALL',136 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,139,'EMERGING',134 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,140,'DEVELOPED',134 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,141,'CONSUMER_UTILITIES',139 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,142,'TELECOM_INDUSTRIALS',139 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,143,'MATERIALS_ENERGY',139 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,144,'FINANCIAL_TECHNOLOGY',139 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,145,'CONSUMER_UTILITIES',140 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,146,'TELECOM_INDUSTRIALS',140 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,147,'MATERIALS_ENERGY',140 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,148,'FINANCIAL_TECHNOLOGY',140 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,149,'AAPL',145 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,150,'GE',146 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (502,151,'MSFT',148 )

        INSERT INTO calypso_hierarchy_node ( tree_id, node_id, node_name, parent_node_id ) VALUES (501,152,'NYMEX NATURAL GAS',112 )

        exec add_domain_values 'engineName','LiquidityPositionPersistenceEngine','Liquidity Context position persistence engine'

        exec add_domain_values 'eventClass','PSEventExternalMovement','Event type for Liquidity External Movement' 

        exec add_domain_values 'scheduledTask','REINITIALIZE_CONTEXT_POSITIONS','Reinitialize context positions.' 

        exec add_domain_values 'scheduledTask','CLEAN_UP_CONTEXT_POSITION','Scheduled Task to delete all data referenced by selected inactive Context Position Bucket Configs' 

        exec add_domain_values 'productTypeReportStyle','ContextPosition','Context Position Report Style' 

        exec add_domain_values 'eventFilter','LiquidityContextPositionEventFilter','Context Position Persistence engine event filter' 

        exec add_domain_values 'tradeKeyword','LiquidityPositionRetailTrade','Trade keyword to identify Retail Trades in Liquidity Server' 

        exec add_domain_values 'scheduledTask','REVERSE_INTRADAY_SETTLED','Reverse context positions for all MT940/950 for the day' 

        exec add_domain_values 'domainName','ContextPosition.subtype','ContextPosition subtypes' 

        exec add_domain_values 'ContextPosition.subtype','Unknown','' 

        exec add_domain_values 'ContextPosition.subtype','TradingCash','' 

        exec add_domain_values 'ContextPosition.subtype','TradingSecurity','' 

        exec add_domain_values 'ContextPosition.subtype','ReferenceCostCash','' 

        exec add_domain_values 'ContextPosition.subtype','LiquidityPremiumCash','' 

        exec add_domain_values 'ContextPosition.subtype','SyntheticReferenceCostCash','' 

        exec add_domain_values 'ContextPosition.subtype','SyntheticBasisCostCash','' 

        exec add_domain_values 'ContextPosition.subtype','SyntheticLiquidityPremiumCash','' 

        exec add_domain_values 'ContextPosition.subtype','SyntheticCollateralizedLiquidityPremiumCash','' 

        exec add_domain_values 'productType','ContextPosition','Context Position as a product type for registrating cross asset components' 

        exec add_domain_values 'classAccessMode','ContextPositionFilters','' 

        exec add_domain_values 'function','AddContextPositionFilters','AccessPermission for ability to add ContextPositionFilter' 

        exec add_domain_values 'function','ModifyContextPositionFilters','AccessPermission for ability to modify ContextPositionFilter' 

        exec add_domain_values 'function','RemoveContextPositionFilters','AccessPermission for ability to remove ContextPositionFilter' 

        exec add_domain_values 'function','AddModifyContextPositionBucketConfigs','AccessPermission for ability to Add or Modify ContextPositionBucketConfigs' 

        exec add_domain_values 'function','AddModifyContextPositionMovementAttributes','AccessPermission for ability to Add or Modify ContextPositionMovementAttributes' 

        exec add_domain_values 'function','AddModifyContextPositionBucketScope','AccessPermission for ability to Add or Modify ContextPositionBucketScope' 

        exec add_domain_values 'function','AddModifyContextPositionReinitializeJob','AccessPermission for ability to Add or Modify ContextPositionReinitializeJob' 

        exec add_domain_values 'engineserver.types','LiquidityServer','' 

        exec add_domain_values 'engineserver.unmanaged.types','LiquidityServer','' 

        exec add_domain_values 'domainName','LiquidityServer.instances','' 

        exec add_domain_values 'domainName','LiquidityServer.engines','' 

        exec add_domain_values 'LiquidityServer.instances','liquidityserver','' 

        exec add_domain_values 'LiquidityServer.engines','LiquidityPositionPersistenceEngine','' 

        exec add_domain_values 'domainName','FtpCostComponentNames','FTP Cost Component names' 

        exec add_domain_values 'FtpCostComponentNames','SWAP_COST','Swap Cost' 

        exec add_domain_values 'FtpCostComponentNames','BASIS_COST','Basis Cost' 

        exec add_domain_values 'FtpCostComponentNames','LIQUIDITY_PREMIUM','Liquidity Premium' 

        exec add_domain_values 'FtpCostComponentNames','ADMINISTRATIVE_COST','Administrative Cost' 

        exec add_domain_values 'FtpCostComponentNames','LAB_COST','LAB Cost' 

        exec add_domain_values 'FtpCostComponentNames','FUNDING_PRINCIPAL_COST','Funding Risk' 

        exec add_domain_values 'FtpCostComponentNames','THEORETICAL_BASIS_COST','Basis Cost at trade inception' 

        exec add_domain_values 'FtpCostComponentNames','THEORETICAL_LIQUIDITY_PREMIUM','Liquidity premium at trade inception' 

        exec add_domain_values 'FtpCostComponentNames','THEORETICAL_REFERENCE_COST','Reference Cost at trade inception' 

        exec add_domain_values 'FtpCostComponentNames','MANAGEMENT_OVERLAY_COST','Management Overlay Cost' 

        exec add_domain_values 'FtpCostComponentNames','CREDIT_COST','Credit Cost' 

        exec add_domain_values 'FtpCostComponentNames','HEDGING_BM_SPREAD_COST','Hedging Benchmark Spread Risk' 

        exec add_domain_values 'FtpCostComponentNames','FUNDING_BM_SPREAD_COST','Funding Benchmark Spread Risk' 

        exec add_domain_values 'FtpCostComponentNames','COLL_LIQUIDITY_PREMIUM','Collateralized Liquidity Premium' 

        exec add_domain_values 'workflowRuleTrade','TradeFTP','' 

        exec add_domain_values 'eventFilter','FTPEngineEventFilter','Event filter for FTP Engine.' 

        exec add_domain_values 'engineName','FTPEngine','FTP engine' 

        exec add_domain_values 'tradeAction','FTP_TRADE_UPDATE','Action applied on trades processed and saved by the FTP engine' 

        exec add_domain_values 'scheduledTask','EOD_FTP_COST_ACCRUAL','' 

        exec add_domain_values 'scheduledTask','EOD_GENERATE_FTP_TRADE','' 

        exec add_domain_values 'scheduledTask','GEN_LIQUIDITY_PREM_INDEX_QUOTES','' 

        exec add_domain_values 'eventType','EX_EOD_FTP_COST_ACCRUAL_SUCCESS','The FTP cost accrual scheduled task was successful.' 

        exec add_domain_values 'eventType','EX_EOD_FTP_COST_ACCRUAL_FAILURE','The FTP cost accrual scheduled task was not successful.' 

        exec add_domain_values 'exceptionType','GEN_LIQUIDITY_PREM_INDEX_QUOTES_FAILURE','' 

        exec add_domain_values 'exceptionType','EOD_FTP_COST_ACCRUAL_SUCCESS','' 

        exec add_domain_values 'exceptionType','EOD_FTP_COST_ACCRUAL_FAILURE','' 

        exec add_domain_values 'eventType','EX_EOD_GENERATE_FTP_TRADE_SUCCESS','The FTP trade generation scheduled task was successful.' 

        exec add_domain_values 'eventType','EX_EOD_GENERATE_FTP_TRADE_FAILURE','The FTP trade generation scheduled task was not successful.' 

        exec add_domain_values 'exceptionType','EOD_GENERATE_FTP_TRADE_SUCCESS','' 

        exec add_domain_values 'exceptionType','EOD_GENERATE_FTP_TRADE_FAILURE','' 

        exec add_domain_values 'exceptionType','FTP_ACCRUAL_GENERATION','Exception while generating accruals for a Trade.' 

        exec add_domain_values 'exceptionType','FTP_COST_CONVERSION_CALCULATION','Exception while converting rate into index conventions for a Trade.' 

        exec add_domain_values 'exceptionType','FTP_COST_CALCULATION','Exception while calculating the cost for a trade cost component.' 

        exec add_domain_values 'exceptionType','FTP_SYNTHETIC_TRADE_EXPLODE','Exception while creating/publishing synthetic trades.' 

        exec add_domain_values 'flowType','FTP_COST','FTP Cost flow type' 

        exec add_domain_values 'flowType','FUNDING_RISK','Funding Principal Cost flow type' 

        exec add_domain_values 'function','ModifyFTPRule','Access permission to modify FTP rules' 

        exec add_domain_values 'function','ViewFTPRule','Access permission to view FTP rules' 

        exec add_domain_values 'domainName','CashMenuItemNames','Cash product specific MenuItem names' 

        exec add_domain_values 'CashMenuItemNames','FTPCostComponent','FTP Cost Component menu item' 

        exec add_domain_values 'CashMenuItemNames','FTPRefreshRule','FTP Refresh Rule menu item' 

        exec add_domain_values 'domainName','FtpLiquidationConfig','FTP Liquidation Config' 

        exec add_domain_values 'domainName','FtpPositionAggregation','FTP Position Aggregation' 

        exec add_domain_values 'FtpLiquidationConfig','DEFAULT','FTP Liquidation Config value' 

        exec add_domain_values 'domainName','FtpEngineProcessingStatus','Trade statuses accepted by FTP Engine' 

        exec add_domain_values 'FtpEngineProcessingStatus','VERIFIED','' 

        exec add_domain_values 'FtpEngineProcessingStatus','CANCELED','' 

        exec add_domain_values 'FtpEngineProcessingStatus','TERMINATED','' 

        exec add_domain_values 'flowType','FTP_ADMINISTRATIVE_COST','FTP Cost flow type' 

        exec add_domain_values 'flowType','FTP_BASIS_COST','FTP Cost flow type' 

        exec add_domain_values 'flowType','FTP_LAB_COST','FTP Cost flow type' 

        exec add_domain_values 'flowType','FTP_SWAP_COST','FTP Reference Cost flow type' 

        exec add_domain_values 'flowType','FTP_LIQUIDITY_PREMIUM','FTP Cost flow type' 

        exec add_domain_values 'flowType','FTP_FUNDING_PRINCIPAL_COST','FTP Funding Cost flow type' 

        exec add_domain_values 'flowType','FTP_MANAGEMENT_OVERLAY_COST','FTP Cost flow type' 

        exec add_domain_values 'flowType','FTP_CREDIT_COST','FTP Cost flow type' 

        exec add_domain_values 'flowType','FTP_HEDGING_BM_SPREAD_COST','FTP Cost flow type for HEDGING_BM_SPREAD_COST' 

        exec add_domain_values 'flowType','FTP_FUNDING_BM_SPREAD_COST','FTP Cost flow type for FUNDING_BM_SPREAD_COST' 

        exec add_domain_values 'flowType','FTP_COLL_LIQUIDITY_PREMIUM','FTP Cost flow type' 

        exec add_domain_values 'currencyDefaultAttribute','LiquidityPremiumIndex','Currency Attribute to identify Liquidity Premium Cost Index Name' 

        exec add_domain_values 'currencyDefaultAttribute','LiquidityPremiumIndexSource','Currency Attribute to identify Liquidity Premium Cost Source Name' 

        exec add_domain_values 'tradeKeyword','BehavioralMaturityTenor','Trade Behavioral Maturity Tenor' 

        exec add_domain_values 'tradeKeyword','FTPReferenceCostHedgeSwapTradeId','Hedge Trade Id for Reference Cost' 

        exec add_domain_values 'tradeKeyword','FTPSyntheticHedgeIndex','Index Name for the Hedge trade to be synthetically created for auto calculation of FTP Costs' 

        exec add_domain_values 'tradeKeyword','FTPSyntheticHedgeIndexSource','Index Source Name for the Hedge trade to be synthetically created for auto calculation of FTP Costs' 

        exec add_domain_values 'tradeKeyword','FTPSyntheticHedgeIndexTenor','Index Tenor Name for the Hedge trade to be synthetically created for auto calculation of FTP Costs' 

        exec add_domain_values 'tradeKeyword','FTPAccrualStartDate','Trade Keyword for providing the accrual start date for a particular trade that will override the trade start date' 

        exec add_domain_values 'tradeKeyword','FTP_HEDGING_LEG','Leg type for Swap identifying the Leg that represents the Hedge value as PAY or RECEIVE' 

        exec add_domain_values 'tradeKeyword','FTP_FUNDING_LEG','Leg type for Swap identifying the Leg that represents the Funded Trade value as PAY or RECEIVE' 

        exec add_domain_values 'tradeKeyword','FTP_LIQUIDITY_PREMIUM_RATE_INDEX','Liquidity Premium Rate Index to be used for shifting curve when discounting liquidity premium hedge trades or positions' 

        exec add_domain_values 'eventClass','PSEventLiquiditySyntheticTrade','' 

        exec add_domain_values 'rateIndexAttributes','InputMethod','' 

        exec add_domain_values 'rateIndexAttributes','MMLiquidTenor','' 

        exec add_domain_values 'rateIndexAttributes','MMCurve','' 

        exec add_domain_values 'rateIndexAttributes','MarketCurve','' 

        exec add_domain_values 'rateIndexAttributes','BaseLiquidityPremium','' 

        exec add_domain_values 'rateIndexAttributes','BaseRateIndex','' 

        exec add_domain_values 'function','AddLiquidityRuleLimit','AccessPermission for ability to Add LiquidityLimitRule' 

        exec add_domain_values 'function','ModifyLiquidityRuleLimit','AccessPermission for ability to Modify LiquidityLimitRule' 

        exec add_domain_values 'function','DeleteLiquidityRuleLimit','AccessPermission for ability to Delete LiquidityLimitRule' 

        exec add_domain_values 'domainName','BankingFlows.extendedType','Domain Name that defines BankingFlows Extended Type' 

        exec add_domain_values 'BankingFlows.extendedType','ACCOUNT','Extended Type ACCOUNT' 

        exec add_domain_values 'BankingFlows.extendedType','DEPOSIT','Extended Type DEPOSIT' 

        exec add_domain_values 'BankingFlows.extendedType','LOAN','Extended Type LOAN' 

        exec add_domain_values 'accountProperty','isLABPosition','Property that helps to identify if account positions are to processed for LAB' 

        exec add_domain_values 'domainName','timeBucket','Domain Name that defines Time Buckets' 

        exec add_domain_values 'timeBucket','800','Time bucket defined for 8:00 AM' 

        exec add_domain_values 'timeBucket','900','Time bucket defined for 9:00 AM' 

        exec add_domain_values 'timeBucket','1000','Time bucket defined for 10:00 AM' 

        exec add_domain_values 'timeBucket','1100','Time bucket defined for 11:00 AM' 

        exec add_domain_values 'timeBucket','1200','Time bucket defined for 12:00 PM' 

        exec add_domain_values 'timeBucket','1300','Time bucket defined for 1:00 PM' 

        exec add_domain_values 'timeBucket','1400','Time bucket defined for 2:00 AM' 

        exec add_domain_values 'timeBucket','1500','Time bucket defined for 3:00 PM' 

        exec add_domain_values 'timeBucket','1600','Time bucket defined for 4:00 PM' 

        exec add_domain_values 'timeBucket','1700','Time bucket defined for 5:00 PM' 

        exec add_domain_values 'timeBucket','1800','Time bucket defined for 6:00 PM' 

        exec add_domain_values 'scheduledTask','REBUILD_LIQUIDITY_POSITIONS','Scheduled Task for rebuilding positions for liquidity management' 

        exec add_domain_values 'currencyDefaultAttribute','SwiftMessage205AccountId','Currency Attribute to identify Account for an MT205 message' 

        exec add_domain_values 'customCriterion','Liquidity','Enable custom TradeFilter criterion for Liquidity' 

        exec add_domain_values 'scheduledTask','RESET_FLOATING_RATE_NOTES','Reset Liquidity Floating Rate Notes' 

        exec add_domain_values 'scheduledTask','LIQUIDITY_UPGRADE_TASK','Liquidity Program based Upgrade tasks' 

        exec add_domain_values 'InventorySecBucketFactory','CallableSec','Callable security position factory' 

        exec add_domain_values 'function','TaskStation_SummaryPanelConfig_ADD','Allow User to add a summary panel configuration rule' 

        exec add_domain_values 'function','TaskStation_SummaryPanelConfig_DELETE','Allow User to delete a summary panel configuration rule' 

        exec add_domain_values 'function','TaskStation_SummaryPanelConfig_CHANGE','Allow User to chnage a summary panel configuration rule' 

        exec add_domain_values 'domainName','CollateralPolicy','Collateral Policy for Credit Support Annex' 

        exec add_domain_values 'domainName','surfaceExpiryTenors','Volatility surface expiry tenor' 

        exec add_domain_values 'surfaceExpiryTenors','2D',''

        exec add_domain_values 'surfaceExpiryTenors','1W' ,''

        exec add_domain_values 'surfaceExpiryTenors','2W' ,''

        exec add_domain_values 'surfaceExpiryTenors','3W' ,''

        exec add_domain_values 'surfaceExpiryTenors','1M' ,''

        exec add_domain_values 'engineParam','MCC_PRICING_ENV','Specify the pricing-env to be used by the Market Conformity Module engines.' 

        exec add_domain_values 'engineParam','MCC_FEED_NAME','Specify the market data feed name to be used by the Market Conformity Module engines.' 

        exec add_domain_values 'engineParam','MCC_INTRA_MONITOR_PRICING_ENV','If true, Intraday Market Data Engine responds to external changes to market data and pricing environment.' 

        exec add_domain_values 'engineParam','MCC_INTRA_FIXED_RATE','If true, Intraday Market Data Engine saves quotes every x minutes.' 

        exec add_domain_values 'engineParam','MCC_INTRA_DELAY','Intraday Market Data Engine waits no. of minutes, executes tasks and starts the timers for subsequent executions .' 

        exec add_domain_values 'engineParam','MCC_TRADE_FILTER_NAME','Redefine name of Market Conformity Engine trade filter from default MARKET_CONFORMITY.' 

        exec add_domain_values 'engineParam','MCC_IGNORE_CONFIG_CHANGES','If true, trade filter configuration changes are ignored by the Market Conformity engine.' 

        exec add_domain_values 'engineParam','MCC_DATE_KEYWORD','Set a trade keyword name that represents the trade entered date/time in Market Conformity Engine.' 

        exec add_domain_values 'domainName','ExternalTrade.Pricer','Pricers for external trades' 

        exec add_domain_values 'REPORT.Types','CAApplyTrade','CAApplyTrade Report' 

        exec add_domain_values 'REPORT.Types','CAApplyTradeSimulation','CAApplyTradeSimulation Report' 

        exec add_domain_values 'REPORT.Types','CAElectedOption','CAElectedOption Report' 

        exec add_domain_values 'REPORT.Types','CAReconciliation','CAReconciliation Report' 

        exec add_domain_values 'REPORT.Types','CA','CA Report' 

        exec add_domain_values 'REPORT.Types','SecurityMatching','Security Matching Window' 

        exec add_domain_values 'REPORT.Types','Rebase','Rebase Report' 

        exec add_domain_values 'domainName','tradeUpfrontFeeType','Domain name to hold upfront fee definitions for all products accept CDS, LCDS and CDSIndex' 

        exec add_domain_values 'tradeUpfrontFeeType','UPFRONT_FEE','Fee definition name for upfront fee for all products accept CDS, LCDS and CDSIndex' 

        exec add_domain_values 'domainName','ExternalTrade.subtype','Types of External Trades' 

        exec add_domain_values 'classAuthMode','Trade','Manual Trade Workflow Auth.' 

        exec add_domain_values 'volatilityType','BOND_YIELD','Market Yield Volatility' 

        exec add_domain_values 'ExternalMessageField.MessageMapper','MT340','' 

        exec add_domain_values 'ExternalMessageField.MessageMapper','MT341','' 

        exec add_domain_values 'feeCalculator','ISDARisklessAccrual','Fee calculator interface for riskless accrual part of upfront fee' 

        exec add_domain_values 'feeCalculator','ISDARiskyAccrual','Fee calculator interface for risky accrual part of upfront fee' 

        exec add_domain_values 'scheduledTask','SA_MR','' 

        exec add_domain_values 'scheduledTask','SA_CCR','' 

        exec add_domain_values 'scheduledTask','UPDATE_STATUS','' 

        exec add_domain_values 'workflowRuleTrade','CheckValidDomiciliationChange','The rule checks if the book change on the trade is for the same domiciliation.' 

        exec add_domain_values 'PLPositionProduct.Pricer','PricerSpreadCapFloorGBM2FHagan','' 

        exec add_domain_values 'ExternalTrade.Pricer','PricerExternalTrade','' 

        exec add_domain_values 'CreditDefaultSwap.subtype','SNAC','Subtype Standard North American Contract CDS. For choosing PricerCreditDefaultSwapFlat' 

        exec add_domain_values 'eventClass','PSEventUpdateStatus','' 

        exec add_domain_values 'exceptionType','TARGET2_INFO','' 

        exec add_domain_values 'exceptionType','TARGET2_NOBIC','' 

        exec add_domain_values 'exceptionType','TARGET2_EXCEPTION','' 

        exec add_domain_values 'function','CreateQuoteValueAdjustment','Access permission to add a QuoteValueAdjustment' 

        exec add_domain_values 'function','ModifyQuoteValueAdjustment','Access permission to modify a QuoteValueAdjustment' 

        exec add_domain_values 'function','RemoveQuoteValueAdjustment','Access permission to remove a QuoteValueAdjustment' 

        exec add_domain_values 'yieldMethod','Exp_ACT365','Exponential method using ACT365 convention' 

        exec add_domain_values 'yieldMethod','MXN','Yield Method for Mexican Bonds.' 

        exec add_domain_values 'FutureContractAttributes','UseIndexPrice','Use underlying Index to calculate Notional' 

        exec add_domain_values 'FutureContractAttributes.UseIndexPrice','Yes','' 

        exec add_domain_values 'FutureContractAttributes.UseIndexPrice','No','' 

        exec add_domain_values 'sdFilterCriterion.Factory','Equity','build Equity Static Data Filter criteria' 

        exec add_domain_values 'tradeKeyword','ReOpen','Applies to PricerBankofThailad. If set to true, the bond should be priced according to auction conventions (to calculate the interpolated rate, use BIBOR rates on trade date -2' 

        exec add_domain_values 'domainName','keyword.ReOpen','' 

        exec add_domain_values 'keyword.ReOpen','true','' 

        exec add_domain_values 'keyword.ReOpen','false','' 

        exec add_domain_values 'LifeCycleEvent','tk.lifecycle.event.BermudanExerciseEvent','Bermudan Exercise' 

        exec add_domain_values 'LifeCycleEventProcessor','tk.lifecycle.processor.BermudanExerciseEventProcessor','Bermudan Exercise' 

        exec add_domain_values 'LifeCycleEventTrigger','tk.lifecycle.trigger.BermudanExerciseTrigger','Pricing Script Bermudan Exercise' 

        exec add_domain_values 'tradeKeyword','DividendReqAccountingEventAmount','' 

        exec add_domain_values 'domainName','CABOPositionBalanceType','' 

        exec add_domain_values 'domainName','propagateToCAElectionAttribute','' 

        exec add_domain_values 'propagateToCAElectionAttribute','ContractDivRate','' 

        exec add_domain_values 'MTMFeeType','UPFRONT_FEE','' 

        exec add_domain_values 'productFamily','ExternalTrade','' 

        exec add_domain_values 'productTypeReportStyle','ExternalTrade','' 

        exec add_domain_values 'domainName','externalTradeFieldType','' 

        exec add_domain_values 'externalTradeFieldType','Integer','' 

        exec add_domain_values 'externalTradeFieldType','Boolean','' 

        exec add_domain_values 'externalTradeFieldType','Double','' 

        exec add_domain_values 'externalTradeFieldType','String','' 

        exec add_domain_values 'externalTradeFieldType','JDate','' 

        exec add_domain_values 'externalTradeFieldType','JDatetime','' 

        exec add_domain_values 'externalTradeFieldType','List','' 

        exec add_domain_values 'externalTradeFieldType','Product','' 

        exec add_domain_values 'externalTradeFieldType','Category','' 

        exec add_domain_values 'externalTradeFieldType','Amount','' 

        exec add_domain_values 'externalTradeFieldType','Matrix','' 

        exec add_domain_values 'domainName','ExternalTradeFieldSQL','' 

        exec add_domain_values 'ExternalTradeFieldSQL','List','' 

        exec add_domain_values 'ExternalTradeFieldSQL','Product','' 

        exec add_domain_values 'ExternalTradeFieldSQL','Category','' 

        exec add_domain_values 'ExternalTradeFieldSQL','Amount','' 

        exec add_domain_values 'ExternalTradeFieldSQL','Matrix','' 

        exec add_domain_values 'domainName','hedgeRelationshipDefinitionAttributes','' 

        exec add_domain_values 'domainName','HedgeRelationshipDefinitionType','' 

        exec add_domain_values 'domainName','workflowRuleHedgeRelationshipDefinition','' 

        exec add_domain_values 'domainName','hedgeDefinitionAttributes','' 

        exec add_domain_values 'domainName','hedgeAccountingSchemeAttributes','' 

        exec add_domain_values 'domainName','hedgeAccountingSchemeStandard','' 

        exec add_domain_values 'domainName','hedgeAccountingSchemeMethod','' 

        exec add_domain_values 'domainName','hedgedRisk','' 

        exec add_domain_values 'domainName','hedgeRelationshipConfigurationEndDateMethod','' 

        exec add_domain_values 'domainName','hedgeRelationshipConfigurationStartDateMethod','' 

        exec add_domain_values 'domainName','hedgeDefinitionType','' 

        exec add_domain_values 'domainName','hedgeDefinitionSubclass','' 

        exec add_domain_values 'domainName','hedgeDefinitionClassification','' 

        exec add_domain_values 'scheduledTask','EOD_HEDGE_EFFECTIVENESS_ANALYSIS','' 

        exec add_domain_values 'scheduledTask','EOD_HEDGE_VALUATION','' 

        exec add_domain_values 'scheduledTask','EOD_HEDGE_LIQUIDATION','' 

        exec add_domain_values 'scheduledTask','EOD_HEDGE_MARKING','' 

        exec add_domain_values 'scheduledTask','HEDGE_EVENT_PROCESSING','' 

        exec add_domain_values 'scheduledTask','EOD_HEDGE_PROCESSING','' 

        exec add_domain_values 'workflowRuleTrade','CheckHedgeDefinition','' 

        exec add_domain_values 'workflowRuleTrade','CheckHedgeRelationshipDefinition','' 

        exec add_domain_values 'workflowRuleTrade','CheckHedgeRelationshipDefinitionWarning','' 

        exec add_domain_values 'sdFilterCriterion.Factory','HedgeRelationship','' 

        exec add_domain_values 'CustomAccountingFilterEvent','HedgeAccounting','' 

        exec add_domain_values 'CustomTradeWindow','HedgeAccounting','' 

        exec add_domain_values 'eventType','HEDGE_BALANCE_VALUATION','' 

        exec add_domain_values 'eventType','HEDGE_DESIGNATION_VALUATION','' 

        exec add_domain_values 'eventType','TRADE_VALUATION_RELATIONSHIP','' 

        exec add_domain_values 'eventType','NEW_HEDGE_RELATIONSHIP','' 

        exec add_domain_values 'eventType','MODIFY_HEDGE_RELATIONSHIP','' 

        exec add_domain_values 'eventType','REMOVE_HEDGE_RELATIONSHIP','' 

        exec add_domain_values 'eventType','EX_HEDGE_RELATIONSHIP_DEFINITION','Exception Generated when a trade in hedge relationship definition is modified' 

        exec add_domain_values 'eventType','INACTIVE_RELATIONSHIP','Status of the Hedge Relationship' 

        exec add_domain_values 'eventType','TERMINATED_RELATIONSHIP','Status of the Hedge Relationship' 

        exec add_domain_values 'eventType','CANCELED_RELATIONSHIP','Status of the Hedge Relationship' 

        exec add_domain_values 'eventType','INEFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' 

        exec add_domain_values 'eventType','EFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' 

        exec add_domain_values 'eventType','PENDING_RELATIONSHIP','Status of the Hedge Relationship' 

        exec add_domain_values 'classAuditMode','HedgeDefinition','' 

        exec add_domain_values 'classAuditMode','HedgeRelationshipDefinition','' 

        exec add_domain_values 'classAuditMode','RelationshipTradeItem','' 

        exec add_domain_values 'classAuditMode','HedgeRelationshipConfiguration','' 

        exec add_domain_values 'classAuthMode','HedgeRelationshipDefinition','' 

        exec add_domain_values 'classAuthMode','HedgeDefinition','' 

        exec add_domain_values 'classAuthMode','HedgeRelationshipConfiguration','' 

        exec add_domain_values 'classAuthMode','HedgePricerMeasureMapping','' 

        exec add_domain_values 'engineName','RelationshipManagerEngine','' 

        exec add_domain_values 'eventClass','PSEventHedgeAccountingValuation','' 

        exec add_domain_values 'eventClass','PSEventHedgeRelationshipDefinition','' 

        exec add_domain_values 'eventClass','PSEventHedgeEffectivenessTest','' 

        exec add_domain_values 'eventClass','PSEventHedgeDesignationRecord','' 

        exec add_domain_values 'eventFilter','HedgeRelationshipDefinitionEventFilter','' 

        exec add_domain_values 'function','CreateHedgeRelationshipDefinition','Access permission to Add Hedge Relationship Definition' 

        exec add_domain_values 'function','CreateHedgeDefinition','Access permission to Add Hedge Definition' 

        exec add_domain_values 'function','CreateHedgePricerMeasureMapping','Access permission to Add Hedge Pricer Measure Mapping' 

        exec add_domain_values 'function','ModifyHedgeRelationshipDefinition','Access permission to Modify Hedge Relationship Definition' 

        exec add_domain_values 'function','ModifyHedgeDefinition','Access permission to Modify Hedge Definition' 

        exec add_domain_values 'function','ModifyHedgePricerMeasureMapping','Access permission to Modify Hedge Pricer Measure Mapping' 

        exec add_domain_values 'function','RemoveHedgeRelationshipDefinition','Access permission to Remove Hedge Relationship Definition' 

        exec add_domain_values 'function','RemoveHedgeDefinition','Access permission to Remove Hedge Definition' 

        exec add_domain_values 'function','RemoveHedgePricerMeasureMapping','Access permission to Remove Hedge Pricer Measure Mapping' 

        exec add_domain_values 'riskAnalysis','HedgeEffectivenessTesting','Retrospective Hedge Effectiveness Testing' 

        exec add_domain_values 'riskAnalysis','HedgeEffectivenessProTesting','Prospective Hedge Effectiveness Testing' 

        exec add_domain_values 'HedgeRelationshipDefinitionType','Non-Qualifying Hedge','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','CVAMeasure','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','HedgeEffectivenessDocumentationReview','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','MaterialThreshold','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationDate','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationStatus','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationDeDesignationDate','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','MigrationHETPassCount','' 

        exec add_domain_values 'hedgeRelationshipDefinitionAttributes','DeactivationDate','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Base Currency','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','O/S Code','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','O/S Description','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Baseline Amort. End Date','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Basis Amort. End Date','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Deferred Amort. End Date','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Holidays','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Curve Shifting','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Calculate Baseline Adjustment','' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Pricing Param FAS91_PREMDISC_YIELD','pricing parameter FAS91_PREMDISC_YIELD' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Pricing Param HYBRID_AMORTIZATION','pricing parameter HYBRID_AMORTIZATION' 

        exec add_domain_values 'hedgeAccountingSchemeAttributes','Amortization Method','Amortization method for the trade adjustment' 

        exec add_domain_values 'hedgeDefinitionAttributes','Check List Template','' 

        exec add_domain_values 'hedgeDefinitionAttributes','De-designation Fee','' 

        exec add_domain_values 'hedgeDefinitionAttributes','Default HAS','' 

        exec add_domain_values 'hedgeDefinitionAttributes','Pricing Environment','' 

        exec add_domain_values 'hedgeDefinitionAttributes','Accounting Hedge','' 

        exec add_domain_values 'hedgeDefinitionAttributes','Prospective Validation Name','' 

        exec add_domain_values 'hedgeDefinitionAttributes','Retrospective Validation Name','' 

        exec add_domain_values 'hedgeDefinitionAttributes','Four-Eye Term Verification','' 

        exec add_domain_values 'hedgeDefinitionAttributes','Liquidation Config','' 

        exec add_domain_values 'hedgeDefinitionSubclass','Cash Flow Hedge','' 

        exec add_domain_values 'hedgeDefinitionSubclass','Fair Value Hedge','' 

        exec add_domain_values 'hedgeDefinitionSubclass','Translation Hedge','' 

        exec add_domain_values 'hedgeDefinitionSubclass','Net Investment Hedge','' 

        exec add_domain_values 'hedgeDefinitionSubclass','Non-Qualifying Hedge','' 

        exec add_domain_values 'hedgeDefinitionType','Primary Hedge','' 

        exec add_domain_values 'hedgeDefinitionType','Secondary Hedge','' 

        exec add_domain_values 'hedgeAccountingSchemeStandard','FAS','' 

        exec add_domain_values 'hedgeAccountingSchemeStandard','IAS','' 

        exec add_domain_values 'hedgeAccountingSchemeMethod','Long Haul','' 

        exec add_domain_values 'hedgeAccountingSchemeMethod','Shortcut','' 

        exec add_domain_values 'hedgeAccountingSchemeTestingType','Prospective','' 

        exec add_domain_values 'hedgeAccountingSchemeTestingType','Retrospective','' 

        exec add_domain_values 'hedgeAccountingSchemeTestingType','Both','' 

        exec add_domain_values 'hedgeAccountingSchemeValidationType','Day','' 

        exec add_domain_values 'hedgeAccountingSchemeValidationType','Week','' 

        exec add_domain_values 'hedgeDefinitionAttributes.Check List Template','HedgeDocumentationCheckList.tmpl','' 

        exec add_domain_values 'hedgeDefinitionClassification','Hedge','' 

        exec add_domain_values 'hedgeDefinitionClassification','Strategy',''

        exec add_domain_values 'hedgeDefinitionClassification','Bundle','' 

        exec add_domain_values 'hedgedRisk','Translation Risk','' 

        exec add_domain_values 'hedgedRisk','Interest Rate Risk','' 

        exec add_domain_values 'hedgedRisk','Interest Rate in Base','' 

        exec add_domain_values 'hedgeRelationshipConfigurationEndDateMethod','MaxEnteredDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationEndDateMethod','MaxMaturityDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationEndDateMethod','MaxTradeDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationEndDateMethod','MinEnteredDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationEndDateMethod','MinMaturityDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationEndDateMethod','MinTradeDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationStartDateMethod','MaxEnteredDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationStartDateMethod','MaxMaturityDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationStartDateMethod','MaxTradeDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationStartDateMethod','MinEnteredDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationStartDateMethod','MinMaturityDate','' 

        exec add_domain_values 'hedgeRelationshipConfigurationStartDateMethod','MinTradeDate','' 

        exec add_domain_values 'MirrorKeywords','Hedge','' 

        exec add_domain_values 'workflowType','HedgeRelationshipDefinition','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','NONE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','CANCELED','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','EFFECTIVE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','INACTIVE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','PENDING','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','INEFFECTIVE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','TERMINATED','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','HYPOTHETICAL','' 

        exec add_domain_values 'HedgeRelationshipDefinitionStatus','UNAPPROVED','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','CANCEL','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','DESIGNATE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','DE_DESIGNATE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','NEW','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','REPROCESS','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','TERMINATE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','UPDATE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','MIGRATE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','APPROVE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','DEACTIVATE','' 

        exec add_domain_values 'HedgeRelationshipDefinitionAction','END_SHORTCUT','' 

        exec add_domain_values 'workflowRuleHedgeRelationshipDefinition','Reprocess','' 

        exec add_domain_values 'workflowRuleHedgeRelationshipDefinition','ReprocessEconomic','' 

        exec add_domain_values 'workflowRuleHedgeRelationshipDefinition','EndShortcut','' 

        exec add_domain_values 'workflowRuleHedgeRelationshipDefinition','Approve','' 

        exec add_domain_values 'workflowRuleHedgeRelationshipDefinition','CheckEndDate','' 

        exec add_domain_values 'workflowRuleHedgeRelationshipDefinition','CheckFullTermination','' 

        exec add_domain_values 'workflowRuleHedgeRelationshipDefinition','Deactivation','' 

        exec add_domain_values 'buySideServer','buysideserver1','Default buy side server 1' 

        exec add_domain_values 'buySideServer','buysideserver2','Default buy side server 2' 

        exec add_domain_values 'buySideServer','buysideserver3','Default buy side server 3' 

        exec add_domain_values 'function','ViewBenchmark','Allow User to query and view Benchmark entries' 

        exec add_domain_values 'function','ViewBenchmarkRecord','Allow User to query and view Benchmark record entries' 

        exec add_domain_values 'function','AuthorizeBenchmark','Access permission to Authorize Benchmarks' 

        exec add_domain_values 'function','CreateBenchmark','Access permission to Create Benchmark' 

        exec add_domain_values 'function','ModifyBenchmark','Access permission to Modify Benchmark' 

        exec add_domain_values 'function','RemoveBenchmark','Access permission to Remove Benchmark' 

        exec add_domain_values 'function','CreateBenchmarkRecord','Access permission to Create Benchmark records' 

        exec add_domain_values 'function','ModifyBenchmarkRecord','Access permission to Modify Benchmark records' 

        exec add_domain_values 'function','RemoveBenchmarkRecord','Access permission to Remove Benchmark records'

        exec add_domain_values 'function','PortfolioWorkstationConfig','Function authorizing access to Portfolio Workstation configuration' 

        exec add_domain_values 'function','PortfolioWorkstationViewServerConfig','Access permission to view Portfolio Workstation server configuration' 

        exec add_domain_values 'function','PortfolioWorkstationAddModifyRemoveServerConfig','Access permission to edit Portfolio Workstation server configuration' 

        exec add_domain_values 'function','PWSColumnViewConfig','Access permission to view Portfolio Workstation analyses columns' 

        exec add_domain_values 'function','PWSColumnAddModifyRemoveConfig','Access permission to edit Portfolio Workstation analyses columns' 

        exec add_domain_values 'function','PWSColumnSetViewConfig','Access permission to view Portfolio Workstation analyses columns sets' 

        exec add_domain_values 'function','PWSColumnSetAddModifyRemoveConfig','Access permission to edit Portfolio Workstation analyses columns sets' 

        exec add_domain_values 'function','PWSGroupingViewConfig','Access permission to view Portfolio Workstation columns groupings' 

        exec add_domain_values 'function','PWSGroupingAddModifyRemoveConfig','Access permission to edit Portfolio Workstation columns groupings' 

        exec add_domain_values 'function','PWSWidgetViewConfig','Access permission to view Portfolio Workstation widgets configuration' 

        exec add_domain_values 'function','PWSWidgetAddModifyRemoveConfig','Access permission to edit Portfolio Workstation widgets configuration' 

        exec add_domain_values 'function','PWSLayoutViewConfig','Access permission to view Portfolio Workstation layouts configuration' 

        exec add_domain_values 'function','PWSLayoutAddModifyRemoveConfig','Access permission to edit Portfolio Workstation layouts configuration' 

        exec add_domain_values 'function','PWSUnitViewConfig','Access permission to view Portfolio Workstation units configuration' 

        exec add_domain_values 'function','PWSUnitAddModifyRemoveConfig','Access permission to edit Portfolio Workstation units configuration' 

        exec add_domain_values 'function','AMGrouping','Access permission to view grouping information' 

        exec add_domain_values 'function','AMModifyGrouping','Access permission to modify grouping information' 

        exec add_domain_values 'classAuditMode','Benchmark','' 

        exec add_domain_values 'classAuthMode','Benchmark','' 

        exec add_domain_values 'scheduledTask','BENCHMARK_IMPORT','Import Benchmark compositions' 

        exec add_domain_values 'scheduledTask','BENCHMARK_MIGRATE','Migrate Benchmarks from Carve out and Market Indices' 

        exec add_domain_values 'scheduledTask','BENCHMARK_ARCHIVE','Archive Benchmarks above a given retention period' 

        exec add_domain_values 'scheduledTask','EOD_PLMARKING_PRODUCT','Saving PLMarks by product under markType Product' 

        exec add_domain_values 'scheduledTask','AM_ANALYSES_START','Start Portfolio Workstation preconfigured analyses, for chosen Funds' 

        exec add_domain_values 'scheduledTask','AM_ANALYSES_STOP','Stop Portfolio Workstation preconfigured analyses, for chosen Funds' 


    end
end
go