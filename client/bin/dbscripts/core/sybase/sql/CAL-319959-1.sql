/* add the columns */

/* now fill those columns we just added */

update product_subscripredemp set product_subscripredemp.settle_currency = trade.settle_currency from trade where product_subscripredemp.product_id=trade.product_id 
go

update product_contribwithdraw set product_contribwithdraw.settle_currency = trade.settle_currency from trade where product_contribwithdraw.product_id=trade.product_id
go

