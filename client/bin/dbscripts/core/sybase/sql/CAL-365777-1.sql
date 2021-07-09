exec rename_column_if_exists 'product_cap_floor','strike_limit','strike_limit_bck'  
go
exec rename_column_if_exists 'product_cap_floor','limit','strike_limit' 
go
exec rename_column_if_exists 'corr_surf_basisadj_hist','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_surf_basisadj_hist','offset','offset_days'  
go
exec rename_column_if_exists 'corr_surf_data_hist','offset_days','offset_days_bck '
go
exec rename_column_if_exists 'corr_surf_data_hist','offset','offset_days'  
go
exec rename_column_if_exists 'corr_surf_ptadj_hist','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_surf_ptadj_hist','offset','offset_days' 
go
exec rename_column_if_exists 'corr_surf_timeaxis_hist','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_surf_timeaxis_hist','offset','offset_days'  
go
exec rename_column_if_exists 'corr_mat_data_hist','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_mat_data_hist','offset','offset_days'  
go
exec rename_column_if_exists 'corr_matrix_data','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_matrix_data','offset','offset_days'  
go
exec rename_column_if_exists 'corr_surf_basisadj','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_surf_basisadj','offset','offset_days'  
go
exec rename_column_if_exists 'corr_surf_data','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_surf_data','offset','offset_days'  
go
exec rename_column_if_exists 'corr_surf_ptadj','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_surf_ptadj','offset','offset_days'  
go
exec rename_column_if_exists 'corr_surf_timeaxis','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_surf_timeaxis','offset','offset_days'  
go
exec rename_column_if_exists 'corr_tenor_ax_hist','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_tenor_ax_hist','offset','offset_days'  
go
exec rename_column_if_exists 'corr_tenor_axis','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'corr_tenor_axis','offset','offset_days'  
go
exec rename_column_if_exists 'cov_mat_data_hist','offset_days','offset_days_bck'
go
exec rename_column_if_exists 'cov_mat_data_hist','offset','offset_days'  
go
exec rename_column_if_exists 'cov_matrix_data','offset_days','offset_days_bck' 
go
exec rename_column_if_exists 'cov_matrix_data','offset','offset_days'  
go
exec drop_column_if_exists 'product_cap_floor','strike_limit_bck'
go
exec drop_column_if_exists 'corr_surf_basisadj_hist','offset_days_bck'
go
exec drop_column_if_exists 'corr_surf_data_hist','offset_days_bck'
go
exec drop_column_if_exists 'corr_surf_ptadj_hist','offset_days_bck'
go
exec drop_column_if_exists 'corr_surf_timeaxis_hist','offset_days_bck'
go
exec drop_column_if_exists 'corr_mat_data_hist','offset_days_bck'
go
exec drop_column_if_exists 'corr_matrix_data','offset_days_bck'
go
exec drop_column_if_exists 'corr_surf_basisadj','offset_days_bck'
go
exec drop_column_if_exists 'corr_surf_data','offset_days_bck'
go
exec drop_column_if_exists 'corr_surf_ptadj','offset_days_bck'
go
exec drop_column_if_exists 'corr_surf_timeaxis','offset_days_bck'
go
exec drop_column_if_exists 'corr_tenor_ax_hist','offset_days_bck'
go
exec drop_column_if_exists 'corr_tenor_axis','offset_days_bck'
go
exec drop_column_if_exists 'cov_mat_data_hist','offset_days_bck'
go
exec drop_column_if_exists 'cov_matrix_data','offset_days_bck'
go