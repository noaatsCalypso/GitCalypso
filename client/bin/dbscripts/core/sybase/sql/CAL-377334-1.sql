/* move official_pl_temp_id to temp table -- need to drop the table so it can be created again as temp table and to remove request_id which is not needed anymore */
if exists (select 1 from sysobjects where name='official_pl_temp_id')
begin
exec ('drop table official_pl_temp_id')
end
go