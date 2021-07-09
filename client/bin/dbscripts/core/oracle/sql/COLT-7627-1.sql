UPDATE mrgcall_config SET po_mta_type = 'SMALLEST' WHERE po_mta_type = 'BOTH'
/
UPDATE mrgcall_config SET le_mta_type = 'SMALLEST' WHERE le_mta_type = 'BOTH'
/
UPDATE mrgcall_config SET po_thres_type = 'SMALLEST' WHERE po_thres_type = 'BOTH'
/
UPDATE mrgcall_config SET le_thres_type = 'SMALLEST' WHERE le_thres_type = 'BOTH'
/
DECLARE
  v_table_exists number := 0;  
BEGIN
  select count(*) into v_table_exists
    from user_tables
    where table_name = 'exposure_group_definition';
  if (v_table_exists > 0) then
      execute immediate 'UPDATE exposure_group_definition SET po_mta_type = ''SMALLEST'' WHERE po_mta_type = ''BOTH''';
      execute immediate 'UPDATE exposure_group_definition SET po_thres_type = ''SMALLEST'' WHERE po_thres_type = ''BOTH''';
      execute immediate 'UPDATE exposure_group_definition SET le_mta_type = ''SMALLEST'' WHERE le_mta_type = ''BOTH''';
      execute immediate 'UPDATE exposure_group_definition SET le_thres_type = ''SMALLEST'' WHERE le_thres_type = ''BOTH''';
  end if;
end;
/
