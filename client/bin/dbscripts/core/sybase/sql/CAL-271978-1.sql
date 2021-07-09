add_column_if_not_exists 'product_tlock','settlement_type','varchar(255)  null'
go
add_column_if_not_exists 'product_tlock','duration','float null'
go
add_column_if_not_exists 'product_tlock','lock_price','float null'
go
add_column_if_not_exists 'product_tlock','duration_override_b','numeric null'
go
add_column_if_not_exists 'product_tlock','observation_type','varchar(255)  null'
go

update product_tlock set settlement_type = 'CASH_SETTLE_YIELD' where settlement_type is null
go
update product_tlock set observation_type = 'SINGLE' where observation_type is null
go

update acc_account set call_acc_subtype = 'Security' where call_acc_subtype is null
and acc_account_id in (select account_id from account_trans where attribute = 'SecuritySettle' and value='true')
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='020',
        version_date='20141231'
go
