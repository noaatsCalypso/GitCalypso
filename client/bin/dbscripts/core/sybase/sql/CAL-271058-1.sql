 

INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'PricerKey', 'For Supporting custom position pricers' )
go

add_domain_values 'quoteType', 'Future64', ''  
go

UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='001',
        version_date='20080430'
go
