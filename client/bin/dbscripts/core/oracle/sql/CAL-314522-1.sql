alter table lifecycle_trigger_rule add new_enabled number null
;
update lifecycle_trigger_rule set new_enabled = round(enabled,0)
;

update lifecycle_trigger_rule set enabled = new_enabled 
;

alter table lifecycle_processor_rule add new_enabled number null 
;
update lifecycle_processor_rule set new_enabled = round(enabled,0)
;
update lifecycle_processor_rule set enabled = new_enabled 
;
