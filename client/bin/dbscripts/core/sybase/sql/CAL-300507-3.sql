select trade.trade_id as trade_id , trade.product_id as product_id,case cp.pl_display_ccy 
		when 'Primary' then cp.primary_currency
		when 'Secondary' then cp.quoting_currency
end as pl_ccy  into tempccy 
from currency_pair cp, trade t, swap_leg l, product_swap s , trade trade 
where trade.trade_id = t.trade_id and
    l.product_id =  s. product_id 
and t.product_id = s.product_id
and s.swap_type in  ('XCCySwap','SwapNonDeliverable','SwapCrossCurrency')
and ( (cp.primary_currency = (select l.principal_currency from swap_leg l, product_swap s 
                              where l.product_id =  s. product_id 
                              and t.product_id = s.product_id
                              and s.swap_type in  ('XCCySwap','SwapNonDeliverable','SwapCrossCurrency','NDS')
                              and l.leg_id = 1)--pay leg
	and cp.quoting_currency = (select l.principal_currency from swap_leg l, product_swap s 
                              where l.product_id =  s. product_id
                              and t.product_id = s.product_id
                              and s.swap_type in  ('XCCySwap','SwapNonDeliverable','SwapCrossCurrency','NDS')
                              and l.leg_id = 2) )  
	or (cp.primary_currency = (select l.principal_currency from swap_leg l, product_swap s 
                              where l.product_id =  s. product_id 
                              and t.product_id = s.product_id
                              and s.swap_type in  ('XCCySwap','SwapNonDeliverable','SwapCrossCurrency','NDS')
                              and l.leg_id = 2)--rec leg
	and cp.quoting_currency = (select l.principal_currency from swap_leg l, product_swap s 
                              where l.product_id =  s. product_id
                              and t.product_id = s.product_id
                              and s.swap_type in  ('XCCySwap','SwapNonDeliverable','SwapCrossCurrency','NDS')
                              and l.leg_id = 1) ) )
go							  
alter table tempccy add ccy_id int identity not null
go
update trade set trade_currency = pl_ccy from tempccy where ccy_id=1 and trade.trade_id=tempccy.trade_id
go
update product_desc set currency = pl_ccy from tempccy where ccy_id = 1 and product_desc.product_id=tempccy.product_id
go
drop table tempccy
go
