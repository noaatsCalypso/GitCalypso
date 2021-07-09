create table temp_trade_keyword as (  
select t1.trade_id, t1.keyword_value from(select tk1.trade_id,tk1.keyword_value from trade_keyword tk1 where tk1.keyword_name ='TransferDate') t1,
(select tk1.trade_id,tk1.keyword_value from trade_keyword tk1 where tk1.keyword_name ='TransferType' and keyword_value='PartialTermination') t2
where t1.trade_id=t2.trade_id )
; 

insert into product_sec_code (product_id,sec_code,code_value,code_value_ucase) 
select ps.product_id,'PAY_TerminationDate',tk.keyword_value,tk.keyword_value 
from product_swap ps,trade tr,temp_trade_keyword tk
where tr.product_id = ps.product_id and 
tr.trade_id =tk.trade_id
;

insert into product_sec_code (product_id,sec_code,code_value,code_value_ucase) 
select ps.product_id,'REC_TerminationDate',tk.keyword_value,tk.keyword_value 
from product_swap ps,trade tr,temp_trade_keyword tk
where tr.product_id = ps.product_id and 
tr.trade_id =tk.trade_id
;

drop table temp_trade_keyword
;