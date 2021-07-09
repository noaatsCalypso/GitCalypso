-- update criterion for keyword account name
if not exists (select 1 from sysobjects where name='attribute_config' and type='U')
begin
exec ('create table attribute_config(attribute_name varchar(128) not null,
attr_table_name varchar(255) not null,
attr_column_name varchar(30) not null,
source_class varchar(255) not null,
attribute_class varchar(255) not null,
id numeric not null,
version numeric not null,
searchable numeric not null,
domain_name varchar(128) null,
entered_user varchar(255) null) ')
end
go

UPDATE sd_filter_element
SET element_name=(
  (SELECT attribute_name
     FROM attribute_config
    WHERE sd_filter_element.element_name LIKE ('KEYWORD.'+ attribute_name)
  AND attribute_config.attr_table_name ='trade_keyword_accel'
  AND attribute_config.attribute_class = 'com.calypso.tk.refdata.Account'
  )+ '.Account Name')
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attribute_config.attr_table_name='trade_keyword_accel'
  AND attribute_config.attribute_class    = 'com.calypso.tk.refdata.Account'
  AND sd_filter_element.element_name       = ('KEYWORD.'+ attribute_name)
  ) 
go
 
-- update criterion for keyword account property
UPDATE sd_filter_element
SET element_name=STR_REPLACE(element_name, ('KEYWORD.' +
  (SELECT attribute_name
     FROM attribute_config
    WHERE sd_filter_element.element_name LIKE (('KEYWORD.'+ attribute_name)+ '.%')
  AND attribute_config.attr_table_name ='trade_keyword_accel'
  AND attribute_config.attribute_class = 'com.calypso.tk.refdata.Account'
  )),
  (SELECT attribute_name
     FROM attribute_config
    WHERE sd_filter_element.element_name LIKE (('KEYWORD.'+ attribute_name)+ '.%')
  AND attribute_config.attr_table_name ='trade_keyword_accel'
  AND attribute_config.attribute_class = 'com.calypso.tk.refdata.Account'
  ))
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attribute_config.attr_table_name='trade_keyword_accel'
  AND attribute_config.attribute_class    = 'com.calypso.tk.refdata.Account'
  AND sd_filter_element.element_name LIKE (('KEYWORD.'+ attribute_name)+ '.%')
  ) 
go
 
 -- update criterion for keyword legalEntity name 
 UPDATE sd_filter_element
SET element_name=(
  (SELECT attribute_name
     FROM attribute_config
    WHERE sd_filter_element.element_name LIKE ('KEYWORD.'+ attribute_config.attribute_name)
  AND attribute_config.attr_table_name ='trade_keyword_accel'
  AND attribute_config.attribute_class = 'com.calypso.tk.core.LegalEntity'
  ) + '.Short Name')
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attribute_config.attr_table_name='trade_keyword_accel'
  AND attribute_config.attribute_class    = 'com.calypso.tk.core.LegalEntity'
  AND sd_filter_element.element_name       = ('KEYWORD.'+ attribute_name)
  ) 
go
 
 -- update criterion for keyword legalEntity property
UPDATE sd_filter_element
SET element_name=STR_REPLACE(element_name, ('KEYWORD.' +
  (SELECT attribute_name
     FROM attribute_config
    WHERE sd_filter_element.element_name LIKE (('KEYWORD.'+ attribute_name)+ '.%')
  AND attribute_config.attr_table_name ='trade_keyword_accel'
  AND attribute_config.attribute_class = 'com.calypso.tk.core.LegalEntity'
  )),
  (SELECT attribute_name
     FROM attribute_config
    WHERE sd_filter_element.element_name LIKE (('KEYWORD.'+ attribute_name)+ '.%')
  AND attribute_config.attr_table_name ='trade_keyword_accel'
  AND attribute_config.attribute_class = 'com.calypso.tk.core.LegalEntity'
  ))
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attribute_config.attr_table_name='trade_keyword_accel'
  AND attribute_config.attribute_class    = 'com.calypso.tk.core.LegalEntity'
  AND sd_filter_element.element_name LIKE (('KEYWORD.'+ attribute_name)+ '.%')
  ) 
go
 
 
 -- update criterion for account property 
UPDATE sd_filter_element
SET element_name = STR_REPLACE(element_name, 'ACCOUNT_PROPERTY.', 'AccountProperty.')
  WHERE element_name LIKE ('ACCOUNT_PROPERTY.%')
go

UPDATE sd_filter_domain
SET element_name = STR_REPLACE(element_name, 'ACCOUNT_PROPERTY.', 'AccountProperty.')
  WHERE element_name LIKE ('ACCOUNT_PROPERTY.%')
go

update sd_filter_element set element_name = 'Account Name' where element_name = 'GL Account'
go
update sd_filter_element set element_name = 'Account Status' where element_name = 'GL Account Status'
go