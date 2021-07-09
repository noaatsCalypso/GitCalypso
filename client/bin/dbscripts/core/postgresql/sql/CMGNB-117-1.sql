insert into group_access (group_name, access_id, access_value, read_only_b)
select group_name, access_id, 'CORE_SERVICE_USERRole', read_only_b from group_access where access_value = 'MARGIN_USERRole'
and group_name not in (select group_name from group_access where access_value = 'CORE_SERVICE_USERRole')
;
