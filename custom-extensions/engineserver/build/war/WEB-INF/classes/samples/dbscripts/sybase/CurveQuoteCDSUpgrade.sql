/* 21435 */
/* Temporarilty added */
CREATE NONCLUSTERED INDEX idx_cqv_quote  ON curve_quote_value
 (quote_name)
go

CREATE NONCLUSTERED INDEX idx_quote_val  ON quote_value
 (quote_name)
go



DELETE FROM curve_def_data where EXISTS(Select 1 FROM  curve_quote_value WHERE 
curve_def_data.curve_id=curve_quote_value.curve_id
and 
curve_def_data.curve_date=curve_quote_value.curve_date
and 
quote_name like 'CDS.%/MODIFIED')
go



DELETE FROM curve_def_data where EXISTS(Select 1 FROM  curve_quote_value WHERE 
curve_def_data.curve_id=curve_quote_value.curve_id
and 
curve_def_data.curve_date=curve_quote_value.curve_date
and 
quote_name like 'CDS.%/STANDARD')


UPDATE curve_quote_value
SET quote_name =stuff(quote_name,charindex('MODIFIED',quote_name),datalength('MODIFIED'),'MR')
WHERE quote_name like 'CDS.%/MODIFIED'
go


UPDATE quote_value
SET quote_name =stuff(quote_name,charindex('MODIFIED',quote_name),datalength('MODIFIED'),'MR')
WHERE quote_name like 'CDS.%/MODIFIED'
go

UPDATE curve_underlying
SET quote_name =stuff(quote_name,charindex('MODIFIED',quote_name),datalength('MODIFIED'),'MR')
WHERE quote_name like 'CDS.%/MODIFIED'
go


UPDATE curve_quote_value
SET quote_name =stuff(quote_name,charindex('STANDARD',quote_name),datalength('STANDARD'),'Standard')
WHERE quote_name like 'CDS.%/STANDARD'
go

UPDATE quote_value
SET quote_name =stuff(quote_name,charindex('STANDARD',quote_name),datalength('STANDARD'),'Standard')
WHERE quote_name like 'CDS.%/STANDARD'
go


UPDATE curve_underlying
SET quote_name =stuff(quote_name,charindex('STANDARD',quote_name),datalength('STANDARD'),'Standard')
WHERE quote_name like 'CDS.%/STANDARD'
go

DROP index curve_quote_value.idx_cqv_quote
go

DROP index quote_value.idx_quote_val
go















































