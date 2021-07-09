 
/* CAL-157568 */

create or replace procedure trade_filter_mat_dtfix
is
 begin
    declare
    cursor cur_main4 is
    select trade_filter_name from trfilter_minmax_dt where CRITERION_NAME='FinalValuationDate' and (date_operator <> 'Is null' or date_operator <> 'Is not null');
arg_trade_filter_name varchar2(255) ;
x number := 0;
   begin
  open cur_main4;
          fetch cur_main4 into arg_trade_filter_name ;
  while cur_main4 %FOUND
loop
select count(*) into x from trade_filter_crit,trade_filter where trade_filter.trade_filter_name=trade_filter_crit.trade_filter_name 
and trade_filter_crit.criterion_name ='NULL_MATURITY_CRITERIA' and trade_filter_crit.criterion_value='NO' and trade_filter_crit.is_in_b=1
and not exists (select count(*) from TRADE_FILTER_CRIT 
where trade_filter_name= arg_trade_filter_name 
and criterion_name='includeNull'
and  criterion_value='FinalValuationDate'
and is_in_b=1);
        if x = 0 then
        insert into TRADE_FILTER_CRIT (trade_filter_name , criterion_name, criterion_value, is_in_b ) values (arg_trade_filter_name,'includeNull','FinalValuationDate',1);
     end if;
        fetch cur_main4 into arg_trade_filter_name ;
end loop;
end;
exception 
  when dup_val_on_index then null; 
end;
/ 
 
begin
  trade_filter_mat_dtfix;
end;
/
drop procedure trade_filter_mat_dtfix
;

begin
add_column_if_not_exists ('perf_swap_leg','ret_fx_reset_lag_bus_day_b', 'number DEFAULT 0 NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg','ret_fx_reset_lag_offset', 'number DEFAULT 0 NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg','ret_fx_reset_lag_dateroll', 'varchar2(16) NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg','ret_fx_reset_lag_holidays', 'varchar2(128) NULL');
end;
/

update perf_swap_leg set ret_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and ret_fx_reset_lag_bus_day_b is null
;
update perf_swap_leg set ret_fx_reset_lag_offset = 0 where fx_reset_id > 0 and ret_fx_reset_lag_offset is null
;
update perf_swap_leg set ret_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and ret_fx_reset_lag_dateroll is null
;

begin
add_column_if_not_exists ('perf_swap_leg','income_fx_reset_lag_bus_day_b', 'number DEFAULT 0 NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg','income_fx_reset_lag_offset', 'number DEFAULT 0 NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg','income_fx_reset_lag_dateroll', 'varchar2(16) NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg','income_fx_reset_lag_holidays', 'varchar2(128) NULL');
end;
/
update perf_swap_leg set income_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and income_fx_reset_lag_bus_day_b is null
;
update perf_swap_leg set income_fx_reset_lag_offset = 0 where fx_reset_id > 0 and income_fx_reset_lag_offset is null
;
update perf_swap_leg set income_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and income_fx_reset_lag_dateroll is null
;

begin
add_column_if_not_exists ('perf_swap_leg_hist','ret_fx_reset_lag_bus_day_b', 'number DEFAULT 0 NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg_hist','ret_fx_reset_lag_offset', 'number DEFAULT 0 NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg_hist','ret_fx_reset_lag_dateroll','varchar2(16) NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg_hist','ret_fx_reset_lag_holidays','varchar2(128) NULL');
end;
/
update perf_swap_leg_hist set ret_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and ret_fx_reset_lag_bus_day_b is null
;
update perf_swap_leg_hist set ret_fx_reset_lag_offset = 0 where fx_reset_id > 0 and ret_fx_reset_lag_offset is null
;
update perf_swap_leg_hist set ret_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and ret_fx_reset_lag_dateroll is null
;
begin
add_column_if_not_exists ('perf_swap_leg_hist','income_fx_reset_lag_bus_day_b', 'number DEFAULT 0 NULL');
end;
/
begin 
add_column_if_not_exists ('perf_swap_leg_hist','income_fx_reset_lag_offset', 'number DEFAULT 0 NULL');
end;
/
begin 
add_column_if_not_exists ('perf_swap_leg_hist','income_fx_reset_lag_dateroll', 'varchar2(16) NULL');
end;
/
begin
add_column_if_not_exists ('perf_swap_leg_hist','income_fx_reset_lag_holidays','varchar2(128) NULL');
end;
/
update perf_swap_leg_hist set income_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and income_fx_reset_lag_bus_day_b is null
;
update perf_swap_leg_hist set income_fx_reset_lag_offset = 0 where fx_reset_id > 0 and income_fx_reset_lag_offset is null
;
update perf_swap_leg_hist set income_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and income_fx_reset_lag_dateroll is null
;

/* REL-8365 */

CREATE OR REPLACE PROCEDURE add_table
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
        EXECUTE IMMEDIATE 'create table forward_start_parameters ( product_id numeric not null,
        fixing_date timestamp null,atm_percent float,
        fxreset numeric null)';
  
    END IF;
END add_table;
/
begin
add_table ('forward_start_parameters');
end;
/

begin
add_column_if_not_exists ('forward_start_parameters','atm_percent' ,'float');
add_column_if_not_exists ('forward_start_parameters','strike_style','number(3,0)');
add_column_if_not_exists ('forward_start_parameters','atm_spot','number(3,0)');
add_column_if_not_exists ('forward_start_parameters','atm_forward','number(3,0)');

end;
/

update forward_start_parameters set strike_style = 1 where atm_spot = 1
;
update forward_start_parameters set strike_style = 2 where atm_forward = 1
;
update forward_start_parameters set strike_value = atm_percent
;
alter table forward_start_parameters drop (atm_spot, atm_forward)
;

/* REL-8412 */

CREATE OR REPLACE PROCEDURE add_table
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
        EXECUTE IMMEDIATE 'CREATE TABLE plmethodology_info ( book_id numeric  NOT NULL,  product_type varchar2 (32) NOT NULL,  strategy numeric  NULL,  cash_type numeric  NULL )';
  
    END IF;
END add_table;
/

BEGIN
add_table('plmethodology_info');
END;
/
  

DECLARE 

CURSOR  plmethodology_info_crsr IS
select book_id, product_type, strategy, cash_type 
from plmethodology_info;

tmp_book_id number;
tmp_product_type VARCHAR(255);
tmp_strategy VARCHAR(255);
tmp_accrual_type VARCHAR(255);
tmp_cash_type VARCHAR(255);
countvar INT;
tmp_rowcnt INT;

BEGIN

	countvar := 0;
	
	FOR tab_rec in plmethodology_info_crsr LOOP
	
		tmp_book_id := tab_rec.book_id;
		tmp_product_type := tab_rec.product_type;
		tmp_strategy := null;
		tmp_accrual_type := null;
		tmp_cash_type := null;
	
		IF ( tab_rec.cash_type = 0 ) THEN 
			tmp_strategy:='MTM';
			tmp_accrual_type:='Settle Date Accrual';
		ELSIF ( tab_rec.cash_type = 1 ) THEN
			tmp_strategy:='Accrual';
			tmp_accrual_type:='Settle Date Accrual';
		ELSIF ( tab_rec.cash_type = 2 ) THEN
			tmp_strategy:='MTM';
			tmp_accrual_type:='Trade Date Accrual';
		END	IF;
		
		IF ( tab_rec.strategy = 0 ) THEN 
			tmp_cash_type:='Settle Date Cash';
		ELSIF ( tab_rec.strategy = 1 ) THEN
			tmp_cash_type:='Trade Date Cash';
		ELSE
			tmp_cash_type:='Settle Date Cash';
		END	IF;
		
		IF (( tmp_strategy is not null ) 
			and ( tmp_accrual_type  is not null ) 
			and ( tmp_cash_type  is not null ) ) 
		THEN
      		
      		select count(*) 
      		into tmp_rowcnt 
      		from pl_methodology 
      		where book_id = tmp_book_id 
      		and product_type = tmp_product_type;
      		
        	IF tmp_rowcnt = 0 THEN
				INSERT INTO pl_methodology(book_id, product_type, description)
				VALUES (tmp_book_id, tmp_product_type, tmp_strategy || ' - ' || tmp_cash_type || ' - ' || tmp_accrual_type);
			END IF;
		END IF;
	    countvar:=countvar+1;
	END LOOP;

END;
/

