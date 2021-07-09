delete from domain_values where value = 'ERSComplianceEngine'
;
delete from engine_param where engine_name = 'ERSComplianceEngine'
;
delete from ps_event_config where engine_name = 'ERSComplianceEngine'
;
delete from engine_metrics where engine_name = 'ERSComplianceEngine'
;
delete from engine_process where engine_name = 'ERSComplianceEngine'
;
delete from engine_config where engine_name = 'ERSComplianceEngine'
;
delete from domain_values where value like '%ERSCompliance%' and name in ('function','eventClass', 'domainName', 'engineName', 'engineserver.types', 'ERSComplianceServer.engines' )
;
