-- Change copied inactive mark adj_status to 'Not Adjusted' so we dont look for adjustment info and throw exception.
UPDATE /*+ parallel(8) */ official_pl_mark m
SET    m.adj_status = 'Not Adjusted'
WHERE (m.pl_type = 'Inactive' OR m.pl_type = 'Inactive Trade')
AND m.adj_status = 'Adjusted' 
AND m.mark_id NOT IN (SELECT a.mark_id FROM official_plmark_adj a)
;

