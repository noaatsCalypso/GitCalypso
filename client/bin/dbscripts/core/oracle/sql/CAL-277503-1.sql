/* Upgrade Version */
UPDATE ers_info
    SET major_version=12,
        minor_version=0,
        sub_version=0,
        patch_version='0',
        version_date=TO_DATE('21/04/2011','DD/MM/YYYY')
;