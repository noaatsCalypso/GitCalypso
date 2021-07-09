create table tempccy as  
(select distinct trade.trade_id  as trade_id , trade.product_id as product_id, decode(cp.pl_display_ccy,'Primary',cp.primary_currency, 'Secondary', cp.quoting_currency) as pl_ccy   
from currency_pair cp, trade t, swap_leg l, product_swap s , trade trade 
where trade.trade_id = t.trade_id and
    l.product_id =  s. product_id 
and t.product_id = s.product_id
and s.swap_type in  ('XCCySwap','SwapNonDeliverable','SwapCrossCurrency','NDS')
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
                              and l.leg_id = 1) ) ) )
;						  

merge into trade using tempccy
on (trade.trade_id=tempccy.trade_id)
when matched then update set trade.trade_currency=tempccy.pl_ccy
where trade.trade_id=tempccy.trade_id
;

merge into product_desc using tempccy
on (product_desc.product_id=tempccy.product_id)
when matched then update set product_desc.currency=tempccy.pl_ccy
where product_desc.product_id=tempccy.product_id
;

drop table tempccy
;
