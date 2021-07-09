update trade set quantity=1 where trade.product_id = (select product_swap.product_id 
from product_swap 
where trade.product_id = product_swap.product_id and 
trade.quantity=-1 
and product_swap.swap_type in ('Swap','NDS','SwapNonDeliverable','SwapCrossCurrency','XCCySwap'))
;
