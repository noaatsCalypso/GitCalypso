truncate table quote_value
;
Insert into quote_value
select * from quote_value_backup
;

DROP TABLE quote_value_backup
;