BEGIN
	EXECUTE('UPDATE collateral_pool_source SET source_type = ''Rehypothecable Assets'' WHERE source_type = ''Rehypothecatable Assets''')
	EXECUTE('DELETE FROM domain_values WHERE name = ''CollateralPool.sourceTypes'' AND value = ''Rehypothecatable Assets''')
END
