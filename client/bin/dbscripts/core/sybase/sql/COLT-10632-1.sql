IF EXISTS (SELECT 1 FROM sysobjects WHERE sysobjects.name = 'collateral_config')
BEGIN

	IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE sysobjects.name = 'collateral_config_bin')
	BEGIN
		EXECUTE('CREATE TABLE collateral_config_bin (mcc_id NUMERIC NOT NULL, additional_fields IMAGE NULL, collateral_dates IMAGE NULL, eligibility_filters IMAGE NULL, eligibility_exclusion IMAGE NULL, le_eligibility_filters IMAGE NULL, le_eligibility_exclusion IMAGE NULL)')
	END

	
	EXECUTE('INSERT INTO collateral_config_bin (mcc_id) SELECT collateral_config.mcc_id FROM collateral_config WHERE NOT EXISTS (SELECT collateral_config_bin.mcc_id FROM collateral_config,collateral_config_bin WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id)')

	IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'additional_fields')
	BEGIN
		EXECUTE('UPDATE collateral_config_bin SET additional_fields = collateral_config.additional_fields FROM collateral_config WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id')
	END
	
	
	IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'collateral_dates')
	BEGIN
		EXECUTE('UPDATE collateral_config_bin SET collateral_dates = collateral_config.collateral_dates FROM collateral_config WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id')
	END
	
	
	IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'eligibility_filters')
	BEGIN
		EXECUTE('UPDATE collateral_config_bin SET eligibility_filters = collateral_config.eligibility_filters FROM collateral_config  WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id')
	END
	
	
	IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'eligibility_exclusion')
	BEGIN
		EXECUTE('UPDATE collateral_config_bin SET eligibility_exclusion = collateral_config.eligibility_exclusion FROM collateral_config WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id')
	END
	
	
	IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_eligibility_filters')
	BEGIN
		EXECUTE('UPDATE collateral_config_bin SET le_eligibility_filters = collateral_config.le_eligibility_filters FROM collateral_config WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id')
	END
	
	
	IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_eligibility_exclusion')
	BEGIN
		EXECUTE('UPDATE collateral_config_bin SET le_eligibility_exclusion = collateral_config.le_eligibility_exclusion FROM collateral_config WHERE collateral_config.mcc_id = collateral_config_bin.mcc_id')
	END

END
go 
