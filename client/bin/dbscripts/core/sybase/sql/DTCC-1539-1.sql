sp_rename 'tr_report.price_notation', price
go
sp_rename 'tr_report.price_notation_type', price_type
go
sp_rename 'tr_report.additional_price_notation', additional_price
go
sp_rename 'tr_report.additional_price_notation_type', additional_price_type
go
ALTER TABLE tr_report ADD (price_currency VARCHAR(3) NULL)
go
ALTER TABLE tr_report ADD (additional_price_currency VARCHAR(3) NULL)
go


sp_rename 'tr_report_hist.price_notation', price
go
sp_rename 'tr_report_hist.price_notation_type', price_type
go
sp_rename 'tr_report_hist.additional_price_notation', additional_price
go
sp_rename 'tr_report_hist.additional_price_notation_type', additional_price_type
go
ALTER TABLE tr_report_hist ADD (price_currency VARCHAR(3) NULL)
go
ALTER TABLE tr_report_hist ADD (additional_price_currency VARCHAR(3) NULL)
go


INSERT INTO tr_reporting_attr (reporting_attribute_id, version, attribute_name, category, support, map_to, iflag, oflag, dsmatch_iflag, dsmatch_oflag, visible, readonly, copiable, description) values(342, 0, 'PriceCurrency', 'Price Information', 'trade', 'Reporting-PriceCurrency', 'WEAK_SET', 'GET', 'SET', 'GET', 1, 0, 1, 'Provides the currency of the Price. Defaults to null.')
go

INSERT INTO tr_reporting_attr (reporting_attribute_id, version, attribute_name, category, support, map_to, iflag, oflag, dsmatch_iflag, dsmatch_oflag, visible, readonly, copiable, description) values(343, 0, 'AdditionalPriceCurrency', 'Price Information', 'trade', 'Reporting-AdditionalPriceCurrency', 'WEAK_SET', 'GET', 'SET', 'GET', 1, 0, 1, 'Provides the currency of the Additional Price. Defaults to null.')
go
