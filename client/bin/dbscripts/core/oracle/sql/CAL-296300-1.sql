update product_cap_floor set discount_method = 3 where coupon_freq = 'ZC' and discount_method = 2 
and SUBSTR(SUBSTR(rate_index,INSTR(rate_index,'/',1,1)+1, LENGTH(rate_index)),1,INSTR(SUBSTR(rate_index,INSTR(rate_index,'/',1,1)+1, LENGTH(rate_index)),'/',1,1)-1) in
(select rate_index_code from rate_index_default where index_type='Inflation')
;
