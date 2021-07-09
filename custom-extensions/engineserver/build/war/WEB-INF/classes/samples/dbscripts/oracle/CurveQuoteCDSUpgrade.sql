/* 21435 */
/* Temporarilty added */
CREATE INDEX idx_cqv_quote   ON curve_quote_value
        (quote_name)
TABLESPACE CALYPSOIDX
;


CREATE INDEX idx_quote_val     ON quote_value
        (quote_name)
TABLESPACE CALYPSOIDX
;


DELETE FROM curve_def_data where EXISTS(Select 1 FROM  curve_quote_value WHERE 
curve_def_data.curve_id=curve_quote_value.curve_id
and 
curve_def_data.curve_date=curve_quote_value.curve_date
and 
quote_name like 'CDS.%/MODIFIED')
;


UPDATE curve_quote_value
SET quote_name =replace(quote_name,'MODIFIED','MR')
WHERE quote_name like 'CDS.%/MODIFIED'
;

UPDATE quote_value
SET quote_name =replace(quote_name,'MODIFIED','MR')
WHERE quote_name like 'CDS.%/MODIFIED'
;

UPDATE curve_underlying
SET quote_name =replace(quote_name,'MODIFIED','MR')
WHERE quote_name like 'CDS.%/MODIFIED'
;




UPDATE curve_quote_value
SET quote_name =replace(quote_name,'STANDARD','Standard')
WHERE quote_name like 'CDS.%/STANDARD'
;

UPDATE quote_value
SET quote_name =replace(quote_name,'STANDARD','Standard')
WHERE quote_name like 'CDS.%/STANDARD'
;

UPDATE curve_underlying
SET quote_name =replace(quote_name,'STANDARD','Standard')
WHERE quote_name like 'CDS.%/STANDARD'
;


DROP INDEX idx_cqv_quote   
;

DROP INDEX idx_quote_val   
;