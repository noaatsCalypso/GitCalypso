
insert into domain_values(name,value,description) VALUES ('domainName', 'PositionFXNDF.Pricer', 'Pricers for PositionFXNDF trades')
;
insert into domain_values(name,value,description) VALUES ('PositionFXNDF.Pricer','PricerFX','')
;
insert into domain_values(name,value,description) VALUES ('productType','PositionFXNDF','')
;
insert into domain_values(name,value,description) VALUES ('domainName','FXCcyPairSoftHolidays','')
;

insert into domain_values(name,value,description) VALUES ('FXCcyPairSoftHolidays','NYC','')
;
insert into domain_values(name,value,description) VALUES ('scheduledTask','POSITION_ROUTING','FX position routing')
;
insert into domain_values(name,value,description) VALUES ('scheduledTask','POSITION_ROUTING_EOD','FX EOD position routing')
;
insert into domain_values(name,value,description) VALUES ('currencyDefaultAttribute','NotionalAdjustMajorIncrement','Currency specific major notional adjustment to make from FX Deal Station')
;
insert into domain_values(name,value,description) VALUES ('currencyDefaultAttribute','NotionalAdjustMinorIncrement','Currency specific minor notional adjustment to make from FX Deal Station')
;
insert into domain_values(name,value,description) VALUES ('currencyDefaultAttribute','SettlementDateAdjustIncrement','Currency specific settlement date adjustment to make from FX Deal Station')
;
insert into pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'TRIANGULATION_CCY_RULESET_NAME', 'java.lang.String', '', 'Triangulation ccy ruleset', 1, 'TRIANGULATION_CCY_RULESET_NAME', '' )
;
UPDATE calypso_info
    SET major_version=11,
        minor_version=0,
        sub_version=0,
        patch_version='003',
        version_date=TO_DATE('11/12/2009','DD/MM/YYYY')
;