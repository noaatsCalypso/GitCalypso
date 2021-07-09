update margin_trade_vm
set po= b.legal_entity_id
from book b,  trade tr , margin_trade_vm v 
where  tr.trade_id = cast(v.trade_id as NUMERIC) 
  and tr.book_id = b.book_id
;