begin
add_domain_values('domainName','expressProductTypes','specify the product types that support express analysis' );
end;
/
begin
add_domain_values('expressProductTypes','Equity','Cash Equities' );
end;
/
begin
add_domain_values('expressProductTypes','EquityLinkedSwap','Equity Swaps' );
end;
/
begin
add_domain_values('expressProductTypes','ADR','ADR' );
end;
/
begin
add_domain_values('expressProductTypes','FutureEquityIndex','Exchange Traded Equity Index Future' );
end;
/
begin
add_domain_values('expressProductTypes','CFD','Need clarification' );
end;
/
begin
add_domain_values('expressProductTypes','FutureDividend','Dividend Future' );
end;
/
begin
add_domain_values('expressProductTypes','ETOEquity','Listed Equity Options' );
end;
/
begin
add_domain_values('expressProductTypes','ETOEquityIndex','Exchange traded equity index options' );
end;
/
begin
add_domain_values('expressProductTypes','Warrant','Warrants' );
end;
/
begin
add_domain_values('expressProductTypes','FutureVolatility','Exchange traded futures on volatility' );
end;
/
begin
add_domain_values('expressProductTypes','ETOVolatility','Exchange traded options on volatility' );
end;
/
begin
add_domain_values('expressProductTypes','FutureCommodity','Exchange traded commodity futures' );
end;
/
begin
add_domain_values('expressProductTypes','ETOCommodity','Exchange traded commodity options' );
end;
/
begin
add_domain_values('expressProductTypes','Bond',';verment and Corporate Bonds' );
end;
/
begin
add_domain_values('expressProductTypes','BondFRN','FRN' );
end;
/
begin
add_domain_values('expressProductTypes','FutureBond',';verment Bond Futures' );
end;
/
begin
add_domain_values('expressProductTypes','FutureOptionBond',';verment Bond Future Options' );
end;
/
begin
add_domain_values('expressProductTypes','FutureOptionSwap','Exchange Traded IR Future Options' );
end;
/
begin
add_domain_values('expressProductTypes','FutureSwap','Exchange Traded IR Futures' );
end;
/
begin
add_domain_values('expressProductTypes','FX','FX Spot' );
end;
/
begin
add_domain_values('expressProductTypes','FutureFX','Exchange traded currency future' );
end;
/
begin
add_domain_values('expressProductTypes','ETOFX','Exchange traded currency future options' );
end;
/
begin
add_domain_values('expressProductTypes','CFDDirectional','CFDs' );
end;
/
begin
add_domain_values('domainName','AdvanceSSLTemplate','specify the SingleSwapLeg trade template name to be used by hypersurface advance generator' );
end;
/
begin
add_domain_values('productTypeReportStyle','PerformanceSwap','PerformanceSwapReportStyle' );
end;
/
begin
add_domain_values('function','ViewQuoteTab','Allow User to see the quote tab in the curve window' );
end;
/
begin
add_domain_values('function','ViewTrade','Allow User to query and view trade records' );
end;
/
begin
add_domain_values('function','ViewTransfer','Allow User to query and view transfer records' );
end;
/
begin
add_domain_values('function','ViewAccount','Allow User to query and view account entries' );
end;
/
begin
add_domain_values('function','ViewMessage','Allow User to query and view back office messages' );
end;
/
begin
add_domain_values('function','ViewInventoryCashPosition','Allow User to query and view  inventory cash position entries' );
end;
/
begin
add_domain_values('function','ViewLegalEntity','Allow User to query and view legal entity entries' );
end;
/
begin
add_domain_values('function','ViewSDI','Allow User to query and view SDI entries' );
end;
/
begin
add_domain_values('productType','BOCashSettlement','BOCashSettlement' );
end;
/
begin
add_domain_values('domainName','XferPosAggregation','' );
end;
/
begin
add_domain_values('domainName','callAccountExceptionHandler ','List of CallAccount exception handler.' );
end;
/
begin
add_domain_values('domainName','AccountSetup','' );
end;
/
begin
add_domain_values('MsgAttributes.CashStatementProcess','SubStatement.Unknown','' );
end;
/
begin
add_domain_values('remittanceType','Repayment','' );
end;
/
begin
add_domain_values('remittanceType','IntradayRepayment','' );
end;
/
begin
add_domain_values('engineParam','XFER_USE_POS_AGGREGATION_ONLY','' );
end;
/
begin
add_domain_values('function','AuthorizeCDSIndexDefinition','' );
end;
/
begin
add_domain_values('function','AuthorizeReferenceEntityBasket','' );
end;
/
begin
add_domain_values('function','AuthorizeReferenceEntityTranche','' );
end;
/
begin
add_domain_values('domainName','AccountProductTemplateNotEditable','' );
end;
/
begin
add_domain_values('measuresForAdjustment','MARKET_VALUE','' );
end;
/
begin
add_domain_values('measuresForAdjustment','Cash','' );
end;
/
begin
add_domain_values('domainName','UnitizedFund.Pricer','Pricers for Unitized Funds' );
end;
/
begin
add_domain_values('domainName','MultiMDIGenerators','Generators that support muliple simulataneous curve generation.' );
end;
/
begin
add_domain_values('MultiMDIGenerators','DoubleGlobalM','Generate two curves together.' );
end;
/
begin
add_domain_values('CurveZero.gen','DoubleGlobalM','Generate two curves together.' );
end;
/
begin
add_domain_values('Warrant.Attributes','MINI','MINI' );
end;
/
begin
add_domain_values('domainName','hedgeRelationshipConfigStartDateMethod','hedgeRelationshipConfigStartDateMethod' );
end;
/
begin
add_domain_values('domainName','hedgeRelationshipConfigEndDateMethod','hedgeRelationshipConfigEndDateMethod' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigStartDateMethod','MaxEnteredDate','MaxEnteredDate' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigStartDateMethod','MaxStartDate','MaxStartDate' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigStartDateMethod','MaxTradeDate','MaxTradeDate' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigStartDateMethod','MinEnteredDate','MinEnteredDate' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigStartDateMethod','MinStartDate','MinStartDate' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigStartDateMethod','MinTradeDate','MinTradeDate' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigEndDateMethod','MaxMaturityDate','MaxMaturityDate' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigEndDateMethod','MinMaturityDate','MinMaturityDate' );
end;
/
begin
add_domain_values('domainName','ScriptableOTCProduct.subtype','Types of ScriptableOTCProduct' );
end;
/
begin
add_domain_values('domainName','SecLending.subtype','Types of SecLending' );
end;
/
begin
add_domain_values('domainName','Advance.ForwardAdjustmentDays','' );
end;
/
begin
add_domain_values('domainName','Advance.subtype','Types of Advance' );
end;
/
begin
add_domain_values('domainName','Advance.cate;ry','Cate;ries of Advance' );
end;
/
begin
add_domain_values('domainName','Advance.CollateralType','List of collateral types for Advance' );
end;
/
begin
add_domain_values('domainName','Advance.CICAProgram','List of CICA Programs for Advance' );
end;
/
begin
add_domain_values('domainName','MarketMeasureCalculators','Calulators for Market Measures' );
end;
/
begin
add_domain_values('domainName','MarketMeasureTrigger','Triggers for Market Measures' );
end;
/
begin
add_domain_values('domainName','MarketMeasureCriterion','Criterion that can be defined for Market Measures' );
end;
/
begin
add_domain_values('MarketMeasureCalculators','COFRateConversion','' );
end;
/
begin
add_domain_values('MarketMeasureCalculators','ForwardAdj','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','Exotic','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','FixedRate','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','FloatingRate','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','ForwardStarting','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','Inactive','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','None','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','Optionality','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','NotionalSize','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','NotionalStepUp','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','ProductType','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','RateIndex','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','CollateralType','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','HasCICAProgram','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','HasPPSAdjustment','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','IsPuttable','' );
end;
/
begin
add_domain_values('MarketMeasureTrigger','IsCallable','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','MaturityDate','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','MemberStatus','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','FirstExerciseDate','' );
end;
/
begin
add_domain_values('MarketMeasureCriterion','Strike','' );
end;
/
begin
add_domain_values('MarketMeasureCalculators','Default','' );
end;
/
begin
add_domain_values('MarketMeasureCalculators','DefaultWAL','' );
end;
/
begin
add_domain_values('domainName','Advance.NotionalSize','List of Notional Sizes for Advance' );
end;
/
begin
add_domain_values('Advance.NotionalSize','1000000.','' );
end;
/
begin
add_domain_values('Advance.NotionalSize','2000000.','' );
end;
/
begin
add_domain_values('Advance.NotionalSize','3000000.','' );
end;
/
begin
add_domain_values('domainName','Advance.NotionalStepUp','List of Notional StepUps for Advance' );
end;
/
begin
add_domain_values('Advance.NotionalStepUp','1000000.','' );
end;
/
begin
add_domain_values('Advance.NotionalStepUp','2000000.','' );
end;
/
begin
add_domain_values('Advance.NotionalStepUp','3000000.','' );
end;
/
begin
add_domain_values('domainName','Advance.ProductType','List of Product Types for Advance' );
end;
/
begin
add_domain_values('Advance.ProductType','ARC','' );
end;
/
begin
add_domain_values('Advance.ProductType','Call Account Funded','' );
end;
/
begin
add_domain_values('Advance.ProductType','FRC','' );
end;
/
begin
add_domain_values('Advance.ProductType','Structured','' );
end;
/
begin
add_domain_values('Advance.ProductType','VRC','' );
end;
/
begin
add_domain_values('domainName','Advance.Strike','Strike Values' );
end;
/
begin
add_domain_values('Advance.Strike','1.0','' );
end;
/
begin
add_domain_values('Advance.Strike','2.0','' );
end;
/
begin
add_domain_values('Advance.Strike','3.0','' );
end;
/
begin
add_domain_values('domainName','Advance.RateIndex','Indices used in Advance' );
end;
/
begin
add_domain_values('Advance.RateIndex','NONE','' );
end;
/
begin
add_domain_values('Advance.RateIndex','USD/LIBOR/3M/BBA','' );
end;
/
begin
add_domain_values('domainName','Advance.MaturityDate','Maturity Dates for Advance' );
end;
/
begin
add_domain_values('Advance.MaturityDate','1M','' );
end;
/
begin
add_domain_values('Advance.MaturityDate','6M','' );
end;
/
begin
add_domain_values('Advance.MaturityDate','1Y','' );
end;
/
begin
add_domain_values('domainName','Advance.FirstExerciseDate','First Exercise Dates for Advance' );
end;
/
begin
add_domain_values('Advance.FirstExerciseDate','1M','' );
end;
/
begin
add_domain_values('Advance.FirstExerciseDate','2M','' );
end;
/
begin
add_domain_values('Advance.FirstExerciseDate','3M','' );
end;
/
begin
add_domain_values('domainName','AdvanceLetterCredit.subtype','List of Letter of Credit Types' );
end;
/
begin
add_domain_values('domainName','AdvanceLetterCredit.DelegatedAuthority','List of Delegated Authorities' );
end;
/
begin
add_domain_values('SingleSwapLeg.Pricer','PricerSingleSwapLegCDSIndexExotic','Pricer for Single Swap Leg CDS Index - CRA' );
end;
/
begin
add_domain_values('marketDataUsage','Advance','' );
end;
/
begin
add_domain_values('marketDataUsage','AdvanceTemplate','' );
end;
/
begin
add_domain_values('PositionBasedProducts','FutureOptionDividend','FutureOptionDividend out of box position based product' );
end;
/
begin
add_domain_values('PositionBasedProducts','FXTakeUp','' );
end;
/
begin
add_domain_values('PositionBasedProducts','FXCash','' );
end;
/
begin
add_domain_values('ProductUseTermFrame','Repo','' );
end;
/
begin
add_domain_values('ProductUseTermFrame','SecLending','' );
end;
/
begin
add_domain_values('ProductUseTermFrame','Cash','' );
end;
/
begin
add_domain_values('systemKeyword','needToDoInterestCleanup','' );
end;
/
begin
add_domain_values('creditMktDataUsage','YIELD','Yield Or Yield Spread Curves.' );
end;
/
begin
add_domain_values('futureOptUnderType','Dividend','' );
end;
/
begin
add_domain_values('tradeKeyword','HedgeRecommendation','' );
end;
/
begin
add_domain_values('systemKeyword','HedgeRecommendation','' );
end;
/
begin
add_domain_values('tradeAction','SETVALDT','Set val date for FXSpotReserve' );
end;
/
begin
add_domain_values('tradeStatus','TTM_SPOTRES','' );
end;
/
begin
add_domain_values('tradeStatus','INACTIVE_ORDER','' );
end;
/
begin
add_domain_values('productType','AdvanceLetterCredit','AdvanceLetterCredit' );
end;
/
begin
add_domain_values('EquityStructuredOption.subtype','FWDSTART','FWDSTART option Product subtype' );
end;
/
begin
add_domain_values('tradeStatus','PENDING_ORDER','' );
end;
/
begin
add_domain_values('tradeStatus','LIVE_ORDER','' );
end;
/
begin
add_domain_values('tradeStatus','REJECTED_ORDER','' );
end;
/
begin
add_domain_values('tradeStatus','EXECUTED_ORDER','' );
end;
/
begin
add_domain_values('tradeStatus','PARTIAL_EXECUTED_ORDER','' );
end;
/
begin
add_domain_values('tradeStatus','CANCELED_ORDER','' );
end;
/
begin
add_domain_values('tradeAction','ACTIVATE_ORDER','Activate an order' );
end;
/
begin
add_domain_values('tradeAction','PARTIAL_EXECUTE','Partially execute an order' );
end;
/
begin
add_domain_values('tradeAction','COMPLETE_ORDER','Complete an Order Strategy' );
end;
/
begin
add_domain_values('CommodityName','Light, Sweet Crude Oil','' );
end;
/
begin
add_domain_values('CommodityName','Natural Gas','' );
end;
/
begin
add_domain_values('CommodityName','Unleaded Gasoline','' );
end;
/
begin
add_domain_values('CommodityName','Brent Crude Oil','' );
end;
/
begin
add_domain_values('CommodityName','Electricity','' );
end;
/
begin
add_domain_values('CommodityName','Propane','' );
end;
/
begin
add_domain_values('CommodityName','Coal','' );
end;
/
begin
add_domain_values('CommodityLocation','HOUSTON HENRY HUB','' );
end;
/
begin
add_domain_values('autoFeedInternalRefTerminationType','PartialNovation','' );
end;
/
begin
add_domain_values('autoFeedExternalRefTerminationType','PartialNovation','' );
end;
/
begin
add_domain_values('workflowRuleTransfer','CheckSettleAmountTransferRule','' );
end;
/
begin
add_domain_values('workflowRuleTrade','CheckCreditEvent','' );
end;
/
begin
add_domain_values('workflowRuleTrade','SetTradeDate','' );
end;
/
begin
add_domain_values('workflowRuleLegalEntity','CheckValid','' );
end;
/
begin
add_domain_values('tradeStatus','ROLLOVERED','' );
end;
/
begin
add_domain_values('tradeStatus','ROLLBACKED','' );
end;
/
begin
add_domain_values('transferStatus','HELD','' );
end;
/
begin
add_domain_values('transferStatus','INVALID','' );
end;
/
begin
add_domain_values('transferStatus','FAILED','' );
end;
/
begin
add_domain_values('messageStatus','TO_SEND','' );
end;
/
begin
add_domain_values('messageStatus','INVALID','' );
end;
/
begin
add_domain_values('domainName','LegalEntityStatus','Lifecycle status of a Legal Entity' );
end;
/
begin
add_domain_values('LegalEntityStatus','NONE','' );
end;
/
begin
add_domain_values('LegalEntityStatus','PENDING','' );
end;
/
begin
add_domain_values('LegalEntityStatus','VERIFIED','' );
end;
/
begin
add_domain_values('tradeAction','CONTINUE','User continues trade. It means the current trade is ended but continued by another trade. It looks like a rollover.' );
end;
/
begin
add_domain_values('tradeAction','SPLIT','User splits a trade. Typical result status: CANCELED' );
end;
/
begin
add_domain_values('tradeAction','MERGE','User merge a trade from a Cpty to another.' );
end;
/
begin
add_domain_values('tradeAction','WI-PROCESS','When Issued Yield To Price Conversion' );
end;
/
begin
add_domain_values('tradeAction','HEDGE','User adds trade to a hedge strategy' );
end;
/
begin
add_domain_values('tradeAction','UNHEDGE','User removes trade from a hedge strategy' );
end;
/
begin
add_domain_values('transferAction','REJECT','Not used by Calypso default set-up' );
end;
/
begin
add_domain_values('transferAction','HOLD','User puts transfer on hold. Typical result status: HELD' );
end;
/
begin
add_domain_values('messageAction','REGENERATE','User or system regenerates message advice document.' );
end;
/
begin
add_domain_values('messageAction','TRACE','Send a Tracing Message in case no answer has been received  from the Receiver of the Message.' );
end;
/
begin
add_domain_values('messageAction','CODU','User copy existing message and Save in DB' );
end;
/
begin
add_domain_values('transferAction','UNASSIGN','User specifies that the transfer is unassigned. Typical result status: CANCELED and 1 transfer created' );
end;
/
begin
add_domain_values('domainName','LegalEntityAction','Possible actions for a Legal Entity' );
end;
/
begin
add_domain_values('LegalEntityAction','NEW','User creates the legal entity.' );
end;
/
begin
add_domain_values('messageAction','LEGALMATCH','User legal matches the message with some other message' );
end;
/
begin
add_domain_values('LegalEntityAction','AMEND','User edits the legal entity.' );
end;
/
begin
add_domain_values('accEventType','BD_CST','' );
end;
/

