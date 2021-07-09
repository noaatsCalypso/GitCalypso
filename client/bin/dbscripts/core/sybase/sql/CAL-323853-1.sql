-- Change copied inactive mark adj_status to 'Not Adjusted' so we dont look for adjustment info and throw exception.
UPDATE  official_pl_mark SET adj_status = 'Not Adjusted' WHERE (pl_type = 'Inactive' OR pl_type = 'Inactive Trade') AND adj_status = 'Adjusted' AND mark_id NOT IN 
(SELECT mark_id FROM official_plmark_adj )
go

