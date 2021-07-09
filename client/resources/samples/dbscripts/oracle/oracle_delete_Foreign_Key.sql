ALTER TABLE main_entry_prop
DROP CONSTRAINT  FK_user_nm_main_entry_prop
;
ALTER TABLE org_node
DROP CONSTRAINT  FK_org_nm_org_node
;
ALTER TABLE fee_grid_attr
DROP CONSTRAINT  FK_fee_grid_fee_grid_attr
;
ALTER TABLE fee_grid
DROP CONSTRAINT  FK_legal_entity_fee_grid
;
ALTER TABLE trade_fee
DROP CONSTRAINT  FK_fee_definition_trd_fee
;
ALTER TABLE folder_trades
DROP CONSTRAINT  FK_folder_folder_trds
;
ALTER TABLE folder_trades
DROP CONSTRAINT  FK_trd_folder_trds
;
ALTER TABLE folder_shortcut
DROP CONSTRAINT  FK_folder_folder_shortcut
;
ALTER TABLE folder_shortcut
DROP CONSTRAINT  FK_folder_folder_shortcut_s
;
ALTER TABLE trade
DROP CONSTRAINT  FK_prd_desc_trd
;
ALTER TABLE trade
DROP CONSTRAINT  FK_trd_bk
;
ALTER TABLE trade
DROP CONSTRAINT  FK_legal_entity_trd
;
ALTER TABLE trade_keyword
DROP CONSTRAINT  FK_trd_trd_keyword
;
ALTER TABLE trade_note
DROP CONSTRAINT  FK_trd_trd_note
;
ALTER TABLE trade_price
DROP CONSTRAINT  FK_trd_trd_price
;
ALTER TABLE trade_role_alloc
DROP CONSTRAINT  FK_trd_trd_role_alloc
;
ALTER TABLE trade_open_qty
DROP CONSTRAINT  FK_trd_trd_open_qty
;
ALTER TABLE trade_open_qty
DROP CONSTRAINT  FK_prd_desc_trd_open_qty
;
ALTER TABLE cash_flow_simple
DROP CONSTRAINT  FK_prd_desc_cash_flow_simple
;
ALTER TABLE cash_flow_compound
DROP CONSTRAINT  FK_prd_desc_cash_flow_compound
;
ALTER TABLE cash_flow_option
DROP CONSTRAINT  FK_prd_desc_cash_flow_opt
;
ALTER TABLE cash_flow_coupon
DROP CONSTRAINT  FK_prd_desc_cash_flow_coupon
;
ALTER TABLE cash_flow_prin_adj
DROP CONSTRAINT  FK_prd_desc_cash_flow_prin_adj
;
ALTER TABLE cash_flow_optcpn
DROP CONSTRAINT  FK_prd_desc_cash_flow_optcpn
;
ALTER TABLE cash_flow_prichg
DROP CONSTRAINT  FK_prd_desc_cash_flow_prichg
;
ALTER TABLE cash_flow_div
DROP CONSTRAINT  FK_prd_desc_cash_flow_div
;
ALTER TABLE liq_position
DROP CONSTRAINT  FK_trd_liq_position_f
;
ALTER TABLE liq_position
DROP CONSTRAINT  FK_trd_liq_position_s
;
ALTER TABLE pl_position
DROP CONSTRAINT  FK_prd_desc_pl_position
;
ALTER TABLE pl_position
DROP CONSTRAINT  FK_bk_pl_position
;
ALTER TABLE an_param_items
DROP CONSTRAINT  FK_analysis_prm_an_prm_itms
;
ALTER TABLE an_og_rp_hedges
DROP CONSTRAINT  FK_an_prm_an_og_rp_hedges
;
ALTER TABLE an_og_report
DROP CONSTRAINT  FK_an_prm_itms_an_og_report
;
ALTER TABLE an_synth_hedge
DROP CONSTRAINT  FK_analysis_prm_an_synth_hedge
;
ALTER TABLE an_bhng_bucket
DROP CONSTRAINT  FK_analysis_prm_an_bhng_bucket
;
ALTER TABLE an_bhng_rp_hedges
DROP CONSTRAINT  FK_an_bhng_bck_an_bhng_rp_hdg
;
ALTER TABLE an_bhng_ulbucket
DROP CONSTRAINT  FK_an_bhng_bck_an_bhng_ulbck
;
ALTER TABLE risk_config
DROP CONSTRAINT  FK_user_nm_risk_cfg
;
ALTER TABLE an_bh_bucket
DROP CONSTRAINT  FK_analysis_prm_an_bh_bucket
;
ALTER TABLE an_bh_hedge
DROP CONSTRAINT  FK_analysis_prm_an_bh_hedge
;
ALTER TABLE pricing_param_item
DROP CONSTRAINT  FK_prcg_prm_prcg_prm_itm
;
ALTER TABLE pricing_param_item
DROP CONSTRAINT  FK_prcg_prm_nm_prcg_prm_itm
;
ALTER TABLE pricing_env
DROP CONSTRAINT  FK_prcg_env_prcg_prm
;
ALTER TABLE pricing_env
DROP CONSTRAINT  FK_prcg_env_pricer_cfg
;
ALTER TABLE pricing_env
DROP CONSTRAINT  FK_prcg_env_quote_set
;
ALTER TABLE pc_pricer
DROP CONSTRAINT  FK_pricer_cfg_pc_pricer 
;
ALTER TABLE pc_discount
DROP CONSTRAINT  FK_pricer_cfg_pc_discount
;
ALTER TABLE pc_forecast
DROP CONSTRAINT  FK_pricer_cfg_pc_forecast
;
ALTER TABLE pc_surface
DROP CONSTRAINT  FK_pricer_cfg_pc_surface
;
ALTER TABLE pc_fx
DROP CONSTRAINT  FK_pricer_cfg_pc_fx
;
ALTER TABLE pc_repo
DROP CONSTRAINT  FK_pricer_cfg_pc_repo
;
ALTER TABLE pc_recovery
DROP CONSTRAINT  FK_pricer_cfg_pc_recovery
;
ALTER TABLE pc_credit_spread
DROP CONSTRAINT  FK_pricer_cfg_pc_credit_spread
;
ALTER TABLE pc_probability
DROP CONSTRAINT  FK_pricer_cfg_pc_probability
;
ALTER TABLE pc_prod_specific
DROP CONSTRAINT  FK_pricer_cfg_pc_prod_specific
;
ALTER TABLE pc_credit_ticker
DROP CONSTRAINT  FK_pricer_cfg_pc_credit_ticker
;
ALTER TABLE curve
DROP CONSTRAINT  FK_market_data_itm_crv 
;
ALTER TABLE curve_tenor
DROP CONSTRAINT  FK_crv_crv_tenor
;
ALTER TABLE curve_member
DROP CONSTRAINT  FK_crv_crv_mbr
;
ALTER TABLE curve_member
DROP CONSTRAINT  FK_crv_underlying_crv_mbr
;
ALTER TABLE curve_member_rt
DROP CONSTRAINT  FK_crv_crv_mbr_rt
;
ALTER TABLE curve_member_link
DROP CONSTRAINT  FK_crv_mbr_rt_crv_mbr_link
;
ALTER TABLE curve_point
DROP CONSTRAINT  FK_crv_crv_point
;
ALTER TABLE curve_point_adj
DROP CONSTRAINT  FK_crv_point_crv_point_adj
;
ALTER TABLE curve_recovery
DROP CONSTRAINT  FK_crv_crv_recovery
;
ALTER TABLE curve_probability
DROP CONSTRAINT  FK_crv_crv_probability
;
ALTER TABLE custom_curve_qt
DROP CONSTRAINT  FK_crv_cst_crv_qt
;
ALTER TABLE curve_def_data
DROP CONSTRAINT  FK_crv_crv_def_data
;
ALTER TABLE curve_price_hdr
DROP CONSTRAINT  FK_crv_crv_price_hdr
;
ALTER TABLE curve_div_hdr
DROP CONSTRAINT  FK_crv_crv_div_hdr
;
ALTER TABLE curve_div_proj
DROP CONSTRAINT  FK_crv_crv_div_proj
;
ALTER TABLE curve_parameter
DROP CONSTRAINT  FK_crv_crv_prmeter
;
ALTER TABLE curve_quote_value
DROP CONSTRAINT  FK_crv_crv_quote_value
;
ALTER TABLE curve_quote_adj
DROP CONSTRAINT  FK_crv_qt_val_crv_qt_adj
;
ALTER TABLE curve_basis_header
DROP CONSTRAINT  FK_crv_crv_basis_header
;
ALTER TABLE curve_fx_header
DROP CONSTRAINT  FK_crv_crv_fx_header
;
ALTER TABLE curve_fxd_header
DROP CONSTRAINT  FK_crv_crv_fxd_header
;
ALTER TABLE curve_spc_date
DROP CONSTRAINT  FK_crv_crv_spc_date
;
ALTER TABLE curve_repo_header
DROP CONSTRAINT  FK_crv_crv_repo_header
;
ALTER TABLE curve_repo_header
DROP CONSTRAINT  FK_prd_desc_crv_repo_header
;
ALTER TABLE cu_specific_mmkt
DROP CONSTRAINT  FK_crv_ud_cu_spec_mmkt
;
ALTER TABLE cu_future
DROP CONSTRAINT  FK_crv_underlying_cu_future
;
ALTER TABLE cu_future
DROP CONSTRAINT  FK_future_contract_cu_future
;
ALTER TABLE cu_fra
DROP CONSTRAINT  FK_crv_underlying_cu_fra
;
ALTER TABLE cu_swap
DROP CONSTRAINT  FK_crv_underlying_cu_swap
;
ALTER TABLE cu_basis_swap
DROP CONSTRAINT  FK_crv_und_cu_basis_swap
;
ALTER TABLE cu_bond
DROP CONSTRAINT  FK_crv_underlying_cu_bond
;
ALTER TABLE cu_bondspread
DROP CONSTRAINT  FK_crv_und_cu_bdsprd
;
ALTER TABLE cu_moneymarket
DROP CONSTRAINT  FK_crv_und_cu_mmkt
;
ALTER TABLE cu_cds
DROP CONSTRAINT  FK_crv_underlying_cu_cds
;
ALTER TABLE cu_fx_forward
DROP CONSTRAINT  FK_crv_und_cu_fx_fwd
;
ALTER TABLE cu_eto
DROP CONSTRAINT  FK_crv_underlying_cu_eto
;
ALTER TABLE cu_eto
DROP CONSTRAINT  FK_eto_contract_cu_eto
;
ALTER TABLE cu_equity_index
DROP CONSTRAINT  FK_crv_und_cu_eqty_idx
;
ALTER TABLE cu_eq_index_fut
DROP CONSTRAINT  FK_crv_und_cu_eq_idx_fut
;
ALTER TABLE vol_surf_param
DROP CONSTRAINT  FK_vol_surf_vol_surf_prm
;
ALTER TABLE vol_surface_tenor
DROP CONSTRAINT  FK_vol_surf_vol_surf_tenor
;
ALTER TABLE vol_surf_exptenor
DROP CONSTRAINT  FK_vol_surf_vol_surf_exptenor
;
ALTER TABLE vol_surface_strike
DROP CONSTRAINT  FK_vol_surf_vol_surf_strike
;
ALTER TABLE vol_surface_point
DROP CONSTRAINT  FK_vol_surf_vol_surf_point
;
ALTER TABLE vol_surface_member
DROP CONSTRAINT  FK_vol_surf_vol_surface_mbr
;
ALTER TABLE vol_surf_qtvalue
DROP CONSTRAINT  FK_vol_surf_vol_surf_qtvalue
;
ALTER TABLE vol_surf_pointadj
DROP CONSTRAINT  FK_vol_surf_pt_vol_surf_ptadj
;
ALTER TABLE vol_pt_blob
DROP CONSTRAINT  FK_vol_surf_vol_pt_blob
;
ALTER TABLE surface_spc_date
DROP CONSTRAINT  FK_vol_surf_surface_spc_date
;
ALTER TABLE vol_surf_und_cap
DROP CONSTRAINT  FK_vol_surf_v_s_u_cap
;
ALTER TABLE vol_surf_und_swpt
DROP CONSTRAINT  FK_vol_surf_v_s_u_swpt
;
ALTER TABLE corr_first_axis
DROP CONSTRAINT  FK_corr_matrix_corr_first_axis
;
ALTER TABLE corr_second_axis
DROP CONSTRAINT  FK_corr_mtrx_corr_secd_axis
;
ALTER TABLE corr_tenor_axis
DROP CONSTRAINT  FK_corr_mtrx_corr_tenor_axis
;
ALTER TABLE group_access
DROP CONSTRAINT  FK_user_grp_nm_grp_access
;
ALTER TABLE usr_access_perm
DROP CONSTRAINT  FK_user_nm_usr_access_perm
;
ALTER TABLE user_password
DROP CONSTRAINT  FK_user_nm_user_password
;
ALTER TABLE passwd_history
DROP CONSTRAINT  FK_user_nm_passwd_history
;
ALTER TABLE access_product
DROP CONSTRAINT  FK_user_grp_nm_access_prd
;
ALTER TABLE perm_book_currency
DROP CONSTRAINT  FK_bk_perm_bk_ccy
;
ALTER TABLE perm_book_cur_pair
DROP CONSTRAINT  FK_bk_perm_bk_cur_pair
;
ALTER TABLE user_defaults
DROP CONSTRAINT  FK_user_nm_user_defaults
;
ALTER TABLE user_last_login
DROP CONSTRAINT  FK_user_nm_user_last_login
;
ALTER TABLE user_login_att
DROP CONSTRAINT  FK_user_nm_user_login_att
;
ALTER TABLE user_login_hist
DROP CONSTRAINT  FK_user_nm_user_login_hist
;
ALTER TABLE work_space_books
DROP CONSTRAINT  FK_wrk_wrk_bks
;
ALTER TABLE work_space_books
DROP CONSTRAINT  FK_bk_wrk_bks
;
ALTER TABLE work_space_bundles
DROP CONSTRAINT  FK_trd_bdl_wrk_bdls
;
ALTER TABLE work_space_bundles
DROP CONSTRAINT  FK_wrk_wrk_bdls
;
ALTER TABLE work_space_trades
DROP CONSTRAINT  FK_trd_wrk_trds
;
ALTER TABLE work_space_trades
DROP CONSTRAINT  FK_wrk_wrk_trds
;
ALTER TABLE work_space_port
DROP CONSTRAINT  FK_trd_flt_wrk_port
;
ALTER TABLE work_space_port
DROP CONSTRAINT  FK_wrk_wrk_port
;
ALTER TABLE work_space_filters
DROP CONSTRAINT  FK_flt_set_wrk_filters
;
ALTER TABLE work_space_filters
DROP CONSTRAINT  FK_wrk_wrk_filters
;
ALTER TABLE work_space_child
DROP CONSTRAINT  FK_wrk_wrk_child
;
ALTER TABLE work_space_child
DROP CONSTRAINT  FK_wrk_wrk_child_name
;
ALTER TABLE user_viewer_book
DROP CONSTRAINT  FK_bk_user_vwr_bk
;
ALTER TABLE user_viewer_book
DROP CONSTRAINT  FK_user_nm_user_vwr_bk
;
ALTER TABLE user_viewer_bundle
DROP CONSTRAINT  FK_bdl_user_vwr_bdl
;
ALTER TABLE user_viewer_bundle
DROP CONSTRAINT  FK_user_nm_user_vwr_bdl
;
ALTER TABLE user_viewer_le
DROP CONSTRAINT  FK_legal_entity_user_vwr_le
;
ALTER TABLE user_viewer_le
DROP CONSTRAINT  FK_user_nm_user_vwr_le
;
ALTER TABLE user_viewer_ws
DROP CONSTRAINT  FK_wrk_user_vwr_ws
;
ALTER TABLE user_viewer_ws
DROP CONSTRAINT  FK_user_nm_user_vwr_ws
;
ALTER TABLE user_viewer_port
DROP CONSTRAINT  FK_trd_flt_user_vwr_port
;
ALTER TABLE user_viewer_port
DROP CONSTRAINT  FK_user_nm_user_vwr_port
;
ALTER TABLE user_viewer_mitem
DROP CONSTRAINT  FK_user_nm_user_vwr_mitm
;
ALTER TABLE user_viewer_column
DROP CONSTRAINT  FK_user_nm_user_vwr_column
;
ALTER TABLE user_viewer_def
DROP CONSTRAINT  FK_user_nm_user_vwr_def
;
ALTER TABLE user_viewer_prop
DROP CONSTRAINT  FK_user_nm_user_vwr_prop
;
ALTER TABLE trade_filter_crit
DROP CONSTRAINT  FK_trd_flt_trd_filter_crit
;
ALTER TABLE trade_filt_min_max
DROP CONSTRAINT  FK_trd_flt_trd_filt_min_max
;
ALTER TABLE trfilter_minmax_dt
DROP CONSTRAINT  FK_trd_flt_trfilter_minmax_dt
;
ALTER TABLE legal_entity_role
DROP CONSTRAINT  FK_legal_ent_legal_ent_role
;
ALTER TABLE le_contact
DROP CONSTRAINT  FK_legal_entity_le_contact
;
ALTER TABLE le_agreement_field
DROP CONSTRAINT  FK_le_legal_agr_le_agr_fld
;
ALTER TABLE le_agr_child
DROP CONSTRAINT  FK_le_legal_agr_le_agr_child
;
ALTER TABLE sec_lend_legal
DROP CONSTRAINT  FK_le_legal_agr_sec_lend_legal
;
ALTER TABLE sec_lend_country
DROP CONSTRAINT  FK_sec_lend_leg_sec_lend_ctr
;
ALTER TABLE le_agr_child
DROP CONSTRAINT  FK_legal_ent_le_agr_child
;
ALTER TABLE le_registration
DROP CONSTRAINT  FK_legal_ent_le_regst
;
ALTER TABLE le_role_disabled
DROP CONSTRAINT  FK_legal_entity_le_role_dis_p
;
ALTER TABLE le_role_disabled
DROP CONSTRAINT  FK_legal_entity_le_role_dis_l
;
ALTER TABLE le_attribute
DROP CONSTRAINT  FK_legal_ent_le_attr
;
ALTER TABLE mrgcall_cashpos
DROP CONSTRAINT  FK_mrgcall_cfg_mrgcall_cashpos
;
ALTER TABLE mrgcall_secpos
DROP CONSTRAINT  FK_mrgcall_cfg_mrgcall_secpos
;
ALTER TABLE mrgcall_field
DROP CONSTRAINT  FK_mrgcall_cfg_mrgcall_field
;
ALTER TABLE ticker_keyword
DROP CONSTRAINT  FK_ticker_ticker_keyword
;
ALTER TABLE book_attr_value
DROP CONSTRAINT  FK_bk_attribute_bk_attr_value
;
ALTER TABLE book_attr_value
DROP CONSTRAINT  FK_bk_bk_attr_value
;
ALTER TABLE book_val_ccy
DROP CONSTRAINT  FK_bk_bk_val_ccy
;
ALTER TABLE book_val_ccy
DROP CONSTRAINT  FK_prd_desc_bk_val_ccy
;
ALTER TABLE acc_book_rule_link
DROP CONSTRAINT  FK_acc_bk_acc_bk_rl_link
;
ALTER TABLE acc_book_rule_link
DROP CONSTRAINT  FK_acc_rl_acc_bk_rl_link
;
ALTER TABLE acc_rule_date
DROP CONSTRAINT  FK_acc_rl_acc_rl_date
;
ALTER TABLE acc_rule_config
DROP CONSTRAINT  FK_acc_rl_acc_rl_cfg
;
ALTER TABLE balance_position
DROP CONSTRAINT  FK_acc_account_bal_pos
;
ALTER TABLE holiday_code_rule
DROP CONSTRAINT  FK_hldy_code_hldy_code_rl
;
ALTER TABLE holiday_code_rule
DROP CONSTRAINT  FK_hldy_rl_hldy_code_rl
;
ALTER TABLE filter_set_element
DROP CONSTRAINT  FK_flt_set_filter_set_element
;
ALTER TABLE filter_set_domain
DROP CONSTRAINT  FK_flt_set_elmt_filt_set_dom
;
ALTER TABLE sd_filter_element
DROP CONSTRAINT  FK_sd_filt_sd_filt_elmt
;
ALTER TABLE sd_filter_domain
DROP CONSTRAINT  FK_sd_filt_elmnt_sd_filt_dom
;
ALTER TABLE disp_calc
DROP CONSTRAINT  FK_disp_cfg_disp_calc
;
ALTER TABLE limit_config_node
DROP CONSTRAINT  FK_limit_cfg_limit_cfg_node
;
ALTER TABLE limit_config_limit
DROP CONSTRAINT  FK_lmt_cfg_node_lmt_cfg_lmt
;
ALTER TABLE limit_crit_group
DROP CONSTRAINT  FK_lmt_cfg_node_lmt_crit_grp
;
ALTER TABLE sched_task_attr
DROP CONSTRAINT  FK_sched_task_sched_task_attr
;
ALTER TABLE sched_task_exec
DROP CONSTRAINT  FK_sched_task_sched_task_exec
;
ALTER TABLE manual_party_sdi
DROP CONSTRAINT  FK_manual_sdi_manual_party_sdi
;
ALTER TABLE manual_sdi_attr
DROP CONSTRAINT  FK_manual_sdi_manual_sdi_attr
;
ALTER TABLE le_settle_delivery
DROP CONSTRAINT  FK_legal_entity_le_stl_dlv
;
ALTER TABLE sdi_relationship
DROP CONSTRAINT  FK_le_stl_dlv_sdi_relationship
;
ALTER TABLE sdi_attribute
DROP CONSTRAINT  FK_le_stl_dlv_sdi_attribute
;
ALTER TABLE currency_benchmark
DROP CONSTRAINT  FK_prd_desc_ccy_benchmark
;
ALTER TABLE task_book_config
DROP CONSTRAINT  FK_user_grp_nm_task_bk_cfg
;
ALTER TABLE task_event_config
DROP CONSTRAINT  FK_user_grp_nm_task_event_cfg
;
ALTER TABLE prod_exch_code
DROP CONSTRAINT  FK_prd_equity_prod_exch_code 
;
ALTER TABLE product_sec_code
DROP CONSTRAINT  FK_prd_desc_prd_sec_code
;
ALTER TABLE cash_settle_info
DROP CONSTRAINT  FK_prd_desc_cash_settle_info
;
ALTER TABLE cash_settle_date
DROP CONSTRAINT  FK_cash_st_info_cash_st_dt
;
ALTER TABLE template_product
DROP CONSTRAINT  FK_prd_desc_template_prd
;
ALTER TABLE template_dates
DROP CONSTRAINT  FK_template_prd_template_date
;
ALTER TABLE product_holding
DROP CONSTRAINT  FK_prd_desc_prd_holding
;
ALTER TABLE product_simplexfer
DROP CONSTRAINT  FK_prd_desc_prd_simplexfer
;
ALTER TABLE product_custxfer
DROP CONSTRAINT  FK_prd_desc_prd_custxfer
;
ALTER TABLE product_custxfer
DROP CONSTRAINT  FK_prd_custxfer_le_stl_dlv
;
ALTER TABLE product_custxfer
DROP CONSTRAINT  FK_prd_custxfer_le_stl_dlv1
;
ALTER TABLE product_xferagent
DROP CONSTRAINT  FK_prd_desc_prd_xferagent
;
ALTER TABLE product_xferagent
DROP CONSTRAINT  FK_prd_xferagent_le_stl_dlv
;
ALTER TABLE product_xferagent
DROP CONSTRAINT  FK_prd_xferagent_le_stl_dlv1
;
ALTER TABLE product_fx
DROP CONSTRAINT  FK_prd_desc_prd_fx
;
ALTER TABLE product_fx
DROP CONSTRAINT  FK_ccy_pair_prd_fx
;
ALTER TABLE product_fx_option
DROP CONSTRAINT  FK_prd_fx_opt_prd_fx
;
ALTER TABLE asian_parameters
DROP CONSTRAINT  FK_prd_desc_asian_prmeters
;
ALTER TABLE asian_reset_dates
DROP CONSTRAINT  FK_prd_desc_asian_reset_dates
;
ALTER TABLE barrier_parameters
DROP CONSTRAINT  FK_prd_desc_barrier_prmeters
;
ALTER TABLE product_cmpd_opt
DROP CONSTRAINT  FK_prd_desc_prd_cmpd_opt
;
ALTER TABLE product_cmpd_opt
DROP CONSTRAINT  FK_prd_desc_prd_cmpd_opt_u
;
ALTER TABLE product_fx_opt_fwd
DROP CONSTRAINT  FK_prd_fx_prd_fx_opt_fwd
;
ALTER TABLE product_fx_opt_fwd
DROP CONSTRAINT  FK_prd_desc_prd_fx_opt_fwd
;
ALTER TABLE product_fx_takeup
DROP CONSTRAINT  FK_prd_fx_prd_fx_takeup
;
ALTER TABLE product_fx_takeup
DROP CONSTRAINT  FK_prd_desc_prd_fx_takeup
;
ALTER TABLE product_fxoptstrip
DROP CONSTRAINT  FK_prd_fx_prd_fxoptstrip
;
ALTER TABLE product_fxoptstrip
DROP CONSTRAINT  FK_prd_desc_prd_fxoptstrip
;
ALTER TABLE product_fx_forward
DROP CONSTRAINT  FK_prd_fx_prd_fx_forward
;
ALTER TABLE product_fx_forward
DROP CONSTRAINT  FK_prd_desc_prd_fx_forward
;
ALTER TABLE product_fx_cash
DROP CONSTRAINT  FK_prd_fx_prd_fx_cash
;
ALTER TABLE product_fx_cash
DROP CONSTRAINT  FK_prd_desc_prd_fx_cash
;
ALTER TABLE fx_cash_flow
DROP CONSTRAINT  FK_prd_fx_cash_fx_cash_flow
;
ALTER TABLE product_fx_ndf
DROP CONSTRAINT  FK_prd_fx_prd_fx_ndf
;
ALTER TABLE product_fx_ndf
DROP CONSTRAINT  FK_prd_desc_prd_fx_ndf
;
ALTER TABLE product_fx_ndf
DROP CONSTRAINT  FK_prd_fx_ndf_fx_reset
;
ALTER TABLE product_fx_swap
DROP CONSTRAINT  FK_prd_fx_prd_fx_swap
;
ALTER TABLE product_fx_swap
DROP CONSTRAINT  FK_prd_desc_prd_fx_swap
;
ALTER TABLE product_mmkt
DROP CONSTRAINT  FK_prd_desc_prd_mmkt
;
ALTER TABLE product_simple_mm
DROP CONSTRAINT  FK_prd_desc_prd_simple_mm
;
ALTER TABLE product_call_not
DROP CONSTRAINT  FK_prd_desc_prd_call_not
;
ALTER TABLE product_commod_mm
DROP CONSTRAINT  FK_prd_desc_prd_commod_mm
;
ALTER TABLE product_simplerepo
DROP CONSTRAINT  FK_prd_desc_prd_simplerepo
;
ALTER TABLE product_simplerepo
DROP CONSTRAINT  FK_prd_desc_prd_simplerepo_s
;
ALTER TABLE product_repo
DROP CONSTRAINT  FK_prd_desc_prd_repo
;
ALTER TABLE product_collateral
DROP CONSTRAINT  FK_prd_desc_prd_cltl
;
ALTER TABLE product_cash
DROP CONSTRAINT  FK_prd_desc_prd_cash
;
ALTER TABLE product_repo
DROP CONSTRAINT  FK_prd_cash_prd_repo
;
ALTER TABLE repo_collateral
DROP CONSTRAINT  FK_prd_repo_repo_cltl
;
ALTER TABLE repo_collateral
DROP CONSTRAINT  FK_prd_cltl_repo_cltl
;
ALTER TABLE product_jgb_repo
DROP CONSTRAINT  FK_prd_repo_prd_jgb_repo
;
ALTER TABLE product_bond
DROP CONSTRAINT  FK_prd_desc_prd_bond
;
ALTER TABLE bond_info
DROP CONSTRAINT  FK_prd_bond_bond_info
;
ALTER TABLE bond_info_syndic
DROP CONSTRAINT  FK_prd_bond_bond_info_syndic
;
ALTER TABLE lottery_win_date
DROP CONSTRAINT  FK_prd_bond_lottery_win_date
;
ALTER TABLE bond_guarantee
DROP CONSTRAINT  FK_prd_bond_bond_guarantee
;
ALTER TABLE bond_asset_backed
DROP CONSTRAINT  FK_prd_bond_bond_asset_backed
;
ALTER TABLE bond_convertible
DROP CONSTRAINT  FK_prd_bond_bond_convertible
;
ALTER TABLE conversion_reset
DROP CONSTRAINT  FK_bond_convert_cnv_reset
;
ALTER TABLE bond_pool_factor
DROP CONSTRAINT  FK_prd_bond_bond_pool_factor
;
ALTER TABLE product_bond_opt
DROP CONSTRAINT  FK_prd_desc_prd_bond_opt
;
ALTER TABLE product_bond_opt
DROP CONSTRAINT  FK_prd_bond_prd_bond_opt
;
ALTER TABLE product_bondspread
DROP CONSTRAINT  FK_prd_bond_prd_bondsprd
;
ALTER TABLE product_bondspread
DROP CONSTRAINT  FK_prd_desc_prd_bondspread
;
ALTER TABLE product_bsb
DROP CONSTRAINT  FK_prd_desc_prd_bsb
;
ALTER TABLE product_issuance
DROP CONSTRAINT  FK_prd_desc_prd_issuance
;
ALTER TABLE product_issuance
DROP CONSTRAINT  FK_prd_desc_prd_issuance_s
;
ALTER TABLE product_seclending
DROP CONSTRAINT  FK_prd_desc_prd_seclending
;
ALTER TABLE seclending_col
DROP CONSTRAINT  FK_prd_seclending_seclend_col
;
ALTER TABLE seclending_col
DROP CONSTRAINT  FK_prd_cltl_seclending_col
;
ALTER TABLE product_tlock
DROP CONSTRAINT  FK_prd_desc_prd_tlock
;
ALTER TABLE product_future
DROP CONSTRAINT  FK_prd_desc_prd_future
;
ALTER TABLE product_future
DROP CONSTRAINT  FK_future_contract_prd_future
;
ALTER TABLE future_ctd
DROP CONSTRAINT  FK_future_contract_future_ctd
;
ALTER TABLE product_fut_opt
DROP CONSTRAINT  FK_opt_contract_prd_fut_opt
;
ALTER TABLE product_swap
DROP CONSTRAINT  FK_prd_desc_prd_swap
;
ALTER TABLE product_swap
DROP CONSTRAINT  FK_prd_swap_swap_leg
;
ALTER TABLE product_swap
DROP CONSTRAINT  FK_prd_swap_swap_leg1
;
ALTER TABLE termination_date
DROP CONSTRAINT  FK_prd_desc_trm_date
;
ALTER TABLE put_call_date
DROP CONSTRAINT  FK_prd_desc_put_call_date
;
ALTER TABLE payout_formula
DROP CONSTRAINT  FK_swap_leg_payout_formula
;
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_swap_leg_n_sch
;
ALTER TABLE swaption_ext_info
DROP CONSTRAINT  FK_prd_swption_swption_ext_in
;
ALTER TABLE xccy_swap_ext_info
DROP CONSTRAINT  FK_prd_swp_xccy_swap_ext_info
;
ALTER TABLE product_cap_floor
DROP CONSTRAINT  FK_prd_desc_prd_cap_floor
;
ALTER TABLE cap_swap_ext_info
DROP CONSTRAINT  FK_prd_swap_cap_swap_ext_info
;
ALTER TABLE product_structured
DROP CONSTRAINT  FK_prd_desc_prd_structured
;
ALTER TABLE basic_product
DROP CONSTRAINT  FK_prd_desc_basic_prd
;
ALTER TABLE basic_product
DROP CONSTRAINT  FK_prd_desc_basic_prd_b
;
ALTER TABLE basic_prod_keyword
DROP CONSTRAINT  FK_basic_prd_basic_prd_kwd
;
ALTER TABLE product_fra
DROP CONSTRAINT  FK_prd_desc_prd_fra
;
ALTER TABLE product_asset_swap
DROP CONSTRAINT  FK_prd_desc_prd_asset_swap
;
ALTER TABLE product_cds
DROP CONSTRAINT  FK_prd_desc_prd_cds
;
ALTER TABLE product_cds
DROP CONSTRAINT  FK_ref_entity_prd_cds
;
ALTER TABLE termination_events
DROP CONSTRAINT  FK_prd_cds_trm_events
;
ALTER TABLE del_characteristic
DROP CONSTRAINT  FK_prd_cds_del_characteristic
;
ALTER TABLE ref_characteristic
DROP CONSTRAINT  FK_prd_cds_ref_characteristic
;
ALTER TABLE ref_entity_basket
DROP CONSTRAINT  FK_ref_ent_ref_ent_basket
;
ALTER TABLE ref_entity_single
DROP CONSTRAINT  FK_ref_ent_ref_ent_single
;
ALTER TABLE product_cdsnthdflt
DROP CONSTRAINT  FK_prd_cds_prd_cdsnthdflt
;
ALTER TABLE product_cdsnthloss
DROP CONSTRAINT  FK_prd_cds_prd_cdsnthloss
;
ALTER TABLE product_trs
DROP CONSTRAINT  FK_prd_desc_prd_trs
;
ALTER TABLE product_basket
DROP CONSTRAINT  FK_prd_desc_prd_basket
;
ALTER TABLE product_trs_basket
DROP CONSTRAINT  FK_prd_trs_prd_trs_basket
;
ALTER TABLE product_cfd
DROP CONSTRAINT  FK_prd_desc_prd_cfd
;
ALTER TABLE cfd_data
DROP CONSTRAINT  FK_prd_cfd_cfd_data
;
ALTER TABLE product_cfd
DROP CONSTRAINT  FK_cfd_contract_prd_cfd
;
ALTER TABLE cfd_country_attr
DROP CONSTRAINT  FK_cfd_ctry_cfd_ctry_attr
;
ALTER TABLE cfd_contract_attr
DROP CONSTRAINT  FK_cfd_cntr_cfd_cntr_attr
;
ALTER TABLE cfd_detail
DROP CONSTRAINT  FK_cfd_cntrt_cfd_detail
;
ALTER TABLE cfd_detail_rdate
DROP CONSTRAINT  FK_cfd_cntrt_cfd_det_rdate
;
ALTER TABLE cfd_fin_grid
DROP CONSTRAINT  FK_cfd_cntrt_cfd_fin_grid
;
ALTER TABLE cfd_deposit
DROP CONSTRAINT  FK_cfd_cntrt_cfd_deposit
;
ALTER TABLE product_eto
DROP CONSTRAINT  FK_eto_contract_prd_eto
;
ALTER TABLE product_eto
DROP CONSTRAINT  FK_prd_desc_prd_eto
;
ALTER TABLE product_equity
DROP CONSTRAINT  FK_prd_desc_prd_equity
;
ALTER TABLE product_adr
DROP CONSTRAINT  FK_prd_desc_prd_adr
;
ALTER TABLE dividend
DROP CONSTRAINT  FK_prd_desc_dividend
;
ALTER TABLE product_otceqtyopt
DROP CONSTRAINT  FK_prd_otcopt_prd_otceqtyopt
;
ALTER TABLE product_otcoption
DROP CONSTRAINT  FK_prd_desc_prd_otcopt
;
ALTER TABLE product_otceqtyopt
DROP CONSTRAINT  FK_prd_otceqtyopt_fx_reset
;
ALTER TABLE option_deliverable
DROP CONSTRAINT  FK_prd_otcopt_opt_deliverable
;
ALTER TABLE product_otceq_opt
DROP CONSTRAINT  FK_prd_otceopt_prd_otceqtyopt
;
ALTER TABLE eq_linked_leg
DROP CONSTRAINT  FK_prd_els_equity_link_leg
;
ALTER TABLE performance_leg
DROP CONSTRAINT  FK_prd_els_prfm_lg
;
ALTER TABLE initial_prices
DROP CONSTRAINT  FK_prfm_lg_initial_prices
;
ALTER TABLE option_observable
DROP CONSTRAINT  FK_obsrv_opt_obsrv
;
ALTER TABLE kickoff_cfg
DROP CONSTRAINT  FK_wfw_trst_kickoff_cfg
;
ALTER TABLE bo_workflow_rule
DROP CONSTRAINT  FK_wfw_trst_bo_wrkflw_rl
;
ALTER TABLE mapping_status
DROP CONSTRAINT  FK_wfw_trst_mapping_status
;
ALTER TABLE transfer_reconcil
DROP CONSTRAINT  FK_bo_transfer_transfer_recon
;
ALTER TABLE xfer_attributes
DROP CONSTRAINT  FK_bo_transfer_xfer_attributes
;
ALTER TABLE event_trade
DROP CONSTRAINT  FK_ps_event_event_trd
;
ALTER TABLE event_trade
DROP CONSTRAINT  FK_trd_event_trd
;
ALTER TABLE ps_event_inst
DROP CONSTRAINT  FK_ps_event_ps_event_inst
;
ALTER TABLE ps_event_config
DROP CONSTRAINT  FK_ps_evt_cfg_nm_ps_evt_cfg
;
ALTER TABLE ps_event_filter
DROP CONSTRAINT  FK_ps_evt_cfg_nm_ps_evt_filt
;
ALTER TABLE event_transfer
DROP CONSTRAINT  FK_ps_event_event_transfer
;
ALTER TABLE event_transfer
DROP CONSTRAINT  FK_bo_transfer_event_transfer
;
ALTER TABLE event_message
DROP CONSTRAINT  FK_ps_event_event_message
;
ALTER TABLE event_message
DROP CONSTRAINT  FK_bo_message_event_message
;
ALTER TABLE mess_attributes
DROP CONSTRAINT  FK_bo_message_mess_attributes
;
ALTER TABLE event_in_message
DROP CONSTRAINT  FK_bo_in_mess_event_in_mess
;
ALTER TABLE event_posting
DROP CONSTRAINT  FK_ps_event_event_posting
;
ALTER TABLE event_posting
DROP CONSTRAINT  FK_bo_posting_event_posting
;
ALTER TABLE event_posting
DROP CONSTRAINT  FK_trd_event_posting
;
ALTER TABLE event_task
DROP CONSTRAINT  FK_ps_event_event_task
;
ALTER TABLE event_task
DROP CONSTRAINT  FK_bo_task_event_task
;
ALTER TABLE event_plpos
DROP CONSTRAINT  FK_pl_position_event_plpos
;
ALTER TABLE event_liqpos
DROP CONSTRAINT  FK_ps_event_event_liqpos
;
ALTER TABLE event_unliqpos
DROP CONSTRAINT  FK_ps_event_event_unliqpos
;
ALTER TABLE event_cre
DROP CONSTRAINT  FK_ps_event_event_cre
;
ALTER TABLE event_cre
DROP CONSTRAINT  FK_bo_cre_event_cre
;
ALTER TABLE bo_cre
DROP CONSTRAINT  FK_trd_bo_cre 
;
ALTER TABLE bo_cre
DROP CONSTRAINT  FK_prd_desc_bo_cre
;
ALTER TABLE cre_attribute
DROP CONSTRAINT  FK_bo_cre_cre_attribute
;
ALTER TABLE mutation_attr
DROP CONSTRAINT  FK_mutation_mutation_attr
;
ALTER TABLE mutation_flow
DROP CONSTRAINT  FK_mutation_mutation_flow
;
ALTER TABLE cre_amount
DROP CONSTRAINT  FK_bo_cre_cre_amount
;
ALTER TABLE scenario_items
DROP CONSTRAINT  FK_scenario_rl_scenario_itms
;
ALTER TABLE tree_node
DROP CONSTRAINT  FK_tree_nm_tree_node
;
ALTER TABLE scenario_report
DROP CONSTRAINT  FK_scenario_view_scn_report
;
ALTER TABLE bo_posting
DROP CONSTRAINT  FK_bo_posting_prd_desc
;
ALTER TABLE bo_posting
DROP CONSTRAINT  FK_bo_posting_trd
;
ALTER TABLE cap_swap_ext_info
DROP CONSTRAINT  FK_cap_swap_ext_info_prd_desc
;
ALTER TABLE currency_pair
DROP CONSTRAINT  FK_ccy_pair_ccy_default
;
ALTER TABLE currency_pair
DROP CONSTRAINT  FK_ccy_pair_ccy_default1
;
ALTER TABLE curve_member_link
DROP CONSTRAINT  FK_crv_mbr_link_crv
;
ALTER TABLE curve_member_link
DROP CONSTRAINT  FK_crv_mbr_link_crv_underlying
;
ALTER TABLE curve_member_rt
DROP CONSTRAINT  FK_crv_mbr_rt_crv_underlying
;
ALTER TABLE event_transfer
DROP CONSTRAINT  FK_event_transfer_trd
;
ALTER TABLE fx_reset
DROP CONSTRAINT  FK_fx_reset_ccy_default
;
ALTER TABLE fx_reset
DROP CONSTRAINT  FK_fx_reset_ccy_default1
;
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_asset_swap
;
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_cds
;
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_els
;
ALTER TABLE notional_schedule
DROP CONSTRAINT  FK_n_sch_prd_swap
;
ALTER TABLE product_bond
DROP CONSTRAINT  FK_prd_bond_legal_entity
;
ALTER TABLE product_eto
DROP CONSTRAINT  FK_prd_eto_prd_desc
;
ALTER TABLE product_fut_opt
DROP CONSTRAINT  FK_prd_fut_opt_prd_desc
;
ALTER TABLE swap_leg
DROP CONSTRAINT  FK_swap_leg_prd_desc 
;
ALTER TABLE task_book_config
DROP CONSTRAINT  FK_task_bk_cfg_bk
;
ALTER TABLE corr_matrix_param ADD
DROP CONSTRAINT FK_corr_matrix_param
;
ALTER TABLE corr_matrix_data ADD
DROP CONSTRAINT FK_corr_matrix_data
;

