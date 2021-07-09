
delete from ers_risk_attribution where node_id = 2 and node_class = 'tk.risk.sim.ShiftItemCurveInflation' and node_value= 'Rates'
;

drop table ers_rate_archive
;

/* Update Patch Version info */
UPDATE ers_info
SET  patch_version='003',
patch_date = to_date('20/11/2007 12:00:00','DD/MM/YYYY HH:MI:SS')
;