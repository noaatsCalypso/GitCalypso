CREATE OR REPLACE FUNCTION SP_USING_AVGPRICE
()
RETURNS void LANGUAGE plpgsql
AS $BODY$
declare
    using_avgprice integer;
BEGIN        
    update liq_position set original_price = first_price;
    
    SELECT count(*) INTO using_avgprice FROM liq_info where liq_method in ('TDWAC','WAC','WACSL','AvgCost','AvgPrice');
    
    IF using_avgprice > 0 THEN
      
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
        and trade_open_qty.trade_id = liq_position.first_trade;

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
        and trade_open_qty.trade_id = liq_position.first_trade;
        
  END IF; 
END;                                                                                                                                                                                                                                                                                                                                        
$BODY$
;

DO $$ begin
    perform SP_USING_AVGPRICE();
end$$;


drop function SP_USING_AVGPRICE()
;