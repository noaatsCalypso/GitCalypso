/* LIQ-7520 : Deprecate Trading book FTP */
delete from domain_values where name = 'FtpCostComponentNames' and value in ( 'SECURITIZED_FUNDING_INTEREST_COST' , 
'SECURITIZED_FUNDING_SECURITY_SWEEP_COST' , 'SECURITIZED_FUNDING_CASH_SWEEP_COST' , 'OVERNIGHT_CASH_SWEEP_COST' , 'OVERNIGHT_CASH_INTEREST_COST' )
;
delete from domain_values where name = 'scheduledTask' and value = 'GEN_FUNDING_FTP_ACCRUALS'
;