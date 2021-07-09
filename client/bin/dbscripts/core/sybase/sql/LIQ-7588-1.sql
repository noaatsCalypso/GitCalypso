/* LIQ-7588 : Readding the delete script since there was a regression issue with subsequent versions in liquidity modules */
delete from domain_values where name = 'scheduledTask' and value = 'GEN_FUNDING_FTP_ACCRUALS'
go