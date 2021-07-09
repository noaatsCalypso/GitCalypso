
update main_entry_prop set property_value = 'reporting.ReportWindow$HedgeRelationship' where property_value = 'reporting.ReportWindow$Relationships' and property_name like '%Action'
go

update main_entry_prop set property_value = 'reporting.ReportWindow$HedgeAvailability' where property_value = 'reporting.ReportWindow$RelationshipsAvailability' and property_name like '%Action'
go

update report_template set report_type = 'HedgeRelationship' where report_type = 'Relationships'
go
