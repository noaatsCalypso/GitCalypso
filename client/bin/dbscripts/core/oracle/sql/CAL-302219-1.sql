delete from domain_values where name in ('ExtendibleSwap', 'ExtendibleSwap.Pricer', 'ExtendibleSwap.subtype')
;
delete from domain_values where name ='domainName' and value in ('ExtendibleSwap.Pricer', 'ExtendibleSwap.subtype')
;
delete from domain_values where name = 'productType' and value = 'ExtendibleSwap'
;
delete from domain_values where name = 'perfMeasurement.Exposure.Notional' and value = 'ExtendibleSwap'
;
delete from custom_tab_trade_config where product_type = 'ExtendibleSwap'
;