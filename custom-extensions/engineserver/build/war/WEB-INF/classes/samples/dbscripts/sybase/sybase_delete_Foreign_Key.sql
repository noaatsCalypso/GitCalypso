ALTER TABLE main_entry_prop
DROP CONSTRAINT  FK_user_nm_main_entry_prop
go
ALTER TABLE org_node
DROP CONSTRAINT  FK_org_nm_org_node
go
ALTER TABLE fee_grid_attr
DROP CONSTRAINT  FK_fee_grid_fee_grid_attr
go
ALTER TABLE fee_grid
DROP CONSTRAINT  FK_legal_entity_fee_grid
go
ALTER TABLE trade_fee
DROP CONSTRAINT  FK_fee_definition_trd_fee
go
ALTER TABLE folder_trades
DROP CONSTRAINT  FK_folder_folder_trds
go
ALTER TABLE folder_trades
DROP CONSTRAINT  FK_trd_folder_trds
go
ALTER TABLE folder_shortcut
DROP CONSTRAINT  FK_folder_folder_shortcut
go
ALTER TABLE folder_shortcut
DROP CONSTRAINT  FK_folder_folder_shortcut_s
go
ALTER TABLE trade
DROP CONSTRAINT  FK_prd_desc_trd
go
ALTER TABLE trade
DROP CONSTRAINT  FK_trd_bk
go
ALTER TABLE trade
DROP CONSTRAINT  FK_legal_entity_trd
go
ALTER TABLE trade_keyword
DROP CONSTRAINT  FK_trd_trd_keyword
go
ALTER TABLE trade_note
DROP CONSTRAINT  FK_trd_trd_note
go
ALTER TABLE trade_price
DROP CONSTRAINT  FK_trd_trd_price
go
ALTER TABLE trade_role_alloc
DROP CONSTRAINT  FK_trd_trd_role_alloc
go
ALTER TABLE trade_open_qty
DROP CONSTRAINT  FK_trd_trd_open_qty
go
ALTER TABLE trade_open_qty
DROP CONSTRAINT  FK_prd_desc_trd_open_qty
go
ALTER TABLE cash_flow_simple
DROP CONSTRAINT  FK_prd_desc_cash_flow_simple
go
ALTER TABLE cash_flow_compound
DROP CONSTRAINT  FK_prd_desc_cash_flow_compound
go
ALTER TABLE cash_flow_option
DROP CONSTRAINT  FK_prd_desc_cash_flow_opt
go
ALTER TABLE cash_flow_coupon
DROP CONSTRAINT  FK_prd_desc_cash_flow_coupon
go
ALTER TABLE cash_flow_prin_adj
DROP CONSTRAINT  FK_prd_desc_cash_flow_prin_adj
go
ALTER TABLE cash_flow_optcpn
DROP CONSTRAINT  FK_prd_desc_cash_flow_optcpn
go
ALTER TABLE cash_flow_prichg
DROP CONSTRAINT  FK_prd_desc_cash_flow_prichg
go
ALTER TABLE cash_flow_div
DROP CONSTRAINT  FK_prd_desc_cash_flow_div
go
ALTER TABLE liq_position
DROP CONSTRAINT  FK_trd_liq_position_f
go
ALTER TABLE liq_position
DROP CONSTRAINT  FK_trd_liq_position_s
go
ALTER TABLE pl_position
DROP CONSTRAINT  FK_prd_desc_pl_position
go
ALTER TABLE pl_position
DROP CONSTRAINT  FK_bk_pl_position
go
ALTER TABLE an_param_items
DROP CONSTRAINT  FK_analysis_prm_an_prm_itms
go
ALTER TABLE an_og_rp_hedges
DROP CONSTRAINT  FK_an_prm_an_og_rp_hedges
go
ALTER TABLE an_og_report
DROP CONSTRAINT  FK_an_prm_itms_an_og_report
go
ALTER TABLE an_synth_hedge
DROP CONSTRAINT  FK_analysis_prm_an_synth_hedge
go
ALTER TABLE an_bhng_bucket
DROP CONSTRAINT  FK_analysis_prm_an_bhng_bucket
go
ALTER TABLE an_bhng_rp_hedges
DROP CONSTRAINT  FK_an_bhng_bck_an_bhng_rp_hdg
go
ALTER TABLE an_bhng_ulbucket
DROP CONSTRAINT  FK_an_bhng_bck_an_bhng_ulbck
go
ALTER TABLE risk_config
DROP CONSTRAINT  FK_user_nm_risk_cfg
go
ALTER TABLE an_bh_bucket
DROP CONSTRAINT  FK_analysis_prm_an_bh_bucket
go
ALTER TABLE an_bh_hedge
DROP CONSTRAINT  FK_analysis_prm_an_bh_hedge
go
ALTER TABLE pricing_param_item
DROP CONSTRAINT  FK_prcg_prm_prcg_prm_itm
go
ALTER TABLE pricing_param_item
DROP CONSTRAINT  FK_prcg_prm_nm_prcg_prm_itm
go
ALTER TABLE pricing_env
DROP CONSTRAINT  FK_prcg_env_prcg_prm
go
ALTER TABLE pricing_env
DROP CONSTRAINT  FK_prcg_env_pricer_cfg
go
ALTER TABLE pricing_env
DROP CONSTRAINT  FK_prcg_env_quote_set
go
ALTER TABLE pc_pricer
DROP CONSTRAINT  FK_pricer_cfg_pc_pricer 
go
ALTER TABLE pc_discount
DROP CONSTRAINT  FK_pricer_cfg_pc_discount
go
ALTER TABLE pc_forecast
DROP CONSTRAINT  FK_pricer_cfg_pc_forecast
go
ALTER TABLE pc_surface
DROP CONSTRAINT  FK_pricer_cfg_pc_surface
go
ALTER TABLE pc_fx
DROP CONSTRAINT  FK_pricer_cfg_pc_fx
go
ALTER TABLE pc_repo
DROP CONSTRAINT  FK_pricer_cfg_pc_repo
go
ALTER TABLE pc_recovery
DROP CONSTRAINT  FK_pricer_cfg_pc_recovery
go
ALTER TABLE pc_credit_spread
DROP CONSTRAINT  FK_pricer_cfg_pc_credit_spread
go
ALTER TABLE pc_probability
DROP CONSTRAINT  FK_pricer_cfg_pc_probability
go
ALTER TABLE pc_prod_specific
DROP CONSTRAINT  FK_pricer_cfg_pc_prod_specific
go
ALTER TABLE pc_credit_ticker
DROP CONSTRAINT  FK_pricer_cfg_pc_credit_ticker
go
ALTER TABLE curve
DROP CONSTRAINT  FK_market_data_itm_crv 
go
ALTER TABLE curve_tenor
DROP CONSTRAINT  FK_crv_crv_tenor
go
ALTER TABLE curve_member
DROP CONSTRAINT  FK_crv_crv_mbr
go
ALTER TABLE curve_member
DROP CONSTRAINT  FK_crv_underlying_crv_mbr
go
ALTER TABLE curve_member_rt
DROP CONSTRAINT  FK_crv_crv_mbr_rt
go
ALTER TABLE curve_member_link
DROP CONSTRAINT  FK_crv_mbr_rt_crv_mbr_link
go
ALTER TABLE curve_point
DROP CONSTRAINT  FK_crv_crv_point
go
ALTER TABLE curve_point_adj
DROP CONSTRAINT  FK_crv_point_crv_point_adj
go
ALTER TABLE curve_recovery
DROP CONSTRAINT  FK_crv_crv_recovery
go
ALTER TABLE curve_probability
DROP CONSTRAINT  FK_crv_crv_probability
go
ALTER TABLE custom_curve_qt
DROP CONSTRAINT  FK_crv_cst_crv_qt
go
ALTER TABLE curve_def_data
DROP CONSTRAINT  FK_crv_crv_def_data
go
ALTER TABLE curve_price_hdr
DROP CONSTRAINT  FK_crv_crv_price_hdr
go
ALTER TABLE curve_div_hdr
DROP CONSTRAINT  FK_crv_crv_div_hdr
go
ALTER TABLE curve_div_proj
DROP CONSTRAINT  FK_crv_crv_div_proj
go
ALTER TABLE curve_parameter
DROP CONSTRAINT  FK_crv_crv_prmeter
go
ALTER TABLE curve_quote_value
DROP CONSTRAINT  FK_crv_crv_quote_value
go
ALTER TABLE curve_quote_adj
DROP CONSTRAINT  FK_crv_qt_val_crv_qt_adj
go
ALTER TABLE curve_basis_header
DROP CONSTRAINT  FK_crv_crv_basis_header
go
ALTER TABLE curve_fx_header
DROP CONSTRAINT  FK_crv_crv_fx_header
go
ALTER TABLE curve_fxd_header
DROP CONSTRAINT  FK_crv_crv_fxd_header
go
ALTER TABLE curve_spc_date
DROP CONSTRAINT  FK_crv_crv_spc_date
go
ALTER TABLE curve_repo_header
DROP CONSTRAINT  FK_crv_crv_repo_header
go
ALTER TABLE curve_repo_header
DROP CONSTRAINT  FK_prd_desc_crv_repo_header
go
ALTER TABLE cu_specific_mmkt
DROP CONSTRAINT  FK_crv_ud_cu_spec_mmkt
go
ALTER TABLE cu_future
DROP CONSTRAINT  FK_crv_underlying_cu_future
go
ALTER TABLE cu_future
DROP CONSTRAINT  FK_future_contract_cu_future
go
ALTER TABLE cu_fra
DROP CONSTRAINT  FK_crv_underlying_cu_fra
go
ALTER TABLE cu_swap
DROP CONSTRAINT  FK_crv_underlying_cu_swap
go
ALTER TABLE cu_basis_swap
DROP CONSTRAINT  FK_crv_und_cu_basis_swap
go
ALTER TABLE cu_bond
DROP CONSTRAINT  FK_crv_underlying_cu_bond
go
ALTER TABLE cu_bondspread
DROP CONSTRAINT  FK_crv_und_cu_bdsprd
go
ALTER TABLE cu_moneymarket
DROP CONSTRAINT  FK_crv_und_cu_mmkt
go
ALTER TABLE cu_cds
DROP CONSTRAINT  FK_crv_underlying_cu_cds
go
ALTER TABLE cu_fx_forward
DROP CONSTRAINT  FK_crv_und_cu_fx_fwd
go
ALTER TABLE cu_eto
DROP CONSTRAINT  FK_crv_underlying_cu_eto
go
ALTER TABLE cu_eto
DROP CONSTRAINT  FK_eto_contract_cu_eto
go
ALTER TABLE cu_equity_index
DROP CONSTRAINT  FK_crv_und_cu_eqty_idx
go
ALTER TABLE cu_eq_index_fut
DROP CONSTRAINT  FK_crv_und_cu_eq_idx_fut
go
ALTER TABLE vol_surf_param
DROP CONSTRAINT  FK_vol_surf_vol_surf_prm
go
ALTER TABLE vol_surface_tenor
DROP CONSTRAINT  FK_vol_surf_vol_surf_tenor
go
ALTER TABLE vol_surf_exptenor
DROP CONSTRAINT  FK_vol_surf_vol_surf_exptenor
go
ALTER TABLE vol_surface_strike
DROP CONSTRAINT  FK_vol_surf_vol_surf_strike
go
ALTER TABLE vol_surface_point
DROP CONSTRAINT  FK_vol_surf_vol_surf_point
go
ALTER TABLE vol_surface_member
DROP CONSTRAINT  FK_vol_surf_vol_surface_mbr
go
ALTER TABLE vol_surf_qtvalue
DROP CONSTRAINT  FK_vol_surf_vol_surf_qtvalue
go
ALTER TABLE vol_surf_pointadj
DROP CONSTRAINT  FK_vol_surf_pt_vol_surf_ptadj
go
ALTER TABLE vol_pt_blob
DROP CONSTRAINT  FK_vol_surf_vol_pt_blob
go
ALTER TABLE surface_spc_date
DROP CONSTRAINT  FK_vol_surf_surface_spc_date
go
ALTER TABLE vol_surf_und_cap
DROP CONSTRAINT  FK_vol_surf_v_s_u_cap
go
ALTER TABLE vol_surf_und_swpt
DROP CONSTRAINT  FK_vol_surf_v_s_u_swpt
go
ALTER TABLE corr_first_axis
DROP CONSTRAINT  FK_corr_matrix_corr_first_axis
go
ALTER TABLE corr_second_axis
DROP CONSTRAINT  FK_corr_mtrx_corr_secd_axis
go
ALTER TABLE corr_tenor_axis
DROP CONSTRAINT  FK_corr_mtrx_corr_tenor_axis
go
ALTER TABLE group_access
DROP CONSTRAINT  FK_user_grp_nm_grp_access
go
ALTER TABLE usr_access_perm
DROP CONSTRAINT  FK_user_nm_usr_access_perm
go
ALTER TABLE user_password
DROP CONSTRAINT  FK_user_nm_user_password
go
ALTER TABLE passwd_history
DROP CONSTRAINT  FK_user_nm_passwd_history
go
ALTER TABLE access_product
DROP CONSTRAINT  FK_user_grp_nm_access_prd
go
ALTER TABLE perm_book_currency
DROP CONSTRAINT  FK_bk_perm_bk_ccy
go
ALTER TABLE perm_book_cur_pair
DROP CONSTRAINT  FK_bk_perm_bk_cur_pair
go
ALTER TABLE user_defaults
DROP CONSTRAINT  FK_user_nm_user_defaults
go
ALTER TABLE user_last_login
DROP CONSTRAINT  FK_user_nm_user_last_login
go
ALTER TABLE user_login_att
DROP CONSTRAINT  FK_user_nm_user_login_att
go
ALTER TABLE user_login_hist
DROP CONSTRAINT  FK_user_nm_user_login_hist
go
ALTER TABLE work_space_books
DROP CONSTRAINT  FK_wrk_wrk_bks
go
ALTER TABLE work_space_books
DROP CONSTRAINT  FK_bk_wrk_bks
go
ALTER TABLE work_space_bundles
DROP CONSTRAINT  FK_trd_bdl_wrk_bdls
go
ALTER TABLE work_space_bundles
DROP CONSTRAINT  FK_wrk_wrk_bdls
go
ALTER TABLE work_space_trades
DROP CONSTRAINT  FK_trd_wrk_trds
go
ALTER TABLE work_space_trades
DROP CONSTRAINT  FK_wrk_wrk_trds
go
ALTER TABLE work_space_port
DROP CONSTRAINT  FK_trd_flt_wrk_port
go
ALTER TABLE work_space_port
DROP CONSTRAINT  FK_wrk_wrk_port
go
ALTER TABLE work_space_filters
DROP CONSTRAINT  FK_flt_set_wrk_filters
go
ALTER TABLE work_space_filters
DROP CONSTRAINT  FK_wrk_wrk_filters
go
ALTER TABLE work_space_child
DROP CONSTRAINT  FK_wrk_wrk_child
go
ALTER TABLE work_space_child
DROP CONSTRAINT  FK_wrk_wrk_child_name
go
ALTER TABLE user_viewer_book
DROP CONSTRAINT  FK_bk_user_vwr_bk
go
ALTER TABLE user_viewer_book
DROP CONSTRAINT  FK_user_nm_user_vwr_bk
go
ALTER TABLE user_viewer_bundle
DROP CONSTRAINT  FK_bdl_user_vwr_bdl
go
ALTER TABLE user_viewer_bundle
DROP CONSTRAINT  FK_user_nm_user_vwr_bdl
go
ALTER TABLE user_viewer_le
DROP CONSTRAINT  FK_legal_entity_user_vwr_le
go
ALTER TABLE user_viewer_le
DROP CONSTRAINT  FK_user_nm_user_vwr_le
go
ALTER TABLE user_viewer_ws
DROP CONSTRAINT  FK_wrk_user_vwr_ws
go
ALTER TABLE user_viewer_ws
DROP CONSTRAINT  FK_user_nm_user_vwr_ws
go
ALTER TABLE user_viewer_port
DROP CONSTRAINT  FK_trd_flt_user_vwr_port
go
ALTER TABLE user_viewer_port
DROP CONSTRAINT  FK_user_nm_user_vwr_port
go
ALTER TABLE user_viewer_mitem
DROP CONSTRAINT  FK_user_nm_user_vwr_mitm
go
ALTER TABLE user_viewer_column
DROP CONSTRAINT  FK_user_nm_user_vwr_column
go
ALTER TABLE user_viewer_def
DROP CONSTRAINT  FK_user_nm_user_vwr_def
go
ALTER TABLE user_viewer_prop
DROP CONSTRAINT  FK_user_nm_user_vwr_prop
go
ALTER TABLE trade_filter_crit
DROP CONSTRAINT  FK_trd_flt_trd_filter_crit
go
ALTER TABLE trade_filt_min_max
DROP CONSTRAINT  FK_trd_flt_trd_filt_min_max
go
ALTER TABLE trfilter_minmax_dt
DROP CONSTRAINT  FK_trd_flt_trfilter_minmax_dt
go
ALTER TABLE legal_entity_role
DROP CONSTRAINT  FK_legal_ent_legal_ent_role
go
ALTER TABLE le_contact
DROP CONSTRAINT  FK_legal_entity_le_contact
go
ALTER TABLE le_agreement_field
DROP CONSTRAINT  FK_le_legal_agr_le_agr_fld
go
ALTER TABLE le_agr_child
DROP CONSTRAINT  FK_le_legal_agr_le_agr_child
go
ALTER TABLE sec_lend_legal
DROP CONSTRAINT  FK_le_legal_agr_sec_lend_legal
go
ALTER TABLE sec_lend_country
DROP CONSTRAINT  FK_sec_lend_leg_sec_lend_ctr
go
ALTER TABLE le_agr_child
DROP CONSTRAINT  FK_legal_ent_le_agr_child
go
ALTER TABLE le_registration
DROP CONSTRAINT  FK_legal_ent_le_regst
go
ALTER TABLE le_role_disabled
DROP CONSTRAINT  FK_legal_entity_le_role_dis_p
go
ALTER TABLE le_role_disabled
DROP CONSTRAINT  FK_legal_entity_le_role_dis_l
go
ALTER TABLE le_attribute
DROP CONSTRAINT  FK_legal_ent_le_attr
go
ALTER TABLE mrgcall_cashpos
DROP CONSTRAINT  FK_mrgcall_cfg_mrgcall_cashpos
go
ALTER TABLE mrgcall_secpos
DROP CONSTRAINT  FK_mrgcall_cfg_mrgcall_secpos
go
ALTER TABLE mrgcall_field
DROP CONSTRAINT  FK_mrgcall_cfg_mrgcall_field
go
ALTER TABLE ticker_keyword
DROP CONSTRAINT  FK_ticker_ticker_keyword
go
ALTER TABLE book_attr_value
DROP CONSTRAINT  FK_bk_attribute_bk_attr_value
go
ALTER TABLE book_attr_value
DROP CONSTRAINT  FK_bk_bk_attr_value
go
ALTER TABLE book_val_ccy
DROP CONSTRAINT  FK_bk_bk_val_ccy
go
ALTER TABLE book_val_ccy
DROP CONSTRAINT  FK_prd_desc_bk_val_ccy
go
ALTER TABLE acc_book_rule_link
DROP CONSTRAINT  FK_acc_bk_acc_bk_rl_link
go
ALTER TABLE acc_book_rule_link
DROP CONSTRAINT  FK_acc_rl_acc_bk_rl_link
go
ALTER TABLE acc_rule_date
DROP CONSTRAINT  FK_acc_rl_acc_rl_date
go
ALTER TABLE acc_rule_config
DROP CONSTRAINT  FK_acc_rl_acc_rl_cfg
go
ALTER TABLE balance_position
DROP CONSTRAINT  FK_acc_account_bal_pos
go
ALTER TABLE holiday_code_rule
DROP CONSTRAINT  FK_hldy_code_hldy_code_rl
go
ALTER TABLE holiday_code_rule
DROP CONSTRAINT  FK_hldy_rl_hldy_code_rl
go
ALTER TABLE filter_set_element
DROP CONSTRAINT  FK_flt_set_filter_set_element
go
ALTER TABLE filter_set_domain
DROP CONSTRAINT  FK_flt_set_elmt_filt_set_dom
go
ALTER TABLE sd_filter_element
DROP CONSTRAINT  FK_sd_filt_sd_filt_elmt
go
ALTER TABLE sd_filter_domain
DROP CONSTRAINT  FK_sd_filt_elmnt_sd_filt_dom
go
ALTER TABLE disp_calc
DROP CONSTRAINT  FK_disp_cfg_disp_calc
go
ALTER TABLE limit_config_node
DROP CONSTRAINT  FK_limit_cfg_limit_cfg_node
go
ALTER TABLE limit_config_limit
DROP CONSTRAINT  FK_lmt_cfg_node_lmt_cfg_lmt
go
ALTER TABLE limit_crit_group
DROP CONSTRAINT  FK_lmt_cfg_node_lmt_crit_grp
go
ALTER TABLE sched_task_attr
DROP CONSTRAINT  FK_sched_task_sched_task_attr
go
ALTER TABLE sched_task_exec
DROP CONSTRAINT  FK_sched_task_sched_task_exec
go
ALTER TABLE manual_party_sdi
DROP CONSTRAINT  FK_manual_sdi_manual_party_sdi
go
ALTER TABLE manual_sdi_attr
DROP CONSTRAINT  FK_manual_sdi_manual_sdi_attr
go
ALTER TABLE le_settle_delivery
DROP CONSTRAINT  FK_legal_entity_le_stl_dlv
go
ALTER TABLE sdi_relationship
DROP CONSTRAINT  FK_le_stl_dlv_sdi_relationship
go
ALTER TABLE sdi_attribute
DROP CONSTRAINT  FK_le_stl_dlv_sdi_attribute
go
ALTER TABLE currency_benchmark
DROP CONSTRAINT  FK_prd_desc_ccy_benchmark
go
ALTER TABLE task_book_config
DROP CONSTRAINT  FK_user_grp_nm_task_bk_cfg
go
ALTER TABLE task_event_config
DROP CONSTRAINT  FK_user_grp_nm_task_event_cfg
go
ALTER TABLE prod_exch_code
DROP CONSTRAINT  FK_prd_equity_prod_exch_code 
go
ALTER TABLE product_sec_code
DROP CONSTRAINT  FK_prd_desc_prd_sec_code
go
ALTER TABLE cash_settle_info
DROP CONSTRAINT  FK_prd_desc_cash_settle_info
go
ALTER TABLE cash_settle_date
DROP CONSTRAINT  FK_cash_st_info_cash_st_dt
go
ALTER TABLE template_product
DROP CONSTRAINT  FK_prd_desc_template_prd
go
ALTER TABLE template_dates
DROP CONSTRAINT  FK_template_prd_template_date
go
ALTER TABLE product_holding
DROP CONSTRAINT  FK_prd_desc_prd_holding
go
ALTER TABLE product_simplexfer
DROP CONSTRAINT  FK_prd_desc_prd_simplexfer
go
ALTER TABLE product_custxfer
DROP CONSTRAINT  FK_prd_desc_prd_custxfer
go
ALTER TABLE product_custxfer
DROP CONSTRAINT  FK_prd_custxfer_le_stl_dlv
go
ALTER TABLE product_custxfer
DROP CONSTRAINT  FK_prd_custxfer_le_stl_dlv1
go
ALTER TABLE product_xferagent
DROP CONSTRAINT  FK_prd_desc_prd_xferagent
go
ALTER TABLE product_xferagent
DROP CONSTRAINT  FK_prd_xferagent_le_stl_dlv
go
ALTER TABLE product_xferagent
DROP CONSTRAINT  FK_prd_xferagent_le_stl_dlv1
go
ALTER TABLE product_fx
DROP CONSTRAINT  FK_prd_desc_prd_fx
go
ALTER TABLE product_fx
DROP CONSTRAINT  FK_ccy_pair_prd_fx
go
ALTER TABLE product_fx_option
DROP CONSTRAINT  FK_prd_fx_opt_prd_fx
go
ALTER TABLE asian_parameters
DROP CONSTRAINT  FK_prd_desc_asian_prmeters
go
ALTER TABLE asian_reset_dates
DROP CONSTRAINT  FK_prd_desc_asian_reset_dates
go
ALTER TABLE barrier_parameters
DROP CONSTRAINT  FK_prd_desc_barrier_prmeters
go
ALTER TABLE product_cmpd_opt
DROP CONSTRAINT  FK_prd_desc_prd_cmpd_opt
go
ALTER TABLE product_cmpd_opt
DROP CONSTRAINT  FK_prd_desc_prd_cmpd_opt_u
go
ALTER TABLE product_fx_opt_fwd
DROP CONSTRAINT  FK_prd_fx_prd_fx_opt_fwd
go
ALTER TABLE product_fx_opt_fwd
DROP CONSTRAINT  FK_prd_desc_prd_fx_opt_fwd
go
ALTER TABLE product_fx_takeup
DROP CONSTRAINT  FK_prd_fx_prd_fx_takeup
go
ALTER TABLE product_fx_takeup
DROP CONSTRAINT  FK_prd_desc_prd_fx_takeup
go
ALTER TABLE product_fxoptstrip
DROP CONSTRAINT  FK_prd_fx_prd_fxoptstrip
go
ALTER TABLE product_fxoptstrip
DROP CONSTRAINT  FK_prd_desc_prd_fxoptstrip
go
ALTER TABLE product_fx_forward
DROP CONSTRAINT  FK_prd_fx_prd_fx_forward
go
ALTER TABLE product_fx_forward
DROP CONSTRAINT  FK_prd_desc_prd_fx_forward
go
ALTER TABLE product_fx_cash
DROP CONSTRAINT  FK_prd_fx_prd_fx_cash
go
ALTER TABLE product_fx_cash
DROP CONSTRAINT  FK_prd_desc_prd_fx_cash
go
ALTER TABLE fx_cash_flow
DROP CONSTRAINT  FK_prd_fx_cash_fx_cash_flow
go
ALTER TABLE product_fx_ndf
DROP CONSTRAINT  FK_prd_fx_prd_fx_ndf
go
ALTER TABLE product_fx_ndf
DROP CONSTRAINT  FK_prd_desc_prd_fx_ndf
go
ALTER TABLE product_fx_ndf
DROP CONSTRAINT  FK_prd_fx_ndf_fx_reset
go
ALTER TABLE product_fx_swap
DROP CONSTRAINT  FK_prd_fx_prd_fx_swap
go
ALTER TABLE product_fx_swap
DROP CONSTRAINT  FK_prd_desc_prd_fx_swap
go
ALTER TABLE product_mmkt
DROP CONSTRAINT  FK_prd_desc_prd_mmkt
go
ALTER TABLE product_simple_mm
DROP CONSTRAINT  FK_prd_desc_prd_simple_mm
go
ALTER TABLE product_call_not
DROP CONSTRAINT  FK_prd_desc_prd_call_not
go
ALTER TABLE product_commod_mm
DROP CONSTRAINT  FK_prd_desc_prd_commod_mm
go
ALTER TABLE product_simplerepo
DROP CONSTRAINT  FK_prd_desc_prd_simplerepo
go
ALTER TABLE product_simplerepo
DROP CONSTRAINT  FK_prd_desc_prd_simplerepo_s
go
ALTER TABLE product_repo
DROP CONSTRAINT  FK_prd_desc_prd_repo
go
ALTER TABLE product_collateral
DROP CONSTRAINT  FK_prd_desc_prd_cltl
go
ALTER TABLE product_cash
DROP CONSTRAINT  FK_prd_desc_prd_cash
go
ALTER TABLE product_repo
DROP CONSTRAINT  FK_prd_cash_prd_repo
go
ALTER TABLE repo_collateral
DROP CONSTRAINT  FK_prd_repo_repo_cltl
go
ALTER TABLE repo_collateral
DROP CONSTRAINT  FK_prd_cltl_repo_cltl
go
ALTER TABLE product_jgb_repo
DROP CONSTRAINT  FK_prd_repo_prd_jgb_repo
go
ALTER TABLE product_bond
DROP CONSTRAINT  FK_prd_desc_prd_bond
go
ALTER TABLE bond_info
DROP CONSTRAINT  FK_prd_bond_bond_info
go
ALTER TABLE bond_info_syndic
DROP CONSTRAINT  FK_prd_bond_bond_info_syndic
go
ALTER TABLE lottery_win_date
DROP CONSTRAINT  FK_prd_bond_lottery_win_date
go
ALTER TABLE bond_guarantee
DROP CONSTRAINT  FK_prd_bond_bond_guarantee
go
ALTER TABLE bond_asset_backed
DROP CONSTRAINT  FK_prd_bond_bond_asset_backed
go
ALTER TABLE bond_convertible
DROP CONSTRAINT  FK_prd_bond_bond_convertible
go
ALTER TABLE conversion_reset
DROP CONSTRAINT  FK_bond_convert_cnv_reset
go
ALTER TABLE bond_pool_factor
DROP CONSTRAINT  FK_prd_bond_bond_pool_factor
go
ALTER TABLE product_bond_opt
DROP CONSTRAINT  FK_prd_desc_prd_bond_opt
go
ALTER TABLE product_bond_opt
DROP CONSTRAINT  FK_prd_bond_prd_bond_opt
go
ALTER TABLE product_bondspread
DROP CONSTRAINT  FK_prd_bond_prd_bondsprd
go
ALTER TABLE product_bondspread
DROP CONSTRAINT  FK_prd_desc_prd_bondspread
go
ALTER TABLE product_bsb
DROP CONSTRAINT  FK_prd_desc_prd_bsb
go
ALTER TABLE product_issuance
DROP CONSTRAINT  FK_prd_desc_prd_issuance
go
ALTER TABLE product_issuance
DROP CONSTRAINT  FK_prd_desc_prd_issuance_s
go
ALTER TABLE product_seclending
DROP CONSTRAINT  FK_prd_desc_prd_seclending
go
ALTER TABLE seclending_col
DROP CONSTRAINT  FK_prd_seclending_seclend_col
go
ALTER TABLE seclending_col
DROP CONSTRAINT  FK_prd_cltl_seclending_col
go
ALTER TABLE product_tlock
DROP CONSTRAINT  FK_prd_desc_prd_tlock
go
ALTER TABLE product_future
DROP CONSTRAINT  FK_prd_desc_prd_future
go
ALTER TABLE product_future
DROP CONSTRAINT  FK_future_contract_prd_future
go
ALTER TABLE future_ctd
DROP CONSTRAINT  FK_future_contract_future_ctd
go
ALTER TABLE product_fut_opt
DROP CONSTRAINT  FK_opt_contract_prd_fut_opt
go
ALTER TABLE product_swap
DROP CONSTRAINT  FK_prd_desc_prd_swap
go
ALTER TABLE product_swap
DROP CONSTRAINT  FK_prd_swap_swap_leg
go
ALTER TABLE product_swap
DROP CONSTRAINT  FK_prd_swap_swap_leg1
go
ALTER TABLE termination_date
DROP CONSTRAINT  FK_prd_desc_trm_date
go
ALTER TABLE put_call_date
DROP CONSTRAINT  FK_prd_desc_put_call_date
go
ALTER TABLE payout_formula
DROP CONSTRAINT  FK_swap_leg_payout_formula
go
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_swap_leg_n_sch
go
ALTER TABLE swaption_ext_info
DROP CONSTRAINT  FK_prd_swption_swption_ext_in
go
ALTER TABLE xccy_swap_ext_info
DROP CONSTRAINT  FK_prd_swp_xccy_swap_ext_info
go
ALTER TABLE product_cap_floor
DROP CONSTRAINT  FK_prd_desc_prd_cap_floor
go
ALTER TABLE cap_swap_ext_info
DROP CONSTRAINT  FK_prd_swap_cap_swap_ext_info
go
ALTER TABLE product_structured
DROP CONSTRAINT  FK_prd_desc_prd_structured
go
ALTER TABLE basic_product
DROP CONSTRAINT  FK_prd_desc_basic_prd
go
ALTER TABLE basic_product
DROP CONSTRAINT  FK_prd_desc_basic_prd_b
go
ALTER TABLE basic_prod_keyword
DROP CONSTRAINT  FK_basic_prd_basic_prd_kwd
go
ALTER TABLE product_fra
DROP CONSTRAINT  FK_prd_desc_prd_fra
go
ALTER TABLE product_asset_swap
DROP CONSTRAINT  FK_prd_desc_prd_asset_swap
go
ALTER TABLE product_cds
DROP CONSTRAINT  FK_prd_desc_prd_cds
go
ALTER TABLE product_cds
DROP CONSTRAINT  FK_ref_entity_prd_cds
go
ALTER TABLE termination_events
DROP CONSTRAINT  FK_prd_cds_trm_events
go
ALTER TABLE del_characteristic
DROP CONSTRAINT  FK_prd_cds_del_characteristic
go
ALTER TABLE ref_characteristic
DROP CONSTRAINT  FK_prd_cds_ref_characteristic
go
ALTER TABLE ref_entity_basket
DROP CONSTRAINT  FK_ref_ent_ref_ent_basket
go
ALTER TABLE ref_entity_single
DROP CONSTRAINT  FK_ref_ent_ref_ent_single
go
ALTER TABLE product_cdsnthdflt
DROP CONSTRAINT  FK_prd_cds_prd_cdsnthdflt
go
ALTER TABLE product_cdsnthloss
DROP CONSTRAINT  FK_prd_cds_prd_cdsnthloss
go
ALTER TABLE product_trs
DROP CONSTRAINT  FK_prd_desc_prd_trs
go
ALTER TABLE product_basket
DROP CONSTRAINT  FK_prd_desc_prd_basket
go
ALTER TABLE product_trs_basket
DROP CONSTRAINT  FK_prd_trs_prd_trs_basket
go
ALTER TABLE product_cfd
DROP CONSTRAINT  FK_prd_desc_prd_cfd
go
ALTER TABLE cfd_data
DROP CONSTRAINT  FK_prd_cfd_cfd_data
go
ALTER TABLE product_cfd
DROP CONSTRAINT  FK_cfd_contract_prd_cfd
go
ALTER TABLE cfd_country_attr
DROP CONSTRAINT  FK_cfd_ctry_cfd_ctry_attr
go
ALTER TABLE cfd_contract_attr
DROP CONSTRAINT  FK_cfd_cntr_cfd_cntr_attr
go
ALTER TABLE cfd_detail
DROP CONSTRAINT  FK_cfd_cntrt_cfd_detail
go
ALTER TABLE cfd_detail_rdate
DROP CONSTRAINT  FK_cfd_cntrt_cfd_det_rdate
go
ALTER TABLE cfd_fin_grid
DROP CONSTRAINT  FK_cfd_cntrt_cfd_fin_grid
go
ALTER TABLE cfd_deposit
DROP CONSTRAINT  FK_cfd_cntrt_cfd_deposit
go
ALTER TABLE product_eto
DROP CONSTRAINT  FK_eto_contract_prd_eto
go
ALTER TABLE product_eto
DROP CONSTRAINT  FK_prd_desc_prd_eto
go
ALTER TABLE product_equity
DROP CONSTRAINT  FK_prd_desc_prd_equity
go
ALTER TABLE product_adr
DROP CONSTRAINT  FK_prd_desc_prd_adr
go
ALTER TABLE dividend
DROP CONSTRAINT  FK_prd_desc_dividend
go
ALTER TABLE product_otceqtyopt
DROP CONSTRAINT  FK_prd_otcopt_prd_otceqtyopt
go
ALTER TABLE product_otcoption
DROP CONSTRAINT  FK_prd_desc_prd_otcopt
go
ALTER TABLE product_otceqtyopt
DROP CONSTRAINT  FK_prd_otceqtyopt_fx_reset
go
ALTER TABLE option_deliverable
DROP CONSTRAINT  FK_prd_otcopt_opt_deliverable
go
ALTER TABLE product_otceq_opt
DROP CONSTRAINT  FK_prd_otceopt_prd_otceqtyopt
go
ALTER TABLE eq_linked_leg
DROP CONSTRAINT  FK_prd_els_equity_link_leg
go
ALTER TABLE performance_leg
DROP CONSTRAINT  FK_prd_els_prfm_lg
go
ALTER TABLE initial_prices
DROP CONSTRAINT  FK_prfm_lg_initial_prices
go
ALTER TABLE option_observable
DROP CONSTRAINT  FK_obsrv_opt_obsrv
go
ALTER TABLE kickoff_cfg
DROP CONSTRAINT  FK_wfw_trst_kickoff_cfg
go
ALTER TABLE bo_workflow_rule
DROP CONSTRAINT  FK_wfw_trst_bo_wrkflw_rl
go
ALTER TABLE mapping_status
DROP CONSTRAINT  FK_wfw_trst_mapping_status
go
ALTER TABLE transfer_reconcil
DROP CONSTRAINT  FK_bo_transfer_transfer_recon
go
ALTER TABLE xfer_attributes
DROP CONSTRAINT  FK_bo_transfer_xfer_attributes
go
ALTER TABLE event_trade
DROP CONSTRAINT  FK_ps_event_event_trd
go
ALTER TABLE event_trade
DROP CONSTRAINT  FK_trd_event_trd
go
ALTER TABLE ps_event_inst
DROP CONSTRAINT  FK_ps_event_ps_event_inst
go
ALTER TABLE ps_event_config
DROP CONSTRAINT  FK_ps_evt_cfg_nm_ps_evt_cfg
go
ALTER TABLE ps_event_filter
DROP CONSTRAINT  FK_ps_evt_cfg_nm_ps_evt_filt
go
ALTER TABLE event_transfer
DROP CONSTRAINT  FK_ps_event_event_transfer
go
ALTER TABLE event_transfer
DROP CONSTRAINT  FK_bo_transfer_event_transfer
go
ALTER TABLE event_message
DROP CONSTRAINT  FK_ps_event_event_message
go
ALTER TABLE event_message
DROP CONSTRAINT  FK_bo_message_event_message
go
ALTER TABLE mess_attributes
DROP CONSTRAINT  FK_bo_message_mess_attributes
go
ALTER TABLE event_in_message
DROP CONSTRAINT  FK_bo_in_mess_event_in_mess
go
ALTER TABLE event_posting
DROP CONSTRAINT  FK_ps_event_event_posting
go
ALTER TABLE event_posting
DROP CONSTRAINT  FK_bo_posting_event_posting
go
ALTER TABLE event_posting
DROP CONSTRAINT  FK_trd_event_posting
go
ALTER TABLE event_task
DROP CONSTRAINT  FK_ps_event_event_task
go
ALTER TABLE event_task
DROP CONSTRAINT  FK_bo_task_event_task
go
ALTER TABLE event_plpos
DROP CONSTRAINT  FK_pl_position_event_plpos
go
ALTER TABLE event_liqpos
DROP CONSTRAINT  FK_ps_event_event_liqpos
go
ALTER TABLE event_unliqpos
DROP CONSTRAINT  FK_ps_event_event_unliqpos
go
ALTER TABLE event_cre
DROP CONSTRAINT  FK_ps_event_event_cre
go
ALTER TABLE event_cre
DROP CONSTRAINT  FK_bo_cre_event_cre
go
ALTER TABLE bo_cre
DROP CONSTRAINT  FK_trd_bo_cre 
go
ALTER TABLE bo_cre
DROP CONSTRAINT  FK_prd_desc_bo_cre
go
ALTER TABLE cre_attribute
DROP CONSTRAINT  FK_bo_cre_cre_attribute
go
ALTER TABLE mutation_attr
DROP CONSTRAINT  FK_mutation_mutation_attr
go
ALTER TABLE mutation_flow
DROP CONSTRAINT  FK_mutation_mutation_flow
go
ALTER TABLE cre_amount
DROP CONSTRAINT  FK_bo_cre_cre_amount
go
ALTER TABLE scenario_items
DROP CONSTRAINT  FK_scenario_rl_scenario_itms
go
ALTER TABLE tree_node
DROP CONSTRAINT  FK_tree_nm_tree_node
go
ALTER TABLE scenario_report
DROP CONSTRAINT  FK_scenario_view_scn_report
go
ALTER TABLE bo_posting
DROP CONSTRAINT  FK_bo_posting_prd_desc
go
ALTER TABLE bo_posting
DROP CONSTRAINT  FK_bo_posting_trd
go
ALTER TABLE cap_swap_ext_info
DROP CONSTRAINT  FK_cap_swap_ext_info_prd_desc
go
ALTER TABLE currency_pair
DROP CONSTRAINT  FK_ccy_pair_ccy_default
go
ALTER TABLE currency_pair
DROP CONSTRAINT  FK_ccy_pair_ccy_default1
go
ALTER TABLE curve_member_link
DROP CONSTRAINT  FK_crv_mbr_link_crv
go
ALTER TABLE curve_member_link
DROP CONSTRAINT  FK_crv_mbr_link_crv_underlying
go
ALTER TABLE curve_member_rt
DROP CONSTRAINT  FK_crv_mbr_rt_crv_underlying
go
ALTER TABLE event_transfer
DROP CONSTRAINT  FK_event_transfer_trd
go
ALTER TABLE fx_reset
DROP CONSTRAINT  FK_fx_reset_ccy_default
go
ALTER TABLE fx_reset
DROP CONSTRAINT  FK_fx_reset_ccy_default1
go
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_asset_swap
go
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_cds
go
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_els
go
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_swap
go
ALTER TABLE product_bond
DROP CONSTRAINT  FK_prd_bond_legal_entity
go
ALTER TABLE product_eto
DROP CONSTRAINT  FK_prd_eto_prd_desc
go
ALTER TABLE product_fut_opt
DROP CONSTRAINT  FK_prd_fut_opt_prd_desc
go
ALTER TABLE swap_leg
DROP CONSTRAINT  FK_swap_leg_prd_desc 
go
ALTER TABLE task_book_config
DROP CONSTRAINT  FK_task_bk_cfg_bk
go

