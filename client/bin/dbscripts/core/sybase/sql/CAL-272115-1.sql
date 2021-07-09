add_column_if_not_exists 'liq_info','liq_info_id','int identity not null'
go

drop_pk_if_exists 'liq_info'
go



UPDATE calypso_info
    SET major_version=14,
        minor_version=4,
        sub_version=0,
        patch_version='001',
        version_date='20150930'
go 
