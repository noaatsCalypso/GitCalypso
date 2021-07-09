UPDATE task_enrichment_field_config SET  data_source_getter_name = 'getLongId' WHERE field_db_name='xfer_id'
go
UPDATE task_enrichment_field_config SET  data_source_getter_name = 'getNettedTransferLongId' WHERE field_db_name='netted_transfer_id'
go
UPDATE task_enrichment_field_config SET  data_source_getter_name = 'getLinkedLongId' WHERE field_db_name='xfer_linked_id'
go
UPDATE task_enrichment_field_config SET  data_source_getter_name = 'getLongId' WHERE field_db_name='msg_id'
go
UPDATE task_enrichment_field_config SET  data_source_getter_name = 'getLinkedLongId' WHERE field_db_name='msg_linked_id'
go
