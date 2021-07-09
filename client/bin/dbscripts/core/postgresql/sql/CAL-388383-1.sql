INSERT INTO trade_keyword (trade_id, keyword_name, keyword_value)
SELECT trade.trade_id, 'OriginalMaturityType', repo.maturity_type FROM  trade, product_repo repo
WHERE trade.product_id = repo.product_id 
AND trade.trade_id NOT IN (
        SELECT trade_keyword.trade_id FROM trade_keyword WHERE trade_keyword.keyword_name='OriginalMaturityType'
    )
AND repo.maturity_type IN ('TERM', 'OPEN')
;
 
INSERT INTO trade_keyword (trade_id, keyword_name, keyword_value)
SELECT trade.trade_id, 'OriginalMaturityType', seclending.maturity_type FROM  trade, product_seclending seclending
WHERE trade.product_id = seclending.product_id 
AND trade.trade_id NOT IN (
        SELECT trade_keyword.trade_id FROM trade_keyword WHERE trade_keyword.keyword_name='OriginalMaturityType'
    )
AND seclending.maturity_type IN ('TERM', 'OPEN')
;

INSERT INTO trade_keyword (trade_id, keyword_name, keyword_value)
SELECT trade.trade_id, 'OriginalNoticeDays', cash.notice_days FROM trade, product_repo repo, product_cash cash
WHERE trade.product_id = repo.product_id 
AND repo.money_market_id = cash.product_id
AND trade.trade_id NOT IN (
        SELECT trade_keyword.trade_id FROM trade_keyword WHERE trade_keyword.keyword_name='OriginalNoticeDays'
    )
AND repo.maturity_type IN ('TERM', 'OPEN')
;
 
INSERT INTO trade_keyword (trade_id, keyword_name, keyword_value)
SELECT trade.trade_id, 'OriginalNoticeDays', seclending.notice_days FROM  trade, product_seclending seclending
WHERE trade.product_id = seclending.product_id 
AND trade.trade_id NOT IN (
        SELECT trade_keyword.trade_id FROM trade_keyword WHERE trade_keyword.keyword_name='OriginalNoticeDays'
    )
AND seclending.maturity_type IN ('TERM', 'OPEN')
;
