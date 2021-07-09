BEGIN
	EXECUTE('UPDATE collateral_pool_source SET source_type=''Other'' WHERE source_type IS NULL')
END
