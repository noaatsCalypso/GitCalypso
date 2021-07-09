create table temp_trade_keyword (trade_id numeric not null, keyword_name varchar(128) not null, keyword_value varchar(255))

go

create table temp_trade(trade_id numeric not null, product_id numeric not null)

go

insert into temp_trade_keyword
select trade_id,keyword_name,keyword_value
from trade_keyword
where
trade_keyword.keyword_name in('InstrumentCFI','InstrumentISIN','InstrumentFullName')

go

insert into temp_trade
select temp_trade_keyword.trade_id,trade.product_id
from temp_trade_keyword,trade
where
temp_trade_keyword.trade_id = trade.trade_id

go


insert into product_sec_code
select temp_trade.product_id,'CFI',temp_trade_keyword.keyword_value,UPPER(temp_trade_keyword.keyword_value)
from temp_trade,temp_trade_keyword
where
temp_trade.trade_id=temp_trade_keyword.trade_id
and temp_trade_keyword.keyword_name in('InstrumentCFI')

go

insert into product_sec_code
select temp_trade.product_id,'ISIN',temp_trade_keyword.keyword_value,UPPER(temp_trade_keyword.keyword_value)
from temp_trade,temp_trade_keyword
where
temp_trade.trade_id=temp_trade_keyword.trade_id
and temp_trade_keyword.keyword_name in('InstrumentISIN')

go

insert into product_sec_code
select temp_trade.product_id,'FullName',temp_trade_keyword.keyword_value,UPPER(temp_trade_keyword.keyword_value)
from temp_trade,temp_trade_keyword
where
temp_trade.trade_id=temp_trade_keyword.trade_id
and temp_trade_keyword.keyword_name in('InstrumentFullName')

go

drop table temp_trade

go

drop table temp_trade_keyword

go