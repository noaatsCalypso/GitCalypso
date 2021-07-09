/* move official_pl_temp_id to temp table -- need to drop the table so it can be created again as temp table and to remove request_id which is not needed anymore */
begin 
drop_table_if_exists('official_pl_temp_id');
end;
/
