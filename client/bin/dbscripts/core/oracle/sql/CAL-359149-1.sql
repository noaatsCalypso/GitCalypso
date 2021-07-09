update product_desc set product_sub_type ='Standard' where product_id in (select tlock.product_id from product_tlock tlock,product_bond bond where tlock.ref_product_id = bond.product_id and bond.notional_index is null)
;

update product_desc set product_sub_type ='Inflation' where product_id in (select tlock.product_id from product_tlock tlock,product_bond bond where tlock.ref_product_id = bond.product_id and bond.notional_index is not null)
;