EXECUTE('UPDATE mrgcall_config SET po_mta_type = ''SMALLEST'' WHERE po_mta_type = ''BOTH''')

EXECUTE('UPDATE mrgcall_config SET le_mta_type = ''SMALLEST'' WHERE le_mta_type = ''BOTH''')

EXECUTE('UPDATE mrgcall_config SET po_thres_type = ''SMALLEST'' WHERE po_thres_type = ''BOTH''')

EXECUTE('UPDATE mrgcall_config SET le_thres_type = ''SMALLEST'' WHERE le_thres_type = ''BOTH''')

IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'exposure_group_definition' AND type = 'U')
BEGIN
	EXECUTE('UPDATE exposure_group_definition SET po_mta_type = ''SMALLEST'' WHERE po_mta_type = ''BOTH''') 
	EXECUTE('UPDATE exposure_group_definition SET po_thres_type = ''SMALLEST'' WHERE po_thres_type = ''BOTH''') 
	EXECUTE('UPDATE exposure_group_definition SET le_mta_type = ''SMALLEST'' WHERE le_mta_type = ''BOTH''') 
	EXECUTE('UPDATE exposure_group_definition SET le_thres_type = ''SMALLEST'' WHERE le_thres_type = ''BOTH''') 
END
