add_column_if_not_exists 'perf_swap_leg','ret_fx_reset_lag_bus_day_b', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg','ret_fx_reset_lag_offset','numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg','ret_fx_reset_lag_dateroll', 'VARCHAR(16) NULL'
go
add_column_if_not_exists 'perf_swap_leg','ret_fx_reset_lag_holidays', 'VARCHAR(128) NULL'
go
update perf_swap_leg set ret_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and ret_fx_reset_lag_bus_day_b is null
go
update perf_swap_leg set ret_fx_reset_lag_offset = 0 where fx_reset_id > 0 and ret_fx_reset_lag_offset is null
go
update perf_swap_leg set ret_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and ret_fx_reset_lag_dateroll is null
go
add_column_if_not_exists 'perf_swap_leg','income_fx_reset_lag_bus_day_b', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg','income_fx_reset_lag_offset', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg','income_fx_reset_lag_dateroll','VARCHAR(16) NULL'
go
add_column_if_not_exists 'perf_swap_leg','income_fx_reset_lag_holidays','VARCHAR(128) NULL'
go
update perf_swap_leg set income_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and income_fx_reset_lag_bus_day_b is null
go
update perf_swap_leg set income_fx_reset_lag_offset = 0 where fx_reset_id > 0 and income_fx_reset_lag_offset is null
go
update perf_swap_leg set income_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and income_fx_reset_lag_dateroll is null
go

add_column_if_not_exists 'perf_swap_leg_hist','ret_fx_reset_lag_bus_day_b', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg_hist','ret_fx_reset_lag_offset','numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg_hist','ret_fx_reset_lag_dateroll', 'VARCHAR(16) NULL'
go
add_column_if_not_exists 'perf_swap_leg_hist','ret_fx_reset_lag_holidays','VARCHAR(128) NULL'
go
update perf_swap_leg_hist set ret_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and ret_fx_reset_lag_bus_day_b is null
go
update perf_swap_leg_hist set ret_fx_reset_lag_offset = 0 where fx_reset_id > 0 and ret_fx_reset_lag_offset is null
go
update perf_swap_leg_hist set ret_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and ret_fx_reset_lag_dateroll is null
go
add_column_if_not_exists 'perf_swap_leg_hist','income_fx_reset_lag_bus_day_b','numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg_hist','income_fx_reset_lag_offset','numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'perf_swap_leg_hist','income_fx_reset_lag_dateroll','VARCHAR(16) NULL'
go
add_column_if_not_exists 'perf_swap_leg_hist','income_fx_reset_lag_holidays','VARCHAR(128) NULL'
go
update perf_swap_leg_hist set income_fx_reset_lag_bus_day_b = 0 where fx_reset_id > 0 and income_fx_reset_lag_bus_day_b is null
go
update perf_swap_leg_hist set income_fx_reset_lag_offset = 0 where fx_reset_id > 0 and income_fx_reset_lag_offset is null
go
update perf_swap_leg_hist set income_fx_reset_lag_dateroll = 'PRECEDING' where fx_reset_id > 0 and income_fx_reset_lag_dateroll is null
go

if not exists (select 1 from sysobjects where type='U' and name='forward_start_parameters')
begin
exec ('create table forward_start_parameters (product_id numeric not null,
        strike_value float null,
        fixing_date datetime null,
        fxreset numeric null,
		strike_style numeric null)')
end
go

add_column_if_not_exists 'forward_start_parameters','atm_spot', 'numeric null'
go
add_column_if_not_exists 'forward_start_parameters','atm_forward', 'numeric null'
go


add_column_if_not_exists 'forward_start_parameters','strike_style', 'numeric null'
go

update forward_start_parameters set strike_style = 1 where atm_spot = 1 
go

update forward_start_parameters set strike_style = 2 where atm_forward =  1 
go

sp_rename 'forward_start_parameters.atm_percent','strike_value'
go

alter table forward_start_parameters drop atm_spot, atm_forward
go

if exists (select 1 from sysobjects where name ='pl_meth' and type='P')
begin
exec ('drop procedure pl_meth')
end
go

create procedure pl_meth
as
begin
declare @tmp_book_id numeric
declare @tmp_product_type VARCHAR(255)
declare @tmp_strategy VARCHAR(255)
declare @tmp_str int
declare @tmp_accrual_type VARCHAR(255)
declare @tmp_cash_type numeric 
declare @tmp_cash varchar(255)
declare @countvar INT
declare @tmp_rowcnt INT
DECLARE plmethodology_info_crsr  CURSOR 
for
select book_id, product_type, strategy, cash_type from plmethodology_info

