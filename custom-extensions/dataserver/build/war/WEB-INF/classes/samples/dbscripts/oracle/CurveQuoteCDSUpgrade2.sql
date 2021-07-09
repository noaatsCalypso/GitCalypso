/* 29399 */

CREATE INDEX idx_cqv_quote   ON curve_quote_value
        (quote_name)
TABLESPACE CALYPSOIDX
;

CREATE INDEX idx_quote_val     ON quote_value
        (quote_name)
TABLESPACE CALYPSOIDX
;


DELETE FROM curve_def_data where EXISTS(Select 1 FROM  curve_quote_value WHERE curve_def_data.curve_id=curve_quote_value.curve_id
and 
curve_def_data.curve_date=curve_quote_value.curve_date
and 
quote_name like 'CDS.%/Standard')
;


UPDATE curve_quote_value
SET quote_name =replace(quote_name,'Standard','R')
WHERE quote_name like 'CDS.%/Standard'
;

UPDATE quote_value
SET quote_name =replace(quote_name,'Standard','R')
WHERE quote_name like 'CDS.%/Standard'
;

UPDATE curve_underlying
SET quote_name =replace(quote_name,'Standard','R')
WHERE quote_name like 'CDS.%/Standard'
;

DELETE FROM curve_def_data where EXISTS(Select 1 FROM  curve_quote_value WHERE curve_def_data.curve_id=curve_quote_value.curve_id
and 
curve_def_data.curve_date=curve_quote_value.curve_date
and 
quote_name like 'CDS.%/None')
;


UPDATE curve_quote_value
SET quote_name =replace(quote_name,'None','NR')
WHERE quote_name like 'CDS.%/None'
;

UPDATE quote_value
SET quote_name =replace(quote_name,'None','NR')
WHERE quote_name like 'CDS.%/None'
;

UPDATE curve_underlying
SET quote_name =replace(quote_name,'None','NR')
WHERE quote_name like 'CDS.%/None'
;

UPDATE cu_cds SET restructuring_type = 'NR' where restructuring_type = 'None'
;
DROP INDEX idx_cqv_quote   
;

DROP INDEX idx_quote_val   
;
