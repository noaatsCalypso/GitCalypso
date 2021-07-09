update product_desc set product_sub_type ='Standard' from product_tlock tlock, product_bond bond where tlock.ref_product_id = bond.product_id and bond.notional_index is null
go

update product_desc set product_sub_type ='Inflation' from product_tlock tlock, product_bond bond where tlock.ref_product_id = bond.product_id and bond.notional_index is not null
go