ALTER TABLE vol_surface 
DROP   CONSTRAINT FK_vol_surface 
go
ALTER TABLE vol_surface_tenor 
DROP   CONSTRAINT FK_vol_surface_tenor 
go
ALTER TABLE vol_surface_point 
DROP   CONSTRAINT FK_vol_surface_point 
go
ALTER TABLE vol_surf_pointadj 
DROP   CONSTRAINT FK_vol_surf_pointadj 
go
ALTER TABLE vol_pt_blob 
DROP   CONSTRAINT FK_vol_pt_blob 
go
ALTER TABLE vol_surf_param 
DROP   CONSTRAINT FK_vol_surf_param 
go
ALTER TABLE vol_surf_qtvalue 
DROP   CONSTRAINT FK_vol_surf_qtvalue 
go
ALTER TABLE vol_surf_exptenor 
DROP   CONSTRAINT FK_vol_surf_exptenor 
go
ALTER TABLE vol_surface_strike 
DROP   CONSTRAINT FK_vol_surface_strike 
go
ALTER TABLE surface_spc_date 
DROP   CONSTRAINT FK_surface_spc_date 
go
ALTER TABLE vol_surface_member 
DROP   CONSTRAINT FK_vol_surface_member 
go
ALTER TABLE correlation_matrix 
DROP   CONSTRAINT FK_correlation_matrix 
go
ALTER TABLE corr_first_axis  
DROP   CONSTRAINT FK_corr_first_axis  
go
ALTER TABLE corr_second_axis 
DROP   CONSTRAINT FK_corr_second_axis 
go
ALTER TABLE corr_tenor_axis 
DROP   CONSTRAINT FK_corr_tenor_axis 
go
ALTER TABLE corr_matrix_data 
DROP   CONSTRAINT FK_corr_matrix_data 
go
ALTER TABLE corr_matrix_param 
DROP   CONSTRAINT FK_corr_matrix_param 
go

