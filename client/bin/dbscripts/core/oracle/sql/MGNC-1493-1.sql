MERGE
INTO    margin_trade_vm v
USING   (
        SELECT DISTINCT tr.trade_id AS trade_id, b.legal_entity_id
            FROM book b, trade tr, margin_trade_vm v
            WHERE v.trade_id = tr.trade_id
            AND tr.book_id = b. book_id
        ) src
ON      (v.trade_id = src.trade_id)
WHEN MATCHED THEN UPDATE
    SET v.po = legal_entity_id
    where v.po = 0
;
