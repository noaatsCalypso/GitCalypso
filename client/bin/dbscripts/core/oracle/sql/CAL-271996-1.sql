delete  from domain_values where name='PositionKeepingServer.engines' and value='LiquidityPositionPersistenceEngine'
;
delete  from domain_values where name='PositionKeepingServer.instances' and value='liquidityserver'
;


/* CAL-195082 CAL-231076 */
begin
add_column_if_not_exists ('product_repo','indemnity_rate','float null');
end;
;
begin
add_column_if_not_exists ('product_repo_hist','indemnity_rate','float null');
end;
;
update product_repo
set product_repo.indemnity_rate = (select product_cash.fixed_rate from product_cash where product_cash.product_id = product_repo.money_market_id)
where product_repo.buysellback_b=1 and product_repo.product_id in (
      select distinct repo_collateral.product_id from repo_collateral, product_collateral
      where repo_collateral.collateral_id=product_collateral.product_id
      and product_collateral.pass_through_b=0)
;
update product_repo_hist
set product_repo_hist.indemnity_rate = (select product_cash_hist.fixed_rate from product_cash_hist where product_cash_hist.product_id = product_repo_hist.money_market_id)
where product_repo_hist.buysellback_b=1 and product_repo_hist.product_id in (
      select distinct repo_coll_hist.product_id from repo_coll_hist, prd_coll_hist
      where repo_coll_hist.collateral_id=prd_coll_hist.product_id
      and prd_coll_hist.pass_through_b=0)
;

/* CAL-189723 CAL-231268 */
begin
add_column_if_not_exists ('product_repo','delivery_type','varchar2(24) null');
end;
;
update product_repo
set delivery_type='Default'
where delivery_type is null
;
begin
add_column_if_not_exists ('product_repo','maturity_type','varchar2(50) null');
end;
;
update product_repo
set product_repo.maturity_type = (select 'OPEN' from product_cash cash where cash.product_id = product_repo.money_market_id and  cash.open_term_b =1 and cash.end_date is null)
where product_repo.maturity_type is null and product_repo.continuous_b = 0
;
update product_repo
set product_repo.maturity_type = 'CONTINUOUS'
where product_repo.maturity_type is null and product_repo.continuous_b = 1
;
update product_repo
set product_repo.maturity_type = (select 'TERM' from product_cash cash where cash.product_id = product_repo.money_market_id and  cash.open_term_b =0)
where product_repo.maturity_type is null and product_repo.continuous_b = 0
;

begin
add_column_if_not_exists ('product_repo_hist','delivery_type','varchar2(24) null');
end;
;
update product_repo_hist
set delivery_type='Default'
where delivery_type is null
;
begin
add_column_if_not_exists ('product_repo_hist','maturity_type','varchar2(50) null');
end;
;
update product_repo_hist
set product_repo_hist.maturity_type = (select 'OPEN' from product_cash_hist cash where cash.product_id = product_repo_hist.money_market_id and  cash.open_term_b =1 and cash.end_date is null)
where product_repo_hist.maturity_type is null and product_repo_hist.continuous_b = 0
;
update product_repo_hist
set product_repo_hist.maturity_type = 'CONTINUOUS'
where product_repo_hist.maturity_type is null and product_repo_hist.continuous_b = 1
;
update product_repo_hist
set product_repo_hist.maturity_type = (select 'TERM' from product_cash_hist cash where cash.product_id = product_repo_hist.money_market_id and  cash.open_term_b =0)
where product_repo_hist.maturity_type is null and product_repo_hist.continuous_b = 0
;

/* CAL-201454 CAL-230862 */
UPDATE sd_filter_element SET element_name = 'Legal Agreement Type' WHERE element_name = 'LegalAgreement'
;
UPDATE sd_filter_element SET element_name = 'Legal Agreement Status' WHERE element_name = 'LegalAgreementStatus'
;

/* CAL-237368 */
DELETE FROM domain_values WHERE name = 'sdFilterCriterion' AND value = 'CA'
;

/* CAL-237131 */
declare
  x number :=0 ;
  k number :=0 ;
begin
	select count(*) into x from user_tables where table_name=upper('eligibility_rule') ;
  if x!=0 then
    execute immediate 'rename eligibility_rule to eligibility_rule_tmp3';
    execute immediate 'create table eligibility_rule
   (	rule_id number(*,0) not null , 
	rule_version numeric, 
	rule_name varchar2(255), 
	rule_static_data_giver varchar2(1024), 
	rule_static_data_taker varchar2(1024), 
	 constraint pk_eligibility_rule2 primary key (rule_id))';
    select count(*) into k from user_tab_columns where table_name=upper('eligibility_rule_tmp3');
    if k=5 then
      execute immediate 'insert into eligibility_rule select * from eligibility_rule_tmp3';  
    end if;
    execute immediate 'drop table eligibility_rule_tmp3'; 
  end if;
end;
/



UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='026',
        version_date=TO_DATE('16/01/2015','DD/MM/YYYY')
