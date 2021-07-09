insert into quote_value (quote_set_name, quote_name, quote_date, bid, ask, open_quote, close_quote, 
quote_type, entered_datetime, version_num, entered_user, high, low,estimated_b, last_quote, known_date,
source_name)
Select qv.quote_set_name,'Inflation.'||rid.currency_code||'.'||rid.rate_index_code, 
qv.quote_date, qv.bid, qv.ask, qv.open_quote, qv.close_quote, qv.quote_type, qv.entered_datetime, 
qv.version_num, qv.entered_user, qv.high, qv.low,qv.estimated_b, qv.last_quote, qv.known_date,
qv.source_name
from quote_value qv, rate_index_default rid
where 
qv.quote_name like  'Inflation.%.%.%'
and qv.quote_name like 'Inflation.'||rid.currency_code||'.'||rid.rate_index_code||'.%'
and not Exists
(select 1
from quote_value qv3,  quote_value qv2
where
qv2.quote_name like 'Inflation.%.%.%'
and qv3.quote_name like 'Inflation.'||rid.currency_code||'.'||rid.rate_index_code||'.%'
and qv2.quote_name like 'Inflation.'||rid.currency_code||'.'||rid.rate_index_code||'.%'
and qv2.quote_name != qv3.quote_name
and qv2.quote_date  = qv3.quote_date
and qv2.quote_name = qv.quote_name
and qv2.quote_date  = qv.quote_date)
;