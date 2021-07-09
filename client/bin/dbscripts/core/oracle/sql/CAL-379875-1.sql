DELETE FROM domain_values WHERE name = 'engineName' AND value ='CollateralServiceIntegrationEngine'
;
DELETE FROM domain_values WHERE name = 'eventFilter' AND value ='CollateralServiceIntegrationEventFilter'
;
DELETE FROM engine_config WHERE ENGINE_NAME = 'CollateralServiceIntegrationEngine'
;
DELETE from engine_param where ENGINE_NAME = 'CollateralServiceIntegrationEngine'
;
DELETE from ps_event_config WHERE ENGINE_NAME = 'CollateralServiceIntegrationEngine'
;
DELETE from ps_event_filter WHERE ENGINE_NAME = 'CollateralServiceIntegrationEngine'
;
