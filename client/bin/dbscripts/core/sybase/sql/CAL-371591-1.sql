/*
CAL-371591
Sets pl methodology to 'transfer' only for SimpleTransfer products if it was 'CASH_PL' or was changed to 'AmortizedCost'
because of script provided for CAL-305182.
*/ 
UPDATE pl_methodology_config_items
SET methodology_name = 'Transfer' 
WHERE product_type = 'SimpleTransfer' 
AND (methodology_name = 'CASH_PL' OR methodology_name = 'AmortizedCost')
go

UPDATE official_pl_mark
SET methodology = 'Transfer'
WHERE effective_product_type = 'SimpleTransfer' 
AND (methodology = 'CASH_PL' OR methodology = 'AmortizedCost')
go

UPDATE official_pl_mark_hist
SET methodology = 'Transfer'
WHERE effective_product_type = 'SimpleTransfer' 
AND (methodology = 'CASH_PL' OR methodology = 'AmortizedCost')
go

UPDATE official_pl_aggregate_item
SET methodology = 'Transfer'
WHERE effective_product_type = 'SimpleTransfer' 
AND (methodology = 'CASH_PL' OR methodology = 'AmortizedCost')
go
