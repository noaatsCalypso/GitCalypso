update margin_trade_vm 
set po= b.legal_entity_id 
from book b,  trade tr , margin_trade_vm v 
where  tr.trade_id = convert(numeric,v.trade_id)
  and tr.book_id = b.book_id
go