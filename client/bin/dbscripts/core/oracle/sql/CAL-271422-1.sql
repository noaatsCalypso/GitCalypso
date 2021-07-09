update /*+ PARALLEL ( report_win_def set  ) */ report_win_def set use_pricing_env=1 where def_name = 'CompositeAnalysis'
;


UPDATE BO_TASK SET TASK_VERSION = 0 WHERE TASK_VERSION IS NULL
;

 
UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='002',
        version_date=TO_DATE('05/03/2010','DD/MM/YYYY')
;
