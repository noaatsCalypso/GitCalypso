alter table calypso_cache rename column cache_limit to cache_limit_bck
/
alter table calypso_cache rename column limit to cache_limit
/
alter table calypso_cache drop column cache_limit_bck
;
begin
drop_table_if_exists ('tf_temp_table');
end;
/
 