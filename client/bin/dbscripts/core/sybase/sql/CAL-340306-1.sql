update trade_open_qty set is_liquidable = -1 where quantity=0 and price=0 and is_liquidable <> -1
and EXISTS (select trade.trade_id from trade where trade.trade_status = 'CANCELED' and trade.trade_id = trade_open_qty.trade_id)
go