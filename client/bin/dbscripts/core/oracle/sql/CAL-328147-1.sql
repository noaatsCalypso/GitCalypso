    INSERT 
    INTO
        pricer_measure
        ( measure_comment, measure_id, measure_name, measure_class_name ) 
    VALUES
        ('Cap Value of Bond''s Embedded option.',916,'PV_CAP','tk.pricer.calculators.PricerMeasureBond' )
;

    INSERT 
    INTO
        pricer_measure
        ( measure_comment, measure_id, measure_name, measure_class_name ) 
    VALUES
        ('Floor Value of Bond''s Embedded option.',917,'PV_FLOOR','tk.pricer.calculators.PricerMeasureBond' )
;

    INSERT 
    INTO
        pricer_measure
        ( measure_comment, measure_id, measure_name, measure_class_name ) 
    VALUES
        (null,490,'EFFECTIVE_DURATION','tk.core.PricerMeasure' )
;
    INSERT 
    INTO
        pricer_measure
        ( measure_comment, measure_id, measure_name, measure_class_name ) 
    VALUES
        (null,491,'EFFECTIVE_CONVEXITY','tk.core.PricerMeasure' )
;
    INSERT 
    INTO
        pricer_measure
        ( measure_comment, measure_id, measure_name, measure_class_name ) 
    VALUES
        (null,492,'OPTION_ADJUSTED_SPREAD','tk.core.PricerMeasure' )
;


    INSERT 
    INTO
        pricing_param_name
        ( default_value, display_name, is_global_b, param_comment, param_domain, param_name, param_type ) 
    VALUES
        ('Bachelier','BOND_FRN_CALCULATOR',1,'Calculators for pricing embedded options','Bachelier,Black,ShiftedBlack','BOND_FRN_CALCULATOR','java.lang.String' )
;

   INSERT 
    INTO
        pricing_param_name
        ( is_global_b, param_comment, param_domain, param_name, param_type ) 
    VALUES
        (1,'When true, compute OAS first, then apply to trade funding curve before computing any other results','true,false','LGMM_CALC_FUNDING_SPREAD','java.lang.Boolean' )
;

    INSERT 
    INTO
        pricing_param_name
        ( is_global_b, param_comment, param_domain, param_name, param_type ) 
    VALUES
        (1,'Calculate Security Price on Value Date for PricerLGMM1FSaliTree','true,false','ZD_PRICING_SALITREE','java.lang.Boolean' )
;

 UPDATE pricing_param_name
 SET param_domain = 'swap_rate_offset,overlap_negative_weights,pv_ratio'
 WHERE param_name = 'SWAP_REPLICATION_METHOD'
;
 
 INSERT 
    INTO
        domain_values
        ( name, value, description ) 
    VALUES
        ('domainName','CurveBondSpread.gen','BondSpread curve generators')
;
 INSERT 
    INTO
        domain_values
        ( name, value, description ) 
    VALUES
        ('domainName','creditMktDataUsage.DIS','')
;
 INSERT 
    INTO
        domain_values
        ( name, value, description ) 
    VALUES
        ('CurveBondSpread.gen','BondSpread','')
;
 INSERT 
    INTO
        domain_values
        ( name, value, description ) 
    VALUES
        ('creditMktDataUsage','DIS','')
;
 INSERT 
    INTO
        domain_values
        ( name, value, description ) 
    VALUES
        ('creditMktDataUsage','CurveBondSpread','')
;