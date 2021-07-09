
/* Delete useless permissions definition */
delete from domain_values 
where name='function' 
and value in ('CreateBenchmarkRecord','ModifyBenchmarkRecord','ViewBenchmarkRecord', 'RemoveBenchmarkRecord')
go

/* Delete old group permissions if any */
delete from group_access 
where access_value in ('CreateBenchmarkRecord', 'ViewBenchmarkRecord', 'ModifyBenchmarkRecord', 'RemoveBenchmarkRecord')
go

delete from domain_values
where name='lifeCycleEntityType'
and value='DecSuppOrder'
go


UPDATE calypso_info
    SET major_version=14,
        minor_version=2,
        sub_version=0,
        patch_version='008',
        version_date='20150228'
go 
