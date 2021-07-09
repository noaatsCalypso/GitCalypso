update product_swap set opt_cal_offset =(select settlement_lag from product_call_info where product_call_info.product_id = product_swap.product_id)
;
update product_swap set opt_cal_bus_b =(select settlement_lag_bus_day_b from product_call_info where product_call_info.product_id = product_swap.product_id)
;