/* CAL-386180 : Reserved keyword should be renamed */
call rename_column_if_exists ('product_ftp', 'is_mirror','is_mirror_bak')
;
call rename_column_if_exists ('product_ftp', 'mirror','is_mirror')
;