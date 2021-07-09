update swap_leg set settle_holidays_b=0 where swap_leg.product_id = (select product_structured_flows.product_id 
from product_structured_flows 
where swap_leg.product_id = product_structured_flows.product_id 
and swap_leg.coupon_holidays=swap_leg.settle_holidays and swap_leg.settle_holidays_b <> 0)
;
