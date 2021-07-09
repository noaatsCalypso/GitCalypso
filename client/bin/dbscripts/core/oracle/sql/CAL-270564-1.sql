begin
add_column_if_not_exists ('bloomberg_values', 'version_num','number null');
end;
/
UPDATE bloomberg_values SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
;

begin
add_column_if_not_exists ('bloom_bond_map', 'version_num','number null');
end;
/
UPDATE bloom_bond_map SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
;

begin
add_column_if_not_exists ('bloom_daycnt_map', 'version_num','number null');
end;
/
UPDATE bloom_daycnt_map SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
;

begin
add_column_if_not_exists ('bloom_header_opt', 'version_num','number null');
end;
/
UPDATE bloom_header_opt SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
;
