update product_desc set product_type='SwapCrossCurrency' where product_id in
(select  distinct t.product_id from
(select distinct product_swap.product_id, product_swap.swap_type,
swap_leg.principal_currency
FROM product_swap ,swap_leg
where product_swap.product_id = swap_leg.product_id
and product_swap.swap_type = 'Swap') t, swap_leg sl
where t.product_id=sl.product_id
and t.principal_currency != sl.principal_currency)
and product_desc .product_type = 'Swap'
and product_desc .product_type != 'NDS'
and product_desc .product_type != 'SwapNonDeliverable'
go
	
update product_swap set swap_type='SwapCrossCurrency' where product_id in
(select  distinct t.product_id from
(select distinct product_swap.product_id, product_swap.swap_type,
swap_leg.principal_currency
FROM product_swap ,swap_leg
where product_swap.product_id = swap_leg.product_id
and product_swap.swap_type = 'Swap') t, swap_leg sl
where t.product_id=sl.product_id
and t.principal_currency != sl.principal_currency)
and product_swap.swap_type='Swap'
and product_swap.swap_type != 'NDS'
and product_swap.swap_type != 'SwapNonDeliverable'
go