open plmethodology_info_crsr
fetch plmethodology_info_crsr into @tmp_book_id, @tmp_product_type,@tmp_str,@tmp_cash_type
while (@@sqlstatus=0)
begin 

		select @countvar = 0
		 
		select 0 
		if @tmp_cash_type = 0
		begin
			select @tmp_strategy ='MTM' 
			select @tmp_accrual_type ='Settle Date Accrual'
			
		end 
		else if @tmp_cash_type = 1
		begin	
			select @tmp_strategy='Accrual'
			select @tmp_accrual_type='Settle Date Accrual'
			
		end
		else if @tmp_cash_type = 2
		begin
			select @tmp_strategy ='MTM'
			select @tmp_accrual_type ='Trade Date Accrual'
		end 
		
		select 1 
		if ( @tmp_str = 0 ) 
		begin
			select @tmp_cash ='Settle Date Cash'
		end
		else if ( @tmp_str = 1 ) 
	    	begin
			select @tmp_cash ='Trade Date Cash'
		end
		else
			select @tmp_cash='Settle Date Cash'
		
		select 2 
		if (( @tmp_str is not null ) 
			and ( @tmp_accrual_type  is not null ) 
			and ( @tmp_cash_type  is not null ) ) 
		begin
      			select @tmp_rowcnt=count(*) 
      			from pl_methodology 
      			where book_id = @tmp_book_id 
      			and product_type = @tmp_product_type
      		end
      		
      		select 3 	
        	IF @tmp_rowcnt = 0 
		begin
			INSERT INTO pl_methodology(book_id, product_type, description)
			VALUES (@tmp_book_id, @tmp_product_type, @tmp_strategy || ' - ' || @tmp_cash || ' - ' || @tmp_accrual_type)
		end
		
	    	select @countvar=@countvar+1
		fetch plmethodology_info_crsr into @tmp_book_id, @tmp_product_type,@tmp_str,@tmp_cash_type
End
close plmethodology_info_crsr 
end
deallocate cursor plmethodology_info_crsr 
go

exec pl_meth
go


drop table plmethodology_info
go
drop procedure pl_meth
go

add_column_if_not_exists 'swap_leg','settle_holidays_b','numeric default 0 not null'
go
add_column_if_not_exists 'swap_leg','settle_holidays','varchar(128) null'
go

