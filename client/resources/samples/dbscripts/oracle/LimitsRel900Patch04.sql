update ers_limit set limit_ccy = ' ' where not REGEXP_LIKE(limit_ccy, '[A-Z]+')
;

/* Update Patch Version info */
UPDATE ers_info
SET  patch_version='004',
patch_date = to_date('31/01/2008 12:00:00','DD/MM/YYYY HH:MI:SS')
;