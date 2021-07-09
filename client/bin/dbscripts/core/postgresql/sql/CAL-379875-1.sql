DELETE FROM domain_values WHERE name = 'engineName' AND value ='CollateralServiceIntegrationEngine'
;
DELETE FROM domain_values WHERE name = 'eventFilter' AND value ='CollateralServiceIntegrationEventFilter'
;
DELETE FROM engine_config WHERE engine_name = 'CollateralServiceIntegrationEngine'
;
DELETE from engine_param where engine_name = 'CollateralServiceIntegrationEngine'
;
DELETE from ps_event_config WHERE engine_name = 'CollateralServiceIntegrationEngine'
;
DELETE from ps_event_filter WHERE engine_name = 'CollateralServiceIntegrationEngine'
;
