 -- update criterion for Legal Agreement Type and Status properties  
UPDATE sd_filter_domain SET element_name = 'Legal Agreement Type' WHERE element_name = 'LegalAgreement'
go
UPDATE sd_filter_domain SET element_name = 'Legal Agreement Status' WHERE element_name = 'LegalAgreementStatus'
go
