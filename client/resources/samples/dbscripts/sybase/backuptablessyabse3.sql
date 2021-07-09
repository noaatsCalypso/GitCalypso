truncate table feed_address
go
Insert into feed_address
select * from feed_address_backup
go

DROP TABLE feed_address_backup
go