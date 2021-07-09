/* Upgrade Version */
UPDATE ers_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='4',
        version_date=TO_DATE('11/10/2010','DD/MM/YYYY')
;