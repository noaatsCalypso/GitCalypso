create table calypso_database_upgrade_audit (module varchar(128) null , name varchar(128) null , version numeric null, startedts datetime null , updatedts datetime null, status varchar(56) null)
go
create table calypso_database_module_audit (name varchar(128) null, version varchar(12) null , createdts datetime null)
go
