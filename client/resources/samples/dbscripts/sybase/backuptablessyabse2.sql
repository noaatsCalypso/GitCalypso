truncate table quote_value
go
Insert into quote_value
select * from quote_value_backup
go

DROP TABLE quote_value_backup
go