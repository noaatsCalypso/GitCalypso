/* 29399*/

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
quote_name like 'CDS.%/Standard')
go

UPDATE curve_quote_value SET quote_name = stuff(quote_name,charindex('Standard',quote_name),datalength('Standard'),'R')
WHERE quote_name like 'CDS.%/Standard'
go


UPDATE curve_underlying SET quote_name = stuff(quote_name,charindex('Standard',quote_name),datalength('Standard'),'R')
WHERE quote_name like 'CDS.%/Standard'
go

UPDATE quote_value SET quote_name = stuff(quote_name,charindex('Standard',quote_name),datalength('Standard'),'R')
WHERE quote_name like 'CDS.%/Standard'
go

DELETE FROM curve_def_data where EXISTS(Select 1 FROM  curve_quote_value WHERE 
curve_def_data.curve_id=curve_quote_value.curve_id
and 
curve_def_data.curve_date=curve_quote_value.curve_date
and 
quote_name like 'CDS.%/None')
go

UPDATE curve_quote_value SET quote_name = stuff(quote_name,charindex('None',quote_name),datalength('None'),'NR')
WHERE quote_name like 'CDS.%/None'
go


UPDATE curve_underlying SET quote_name = stuff(quote_name,charindex('None',quote_name),datalength('None'),'NR')
WHERE quote_name like 'CDS.%/None'
go

UPDATE quote_value SET quote_name = stuff(quote_name,charindex('None',quote_name),datalength('None'),'NR')
WHERE quote_name like 'CDS.%/None'
go

UPDATE cu_cds SET restructuring_type = 'NR' where restructuring_type = 'None'
go

DROP index curve_quote_value.idx_cqv_quote
go

DROP index quote_value.idx_quote_val
go
