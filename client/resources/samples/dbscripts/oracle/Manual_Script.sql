CREATE OR REPLACE PROCEDURE add_domain_values (dname IN varchar2, dvalue in varchar2, ddescription in varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM domain_values WHERE name= dname and value= dvalue;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
        if x = 1 then
                execute immediate 'delete from domain_values where name='||chr(39)||dname||chr(39)||' and value ='||chr(39)||dvalue||chr(39);
                execute immediate 'insert into domain_values ( name, value, description )
                VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
        elsif x=0 THEN
	        execute immediate 'insert into domain_values ( name, value, description ) 
                VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
    END IF;
END add_domain_values;
/

begin
add_domain_values('remittanceType','Repayment','');
end;
/
begin
add_domain_values('remittanceType','IntradayRepayment','');
end;
/
begin
add_domain_values('CustomerTransfer.subtype','Repayment','');
end;
/
begin
add_domain_values('CustomerTransfer.subtype','IntradayRepayment','');
end;
/
begin
add_domain_values('systemKeyword','needToDoInterestCleanup','');
end;
/
begin
add_domain_values('domainName','MarketMeasureCalculators','Calulators for Market Measures');
end;
/
begin
add_domain_values('domainName','MarketMeasureCriterion','Criterion that can be defined for Market Measures');
end;
/
begin
add_domain_values('MarketMeasureCriterion','NotionalSize','');
end;
/
begin
add_domain_values('MarketMeasureCriterion','ProductType','');
end;
/
begin
add_domain_values('MarketMeasureCriterion','CollateralType','');
end;
/
begin
add_domain_values('MarketMeasureCriterion','HasCICAProgram','');
end;
/
begin
add_domain_values('MarketMeasureCriterion','MaturityDate','');
end;
/
begin
add_domain_values('MarketMeasureCriterion','MemberStatus','');
end;
/
begin
add_domain_values('MarketMeasureCalculators','Default','');
end;
/
begin
add_domain_values('domainName','Advance.NotionalSize','List of Notional Sizes for Advance');
end;
/
begin
add_domain_values('Advance.NotionalSize','1000000.','');
end;
/
begin
add_domain_values('Advance.NotionalSize','2000000.','');
end;
/
begin
add_domain_values('Advance.NotionalSize','3000000.','');
end;
/
begin
add_domain_values('domainName','Advance.ProductType','List of Product Types for Advance');
end;
/
begin
add_domain_values('Advance.ProductType','Fixed','');
end;
/
begin
add_domain_values('Advance.ProductType','Float','');
end;
/
begin
add_domain_values ('marketDataUsage','Advance','');
end;
/
begin
add_domain_values ('marketDataUsage','AdvanceTemplate','');
end;
/
begin 
add_domain_values ('MarketMeasureCalculators','COFRateConversion','');
end;
/
INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id, measure_comment) 
VALUES('B/E_COF','tk.core.PricerMeasure','448','This is the break even rate considering the NVP_COF')
/

INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id, measure_comment) 
VALUES('NPV_COF','tk.core.PricerMeasure','447','NPV of the advance on a cost of funds market data')
/
begin
add_domain_values('domainName','MarketMeasureTrigger','Triggers for Market Measures');
add_domain_values('MarketMeasureTrigger','Exotic','');
add_domain_values('MarketMeasureTrigger','FixedRate','');
add_domain_values('MarketMeasureTrigger','FloatingRate','');
add_domain_values('MarketMeasureTrigger','None','');
add_domain_values('MarketMeasureTrigger','Optionality','');
add_domain_values('MarketMeasureTrigger','ForwardStarting','');
add_domain_values('MarketMeasureCalculators','ForwardAdj','');
add_domain_values('Advance.RateIndex','NONE','');
add_domain_values('Advance.RateIndex','USD/LIBOR/3M/BBA','');
add_domain_values('MarketMeasureTrigger','Inactive','');
end;
/

begin 
add_domain_values ('MarketMeasureCriterion','HasPPSAdjustment','');
end;
/
begin 
add_domain_values ('MarketMeasureCriterion','IsPuttable','');
end;
/
begin 
add_domain_values ('MarketMeasureCriterion','IsCallable','');
end;
/

begin 
add_domain_values ('hyperSurfaceGenerators','Advance','');
add_domain_values ('hyperSurfaceGenerators','AdvanceTemplate','');
add_domain_values ('function','AddModifyMarketMeasures','Access Permission to add.modify MarketMeasures');
add_domain_values ('function','DeleteMarketMeasures','Access Permission to remove MarketMeasures');
add_domain_values ('MarketMeasureCalculators','DefaultWAL','');
end;
/
begin 
add_domain_values ('MarketMeasureCriterion','NotionalStepUp,'');
add_domain_values ('domainName','Advance.NotionalStepUp','List of Notional StepUps for Advance');
add_domain_values ('Advance.NotionalStepUp','1000000.','');
add_domain_values ('Advance.NotionalStepUp','2000000.','');
add_domain_values ('Advance.NotionalStepUp','3000000.','');
end;
/


