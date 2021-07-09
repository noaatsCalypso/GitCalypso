exec rename_column_if_exists 'product_credit_facility','credit_limit','credit_limit_bck'  
go
exec rename_column_if_exists 'product_credit_facility','limit','credit_limit'  
go
exec rename_column_if_exists 'acc_interest_config','offset_date','offset_date_bck'  
go
exec rename_column_if_exists 'acc_interest_config','offset','offset_date'  
go
exec drop_column_if_exists 'product_credit_facility','credit_limit_bck'
go
exec drop_column_if_exists 'acc_interest_config','offset_date_bck'
go