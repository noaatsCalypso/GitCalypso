delete from domain_values where value in ('ERSCreditEngine', 'ERSLimitEngine')
;
delete from engine_param where engine_name in ('ERSCreditEngine', 'ERSLimitEngine')
;
delete from ps_event_config where engine_name in ('ERSCreditEngine', 'ERSLimitEngine')
;