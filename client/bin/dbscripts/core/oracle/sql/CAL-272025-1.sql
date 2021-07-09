update prod_exch_code set exch_code='Local' where exch_code is null
;
UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='003',
        version_date=TO_DATE('29/05/2015','DD/MM/YYYY')
;