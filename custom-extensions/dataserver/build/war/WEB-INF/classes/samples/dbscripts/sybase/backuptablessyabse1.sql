truncate table vol_surf_und
go
Insert into vol_surf_und
select * from vol_surf_und_BACKUP
go

truncate table vol_surf_qtvalue
go
Insert into vol_surf_qtvalue
select * from vol_surf_qtvalue_BACKUP
go

truncate table vol_quote_adj
go
Insert into vol_quote_adj
select * from vol_quote_adj_BACKUP
go

DROP TABLE vol_surf_und_BACKUP
go

DROP TABLE vol_surf_qtvalue_BACKUP
go

DROP TABLE vol_quote_adj_BACKUP
go

DROP TABLE t1
go