declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('sd_filter_element') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table sd_filter_element (sd_filter_name varchar2(64) not null,
        element_name   varchar2(128)  not null ,
        element_type  number not null ,
        min_value   varchar2(255)  null ,
        max_value   varchar2(255)  null ,
        is_value  number not null ,
        like_value   varchar2(255)  null ,
        domain_value   varchar2(255)  null ,
        is_min_inclusive  number default 1 not null ,
        is_max_inclusive  number  default 1 not null )';
END IF;
End ;
/
 declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('attribute_config') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table attribute_config(attribute_name varchar2(128) not null,
attr_table_name varchar2(255) not null,
attr_column_name varchar2(30) not null,
source_class varchar2(255) not null,
attribute_class varchar2(255) not null,
id number not null,
version number not null,
searchable number not null,
domain_name varchar2(128) null,
entered_user varchar2(255) null)';
END IF;
End ;
/

 -- update criterion for keyword account name
 UPDATE sd_filter_element
SET element_name=concat(
  (SELECT attribute_name
     FROM attribute_config
    WHERE element_name LIKE concat('KEYWORD.', attribute_name)
  AND attr_table_name ='trade_keyword_accel'
  AND attribute_class = 'com.calypso.tk.refdata.Account'
  ), '.Account Name')
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attr_table_name='trade_keyword_accel'
  AND attribute_class    = 'com.calypso.tk.refdata.Account'
  AND element_name       = concat('KEYWORD.', attribute_name)
  ) 
;
  
-- update criterion for keyword account property
 UPDATE sd_filter_element
SET element_name=REPLACE(element_name, concat('KEYWORD.',
  (SELECT attribute_name
     FROM attribute_config
    WHERE element_name LIKE concat(concat('KEYWORD.', attribute_name), '.%')
  AND attr_table_name ='trade_keyword_accel'
  AND attribute_class = 'com.calypso.tk.refdata.Account'
  )),
  (SELECT attribute_name
     FROM attribute_config
    WHERE element_name LIKE concat(concat('KEYWORD.', attribute_name), '.%')
  AND attr_table_name ='trade_keyword_accel'
  AND attribute_class = 'com.calypso.tk.refdata.Account'
  ))
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attr_table_name='trade_keyword_accel'
  AND attribute_class    = 'com.calypso.tk.refdata.Account'
  AND element_name LIKE concat(concat('KEYWORD.', attribute_name), '.%')
  ) 
;
  
 -- update criterion for keyword legalEntity name  
 UPDATE sd_filter_element
SET element_name=concat(
  (SELECT attribute_name
     FROM attribute_config
    WHERE element_name LIKE concat('KEYWORD.', attribute_name)
  AND attr_table_name ='trade_keyword_accel'
  AND attribute_class = 'com.calypso.tk.core.LegalEntity'
  ), '.Short Name')
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attr_table_name='trade_keyword_accel'
  AND attribute_class    = 'com.calypso.tk.core.LegalEntity'
  AND element_name       = concat('KEYWORD.', attribute_name)
  ) 
;
  
 -- update criterion for keyword legalEntity property
 UPDATE sd_filter_element
SET element_name=REPLACE(element_name, concat('KEYWORD.',
  (SELECT attribute_name
     FROM attribute_config
    WHERE element_name LIKE concat(concat('KEYWORD.', attribute_name), '.%')
  AND attr_table_name ='trade_keyword_accel'
  AND attribute_class = 'com.calypso.tk.core.LegalEntity'
  )),
  (SELECT attribute_name
     FROM attribute_config
    WHERE element_name LIKE concat(concat('KEYWORD.', attribute_name), '.%')
  AND attr_table_name ='trade_keyword_accel'
  AND attribute_class = 'com.calypso.tk.core.LegalEntity'
  ))
  WHERE EXISTS
  (SELECT attribute_name
     FROM attribute_config
    WHERE attr_table_name='trade_keyword_accel'
  AND attribute_class    = 'com.calypso.tk.core.LegalEntity'
  AND element_name LIKE concat(concat('KEYWORD.', attribute_name), '.%')
  ) 
;
  
 -- update criterion for account property  
UPDATE sd_filter_element
SET element_name = REPLACE(element_name, 'ACCOUNT_PROPERTY.', 'AccountProperty.')
WHERE element_name LIKE ('ACCOUNT_PROPERTY.%')
;

UPDATE sd_filter_domain
SET element_name = REPLACE(element_name, 'ACCOUNT_PROPERTY.', 'AccountProperty.')
WHERE element_name LIKE 'ACCOUNT_PROPERTY.%'
;
  
update sd_filter_element set element_name = 'Account Name' where element_name = 'GL Account'
;
update sd_filter_element set element_name = 'Account Status' where element_name = 'GL Account Status'
;