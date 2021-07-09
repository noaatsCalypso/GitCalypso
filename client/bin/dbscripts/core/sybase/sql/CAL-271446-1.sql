/* Diff process */

 

add_domain_values  'domainName','CurveAttribute','' 
go
add_domain_values  'domainName','CurveAttribute.CurveProbability','' 
go
add_domain_values  'domainName','riskAlternateCurveInterpolator','Risk alternate curve interpolator' 
go
add_domain_values  'riskAlternateCurveInterpolator','InterpolatorLogLinear','' 
go
add_domain_values  'domainName','CollateralizedHedgingInstrument','Instruments for whitch the collateral ccy is the product ccy' 
go
add_domain_values  'CollateralizedHedgingInstrument','Swap','' 
go
add_domain_values  'CollateralizedHedgingInstrument','CapFloor','' 
go
add_domain_values 'CollateralizedHedgingInstrument','Swaption','' 
go
add_domain_values  'domainName','PricingSheetViewerMeasures','The Pricer Measures supported in the Pricing Sheet for client data view' 
go
add_domain_values  'PricingSheetViewerMeasures','CALIBRATION_RESULTS','' 
go
add_domain_values  'PricingSheetViewerMeasures','LGM_MODEL','' 
go
add_domain_values  'PricingSheetViewerMeasures','VEGA_POINTS','' 
go
add_domain_values 'PricingSheetViewerMeasures','LGMM_BESTFIT_ERROR','' 
go
add_domain_values  'PricingSheetViewerMeasures','LGMM_MEANREV_SCEN','' 
go


INSERT INTO pricing_param_name( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES( 'USE_EXTERNAL_FLOWS','java.lang.Boolean', 'true,false', 'A boolean used to check whether the External Cashflows should be used', 'USE_EXTERNAL_FLOWS', 'true', 0 )
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=0,
        sub_version=0,
        patch_version='022',
        version_date='20140107'
go
