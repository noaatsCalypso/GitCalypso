/*
CAL-371591
Sets pl methodology to 'transfer' only for SimpleTransfer products if it was 'CASH_PL' or was changed to 'AmortizedCost'
because of script provided for CAL-305182.
*/ 
UPDATE pl_methodology_config_items m
SET m.methodology_name = 'Transfer' 
WHERE m.product_type = 'SimpleTransfer' 
AND (m.methodology_name = 'CASH_PL' OR m.methodology_name = 'AmortizedCost')
;

UPDATE official_pl_mark m 
SET m.methodology = 'Transfer'
WHERE m.effective_product_type = 'SimpleTransfer' 
AND (m.methodology = 'CASH_PL' OR m.methodology = 'AmortizedCost')
;

UPDATE official_pl_mark_hist m 
SET m.methodology = 'Transfer'
WHERE m.effective_product_type = 'SimpleTransfer' 
AND (m.methodology = 'CASH_PL' OR m.methodology = 'AmortizedCost')
;

UPDATE official_pl_aggregate_item m 
SET m.methodology = 'Transfer'
WHERE m.effective_product_type = 'SimpleTransfer' 
AND (m.methodology = 'CASH_PL' OR m.methodology = 'AmortizedCost')
;
