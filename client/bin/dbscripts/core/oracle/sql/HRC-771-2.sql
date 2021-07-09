DELETE FROM ps_event_config WHERE engine_name='LimitsController'
;

DELETE FROM engine_param WHERE engine_name = 'LimitsController'
;

DELETE FROM ps_event_filter WHERE engine_name = 'LimitsController'
;

