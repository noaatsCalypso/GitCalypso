alter table userprefs_template_crit add (tmpvalues text null)
go
update userprefs_template_crit set tmpvalues=value
go
alter table userprefs_template_crit drop value
go
sp_rename "userprefs_template_crit.tmpvalues", value
go
