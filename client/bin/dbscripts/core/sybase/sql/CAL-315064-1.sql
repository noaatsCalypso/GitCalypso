UPDATE swap_leg SET sample_timing = 'BEG_PER' WHERE sample_timing = 'END_PER' AND reset_averaging_b = 1 
AND swap_leg.product_id in (select product_id from product_desc where product_desc.product_type = 'Advance')
go