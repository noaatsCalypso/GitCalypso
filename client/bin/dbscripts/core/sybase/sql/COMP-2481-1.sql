delete from sched_task where task_type = 'ERSC_COMPLIANCE_MIGRATION_EXPORT'
GO
delete from domain_values where name = 'scheduledTask' and value =  'ERSC_COMPLIANCE_MIGRATION_EXPORT'
GO