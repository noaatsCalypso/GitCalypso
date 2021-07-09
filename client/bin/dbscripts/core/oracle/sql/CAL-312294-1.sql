begin
add_column_if_not_exists ('entity_attributes','attr_date_value','datetime null');
end;
/
delete from entity_attributes where entity_id = 2074420 and entity_type = 'CASwiftEventCode' and attr_name in ('CAMatch.MT564', 'CAMatch.MT566', 'CAModelSubtype')
;
Insert into entity_attributes (ENTITY_ID,ENTITY_TYPE,ATTR_NAME,ATTR_TYPE,ATTR_VALUE,ATTR_DATE_VALUE,ATTR_NUMERIC_VALUE) values (2074420,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Record_Date,Payment_Date,Redemption_Price',null,null)
;
Insert into entity_attributes (ENTITY_ID,ENTITY_TYPE,ATTR_NAME,ATTR_TYPE,ATTR_VALUE,ATTR_DATE_VALUE,ATTR_NUMERIC_VALUE) values (2074420,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Record_Date,Payment_Date,Redemption_Price',null,null)
;
