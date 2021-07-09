exec rename_column_if_exists 'liq_limit_ccy_bucket','bucket_limit','bucket_limit_bck'
go
exec rename_column_if_exists 'liq_limit_ccy_bucket','limit','bucket_limit'
go
exec rename_column_if_exists 'liq_limit_ccy_class_lvl','class_lvl_limit','class_lvl_limit_bck'
go
exec rename_column_if_exists 'liq_limit_ccy_class_lvl','limit','class_lvl_limit'
go
exec rename_column_if_exists 'liq_limit_ccy_class_lvl_bucket','lvl_bucket_limit','lvl_bucket_limit_bck'
go
exec rename_column_if_exists 'liq_limit_ccy_class_lvl_bucket','limit','lvl_bucket_limit'
go
exec drop_column_if_exists 'liq_limit_ccy_bucket','bucket_limit_bck'
go
exec drop_column_if_exists 'liq_limit_ccy_class_lv', 'class_lvl_limit_bck'
go
exec drop_column_if_exists 'liq_limit_ccy_class_lvl_bucket', 'lvl_bucket_limit_bck'
go