UPDATE swap_leg SET settle_holidays_b = 0 FROM product_structured_flows 
WHERE swap_leg.product_id=product_structured_flows.product_id
AND swap_leg.coupon_holidays=swap_leg.settle_holidays AND swap_leg.settle_holidays_b <> 0
GO