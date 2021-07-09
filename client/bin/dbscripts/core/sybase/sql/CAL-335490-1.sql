 -- update criterion for account property 
update sd_filter_domain set element_name = 'Account Name' where element_name = 'GL Account'
go
update sd_filter_domain set element_name = 'Account Status' where element_name = 'GL Account Status'
go