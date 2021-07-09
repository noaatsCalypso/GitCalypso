update ps_event_config set event_class = 'PSEventProcessOrder'
where engine_name in (select distinct engine_name from engine_param where param_name = 'CLASS_NAME'
and param_value ='com.calypso.engine.oms.OMSEngine')
;