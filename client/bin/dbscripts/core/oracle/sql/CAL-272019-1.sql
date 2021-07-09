/* added diff */

 

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('SECFINANCE_EFFECTIVE_CALL_METHOD','java.lang.String','Maturity Date,Earliest Maturity Date','Used for callable Repo and Sec Lending. Select the end date for the cashflow generation',1,'Maturity Date' )
/

begin
add_domain_values('cdsPmtLagType','As per Section 8.6 of the Definitions','' );
end;
/
begin
add_domain_values('cdsPmtLagType','Section 8.6/Not to exceed thirty business days','' );
end;
/
begin
add_domain_values('XferAttributes','NettingRunConfig','' );
end;
/
begin
add_domain_values('workflowRuleTransfer','CheckRecalcNettingRun','' );
end;
/
begin
add_domain_values('workflowRuleTransfer','SetAttributes','' );
end;
/
begin
add_domain_values('function','CheckPermForAuthTrade','Access permission to Restrict ability to Authorize trade without permission on action' );
end;
/
begin
add_domain_values('function','ModifyTradeDateTime','Access permission to Restrict ability to Modify trade datetime' );
end;
/
begin
add_domain_values('restriction','CheckPermForAuthTrade','' );
end;
/
begin
add_domain_values('restriction','ModifyTradeDateTime','' );
end;
/
begin
add_domain_values('marketDataUsage','CLOSING_TRADE','usage type for Repo Underlying Curve Mapping with Cost to Close pricing' );
end;
/
begin
add_domain_values('CLOSING_TRADE.ANY.ANY','CurveRepo','Open CurveRepoSelector for usage CLOSING_TRADE in PricerConfig > Product Specific' );
end;
/
declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tab_columns WHERE table_name=upper('triparty_allocation_records') and column_name=upper('coll_value_exp_ccy') ;
  IF x!=0 THEN
    execute immediate 'alter table triparty_allocation_records modify coll_value_exp_ccy varchar2(3)';
	END IF;
end;
/

delete from domain_values where name = 'lifeCycleEntityType' and value = 'DecSuppOrder'
;
UPDATE calypso_info
    SET major_version=14,
        minor_version=3,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('29/05/2015','DD/MM/YYYY')
;
