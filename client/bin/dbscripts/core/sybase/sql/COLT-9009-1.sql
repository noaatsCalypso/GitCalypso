BEGIN

   IF NOT EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config' AND syscolumns.name = 'acadia_b')
   BEGIN
      EXECUTE('ALTER TABLE collateral_config ADD acadia_b numeric NULL')
   END

   EXECUTE('UPDATE collateral_config SET acadia_b = 1 WHERE (SELECT mcc_value FROM collateral_config_field collateral_config_field WHERE mcc_field = ''ACADIA_AMPID'' AND collateral_config.mcc_id = collateral_config_field.mcc_id) IS NOT NULL')

END
