update prod_exch_code set exch_code='Local' where exch_code is null
go
UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='003',
        version_date='20150529'
go 
