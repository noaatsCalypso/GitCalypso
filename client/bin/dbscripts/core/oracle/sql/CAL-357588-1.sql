/* initialize the new original price column on all liquidations to the first trade price */
/* then update specific liquidation types, only when average price methodologies are in use */
/* for Buy/Sell (type=0) and CA REDEMPTION (type=9), set original price to the first TOQ's price (signed), as it would be when not using average price */
/* for REALIZED liquidations (type=2), first price is a constant 0 (CA CASH) or 1 (Fees) and not related to a trade or position price; it can stay as first price */
/* for the other CA types - AMORTIZATION (3), PAYDOWN (7), REFERENTIAL (8) - set original price to the first TOQ's price (unsigned), as it would be when not using average price */
update liq_position set original_price = first_price
;

declare using_avgprice integer := 0;
begin
	select count(*) into using_avgprice from liq_info where liq_method in ('TDWAC','WAC','WACSL','AvgCost','AvgPrice');
    if using_avgprice > 0 then
    begin
		update liq_position set original_price = (select
			case
				when lp2.type in (0,9) 
				then trade_open_qty.price * SIGN(trade_open_qty.quantity) 
				when lp2.type in (3,7,8) 
				then trade_open_qty.price 
			end
			from trade_open_qty, liq_position lp2
			where trade_open_qty.book_id = lp2.book_id
			and trade_open_qty.product_id = lp2.product_id
			and trade_open_qty.liq_agg_id = lp2.liq_agg_id
			and trade_open_qty.liq_config_id = lp2.liq_config_id
			and trade_open_qty.sign = lp2.first_rel_id
			and trade_open_qty.linked_id = lp2.first_linked_id
			and trade_open_qty.settle_date = lp2.first_settle_date
			and trade_open_qty.trade_id = lp2.first_trade
			and liq_position.order_id = lp2.order_id
		)
		where liq_position.type in (0,9,3,7,8);
    end;	
    end if;
end;
/