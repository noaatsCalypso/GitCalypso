update future_contract set future_name_month = 5
where contract_id in (select distinct(l.contract_id) from product_listed l, product_future f, product_sec_code s
						where l.product_id = f.product_id and s.product_id = f.product_id and s.sec_code = 'PromptMonth')
go

update option_contract set future_name_month = 5
where contract_id in (select distinct(l.contract_id) from product_listed l, product_fut_opt f, product_sec_code s
						where l.product_id = f.product_id and s.product_id = f.product_id and s.sec_code = 'PromptMonth')
go