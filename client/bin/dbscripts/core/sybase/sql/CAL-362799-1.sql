update product_seclending set maturity_type = 'TERM' where maturity_type is null and open_term_b = 0
update product_seclending set maturity_type = 'OPEN' where maturity_type is null and open_term_b = 1
go