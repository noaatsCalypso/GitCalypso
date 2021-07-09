insert 
into
product_sec_code
( product_id,
  sec_code,
  code_value,
  code_value_ucase
) 
select
ps.product_id,
'SWAPLEG_TerminationDate',
tk.keyword_value,
tk.keyword_value
from 
product_structured_flows ps,
trade tr,
( 
 select 
 tk1.trade_id,
 tk1.keyword_value
 from 
 trade_keyword tk1
 where 
 tk1.keyword_name = 'TransferDate' 
 and tk1.trade_id
 in
   (
     select
 	 trade_id
	 from 
	 trade_keyword
	 where keyword_name = 'TransferType' 
	 and keyword_value='PartialTermination'
	)
) tk 
where
tr.product_id = ps.product_id
and 
tr.trade_id =tk.trade_id
;