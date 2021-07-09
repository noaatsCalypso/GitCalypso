truncate table vol_surf_und
;
Insert into vol_surf_und
select * from vol_surf_und_BACKUP
;

truncate table vol_surf_qtvalue
;
Insert into vol_surf_qtvalue
select * from vol_surf_qtvalue_BACKUP
;

truncate table vol_quote_adj
;
Insert into vol_quote_adj
select * from vol_quote_adj_BACKUP
;

DROP TABLE vol_surf_und_BACKUP
;

DROP TABLE vol_surf_qtvalue_BACKUP
;

DROP TABLE vol_quote_adj_BACKUP
;

DROP TABLE t1
;