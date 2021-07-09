insert into user_layout_data (data_name, data_key, data_user, data_version, data_list, data_layout)
select data_name, data_key, '@@ALL@@',data_version, data_list, data_layout from user_layout_data where data_name = '@@ColumnsSetsUI@@' and data_key = '@@PWSConfig@@' 
and not EXISTS(select * from user_layout_data where data_name = '@@ColumnsSetsUI@@' and data_key = '@@PWSConfig@@' and data_user = '@@ALL@@') order by data_version desc limit 1
;