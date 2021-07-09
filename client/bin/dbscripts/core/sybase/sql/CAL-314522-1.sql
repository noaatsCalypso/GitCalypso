alter table lifecycle_trigger_rule add new_enabled numeric null
go
update lifecycle_trigger_rule set new_enabled = round(enabled,0)
go

alter table lifecycle_trigger_rule drop enabled
go
sp_rename 'lifecycle_trigger_rule.new_enabled', enabled
go

alter table lifecycle_processor_rule add new_enabled numeric null 
go
update lifecycle_processor_rule set new_enabled = round(enabled,0)
go

alter table lifecycle_processor_rule drop enabled
go
sp_rename 'lifecycle_processor_rule.new_enabled' ,enabled
go
