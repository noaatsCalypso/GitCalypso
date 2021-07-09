DELETE FROM domain_values WHERE name in ('ExtendibleSwap', 'ExtendibleSwap.Pricer', 'ExtendibleSwap.subtype')
go
DELETE FROM domain_values WHERE name ='domainName' AND value in ('ExtendibleSwap.Pricer', 'ExtendibleSwap.subtype')
go
DELETE FROM domain_values WHERE name = 'productType' AND value = 'ExtendibleSwap'
go
DELETE FROM domain_values WHERE name = 'perfMeasurement.Exposure.Notional' AND value = 'ExtendibleSwap'
go
DELETE FROM custom_tab_trade_config WHERE product_type = 'ExtendibleSwap'
go