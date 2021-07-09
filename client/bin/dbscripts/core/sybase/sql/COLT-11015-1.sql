BEGIN
	EXECUTE('UPDATE report_win_def SET use_pricing_env = 1 WHERE def_name LIKE ''TradeAllocationInventory%''')
END
