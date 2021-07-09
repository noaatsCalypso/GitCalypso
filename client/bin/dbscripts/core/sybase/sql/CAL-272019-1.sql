 
/* added diff */

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('SECFINANCE_EFFECTIVE_CALL_METHOD','java.lang.String','Maturity Date,Earliest Maturity Date','Used for callable Repo and Sec Lending. Select the end date for the cashflow generation',1,'Maturity Date' )
go
add_domain_values 'intermediary1IdentifierPrefixes','CC',''
go

add_domain_values 'cdsPmtLagType','As per Section 8.6 of the Definitions','' 
go

add_domain_values 'cdsPmtLagType','Section 8.6/Not to exceed thirty business days','' 
go

add_domain_values 'XferAttributes','NettingRunConfig','' 
go

add_domain_values 'workflowRuleTransfer','CheckRecalcNettingRun','' 
go

add_domain_values 'workflowRuleTransfer','SetAttributes','' 
go

add_domain_values 'function','CheckPermForAuthTrade','Access permission to Restrict ability to Authorize trade without permission on action' 
go

add_domain_values 'function','ModifyTradeDateTime','Access permission to Restrict ability to Modify trade datetime' 
go

add_domain_values 'restriction','CheckPermForAuthTrade','' 
go

add_domain_values 'restriction','ModifyTradeDateTime','' 
go

add_domain_values 'marketDataUsage','CLOSING_TRADE','usage type for Repo Underlying Curve Mapping with Cost to Close pricing' 
go

add_domain_values 'CLOSING_TRADE.ANY.ANY','CurveRepo','Open CurveRepoSelector for usage CLOSING_TRADE in PricerConfig > Product Specific' 
go
 

drop_pk_if_exists 'analysis_output_perm_pages'
go
delete from domain_values where name = 'lifeCycleEntityType' and value = 'DecSuppOrder'
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='000',
        version_date='20150228'
go 
