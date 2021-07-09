create table temp_trade_keyword (trade_id number(22) not null, keyword_name varchar2(128) not null, keyword_value varchar2(255))
;

create table temp_trade(trade_id number(22) not null, product_id number(22) not null)
;

insert into temp_trade_keyword
select trade_id,keyword_name,keyword_value
from trade_keyword
where
trade_keyword.keyword_name in('InstrumentCFI','InstrumentISIN','InstrumentFullName')
;

insert into temp_trade
select temp_trade_keyword.trade_id,trade.product_id
from temp_trade_keyword,trade
where
temp_trade_keyword.trade_id = trade.trade_id
;


insert into product_sec_code
select temp_trade.product_id,'CFI',temp_trade_keyword.keyword_value,UPPER(temp_trade_keyword.keyword_value)
from temp_trade,temp_trade_keyword
where
temp_trade.trade_id=temp_trade_keyword.trade_id
and temp_trade_keyword.keyword_name in('InstrumentCFI')
;
insert into product_sec_code
select temp_trade.product_id,'ISIN',temp_trade_keyword.keyword_value,UPPER(temp_trade_keyword.keyword_value)
from temp_trade,temp_trade_keyword
where
temp_trade.trade_id=temp_trade_keyword.trade_id
and temp_trade_keyword.keyword_name in('InstrumentISIN')
;
insert into product_sec_code
select temp_trade.product_id,'FullName',temp_trade_keyword.keyword_value,UPPER(temp_trade_keyword.keyword_value)
from temp_trade,temp_trade_keyword
where
temp_trade.trade_id=temp_trade_keyword.trade_id
and temp_trade_keyword.keyword_name in('InstrumentFullName')
;

drop table temp_trade
;

drop table temp_trade_keyword
;