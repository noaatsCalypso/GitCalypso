/* This Script has to be run only opn Development version...It is meant only for Database Diagram */
/* **************************************** */
/*  All The Meta Table Relation */
/* **************************************** */
ALTER TABLE main_entry_prop ADD
    CONSTRAINT FK_user_nm_main_entry_prop FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE org_node ADD
    CONSTRAINT FK_org_nm_org_node FOREIGN KEY
    (
     org_name
    ) REFERENCES org_name (
      org_name
    )
go
/* **************************************** */
/*  All The Trade Relation */
/* **************************************** */
ALTER TABLE fee_grid_attr ADD
    CONSTRAINT FK_fee_grid_fee_grid_attr FOREIGN KEY
    (
     fee_grid_id
    ) REFERENCES fee_grid (
      fee_grid_id
    )
go
ALTER TABLE fee_grid ADD
    CONSTRAINT FK_legal_entity_fee_grid FOREIGN KEY
    (
     le_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE trade_fee ADD
    CONSTRAINT FK_fee_definition_trd_fee FOREIGN KEY
    (
     fee_type
    ) REFERENCES fee_definition (
      fee_type
    )
go
ALTER TABLE folder_trades ADD
    CONSTRAINT FK_folder_folder_trds FOREIGN KEY
    (
     folder_id
    ) REFERENCES folder (
      folder_id
    )
go
ALTER TABLE folder_trades ADD
    CONSTRAINT FK_trd_folder_trds FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go

ALTER TABLE folder_shortcut ADD
    CONSTRAINT FK_folder_folder_shortcut FOREIGN KEY
    (
     folder_id
    ) REFERENCES folder (
      folder_id
    )
go
ALTER TABLE folder_shortcut ADD
    CONSTRAINT FK_folder_folder_shortcut_s FOREIGN KEY
    (
     sc_folder_id
    ) REFERENCES folder (
      folder_id
    )
go
ALTER TABLE trade ADD
    CONSTRAINT FK_prd_desc_trd FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE trade ADD
    CONSTRAINT FK_trd_bk FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go
ALTER TABLE trade ADD
    CONSTRAINT FK_legal_entity_trd FOREIGN KEY
    (
     cpty_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE trade_keyword ADD
    CONSTRAINT FK_trd_trd_keyword FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE trade_note ADD
    CONSTRAINT FK_trd_trd_note FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE trade_price ADD
    CONSTRAINT FK_trd_trd_price FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE trade_role_alloc ADD
    CONSTRAINT FK_trd_trd_role_alloc FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE trade_open_qty ADD
    CONSTRAINT FK_trd_trd_open_qty FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE trade_open_qty ADD
    CONSTRAINT FK_prd_desc_trd_open_qty FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

/* **************************************** */
/* CashFlow Relation */
/* **************************************** */
ALTER TABLE cash_flow_simple ADD
    CONSTRAINT FK_prd_desc_cash_flow_simple FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_flow_compound ADD
    CONSTRAINT FK_prd_desc_cash_flow_compound FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_flow_option ADD
    CONSTRAINT FK_prd_desc_cash_flow_opt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_flow_coupon ADD
    CONSTRAINT FK_prd_desc_cash_flow_coupon FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_flow_prin_adj ADD
    CONSTRAINT FK_prd_desc_cash_flow_prin_adj FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_flow_optcpn ADD
    CONSTRAINT FK_prd_desc_cash_flow_optcpn FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_flow_prichg ADD
    CONSTRAINT FK_prd_desc_cash_flow_prichg FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_flow_div ADD
    CONSTRAINT FK_prd_desc_cash_flow_div FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

/* **************************************** */
/* Engines Relation */
/* **************************************** */
ALTER TABLE liq_position ADD
    CONSTRAINT FK_trd_liq_position_f FOREIGN KEY
    (
     first_trade
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE liq_position ADD
    CONSTRAINT FK_trd_liq_position_s FOREIGN KEY
    (
     second_trade
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE pl_position ADD
    CONSTRAINT FK_prd_desc_pl_position FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE pl_position ADD
    CONSTRAINT FK_bk_pl_position FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go

/* ************************************************** */
/* Analysis Relation */
/* ************************************************** */
ALTER TABLE an_param_items ADD
    CONSTRAINT FK_analysis_prm_an_prm_itms FOREIGN KEY
    (
     param_name,class_name
    ) REFERENCES analysis_param (
      param_name,class_name
    )
go
ALTER TABLE an_og_rp_hedges ADD
    CONSTRAINT FK_an_prm_an_og_rp_hedges FOREIGN KEY
    (
     param_name,class_name
    ) REFERENCES analysis_param (
      param_name,class_name
    )
go
ALTER TABLE an_og_report ADD
    CONSTRAINT FK_an_prm_itms_an_og_report FOREIGN KEY
    (
     param_name,class_name
    ) REFERENCES analysis_param (
      param_name,class_name
    )
go
ALTER TABLE an_synth_hedge ADD
    CONSTRAINT FK_analysis_prm_an_synth_hedge FOREIGN KEY
    (
     param_name,class_name
    ) REFERENCES analysis_param (
      param_name,class_name
    )
go
ALTER TABLE an_bhng_bucket ADD
    CONSTRAINT FK_analysis_prm_an_bhng_bucket FOREIGN KEY
    (
     param_name,class_name
    ) REFERENCES analysis_param (
      param_name,class_name
    )
go

ALTER TABLE an_bhng_rp_hedges ADD
    CONSTRAINT FK_an_bhng_bck_an_bhng_rp_hdg FOREIGN KEY
    (
     param_name,class_name,product_id
    ) REFERENCES an_bhng_bucket (
      param_name,class_name,product_id
    )
go

ALTER TABLE an_bhng_ulbucket ADD
    CONSTRAINT FK_an_bhng_bck_an_bhng_ulbck FOREIGN KEY
    (
     param_name,class_name,product_id
    ) REFERENCES an_bhng_bucket (
      param_name,class_name,product_id
    )
go
ALTER TABLE risk_config ADD
    CONSTRAINT FK_user_nm_risk_cfg FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE an_bh_bucket ADD
    CONSTRAINT FK_analysis_prm_an_bh_bucket FOREIGN KEY
    (
     param_name,class_name
    ) REFERENCES analysis_param (
      param_name,class_name
    )
go
ALTER TABLE an_bh_hedge ADD
    CONSTRAINT FK_analysis_prm_an_bh_hedge FOREIGN KEY
    (
     param_name,class_name
    ) REFERENCES analysis_param (
      param_name,class_name
    )
go

/* **************************************** */
/* Market Data Relation Curve Relation */
/* **************************************** */
/* Pricing Parameter Relation  */
ALTER TABLE pricing_param_items ADD
    CONSTRAINT FK_prcg_prm_prcg_prm_itm FOREIGN KEY
    (
     pricing_param_name
    ) REFERENCES pricing_param (
      pricing_param_name
    )
go

ALTER TABLE pricing_param_items ADD
    CONSTRAINT FK_prcg_prm_nm_prcg_prm_itm FOREIGN KEY
    (
     attribute_name
    ) REFERENCES pricing_param_name (
      param_name
    )
go
ALTER TABLE pricing_env ADD
    CONSTRAINT FK_prcg_env_prcg_prm FOREIGN KEY
    (
     pricing_param_name
    ) REFERENCES pricing_param (
      pricing_param_name
    )
go

ALTER TABLE pricing_env ADD
    CONSTRAINT FK_prcg_env_pricer_cfg FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pricing_env ADD 
	CONSTRAINT FK_prcg_env_quote_set FOREIGN KEY 
	(
		quote_set_name
	) REFERENCES quote_set (
		quote_set_name
    )
go
ALTER TABLE pc_pricer  ADD
    CONSTRAINT FK_pricer_cfg_pc_pricer  FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_discount ADD
    CONSTRAINT FK_pricer_cfg_pc_discount FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_forecast ADD
    CONSTRAINT FK_pricer_cfg_pc_forecast FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_surface ADD
    CONSTRAINT FK_pricer_cfg_pc_surface FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_fx ADD
    CONSTRAINT FK_pricer_cfg_pc_fx FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_repo ADD
    CONSTRAINT FK_pricer_cfg_pc_repo FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_recovery ADD
    CONSTRAINT FK_pricer_cfg_pc_recovery FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_credit_spread ADD
    CONSTRAINT FK_pricer_cfg_pc_credit_spread FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_probability ADD
    CONSTRAINT FK_pricer_cfg_pc_probability FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_prod_specific ADD
    CONSTRAINT FK_pricer_cfg_pc_prod_specific FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go
ALTER TABLE pc_credit_ticker ADD
    CONSTRAINT FK_pricer_cfg_pc_credit_ticker FOREIGN KEY
    (
     pricer_config_name
    ) REFERENCES pricer_config (
      pricer_config_name
    )
go


/* Curve Relation  */
ALTER TABLE curve  ADD
    CONSTRAINT FK_market_data_itm_crv  FOREIGN KEY
    (
     curve_id
    ) REFERENCES market_data_item (
      mdata_id
    )
go
ALTER TABLE curve_tenor ADD
    CONSTRAINT FK_crv_crv_tenor FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_member ADD
    CONSTRAINT FK_crv_crv_mbr FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_member ADD
    CONSTRAINT FK_crv_underlying_crv_mbr FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE curve_member_rt ADD
    CONSTRAINT FK_crv_crv_mbr_rt FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_member_link ADD
    CONSTRAINT FK_crv_mbr_rt_crv_mbr_link FOREIGN KEY
    (
     curve_id, curve_date,cu_id
    ) REFERENCES curve_member_rt (
      curve_id, curve_date,cu_id
    )
go
ALTER TABLE curve_point ADD
    CONSTRAINT FK_crv_crv_point FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_point_adj ADD
    CONSTRAINT FK_crv_point_crv_point_adj FOREIGN KEY
    (
     curve_id,curve_date,curve_offset
    ) REFERENCES curve_point (
      curve_id,curve_date,curve_offset
    )
go
ALTER TABLE curve_recovery ADD
    CONSTRAINT FK_crv_crv_recovery FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_probability ADD
    CONSTRAINT FK_crv_crv_probability FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE custom_curve_qt ADD
    CONSTRAINT FK_crv_cst_crv_qt FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_def_data ADD
    CONSTRAINT FK_crv_crv_def_data FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_price_hdr ADD
    CONSTRAINT FK_crv_crv_price_hdr FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_div_hdr ADD
    CONSTRAINT FK_crv_crv_div_hdr FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_div_proj ADD
    CONSTRAINT FK_crv_crv_div_proj FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_parameter ADD
    CONSTRAINT FK_crv_crv_prmeter FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_quote_value ADD
    CONSTRAINT FK_crv_crv_quote_value FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve (
      curve_id,curve_date
    )
go
ALTER TABLE curve_quote_adj ADD
    CONSTRAINT FK_crv_qt_val_crv_qt_adj FOREIGN KEY
    (
     curve_id,curve_date,quote_name
    ) REFERENCES curve_quote_value (
      curve_id,curve_date,quote_name
    )
go
ALTER TABLE curve_basis_header ADD
    CONSTRAINT FK_crv_crv_basis_header FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_fx_header ADD
    CONSTRAINT FK_crv_crv_fx_header FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_fxd_header ADD
    CONSTRAINT FK_crv_crv_fxd_header FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_spc_date ADD
    CONSTRAINT FK_crv_crv_spc_date FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_repo_header ADD
    CONSTRAINT FK_crv_crv_repo_header FOREIGN KEY
    (
     curve_id,curve_date
    ) REFERENCES curve  (
      curve_id,curve_date
    )
go
ALTER TABLE curve_repo_header ADD
    CONSTRAINT FK_prd_desc_crv_repo_header FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE vol_surface ADD
    CONSTRAINT FK_vol_surface FOREIGN KEY
    (
     vol_surface_id
    ) REFERENCES market_data_item   (
      mdata_id
    )
go

ALTER TABLE vol_surface_tenor ADD
    CONSTRAINT FK_vol_surface_tenor FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go


ALTER TABLE vol_surface_point ADD
    CONSTRAINT FK_vol_surface_point FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go


ALTER TABLE vol_surf_pointadj ADD
    CONSTRAINT FK_vol_surf_pointadj FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go



ALTER TABLE vol_pt_blob ADD
    CONSTRAINT FK_vol_pt_blob FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go



ALTER TABLE vol_surf_param ADD
    CONSTRAINT FK_vol_surf_param FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go




ALTER TABLE vol_surf_qtvalue ADD
    CONSTRAINT FK_vol_surf_qtvalue FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go



ALTER TABLE vol_surf_exptenor ADD
    CONSTRAINT FK_vol_surf_exptenor FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go



ALTER TABLE vol_surface_strike ADD
    CONSTRAINT FK_vol_surface_strike FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go

ALTER TABLE surface_spc_date ADD
    CONSTRAINT FK_surface_spc_date FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go


ALTER TABLE vol_surface_member ADD
    CONSTRAINT FK_vol_surface_member FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface  (
      vol_surface_id,vol_surface_date
    )
go


ALTER TABLE correlation_matrix ADD
    CONSTRAINT FK_correlation_matrix FOREIGN KEY
    (
     matrix_id
    ) REFERENCES market_data_item   (
      mdata_id
    )
go
ALTER TABLE corr_first_axis  ADD
    CONSTRAINT FK_corr_first_axis  FOREIGN KEY
    (
    matrix_id,matrix_datetime
    ) REFERENCES correlation_matrix  (
     matrix_id,matrix_datetime
    )
go
ALTER TABLE corr_second_axis ADD
    CONSTRAINT FK_corr_second_axis FOREIGN KEY
    (
    matrix_id,matrix_datetime
    ) REFERENCES correlation_matrix  (
     matrix_id,matrix_datetime
    )
go
ALTER TABLE corr_tenor_axis ADD
    CONSTRAINT FK_corr_tenor_axis FOREIGN KEY
    (
    matrix_id,matrix_datetime
    ) REFERENCES correlation_matrix  (
     matrix_id,matrix_datetime
    )
go
ALTER TABLE corr_matrix_data ADD
    CONSTRAINT FK_corr_matrix_data FOREIGN KEY
    (
    matrix_id,matrix_datetime
    ) REFERENCES correlation_matrix  (
     matrix_id,matrix_datetime
    )
go
ALTER TABLE corr_matrix_param ADD
    CONSTRAINT FK_corr_matrix_param FOREIGN KEY
    (
    matrix_id,matrix_datetime
    ) REFERENCES correlation_matrix (
     matrix_id,matrix_datetime
    )
go



ALTER TABLE cu_specific_mmkt ADD
    CONSTRAINT FK_crv_ud_cu_spec_mmkt FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_future ADD
    CONSTRAINT FK_crv_underlying_cu_future FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_future ADD
    CONSTRAINT FK_future_contract_cu_future FOREIGN KEY
    (
     contract_id
    ) REFERENCES future_contract (
      contract_id
    )
go
ALTER TABLE cu_fra ADD
    CONSTRAINT FK_crv_underlying_cu_fra FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_swap ADD
    CONSTRAINT FK_crv_underlying_cu_swap FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go

ALTER TABLE cu_basis_swap ADD
    CONSTRAINT FK_crv_und_cu_basis_swap FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_bond ADD
    CONSTRAINT FK_crv_underlying_cu_bond FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_bondspread ADD
    CONSTRAINT FK_crv_und_cu_bdsprd FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_moneymarket ADD
    CONSTRAINT FK_crv_und_cu_mmkt FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_cds ADD
    CONSTRAINT FK_crv_underlying_cu_cds FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_fx_forward ADD
    CONSTRAINT FK_crv_und_cu_fx_fwd FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_eto ADD
    CONSTRAINT FK_crv_underlying_cu_eto FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_eto ADD
    CONSTRAINT FK_eto_contract_cu_eto FOREIGN KEY
    (
     contract_id
    ) REFERENCES eto_contract (
      contract_id
    )
go
ALTER TABLE cu_equity_index ADD
    CONSTRAINT FK_crv_und_cu_eqty_idx FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
ALTER TABLE cu_eq_index_fut ADD
    CONSTRAINT FK_crv_und_cu_eq_idx_fut FOREIGN KEY
    (
     cu_id
    ) REFERENCES curve_underlying (
      cu_id
    )
go
/* ************************************************** */
/* Market Data Relation Volatility Surface */
/* ************************************************** */
ALTER TABLE vol_surf_param ADD
    CONSTRAINT FK_vol_surf_vol_surf_prm FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE vol_surface_tenor ADD
    CONSTRAINT FK_vol_surf_vol_surf_tenor FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go

ALTER TABLE vol_surf_exptenor ADD
    CONSTRAINT FK_vol_surf_vol_surf_exptenor FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE vol_surface_strike ADD
    CONSTRAINT FK_vol_surf_vol_surf_strike FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE vol_surface_point ADD
    CONSTRAINT FK_vol_surf_vol_surf_point FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE vol_surface_member ADD
    CONSTRAINT FK_vol_surf_vol_surface_mbr FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE vol_surf_qtvalue ADD
    CONSTRAINT FK_vol_surf_vol_surf_qtvalue FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE vol_surf_pointadj ADD
    CONSTRAINT FK_vol_surf_pt_vol_surf_ptadj FOREIGN KEY
    (
     vol_surface_id,vol_surface_date,vol_surface_expiry,vol_surface_tenor,vol_surface_strike
    ) REFERENCES vol_surface_point (
      vol_surface_id,vol_surface_date,vol_surface_expiry,vol_surface_tenor,vol_surface_strike
    )
go
ALTER TABLE vol_pt_blob ADD
    CONSTRAINT FK_vol_surf_vol_pt_blob FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE surface_spc_date ADD
    CONSTRAINT FK_vol_surf_surface_spc_date FOREIGN KEY
    (
     vol_surface_id,vol_surface_date
    ) REFERENCES vol_surface (
      vol_surface_id,vol_surface_date
    )
go
ALTER TABLE vol_surf_und_cap ADD
    CONSTRAINT FK_vol_surf_v_s_u_cap FOREIGN KEY
    (
     vol_surf_und_id
    ) REFERENCES vol_surf_und (
      vol_surf_und_id
    )
go
ALTER TABLE vol_surf_und_swpt ADD
    CONSTRAINT FK_vol_surf_v_s_u_swpt FOREIGN KEY
    (
     vol_surf_und_id
    ) REFERENCES vol_surf_und (
     vol_surf_und_id
    )
go

/* ************************************************** */
/* Market Data Corrleation Matricie Relation */
/* ************************************************** */
ALTER TABLE corr_first_axis ADD
    CONSTRAINT FK_corr_matrix_corr_first_axis FOREIGN KEY
    (
     matrix_id, matrix_datetime
    ) REFERENCES correlation_matrix (
      matrix_id, matrix_datetime
    )
go
ALTER TABLE corr_second_axis ADD
    CONSTRAINT FK_corr_mtrx_corr_secd_axis FOREIGN KEY
    (
     matrix_id, matrix_datetime
    ) REFERENCES correlation_matrix (
      matrix_id, matrix_datetime
    )
go
ALTER TABLE corr_tenor_axis ADD
    CONSTRAINT FK_corr_mtrx_corr_tenor_axis FOREIGN KEY
    (
     matrix_id, matrix_datetime
    ) REFERENCES correlation_matrix (
      matrix_id, matrix_datetime
    )
go
/* ************************************************** */
/* UserAccessPermission Relation and User Related */
/* ************************************************** */
ALTER TABLE group_access ADD
    CONSTRAINT FK_user_grp_nm_grp_access FOREIGN KEY
    (
     group_name
    ) REFERENCES user_group_name (
      group_name
    )
go
ALTER TABLE usr_access_perm ADD
    CONSTRAINT FK_user_nm_usr_access_perm FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_password ADD
    CONSTRAINT FK_user_nm_user_password FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE passwd_history ADD
    CONSTRAINT FK_user_nm_passwd_history FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE access_product ADD
    CONSTRAINT FK_user_grp_nm_access_prd FOREIGN KEY
    (
     group_name
    ) REFERENCES user_group_name (
      group_name
    )
go
ALTER TABLE perm_book_currency ADD
    CONSTRAINT FK_bk_perm_bk_ccy FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go
ALTER TABLE perm_book_cur_pair ADD
    CONSTRAINT FK_bk_perm_bk_cur_pair FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go
ALTER TABLE user_defaults ADD
    CONSTRAINT FK_user_nm_user_defaults FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_last_login ADD
    CONSTRAINT FK_user_nm_user_last_login FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_login_att ADD
    CONSTRAINT FK_user_nm_user_login_att FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_login_hist ADD
    CONSTRAINT FK_user_nm_user_login_hist FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go

/* ************************************************** */
/* UseR Related --> WorkSpace  */
/* ************************************************** */

ALTER TABLE work_space_books ADD
    CONSTRAINT FK_wrk_wrk_bks FOREIGN KEY
    (
     work_space_name
    ) REFERENCES work_space (
      work_space_name
    )
go
ALTER TABLE work_space_books ADD
    CONSTRAINT FK_bk_wrk_bks FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go
ALTER TABLE work_space_bundles ADD
    CONSTRAINT FK_trd_bdl_wrk_bdls FOREIGN KEY
    (
     bundle_id
    ) REFERENCES trade_bundle (
      bundle_id
    )
go
ALTER TABLE work_space_bundles ADD
    CONSTRAINT FK_wrk_wrk_bdls FOREIGN KEY
    (
     work_space_name
    ) REFERENCES work_space (
      work_space_name
    )
go
ALTER TABLE work_space_trades ADD
    CONSTRAINT FK_trd_wrk_trds FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE work_space_trades ADD
    CONSTRAINT FK_wrk_wrk_trds FOREIGN KEY
    (
     work_space_name
    ) REFERENCES work_space (
      work_space_name
    )
go
ALTER TABLE work_space_port ADD
    CONSTRAINT FK_trd_flt_wrk_port FOREIGN KEY
    (
     trade_filter_name
    ) REFERENCES trade_filter (
      trade_filter_name
    )
go
ALTER TABLE work_space_port ADD
    CONSTRAINT FK_wrk_wrk_port FOREIGN KEY
    (
     work_space_name
    ) REFERENCES work_space (
      work_space_name
    )
go
ALTER TABLE work_space_filters ADD
    CONSTRAINT FK_flt_set_wrk_filters FOREIGN KEY
    (
     filter_set_name
    ) REFERENCES filter_set (
      filter_set_name
    )
go
ALTER TABLE work_space_filters ADD
    CONSTRAINT FK_wrk_wrk_filters FOREIGN KEY
    (
     work_space_name
    ) REFERENCES work_space (
      work_space_name
    )
go

ALTER TABLE work_space_child ADD
    CONSTRAINT FK_wrk_wrk_child FOREIGN KEY
    (
     child_name
    ) REFERENCES work_space (
      work_space_name
    )
go
ALTER TABLE work_space_child ADD
    CONSTRAINT FK_wrk_wrk_child_name FOREIGN KEY
    (
     work_space_name
    ) REFERENCES work_space (
      work_space_name
    )
go

/* ************************************************** */
/* User Related --> User Viewer  */
/* ************************************************** */
ALTER TABLE user_viewer_book ADD
    CONSTRAINT FK_bk_user_vwr_bk FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go
ALTER TABLE user_viewer_book ADD
    CONSTRAINT FK_user_nm_user_vwr_bk FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_bundle ADD
    CONSTRAINT FK_bdl_user_vwr_bdl FOREIGN KEY
    (
     bundle_id
    ) REFERENCES trade_bundle (
      bundle_id
    )
go
ALTER TABLE user_viewer_bundle ADD
    CONSTRAINT FK_user_nm_user_vwr_bdl FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_le ADD
    CONSTRAINT FK_legal_entity_user_vwr_le FOREIGN KEY
    (
     le_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE user_viewer_le ADD
    CONSTRAINT FK_user_nm_user_vwr_le FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_ws ADD
    CONSTRAINT FK_wrk_user_vwr_ws FOREIGN KEY
    (
     work_space_name
    ) REFERENCES work_space (
      work_space_name
    )
go
ALTER TABLE user_viewer_ws ADD
    CONSTRAINT FK_user_nm_user_vwr_ws FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_port ADD
    CONSTRAINT FK_trd_flt_user_vwr_port FOREIGN KEY
    (
     trade_filter_name
    ) REFERENCES trade_filter (
      trade_filter_name
    )
go
ALTER TABLE user_viewer_port ADD
    CONSTRAINT FK_user_nm_user_vwr_port FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_mitem ADD
    CONSTRAINT FK_user_nm_user_vwr_mitm FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_column ADD
    CONSTRAINT FK_user_nm_user_vwr_column FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_def ADD
    CONSTRAINT FK_user_nm_user_vwr_def FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
ALTER TABLE user_viewer_prop ADD
    CONSTRAINT FK_user_nm_user_vwr_prop FOREIGN KEY
    (
     user_name
    ) REFERENCES user_name (
      user_name
    )
go
/* ************************************************** */
/* Reference Data Relation */
/* ************************************************** */
ALTER TABLE trade_filter_crit ADD
    CONSTRAINT FK_trd_flt_trd_filter_crit FOREIGN KEY
    (
     trade_filter_name
    ) REFERENCES trade_filter (
      trade_filter_name
    )
go
ALTER TABLE trade_filt_min_max ADD
    CONSTRAINT FK_trd_flt_trd_filt_min_max FOREIGN KEY
    (
     trade_filter_name
    ) REFERENCES trade_filter (
      trade_filter_name
    )
go
ALTER TABLE trfilter_minmax_dt ADD
    CONSTRAINT FK_trd_flt_trfilter_minmax_dt FOREIGN KEY
    (
     trade_filter_name
    ) REFERENCES trade_filter (
      trade_filter_name
    )
go
ALTER TABLE legal_entity_role ADD
    CONSTRAINT FK_legal_ent_legal_ent_role FOREIGN KEY
    (
     legal_entity_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE le_contact ADD
    CONSTRAINT FK_legal_entity_le_contact FOREIGN KEY
    (
     legal_entity_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE le_agreement_field ADD
    CONSTRAINT FK_le_legal_agr_le_agr_fld FOREIGN KEY
    (
     le_agreement_id
    ) REFERENCES le_legal_agreement (
      legal_agreement_id
    )
go
ALTER TABLE le_agr_child ADD
    CONSTRAINT FK_le_legal_agr_le_agr_child FOREIGN KEY
    (
     legal_agreement_id
    ) REFERENCES le_legal_agreement (
      legal_agreement_id
    )
go
ALTER TABLE sec_lend_legal ADD
    CONSTRAINT FK_le_legal_agr_sec_lend_legal FOREIGN KEY
    (
     legal_agreement_id
    ) REFERENCES le_legal_agreement (
      legal_agreement_id
    )
go
ALTER TABLE sec_lend_country ADD
    CONSTRAINT FK_sec_lend_leg_sec_lend_ctr FOREIGN KEY
    (
     legal_agreement_id
    ) REFERENCES sec_lend_legal (
      legal_agreement_id
    )
go
ALTER TABLE le_agr_child ADD
    CONSTRAINT FK_legal_ent_le_agr_child FOREIGN KEY
    (
     legal_entity_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE le_registration ADD
    CONSTRAINT FK_legal_ent_le_regst FOREIGN KEY
    (
     legal_entity_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go

ALTER TABLE le_role_disabled ADD
    CONSTRAINT FK_legal_entity_le_role_dis_p FOREIGN KEY
    (
     po_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE le_role_disabled ADD
    CONSTRAINT FK_legal_entity_le_role_dis_l FOREIGN KEY
    (
     le_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE le_attribute ADD
    CONSTRAINT FK_legal_ent_le_attr FOREIGN KEY
    (
     legal_entity_id
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go
ALTER TABLE mrgcall_cashpos ADD
    CONSTRAINT FK_mrgcall_cfg_mrgcall_cashpos FOREIGN KEY
    (
     mrg_call_def
    ) REFERENCES mrgcall_config (
      mrg_call_def
    )
go
ALTER TABLE mrgcall_secpos ADD
    CONSTRAINT FK_mrgcall_cfg_mrgcall_secpos FOREIGN KEY
    (
     mrg_call_def
    ) REFERENCES mrgcall_config (
      mrg_call_def
    )
go
ALTER TABLE mrgcall_field ADD
    CONSTRAINT FK_mrgcall_cfg_mrgcall_field FOREIGN KEY
    (
     mcc_id
    ) REFERENCES mrgcall_config (
      mrg_call_def
    )
go

/* ************************************************** */
/* Static Data Relation */
/* ************************************************** */
ALTER TABLE ticker_keyword ADD
    CONSTRAINT FK_ticker_ticker_keyword FOREIGN KEY
    (
     ticker_id
    ) REFERENCES ticker (
      ticker_id
    )
go
ALTER TABLE book_attr_value ADD
    CONSTRAINT FK_bk_attribute_bk_attr_value FOREIGN KEY
    (
     attribute_name
    ) REFERENCES book_attribute (
      attribute_name
    )
go
ALTER TABLE book_attr_value ADD
    CONSTRAINT FK_bk_bk_attr_value FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go
ALTER TABLE book_val_ccy ADD
    CONSTRAINT FK_bk_bk_val_ccy FOREIGN KEY
    (
     book_id
    ) REFERENCES book (
      book_id
    )
go
ALTER TABLE book_val_ccy ADD
    CONSTRAINT FK_prd_desc_bk_val_ccy FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE acc_book_rule_link ADD
    CONSTRAINT FK_acc_bk_acc_bk_rl_link FOREIGN KEY
    (
     acc_book_id
    ) REFERENCES acc_book (
      acc_book_id
    )
go
ALTER TABLE acc_book_rule_link ADD
    CONSTRAINT FK_acc_rl_acc_bk_rl_link FOREIGN KEY
    (
     acc_rule_id
    ) REFERENCES acc_rule (
      acc_rule_id
    )
go
ALTER TABLE acc_rule_date ADD
    CONSTRAINT FK_acc_rl_acc_rl_date FOREIGN KEY
    (
     acc_rule_id
    ) REFERENCES acc_rule (
      acc_rule_id
    )
go
ALTER TABLE acc_rule_config ADD
    CONSTRAINT FK_acc_rl_acc_rl_cfg FOREIGN KEY
    (
     acc_rule_id
    ) REFERENCES acc_rule (
      acc_rule_id
    )
go
ALTER TABLE balance_position ADD
    CONSTRAINT FK_acc_account_bal_pos FOREIGN KEY
    (
     account_id
    ) REFERENCES acc_account (
      acc_account_id
    )
go

ALTER TABLE holiday_code_rule ADD
    CONSTRAINT FK_hldy_code_hldy_code_rl FOREIGN KEY
    (
    code_name
    ) REFERENCES holiday_code (
      holiday_code
    )
go
ALTER TABLE holiday_code_rule ADD
    CONSTRAINT FK_hldy_rl_hldy_code_rl FOREIGN KEY
    (
     holiday_rule_id
    ) REFERENCES holiday_rule (
      holiday_rule_id
    )
go
ALTER TABLE filter_set_element ADD
    CONSTRAINT FK_flt_set_filter_set_element FOREIGN KEY
    (
     filter_set_name
    ) REFERENCES filter_set (
      filter_set_name
    )
go
ALTER TABLE filter_set_domain ADD
    CONSTRAINT FK_flt_set_elmt_filt_set_dom FOREIGN KEY
    (
     filter_set_name,element_name,element_type
    ) REFERENCES filter_set_element (
      filter_set_name,element_name,element_type
    )
go
ALTER TABLE sd_filter_element ADD
    CONSTRAINT FK_sd_filt_sd_filt_elmt FOREIGN KEY
    (
     sd_filter_name
    ) REFERENCES sd_filter (
      sd_filter_name
    )
go
ALTER TABLE sd_filter_domain ADD
    CONSTRAINT FK_sd_filt_elmnt_sd_filt_dom FOREIGN KEY
    (
     sd_filter_name,element_name,element_type
    ) REFERENCES sd_filter_element (
      sd_filter_name,element_name,element_type
    )
go
ALTER TABLE disp_calc ADD
    CONSTRAINT FK_disp_cfg_disp_calc FOREIGN KEY
    (
     config_name
    ) REFERENCES disp_config (
      config_name
    )
go
ALTER TABLE limit_config_node ADD
    CONSTRAINT FK_limit_cfg_limit_cfg_node FOREIGN KEY
    (
     config_name
    ) REFERENCES limit_config (
      config_name
    )
go
ALTER TABLE limit_config_limit ADD
    CONSTRAINT FK_lmt_cfg_node_lmt_cfg_lmt FOREIGN KEY
    (
     config_name, node_id
    ) REFERENCES limit_config_node (
      config_name, node_id
    )
go
ALTER TABLE limit_crit_group ADD
    CONSTRAINT FK_lmt_cfg_node_lmt_crit_grp FOREIGN KEY
    (
     config_name, node_id
    ) REFERENCES limit_config_node (
      config_name, node_id
    )
go
ALTER TABLE sched_task_attr ADD
    CONSTRAINT FK_sched_task_sched_task_attr FOREIGN KEY
    (
     task_id
    ) REFERENCES sched_task (
      task_id
    )
go
ALTER TABLE sched_task_exec ADD
    CONSTRAINT FK_sched_task_sched_task_exec FOREIGN KEY
    (
     task_id
    ) REFERENCES sched_task (
      task_id
    )
go
ALTER TABLE manual_party_sdi ADD
    CONSTRAINT FK_manual_sdi_manual_party_sdi FOREIGN KEY
    (
     sdi_id
    ) REFERENCES manual_sdi (
      sdi_id
    )
go
ALTER TABLE manual_sdi_attr ADD
    CONSTRAINT FK_manual_sdi_manual_sdi_attr FOREIGN KEY
    (
     sdi_id
    ) REFERENCES manual_sdi (
      sdi_id
    )
go
ALTER TABLE le_settle_delivery ADD
    CONSTRAINT FK_legal_entity_le_stl_dlv FOREIGN KEY
    (
     bene_le
    ) REFERENCES legal_entity (
      legal_entity_id
    )
go

ALTER TABLE sdi_relationship ADD
    CONSTRAINT FK_le_stl_dlv_sdi_relationship FOREIGN KEY
    (
     id
    ) REFERENCES le_settle_delivery (
      sdi_id
    )
go
ALTER TABLE sdi_attribute ADD
    CONSTRAINT FK_le_stl_dlv_sdi_attribute FOREIGN KEY
    (
     sdi_id
    ) REFERENCES le_settle_delivery (
      sdi_id
    )
go
ALTER TABLE currency_benchmark ADD
    CONSTRAINT FK_prd_desc_ccy_benchmark FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE task_book_config ADD
    CONSTRAINT FK_user_grp_nm_task_bk_cfg FOREIGN KEY
    (
     group_name
    ) REFERENCES user_group_name (
      group_name
    )
go
ALTER TABLE task_event_config ADD
    CONSTRAINT FK_user_grp_nm_task_event_cfg FOREIGN KEY
    (
     group_name
    ) REFERENCES user_group_name (
      group_name
    )
go
/* ************************************************** */
/* All the Products Tables */
/* ************************************************** */

/* General */
ALTER TABLE prod_exch_code  ADD
    CONSTRAINT FK_prd_equity_prod_exch_code  FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_sec_code ADD
    CONSTRAINT FK_prd_desc_prd_sec_code FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cash_settle_info ADD
    CONSTRAINT FK_prd_desc_cash_settle_info FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE cash_settle_date ADD
    CONSTRAINT FK_cash_st_info_cash_st_dt FOREIGN KEY
    (
     product_id,event_type
    ) REFERENCES cash_settle_info (
      product_id,event_type
    )
go
ALTER TABLE template_product ADD
    CONSTRAINT FK_prd_desc_template_prd FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE template_dates ADD
    CONSTRAINT FK_template_prd_template_date FOREIGN KEY
    (
     template_name,product_type, user_name
    ) REFERENCES template_product (
      template_name,product_type, user_name
    )
go

ALTER TABLE product_holding ADD
    CONSTRAINT FK_prd_desc_prd_holding FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
/* Customer Transfer Relation */
ALTER TABLE product_simplexfer ADD
    CONSTRAINT FK_prd_desc_prd_simplexfer FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_custxfer ADD
    CONSTRAINT FK_prd_desc_prd_custxfer FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_custxfer ADD 
	CONSTRAINT FK_prd_custxfer_le_stl_dlv FOREIGN KEY 
	(
		cpty_sdi
	) REFERENCES le_settle_delivery (
		sdi_id
    )
go
ALTER TABLE product_custxfer ADD 
	CONSTRAINT FK_prd_custxfer_le_stl_dlv1 FOREIGN KEY 
	(
		po_sdi
	) REFERENCES le_settle_delivery (
		sdi_id
    )
go
ALTER TABLE product_xferagent ADD
    CONSTRAINT FK_prd_desc_prd_xferagent FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_xferagent ADD 
	CONSTRAINT FK_prd_xferagent_le_stl_dlv FOREIGN KEY 
	(
		from_sdi_id
	) REFERENCES le_settle_delivery (
		sdi_id
    )
go
ALTER TABLE product_xferagent ADD 
	CONSTRAINT FK_prd_xferagent_le_stl_dlv1 FOREIGN KEY 
	(
		to_sdi_id
	) REFERENCES le_settle_delivery (
		sdi_id
    )
go
/* All the Products FX Tables */
ALTER TABLE product_fx ADD
    CONSTRAINT FK_prd_desc_prd_fx FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_fx ADD
    CONSTRAINT FK_ccy_pair_prd_fx FOREIGN KEY
    (
     principal_currency,quoting_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fx_option ADD
    CONSTRAINT FK_prd_fx_opt_prd_fx FOREIGN KEY
    (
     base_currency,quote_currency
    ) REFERENCES product_fx (
      principal_currency,quoting_currency
    )
go
ALTER TABLE asian_parameters ADD
    CONSTRAINT FK_prd_desc_asian_prmeters FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE asian_reset_dates ADD
    CONSTRAINT FK_prd_desc_asian_reset_dates FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE barrier_parameters ADD
    CONSTRAINT FK_prd_desc_barrier_prmeters FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_cmpd_opt ADD
    CONSTRAINT FK_prd_desc_prd_cmpd_opt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_cmpd_opt ADD
    CONSTRAINT FK_prd_desc_prd_cmpd_opt_u FOREIGN KEY
    (
     underlying_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_fx_opt_fwd ADD
    CONSTRAINT FK_prd_fx_prd_fx_opt_fwd FOREIGN KEY
    (
     principal_currency,quoting_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fx_opt_fwd ADD
    CONSTRAINT FK_prd_desc_prd_fx_opt_fwd FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_fx_takeup ADD
    CONSTRAINT FK_prd_fx_prd_fx_takeup FOREIGN KEY
    (
     principal_currency,quoting_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fx_takeup ADD
    CONSTRAINT FK_prd_desc_prd_fx_takeup FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_fxoptstrip ADD
    CONSTRAINT FK_prd_fx_prd_fxoptstrip FOREIGN KEY
    (
     base_currency,quote_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fxoptstrip ADD
    CONSTRAINT FK_prd_desc_prd_fxoptstrip FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_fx_forward ADD
    CONSTRAINT FK_prd_fx_prd_fx_forward FOREIGN KEY
    (
     principal_currency,quoting_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fx_forward ADD
    CONSTRAINT FK_prd_desc_prd_fx_forward FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_fx_cash ADD
    CONSTRAINT FK_prd_fx_prd_fx_cash FOREIGN KEY
    (
     base_currency,quote_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fx_cash ADD
    CONSTRAINT FK_prd_desc_prd_fx_cash FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE fx_cash_flow ADD
    CONSTRAINT FK_prd_fx_cash_fx_cash_flow FOREIGN KEY
    (
     product_id
    ) REFERENCES product_fx_cash (
      product_id
    )
go
ALTER TABLE product_fx_ndf ADD
    CONSTRAINT FK_prd_fx_prd_fx_ndf FOREIGN KEY
    (
     principal_currency,quoting_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fx_ndf ADD
    CONSTRAINT FK_prd_desc_prd_fx_ndf FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_fx_ndf ADD 
	CONSTRAINT FK_prd_fx_ndf_fx_reset FOREIGN KEY 
	(
		fx_reset
	) REFERENCES fx_reset (
		fx_reset_id
    )
go
ALTER TABLE product_fx_swap ADD
    CONSTRAINT FK_prd_fx_prd_fx_swap FOREIGN KEY
    (
     principal_currency,quoting_currency
    ) REFERENCES currency_pair (
      primary_currency,quoting_currency
    )
go
ALTER TABLE product_fx_swap ADD
    CONSTRAINT FK_prd_desc_prd_fx_swap FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
/* ************************************************** */
/* Money Market RelationShip */
/* ************************************************** */
ALTER TABLE product_mmkt ADD
    CONSTRAINT FK_prd_desc_prd_mmkt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_simple_mm ADD
    CONSTRAINT FK_prd_desc_prd_simple_mm FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_call_not ADD
    CONSTRAINT FK_prd_desc_prd_call_not FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_commod_mm ADD
    CONSTRAINT FK_prd_desc_prd_commod_mm FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
/* ************************************************** */
/* Repo Product RelationShip */
/* ************************************************** */
ALTER TABLE product_simplerepo ADD
    CONSTRAINT FK_prd_desc_prd_simplerepo FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_simplerepo ADD
    CONSTRAINT FK_prd_desc_prd_simplerepo_s FOREIGN KEY
    (
     security_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_repo ADD
    CONSTRAINT FK_prd_desc_prd_repo FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_collateral ADD
    CONSTRAINT FK_prd_desc_prd_cltl FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_cash ADD
    CONSTRAINT FK_prd_desc_prd_cash FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_repo ADD
    CONSTRAINT FK_prd_cash_prd_repo FOREIGN KEY
    (
     money_market_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE repo_collateral ADD
    CONSTRAINT FK_prd_repo_repo_cltl FOREIGN KEY
    (
     product_id
    ) REFERENCES product_repo (
      product_id
    )
go
ALTER TABLE repo_collateral ADD
    CONSTRAINT FK_prd_cltl_repo_cltl FOREIGN KEY
    (
     collateral_id
    ) REFERENCES product_collateral (
      product_id
    )
go
ALTER TABLE product_jgb_repo ADD
    CONSTRAINT FK_prd_repo_prd_jgb_repo FOREIGN KEY
    (
     product_id
    ) REFERENCES product_repo (
      product_id
    )
go
/* ************************************************** */
/* Bond Product RelationShip */
/* ************************************************** */
ALTER TABLE product_bond ADD
    CONSTRAINT FK_prd_desc_prd_bond FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE bond_info ADD
    CONSTRAINT FK_prd_bond_bond_info FOREIGN KEY
    (
     product_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE bond_info_syndic ADD
    CONSTRAINT FK_prd_bond_bond_info_syndic FOREIGN KEY
    (
     product_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE lottery_win_date ADD
    CONSTRAINT FK_prd_bond_lottery_win_date FOREIGN KEY
    (
     product_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE bond_guarantee ADD
    CONSTRAINT FK_prd_bond_bond_guarantee FOREIGN KEY
    (
     product_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE bond_asset_backed ADD
    CONSTRAINT FK_prd_bond_bond_asset_backed FOREIGN KEY
    (
     product_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE bond_convertible ADD
    CONSTRAINT FK_prd_bond_bond_convertible FOREIGN KEY
    (
     product_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE conversion_reset ADD
    CONSTRAINT FK_bond_convert_cnv_reset FOREIGN KEY
    (
     product_id
    ) REFERENCES bond_convertible (
      product_id
    )
go
ALTER TABLE bond_pool_factor ADD
    CONSTRAINT FK_prd_bond_bond_pool_factor FOREIGN KEY
    (
     product_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE product_bond_opt ADD
    CONSTRAINT FK_prd_desc_prd_bond_opt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_bond_opt ADD
    CONSTRAINT FK_prd_bond_prd_bond_opt FOREIGN KEY
    (
     underlying_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE product_bondspread ADD
    CONSTRAINT FK_prd_bond_prd_bondsprd FOREIGN KEY
    (
     underlying_bond_id
    ) REFERENCES product_bond (
      product_id
    )
go
ALTER TABLE product_bondspread ADD
    CONSTRAINT FK_prd_desc_prd_bondspread FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

/* ************************************************** */
/* BuySellBack Product RelationShip */
/* ************************************************** */
ALTER TABLE product_bsb ADD
    CONSTRAINT FK_prd_desc_prd_bsb FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
/* ************************************************** */
/* Issuance Product RelationShip */
/* ************************************************** */
ALTER TABLE product_issuance ADD
    CONSTRAINT FK_prd_desc_prd_issuance FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_issuance ADD
    CONSTRAINT FK_prd_desc_prd_issuance_s FOREIGN KEY
    (
     security_id
    ) REFERENCES product_desc (
      product_id
    )
go
/* ************************************************** */
/* Seclending Product RelationShip */
/* ************************************************** */
ALTER TABLE product_seclending ADD
    CONSTRAINT FK_prd_desc_prd_seclending FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE seclending_col ADD
    CONSTRAINT FK_prd_seclending_seclend_col FOREIGN KEY
    (
     product_id
    ) REFERENCES product_seclending (
      product_id
    )
go
ALTER TABLE seclending_col ADD
    CONSTRAINT FK_prd_cltl_seclending_col FOREIGN KEY
    (
     collateral_id
    ) REFERENCES product_collateral (
      product_id
    )
go
/* ************************************************** */
/* TreasuryLock RelationShip */
/* ************************************************** */
ALTER TABLE product_tlock ADD
    CONSTRAINT FK_prd_desc_prd_tlock FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

/* ************************************************** */
/* Future Product RelationShip */
/* ************************************************** */
ALTER TABLE product_future ADD
    CONSTRAINT FK_prd_desc_prd_future FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_future ADD
    CONSTRAINT FK_future_contract_prd_future FOREIGN KEY
    (
     contract_id
    ) REFERENCES future_contract (
      contract_id
    )
go
ALTER TABLE future_ctd ADD
    CONSTRAINT FK_future_contract_future_ctd FOREIGN KEY
    (
     contract_id
    ) REFERENCES future_contract (
      contract_id
    )
go
ALTER TABLE product_fut_opt ADD
    CONSTRAINT FK_opt_contract_prd_fut_opt FOREIGN KEY
    (
     contract_id
    ) REFERENCES option_contract (
      contract_id
    )
go
/* ************************************************** */
/* All Swap Related and  Product RelationShip */
/* ************************************************** */
/* Interest Rate Derivative */
ALTER TABLE product_swap ADD
    CONSTRAINT FK_prd_desc_prd_swap FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE product_swap ADD 
	CONSTRAINT FK_prd_swap_swap_leg FOREIGN KEY 
	(
		product_id,
		pay_leg_id
	) REFERENCES swap_leg (
		product_id,
		leg_id
    )
go
ALTER TABLE product_swap ADD 
	CONSTRAINT FK_prd_swap_swap_leg1 FOREIGN KEY 
	(
		product_id,
		receive_leg_id
	) REFERENCES swap_leg (
		product_id,
		leg_id
    )
go
ALTER TABLE termination_date ADD
    CONSTRAINT FK_prd_desc_trm_date FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE put_call_date ADD
    CONSTRAINT FK_prd_desc_put_call_date FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE payout_formula ADD
    CONSTRAINT FK_swap_leg_payout_formula FOREIGN KEY
    (
     product_id,product_sub_id
    ) REFERENCES swap_leg (
      product_id,leg_id
    )
go
ALTER TABLE notional_schedule ADD
    CONSTRAINT FK_swap_leg_n_sch FOREIGN KEY
    (
     product_id,sub_id
    ) REFERENCES swap_leg (
      product_id,leg_id
    )
go
/* Swaption */
ALTER TABLE swaption_ext_info ADD
    CONSTRAINT FK_prd_swption_swption_ext_in FOREIGN KEY
    (
     product_id
    ) REFERENCES product_swaption (
      product_id
    )
go

ALTER TABLE xccy_swap_ext_info ADD
    CONSTRAINT FK_prd_swp_xccy_swap_ext_info FOREIGN KEY
    (
     product_id
    ) REFERENCES product_swap (
      product_id
    )
go
/* Cap Floor */
ALTER TABLE product_cap_floor ADD
    CONSTRAINT FK_prd_desc_prd_cap_floor FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

/* CappedSwap */
ALTER TABLE cap_swap_ext_info ADD
    CONSTRAINT FK_prd_swap_cap_swap_ext_info FOREIGN KEY
    (
     product_id
    ) REFERENCES product_swap (
      product_id
    )
go
/* Structured Product */
ALTER TABLE product_structured ADD
    CONSTRAINT FK_prd_desc_prd_structured FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE basic_product ADD
    CONSTRAINT FK_prd_desc_basic_prd FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE basic_product ADD
    CONSTRAINT FK_prd_desc_basic_prd_b FOREIGN KEY
    (
     basic_product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE basic_prod_keyword ADD
    CONSTRAINT FK_basic_prd_basic_prd_kwd FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
     product_id
    )
go
ALTER TABLE product_fra ADD
    CONSTRAINT FK_prd_desc_prd_fra FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

/* *********************  */
/* Credit  Derivative */
/* *********************  */
/* Asset Swap */
ALTER TABLE product_asset_swap ADD
    CONSTRAINT FK_prd_desc_prd_asset_swap FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
/* Credit Default Swap */
ALTER TABLE product_cds ADD
    CONSTRAINT FK_prd_desc_prd_cds FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_cds ADD
    CONSTRAINT FK_ref_entity_prd_cds FOREIGN KEY
    (
     ref_entity_id
    ) REFERENCES ref_entity (
      ref_entity_id
    )
go
ALTER TABLE termination_events ADD
    CONSTRAINT FK_prd_cds_trm_events FOREIGN KEY
    (
     product_id
    ) REFERENCES product_cds (
      product_id
    )
go

ALTER TABLE del_characteristic ADD
    CONSTRAINT FK_prd_cds_del_characteristic FOREIGN KEY
    (
     product_id
    ) REFERENCES product_cds (
      product_id
    )
go

ALTER TABLE ref_characteristic ADD
    CONSTRAINT FK_prd_cds_ref_characteristic FOREIGN KEY
    (
     product_id
    ) REFERENCES product_cds (
      product_id
    )
go


ALTER TABLE ref_entity_basket ADD
    CONSTRAINT FK_ref_ent_ref_ent_basket FOREIGN KEY
    (
     ref_entity_id
    ) REFERENCES ref_entity (
      ref_entity_id
    )
go

ALTER TABLE ref_entity_single ADD
    CONSTRAINT FK_ref_ent_ref_ent_single FOREIGN KEY
    (
     ref_entity_id
    ) REFERENCES ref_entity (
      ref_entity_id
    )
go
ALTER TABLE product_cdsnthdflt ADD
    CONSTRAINT FK_prd_cds_prd_cdsnthdflt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_cds (
      product_id
    )
go
ALTER TABLE product_cdsnthloss ADD
    CONSTRAINT FK_prd_cds_prd_cdsnthloss FOREIGN KEY
    (
     product_id
    ) REFERENCES product_cds (
      product_id
    )
go
/* Total Return Swap  and Basket */
ALTER TABLE product_trs ADD
    CONSTRAINT FK_prd_desc_prd_trs FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE product_basket ADD
    CONSTRAINT FK_prd_desc_prd_basket FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE product_trs_basket ADD
    CONSTRAINT FK_prd_trs_prd_trs_basket FOREIGN KEY
    (
     product_id
    ) REFERENCES product_trs (
      product_id
    )
go


/* ************************************************** */
/* Equity/Stock RelationShip */
/* ************************************************** */
ALTER TABLE product_cfd ADD
    CONSTRAINT FK_prd_desc_prd_cfd FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE cfd_data ADD
    CONSTRAINT FK_prd_cfd_cfd_data FOREIGN KEY
    (
     cfd_id
    ) REFERENCES product_cfd (
      product_id
    )
go

ALTER TABLE product_cfd ADD
    CONSTRAINT FK_cfd_contract_prd_cfd FOREIGN KEY
    (
     contract_id
    ) REFERENCES cfd_contract (
      id
    )
go

ALTER TABLE cfd_country_attr ADD
    CONSTRAINT FK_cfd_ctry_cfd_ctry_attr FOREIGN KEY
    (
	cfd_country_id
    ) REFERENCES cfd_country (
      id
    )
go
ALTER TABLE cfd_contract_attr ADD
    CONSTRAINT FK_cfd_cntr_cfd_cntr_attr FOREIGN KEY
    (
     contract_id
    ) REFERENCES cfd_contract (
      id
    )
go

ALTER TABLE cfd_detail ADD
    CONSTRAINT FK_cfd_cntrt_cfd_detail FOREIGN KEY
    (
     contract_id
    ) REFERENCES cfd_contract (
      id
    )
go

ALTER TABLE cfd_detail_rdate ADD
    CONSTRAINT FK_cfd_cntrt_cfd_det_rdate FOREIGN KEY
    (
     contract_id
    ) REFERENCES cfd_contract (
      id
    )
go
ALTER TABLE cfd_fin_grid ADD
    CONSTRAINT FK_cfd_cntrt_cfd_fin_grid FOREIGN KEY
    (
     contract_id
    ) REFERENCES cfd_contract (
      id
    )
go
ALTER TABLE cfd_deposit ADD
    CONSTRAINT FK_cfd_cntrt_cfd_deposit FOREIGN KEY
    (
     contract_id
    ) REFERENCES cfd_contract (
      id
    )
go


/* ETO Related */
ALTER TABLE product_eto ADD
    CONSTRAINT FK_eto_contract_prd_eto FOREIGN KEY
    (
     contract_id
    ) REFERENCES eto_contract (
      contract_id
    )
go
ALTER TABLE product_eto ADD
    CONSTRAINT FK_prd_desc_prd_eto FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

/* Equity Related */
ALTER TABLE product_equity ADD
    CONSTRAINT FK_prd_desc_prd_equity FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go


ALTER TABLE product_adr ADD
    CONSTRAINT FK_prd_desc_prd_adr FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE dividend ADD
    CONSTRAINT FK_prd_desc_dividend FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go


/* Product OTC Equity Option */
ALTER TABLE product_otceqtyopt ADD
    CONSTRAINT FK_prd_otcopt_prd_otceqtyopt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_otcoption (
      product_id
    )
go

ALTER TABLE product_otcoption ADD
    CONSTRAINT FK_prd_desc_prd_otcopt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go

ALTER TABLE product_otceqtyopt ADD 
	CONSTRAINT FK_prd_otceqtyopt_fx_reset FOREIGN KEY 
	(
		fx_reset_id
	) REFERENCES fx_reset (
		fx_reset_id
    )
go


ALTER TABLE option_deliverable ADD
    CONSTRAINT FK_prd_otcopt_opt_deliverable FOREIGN KEY
    (
     product_id
    ) REFERENCES product_otcoption (
      product_id
    )
go

ALTER TABLE product_otceq_opt ADD
    CONSTRAINT FK_prd_otceopt_prd_otceqtyopt FOREIGN KEY
    (
     product_id
    ) REFERENCES product_otcoption (
      product_id
    )
go

/* ELS */
ALTER TABLE eq_linked_leg ADD
    CONSTRAINT FK_prd_els_equity_link_leg FOREIGN KEY
    (
     product_id
    ) REFERENCES product_els (
      product_id
    )
go
ALTER TABLE performance_leg ADD
    CONSTRAINT FK_prd_els_prfm_lg FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE initial_prices ADD
    CONSTRAINT FK_prfm_lg_initial_prices FOREIGN KEY
    (
     product_id,leg_id
    ) REFERENCES performance_leg (
      product_id,leg_id
    )
go
ALTER TABLE option_observable ADD
    CONSTRAINT FK_obsrv_opt_obsrv FOREIGN KEY
    (
     observable_id
    ) REFERENCES observable (
      observable_id
    )
go
/* ************************************************** */
/* Backoffice Related */
/* ************************************************** */
ALTER TABLE kickoff_cfg ADD
    CONSTRAINT FK_wfw_trst_kickoff_cfg FOREIGN KEY
    (
     wfw_transition
    ) REFERENCES wfw_transition (
      workflow_id
    )
go
ALTER TABLE bo_workflow_rule ADD
    CONSTRAINT FK_wfw_trst_bo_wrkflw_rl FOREIGN KEY
    (
     id
    ) REFERENCES wfw_transition (
      workflow_id
    )
go
ALTER TABLE mapping_status ADD
    CONSTRAINT FK_wfw_trst_mapping_status FOREIGN KEY
    (
     workflow_id
    ) REFERENCES wfw_transition (
      workflow_id
    )
go
ALTER TABLE transfer_reconcil ADD
    CONSTRAINT FK_bo_transfer_transfer_recon FOREIGN KEY
    (
     transfer_id
    ) REFERENCES bo_transfer (
      transfer_id
    )
go
ALTER TABLE xfer_attributes ADD
    CONSTRAINT FK_bo_transfer_xfer_attributes FOREIGN KEY
    (
     transfer_id
    ) REFERENCES bo_transfer (
      transfer_id
    )
go

/* ************************************************** */
/* Event Related */
/* ************************************************** */
ALTER TABLE event_trade ADD
    CONSTRAINT FK_ps_event_event_trd FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_trade ADD
    CONSTRAINT FK_trd_event_trd FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE ps_event_inst ADD
    CONSTRAINT FK_ps_event_ps_event_inst FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE ps_event_config ADD
    CONSTRAINT FK_ps_evt_cfg_nm_ps_evt_cfg FOREIGN KEY
    (
     event_config_name
    ) REFERENCES ps_event_cfg_name (
      event_config_name
    )
go
ALTER TABLE ps_event_filter ADD
    CONSTRAINT FK_ps_evt_cfg_nm_ps_evt_filt FOREIGN KEY
    (
     event_config_name
    ) REFERENCES ps_event_cfg_name (
      event_config_name
    )
go
ALTER TABLE event_transfer ADD
    CONSTRAINT FK_ps_event_event_transfer FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_transfer ADD
    CONSTRAINT FK_bo_transfer_event_transfer FOREIGN KEY
    (
     transfer_id
    ) REFERENCES bo_transfer (
      transfer_id
    )
go
ALTER TABLE event_message ADD
    CONSTRAINT FK_ps_event_event_message FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_message ADD
    CONSTRAINT FK_bo_message_event_message FOREIGN KEY
    (
     message_id
    ) REFERENCES bo_message (
      message_id
    )
go
ALTER TABLE mess_attributes ADD
    CONSTRAINT FK_bo_message_mess_attributes FOREIGN KEY
    (
     message_id
    ) REFERENCES bo_message (
      message_id
    )
go
ALTER TABLE event_in_message ADD
    CONSTRAINT FK_bo_in_mess_event_in_mess FOREIGN KEY
    (
     in_message_id
    ) REFERENCES bo_in_message (
      message_id
    )
go

ALTER TABLE event_posting ADD
    CONSTRAINT FK_ps_event_event_posting FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_posting ADD
    CONSTRAINT FK_bo_posting_event_posting FOREIGN KEY
    (
     posting_id
    ) REFERENCES bo_posting (
      bo_posting_id
    )
go
ALTER TABLE event_posting ADD
    CONSTRAINT FK_trd_event_posting FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE event_task ADD
    CONSTRAINT FK_ps_event_event_task FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_task ADD
    CONSTRAINT FK_bo_task_event_task FOREIGN KEY
    (
     task_id
    ) REFERENCES bo_task (
      task_id
    )
go
ALTER TABLE event_plpos ADD
    CONSTRAINT FK_pl_position_event_plpos FOREIGN KEY
    (
     product_id,book_id
    ) REFERENCES pl_position (
      product_id,book_id
    )
go
ALTER TABLE event_liqpos ADD
    CONSTRAINT FK_ps_event_event_liqpos FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_unliqpos ADD
    CONSTRAINT FK_ps_event_event_unliqpos FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_cre ADD
    CONSTRAINT FK_ps_event_event_cre FOREIGN KEY
    (
     event_id
    ) REFERENCES ps_event (
      event_id
    )
go
ALTER TABLE event_cre ADD
    CONSTRAINT FK_bo_cre_event_cre FOREIGN KEY
    (
     cre_id
    ) REFERENCES bo_cre (
      bo_cre_id
    )
go
ALTER TABLE bo_cre  ADD
    CONSTRAINT FK_trd_bo_cre  FOREIGN KEY
    (
     trade_id
    ) REFERENCES trade (
      trade_id
    )
go
ALTER TABLE bo_cre ADD
    CONSTRAINT FK_prd_desc_bo_cre FOREIGN KEY
    (
     product_id
    ) REFERENCES product_desc (
      product_id
    )
go
ALTER TABLE cre_attribute ADD
    CONSTRAINT FK_bo_cre_cre_attribute FOREIGN KEY
    (
     cre_id
    ) REFERENCES bo_cre (
      bo_cre_id
    )
go
ALTER TABLE mutation_attr ADD
    CONSTRAINT FK_mutation_mutation_attr FOREIGN KEY
    (
     mutation_id
    ) REFERENCES mutation (
      mutation_id
    )
go
ALTER TABLE mutation_flow ADD
    CONSTRAINT FK_mutation_mutation_flow FOREIGN KEY
    (
     mutation_id
    ) REFERENCES mutation (
      mutation_id
    )
go
ALTER TABLE cre_amount ADD
    CONSTRAINT FK_bo_cre_cre_amount FOREIGN KEY
    (
     cre_id
    ) REFERENCES bo_cre (
      bo_cre_id
    )
go
/* ************************************************** */
/* Reporting Related */
/* ************************************************** */
ALTER TABLE scenario_items ADD
    CONSTRAINT FK_scenario_rl_scenario_itms FOREIGN KEY
    (
     scenario_name,class_name
    ) REFERENCES scenario_rule (
      scenario_name,class_name
    )
go
ALTER TABLE tree_node ADD
    CONSTRAINT FK_tree_nm_tree_node FOREIGN KEY
    (
     tree_name
    ) REFERENCES tree_name (
      tree_name
    )
go
ALTER TABLE scenario_report ADD
    CONSTRAINT FK_scenario_view_scn_report FOREIGN KEY
    (
     view_name,view_type
    ) REFERENCES scenario_view (
      view_name,view_type
    )
go


ALTER TABLE bo_posting ADD 
	CONSTRAINT FK_bo_posting_prd_desc FOREIGN KEY 
	(
		product_id
	) REFERENCES product_desc (
		product_id
    )
go

ALTER TABLE bo_posting ADD 
	CONSTRAINT FK_bo_posting_trd FOREIGN KEY 
	(
		trade_id
	) REFERENCES trade (
		trade_id
    )
go



ALTER TABLE cap_swap_ext_info ADD 
	CONSTRAINT FK_cap_swap_ext_info_prd_desc FOREIGN KEY 
	(
		product_id
	) REFERENCES product_desc (
		product_id
    )
go




ALTER TABLE currency_pair ADD 
	CONSTRAINT FK_ccy_pair_ccy_default FOREIGN KEY 
	(
		primary_currency
	) REFERENCES currency_default (
		currency_code
    )
go

ALTER TABLE currency_pair ADD 
	CONSTRAINT FK_ccy_pair_ccy_default1 FOREIGN KEY 
	(
		quoting_currency
	) REFERENCES currency_default (
		currency_code
    )
go


ALTER TABLE curve_member_link ADD 
	CONSTRAINT FK_crv_mbr_link_crv FOREIGN KEY 
	(
		curve_id,
		curve_date
	) REFERENCES curve (
		curve_id,
		curve_date
    )
go

ALTER TABLE curve_member_link ADD 
	CONSTRAINT FK_crv_mbr_link_crv_underlying FOREIGN KEY 
	(
		cu_id
	) REFERENCES curve_underlying (
		cu_id
    )
go




ALTER TABLE curve_member_rt ADD 
	CONSTRAINT FK_crv_mbr_rt_crv_underlying FOREIGN KEY 
	(
		cu_id
	) REFERENCES curve_underlying (
		cu_id
    )
go
ALTER TABLE event_transfer ADD 
	CONSTRAINT FK_event_transfer_trd FOREIGN KEY 
	(
		trade_id
	) REFERENCES trade (
		trade_id
    )
go


ALTER TABLE fx_reset ADD 
	CONSTRAINT FK_fx_reset_ccy_default FOREIGN KEY 
	(
		primary_currency
	) REFERENCES currency_default (
		currency_code
    )
go

ALTER TABLE fx_reset ADD 
	CONSTRAINT FK_fx_reset_ccy_default1 FOREIGN KEY 
	(
		quoting_currency
	) REFERENCES currency_default (
		currency_code
    )
go
ALTER TABLE notional_schedule ADD 
	CONSTRAINT FK_n_sch_prd_asset_swap FOREIGN KEY 
	(
		product_id
	) REFERENCES product_asset_swap (
		product_id
    )
go

ALTER TABLE notional_schedule ADD 
	CONSTRAINT FK_n_sch_prd_cds FOREIGN KEY 
	(
		product_id
	) REFERENCES product_cds (
		product_id
    )
go

ALTER TABLE notional_schedule ADD 
	CONSTRAINT FK_n_sch_prd_els FOREIGN KEY 
	(
		product_id
	) REFERENCES product_els (
		product_id
    )
go

ALTER TABLE notional_schedule ADD 
	CONSTRAINT FK_n_sch_prd_swap FOREIGN KEY 
	(
		product_id
	) REFERENCES product_swap (
		product_id
    )
go



ALTER TABLE product_bond ADD 
	CONSTRAINT FK_prd_bond_legal_entity FOREIGN KEY 
	(
		issuer_le_id
	) REFERENCES legal_entity (
		legal_entity_id
    )
go








ALTER TABLE product_eto ADD 
	CONSTRAINT FK_prd_eto_prd_desc FOREIGN KEY 
	(
		underlying_id
	) REFERENCES product_desc (
		product_id
    )
go





ALTER TABLE product_fut_opt ADD 
	CONSTRAINT FK_prd_fut_opt_prd_desc FOREIGN KEY 
	(
		product_id
	) REFERENCES product_desc (
		product_id
    )
go
ALTER TABLE swap_leg ADD 
	CONSTRAINT FK_swap_leg_prd_desc  FOREIGN KEY 
	(
		product_id
	) REFERENCES product_desc (
		product_id
    )
go
ALTER TABLE task_book_config ADD 
	CONSTRAINT FK_task_bk_cfg_bk FOREIGN KEY 
	(
		book_id
	) REFERENCES book (
		book_id
    )
go


ALTER TABLE master_confirmation_field ADD constraint FK_MASTER_CONFIRMATION
        FOREIGN KEY (master_confirmation_id)
        REFERENCES master_confirmation (master_confirmation_id)
go


