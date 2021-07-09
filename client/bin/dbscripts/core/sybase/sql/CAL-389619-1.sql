/* CAL-386180 : Reserved keyword should be renamed */
exec rename_column_if_exists 'product_ftp', 'is_mirror','is_mirror_bak'
go
exec rename_column_if_exists 'product_ftp', 'mirror','is_mirror'
go