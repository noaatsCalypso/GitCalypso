UPDATE referring_object SET rfg_tbl_join_cols = 'prd_sd_filter_name' WHERE rfg_obj_id = 11 
; 

/* BZ 61702 */


UPDATE master_confirmation SET type = 'ANY' WHERE type IS NULL
;

/* end */

UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='004',
        version_date=TO_DATE('31/03/2009','DD/MM/YYYY')
;
