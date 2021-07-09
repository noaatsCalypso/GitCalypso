 

UPDATE referring_object SET rfg_tbl_join_cols = 'prd_sd_filter_name' WHERE rfg_obj_id = 11 
go 

/* BZ 61702 */
add_column_if_not_exists 'master_confirmation','type', 'varchar(255) NULL'
go

UPDATE master_confirmation SET type ='ANY' WHERE type IS NULL
go

/* end */

UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='004',
        version_date='20090331'
go
