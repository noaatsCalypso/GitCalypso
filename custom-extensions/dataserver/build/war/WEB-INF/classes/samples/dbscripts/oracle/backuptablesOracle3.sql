truncate table feed_address
;
Insert into feed_address
select * from feed_address_backup
;

DROP TABLE feed_address_backup
;