begin
add_domain_values('accEventType','DAILY_VALUATION','' );
end;
/
begin
add_domain_values('accEventType','DAILY_POS_VALUATION','' );
end;
/
begin
add_domain_values('accEventType','INTEREST_TD','' );
end;
/
begin
add_domain_values('accEventType','MTM_DISC','' );
end;
/
begin
add_domain_values('accEventType','MTM_DISC_YIELD','' );
end;
/
begin
add_domain_values('accEventType','PAYDOWN_PAYMENT','' );
end;
/
begin
add_domain_values('accEventType','PREM_DISC_REAL_LD','' );
end;
/
begin
add_domain_values('accEventType','PREM_DISC_YIELD_REAL_LD','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_NOMINAL_LONG_ON','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_NOMINAL_SHORT_ON','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_PREMDISC_SHORT_ON','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_PREMDISC_LONG_ON','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_ACCRUAL_LONG_ON','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_ACCRUAL_SHORT_ON','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_NOMINAL_LONG_OFF','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_NOMINAL_SHORT_OFF','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_PREMDISC_SHORT_OFF','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_PREMDISC_LONG_OFF','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_ACCRUAL_LONG_OFF','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_ACCRUAL_SHORT_OFF','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_POSITION_LONG_OFF','' );
end;
/
begin
add_domain_values('accEventType','RECLASS_POSITION_SHORT_OFF','' );
end;
/
begin
add_domain_values('accEventType','HEDGED_MTM','' );
end;
/
begin
add_domain_values('accEventType','HEDGING_MTM','' );
end;
/
begin
add_domain_values('accEventType','HEDGE_VALUE','' );
end;
/
begin
add_domain_values('accEventType','HEDGE_INEFFECTIVENESS','' );
end;
/
begin
add_domain_values('accEventType','HEDGE_EFFECTIVENESS','' );
end;
/
begin
add_domain_values('accEventType','HEDGE_INEFFECTIVENESS_OCI','' );
end;
/
begin
add_domain_values('accEventType','HEDGE_EFFECTIVENESS_OCI','' );
end;
/
begin
add_domain_values('accEventType','HEDGE_TAX','' );
end;
/
begin
add_domain_values('accEventType','HEDGE_TAX_OCI','' );
end;
/
begin
add_domain_values('accountType','NORMAL','Classic account with no specific processing prescribed.' );
end;
/
begin
add_domain_values('accountType','SUSPENSE','An account used for booking suspense postings' );
end;
/
begin
add_domain_values('AccountCalculationType','Margin','' );
end;
/
begin
add_domain_values('AccountSetup','CLIENT_SDI_FOR_ANY_PRODUCT','false' );
end;
/
begin
add_domain_values('AccountSetup','CALL_ACCOUNT_DDA_SDI_ONLY','false' );
end;
/
begin
add_domain_values('AccountSetup','IGNORE_CLIENT_ACCOUNT_BOOK','false' );
end;
/
begin
add_domain_values('AccountSetup','INTEREST_SWEPT_WITH_CUSTXFER','false' );
end;
/
begin
add_domain_values('AccountSetup','USE_TAX_IN_STATEMENT','true' );
end;
/
begin
add_domain_values('accountProperty','InitialDepositAmount','' );
end;
/
begin
add_domain_values('accountProperty','InitialDepositValueDate','' );
end;
/
begin
add_domain_values('attributeType','SettleAccountName','Settlement Account Name' );
end;
/
begin
add_domain_values('attributeType','PostingCcy','Posting Currency' );
end;
/
begin
add_domain_values('attributeType','OriginalAccountId','Original Account Id' );
end;
/
begin
add_domain_values('attributeType','OriginalAccountName','Original Account Name' );
end;
/
begin
add_domain_values('attributeType','TradeId','Trade Id' );
end;
/
begin
add_domain_values('attributeType','AccountEvent','Account Event' );
end;
/
begin
add_domain_values('securityCode.DesignatedPriority','LIEN1','' );
end;
/
begin
add_domain_values('securityCode.DesignatedPriority','LIEN2','' );
end;
/
begin
add_domain_values('securityCode.DesignatedPriority','LIEN3','' );
end;
/
begin
add_domain_values('domainName','lifeCycleEntityType','Simple name of Entity Type for which exists a LifyCycleHandler' );
end;
/
begin
add_domain_values('ScriptableOTCProduct.Pricer','PricerBlackNFMonteCarloExotic','Pricer for ScriptableOTCProduct' );
end;
/
begin
add_domain_values('domainName','defaultFXVolSurfUndQtGen','default method generating FX volatility underlying quote name' );
end;
/
begin
add_domain_values('defaultFXVolSurfUndQtGen','excludeFeedSource','Exclude feed source name while while generating FX volatility underlying quote name' );
end;
/
begin
add_domain_values('UnitizedFund.Pricer','PricerUnitizedFund','Unitized Fund Pricer' );
end;
/
begin
add_domain_values('CA.subtype','IMPAIRMENT','' );
end;
/
begin
add_domain_values('CA.subtype','REBATE','' );
end;
/
begin
add_domain_values('Advance.subtype','ARC','Adjustable Rate Credit' );
end;
/
begin
add_domain_values('Advance.subtype','FRC','Fixed Rate Credit' );
end;
/
begin
add_domain_values('Advance.subtype','VRC','Variable Rate Credit' );
end;
/
begin
add_domain_values('Advance.subtype','Structured','Structured' );
end;
/
begin
add_domain_values('AdvanceLetterCredit.subtype','Purchase of Mortgage Loans','Purchase of Mortgage Loans' );
end;
/
begin
add_domain_values('FXOption.subtype','COMPOUND','' );
end;
/
begin
add_domain_values('SecLending.subtype','Sec Vs Cash','' );
end;
/
begin
add_domain_values('SecLending.subtype','Sec Vs Collateral Pool','' );
end;
/
begin
add_domain_values('SecLending.subtype','Unsecured','' );
end;
/
begin
add_domain_values('CreditDefaultSwapABS.subtype','HARD','' );
end;
/
begin
add_domain_values('CreditDefaultSwapABS.subtype','SOFT','' );
end;
/
begin
add_domain_values('CreditDefaultSwapABS.subtype','BOTH','' );
end;
/
begin
add_domain_values('CustomerTransfer.subtype','Repayment','' );
end;
/
begin
add_domain_values('CustomerTransfer.subtype','IntradayRepayment','' );
end;
/
begin
add_domain_values('eventClass','PSEventValuationReversal','' );
end;
/
begin
add_domain_values('eventClass','PSEventHedgeValuation','' );
end;
/
begin
add_domain_values('eventClass','PSEventCreditNotice','PSEventCreditNotice' );
end;
/
begin
add_domain_values('eventType','ROLLOVERED_TRADE','' );
end;
/
begin
add_domain_values('eventType','HELD_RECEIPT','' );
end;
/
begin
add_domain_values('eventType','FAILED_RECEIPT','' );
end;
/
begin
add_domain_values('eventType','HEDGE_VALUATION','' );
end;
/
begin
add_domain_values('eventType','HEDGE_FAIRVALUE','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_SUPPLEMENT','' );
end;
/
begin
add_domain_values('eventType','HELD_PAYMENT','' );
end;
/
begin
add_domain_values('eventType','FAILED_PAYMENT','' );
end;
/
begin
add_domain_values('eventType','HELD_SEC_RECEIPT','' );
end;
/
begin
add_domain_values('eventType','FAILED_SEC_RECEIPT','' );
end;
/
begin
add_domain_values('eventType','HELD_SEC_DELIVERY','' );
end;
/
begin
add_domain_values('eventType','FAILED_SEC_DELIVERY','' );
end;
/
begin
add_domain_values('eventType','VALUATION_REVERSAL','' );
end;
/
begin
add_domain_values('eventType','EX_ERRORS_REPORTED','Indicates a document of errors is attache to the current Task.' );
end;
/
begin
add_domain_values('eventType','VERIFIED_TICKET','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_CONFIRM','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_PAYMENT_ADVICE','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_RECEIPT_ADVICE','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_SEC_RECEIPTMSG','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_SEC_DELIVERYMSG','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_RATE_RESET','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_EXERCISE_NOTICE','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_CREATE_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_UPDATE_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_CLOSE_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_UNDO_CLOSE_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_REOPEN_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_BLOCK_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_UNBLOCK_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_DORMANT_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_REACTIVATE_AUTH','' );
end;
/
begin
add_domain_values('exceptionType','ACCOUNT_DORMANCY','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_CREATE_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_UPDATE_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_CLOSE_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_UNDO_CLOSE_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_REOPEN_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_BLOCK_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_UNBLOCK_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_DORMANT_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_REACTIVATE_AUTH','' );
end;
/
begin
add_domain_values('eventType','EX_ACCOUNT_DORMANCY','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_CREATE_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_UPDATE_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_CLOSE_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_UNDO_CLOSE_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_REOPEN_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_BLOCK_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_UNBLOCK_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_DORMANT_AUTH','' );
end;
/
begin
add_domain_values('callAccountExceptionHandler','EX_ACCOUNT_REACTIVATE_AUTH','' );
end;
/
begin
add_domain_values('feeCalculator','FeePercentage','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_ACC_STATEMENT','' );
end;
/
begin
add_domain_values('eventType','VERIFIED_CREDIT_NOTICE','VERIFIED_CREDIT_NOTICE' );
end;
/
begin
add_domain_values('exceptionType','ERRORS_REPORTED','' );
end;
/
begin
add_domain_values('feeCalculator','NoticeWithdrawalPenalty','' );
end;
/
begin
add_domain_values('function','ModifyMulticurvePackage','Access permission to Modify Multicurve Packages' );
end;
/
begin
add_domain_values('function','CreateMulticurvePackage','Access permission to Create Multicurve Packages' );
end;
/
begin
add_domain_values('function','RemoveMulticurvePackage','Access permission to Remove Multicurve Packages' );
end;
/
begin
add_domain_values('function','Disallow Save Quotes From Credit Market Data Window','This function will disallow the user to save the quotes from credit market data window' );
end;
/
begin
add_domain_values('function','AuthorizeTransfer','Access permission to authorize a Transfer' );
end;
/
begin
add_domain_values('function','DealCaptureLayoutCustomization','Access permission to allow users to customize the deal capture layout configuration and field movements' );
end;
/
begin
add_domain_values('function','AddModifyMarketMeasures','Access Permission to add.modify MarketMeasures' );
end;
/
begin
add_domain_values('function','DeleteMarketMeasures','Access Permission to remove MarketMeasures' );
end;
/
begin
add_domain_values('restriction','Disallow Save Quotes From Credit Market Data Window','' );
end;
/
begin
add_domain_values('productType','SecLending','' );
end;
/
begin
add_domain_values('messageType','CREDIT_NOTICE','Message confirming that a Credit Event has occurred' );
end;
/
begin
add_domain_values('nettingType','GCF','GCF' );
end;
/
begin
add_domain_values('nettingType','GCFTAP','GCFTAP' );
end;
/
begin
add_domain_values('nettingType','FundFX','FundFX' );
end;
/
begin
add_domain_values('productFamily','CA','' );
end;
/
begin
add_domain_values('productFamily','Fund','' );
end;
/
begin
add_domain_values('productType','Advance','' );
end;
/
begin
add_domain_values('productType','FutureOptionDividend','' );
end;
/
begin
add_domain_values('productType','CreditFacility','' );
end;
/
begin
add_domain_values('productType','CreditTranche','' );
end;
/
begin
add_domain_values('productType','CreditDrawDown','' );
end;
/
begin
add_domain_values('retroActivity','EffectiveDate','' );
end;
/
begin
add_domain_values('riskAnalysis','FXSpotBlotter','' );
end;
/
begin
add_domain_values('reversalRule','NO_NID','Accounting reversals not allowed but for same Day only' );
end;
/
begin
add_domain_values('riskAnalysis','HedgeEffectiveness','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','MarginCallStatement.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','bondconfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','brokerconfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','cashconfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','cdsIndexConfirm.html','' );
end;
/
begin
add_domain_values('role','Hypothetical','Hypothetical' );
end;
/
begin
add_domain_values('scheduledTask','CREDIT_FACILITY_STATEMENT','Generate Credit Facility Statements' );
end;
/
begin
add_domain_values('scheduledTask','ACCOUNT_FULL_BALANCE','Updates the principal of FullBalance CustomerTransfer trades' );
end;
/
begin
add_domain_values('sortMethod','TradeDateStartOfDay','' );
end;
/
begin
add_domain_values('role','BuySide','Used to determine whether an entity is a buy-side firm' );
end;
/
begin
add_domain_values('SWIFT.Templates','MT540','Security Receive Free' );
end;
/
begin
add_domain_values('SWIFT.Templates','MT370','Netting Position Advice' );
end;
/
begin
add_domain_values('SWIFT.Templates','MT601','Precious Metal Option Confirmation' );
end;
/
begin
add_domain_values('MESSAGE.Templates','AccountStatement.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','buysellbackconfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','capconfirmation2.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','cdsIndexTrancheConfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','equityconfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','fxforwardconfirmation.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','fxoptionforwardconfirmation.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','mminterestconfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','trsConfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','mmdiscountconfirm.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','pricefixing.html','' );
end;
/
begin
add_domain_values('MESSAGE.Templates','simplemmconfirm.html','' );
end;
/
begin
add_domain_values('InventoryPositions','EXTERNAL-ACTUAL-SETTLE','' );
end;
/
begin
add_domain_values('InventoryPositions','INTERNAL-FUNDING-SETTLE','' );
end;
/
begin
add_domain_values('riskPresenter','InvestmentPerformance','' );
end;
/
begin
add_domain_values('riskPresenter','NAV','' );
end;
/
begin
add_domain_values('riskPresenter','EconomicPL','' );
end;
/
begin
add_domain_values('riskAnalysis','MultiSensitivity','MultiSensitivity Analysis' );
end;
/
begin
add_domain_values('riskPresenter','MultiSensitivity','MultiSensitivity Analysis' );
end;
/
begin
add_domain_values('riskPresenter','IntradayRiskPL','IntradayRiskPL Analysis' );
end;
/
begin
add_domain_values('tradeStatus','HEDGED','HEDGED' );
end;
/
begin
add_domain_values('tradeStatus','UNHEDGED','UNHEDGED' );
end;
/
begin
add_domain_values('domainName','CustomAccountingFilterEvent','Custom Filter Event' );
end;
/
begin
add_domain_values('productTypeReportStyle','Advance','Advance ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','AdvanceLetterCredit','AdvanceLetterCredit ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','AssetSwap','AssetSwap ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','ScriptableOTCProduct','ScriptableOTCProduct ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','SecFinance','SecFinance ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','SecLending','SecLending ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','CreditFacility','CreditFacility ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','CreditTranche','CreditTranche ReportStyle' );
end;
/
begin
add_domain_values('productTypeReportStyle','CreditDrawDown','CreditDrawDown ReportStyle' );
end;
/
begin
add_domain_values('defaultFullTerminationFeeType.EquityStructuredOption','TERMINATION_FEE','PV' );
end;
/
begin
add_domain_values('domainName','TradeCreditEventReprocessTradesAction','Restricts the workflow actions for reprocess trades on the Credit Event Window from the existing list of tradeAction domain' );
end;
/
begin
add_domain_values('domainName','ProcessIndexTradesAction','Restricts the workflow actions for migrating Index trades on the Credit Event Window from the existing list of tradeAction domain' );
end;
/
begin
add_domain_values('tradeKeyword','CASecurityAvailableDate','JDate AVAL Swift code: Available Date/Time For Trading - Date/time at which securities become available for trading, for example first dealing date' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','confirmation_authorization','Web Module for Confirmation Authorization' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','sdi_authorization','Web Module for SDI Authorization' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','intercompany_settlement_authorization','Web Module for ICS Authorization' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','deal_request_authorization','Web Module for Deal request Authorization' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','cash_forecast_authorization','Web Module for Cash forecast Authorization' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','transfer_authorization','Web Module for Transfer Authorization' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','account_activity','Web Module for Account Activity' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','inventory_cash_positions','Web Module for Inventory Cash Position. Needed for Account Activity' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','cash_forecasts','Web Module for Cash Forecast' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','deal_requests','Web Module for Deal Request' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','intercompany_settlements','Web Module for Intercompany Settlement' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','statements','Web Module for Statements' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','sdi','Web Module for SDI' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','payments','Web Module for Payments' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','confirmations','Web Module for Confirmations' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','trades','Web Module for Trade Blotter' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','trades_report','Web Module for Trade Report' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','payments_receipts_report','Web Module for Payments Receipt Report' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','confirmations_report','Web Module for Confirmations Report' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','maturity_notices','Web Module for Maturity Notice Report' );
end;
/
begin
add_domain_values('dataSegregationEnabledApps','manualsdi_template_maintenance','Web Module for Manual SDI template Maintenance' );
end;
/
begin
add_domain_values('hyperSurfaceGenerators','Advance','' );
end;
/
begin
add_domain_values('hyperSurfaceGenerators','AdvanceTemplate','' );
end;
/
begin
add_domain_values('domainName','Advance.Pricer','Pricers for Advance' );
end;
/
begin
add_domain_values('Advance.Pricer','PricerAdvance','' );
end;
/
begin
add_domain_values('domainName','AdvanceLetterCredit.Pricer','Pricers for Letter of Credit' );
end;
/
begin
add_domain_values('AdvanceLetterCredit.Pricer','PricerAdvanceLetterCredit','' );
end;
/
begin
add_domain_values('EquityStructuredOption.Pricer','PricerBlack1FBinomialVanilla','binomial Pricer for single equity american vanilla option - use constant rates/vols - can do forward start price' );
end;
/
begin
add_domain_values('domainName','pricingScriptProductBase','' );
end;
/
begin
add_domain_values('pricingScriptProductBase','EquityStructuredOption','' );
end;
/
begin
add_domain_values('pricingScriptProductBase','ScriptableOTCProduct','' );
end;
/
begin
add_domain_values('domainName','pricingScriptProductBase','' );
end;
/
begin
add_domain_values('pricingScriptProductBase','ScriptableOTCProduct','' );
end;
/
begin
add_domain_values('function','PerformAccountClosure','Allow User to Perform The Account Closure from Account Window' );
end;
/
begin
add_domain_values('function','UndoAccountClosure','Allow User to Undo the the Closure Account from Account Window' );
end;
/
begin
add_domain_values('function','ReOpenAccountClosure','Allow User to Reopen a Closed Account from Account Window' );
end;
/
begin
add_domain_values('function','CloseAccount','Allow User to Close an Account from Account Window' );
end;
/
begin
add_domain_values('function','SuspendAccount','Allow User to Suspend an  Account from Account Window' );
end;
/
begin
add_domain_values('function','BlockAccount','Allow User to Block an Account from Account Window' );
end;
/
begin
add_domain_values('function','UnblockAccount','Allow User to UnBlock an Account from Account Window' );
end;
/
begin
add_domain_values('function','DormantAccount','Allow User to Accpt a Dormant Account from Account Window' );
end;
/
begin
add_domain_values('function','RejectDormantAccount','Allow User to Reject a Dormant Account from Account Window' );
end;
/
begin
add_domain_values('function','ReactivateDormantAccount','Allow User to Reactivate a Dormant Account from Account Window' );
end;
/
begin
add_domain_values('function','ModifyAccountNotEditableFields','Allow User to Update Non Editable Fields from Account Window' );
end;
/
begin
add_domain_values('workflowRuleTrade','CheckAvailableCallAccountPosition','' );
end;
/
begin
add_domain_values('workflowRuleTransfer','CheckAvailableCallAccountPosition','' );
end;
/
begin
add_domain_values('workflowRuleTrade','UpdateTrancheActions','' );
end;
/
begin
add_domain_values('domainName','CreditFacility.Pricer','Pricers for Credit Facilities' );
end;
/
begin
add_domain_values('domainName','CreditTranche.Pricer','Pricers for Credit Tranches' );
end;
/
begin
add_domain_values('domainName','CreditDrawDown.Pricer','Pricers for Credit DrawDowns' );
end;
/
begin
add_domain_values('CreditFacility.Pricer','PricerCreditFacility','' );
end;
/
begin
add_domain_values('CreditTranche.Pricer','PricerCreditTranche','' );
end;
/
begin
add_domain_values('CreditDrawDown.Pricer','PricerCreditDrawDown','' );
end;
/
begin
add_domain_values('plMeasure','Total P{&}L','Realtime Total PnL' );
end;
/
begin
add_domain_values('plMeasure','Total P{&}L (Base)','Realtime Total PnL (Base)' );
end;
/
begin
add_domain_values('plMeasure','Total P{&}L (Full)','Realtime Total PnL (Full)' );
end;
/
begin
add_domain_values('plMeasure','Base P{&}L','Fast Base PnL' );
end;
/
begin
add_domain_values('PricerMeasurePnlBondsEOD','UNSETTLED_INTEREST','' );
end;
/
begin
add_domain_values('PricerMeasurePnlBondsEOD','ACCRUAL','' );
end;
/
begin
add_domain_values('PricerMeasurePnlBondsEOD','ACCRUAL','' );
end;
/
begin
add_domain_values('PricerMeasurePnlRealtimeEOD','CONVERSION_FACTOR','' );
end;
/
begin
add_domain_values('PricerMeasurePnlRealtimeEOD','MARKET_VALUE','' );
end;
/
begin
add_domain_values('PricerMeasurePnlRealtimeEOD','Cash','' );
end;
/
begin
add_domain_values('PricerMeasurePnlRealtimeEOD','HISTO_MARKET_VALUE','' );
end;
/
begin
add_domain_values('PricerMeasurePnlRealtimeEOD','HISTO_Cash','' );
end;
/
begin
add_domain_values('measuresForAdjustment','CA_PV','' );
end;
/
begin
add_domain_values('measuresForAdjustment','CA_COST','' );
end;
/
begin
add_domain_values('NamesPricerMsrEOD','PricerMeasurePnlRealtimeEOD','Realtime' );
end;
/
begin
add_domain_values('PNLRealtime','Total P{&}L','' );
end;
/
begin
add_domain_values('PNLRealtime','Total P{&}L (Base)','' );
end;
/
begin
add_domain_values('PNLRealtime','Total P{&}L (Full)','' );
end;
/
begin
add_domain_values('NamesForPNL','PNLRealtime','Realtime PnL' );
end;
/
begin
add_domain_values('domainName','PanelMainKeywords','Trade Keyword to be displayed in CustomerXfer' );
end;
/
begin
add_domain_values('successionEventType','Rename With New RefEntity','' );
end;
/
begin
add_domain_values('pricingScriptReportVariables','M	','' );
end;
/
begin
add_domain_values('function','PricingSheetLegDetailsEditable','Permits Access to modify the leg details properties in Pricing Sheet' );
end;
/
begin
add_domain_values('PricingSheetMeasures','DVEGA_DRD' ,'');
end;
/
begin
add_domain_values('function','CreateXProdConfig','Access permisssion to create/modify XProd Configuration');
end;
/
begin
add_domain_values('function','RemoveXProdConfig','Access permission to remove XProd Configuration');
end;
/
begin
add_domain_values('function','XProdConfigAccess','Access permission to access XProd Configuration' );
end;
/
begin
add_domain_values ('function','ModifyXProdConfig','Access permission to create/modify/delete XProd Configuration');
end;
/
begin
add_domain_values('domainName','LifeCycleEvent','' );
end;
/
begin
add_domain_values('LifeCycleEvent','tk.lifecycle.event.KnockInEvent','Knock In' );
end;
/
begin
add_domain_values('LifeCycleEvent','tk.lifecycle.event.KnockOutEvent','Knock Out' );
end;
/
begin
add_domain_values('LifeCycleEvent','tk.lifecycle.event.PhysicalDeliveryEvent','Physical Delivery' );
end;
/
begin
add_domain_values('LifeCycleEvent','tk.lifecycle.event.RedemptionEvent','Redemption' );
end;
/
begin
add_domain_values('LifeCycleEvent','tk.lifecycle.event.base.StructuredLifeCycleEvent','Structured Event' );
end;
/
begin
add_domain_values('exceptionType','LIFECYCLE','' );
end;
/
begin
add_domain_values('domainName','LifeCycleEventProcessor','' );
end;
/
begin
add_domain_values('LifeCycleEventProcessor','tk.lifecycle.processor.KnockInTradeEventProcessor','Trade Knock In Processor' );
end;
/
begin
add_domain_values('LifeCycleEventProcessor','tk.lifecycle.processor.KnockOutTradeEventProcessor','Trade Knock Out Processor' );
end;
/
begin
add_domain_values('LifeCycleEventProcessor','tk.lifecycle.processor.PhysicalDeliveryEventProcessor','Physical Delivery Processor' );
end;
/
begin
add_domain_values('LifeCycleEventProcessor','tk.lifecycle.processor.RedemptionTradeEventProcessor','Trade Redemption Processor' );
end;
/
begin
add_domain_values('LifeCycleEventProcessor','tk.lifecycle.processor.StructuredEventProcessor','Structured Processor' );
end;
/
begin
add_domain_values('domainName','LifeCycleEventTrigger','' );
end;
/
begin
add_domain_values('LifeCycleEventTrigger','tk.lifecycle.trigger.PricingScriptKnockInTrigger','Knock In' );
end;
/
begin
add_domain_values('LifeCycleEventTrigger','tk.lifecycle.trigger.PricingScriptKnockOutTrigger','Knock Out' );
end;
/
begin
add_domain_values('LifeCycleEventTrigger','tk.lifecycle.trigger.PhysicalDeliveryTrigger','Physical Delivery' );
end;
/
begin
add_domain_values('LifeCycleEventTrigger','tk.lifecycle.trigger.PricingScriptRedemptionTrigger','Redemption' );
end;
/
begin
add_domain_values('LifeCycleEventTrigger','tk.lifecycle.trigger.StructuredEventTrigger','Default Structured Trigger' );
end;
/
begin
add_domain_values('lifeCycleEntityType','LifeCycleEvent','LifeCycleEvent has its own life cycle' );
end;
/
begin
add_domain_values('workflowType','LifeCycleEvent','LifeCycleEvent follows its own workflow' );
end;
/
begin
add_domain_values('LifeCycleEventStatus','NONE','' );
end;
/
begin
add_domain_values('LifeCycleEventStatus','PENDING','' );
end;
/
begin
add_domain_values('LifeCycleEventStatus','CANCELED','' );
end;
/
begin
add_domain_values('LifeCycleEventStatus','TERMINATED','' );
end;
/
begin
add_domain_values('LifeCycleEventStatus','PROCESSED','' );
end;
/
begin
add_domain_values('LifeCycleEventAction','NEW','' );
end;
/
begin
add_domain_values('LifeCycleEventAction','APPLY','' );
end;
/
begin
add_domain_values('LifeCycleEventAction','CANCEL','' );
end;
/
begin
add_domain_values('LifeCycleEventAction','TERMINATE','' );
end;
/
begin
add_domain_values('LifeCycleEventAction','AMEND','' );
end;
/
begin
add_domain_values('LifeCycleUndoActionForKnockIn','UN-KNOCK_IN','' );
end;
/
begin
add_domain_values('LifeCycleUndoActionForKnockOut','UN-KNOCK_OUT','' );
end;
/
begin
add_domain_values('function','ExecuteLifeCycleEvent','Access Permission to execute lifecycle events' );
end;
/
begin
add_domain_values('function','UndoLifeCycleEvent','Access Permission to undo lifecycle events' );
end;
/
begin
add_domain_values('domainName','hedgeRelationshipDefinitionAttributes','' );
end;
/
begin
add_domain_values('domainName','workflowRuleHedgeRelationshipDefinition','' );
end;
/
begin
add_domain_values('domainName','hedgeDefinitionAttributes','' );
end;
/
begin
add_domain_values('domainName','hedgeAccountingSchemeAttributes','' );
end;
/
begin
add_domain_values('domainName','hedgeAccountingSchemeStandard','' );
end;
/
begin
add_domain_values('domainName','hedgeAccountingSchemeMethod','' );
end;
/
begin
add_domain_values('domainName','hedgedRisk','' );
end;
/
begin
add_domain_values('domainName','hedgeRelationshipConfigurationEndDateMethod','' );
end;
/
begin
add_domain_values('domainName','hedgeRelationshipConfigurationStartDateMethod','' );
end;
/
begin
add_domain_values('domainName','hedgeDefinitionType','' );
end;
/
begin
add_domain_values('domainName','hedgeDefinitionSubclass','' );
end;
/
begin
add_domain_values('domainName','hedgeRelationshipDefinitionType','' );
end;
/
begin
add_domain_values('domainName','hedgeDefinitionClassification','' );
end;
/
begin
add_domain_values('scheduledTask','EOD_HEDGE_EFFECTIVENESS_ANALYSIS','' );
end;
/
begin
add_domain_values('scheduledTask','EOD_HEDGE_VALUATION','' );
end;
/
begin
add_domain_values('scheduledTask','EOD_HEDGE_LIQUIDATION','' );
end;
/
begin
add_domain_values('scheduledTask','EOD_HEDGE_MARKING','' );
end;
/
begin
add_domain_values('MainEntry.CustomEventSubscription','PSEventHedgeAccountingValuation','' );
end;
/
begin
add_domain_values('MainEntry.CustomEventSubscription','PSEventHedgeRelationshipDefinition','' );
end;
/
begin
add_domain_values('workflowRuleTrade','CheckHedgeDefinition','' );
end;
/
begin
add_domain_values('workflowRuleTrade','CheckHedgeRelationshipDefinition','' );
end;
/
begin
add_domain_values('workflowRuleTrade','CheckHedgeRelationshipDefinitionWarning','' );
end;
/
begin
add_domain_values('CustomStaticDataFilter','HedgeAccounting','' );
end;
/
begin
add_domain_values('CustomAccountingFilterEvent','HedgeAccounting','' );
end;
/
begin
add_domain_values('CustomTradeWindow','HedgeAccounting','' );
end;
/
begin
add_domain_values('eventType','HEDGE_BALANCE_VALUATION','' );
end;
/
begin
add_domain_values('eventType','HEDGE_DESIGNATION_VALUATION','' );
end;
/
begin
add_domain_values('eventType','TRADE_VALUATION_RELATIONSHIP','' );
end;
/
begin
add_domain_values('eventType','NEW_HEDGE_RELATIONSHIP','' );
end;
/
begin
add_domain_values('eventType','MODIFY_HEDGE_RELATIONSHIP','' );
end;
/
begin
add_domain_values('eventType','REMOVE_HEDGE_RELATIONSHIP','' );
end;
/
begin
add_domain_values('eventType','EX_HEDGE_RELATIONSHIP_DEFINITION','Exception Generated when a trade in hedge relationship definition is modified' );
end;
/
begin
add_domain_values('eventType','INACTIVE_RELATIONSHIP','Status of the Hedge Relationship' );
end;
/
begin
add_domain_values('eventType','TERMINATED_RELATIONSHIP','Status of the Hedge Relationship' );
end;
/
begin
add_domain_values('eventType','CANCELED_RELATIONSHIP','Status of the Hedge Relationship' );
end;
/
begin
add_domain_values('eventType','INEFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' );
end;
/
begin
add_domain_values('eventType','EFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' );
end;
/
begin
add_domain_values('eventType','PENDING_RELATIONSHIP','Status of the Hedge Relationship' );
end;
/
begin
add_domain_values('classAuditMode','HedgeDefinition','' );
end;
/
begin
add_domain_values('classAuditMode','HedgeRelationshipDefinition','' );
end;
/
begin
add_domain_values('classAuditMode','RelationshipTradeItem','' );
end;
/
begin
add_domain_values('classAuditMode','HedgeRelationshipConfiguration','' );
end;
/
begin
add_domain_values('classAuthMode','HedgeRelationshipDefinition','' );
end;
/
begin
add_domain_values('classAuthMode','HedgeDefinition','' );
end;
/
begin
add_domain_values('classAuthMode','HedgeRelationshipConfiguration','' );
end;
/
begin
add_domain_values('classAuthMode','HedgePricerMeasureMapping','' );
end;
/
begin
add_domain_values('engineName','RelationshipManagerEngine','' );
end;
/
begin
add_domain_values('applicationName','RelationshipManagerEngine','RelationshipManagerEngine' );
end;
/
begin
add_domain_values('eventClass','PSEventHedgeAccountingValuation','' );
end;
/
begin
add_domain_values('eventClass','PSEventHedgeRelationshipDefinition','' );
end;
/
begin
add_domain_values('eventClass','PSEventHedgeEffectivenessTest','' );
end;
/
begin
add_domain_values('eventClass','PSEventHedgeDesignationRecord','' );
end;
/
begin
add_domain_values('eventFilter','HedgeRelationshipDefinitionEventFilter','' );
end;
/
begin
add_domain_values('function','CreateHedgeRelationshipDefinition','Access permission to Add Hedge Relationship Definition' );
end;
/
begin
add_domain_values('function','CreateHedgeDefinition','Access permission to Add Hedge Definition' );
end;
/
begin
add_domain_values('function','CreateHedgePricerMeasureMapping','Access permission to Add Hedge Pricer Measure Mapping' );
end;
/
begin
add_domain_values('function','ModifyHedgeRelationshipDefinition','Access permission to Modify Hedge Relationship Definition' );
end;
/
begin
add_domain_values('function','ModifyHedgeDefinition','Access permission to Modify Hedge Definition' );
end;
/
begin
add_domain_values('function','ModifyHedgePricerMeasureMapping','Access permission to Modify Hedge Pricer Measure Mapping' );
end;
/
begin
add_domain_values('function','RemoveHedgeRelationshipDefinition','Access permission to Remove Hedge Relationship Definition' );
end;
/
begin
add_domain_values('function','RemoveHedgeDefinition','Access permission to Remove Hedge Definition' );
end;
/
begin
add_domain_values('function','RemoveHedgePricerMeasureMapping','Access permission to Remove Hedge Pricer Measure Mapping' );
end;
/
begin
add_domain_values('riskAnalysis','HedgeEffectivenessTesting','Retrospective Hedge Effectiveness Testing' );
end;
/
begin
add_domain_values('riskAnalysis','HedgeEffectivenessProTesting','Prospective Hedge Effectiveness Testing' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionAttributes','CVAMeasure','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionAttributes','HedgeEffectivenessDocumentationReview','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionAttributes','LastEffectivenessTest','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionAttributes','MaterialThreshold','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionAttributes','ShiftOnDiscountCurve','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','Base Currency','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','O/S Code','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','O/S Description','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','Baseline Amort. End Date','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','Basis Amort. End Date','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','Holidays','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','Curve Shifting','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeAttributes','Test Termination/Liquidation','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes','Check List Template','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes','De-designation Fee','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes','Postings Only If Effective','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes','Pricing Environment','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes','Accounting Hedge','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes','Prospective Validation Name','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes','Retrospective Validation Name','' );
end;
/
begin
add_domain_values('hedgeDefinitionSubclass','Cashflow Hedge','' );
end;
/
begin
add_domain_values('hedgeDefinitionSubclass','Fair Value Hedge','' );
end;
/
begin
add_domain_values('hedgeDefinitionSubclass','Net Investment Hedge','' );
end;
/
begin
add_domain_values('hedgeDefinitionSubclass','Non-Qualifying Hedge','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionType','Cashflow Hedge','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionType','Fair Value Hedge','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionType','Net Investment Hedge','' );
end;
/
begin
add_domain_values('hedgeRelationshipDefinitionType','Non-Qualifying Hedge','' );
end;
/
begin
add_domain_values('hedgeDefinitionType','Primary Hedge','' );
end;
/
begin
add_domain_values('hedgeDefinitionType','Secondary Hedge','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeStandard','FAS','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeStandard','IAS','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeMethod','Cash Flow Hedge','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeMethod','Long Haul','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeMethod','Change in Variable Cash Flow','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeMethod','Hypothetical Derivative','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeMethod','Shortcut','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeTestingType','Prospective','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeTestingType','Retrospective','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeTestingType','Both','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeValidationType','Day','' );
end;
/
begin
add_domain_values('hedgeAccountingSchemeValidationType','Week','' );
end;
/
begin
add_domain_values('hedgeDefinitionAttributes.Check List Template','HedgeDocumentationCheckList.tmpl','' );
end;
/
begin
add_domain_values('hedgeDefinitionClassification','Hedge','' );
end;
/
begin
add_domain_values('hedgeDefinitionClassification','Strategy','' );
end;
/
begin
add_domain_values('hedgeDefinitionClassification','Bundle','' );
end;
/
begin
add_domain_values('hedgedRisk','Credit Risk','' );
end;
/
begin
add_domain_values('hedgedRisk','FX Risk','' );
end;
/
begin
add_domain_values('hedgedRisk','Interest Rate Risk','' );
end;
/
begin
add_domain_values('hedgedRisk','Issuer Credit Spread Risk','' );
end;
/
begin
add_domain_values('hedgedRisk','Issuer Default Risk','' );
end;
/
begin
add_domain_values('hedgedRisk','Price Risk','' );
end;
/
begin
add_domain_values('hedgedRisk','Swap Spread Risk','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationEndDateMethod','MaxEnteredDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationEndDateMethod','MaxMaturityDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationEndDateMethod','MaxTradeDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationEndDateMethod','MinEnteredDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationEndDateMethod','MinMaturityDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationEndDateMethod','MinTradeDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationStartDateMethod','MaxEnteredDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationStartDateMethod','MaxMaturityDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationStartDateMethod','MaxTradeDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationStartDateMethod','MinEnteredDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationStartDateMethod','MinMaturityDate','' );
end;
/
begin
add_domain_values('hedgeRelationshipConfigurationStartDateMethod','MinTradeDate','' );
end;
/
begin
add_domain_values('MirrorKeywords','Hedge','' );
end;
/
begin
add_domain_values('workflowType','HedgeRelationshipDefinition','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','NONE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','CANCELED','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','EFFECTIVE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','INACTIVE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','PENDING','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','INEFFECTIVE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','TERMINATED','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','HYPOTHETICAL','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionStatus','UNAPPROVED','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','CANCEL','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','DESIGNATE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','DE_DESIGNATE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','NEW','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','REPROCESS','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','TERMINATE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','UPDATE','' );
end;
/
begin
add_domain_values('HedgeRelationshipDefinitionAction','APPROVE','' );
end;
/
begin
add_domain_values('workflowRuleHedgeRelationshipDefinition','Reprocess','' );
end;
/
begin
add_domain_values('workflowRuleHedgeRelationshipDefinition','ReprocessEconomic','' );
end;
/
begin
add_domain_values('workflowRuleHedgeRelationshipDefinition','Approve','' );
end;
/
begin
add_domain_values('workflowRuleHedgeRelationshipDefinition','CheckEndDate','' );
end;
/
begin
add_domain_values('workflowRuleHedgeRelationshipDefinition','CheckFullTermination','' );
end;
/

DECLARE 
engid number:=0;
cnt number;
BEGIN
	select max(engine_id)+1 into engid from engine_config;
	select count(*) into cnt from engine_config where engine_name='RelationshipManagerEngine';
	if cnt = 0 THEN
	INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (engid,'RelationshipManagerEngine','' );
    end if;
end;
/

INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ScriptableOTCProduct.ANY.ANY','PricerBlackNFMonteCarloExotic' )
;
delete from pricer_measure where measure_name='UNSETTLED_INTEREST' and measure_class_name='tk.core.PricerMeasure' and measure_id= 446 and measure_comment='interest payments that are going to settle'
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('UNSETTLED_INTEREST','tk.core.PricerMeasure',446,'interest payments that are going to settle' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('NPV_COF','tk.core.PricerMeasure',447,'This is normal NPV computation, but it will use the cost of funds curve instead of the usual discount curve' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('BREAK_EVEN_RATE_COF','tk.core.PricerMeasure',448,'This is the break even rate considering the NPV_COF cost of funds curve).' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRICE_UNDERLYING_INDEX','tk.pricer.PricerMeasureCredit',2000,'Price of the underlying index' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('ACCRUAL_FINANCING','tk.pricer.PricerMeasureCredit',2001,'Accrual for the finance leg of the trade' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('ACCRUAL_INDEX','tk.pricer.PricerMeasureCredit',2002,'Accrual for the performance leg of the trade' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('MTM_INDEX','tk.pricer.PricerMeasureCredit',2003,'Mark to market of the index price change' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('product_scot','Table for Product ScriptableOTCProduct' )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'ConfigHierarchy',1 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeAccountingScheme',1 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'DesignationRecords',1 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'RelationshipTradeItem',1 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationship',1 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeStrategy',1 )
;
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationshipConfig',500 )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventLifeCycle','LifeCycleEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeRelationshipDefinition','RelationshipManagerEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTrade','RelationshipManagerEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeEffectivenessTest','RelationshipManagerEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeRelationshipDefinition','AccountingEngine' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeAccountingValuation','AccountingEngine' )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (650,'LifeCycleEvent','NONE','NEW','PENDING',0,1,'ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (651,'LifeCycleEvent','PENDING','APPLY','PROCESSED',0,1,'ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (652,'LifeCycleEvent','PROCESSED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (653,'LifeCycleEvent','CANCELED','TERMINATE','TERMINATED',0,1,'ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (654,'LifeCycleEvent','PENDING','AMEND','PENDING',0,1,'ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (655,'LifeCycleEvent','CANCELED','AMEND','CANCELED',0,1,'ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (801,'HedgeRelationshipDefinition','NONE','NEW','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (802,'HedgeRelationshipDefinition','PENDING','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (803,'HedgeRelationshipDefinition','EFFECTIVE','DE_DESIGNATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (804,'HedgeRelationshipDefinition','INEFFECTIVE','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (805,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (806,'HedgeRelationshipDefinition','INEFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (807,'HedgeRelationshipDefinition','INEFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (808,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (809,'HedgeRelationshipDefinition','INACTIVE','TERMINATE','TERMINATED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (810,'HedgeRelationshipDefinition','INACTIVE','REPROCESS','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (811,'HedgeRelationshipDefinition','PENDING','REPROCESS','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (812,'HedgeRelationshipDefinition','EFFECTIVE','UPDATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (813,'HedgeRelationshipDefinition','INEFFECTIVE','UPDATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (814,'HedgeRelationshipDefinition','INEFFECTIVE','REPROCESS','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (815,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (816,'HedgeRelationshipDefinition','PENDING','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (817,'HedgeRelationshipDefinition','PENDING','UPDATE','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (820,'HedgeRelationshipDefinition','NONE','NEW','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (821,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (822,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','TERMINATED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (823,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (824,'HedgeRelationshipDefinition','TERMINATED','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (825,'HedgeRelationshipDefinition','PENDING','MIGRATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (826,'HedgeRelationshipDefinition','EFFECTIVE','END_SHORTCUT','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (801,'Reprocess' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (807,'Reprocess' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (808,'Reprocess' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (809,'CheckEndDate' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (810,'Reprocess' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (811,'Reprocess' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (814,'Reprocess' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (815,'Reprocess' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (820,'ReprocessEconomic' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (821,'ReprocessEconomic' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (826,'EndShortcut' )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('HedgeEffectivenessTesting','apps.risk.HedgeEffectivenessTestingViewer',0 )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('HedgeEffectivenessProTesting','apps.risk.HedgeEffectivenessProTestingViewer',0 )
;


begin
add_column_if_not_exists ('swap_leg','settle_holidays','VARCHAR2(128)');
end;
/
begin
add_column_if_not_exists ('swap_leg','settle_holidays_b','numeric DEFAULT 0 NOT NULL');
end;
/
begin
add_column_if_not_exists ('swap_leg_hist','settle_holidays_b','numeric DEFAULT 0 NOT NULL');
end;
/

update swap_leg set settle_holidays_b=1 where settle_holidays is not NULL and settle_holidays != coupon_holidays
;

/* REL-8487 */

CREATE OR REPLACE PROCEDURE add_table
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
        EXECUTE IMMEDIATE 'create table TASK_ENRICHMENT_FIELD_CONFIG (WORKFLOW_TYPE  VARCHAR2(64) NOT NULL,
 FIELD_DB_COLUMN_INDEX   NUMBER(38) NOT NULL,
 DATA_SOURCE_CLASS_NAME   VARCHAR2(512) NOT NULL,
 DATA_SOURCE_GETTER_NAME  VARCHAR2(512),
 CUSTOM_CLASS_NAME   VARCHAR2(512),
 FIELD_CONVERSION_CLASS   VARCHAR2(64),
 EXTRA_ARGUMENTS   VARCHAR2(512),
 FIELD_DISPLAY_NAME  VARCHAR2(132),
 FIELD_DB_NAME   VARCHAR2(132) NOT NULL)';
  
    END IF;
END add_table;
/

BEGIN
add_table('TASK_ENRICHMENT_FIELD_CONFIG');
END;
/


begin 
add_column_if_not_exists ('TASK_ENRICHMENT_FIELD_CONFIG','WORKFLOW_TYPE', 'varchar2(64) NOT NULL');
end;
/

begin 
add_column_if_not_exists ('TASK_ENRICHMENT_FIELD_CONFIG','EXTRA_ARGUMENTS', 'varchar2 (512) NULL');
end;
/
begin 
add_column_if_not_exists ('TASK_ENRICHMENT_FIELD_CONFIG','CUSTOM_CLASS_NAME', 'varchar2 (512) NULL');
end;
/
begin 
add_column_if_not_exists ('TASK_ENRICHMENT_FIELD_CONFIG','field_domain_finder', 'varchar2 (512) NULL');
end;
/

begin 
add_column_if_not_exists ('TASK_ENRICHMENT_FIELD_CONFIG','field_domain_finder_arg', 'varchar2 (132) NULL');
end;
/ 


begin
add_domain_values('domainName','MainEntry.Startup','' );
end;
/

begin
add_domain_values('MainEntry.Startup','TaskEnrichment','' );
end;
/
begin
add_domain_values('domainName','Admin.Startup','' );
end;
/
begin
add_domain_values('Admin.Startup','TaskEnrichment','' );
end;
/
begin
add_domain_values('function','AddModifyTSTab','Allow User to add or modify any TaskStation Tab' );
end;
/
begin
add_domain_values('function','RemoveTSTab','Allow User to delete any TaskStation Tab' );
end;
/
begin
add_domain_values('function','ModifyTSTabPlan','Allow User to modify part of Window Plan related to selected TaskStation Tab' );
end;
/
begin
add_domain_values('function','ModifyTSTabFiltering','Allow User to display filter Panel' );
end;
/
  
 

begin
 drop_pk_if_exists('VOL_SURFACE_POINT_TYPE_SWAP');
end;
;

/*  Update Version */
UPDATE calypso_info
    SET major_version=13,
        minor_version=0,
        sub_version=0,
        patch_version='007',
        version_date=TO_DATE('02/01/2013','DD/MM/YYYY')
;
