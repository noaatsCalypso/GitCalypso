/*  Update Version */
 
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Trade_Full_Base_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Trade_Translation_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Trade_Cash_FX_Reval', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'PricingSheetMeasures', 'The Pricer Measures supported in the Pricing Sheet' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'NPV' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'PV' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'TV' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'VANNA_VOLGA_ADJ' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'DELTA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'DELTA_PCT' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'DELTA_RISKY_PRIM' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'DELTA_RISKY_SEC' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'MOD_DELTA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'FWD_DELTA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'FWD_DELTA_RISKY_PRIM' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'FWD_DELTA_RISKY_SEC' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'GAMMA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'MOD_GAMMA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'GAMMA_PCT' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'RHO' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'RHO2' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'REAL_RHO' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'REAL_RHO2' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'THETA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'THETA_PCT' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'REAL_THETA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'THETA2' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'VEGA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'VEGA_PCT' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'MOD_VEGA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'W_VEGA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'W_MOD_VEGA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'W_SHIFT_MOD_VEGA' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'DVEGA_DVOL' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'DVEGA_DSPOT' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'DDELTA_DVOL' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'IMPLIEDVOLATILITY' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'IMPLIED_TRADING_VOL' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'PricingSheetMeasures', 'TRADING_DAYS' )
;
 


UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='001',
        version_date=TO_DATE('05/03/2010','DD/MM/YYYY')
;
