 
begin
add_domain_values  ('domainName','CurveAttribute','' );
end;
/
begin
add_domain_values  ('domainName','CurveAttribute.CurveProbability','' );
end;
/
begin
add_domain_values  ('domainName','riskAlternateCurveInterpolator','Risk alternate curve interpolator' );
end;
/
begin
add_domain_values  ('riskAlternateCurveInterpolator','InterpolatorLogLinear','' );
end;
/
begin
add_domain_values  ('domainName','CollateralizedHedgingInstrument','Instruments for whitch the collateral ccy is the product ccy' );
end;
/
begin
add_domain_values  ('CollateralizedHedgingInstrument','Swap','' );
end;
/
begin
add_domain_values  ('CollateralizedHedgingInstrument','CapFloor','' );
end;
/
begin
add_domain_values ('CollateralizedHedgingInstrument','Swaption','' );
end;
/
begin
add_domain_values  ('domainName','PricingSheetViewerMeasures','The Pricer Measures supported in the Pricing Sheet for client data view' );
end;
/
begin
add_domain_values  ('PricingSheetViewerMeasures','CALIBRATION_RESULTS','' );
end;
/
begin
add_domain_values  ('PricingSheetViewerMeasures','LGM_MODEL','' );
end;
/
begin
add_domain_values  ('PricingSheetViewerMeasures','VEGA_POINTS','' );
end;
/
begin
add_domain_values ('PricingSheetViewerMeasures','LGMM_BESTFIT_ERROR','' );
end;
/
begin
add_domain_values  ('PricingSheetViewerMeasures','LGMM_MEANREV_SCEN','' );
end;
/

INSERT INTO pricing_param_name( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES( 'USE_EXTERNAL_FLOWS','java.lang.Boolean', 'true,false', 'A boolean used to check whether the External Cashflows should be used', 'USE_EXTERNAL_FLOWS', 'true', 0 )
;

UPDATE calypso_info
    SET major_version=14,
        minor_version=0,
        sub_version=0,
        patch_version='022',
        version_date=TO_DATE('07/01/2014','DD/MM/YYYY')
;
