update product_cap_floor set cmp_with_spread ='NoCompound' where cmp_with_spread is null
go

update product_cap_floor set compound_freq ='NON' where compound_freq is null
go