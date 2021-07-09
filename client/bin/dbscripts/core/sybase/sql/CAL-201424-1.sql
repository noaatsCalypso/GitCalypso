Update product_desc set product_sub_type=exercise_type from product_call_info where 
product_desc.product_id=product_call_info.product_id 
		AND 
		product_call_info.call_type='Cancellable' 
		AND 
		product_desc.product_extended_type=product_call_info.call_type 
		AND 
		product_desc.product_type='Swap' 
		AND 
		product_desc.product_sub_type='Standard'
go

add_domain_values 'Swap.subtype','American',' '
go
add_domain_values 'Swap.subtype','Bermudan',' ' 
go
add_domain_values'Swap.subtype','European',' ' 
go