/* Delete useless permissions definition */
delete from DOMAIN_VALUES 
where name='function' 
and value in ('CreateBenchmarkRecord','ModifyBenchmarkRecord','ViewBenchmarkRecord', 'RemoveBenchmarkRecord')
;
/* Delete old group permissions if any */
delete from GROUP_ACCESS 
where access_value in ('CreateBenchmarkRecord', 'ViewBenchmarkRecord', 'ModifyBenchmarkRecord', 'RemoveBenchmarkRecord')
;

delete from domain_values
where name='lifeCycleEntityType'
and value='DecSuppOrder'
;

UPDATE calypso_info
    SET major_version=14,
        minor_version=2,
        sub_version=0,
        patch_version='008',
        version_date=TO_DATE('28/02/2015','DD/MM/YYYY')
;
