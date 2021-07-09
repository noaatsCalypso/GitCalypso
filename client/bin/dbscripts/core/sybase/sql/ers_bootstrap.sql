insert into calypso_database_module_audit(name, version, createdts) select 'ers' ,
convert(varchar(5),major_version)||'.'||convert(varchar(5),minor_version)||'.'||convert(varchar(5),sub_version)||'.'||patch_version ,getdate() from calypso_info
go

 
