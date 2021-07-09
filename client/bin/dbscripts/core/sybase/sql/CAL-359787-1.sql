delete from domain_values where value in ('ERSCreditEngine', 'ERSLimitEngine')
go
delete from engine_param where engine_name in ('ERSCreditEngine', 'ERSLimitEngine')
go
delete from ps_event_config where engine_name in ('ERSCreditEngine', 'ERSLimitEngine')
go