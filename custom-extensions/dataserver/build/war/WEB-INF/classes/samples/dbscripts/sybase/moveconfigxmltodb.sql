delete from ers_analysis_configuration
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HypPL', 'main', '', '', 1, 1, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HypPL', 'variables', 'parameter', 'Standard', 1, 1, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('ProfitLoss', 'main', '', '', 1, 2, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('ProfitLoss', 'variables', 'parameter', 'Standard', 1, 2, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'main', '', '', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'groupings', '0', 'Currency', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('FXRisk', 'main', '', '', 1, 4, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('FXRisk', 'groupings', '0', 'Currency', 1, 4, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'groupings', '1', 'Product', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'groupings', '2', 'Book', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'groupings', '3', 'Counterparty', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'groupings', '4', 'Strategy', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'groupings', '5', 'Date', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('EQDelta', 'variables', 'parameter', 'default', 1, 3, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('FXRisk', 'groupings', '1', 'Date', 1, 4, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('FXRisk', 'variables', 'parameter', 'default', 1, 4, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('QuoteValueRecorder', 'main', '', '', 1, 5, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'main', '', '', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'groupings', '0', 'Currency', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'groupings', '1', 'Product', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'groupings', '2', 'Book', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'groupings', '3', 'Counterparty', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'groupings', '4', 'Strategy', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'groupings', '5', 'Date', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRDelta', 'variables', 'parameter', 'UpOneBp', 1, 6, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'main', '', '', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'groupings', '0', 'Currency', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'groupings', '1', 'Product', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'groupings', '2', 'Book', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'groupings', '3', 'Counterparty', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'groupings', '4', 'Strategy', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'groupings', '5', 'Date', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRGamma', 'variables', 'parameter', 'Up2Bp-2Up1Bp', 1, 7, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'main', '', '', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'groupings', '0', 'Currency', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'groupings', '1', 'Product', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'groupings', '2', 'Book', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'groupings', '3', 'Counterparty', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'groupings', '4', 'Strategy', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'groupings', '5', 'Date', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVega', 'variables', 'parameter', 'IRVegaN', 1, 8, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'main', '', '', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'general', 'pivot', 'true', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'general', 'treeview', 'true', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'groupings', '0', 'Region', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'groupings', '1', 'Industry', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'groupings', '2', 'Currency', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'groupings', '3', 'Issuer', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'groupings', '4', 'Product', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'groupings', '5', 'Country', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'groupings', '6', 'Date', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CSDelta', 'variables', 'parameter', 'CS01Up', 1, 9, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CrossAssetPL', 'main', '', '', 1, 10, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('CrossAssetPL', 'variables', 'parameter', 'default', 1, 10, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'main', '', '', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'groupings', '0', 'Currency', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'groupings', '1', 'Product', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'groupings', '2', 'Book', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'groupings', '3', 'Counterparty', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'groupings', '4', 'Strategy', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'groupings', '5', 'Issuer', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Stress', 'groupings', '6', 'Date', 1, 11, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'main', '', '', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'general', 'pivot', 'true', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'general', 'treeview', 'true', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'groupings', '0', 'Region', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'groupings', '1', 'Industry', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'groupings', '2', 'Currency', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'groupings', '3', 'Issuer', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'groupings', '4', 'Product', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'groupings', '5', 'Country', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.Credit_View', 'groupings', '6', 'Date', 1, 12, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRDeltaZ', 'main', '', '', 1, 13, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRDeltaZ', 'groupings', '0', 'Currency', 1, 13, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRDeltaZ', 'groupings', '1', 'Product', 1, 13, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRDeltaZ', 'groupings', '2', 'Book', 1, 13, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRDeltaZ', 'groupings', '3', 'Counterparty', 1, 13, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRDeltaZ', 'groupings', '4', 'Strategy', 1, 13, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRDeltaZ', 'groupings', '5', 'Date', 1, 13, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRSlide', 'main', '', '', 1, 14, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRSlide', 'groupings', '0', 'Currency', 1, 14, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRSlide', 'groupings', '1', 'Product', 1, 14, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRSlide', 'groupings', '2', 'Book', 1, 14, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRSlide', 'groupings', '3', 'Counterparty', 1, 14, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRSlide', 'groupings', '4', 'Strategy', 1, 14, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Scenario.IRSlide', 'groupings', '5', 'Date', 1, 14, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'main', '', '', 1, 15, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'general', 'treeview', 'n/a', 1, 15, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'groupings', '0', 'RiskType', 1, 15, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'groupings', '1', 'Currency', 1, 15, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'groupings', '2', 'Product', 1, 15, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'groupings', '3', 'Book', 1, 15, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'groupings', '4', 'Date', 1, 15, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'variables', 'parameter', 'Standard', 1, 15, 'Parameter')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'variables', 'confidence', '95%', 1, 15, 'Confidence Level')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'variables', 'horizon', '1 Day', 1, 15, 'Horizon')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'variables', 'observations', '250', 1, 15, 'Observations')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistSim', 'variables', 'weighting', 'Equal', 1, 15, 'Weighting')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'main', '', '', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'general', 'adhocOf', 'HistSim', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '0', 'Total', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '1', 'Currency', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '2', 'Product', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '3', 'Book', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '4', 'Counterparty', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '5', 'Strategy', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '6', 'Issuer', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'groupings', '7', 'Date', 1, 16, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'variables', 'parameter', 'Standard', 1, 16, 'Parameter')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'variables', 'confidence', '95%', 1, 16, 'Confidence Level')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'variables', 'horizon', '1 Day', 1, 16, 'Horizon')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'variables', 'observations', '250', 1, 16, 'Observations')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'variables', 'display', '1', 1, 16, 'VaR Percentage')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('HistVaR', 'variables', 'weighting', 'Equal', 1, 16, 'Weighting')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'main', '', '', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'general', 'adhocOf', 'HistSim', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'groupings', '0', 'Currency', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'groupings', '1', 'Product', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'groupings', '2', 'Book', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'groupings', '3', 'Counterparty', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'groupings', '4', 'Strategy', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'groupings', '5', 'Issuer', 1, 17, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'variables', 'parameter', 'Standard', 1, 17, 'Parameter')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'variables', 'confidence', '95%', 1, 17, 'Confidence Level')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'variables', 'horizon', '1 Day', 1, 17, 'Horizon')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'variables', 'observations', '250', 1, 17, 'Observations')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'variables', 'display', '1', 1, 17, 'VaR Percentage')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('MrgVaR', 'variables', 'weighting', 'Equal', 1, 17, 'Weighting')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'main', '', '', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'general', 'adhocOf', 'HistSim', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'groupings', '0', 'Currency', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'groupings', '1', 'Product', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'groupings', '2', 'Book', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'groupings', '3', 'Counterparty', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'groupings', '4', 'Strategy', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'groupings', '5', 'Issuer', 1, 18, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'variables', 'parameter', 'Standard', 1, 18, 'Parameter')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'variables', 'confidence', '95%', 1, 18, 'Confidence Level')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'variables', 'horizon', '1 Day', 1, 18, 'Horizon')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'variables', 'observations', '250', 1, 18, 'Observations')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'variables', 'display', '1', 1, 18, 'VaR Percentage')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IncrVaR', 'variables', 'weighting', 'Equal', 1, 18, 'Weighting')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'main', '', '', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'general', 'treeview', 'n/a', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'general', 'adhocOf', 'HypPL', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'general', 'class', 'backtesting', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'groupings', '0', 'RiskType', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'groupings', '1', 'Currency', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'groupings', '2', 'Product', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'groupings', '3', 'Book', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'parameter', 'Standard', 1, 19, 'Parameter')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'confidence', '95%', 1, 19, 'Confidence Level')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'horizon', '1 Day', 1, 19, 'Horizon')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'overlap', '1 Day', 1, 19, 'Overlap Incr')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'observations', '250', 1, 19, 'Observations')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'days', '120', 2, 19, 'Days')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'fromdate', '2007-7-31', 1, 19, 'From Date')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'one_tailed', 'false', 1, 19, 'One Tailed')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'variables', 'weighting', 'Equal', 1, 19, 'Weighting')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('BackTest', 'general', 'overlapon', 'Std10d', 1, 19, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'main', '', '', 1, 20, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'general', 'treeview', 'n/a', 1, 20, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'general', 'adhocOf', 'HistSim', 1, 20, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'general', 'class', 'riskcapital', 1, 20, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'groupings', '0', 'RiskType', 1, 20, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'groupings', '1', 'Date', 1, 20, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'parameter', 'Standard', 1, 20, 'Parameter')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'confidence', '99%', 1, 20, 'Confidence Level')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'horizon', '10 Day', 1, 20, 'Horizon')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'observations', '250', 1, 20, 'Observations')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'main', '', '', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'days', '60', 1, 20, 'Days')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'fromdate', '2007-7-31', 2, 20, 'From Date')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'scale_factor', '3.0', 1, 20, 'Scaling Factor')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('Capital', 'variables', 'weighting', 'Equal', 1, 20, 'Weighting')
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'groupings', '0', 'Currency', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'groupings', '1', 'Product', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'groupings', '2', 'Book', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'groupings', '3', 'Counterparty', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'groupings', '4', 'Strategy', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'groupings', '5', 'Issuer', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'groupings', '6', 'Date', 1, 21, NULL)
GO
INSERT INTO ers_analysis_configuration(analysis, config_name, attribute_name, attribute_value, inuse, order_id, additional)
  VALUES('IRVegaDrv', 'variables', 'parameter', 'default', 1, 21, NULL)
GO
