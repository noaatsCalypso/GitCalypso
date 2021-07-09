 
add_domain_values 'domainName', 'PositionFXNDF.Pricer', 'Pricers for PositionFXNDF trades'
go
add_domain_values 'PositionFXNDF.Pricer','PricerFX',''
go
add_domain_values 'productType','PositionFXNDF',''
go
add_domain_values 'domainName','FXCcyPairSoftHolidays',''
go
add_domain_values 'FXCcyPairSoftHolidays','NYC',''
go
add_domain_values 'scheduledTask','POSITION_ROUTING','FX position routing'
go
add_domain_values 'scheduledTask','POSITION_ROUTING_EOD','FX EOD position routing'
go
add_domain_values 'currencyDefaultAttribute','NotionalAdjustMajorIncrement','Currency specific major notional adjustment to make from FX Deal Station'
go
add_domain_values 'currencyDefaultAttribute','NotionalAdjustMinorIncrement','Currency specific minor notional adjustment to make from FX Deal Station'
go
add_domain_values 'currencyDefaultAttribute','SettlementDateAdjustIncrement','Currency specific settlement date adjustment to make from FX Deal Station'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'TRIANGULATION_CCY_RULESET_NAME', 'java.lang.String', '', 'Triangulation ccy ruleset', 1, 'TRIANGULATION_CCY_RULESET_NAME', '') 
go

/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=0,
        sub_version=0,
        patch_version='003',
        version_date='20090702'
go