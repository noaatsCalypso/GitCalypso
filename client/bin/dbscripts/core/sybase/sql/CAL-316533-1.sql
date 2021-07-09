select * into temp_trd1 from trade_role_alloc 
where trade_id in (select t.trade_id from trade t,product_desc p 
where t.product_id=p.product_id and p.product_family='FX')
go
 
select ta.rel_trade_id,ta.trade_id,ta.amount ,ta.sec_amount into temp_trd2  from trade_keyword tk ,temp_trd1 ta 
where tk.keyword_name = 'NegotiatedCurrency' and tk.keyword_value = ta.settle_ccy and ta.trade_id=tk.trade_id
go

/* switch between amount & sec_amount */

UPDATE trade_role_alloc 
set  trade_role_alloc.amount= temp_trd2.sec_amount from temp_trd2 where trade_role_alloc.trade_id=temp_trd2.trade_id and trade_role_alloc.rel_trade_id=temp_trd2.rel_trade_id
go

UPDATE trade_role_alloc  
set trade_role_alloc.sec_amount= temp_trd2.amount from temp_trd2 where trade_role_alloc.trade_id=temp_trd2.trade_id and trade_role_alloc.rel_trade_id=temp_trd2.rel_trade_id
go

drop table temp_trd1
go
drop table temp_trd2
go