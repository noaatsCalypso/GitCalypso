begin
rename_column_if_exists ('allocation','bm_offset','bm_offset_bck');
end;
/
begin
rename_column_if_exists ('allocation','offset','bm_offset');
end;
/ 
 
begin
rename_column_if_exists ('benchmark_comp_record_item','bm_offset','bm_offset_bck');
end;
/
 
begin
rename_column_if_exists ('benchmark_comp_record_item','offset','bm_offset');
end;
/

begin 
drop_column_if_exists  ('allocation','bm_offset_bck');
end;
/
begin 
drop_column_if_exists  ('benchmark_comp_record_item','bm_offset_bck');
end;
/
 