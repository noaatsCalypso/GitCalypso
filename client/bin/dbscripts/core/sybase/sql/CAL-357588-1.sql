/* initialize the new original price column on all liquidations to the first trade price */
/* then update specific liquidation types, only when average price methodologies are in use */
/* for Buy/Sell (type=0) and CA REDEMPTION (type=9), set original price to the first TOQ's price (signed), as it would be when not using average price */
/* for REALIZED liquidations (type=2), first price is a constant 0 (CA CASH) or 1 (Fees) and not related to a trade or position price; it can stay as first price */
/* for the other CA types - AMORTIZATION (3), PAYDOWN (7), REFERENTIAL (8) - set original price to the first TOQ's price (unsigned), as it would be when not using average price */
update liq_position set original_price = first_price
go

if exists (select 1 from liq_info where liq_method in ('TDWAC','WAC','WACSL','AvgCost','AvgPrice'))
begin

update liq_position
set original_price = trade_open_qty.price * SIGN(trade_open_qty.quantity) from trade_open_qty
where liq_position.type in (0,9)
and trade_open_qty.book_id = liq_position.book_id 
and trade_open_qty.product_id = liq_position.product_id
and trade_open_qty.liq_agg_id = liq_position.liq_agg_id
and trade_open_qty.liq_config_id = liq_position.liq_config_id
and trade_open_qty.sign = liq_position.first_rel_id 
and trade_open_qty.linked_id = liq_position.first_linked_id
and trade_open_qty.settle_date = liq_position.first_settle_date
and trade_open_qty.trade_id = liq_position.first_trade

update liq_position
set original_price = trade_open_qty.price from trade_open_qty
where liq_position.type in (3,7,8)
and trade_open_qty.book_id = liq_position.book_id 
and trade_open_qty.product_id = liq_position.product_id
and trade_open_qty.liq_agg_id = liq_position.liq_agg_id
and trade_open_qty.liq_config_id = liq_position.liq_config_id
and trade_open_qty.sign = liq_position.first_rel_id 
and trade_open_qty.linked_id = liq_position.first_linked_id
and trade_open_qty.settle_date = liq_position.first_settle_date
and trade_open_qty.trade_id = liq_position.first_trade

end
go
