ALTER TABLE tr_report RENAME COLUMN price_notation TO price;
ALTER TABLE tr_report RENAME COLUMN price_notation_type TO price_type;
ALTER TABLE tr_report RENAME COLUMN additional_price_notation TO additional_price;
ALTER TABLE tr_report RENAME COLUMN additional_price_notation_type TO additional_price_type;
ALTER TABLE tr_report ADD (price_currency VARCHAR2(3) NULL);
ALTER TABLE tr_report ADD (additional_price_currency VARCHAR2(3) NULL);

ALTER TABLE tr_report_hist RENAME COLUMN price_notation TO price;
ALTER TABLE tr_report_hist RENAME COLUMN price_notation_type TO price_type;
ALTER TABLE tr_report_hist RENAME COLUMN additional_price_notation TO additional_price;
ALTER TABLE tr_report_hist RENAME COLUMN additional_price_notation_type TO additional_price_type;
ALTER TABLE tr_report_hist ADD (price_currency VARCHAR2(3) NULL);
ALTER TABLE tr_report_hist ADD (additional_price_currency VARCHAR2(3) NULL);

-- CREATE TABLE tr_reporting_attr_deprecated AS SELECT * FROM tr_reporting_attr;
-- DELETE FROM tr_reporting_attr_deprecated WHERE attribute_name NOT LIKE '%PriceNotation%';

-- UPDATE tr_reporting_attr
--  SET attribute_name = regexp_replace(attribute_name, 'PriceNotation([A-Za-z]*)1', '\1')
--  WHERE attribute_name LIKE 'PriceNotation%';

-- UPDATE tr_reporting_attr
--  SET attribute_name = replace(attribute_name, 'PriceNotation', 'Price')
--  WHERE attribute_name LIKE 'AdditionalPriceNotation%';

-- UPDATE tr_reporting_attr SET map_to = REPLACE(map_to, 'PriceNotationPrice1', 'Price') FROM tr_reporting_attr WHERE attribute_name = 'Price' AND map_to LIKE '%PriceNotationPrice1';
-- UPDATE tr_reporting_attr SET map_to = REPLACE(map_to, 'PriceNotationPriceType1', 'PriceType') FROM tr_reporting_attr WHERE attribute_name = 'PriceType' AND map_to LIKE '%PriceNotationPriceType1';
-- UPDATE tr_reporting_attr SET map_to = REPLACE(map_to, 'AdditionalPriceNotation', 'AdditionalPrice') FROM tr_reporting_attr WHERE attribute_name = 'Price' AND map_to LIKE '%AdditionalPriceNotation';
-- UPDATE tr_reporting_attr SET map_to = REPLACE(map_to, 'AdditionalPriceNotationPriceType', 'AdditionalPriceType') FROM tr_reporting_attr WHERE attribute_name = 'PriceType' AND map_to LIKE '%AdditionalPriceNotationType';

-- COMMIT;

INSERT INTO tr_reporting_attr (reporting_attribute_id, version, attribute_name, category, support, map_to, iflag, oflag, dsmatch_iflag, dsmatch_oflag, visible, readonly, copiable, description) values(342, 0, 'PriceCurrency', 'Price Information', 'trade', 'Reporting-PriceCurrency', 'WEAK_SET', 'GET', 'SET', 'GET', 1, 0, 1, 'Provides the currency of the Price. Defaults to null.');
INSERT INTO tr_reporting_attr (reporting_attribute_id, version, attribute_name, category, support, map_to, iflag, oflag, dsmatch_iflag, dsmatch_oflag, visible, readonly, copiable, description) values(343, 0, 'AdditionalPriceCurrency', 'Price Information', 'trade', 'Reporting-AdditionalPriceCurrency', 'WEAK_SET', 'GET', 'SET', 'GET', 1, 0, 1, 'Provides the currency of the Additional Price. Defaults to null.');
