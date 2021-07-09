add_column_if_not_exists 'bloomberg_values', 'version_num','numeric null'
GO
UPDATE bloomberg_values SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
GO

add_column_if_not_exists 'bloom_bond_map', 'version_num','numeric null'
GO
UPDATE bloom_bond_map SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
GO

add_column_if_not_exists 'bloom_daycnt_map', 'version_num','numeric null'
GO
UPDATE bloom_daycnt_map SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
GO

add_column_if_not_exists 'bloom_header_opt', 'version_num','numeric null'
GO
UPDATE bloom_header_opt SET version_num = 1 WHERE (version_num is NULL OR version_num = 0)
GO
