
alter table ers_batch drop constraint UNIQ_ers_batch
;
alter table ers_rate_archive drop constraint uniq_ersratearchive
;
alter table ers_run_history drop constraint uniq_ers_runhist
;
alter table ers_scenario drop constraint uniq_ersscenario
;
alter table ers_risk_attribution drop constraint uniq_ersriskattr
;

/* Update Patch Version */
UPDATE ers_info
SET  patch_version='002',
patch_date = to_date('30/08/2007 12:00:00','DD/MM/YYYY HH:MI:SS')
;     
