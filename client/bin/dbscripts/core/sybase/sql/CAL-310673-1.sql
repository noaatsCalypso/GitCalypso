update product_seclending
set product_seclending.maturity_type = 'OPEN'
where product_seclending.maturity_type is null and product_seclending.open_term_b = 1
go
update product_seclending
set product_seclending.maturity_type = 'TERM'
where product_seclending.maturity_type is null and product_seclending.open_term_b = 0
go

update prd_seclend_hist
set prd_seclend_hist.maturity_type = 'OPEN'
where prd_seclend_hist.maturity_type is null and prd_seclend_hist.open_term_b = 1
go
update prd_seclend_hist
set prd_seclend_hist.maturity_type = 'TERM'
where prd_seclend_hist.maturity_type is null and prd_seclend_hist.open_term_b = 0
go