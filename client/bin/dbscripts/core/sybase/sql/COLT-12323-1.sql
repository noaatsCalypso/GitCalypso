IF EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'margin_call_entries' AND syscolumns.name = 'processing_type')
BEGIN 
EXECUTE ('select * into margin_call_entries_temp from margin_call_entries where processing_type != ''processing''')
EXECUTE ('UPDATE margin_call_entries_temp set margin_call_entries_temp.required_value = (select margin_call_entries.required_value from margin_call_entries where margin_call_entries.mcc_id = margin_call_entries_temp.mcc_id and convert(varchar(12),margin_call_entries.process_datetime, 3) = convert(varchar(12),margin_call_entries_temp.process_datetime, 3) and margin_call_entries.collateral_context_id = margin_call_entries_temp.collateral_context_id and margin_call_entries.processing_type=''processing'') WHERE EXISTS (SELECT 1 FROM margin_call_entries WHERE margin_call_entries_temp.mcc_id = margin_call_entries.mcc_id  and convert(varchar(12),margin_call_entries.process_datetime, 3) = convert(varchar(12),margin_call_entries_temp.process_datetime, 3) and margin_call_entries.collateral_context_id = margin_call_entries_temp.collateral_context_id and margin_call_entries.processing_type=''processing'')')   
EXECUTE ('UPDATE margin_call_entries set margin_call_entries.required_value = (select margin_call_entries_temp.required_value from margin_call_entries_temp where margin_call_entries.ID = margin_call_entries_temp.ID) where exists (select 1 from margin_call_entries_temp where margin_call_entries.id = margin_call_entries_temp.id)')  
EXECUTE ('DROP TABLE margin_call_entries_temp')
END