update swap_leg set settle_holidays_b=1 where settle_holidays is not NULL and settle_holidays != coupon_holidays
go
/* Diff 13 to 13SP2 */
add_domain_values  'domainName','expressProductTypes','specify the product types that support express analysis' 
go
add_domain_values  'expressProductTypes','Equity','Cash Equities' 
go
add_domain_values  'expressProductTypes','EquityLinkedSwap','Equity Swaps' 
go
add_domain_values  'expressProductTypes','ADR','ADR' 
go
add_domain_values  'expressProductTypes','FutureEquityIndex','Exchange Traded Equity Index Future' 
go
add_domain_values  'expressProductTypes','CFD','Need clarification' 
go
add_domain_values  'expressProductTypes','FutureDividend','Dividend Future' 
go
add_domain_values  'expressProductTypes','ETOEquity','Listed Equity Options' 
go
add_domain_values  'expressProductTypes','ETOEquityIndex','Exchange traded equity index options' 
go
add_domain_values  'expressProductTypes','Warrant','Warrants' 
go
add_domain_values  'expressProductTypes','FutureVolatility','Exchange traded futures on volatility' 
go
add_domain_values  'expressProductTypes','ETOVolatility','Exchange traded options on volatility' 
go
add_domain_values  'expressProductTypes','FutureCommodity','Exchange traded commodity futures' 
go
add_domain_values  'expressProductTypes','ETOCommodity','Exchange traded commodity options' 
go
add_domain_values  'expressProductTypes','Bond','Goverment and Corporate Bonds' 
go
add_domain_values  'expressProductTypes','BondFRN','FRN' 
go
add_domain_values  'expressProductTypes','FutureBond','Goverment Bond Futures' 
go
add_domain_values  'expressProductTypes','FutureOptionBond','Goverment Bond Future Options' 
go
add_domain_values  'expressProductTypes','FutureOptionSwap','Exchange Traded IR Future Options' 
go
add_domain_values  'expressProductTypes','FutureSwap','Exchange Traded IR Futures' 
go
add_domain_values  'expressProductTypes','FX','FX Spot' 
go
add_domain_values  'expressProductTypes','FutureFX','Exchange traded currency future' 
go
add_domain_values  'expressProductTypes','ETOFX','Exchange traded currency future options' 
go
add_domain_values  'expressProductTypes','CFDDirectional','CFDs' 
go
add_domain_values  'domainName','AdvanceSSLTemplate','specify the SingleSwapLeg trade template name to be used by hypersurface advance generator' 
go
add_domain_values  'function','ViewTrade','Allow User to query and view trade records' 
go
add_domain_values  'function','ViewTransfer','Allow User to query and view transfer records' 
go
add_domain_values  'function','ViewAccount','Allow User to query and view account entries' 
go
add_domain_values  'function','ViewMessage','Allow User to query and view back office messages' 
go
add_domain_values  'function','ViewInventoryCashPosition','Allow User to query and view  inventory cash position entries' 
go
add_domain_values  'function','ViewLegalEntity','Allow User to query and view legal entity entries' 
go
add_domain_values  'function','ViewSDI','Allow User to query and view SDI entries' 
go
add_domain_values  'remittanceType','Repayment','' 
go
add_domain_values  'remittanceType','IntradayRepayment','' 
go
add_domain_values  'measuresForAdjustment','MARKET_VALUE','' 
go
add_domain_values  'measuresForAdjustment','Cash','' 
go
add_domain_values  'domainName','MultiMDIGenerators','Generators that support muliple simulataneous curve generation.' 
go
add_domain_values  'MultiMDIGenerators','DoubleGlobalM','Generate two curves together.' 
go
add_domain_values  'CurveZero.gen','DoubleGlobalM','Generate two curves together.' 
go
add_domain_values  'domainName','ScriptableOTCProduct.subtype','Types of ScriptableOTCProduct' 
go
add_domain_values  'domainName','Advance.ForwardAdjustmentDays','' 
go
add_domain_values  'domainName','Advance.CollateralType','List of collateral types for Advance' 
go
add_domain_values  'domainName','MarketMeasureCalculators','Calulators for Market Measures' 
go
add_domain_values  'domainName','MarketMeasureTrigger','Triggers for Market Measures' 
go
add_domain_values  'domainName','MarketMeasureCriterion','Criterion that can be defined for Market Measures' 
go
add_domain_values  'MarketMeasureCalculators','COFRateConversion','' 
go
add_domain_values  'MarketMeasureCalculators','ForwardAdj','' 
go
add_domain_values  'MarketMeasureTrigger','Exotic','' 
go
add_domain_values  'MarketMeasureTrigger','FixedRate','' 
go
add_domain_values  'MarketMeasureTrigger','FloatingRate','' 
go
add_domain_values  'MarketMeasureTrigger','ForwardStarting','' 
go
add_domain_values  'MarketMeasureTrigger','Inactive','' 
go
add_domain_values  'MarketMeasureTrigger','None','' 
go
add_domain_values  'MarketMeasureTrigger','Optionality','' 
go
add_domain_values  'MarketMeasureCriterion','NotionalSize','' 
go
add_domain_values  'MarketMeasureCriterion','NotionalStepUp','' 
go
add_domain_values  'MarketMeasureCriterion','ProductType','' 
go
add_domain_values  'MarketMeasureCriterion','RateIndex','' 
go
add_domain_values  'MarketMeasureCriterion','CollateralType','' 
go
add_domain_values  'MarketMeasureCriterion','HasCICAProgram','' 
go
add_domain_values  'MarketMeasureTrigger','HasPPSAdjustment','' 
go
add_domain_values  'MarketMeasureTrigger','IsPuttable','' 
go
add_domain_values  'MarketMeasureTrigger','IsCallable','' 
go
add_domain_values  'MarketMeasureCriterion','MaturityDate','' 
go
add_domain_values  'MarketMeasureCriterion','MemberStatus','' 
go
add_domain_values  'MarketMeasureCriterion','FirstExerciseDate','' 
go
add_domain_values  'MarketMeasureCriterion','Strike','' 
go
add_domain_values  'MarketMeasureCalculators','Default','' 
go
add_domain_values  'MarketMeasureCalculators','DefaultWAL','' 
go
add_domain_values  'domainName','Advance.NotionalSize','List of Notional Sizes for Advance' 
go
add_domain_values  'Advance.NotionalSize','1000000.','' 
go
add_domain_values  'Advance.NotionalSize','2000000.','' 
go
add_domain_values  'Advance.NotionalSize','3000000.','' 
go
add_domain_values  'domainName','Advance.NotionalStepUp','List of Notional StepUps for Advance' 
go
add_domain_values  'Advance.NotionalStepUp','1000000.','' 
go
add_domain_values  'Advance.NotionalStepUp','2000000.','' 
go
add_domain_values  'Advance.NotionalStepUp','3000000.','' 
go
add_domain_values  'domainName','Advance.ProductType','List of Product Types for Advance' 
go
add_domain_values  'Advance.ProductType','ARC','' 
go
add_domain_values  'Advance.ProductType','Call Account Funded','' 
go
add_domain_values  'Advance.ProductType','FRC','' 
go
add_domain_values  'Advance.ProductType','Structured','' 
go
add_domain_values  'Advance.ProductType','VRC','' 
go
add_domain_values  'domainName','Advance.Strike','Strike Values' 
go
add_domain_values  'Advance.Strike','1.0','' 
go
add_domain_values  'Advance.Strike','2.0','' 
go
add_domain_values  'Advance.Strike','3.0','' 
go
add_domain_values  'domainName','Advance.RateIndex','Indices used in Advance' 
go
add_domain_values  'Advance.RateIndex','NONE','' 
go
add_domain_values  'Advance.RateIndex','USD/LIBOR/3M/BBA','' 
go
add_domain_values  'domainName','Advance.MaturityDate','Maturity Dates for Advance' 
go
add_domain_values  'Advance.MaturityDate','1M','' 
go
add_domain_values  'Advance.MaturityDate','6M','' 
go
add_domain_values  'Advance.MaturityDate','1Y','' 
go
add_domain_values  'domainName','Advance.FirstExerciseDate','First Exercise Dates for Advance' 
go
add_domain_values  'Advance.FirstExerciseDate','1M','' 
go
add_domain_values  'Advance.FirstExerciseDate','2M','' 
go
add_domain_values  'Advance.FirstExerciseDate','3M','' 
go
add_domain_values  'marketDataUsage','Advance','' 
go
add_domain_values  'marketDataUsage','AdvanceTemplate','' 
go
add_domain_values  'PositionBasedProducts','FutureOptionDividend','FutureOptionDividend out of box position based product' 
go
add_domain_values  'systemKeyword','needToDoInterestCleanup','' 
go
add_domain_values  'futureOptUnderType','Dividend','' 
go
add_domain_values  'tradeKeyword','HedgeRecommendation','' 
go
add_domain_values  'systemKeyword','HedgeRecommendation','' 
go
add_domain_values  'workflowRuleTrade','SetTradeDate','' 
go
add_domain_values  'domainName','lifeCycleEntityType','Simple name of Entity Type for which exists a LifyCycleHandler' 
go
add_domain_values  'ScriptableOTCProduct.Pricer','PricerBlackNFMonteCarloExotic','Pricer for ScriptableOTCProduct' 
go
add_domain_values  'CustomerTransfer.subtype','Repayment','' 
go
add_domain_values  'CustomerTransfer.subtype','IntradayRepayment','' 
go
add_domain_values  'function','ModifyMulticurvePackage','Access permission to Modify Multicurve Packages' 
go
add_domain_values  'function','CreateMulticurvePackage','Access permission to Create Multicurve Packages' 
go
add_domain_values  'function','RemoveMulticurvePackage','Access permission to Remove Multicurve Packages' 
go
add_domain_values  'function','AddModifyMarketMeasures','Access Permission to add.modify MarketMeasures' 
go
add_domain_values  'function','DeleteMarketMeasures','Access Permission to remove MarketMeasures' 
go
add_domain_values  'productType','FutureOptionDividend','' 
go
add_domain_values  'role','BuySide','Used to determine whether an entity is a buy-side firm' 
go
add_domain_values  'SWIFT.Templates','MT370','Netting Position Advice' 
go
add_domain_values  'riskAnalysis','MultiSensitivity','MultiSensitivity Analysis' 
go
add_domain_values  'riskPresenter','MultiSensitivity','MultiSensitivity Analysis' 
go
add_domain_values  'riskPresenter','IntradayRiskPL','IntradayRiskPL Analysis' 
go
add_domain_values  'domainName','CustomAccountingFilterEvent','Custom Filter Event' 
go
add_domain_values  'productTypeReportStyle','ScriptableOTCProduct','ScriptableOTCProduct ReportStyle' 
go
add_domain_values  'tradeKeyword','CASecurityAvailableDate','JDate AVAL Swift code: Available Date/Time For Trading - Date/time at which securities become available for trading, for example first dealing date' 
go
add_domain_values  'hyperSurfaceGenerators','AdvanceTemplate','' 
go
add_domain_values  'domainName','pricingScriptProductBase','' 
go
add_domain_values  'pricingScriptProductBase','EquityStructuredOption','' 
go
add_domain_values  'pricingScriptProductBase','ScriptableOTCProduct','' 
go
add_domain_values  'domainName','pricingScriptProductBase','' 
go
add_domain_values  'pricingScriptProductBase','ScriptableOTCProduct','' 
go
add_domain_values  'plMeasure','Total P&L','Realtime Total PnL' 
go
add_domain_values  'plMeasure','Total P&L (Base','Realtime Total PnL (Base' 
go
add_domain_values  'plMeasure','Total P&L (Full','Realtime Total PnL (Full' 
go
add_domain_values  'plMeasure','Base P&L','Fast Base PnL' 
go
add_domain_values  'PricerMeasurePnlBondsEOD','UNSETTLED_INTEREST','' 
go
add_domain_values  'PricerMeasurePnlBondsEOD','ACCRUAL','' 
go
add_domain_values  'PricerMeasurePnlBondsEOD','ACCRUAL','' 
go
add_domain_values  'PricerMeasurePnlRealtimeEOD','CONVERSION_FACTOR','' 
go
add_domain_values  'PricerMeasurePnlRealtimeEOD','MARKET_VALUE','' 
go
add_domain_values  'PricerMeasurePnlRealtimeEOD','Cash','' 
go
add_domain_values  'PricerMeasurePnlRealtimeEOD','HISTO_MARKET_VALUE','' 
go
add_domain_values  'PricerMeasurePnlRealtimeEOD','HISTO_Cash','' 
go
add_domain_values  'measuresForAdjustment','CA_PV','' 
go
add_domain_values  'measuresForAdjustment','CA_COST','' 
go
add_domain_values  'NamesPricerMsrEOD','PricerMeasurePnlRealtimeEOD','Realtime' 
go
add_domain_values  'PNLRealtime','Total P&L','' 
go
add_domain_values  'PNLRealtime','Total P&L (Base','' 
go
add_domain_values  'PNLRealtime','Total P&L (Full','' 
go
add_domain_values  'NamesForPNL','PNLRealtime','Realtime PnL' 
go
add_domain_values  'domainName','LifeCycleEvent','' 
go
add_domain_values  'LifeCycleEvent','tk.lifecycle.event.KnockInEvent','Knock In' 
go
add_domain_values  'LifeCycleEvent','tk.lifecycle.event.KnockOutEvent','Knock Out' 
go
add_domain_values  'LifeCycleEvent','tk.lifecycle.event.PhysicalDeliveryEvent','Physical Delivery' 
go
add_domain_values  'LifeCycleEvent','tk.lifecycle.event.RedemptionEvent','Redemption' 
go
add_domain_values  'LifeCycleEvent','tk.lifecycle.event.base.StructuredLifeCycleEvent','Structured Event' 
go
add_domain_values  'exceptionType','LIFECYCLE','' 
go
add_domain_values  'domainName','LifeCycleEventProcessor','' 
go
add_domain_values  'LifeCycleEventProcessor','tk.lifecycle.processor.KnockInTradeEventProcessor','Trade Knock In Processor' 
go
add_domain_values  'LifeCycleEventProcessor','tk.lifecycle.processor.KnockOutTradeEventProcessor','Trade Knock Out Processor' 
go
add_domain_values  'LifeCycleEventProcessor','tk.lifecycle.processor.PhysicalDeliveryEventProcessor','Physical Delivery Processor' 
go
add_domain_values  'LifeCycleEventProcessor','tk.lifecycle.processor.RedemptionTradeEventProcessor','Trade Redemption Processor' 
go
add_domain_values  'LifeCycleEventProcessor','tk.lifecycle.processor.StructuredEventProcessor','Structured Processor' 
go
add_domain_values  'domainName','LifeCycleEventTrigger','' 
go
add_domain_values  'LifeCycleEventTrigger','tk.lifecycle.trigger.PricingScriptKnockInTrigger','Knock In' 
go
add_domain_values  'LifeCycleEventTrigger','tk.lifecycle.trigger.PricingScriptKnockOutTrigger','Knock Out' 
go
add_domain_values  'LifeCycleEventTrigger','tk.lifecycle.trigger.PhysicalDeliveryTrigger','Physical Delivery' 
go
add_domain_values  'LifeCycleEventTrigger','tk.lifecycle.trigger.PricingScriptRedemptionTrigger','Redemption' 
go
add_domain_values  'LifeCycleEventTrigger','tk.lifecycle.trigger.StructuredEventTrigger','Default Structured Trigger' 
go
add_domain_values  'lifeCycleEntityType','LifeCycleEvent','LifeCycleEvent has its own life cycle' 
go
add_domain_values  'workflowType','LifeCycleEvent','LifeCycleEvent follows its own workflow' 
go
add_domain_values  'LifeCycleEventStatus','NONE','' 
go
add_domain_values  'LifeCycleEventStatus','PENDING','' 
go
add_domain_values  'LifeCycleEventStatus','CANCELED','' 
go
add_domain_values  'LifeCycleEventStatus','TERMINATED','' 
go
add_domain_values  'LifeCycleEventStatus','PROCESSED','' 
go
add_domain_values  'LifeCycleEventAction','NEW','' 
go
add_domain_values  'LifeCycleEventAction','APPLY','' 
go
add_domain_values  'LifeCycleEventAction','CANCEL','' 
go
add_domain_values  'LifeCycleEventAction','TERMINATE','' 
go
add_domain_values  'LifeCycleEventAction','AMEND','' 
go
add_domain_values  'LifeCycleUndoActionForKnockIn','UN-KNOCK_IN','' 
go
add_domain_values  'LifeCycleUndoActionForKnockOut','UN-KNOCK_OUT','' 
go
add_domain_values  'function','ExecuteLifeCycleEvent','Access Permission to execute lifecycle events' 
go
add_domain_values  'function','UndoLifeCycleEvent','Access Permission to undo lifecycle events' 
go
add_domain_values  'domainName','hedgeRelationshipDefinitionAttributes','' 
go
add_domain_values  'domainName','workflowRuleHedgeRelationshipDefinition','' 
go
add_domain_values  'domainName','hedgeDefinitionAttributes','' 
go
add_domain_values  'domainName','hedgeAccountingSchemeAttributes','' 
go
add_domain_values  'domainName','hedgeAccountingSchemeStandard','' 
go
add_domain_values  'domainName','hedgeAccountingSchemeMethod','' 
go
add_domain_values  'domainName','hedgedRisk','' 
go
add_domain_values  'domainName','hedgeRelationshipConfigurationEndDateMethod','' 
go
add_domain_values  'domainName','hedgeRelationshipConfigurationStartDateMethod','' 
go
add_domain_values  'domainName','hedgeDefinitionType','' 
go
add_domain_values  'domainName','hedgeDefinitionSubclass','' 
go
add_domain_values  'domainName','hedgeRelationshipDefinitionType','' 
go
add_domain_values  'domainName','hedgeDefinitionClassification','' 
go
add_domain_values  'scheduledTask','EOD_HEDGE_EFFECTIVENESS_ANALYSIS','' 
go
add_domain_values  'scheduledTask','EOD_HEDGE_VALUATION','' 
go
add_domain_values  'scheduledTask','EOD_HEDGE_LIQUIDATION','' 
go
add_domain_values  'scheduledTask','EOD_HEDGE_MARKING','' 
go
add_domain_values  'MainEntry.CustomEventSubscription','PSEventHedgeAccountingValuation','' 
go
add_domain_values  'MainEntry.CustomEventSubscription','PSEventHedgeRelationshipDefinition','' 
go
add_domain_values  'workflowRuleTrade','CheckHedgeDefinition','' 
go
add_domain_values  'workflowRuleTrade','CheckHedgeRelationshipDefinition','' 
go
add_domain_values  'workflowRuleTrade','CheckHedgeRelationshipDefinitionWarning','' 
go
add_domain_values  'CustomStaticDataFilter','HedgeAccounting','' 
go
add_domain_values  'CustomAccountingFilterEvent','HedgeAccounting','' 
go
add_domain_values  'CustomTradeWindow','HedgeAccounting','' 
go
add_domain_values  'eventType','HEDGE_BALANCE_VALUATION','' 
go
add_domain_values  'eventType','HEDGE_DESIGNATION_VALUATION','' 
go
add_domain_values  'eventType','TRADE_VALUATION_RELATIONSHIP','' 
go
add_domain_values  'eventType','NEW_HEDGE_RELATIONSHIP','' 
go
add_domain_values  'eventType','MODIFY_HEDGE_RELATIONSHIP','' 
go
add_domain_values  'eventType','REMOVE_HEDGE_RELATIONSHIP','' 
go
add_domain_values  'eventType','EX_HEDGE_RELATIONSHIP_DEFINITION','Exception Generated when a trade in hedge relationship definition is modified' 
go
add_domain_values  'eventType','INACTIVE_RELATIONSHIP','Status of the Hedge Relationship' 
go
add_domain_values  'eventType','TERMINATED_RELATIONSHIP','Status of the Hedge Relationship' 
go
add_domain_values  'eventType','CANCELED_RELATIONSHIP','Status of the Hedge Relationship' 
go
add_domain_values  'eventType','INEFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' 
go
add_domain_values  'eventType','EFFECTIVE_RELATIONSHIP','Status of the Hedge Relationship' 
go
add_domain_values  'eventType','PENDING_RELATIONSHIP','Status of the Hedge Relationship' 
go
add_domain_values  'classAuditMode','HedgeDefinition','' 
go
add_domain_values  'classAuditMode','HedgeRelationshipDefinition','' 
go
add_domain_values  'classAuditMode','RelationshipTradeItem','' 
go
add_domain_values  'classAuditMode','HedgeRelationshipConfiguration','' 
go
add_domain_values  'classAuthMode','HedgeRelationshipDefinition','' 
go
add_domain_values  'classAuthMode','HedgeDefinition','' 
go
add_domain_values  'classAuthMode','HedgeRelationshipConfiguration','' 
go
add_domain_values  'classAuthMode','HedgePricerMeasureMapping','' 
go
add_domain_values  'engineName','RelationshipManagerEngine','' 
go
add_domain_values  'applicationName','RelationshipManagerEngine','RelationshipManagerEngine' 
go
add_domain_values  'eventClass','PSEventHedgeAccountingValuation','' 
go
add_domain_values  'eventClass','PSEventHedgeRelationshipDefinition','' 
go
add_domain_values  'eventClass','PSEventHedgeEffectivenessTest','' 
go
add_domain_values  'eventClass','PSEventHedgeDesignationRecord','' 
go
add_domain_values  'eventFilter','HedgeRelationshipDefinitionEventFilter','' 
go
add_domain_values  'function','CreateHedgeRelationshipDefinition','Access permission to Add Hedge Relationship Definition' 
go
add_domain_values  'function','CreateHedgeDefinition','Access permission to Add Hedge Definition' 
go
add_domain_values  'function','CreateHedgePricerMeasureMapping','Access permission to Add Hedge Pricer Measure Mapping' 
go
add_domain_values  'function','ModifyHedgeRelationshipDefinition','Access permission to Modify Hedge Relationship Definition' 
go
add_domain_values  'function','ModifyHedgeDefinition','Access permission to Modify Hedge Definition' 
go
add_domain_values  'function','ModifyHedgePricerMeasureMapping','Access permission to Modify Hedge Pricer Measure Mapping' 
go
add_domain_values  'function','RemoveHedgeRelationshipDefinition','Access permission to Remove Hedge Relationship Definition' 
go
add_domain_values  'function','RemoveHedgeDefinition','Access permission to Remove Hedge Definition' 
go
add_domain_values  'function','RemoveHedgePricerMeasureMapping','Access permission to Remove Hedge Pricer Measure Mapping' 
go
add_domain_values  'riskAnalysis','HedgeEffectivenessTesting','Retrospective Hedge Effectiveness Testing' 
go
add_domain_values  'riskAnalysis','HedgeEffectivenessProTesting','Prospective Hedge Effectiveness Testing' 
go
add_domain_values  'hedgeRelationshipDefinitionAttributes','CVAMeasure','' 
go
add_domain_values  'hedgeRelationshipDefinitionAttributes','HedgeEffectivenessDocumentationReview','' 
go
add_domain_values  'hedgeRelationshipDefinitionAttributes','LastEffectivenessTest','' 
go
add_domain_values  'hedgeRelationshipDefinitionAttributes','MaterialThreshold','' 
go
add_domain_values  'hedgeRelationshipDefinitionAttributes','ShiftOnDiscountCurve','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','Base Currency','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','O/S Code','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','O/S Description','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','Baseline Amort. End Date','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','Basis Amort. End Date','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','Holidays','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','Curve Shifting','' 
go
add_domain_values  'hedgeAccountingSchemeAttributes','Test Termination/Liquidation','' 
go
add_domain_values  'hedgeDefinitionAttributes','Check List Template','' 
go
add_domain_values  'hedgeDefinitionAttributes','De-designation Fee','' 
go
add_domain_values  'hedgeDefinitionAttributes','Postings Only If Effective','' 
go
add_domain_values  'hedgeDefinitionAttributes','Pricing Environment','' 
go
add_domain_values  'hedgeDefinitionAttributes','Accounting Hedge','' 
go
add_domain_values  'hedgeDefinitionAttributes','Prospective Validation Name','' 
go
add_domain_values  'hedgeDefinitionAttributes','Retrospective Validation Name','' 
go
add_domain_values  'hedgeDefinitionSubclass','Cashflow Hedge','' 
go
add_domain_values  'hedgeDefinitionSubclass','Fair Value Hedge','' 
go
add_domain_values  'hedgeDefinitionSubclass','Net Investment Hedge','' 
go
add_domain_values  'hedgeDefinitionSubclass','Non-Qualifying Hedge','' 
go
add_domain_values  'hedgeRelationshipDefinitionType','Cashflow Hedge','' 
go
add_domain_values  'hedgeRelationshipDefinitionType','Fair Value Hedge','' 
go
add_domain_values  'hedgeRelationshipDefinitionType','Net Investment Hedge','' 
go
add_domain_values  'hedgeRelationshipDefinitionType','Non-Qualifying Hedge','' 
go
add_domain_values  'hedgeDefinitionType','Primary Hedge','' 
go
add_domain_values  'hedgeDefinitionType','Secondary Hedge','' 
go
add_domain_values  'hedgeAccountingSchemeStandard','FAS','' 
go
add_domain_values  'hedgeAccountingSchemeStandard','IAS','' 
go
add_domain_values  'hedgeAccountingSchemeMethod','Cash Flow Hedge','' 
go
add_domain_values  'hedgeAccountingSchemeMethod','Long Haul','' 
go
add_domain_values  'hedgeAccountingSchemeMethod','Change in Variable Cash Flow','' 
go
add_domain_values  'hedgeAccountingSchemeMethod','Hypothetical Derivative','' 
go
add_domain_values  'hedgeAccountingSchemeMethod','Shortcut','' 
go
add_domain_values  'hedgeAccountingSchemeTestingType','Prospective','' 
go
add_domain_values  'hedgeAccountingSchemeTestingType','Retrospective','' 
go
add_domain_values  'hedgeAccountingSchemeTestingType','Both','' 
go
add_domain_values  'hedgeAccountingSchemeValidationType','Day','' 
go
add_domain_values  'hedgeAccountingSchemeValidationType','Week','' 
go
add_domain_values  'hedgeDefinitionAttributes.Check List Template','HedgeDocumentationCheckList.tmpl','' 
go
add_domain_values  'hedgeDefinitionClassification','Hedge','' 
go
add_domain_values  'hedgeDefinitionClassification','Strategy','' 
go
add_domain_values  'hedgeDefinitionClassification','Bundle','' 
go
add_domain_values  'hedgedRisk','Credit Risk','' 
go
add_domain_values  'hedgedRisk','FX Risk','' 
go
add_domain_values  'hedgedRisk','Interest Rate Risk','' 
go
add_domain_values  'hedgedRisk','Issuer Credit Spread Risk','' 
go
add_domain_values  'hedgedRisk','Issuer Default Risk','' 
go
add_domain_values  'hedgedRisk','Price Risk','' 
go
add_domain_values  'hedgedRisk','Swap Spread Risk','' 
go
add_domain_values  'hedgeRelationshipConfigurationEndDateMethod','MaxEnteredDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationEndDateMethod','MaxMaturityDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationEndDateMethod','MaxTradeDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationEndDateMethod','MinEnteredDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationEndDateMethod','MinMaturityDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationEndDateMethod','MinTradeDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationStartDateMethod','MaxEnteredDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationStartDateMethod','MaxMaturityDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationStartDateMethod','MaxTradeDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationStartDateMethod','MinEnteredDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationStartDateMethod','MinMaturityDate','' 
go
add_domain_values  'hedgeRelationshipConfigurationStartDateMethod','MinTradeDate','' 
go
add_domain_values  'MirrorKeywords','Hedge','' 
go
add_domain_values  'workflowType','HedgeRelationshipDefinition','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','NONE','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','CANCELED','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','EFFECTIVE','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','INACTIVE','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','PENDING','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','INEFFECTIVE','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','TERMINATED','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','HYPOTHETICAL','' 
go
add_domain_values  'HedgeRelationshipDefinitionStatus','UNAPPROVED','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','CANCEL','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','DESIGNATE','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','DE_DESIGNATE','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','NEW','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','REPROCESS','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','TERMINATE','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','UPDATE','' 
go
add_domain_values  'HedgeRelationshipDefinitionAction','APPROVE','' 
go
add_domain_values  'workflowRuleHedgeRelationshipDefinition','Reprocess','' 
go
add_domain_values  'workflowRuleHedgeRelationshipDefinition','ReprocessEconomic','' 
go
add_domain_values  'workflowRuleHedgeRelationshipDefinition','Approve','' 
go
add_domain_values  'workflowRuleHedgeRelationshipDefinition','CheckEndDate','' 
go
add_domain_values  'workflowRuleHedgeRelationshipDefinition','CheckFullTermination','' 
go
begin 
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config 
select @c= count(*) from engine_config where engine_name='RelationshipManagerEngine' 
if @c = 0 
begin 
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'RelationshipManagerEngine','' ) 
end 
end
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ScriptableOTCProduct.ANY.ANY','PricerBlackNFMonteCarloExotic' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('UNSETTLED_INTEREST','tk.core.PricerMeasure',446,'interest payments that are going to settle' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('NPV_COF','tk.core.PricerMeasure',447,'This is normal NPV computation, but it will use the cost of funds curve instead of the usual discount curve' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('BREAK_EVEN_RATE_COF','tk.core.PricerMeasure',448,'This is the break even rate considering the NPV_COF cost of funds curve).' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRICE_UNDERLYING_INDEX','tk.pricer.PricerMeasureCredit',2000,'Price of the underlying index' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('ACCRUAL_FINANCING','tk.pricer.PricerMeasureCredit',2001,'Accrual for the finance leg of the trade' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('ACCRUAL_INDEX','tk.pricer.PricerMeasureCredit',2002,'Accrual for the performance leg of the trade' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('MTM_INDEX','tk.pricer.PricerMeasureCredit',2003,'Mark to market of the index price change' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('product_scot','Table for Product ScriptableOTCProduct' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, is_global_b, display_name, default_value ) VALUES ('PREM_DISC_FROM_TRADE_DATE','java.lang.Boolean','true,false',0,'PREM_DISC_FROM_TRADE_DATE','false' )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'ConfigHierarchy',1 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeAccountingScheme',1 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'DesignationRecords',1 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'RelationshipTradeItem',1 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationship',1 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeStrategy',1 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'HedgeRelationshipConfig',500 )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventLifeCycle','LifeCycleEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeRelationshipDefinition','RelationshipManagerEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTrade','RelationshipManagerEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeEffectivenessTest','RelationshipManagerEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeRelationshipDefinition','AccountingEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeAccountingValuation','AccountingEngine' )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (650,'LifeCycleEvent','NONE','NEW','PENDING',0,1,'ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (651,'LifeCycleEvent','PENDING','APPLY','PROCESSED',0,1,'ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (652,'LifeCycleEvent','PROCESSED','CANCEL','CANCELED',0,1,'ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (653,'LifeCycleEvent','CANCELED','TERMINATE','TERMINATED',0,1,'ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (654,'LifeCycleEvent','PENDING','AMEND','PENDING',0,1,'ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (655,'LifeCycleEvent','CANCELED','AMEND','CANCELED',0,1,'ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (801,'HedgeRelationshipDefinition','NONE','NEW','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (802,'HedgeRelationshipDefinition','PENDING','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (803,'HedgeRelationshipDefinition','EFFECTIVE','DE_DESIGNATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (804,'HedgeRelationshipDefinition','INEFFECTIVE','DESIGNATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (805,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (806,'HedgeRelationshipDefinition','INEFFECTIVE','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (807,'HedgeRelationshipDefinition','INEFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (808,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (809,'HedgeRelationshipDefinition','INACTIVE','TERMINATE','TERMINATED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (810,'HedgeRelationshipDefinition','INACTIVE','REPROCESS','INACTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (811,'HedgeRelationshipDefinition','PENDING','REPROCESS','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (812,'HedgeRelationshipDefinition','EFFECTIVE','UPDATE','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (813,'HedgeRelationshipDefinition','INEFFECTIVE','UPDATE','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (814,'HedgeRelationshipDefinition','INEFFECTIVE','REPROCESS','INEFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (815,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (816,'HedgeRelationshipDefinition','PENDING','CANCEL','CANCELED',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (817,'HedgeRelationshipDefinition','PENDING','UPDATE','PENDING',0,1,'ALL','ALL',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (820,'HedgeRelationshipDefinition','NONE','NEW','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (821,'HedgeRelationshipDefinition','EFFECTIVE','REPROCESS','EFFECTIVE',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (822,'HedgeRelationshipDefinition','EFFECTIVE','TERMINATE','TERMINATED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (823,'HedgeRelationshipDefinition','EFFECTIVE','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES (824,'HedgeRelationshipDefinition','TERMINATED','CANCEL','CANCELED',0,1,'ALL','Non-Qualifying Hedge',0,0,0,0,0 )
go

INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (801,'Reprocess' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (807,'Reprocess' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (808,'Reprocess' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (809,'CheckEndDate' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (810,'Reprocess' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (811,'Reprocess' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (814,'Reprocess' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (815,'Reprocess' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (820,'ReprocessEconomic' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (821,'ReprocessEconomic' )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('HedgeEffectivenessTesting','apps.risk.HedgeEffectivenessTestingViewer',0 )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('HedgeEffectivenessProTesting','apps.risk.HedgeEffectivenessProTestingViewer',0 )
go

/* REL-8487 */

if not exists (select 1 from sysobjects where name='task_enrichment_field_config' and type='U')
begin
 exec ('create table task_enrichment_field_config (workflow_type  varchar(64) not null,
 field_db_column_index    numeric not null,
 data_source_class_name   varchar(512) not null,
 data_source_getter_name  varchar(512),
 custom_class_name  varchar(512) null,
 field_conversion_class  varchar(64) null,
 extra_arguments  varchar(512) null,
 field_display_name varchar(132),
 field_db_name varchar(132) not null)')
end 
go

add_column_if_not_exists 'task_enrichment_field_config','workflow_type', 'varchar(512) NOT NULL'
go

add_column_if_not_exists 'task_enrichment_field_config','custom_class_name', 'varchar(512) NULL'
go

add_column_if_not_exists 'task_enrichment_field_config','extra_arguments', 'varchar(512) NULL'
go

add_column_if_not_exists 'task_enrichment_field_config','field_domain_finder', 'varchar(512) NULL'
go
add_column_if_not_exists 'task_enrichment_field_config','field_domain_finder_arg', 'varchar(132) NULL'
go


INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','MainEntry.Startup','' )
go
INSERT INTO domain_values ( name, value, description ) VALUES ('MainEntry.Startup','TaskEnrichment','' )
go
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','Admin.Startup','' )
go
INSERT INTO domain_values ( name, value, description ) VALUES ('Admin.Startup','TaskEnrichment','' )
go
INSERT INTO domain_values ( name, value, description ) VALUES ('function','AddModifyTSTab','Allow User to add or modify any TaskStation Tab' )
go
INSERT INTO domain_values ( name, value, description ) VALUES ('function','RemoveTSTab','Allow User to delete any TaskStation Tab' )
go
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ModifyTSTabPlan','Allow User to modify part of Window Plan related to selected TaskStation Tab' )
go
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ModifyTSTabFiltering','Allow User to display filter Panel' )
go

/* end */

/*  Update Version */
UPDATE calypso_info
    SET major_version=13,
        minor_version=0,
        sub_version=0,
        patch_version='007',
        version_date='20130102'
go
