add_column_if_not_exists 'entity_attributes','attr_date_value','datetime null'
go

delete from entity_attributes where entity_id = 2074420 and entity_type = 'CASwiftEventCode' and attr_name in ('CAMatch.MT564', 'CAMatch.MT566', 'CAModelSubtype')
go
Insert into entity_attributes (entity_id,entity_type,attr_name,attr_type,attr_value,attr_date_value,attr_numeric_value) values (2074420,'CASwiftEventCode','CAMatch.MT564','List','Ex_Date,Record_Date,Payment_Date,Redemption_Price',null,null)
go
Insert into entity_attributes (entity_id,entity_type,attr_name,attr_type,attr_value,attr_date_value,attr_numeric_value) values (2074420,'CASwiftEventCode','CAMatch.MT566','List','Ex_Date,Record_Date,Payment_Date,Redemption_Price',null,null)
go