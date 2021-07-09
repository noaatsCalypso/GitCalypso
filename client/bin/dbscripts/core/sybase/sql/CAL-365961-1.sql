exec rename_column_if_exists 'cu_cds','start_offset','start_offset_bck'
go
exec rename_column_if_exists 'cu_cds','offset','start_offset'
go
exec rename_column_if_exists 'product_otccom_opt','settlement_offset','settlement_offset_bck'
go
exec rename_column_if_exists 'product_otccom_opt','offset','settlement_offset'
go
exec rename_column_if_exists 'product_otceq_opt','settlement_offset','settlement_offset_bck'
go
exec rename_column_if_exists 'product_otceq_opt','offset','settlement_offset'
go
exec rename_column_if_exists 'accrual_schedule_params','accrual_offset','accrual_offset_bck'
go
exec rename_column_if_exists 'accrual_schedule_params','offset','accrual_offset'
go
exec drop_column_if_exists 'cu_cds','start_offset_bck'
go
exec drop_column_if_exists 'product_otccom_opt','settlement_offset_bck'
go
exec drop_column_if_exists 'product_otceq_opt','settlement_offset_bck'
go
exec drop_column_if_exists 'accrual_schedule_params','accrual_offset_bck'
go