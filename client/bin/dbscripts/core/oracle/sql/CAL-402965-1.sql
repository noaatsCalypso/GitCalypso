insert into user_layout_data (data_name, data_key, data_user, data_version, data_list, data_layout)
select data_name, data_key, '@@ALL@@' as data_user,data_version, data_list, data_layout from 
(select * from user_layout_data where data_name = '@@ColumnsSetsUI@@' and data_key = '@@PWSConfig@@' order by data_version desc) 
where not EXISTS(select * from user_layout_data where data_name = '@@ColumnsSetsUI@@' and data_key = '@@PWSConfig@@' and data_user = '@@ALL@@') and ROWNUM <=1
;