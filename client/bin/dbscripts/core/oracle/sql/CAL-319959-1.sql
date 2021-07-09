/* now fill those columns we just added */

update product_subscripredemp p set settle_currency = (select settle_currency from trade where product_id=p.product_id) 
;

update product_contribwithdraw p set settle_currency = (select settle_currency from trade where product_id=p.product_id) 
;

