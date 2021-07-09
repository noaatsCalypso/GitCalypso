IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'le_eligibility_filters')
BEGIN 
        EXECUTE('ALTER TABLE collateral_config ADD le_eligibility_filters BINARY NULL')
        EXECUTE('ALTER TABLE collateral_config ADD le_eligibility_exclusion BINARY NULL')
END
  
IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'eligibility_exlusion')
BEGIN 
        EXECUTE('ALTER TABLE collateral_config ADD eligibility_exlusion BINARY NULL')
END
  
IF EXISTS(SELECT 1 FROM sysobjects WHERE sysobjects.name = 'exposure_group_definition')
BEGIN
    IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'le_eligibility_filters')
    BEGIN 
      EXECUTE('ALTER TABLE exposure_group_definition ADD le_eligibility_filters BINARY NULL')
      EXECUTE( 'ALTER TABLE exposure_group_definition ADD le_eligibility_exclusion BINARY NULL')
    END
  
    IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'eligiblity_exclusion')
      BEGIN 
        EXECUTE('ALTER TABLE exposure_group_definition ADD eligibility_exlusion BINARY NULL')
      END
      
    IF NOT EXISTS(SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'exposure_group_definition' AND syscolumns.name = 'eligibility_filters')
      BEGIN 
        EXECUTE('ALTER TABLE exposure_group_definition ADD eligibility_filters BINARY NULL')
      END
      
  
    EXECUTE('UPDATE exposure_group_definition SET le_eligibility_filters = eligibility_filters')
    EXECUTE('UPDATE exposure_group_definition SET le_eligibility_exclusion = eligibility_exclusion')
  
  END

