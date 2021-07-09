delete  from domain_values where name='PositionKeepingServer.engines' and value='LiquidityPositionPersistenceEngine'
go
delete  from domain_values where name='PositionKeepingServer.instances' and value='liquidityserver'
go

/* CAL-195082 CAL-231076 */
add_column_if_not_exists 'product_repo','indemnity_rate','float null'
go
add_column_if_not_exists 'product_repo_hist','indemnity_rate','float null'
go
update product_repo
set product_repo.indemnity_rate = (select product_cash.fixed_rate from product_cash where product_cash.product_id = product_repo.money_market_id)
where product_repo.product_id in (
      select distinct repo_collateral.product_id from repo_collateral, product_collateral
      where repo_collateral.collateral_id=product_collateral.product_id
      and product_collateral.pass_through_b=0)
go
update product_repo_hist
set product_repo_hist.indemnity_rate = (select product_cash_hist.fixed_rate from product_cash_hist where product_cash_hist.product_id = product_repo_hist.money_market_id)
where product_repo_hist.product_id in (
      select distinct repo_coll_hist.product_id from repo_coll_hist, prd_coll_hist
      where repo_coll_hist.collateral_id=prd_coll_hist.product_id
      and prd_coll_hist.pass_through_b=0)
go

/* CAL-189723 CAL-231268 */
add_column_if_not_exists 'product_repo','delivery_type','varchar(24) null'
go
update product_repo
set delivery_type='Default'
where delivery_type is null
go
add_column_if_not_exists 'product_repo','maturity_type','varchar(50) null'
go
update product_repo
set product_repo.maturity_type = (select 'OPEN' from product_cash cash where cash.product_id = product_repo.money_market_id and  cash.open_term_b =1 and cash.end_date is null)
where product_repo.maturity_type is null and product_repo.continuous_b = 0
go
update product_repo
set product_repo.maturity_type = 'CONTINUOUS'
where product_repo.maturity_type is null and product_repo.continuous_b = 1
go
update product_repo
set product_repo.maturity_type = (select 'TERM' from product_cash cash where cash.product_id = product_repo.money_market_id and  cash.open_term_b =0)
where product_repo.maturity_type is null and product_repo.continuous_b = 0
go

add_column_if_not_exists 'product_repo_hist','delivery_type','varchar(24) null'
go
update product_repo_hist
set delivery_type='Default'
where delivery_type is null
go
add_column_if_not_exists 'product_repo_hist','maturity_type','varchar(50) null'
go
update product_repo_hist
set product_repo_hist.maturity_type = (select 'OPEN' from product_cash_hist cash where cash.product_id = product_repo_hist.money_market_id and  cash.open_term_b =1 and cash.end_date is null)
where product_repo_hist.maturity_type is null and product_repo_hist.continuous_b = 0
go
update product_repo_hist
set product_repo_hist.maturity_type = 'CONTINUOUS'
where product_repo_hist.maturity_type is null and product_repo_hist.continuous_b = 1
go
update product_repo_hist
set product_repo_hist.maturity_type = (select 'TERM' from product_cash_hist cash where cash.product_id = product_repo_hist.money_market_id and  cash.open_term_b =0)
where product_repo_hist.maturity_type is null and product_repo_hist.continuous_b = 0
go

/* CAL-201454 CAL-230862 */
UPDATE sd_filter_element SET element_name = 'Legal Agreement Type' WHERE element_name = 'LegalAgreement'
go
UPDATE sd_filter_element SET element_name = 'Legal Agreement Status' WHERE element_name = 'LegalAgreementStatus'
go

/* CAL-237368 */
DELETE FROM domain_values WHERE name = 'sdFilterCriterion' AND value = 'CA'
go

/* CAL-237131 */
ALTER TABLE eligibility_rule MODIFY rule_version numeric NOT NULL
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='026',
        version_date='20150116'
go
