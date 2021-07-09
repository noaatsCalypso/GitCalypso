delete from domain_values where value in ('ERS_LIMIT_HOUSEKEEPING', 'ERS_LIMIT_BATCH')
go

delete from sched_task where task_type in ('ERS_LIMIT_HOUSEKEEPING', 'ERS_LIMIT_BATCH')
go
