update collateral_config set LE_THRESH_APPL = 'IA + MTM',PO_THRESH_APPL = 'IA + MTM' where PO_THRESH_APPL is null and LE_THRESH_APPL is null
;
update exposure_group_definition set LE_THRESH_APPL = 'IA + MTM',PO_THRESH_APPL = 'IA + MTM' where PO_THRESH_APPL is null and LE_THRESH_APPL is null
;