BEGIN

	EXECUTE('UPDATE collateral_context SET workflow_subtype = ''From Entry Type'' WHERE  workflow_subtype = ''From Processing Type''')
       	EXECUTE('UPDATE collateral_context SET workflow_product = ''From Entry Type'' WHERE  workflow_product = ''From Processing Type''')

END
