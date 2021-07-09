alter table product_cap_floor rename column strike_limit to strike_limit_bck 
;
alter table product_cap_floor rename column limit to strike_limit 
;
alter table corr_surf_basisadj_hist rename column offset_days to offset_days_bck
;
alter table corr_surf_basisadj_hist rename column offset to offset_days 
;
alter table corr_surf_data_hist rename column offset_days to offset_days_bck
;
alter table corr_surf_data_hist rename column offset to offset_days 
;
alter table corr_surf_ptadj_hist rename column offset_days to offset_days_bck
;
alter table corr_surf_ptadj_hist rename column offset to offset_days 
;
alter table corr_surf_timeaxis_hist rename column offset_days to offset_days_bck
;
alter table corr_surf_timeaxis_hist rename column offset to offset_days 
;
alter table corr_mat_data_hist rename column offset_days to offset_days_bck
;
alter table corr_mat_data_hist rename column offset to offset_days 
;
alter table corr_matrix_data rename column offset_days to offset_days_bck
;
alter table corr_matrix_data rename column offset to offset_days 
;
alter table corr_surf_basisadj rename column offset_days to offset_days_bck
;
alter table corr_surf_basisadj rename column offset to offset_days 
;
alter table corr_surf_data rename column offset_days to offset_days_bck
;
alter table corr_surf_data rename column offset to offset_days 
;
alter table corr_surf_ptadj rename column offset_days to offset_days_bck 
;
alter table corr_surf_ptadj rename column offset to offset_days 
;
alter table corr_surf_timeaxis rename column offset_days to offset_days_bck
;
alter table corr_surf_timeaxis rename column offset to offset_days 
;
alter table corr_tenor_ax_hist rename column offset_days to offset_days_bck
;
alter table corr_tenor_ax_hist rename column offset to offset_days 
;
alter table corr_tenor_axis rename column offset_days to offset_days_bck 
;
alter table corr_tenor_axis rename column offset to offset_days 
;
alter table cov_mat_data_hist rename column offset_days to offset_days_bck
;
alter table cov_mat_data_hist rename column offset to offset_days 
;
alter table cov_matrix_data rename column offset_days to offset_days_bck
;
alter table cov_matrix_data rename column offset to offset_days 
;

alter table product_cap_floor drop column strike_limit_bck
;
alter table corr_surf_basisadj_hist drop column offset_days_bck
;
alter table corr_surf_data_hist drop column offset_days_bck
;
alter table corr_surf_ptadj_hist drop column offset_days_bck
;
alter table corr_surf_timeaxis_hist drop column offset_days_bck
;
alter table corr_mat_data_hist drop column offset_days_bck
;
alter table corr_matrix_data drop column offset_days_bck
;
alter table corr_surf_basisadj drop column offset_days_bck
;
alter table corr_surf_data drop column offset_days_bck
;
alter table corr_surf_ptadj drop column offset_days_bck
;
alter table corr_surf_timeaxis drop column offset_days_bck
;
alter table corr_tenor_ax_hist drop column offset_days_bck
;
alter table corr_tenor_axis drop column offset_days_bck
;
alter table cov_mat_data_hist drop column offset_days_bck
;
alter table cov_matrix_data drop column offset_days_bck
;