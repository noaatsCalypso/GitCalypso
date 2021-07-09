INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'PricerKey', 'For Supporting custom position pricers' )
;
delete from domain_values where name = 'quoteType'  and value= 'Future64'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'quoteType', 'Future64', '' )
;
UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='001',
        version_date=TO_DATE('30/04/2008','DD/MM/YYYY')
;


