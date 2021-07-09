insert into calypso_database_module_audit(name, version, createdts) select 'ers' ,
major_version||'.'||minor_version||'.'||sub_version||'.'||patch_version ,CURRENT_TIMESTAMP from calypso_info
;

 
