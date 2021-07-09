/* diff deltas */

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('TV_ATM_TYPE','java.lang.String','Market Concordant,Forward','For FXO model Theoretical. The type of ATM volatilities used.',1,'Market Concordant' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('TV_USE_FLAT_TERM_STRUCTURE','java.lang.Boolean','true,false','For FXO model Theoretical. If ''true'', term structure of rates and volatilitiles will be ignored, and assumed flat (to the expiration of the option).',1,'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('TV_ASIAN_ARITH_PROXY','java.lang.String','Log Normal,Shifted Log Normal','For FXO model Theoretical. The proxy formula to use when valuating Asian options.',1,'Log Normal' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('MKT_THIRD_CCY_QUANTO_MODEL','java.lang.String','Theoretical,Best','For FXOption pricer FXOMarket. The model to be applied when valuating third ccy quanto options.',1,'' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('MKT_ACCRUAL_FADER_MODEL','java.lang.String','Theoretical,VannaVolga,LocalVolatilityMonteCarlo,Best','For FXOption pricer FXOMarket. The model to be applied when valuating Fader Accrual options.',1,'' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('MKT_ASIAN_CASH_IN_PRIMARY_MODEL','java.lang.String','Theoretical,LocalVolatilityMonteCarlo,Best','For FXOption pricer FXOMarket. The model to be applied when valuating asian options paying in primary currency.',1,'' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_REFERENCE_DELTA_TYPE','java.lang.String','Market Concordant','For FXO model Vanna Volga. The delta convention of the reference delta(s).',1,'Market Concordant' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_REFERENCE_DELTA','java.lang.Double','','For FXO model Vanna Volga. The delta of the vanillas used in the vanna volga hedge. It must be a number greater than 0, and no bigger than 50.',1,'25.0' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_WEIGHT_POLICY','java.lang.String','Full,Expected Life Fraction,Survival Probability,Fisher,User input','For FXO model Vanna Volga. The policy for weighting the vanna-volga adjustment before applying it to the target option.',1,'Expected Life Fraction' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_INPUT_WEIGHT','java.lang.Double','Full,Expected Life Fraction,Survival Probability,Fisher,User input','For FXO model Vanna Volga. The weight to apply if VV_WEIGHT_POLICY is set to ''User input''. It must be a number between 0.0 and 1.0.',1,'1.0' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_WEIGHT_USE_SYMMETRIC_PROB','java.lang.Boolean','true,false','For FXO model Vanna Volga. If ''true'', the probability calculations needed by the weighting scheme will be done in a way that will produce same results regardless of the pair direction (i.e., EUR/USD or USD/EUR).',1,'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_HEDGE_POLICY','java.lang.String','Synthetic,Natural','For FXO model Vanna Volga. The methodology used to decide the composition of the hedge portfolio. ''Synthetic'' to make it match the vega, vanna, volga. ''Natural'' to match vanna with Risk Reversal''s vanna and volga with Butterfly''s volga.',1,'Synthetic' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_HEDGE_EXPIRY','java.lang.String','Barrier End Date,Expiry Date,Expected Exit Date','For FXO model Vanna Volga, when applied to barrier options. The expiry of the vanna-volga hedge portfolio.',1,'Barrier End Date' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_SPARE_TERMINAL_ADJUSTMENT','java.lang.Boolean','true,false','For FXO model Vanna Volga, when applied to barrier options. If ''true'', the terminal expiry will be approximated with the model indicated by parameter VV_TERMINAL_REF_MODEL.',1,'true' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_TERMINAL_REF_MODEL','java.lang.String','Market,VannaVolga','For FXO model Vanna Volga, when applied to barrier options. The model to use when evaluating the terminal expiry.',1,'Market' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_CONSISTENCY_ENFORCEMENT','java.lang.String','None,Basic,Advanced','For FXO model Vanna Volga, when applied to barrier options. The degree of complexity on the methodology to ensure consistency accross related barrier options.',1,'Basic' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_EXPIRY_BARRIER_MODEL','java.lang.String','Market,VannaVolga','For FXOption pricer FXOVannaVolga. The model to apply when dealing European barrier options.',1,'Market' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_THIRD_CCY_QUANTO_MODEL','java.lang.String','Theoretical,Best','For FXOption pricer FXOVannaVolga. The model to be applied when valuating third ccy quanto options.',1,'' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('VV_ACCRUAL_RESETTABLE_MODEL','java.lang.String','Theoretical,Market,LocalVolatilityMonteCarlo,Best','For FXOption pricer FXOVannaVolga. The model to be applied when valuating Resettable Accrual options.',1,'' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('TV_MC_ITERATIONS','java.lang.Integer','','For FXO model TheoreticalMonteCarlo. The number of iterations performed by the Monte Carlo simulation. It has to lay between 1 and 16777215; the input will be internally adjusted to the first greater number in the sequence 2^n - 1 (like 65535=2^15 - 1).',1,'32767' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('TV_MC_PAYOFF_SMOOTHING_PV','java.lang.Double','','For FXO model TheoreticalMonteCarlo. The level of smoothing to apply when calculating PV measures. 0 will mean "no smoothing applied", while any other positive number will be interpreted "number of standard deviations".',1,'0.0' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('TV_MC_PAYOFF_SMOOTHING_SNS','java.lang.Double','','For FXO model TheoreticalMonteCarlo. The level of smoothing to apply when calculating sensitivity measures. 0 will mean "no smoothing applied", while any other positive number will be interpreted "number of standard deviations".',1,'0.125' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('LV_MC_MAX_STEP_DAYS','java.lang.Double','','For FXO model LocalVolatilityMonteCarlo. The maximum size of a Monte Carlo step, in natural days.',1,'14.0' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('LV_MC_ITERATIONS','java.lang.Integer','','For FXO model LocalVolatilityMonteCarlo. The number of iterations performed by the Monte Carlo simulation. It has to lay between 1 and 16777215; the input will be internally adjusted to the first greater number in the sequence 2^n - 1 (like 511=2^9 - 1).',1,'32767' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('LV_MC_PAYOFF_SMOOTHING_PV','java.lang.Double','','For FXO model LocalVolatilityMonteCarlo. The level of smoothing to apply when calculating PV measures. 0 will mean "no smoothing applied", while any other positive number will be interpreted "number of standard deviations".',1,'0.0' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('LV_MC_PAYOFF_SMOOTHING_SNS','java.lang.Double','','For FXO model LocalVolatilityMonteCarlo. The level of smoothing to apply when calculating sensitivity measures. 0 will mean "no smoothing applied", while any other positive number will be interpreted "number of standard deviations".',1,'0.125' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('LV_MC_TV_MODEL','java.lang.String','Theoretical,TheoreticalMonteCarlo','For FXOption pricer FXOLocalVolatilityMonteCarlo. The model to use when evaluating pricer measure TV.',1,'Theoretical' )
go
add_domain_values 'function','AddModifyTSTab','Allow User to add or modify any TaskStation Tab'
go
add_domain_values 'function','RemoveTSTab','Allow User to delete any TaskStation Tab'
go
add_domain_values 'function','TaskStation_SummaryPanelConfig_ADD_CHANGE','Allow User to add a summary panel configuration rule'
go
add_domain_values 'function','ModifyTSTabPlan','Allow User to modify part of Window Plan related to selected TaskStation Tab'
go
add_domain_values 'function','ModifyTSTabFiltering','Allow User to display filter Panel'
go
add_domain_values 'function','ModifyTSCatalogOrdering','Allow User to modify Task Station Catalog Ordering'
go
add_domain_values 'domainName','taskEnrichmentClasses','List of data source classes used for task enrichment'
go
add_domain_values 'taskEnrichmentClasses','Trade','com.calypso.tk.core.Trade'
go
add_domain_values 'taskEnrichmentClasses','Transfer','com.calypso.tk.bo.BOTransfer'
go
add_domain_values 'taskEnrichmentClasses','Message','com.calypso.tk.bo.BOMessage'
go
add_domain_values 'taskEnrichmentClasses','CrossWorkflows','com.calypso.tk.bo.Task'
go
add_domain_values 'taskEnrichmentClasses','Dynamic','com.calypso.tk.bo.Task'
go
add_domain_values 'taskEnrichmentClasses','TradeBundle','com.calypso.tk.core.TradeBundle'
go
add_domain_values 'taskEnrichmentClasses','CAElection','com.calypso.tk.product.corporateaction.CAElection'
go
add_domain_values 'taskEnrichmentClasses','HedgeRelationshipDefinition','HedgeRelationshipDefinition'
go
add_domain_values 'FXOption.Pricer','PricerFXOMarket','' 
go
add_domain_values 'FXOption.Pricer','PricerFXOTheoretical','Implements TV valuation (Black-Scholes model with ATM volatilities)'
go
add_domain_values 'FXOption.Pricer','PricerFXOVannaVolga','Implements smile adapted valuation via Vanna Volga adjustment'
go
add_domain_values 'FXOption.Pricer','PricerFXOTheoreticalMonteCarlo','Implements TV valuation (Black-Scholes model with ATM volatilities), and solves it by Monte Carlo simulation'
go
add_domain_values 'FXOption.Pricer','PricerFXOLocalVolatilityMonteCarlo','Implements smile adapted model Local Volatility and solves it by Monte Carlo simulation'
go
add_domain_values 'domainName','PositionKeeping.SpotRiskTransferByPV','If False, SpotRiskTransfer is by notional, otherwise by PV of the notional'
go
add_domain_values 'PositionKeeping.SpotRiskTransferByPV','False',''
go



UPDATE calypso_info
    SET major_version=14,
        minor_version=2,
        sub_version=0,
        patch_version='003',
        version_date='20150228'
go 
