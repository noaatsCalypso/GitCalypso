update collateral_config set po_thresh_appl = 'IA + MTM', le_thresh_appl = 'IA + MTM'  where po_thresh_appl is null and le_thresh_appl is null
go
update exposure_group_definition set le_thresh_appl = 'IA + MTM',po_thresh_appl = 'IA + MTM' where po_thresh_appl is null and le_thresh_appl is null
go
