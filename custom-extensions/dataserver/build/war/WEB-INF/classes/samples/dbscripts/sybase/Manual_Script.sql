if exists (select 1 from sysobjects where name ='add_domain_values' and type='P')

exec ('drop procedure add_domain_values')
end
go
create proc add_domain_values (@name varchar(255),@value varchar(255),@description varchar(255))
as

	declare @cnt int
	select @cnt=count(*) from domain_values where name=@name and @value=@value 
	select @cnt 
	if  (@cnt=0) 
	insert into domain_values (name,value,description) values (@name,@value,@description)
	else 
	delete from domain_values where name=@name and value=@value
	insert into domain_values (name,value,description) values (@name,@value,@description)
end
go

add_domain_values 'remittanceType','Repayment',''
go

add_domain_values 'remittanceType','IntradayRepayment',''
go

add_domain_values 'CustomerTransfer.subtype','Repayment',''
go

add_domain_values 'CustomerTransfer.subtype','IntradayRepayment',''
go

add_domain_values 'systemKeyword','needToDoInterestCleanup','';
go


add_domain_values 'domainName','MarketMeasureCalculators','Calulators for Market Measures'
go

add_domain_values 'domainName','MarketMeasureCriterion','Criterion that can be defined for Market Measures'
go

add_domain_values 'MarketMeasureCriterion','NotionalSize',''
go

add_domain_values 'MarketMeasureCriterion','ProductType',''
go

add_domain_values 'MarketMeasureCriterion','CollateralType',''
go

add_domain_values 'MarketMeasureCriterion','HasCICAProgram',''
go

add_domain_values 'MarketMeasureCriterion','MaturityDate',''
go

add_domain_values 'MarketMeasureCriterion','MemberStatus',''
go

add_domain_values 'MarketMeasureCalculators','Default',''
go

add_domain_values 'domainName','Advance.NotionalSize','List of Notional Sizes for Advance'
go

add_domain_values 'Advance.NotionalSize','1000000.',''
go

add_domain_values 'Advance.NotionalSize','2000000.',''
go

add_domain_values 'Advance.NotionalSize','3000000.',''
go

add_domain_values 'domainName','Advance.ProductType','List of Product Types for Advance'
go

add_domain_values 'Advance.ProductType','Fixed',''
go

add_domain_values 'Advance.ProductType','Float',''
go

add_domain_values 'marketDataUsage','Advance',''
go

add_domain_values 'marketDataUsage','AdvanceTemplate',''
go
		
add_domain_values 'MarketMeasureCalculators','COFRateConversion',''
go

INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id, measure_comment) VALUES('B/E_COF','tk.core.PricerMeasure','448','This is the break even rate considering the NVP_COF')
go

INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id, measure_comment) VALUES('NPV_COF','tk.core.PricerMeasure','447','NPV of the advance on a cost of funds market data')
go

add_domain_values 'domainName','MarketMeasureTrigger','Triggers for Market Measures'
go
add_domain_values 'MarketMeasureTrigger','Exotic',''
go
add_domain_values 'MarketMeasureTrigger','FixedRate',''
go
add_domain_values 'MarketMeasureTrigger','FloatingRate',''
go
add_domain_values 'MarketMeasureTrigger','None',''
go
add_domain_values 'MarketMeasureTrigger','Optionality',''
go
add_domain_values 'MarketMeasureTrigger','ForwardStarting',''
go
add_domain_values 'MarketMeasureCalculators','ForwardAdj',''
go
add_domain_values 'Advance.RateIndex','NONE',''
go
add_domain_values 'Advance.RateIndex','USD/LIBOR/3M/BBA',''
go
add_domain_values 'MarketMeasureTrigger','Inactive','' 
go
add_domain_values  'MarketMeasureCriterion','HasPPSAdjustment',''
go
add_domain_values 'MarketMeasureCriterion','IsPuttable','' 
go
add_domain_values 'MarketMeasureCriterion','IsCallable',''
go
add_domain_values 'hyperSurfaceGenerators','Advance',''
go
add_domain_values 'hyperSurfaceGenerators','AdvanceTemplate',''
go
add_domain_values 'function','AddModifyMarketMeasures','Access Permission to add.modify MarketMeasures'
go
add_domain_values 'function','DeleteMarketMeasures','Access Permission to remove MarketMeasures'
go
add_domain_values 'MarketMeasureCalculators','DefaultWAL',''
go 
add_domain_values 'MarketMeasureCriterion','NotionalStepUp,''
go
add_domain_values 'domainName','Advance.NotionalStepUp','List of Notional StepUps for Advance'
go
add_domain_values 'Advance.NotionalStepUp','1000000.',''
go
add_domain_values 'Advance.NotionalStepUp','2000000.',''
go
add_domain_values 'Advance.NotionalStepUp','3000000.',''
go
