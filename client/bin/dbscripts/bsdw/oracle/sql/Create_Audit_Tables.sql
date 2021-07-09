create table calypso_database_upgrade_audit (module varchar2(128), name varchar2(128), version number, startedts timestamp, updatedts timestamp, status varchar2(56))
;
create table calypso_database_module_audit (name varchar2(128), version varchar2(12), createdts timestamp)
;
