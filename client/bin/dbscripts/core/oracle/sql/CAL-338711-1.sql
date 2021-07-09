delete trade_open_qty where is_liquidable = -1 and exists 
(select 1 from trade where trade.trade_id = trade_open_qty.trade_id and trade.trade_status <> 'CANCELED')
;
