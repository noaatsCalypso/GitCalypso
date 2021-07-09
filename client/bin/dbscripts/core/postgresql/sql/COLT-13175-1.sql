update collateral_config set le_thresh_appl = 'IA + MTM',po_thresh_appl = 'IA + MTM' where po_thresh_appl is null and le_thresh_appl is null
;
update exposure_group_definition set le_thresh_appl = 'IA + MTM',po_thresh_appl = 'IA + MTM'  where po_thresh_appl is null and le_thresh_appl is null
;
