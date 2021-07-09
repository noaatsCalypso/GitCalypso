DECLARE
	v_column_exists number := 0;  
BEGIN
	select count(*) into v_column_exists from user_tab_columns where table_name = 'MARGIN_CALL_ENTRIES' and column_name = 'PROCESSING_TYPE';
	if (v_column_exists > 0) then
BEGIN
execute immediate
'CREATE TABLE margin_call_entries_temp AS ( select * from margin_call_entries where processing_type != ''processing'')';
execute immediate
'UPDATE margin_call_entries_temp set margin_call_entries_temp.required_value = (select margin_call_entries.required_value from margin_call_entries where margin_call_entries.mcc_id = margin_call_entries_temp.mcc_id and trunc(margin_call_entries.process_datetime) = trunc(margin_call_entries_temp.process_datetime) and margin_call_entries.collateral_context_id = margin_call_entries_temp.collateral_context_id and margin_call_entries.processing_type=''processing'') WHERE EXISTS (SELECT 1 FROM margin_call_entries WHERE margin_call_entries_temp.mcc_id = margin_call_entries.mcc_id and trunc(margin_call_entries.process_datetime) = trunc(margin_call_entries_temp.process_datetime) and margin_call_entries.collateral_context_id = margin_call_entries_temp.collateral_context_id and margin_call_entries.processing_type=''processing'')';
execute immediate
'UPDATE margin_call_entries set margin_call_entries.required_value = (select margin_call_entries_temp.required_value from margin_call_entries_temp where margin_call_entries.ID = margin_call_entries_temp.ID) where exists (select 1 from margin_call_entries_temp where margin_call_entries.id = margin_call_entries_temp.id)';
execute immediate 
'DROP TABLE margin_call_entries_temp';
END;
end if;
END;