alter table userprefs_template_crit add (tmpvalues CLOB)
;
update userprefs_template_crit set tmpvalues=value
;
alter table userprefs_template_crit drop column value
;
alter table userprefs_template_crit rename column tmpvalues to value
;
