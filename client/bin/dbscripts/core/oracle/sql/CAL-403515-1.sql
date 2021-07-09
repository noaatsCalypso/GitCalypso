update portfolio_swap_contract_fund set sample_timing = 'BEG_PER', reset_timing = 'END_PER' where id in (select funding_leg_id from portfolio_swap_contract) and reset_freq = 'DLY'
;
update portfolio_swap_contract_fund set compound_b = 0 where id in (select funding_leg_id from portfolio_swap_contract) and (reset_freq = 'DLY' or reset_freq = 'NON')
;
update portfolio_swap_contract_fund set cmp_with_spread = 'NO_COMPOUND' where id in (select funding_leg_id from portfolio_swap_contract)
;
update portfolio_swap_contract_fund ps set (ps.rounding_method, ps.rounding_decimals) = (select currency_default.rounding_method, currency_default.rate_decimals from portfolio_swap_contract, portfolio_swap_contract_fund, currency_default where portfolio_swap_contract_fund.id = portfolio_swap_contract.funding_leg_id and currency_default.currency_code = portfolio_swap_contract.settlement_curr and portfolio_swap_contract_fund.id = ps.id)
;
