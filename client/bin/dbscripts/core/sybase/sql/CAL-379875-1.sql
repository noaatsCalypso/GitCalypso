DELETE FROM domain_values WHERE name = 'engineName' AND value ='CollateralServiceIntegrationEngine'
go
DELETE FROM domain_values WHERE name = 'eventFilter' AND value ='CollateralServiceIntegrationEventFilter'
go
DELETE FROM engine_config WHERE engine_name = 'CollateralServiceIntegrationEngine'
go
DELETE from engine_param where engine_name = 'CollateralServiceIntegrationEngine'
go
DELETE from ps_event_config WHERE engine_name = 'CollateralServiceIntegrationEngine'
go
DELETE from ps_event_filter WHERE engine_name = 'CollateralServiceIntegrationEngine'
go
