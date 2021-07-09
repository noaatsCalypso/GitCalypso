update product_cap_floor set discount_method = 3 where coupon_freq = 'ZC' and discount_method = 2 and 
substring(substring(rate_index,charindex('/',rate_index)+1,len(rate_index)),1,charindex('/',substring(rate_index,charindex('/',rate_index)+1,len(rate_index)))-1) 
in (select rate_index_code from rate_index_default where index_type='Inflation')
go

