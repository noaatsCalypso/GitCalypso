
add_column_if_not_exists  'option_contract','dateformat','numeric null' 
go
add_column_if_not_exists  'eto_contract','dateformat','numeric null' 
go

update option_contract set dateformat = 1 where  dateformat is null
go
update eto_contract set dateformat = 1 where  dateformat is null
go
UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='004',
        version_date='20160701'
go 

