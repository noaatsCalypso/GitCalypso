IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'concentration_limit' AND syscolumns.name = 'breakdown')
BEGIN
	EXECUTE('ALTER TABLE concentration_limit ADD breakdown VARCHAR(256) NULL')
	EXECUTE('ALTER TABLE concentration_limit ADD depth NUMERIC NULL')
	EXECUTE('ALTER TABLE concentration_limit ADD limit_id NUMERIC NULL')
	EXECUTE('ALTER TABLE concentration_limit ADD (breakdown_key VARCHAR(256) NULL)')
	EXECUTE('ALTER TABLE concentration_limit ADD parent_limit_id NUMERIC NULL')
END
		
IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'concentration_limit' AND syscolumns.name = 'percentage_basis')
BEGIN
	EXECUTE('ALTER TABLE concentration_limit ADD percentage_basis VARCHAR(64) null')
	EXECUTE('UPDATE concentration_limit SET breakdown = ''Currency Filter'' WHERE rule_id IN (SELECT id FROM concentration_rule WHERE type=''Category'') AND breakdown IS NULL AND currencies IS NOT NULL')
	EXECUTE('UPDATE concentration_limit SET breakdown = ''Static Data Filter'' WHERE rule_id IN (SELECT id FROM concentration_rule WHERE type=''Category'') AND breakdown IS NULL AND sd_filter IS NOT NULL')
	EXECUTE('UPDATE concentration_limit SET breakdown = ''Issuer'' WHERE rule_id IN (SELECT id FROM concentration_rule WHERE type=''Issuer'') AND breakdown IS NULL')
	EXECUTE('UPDATE concentration_limit SET breakdown = ''Security'' WHERE rule_id IN (SELECT id FROM concentration_rule WHERE type=''Issue'') AND breakdown IS NULL')
	EXECUTE('UPDATE concentration_limit SET percentage_basis = ''Total Issued'' WHERE rule_id IN (SELECT id FROM concentration_rule WHERE type=''Issue'')')
	EXECUTE('UPDATE concentration_limit SET percentage_basis = ''Total Collateral Value'' WHERE rule_id IN (SELECT id FROM concentration_rule WHERE type=''Category'')')
	EXECUTE('UPDATE concentration_limit SET percentage_basis = ''Total Collateral Value'' WHERE rule_id IN (SELECT id FROM concentration_rule WHERE type=''Issuer'')')
	EXECUTE('UPDATE concentration_limit SET depth=0 WHERE depth IS NULL')
END
