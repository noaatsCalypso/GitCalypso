DELETE FROM ps_event_config WHERE engine_name='LimitsController'
go

DELETE FROM engine_param WHERE engine_name = 'LimitsController'
go

DELETE FROM ps_event_filter WHERE engine_name ='LimitsController'
go