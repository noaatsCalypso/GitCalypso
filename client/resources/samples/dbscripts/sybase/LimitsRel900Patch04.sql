update ers_limit set limit_ccy = ' ' where limit_ccy not like '[A-Z]%'
go

/* Update Patch Version */
UPDATE ers_info
SET  patch_version='004',
patch_date = '20080131'
GO     
