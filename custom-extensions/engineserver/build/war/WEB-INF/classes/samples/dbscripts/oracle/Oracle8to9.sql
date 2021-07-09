/*  This Script is to be run if you are on Calypso RELEASE  Version  */
ALTER TABLE acc_account
MODIFY creation_date TIMESTAMP
;
ALTER TABLE acc_account
MODIFY last_closing_date TIMESTAMP
;
ALTER TABLE advice_doc_hist
MODIFY gen_datetime TIMESTAMP
;
ALTER TABLE advice_document
MODIFY gen_datetime TIMESTAMP
;
ALTER TABLE analysis_output
MODIFY val_date_time TIMESTAMP
;
ALTER TABLE bo_audit
MODIFY modif_date TIMESTAMP
;
ALTER TABLE bo_audit_hist
MODIFY modif_date TIMESTAMP
;
ALTER TABLE bo_cre
MODIFY creation_date TIMESTAMP
;
ALTER TABLE bo_cre
MODIFY sent_date TIMESTAMP
;
ALTER TABLE bo_cre
MODIFY update_time TIMESTAMP
;
ALTER TABLE bo_cre_hist
MODIFY creation_date TIMESTAMP
;
ALTER TABLE bo_cre_hist
MODIFY sent_date TIMESTAMP
;
ALTER TABLE bo_cre_hist
MODIFY update_time TIMESTAMP
;
ALTER TABLE bo_in_message
MODIFY creation_date TIMESTAMP
;
ALTER TABLE bo_message
MODIFY creation_date TIMESTAMP
;
ALTER TABLE bo_message
MODIFY trade_time TIMESTAMP
;
ALTER TABLE bo_message_hist
MODIFY creation_date TIMESTAMP
;
ALTER TABLE bo_message_hist
MODIFY trade_time TIMESTAMP
;
ALTER TABLE bo_posting
MODIFY creation_date TIMESTAMP
;
ALTER TABLE bo_posting
MODIFY sent_date TIMESTAMP
;
ALTER TABLE bo_posting
MODIFY update_time TIMESTAMP
;
ALTER TABLE bo_posting_hist
MODIFY update_time TIMESTAMP
;
ALTER TABLE bo_posting_hist
MODIFY sent_date TIMESTAMP
;
ALTER TABLE bo_posting_hist
MODIFY creation_date TIMESTAMP
;
ALTER TABLE bo_task
MODIFY task_datetime TIMESTAMP
;
ALTER TABLE bo_task
MODIFY new_datetime TIMESTAMP
;
ALTER TABLE bo_task
MODIFY completed_datetime TIMESTAMP
;
ALTER TABLE bo_task
MODIFY kickoff_datetime TIMESTAMP
;
ALTER TABLE bo_task
MODIFY cutoff_datetime TIMESTAMP
;
ALTER TABLE bo_task
MODIFY underproc_datetime TIMESTAMP
;
ALTER TABLE bo_task
MODIFY undo_trade_time TIMESTAMP
;
ALTER TABLE bo_task_hist
MODIFY task_datetime TIMESTAMP
;
ALTER TABLE bo_task_hist
MODIFY undo_trade_time TIMESTAMP
;
ALTER TABLE bo_task_hist
MODIFY underproc_datetime TIMESTAMP
;
ALTER TABLE bo_task_hist
MODIFY cutoff_datetime TIMESTAMP
;
ALTER TABLE bo_task_hist
MODIFY kickoff_datetime TIMESTAMP
;
ALTER TABLE bo_task_hist
MODIFY completed_datetime TIMESTAMP
;
ALTER TABLE bo_task_hist
MODIFY new_datetime TIMESTAMP
;
ALTER TABLE corr_first_ax_hist
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_first_axis
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_formula
MODIFY corr_formula_dt TIMESTAMP
;
ALTER TABLE corr_mat_data_hist
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_matrix_data
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_matrix_hist
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_secnd_ax_hist
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_second_axis
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_surface_member
MODIFY SURFACE_DATETIME TIMESTAMP
;
ALTER TABLE corr_surf_ptadj
MODIFY SURFACE_DATETIME TIMESTAMP
;
ALTER TABLE corr_surf_qtvalue
MODIFY SURFACE_DATETIME TIMESTAMP
;
ALTER TABLE corr_tenor_ax_hist
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE corr_tenor_axis
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE correlation_matrix
MODIFY matrix_datetime TIMESTAMP
;
ALTER TABLE credit_event
MODIFY entered_datetime TIMESTAMP
;
ALTER TABLE credit_rating
MODIFY updated_datetime TIMESTAMP
;
ALTER TABLE curve
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_bas_hdr_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_bas_hdr_hist
MODIFY base_curve_dt TIMESTAMP
;
ALTER TABLE curve_bas_hdr_hist
MODIFY foreign_curve_dt TIMESTAMP
;
ALTER TABLE curve_basis_header
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_basis_header
MODIFY base_curve_dt TIMESTAMP
;
ALTER TABLE curve_basis_header
MODIFY foreign_curve_dt TIMESTAMP
;
ALTER TABLE curve_def_data
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_fx_hdr_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_fx_hdr_hist
MODIFY base_curve_dt TIMESTAMP
;
ALTER TABLE curve_fx_hdr_hist
MODIFY quote_curve_dt TIMESTAMP
;
ALTER TABLE curve_fx_header
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_fx_header
MODIFY base_curve_dt TIMESTAMP
;
ALTER TABLE curve_fx_header
MODIFY quote_curve_dt TIMESTAMP
;
ALTER TABLE curve_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_mem_rt_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_member
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_member_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_member_link
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_member_rt
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_memlink_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_param_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_parameter
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_pnt_adj_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_point
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_point_adj
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_point_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_prc_hdr_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_prc_hdr_hist
MODIFY disc_curve_date TIMESTAMP
;
ALTER TABLE curve_price_hdr
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_price_hdr
MODIFY disc_curve_date TIMESTAMP
;
ALTER TABLE curve_prob_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_prob_hist
MODIFY base_credit_crv_dt TIMESTAMP
;
ALTER TABLE curve_prob_hist
MODIFY base_curve_dt TIMESTAMP
;
ALTER TABLE curve_probability
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_probability
MODIFY base_curve_dt TIMESTAMP
;
ALTER TABLE curve_probability
MODIFY base_credit_crv_dt TIMESTAMP
;
ALTER TABLE curve_qt_adj_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_qt_val_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_quote_adj
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_quote_value
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_recov_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_recovery
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_repo_header
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_repohdr_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_spc_date
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_spcdate_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_tenor
MODIFY curve_date TIMESTAMP
;
ALTER TABLE curve_tenor_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE cust_curve_qt_hist
MODIFY curve_date TIMESTAMP
;
ALTER TABLE custom_curve_qt
MODIFY curve_date TIMESTAMP
;
ALTER TABLE customer_call
MODIFY date_time TIMESTAMP
;
ALTER TABLE entity_state
MODIFY create_date TIMESTAMP
;
ALTER TABLE entity_state
MODIFY modify_date TIMESTAMP
;
ALTER TABLE event_liqpos
MODIFY liquidated_date TIMESTAMP
;
ALTER TABLE event_plpos
MODIFY last_liq_date TIMESTAMP
;
ALTER TABLE event_trade
MODIFY o_trade_date TIMESTAMP
;
ALTER TABLE event_trade
MODIFY o_upd_datetime TIMESTAMP
;
ALTER TABLE event_trade
MODIFY o_entered_date TIMESTAMP
;
ALTER TABLE event_transfer
MODIFY trade_time TIMESTAMP
;
ALTER TABLE event_unliqpos
MODIFY liquidated_date TIMESTAMP
;
ALTER TABLE fee_grid
MODIFY entered_date TIMESTAMP
;
ALTER TABLE feed_handler_log
MODIFY date_time TIMESTAMP
;
ALTER TABLE folder
MODIFY update_date TIMESTAMP
;
ALTER TABLE incoming_doc_hist
MODIFY gen_datetime TIMESTAMP
;
ALTER TABLE incoming_document
MODIFY gen_datetime TIMESTAMP
;
ALTER TABLE legal_entity
MODIFY entered_date TIMESTAMP
;
ALTER TABLE liq_position
MODIFY liquidated_date TIMESTAMP
;
ALTER TABLE liq_position_hist
MODIFY liquidated_date TIMESTAMP
;
ALTER TABLE message_cmt_hist
MODIFY gen_datetime TIMESTAMP
;
ALTER TABLE message_cmt_hist
MODIFY invalidated_date TIMESTAMP
;
ALTER TABLE message_comment
MODIFY gen_datetime TIMESTAMP
;
ALTER TABLE message_comment
MODIFY invalidated_date TIMESTAMP
;
ALTER TABLE mrgcall_config
MODIFY starting_date TIMESTAMP
;
ALTER TABLE mrgcall_config
MODIFY closing_date TIMESTAMP
;
ALTER TABLE mutation
MODIFY proc_date TIMESTAMP
;
ALTER TABLE mutation
MODIFY effect_date TIMESTAMP
;
ALTER TABLE mutation
MODIFY entered_date TIMESTAMP
;
ALTER TABLE passwd_history
MODIFY passwd_chg TIMESTAMP
;
ALTER TABLE pending_modif
MODIFY modif_date TIMESTAMP
;
ALTER TABLE pending_modif
MODIFY eff_datetime TIMESTAMP
;
ALTER TABLE pl_position
MODIFY last_liq_date TIMESTAMP
;
ALTER TABLE pl_position_hist
MODIFY last_liq_date TIMESTAMP
;
ALTER TABLE position_snap
MODIFY SNAPSHOT_DATE TIMESTAMP
;
ALTER TABLE position_snap
MODIFY UPDATE_TIME TIMESTAMP
;
ALTER TABLE product_adr
MODIFY entered_date TIMESTAMP
;
ALTER TABLE product_bond
MODIFY entered_date TIMESTAMP
;
ALTER TABLE product_equity
MODIFY entered_date TIMESTAMP
;
ALTER TABLE product_fx_ndf
MODIFY reset_date_time TIMESTAMP
;
ALTER TABLE product_otcoption
MODIFY effective_datetime TIMESTAMP
;
ALTER TABLE product_otcoption
MODIFY maturity_datetime TIMESTAMP
;
ALTER TABLE product_structured
MODIFY entered_date TIMESTAMP
;
ALTER TABLE product_tlock
MODIFY entered_date TIMESTAMP
;
ALTER TABLE ps_event
MODIFY upd_time TIMESTAMP
;
ALTER TABLE quote_value
MODIFY entered_datetime TIMESTAMP
;
ALTER TABLE ref_entity_changes
MODIFY modif_date TIMESTAMP
;
ALTER TABLE sched_task
MODIFY entered_date TIMESTAMP
;
ALTER TABLE sched_task_exec
MODIFY exec_time TIMESTAMP
;
ALTER TABLE sched_task_exec
MODIFY end_time TIMESTAMP
;
ALTER TABLE sec_basket_changes
MODIFY modif_date TIMESTAMP
;
ALTER TABLE surf_spc_date_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE surface_spc_date
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE trade
MODIFY entered_date TIMESTAMP
;
ALTER TABLE trade
MODIFY update_date_time TIMESTAMP
;
ALTER TABLE trade
MODIFY trade_date_time TIMESTAMP
;
ALTER TABLE trade_hist
MODIFY trade_date_time TIMESTAMP
;
ALTER TABLE trade_hist
MODIFY update_date_time TIMESTAMP
;
ALTER TABLE trade_hist
MODIFY entered_date TIMESTAMP
;
ALTER TABLE trade_open_qty
MODIFY trade_date TIMESTAMP
;
ALTER TABLE trade_open_qty
MODIFY entered_date TIMESTAMP
;
ALTER TABLE trade_openqty_hist
MODIFY trade_date TIMESTAMP
;
ALTER TABLE trade_openqty_hist
MODIFY entered_date TIMESTAMP
;
ALTER TABLE user_last_login
MODIFY last_login_date TIMESTAMP
;
ALTER TABLE user_last_login
MODIFY succ_login_date TIMESTAMP
;
ALTER TABLE user_login_att
MODIFY login_date TIMESTAMP
;
ALTER TABLE user_login_hist
MODIFY login_date TIMESTAMP
;
ALTER TABLE user_name
MODIFY acc_locked_date TIMESTAMP
;
ALTER TABLE vol_pt_blob
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_pt_blob_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_srfexpten_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surf_exptenor
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surf_mem_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surf_param
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surf_pnt_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surf_pointadj
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surf_qtvalue
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surf_strk_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surface
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surface_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surface_member
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surface_point
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surface_strike
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surface_tenor
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surfparam_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surfptadj_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surfqtval_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE vol_surftenor_hist
MODIFY vol_surface_date TIMESTAMP
;
ALTER TABLE ttm_rate
MODIFY ttm_date TIMESTAMP 
;
ALTER TABLE  obj_request_log
MODIFY last_req_date_time TIMESTAMP
;
ALTER TABLE  settle_position
MODIFY update_time TIMESTAMP
;
ALTER TABLE fee_billing 
MODIFY 	entered_date TIMESTAMP
;
ALTER TABLE webfx_log 
MODIFY 	update_datetime TIMESTAMP 
;
ALTER TABLE curve_commodity_hdr_hist
MODIFY 	base_curve_dt TIMESTAMP
;
ALTER TABLE curve_commodity_hdr
MODIFY 	curve_date TIMESTAMP 
;
ALTER TABLE curve_commodity_hdr_hist
MODIFY 	curve_date TIMESTAMP
;

ALTER TABLE curve_commodity_hdr
MODIFY 	  base_curve_dt TIMESTAMP 
;

ALTER TABLE  report_browser_config 
MODIFY modified_time TIMESTAMP
;
ALTER TABLE   position
MODIFY update_time TIMESTAMP
;

ALTER TABLE  settle_position_chg
MODIFY LAST_TRADE_DATE TIMESTAMP
;
ALTER TABLE  settle_position_chg
MODIFY UPDATE_TIME TIMESTAMP
;
ALTER TABLE  settle_position_snap
MODIFY SNAPSHOT_DATE TIMESTAMP
;
ALTER TABLE  settle_position_snap
MODIFY UPDATE_TIME TIMESTAMP
;


CREATE OR REPLACE PROCEDURE sp_save_pl_pos (arg_unrealized  IN FLOAT,
				   arg_realized  IN FLOAT,
				   arg_productId  IN NUMBER,
				   arg_bookId     IN NUMBER,
				   arg_last_liq_date IN TIMESTAMP,
				   arg_last_average_price IN FLOAT,
				   arg_current_avg_price IN FLOAT,
				   arg_last_liq_id IN NUMBER)
AS BEGIN

UPDATE pl_position SET realized = arg_realized ,
		       unrealized = arg_unrealized,
		       last_liq_date = arg_last_liq_date,
		       last_average_price = arg_last_average_price,
		       current_avg_price = arg_current_avg_price,
		       last_liq_id = arg_last_liq_id
	       	       WHERE product_id = arg_productId AND
			     book_id = arg_bookId ;
IF SQL%ROWCOUNT = 0 THEN
    INSERT INTO pl_position( product_id,book_id,realized,unrealized,last_liq_date,last_average_price,current_avg_price,last_liq_id)
    VALUES(arg_productId,arg_bookId,arg_realized,arg_unrealized,arg_last_liq_date,arg_last_average_price,arg_current_avg_price,arg_last_liq_id);
END IF;
END ;  
/

CREATE OR REPLACE PROCEDURE sp_save_liq_pos (arg_trade1      IN NUMBER,
					   arg_trade2      IN NUMBER,
					   arg_date       IN TIMESTAMP,
					   arg_quantity   IN FLOAT,
					   arg_price1     IN FLOAT,
					   arg_price2     IN FLOAT,
					   arg_bookId     IN FLOAT,
					   arg_product_id  IN NUMBER,
					   arg_start_date  IN TIMESTAMP,
					   arg_last_average_price IN FLOAT,
					   arg_ca_amount   IN FLOAT,
				           arg_first_accrual IN FLOAT,
					   arg_second_accrual IN FLOAT,
					   arg_order_id  IN NUMBER,
					   arg_first_settle_date IN DATE,
					   arg_second_settle_date IN DATE,
					   arg_type IN NUMBER,
					   arg_is_deleted IN CHAR,
					   arg_last_liq_id IN NUMBER,
					   arg_first_rel_id IN NUMBER,
					   arg_sec_rel_id IN NUMBER,
					   arg_initial_id IN NUMBER,
					   arg_face_value IN FLOAT)
AS BEGIN
INSERT INTO liq_position(first_trade, second_trade,
	liquidated_date, quantity, first_price, second_price,
	book_id, product_id,start_date,last_average_price,ca_amount,first_accrual,second_accrual,order_id,first_settle_date,second_settle_date,type,is_deleted,last_liq_id,first_rel_id,sec_rel_id,initial_id,face_value)
VALUES (arg_trade1,arg_trade2,arg_date,arg_quantity,arg_price1,arg_price2,arg_bookId,arg_product_id,arg_start_date,arg_last_average_price,arg_ca_amount,arg_first_accrual,arg_second_accrual,arg_order_id,arg_first_settle_date,arg_second_settle_date,arg_type,arg_is_deleted,arg_last_liq_id,arg_first_rel_id,arg_sec_rel_id,arg_initial_id,arg_face_value);

END ;  
/



CREATE OR REPLACE PROCEDURE sp_save_trade(arg_trade_id   IN NUMBER,
			    arg_product_id   IN NUMBER,
			    arg_trade_date_time  IN TIMESTAMP,
			    arg_settlement_date  IN DATE,
			    arg_quantity  IN FLOAT,
			    arg_trade_price  IN FLOAT,
			    arg_trade_currency  IN CHAR,
			    arg_settle_currency  IN CHAR,
			    arg_trader_name   IN VARCHAR,
			    arg_cpty_id   IN NUMBER,
			    arg_book_id   IN NUMBER,
			    arg_trade_status    IN VARCHAR,
			    arg_entered_date  IN TIMESTAMP,
			    arg_entered_user   IN VARCHAR,
			    arg_comments  IN VARCHAR,
			    arg_exchange_traded IN CHAR,
			    arg_exchange_id  IN INTEGER,
			    arg_accrual       IN FLOAT,
			    arg_update_date_time IN TIMESTAMP,
			    arg_bundle_id    IN NUMBER,
			    arg_action	 IN VARCHAR,
	arg_internal_reference  IN VARCHAR ,
	arg_external_reference  IN VARCHAR ,
	arg_split_book_price  IN NUMBER,
	arg_split_base_price  IN NUMBER,
	arg_split_currency IN CHAR,
	arg_sales_p       IN VARCHAR,
	arg_mirror_trade_id IN INTEGER,
	arg_neg_trade_price IN FLOAT,
	arg_neg_price_type IN VARCHAR,
	arg_custom_xfrule_b IN INTEGER,
	arg_le_role           IN VARCHAR ,
	arg_market_type    IN  VARCHAR,
	arg_market_info   IN FLOAT,
	arg_alternate_date IN DATE,
	arg_custom_data   IN VARCHAR,
	arg_mirror_book_id IN INTEGER,
	arg_modified_user IN VARCHAR)
AS BEGIN

INSERT INTO trade(trade_id,product_id,
                  trade_date_time,settlement_date,quantity,trade_price,
		  trade_currency,settle_currency,trader_name,cpty_id,
		  book_id,trade_status,entered_date,entered_user,comments,
		  exchange_traded,exchange_id,accrual,
		update_date_time,bundle_id,trade_action,
	internal_reference,external_reference,split_book_price,
	split_base_price,split_currency,sales_person,mirror_trade_id,
	neg_trade_price,neg_price_type,custom_xfrule_b,le_role,market_type,
	market_info,alternate_date,version_num,custom_data,
	mirror_book_id,modified_user)
VALUES(arg_trade_id,arg_product_id,arg_trade_date_time,
       arg_settlement_date,arg_quantity,arg_trade_price,arg_trade_currency,
       arg_settle_currency,arg_trader_name,arg_cpty_id,
       arg_book_id,arg_trade_status,
       arg_entered_date,arg_entered_user,arg_comments,
       arg_exchange_traded,
       arg_exchange_id,arg_accrual,arg_update_date_time,
       arg_bundle_id,arg_action,
	arg_internal_reference,arg_external_reference,arg_split_book_price,
	arg_split_base_price,arg_split_currency,arg_sales_p,
	arg_mirror_trade_id,arg_neg_trade_price,arg_neg_price_type,
	arg_custom_xfrule_b, arg_le_role,arg_market_type,
	arg_market_info,arg_alternate_date,0,arg_custom_data,
	arg_mirror_book_id,arg_modified_user)   ;

END ;  
/



CREATE OR REPLACE PROCEDURE sp_update_trade(arg_trade_id   IN NUMBER,
			    arg_product_id   IN NUMBER,
			    arg_trade_date_time  IN TIMESTAMP,
			    arg_settlement_date  IN DATE,
			    arg_quantity  IN FLOAT,
			    arg_trade_price  IN FLOAT,
			    arg_trade_currency  IN CHAR,
			    arg_settle_currency  IN CHAR,
			    arg_trader_name   IN VARCHAR,
			    arg_cpty_id   IN NUMBER,
			    arg_book_id   IN NUMBER,
			    arg_trade_status   IN VARCHAR,
			    arg_entered_date  IN TIMESTAMP,
			    arg_entered_user   IN VARCHAR,
			    arg_comments  IN VARCHAR,
			    arg_exchange_traded IN CHAR,
			    arg_exchange_id  IN INTEGER,
			    arg_accrual       IN FLOAT,
			    arg_update_date_time IN TIMESTAMP,
			    arg_bundle_id  IN NUMBER,
			    arg_action     IN VARCHAR,
	arg_internal_reference  IN VARCHAR   ,
	arg_external_reference  IN VARCHAR,
	arg_split_book_price  IN NUMBER,
	arg_split_base_price  IN NUMBER,
	arg_split_currency  IN  CHAR,
        arg_sales_p         IN VARCHAR,
	arg_mirror_trade_id IN INTEGER,
	arg_neg_trade_price FLOAT,
	arg_neg_price_type VARCHAR,
	arg_custom_xfrule_b IN INTEGER,
	arg_le_role           IN VARCHAR ,
	arg_market_type    IN  VARCHAR,
	arg_market_info   IN FLOAT,
	arg_alternate_date IN DATE,
	arg_version_num IN INTEGER,
	arg_custom_data IN VARCHAR,
	arg_mirror_book_id IN INTEGER
	)
AS BEGIN

UPDATE trade SET 
	product_id = arg_product_id,
	trade_date_time = arg_trade_date_time,
        settlement_date = arg_settlement_date,
	quantity=arg_quantity,
	trade_price = arg_trade_price,
	trade_currency = arg_trade_currency,
        settle_currency = arg_settle_currency,
	trader_name = arg_trader_name,
	cpty_id = arg_cpty_id,
	book_id = arg_book_id,
	trade_status = arg_trade_status,
        entered_date = arg_entered_date,
	entered_user = arg_entered_user,
	comments = arg_comments,
	exchange_traded = arg_exchange_traded,
	exchange_id = arg_exchange_id,
	accrual = arg_accrual,
	update_date_time = arg_update_date_time,
	bundle_id = arg_bundle_id,
	trade_action = arg_action,
	internal_reference=arg_internal_reference,
	external_reference=arg_external_reference,
	split_book_price=arg_split_book_price,	
	split_base_price=arg_split_base_price,
	split_currency=arg_split_currency,
        sales_person = arg_sales_p,
	mirror_trade_id=arg_mirror_trade_id,
	neg_trade_price=arg_neg_trade_price,
	neg_price_type=arg_neg_price_type,
	custom_xfrule_b=arg_custom_xfrule_b,	
	le_role=arg_le_role,
	market_type=arg_market_type,
	market_info=arg_market_info,
	alternate_date=arg_alternate_date,
	version_num = arg_version_num,
	custom_data=arg_custom_data,
	mirror_book_id=arg_mirror_book_id
WHERE trade_id = arg_trade_id  ;

END;  
/

CREATE OR REPLACE PROCEDURE sp_save_bo_posting(
        arg_bo_posting_id      IN NUMBER,
        arg_bo_posting_type     IN VARCHAR,
        arg_description       IN VARCHAR,
        arg_amount           IN FLOAT,
        arg_currency_code    IN CHAR,
        arg_trade_id          IN NUMBER,
        arg_product_id        IN NUMBER,
        arg_posting_type      IN VARCHAR,
        arg_debit_acc_id         IN NUMBER,
        arg_credit_acc_id         IN NUMBER,
        arg_linked_id         IN NUMBER,
        arg_original_event    IN VARCHAR,
        arg_creation_date    IN TIMESTAMP,
        arg_effective_date   IN DATE,
        arg_booking_date     IN DATE,
        arg_acc_rule_id       IN NUMBER,
        arg_sent_date        IN TIMESTAMP,
        arg_sent_status       IN VARCHAR,
        arg_matching         IN CHAR,
        arg_other_amount     IN FLOAT,
        arg_book_id           IN NUMBER,
        arg_transfer_id       IN NUMBER,
        arg_sub_id            IN NUMBER,
        arg_config_id         IN NUMBER,
        arg_process_flags     IN VARCHAR,
        arg_trade_version     IN INTEGER,
        arg_update_time       IN TIMESTAMP,
        arg_xfer_version      IN INTEGER,
        arg_version_num       IN INTEGER,
        arg_entered_user      IN VARCHAR)

AS BEGIN

INSERT INTO 
bo_posting ( bo_posting_id,
                        bo_posting_type,
                        description,
                        amount,
                        currency_code,
                        trade_id,
                        product_id,
                        posting_type,
                        debit_acc_id,
                        credit_acc_id,
                        linked_id,
                        original_event,
                        creation_date,
                        effective_date,
                        booking_date,
                        acc_rule_id,
                        sent_date,
                        sent_status,
                        matching,
                        other_amount,
                        book_id,
                        transfer_id,
                        sub_id,
                        config_id,
                        process_flags,
                        trade_version,
                        update_time,
                        xfer_version,
                        version_num,
                        entered_user)
VALUES (arg_bo_posting_id,
        arg_bo_posting_type,
        arg_description,
        arg_amount,
        arg_currency_code,
        arg_trade_id,
        arg_product_id,
        arg_posting_type,
        arg_debit_acc_id,
        arg_credit_acc_id,
        arg_linked_id,
        arg_original_event,
        arg_creation_date,
        arg_effective_date,
        arg_booking_date,
        arg_acc_rule_id,
        arg_sent_date,
        arg_sent_status,
        arg_matching,
        arg_other_amount,
        arg_book_id,
        arg_transfer_id,
        arg_sub_id,
        arg_config_id,
        arg_process_flags,
        arg_trade_version,
        arg_update_time,
        arg_xfer_version,
        arg_version_num,
        arg_entered_user);
END;
/

CREATE OR REPLACE PROCEDURE sp_save_message(
	arg_message_id         IN NUMBER,
	arg_trade_id           IN NUMBER,
	arg_event_type         IN VARCHAR,
	arg_product_family     IN VARCHAR,
	arg_product_type       IN VARCHAR,
	arg_message_type       IN VARCHAR,
	arg_sender_id            IN NUMBER,
	arg_sender_role         IN VARCHAR ,
	arg_send_contact_type  IN VARCHAR,
	arg_send_address_code  IN VARCHAR, 
	arg_receiver_id             IN NUMBER,
	arg_receiver_role        IN VARCHAR,
	arg_rec_contact_type  IN VARCHAR,
	arg_rec_address_code	 IN VARCHAR, 
	arg_address_method       IN VARCHAR,
	arg_language             IN VARCHAR,
	arg_gateway              IN VARCHAR,
	arg_creation_date       IN TIMESTAMP,
	arg_message_status      IN VARCHAR ,
	arg_matching_b          IN CHAR,
	arg_template_name        IN VARCHAR,
	arg_action		 IN VARCHAR,
	arg_linked_id	         IN NUMBER,
	arg_transfer_id 	 IN NUMBER,
	arg_reset_date         IN DATE,
	arg_sub_action	        IN VARCHAR,
	arg_sender_cont_id      IN NUMBER,
	arg_rec_cont_id    IN NUMBER,
	arg_message_class	IN VARCHAR,
	arg_format_type         IN VARCHAR,
	arg_trade_time	        IN TIMESTAMP,
	arg_doc_edited_b        IN CHAR,
	arg_advice_cfg_id       IN NUMBER,
	arg_statement_id        IN NUMBER,
	arg_description         IN VARCHAR,
	arg_trade_version       IN INTEGER,
	arg_xfer_version       IN INTEGER,
	arg_external_b	       IN CHAR)

AS BEGIN

INSERT INTO bo_message (message_id,
	trade_id ,
	event_type ,
	product_family,
	product_type  ,
	message_type ,
	sender_id       ,
	sender_role       ,
	send_contact_type ,
	send_address_code, 
	receiver_id          ,
	receiver_role     ,
	rec_contact_type ,
	rec_address_code	, 
	address_method   ,
	m_language       ,
	gateway        ,
	creation_date     ,
	message_status   ,
	matching_b     ,
	template_name,
	m_action	,
	linked_id	,
	transfer_id  ,
	reset_date,
	sub_action,
	sender_contact_id,
	rec_contact_id,
	message_class,format_type,
	trade_time,
	doc_edited_b,
	advice_cfg_id,
	statement_id,
	description,
	trade_version,
	xfer_version,
	external_b)
VALUES (arg_message_id,
	arg_trade_id ,
	arg_event_type ,
	arg_product_family,
	arg_product_type  ,
	arg_message_type ,
	arg_sender_id       ,
	arg_sender_role       ,
	arg_send_contact_type ,
	arg_send_address_code, 
	arg_receiver_id          ,
	arg_receiver_role     ,
	arg_rec_contact_type ,
	arg_rec_address_code	, 
	arg_address_method   ,
	arg_language       ,
	arg_gateway        ,
	arg_creation_date     ,
	arg_message_status   ,
	arg_matching_b     ,
	arg_template_name,
	arg_action	,
	arg_linked_id	,
	arg_transfer_id ,
	arg_reset_date,
	arg_sub_action,
	arg_sender_cont_id,
	arg_rec_cont_id,
	arg_message_class,arg_format_type,
	arg_trade_time,
	arg_doc_edited_b,
	arg_advice_cfg_id,
	arg_statement_id,
	arg_description,
	arg_trade_version,
	arg_xfer_version,
	arg_external_b);

END;
/


CREATE OR REPLACE PROCEDURE sp_save_openqty  (arg_trade_id  IN NUMBER,
				   arg_product_id 	 IN NUMBER,
				   arg_settle_date 	IN DATE,
				   arg_trade_date    IN TIMESTAMP,
				   arg_quantity    IN FLOAT,
				   arg_open_quantity IN FLOAT,
				   arg_price	IN FLOAT,
				   arg_accrual    IN FLOAT,
				   arg_open_repo_q IN FLOAT,
				   arg_book_id     IN NUMBER,
				   arg_product_fam IN VARCHAR,
				   arg_product_type IN VARCHAR,
				   arg_sign	    IN NUMBER,
				   arg_liquidable   IN CHAR,
				   arg_return       IN CHAR,
				   arg_returndate   IN DATE,
				   arg_entereddate  IN TIMESTAMP)
AS BEGIN
UPDATE trade_open_qty SET  trade_date = arg_trade_date,
		       quantity = arg_quantity,
		       open_quantity = arg_open_quantity,
		       price = arg_price,
		       accrual = arg_accrual,
		       open_repo_quantity = arg_open_repo_q,
		       book_id = arg_book_id,
		       product_family = arg_product_fam,
		       product_type = arg_product_type,
		       is_liquidable = arg_liquidable,
		       is_return = arg_return,
		       return_date = arg_returndate,
		       entered_date = arg_entereddate
	       	       WHERE trade_id = arg_trade_id AND
			     product_id = arg_product_id AND
			     sign = arg_sign AND
			     settle_date = arg_settle_date ;
IF SQL%ROWCOUNT = 0 THEN
   INSERT INTO trade_open_qty(trade_id,product_id,settle_date,trade_date,quantity,open_quantity,price,accrual,open_repo_quantity,book_id,product_family,product_type,sign,is_liquidable,is_return,return_date,entered_date)
  VALUES(arg_trade_id,arg_product_id,arg_settle_date,arg_trade_date,arg_quantity,arg_open_quantity,arg_price,arg_accrual,arg_open_repo_q,arg_book_id,arg_product_fam,arg_product_type,arg_sign,arg_liquidable,arg_return,arg_returndate,
arg_entereddate);
END IF;
END;
/


CREATE OR REPLACE PROCEDURE sp_save_legent ( 
	arg_legal_entity_id  IN NUMBER , 
	arg_short_name         IN VARCHAR ,
	arg_long_name         IN VARCHAR ,
	arg_parent_le_id        IN NUMBER,
	arg_classification    IN VARCHAR ,
	arg_comments          IN VARCHAR ,
	arg_le_status         IN VARCHAR ,
	arg_country	  IN VARCHAR ,
	arg_inactive_date  IN DATE ,
	arg_entered_date   IN TIMESTAMP,
	arg_entered_user   IN VARCHAR,
	arg_holidays       IN VARCHAR,
	arg_version_num	   IN NUMBER,
	arg_external_ref IN VARCHAR)
AS 
BEGIN
INSERT INTO legal_entity(legal_entity_id, 
	short_name          ,
	long_name          ,
	parent_le_id  ,
	classification    ,
	comments       ,
	le_status,
	country,
	inactive_date,
	entered_date,
	entered_user,
	holidays,
	version_num,
	external_ref)
VALUES(arg_legal_entity_id, 
	arg_short_name          ,
	arg_long_name      ,
	arg_parent_le_id  ,
	arg_classification    ,
	arg_comments       ,
	arg_le_status,
	arg_country,
	arg_inactive_date,
	arg_entered_date,
	arg_entered_user,
	arg_holidays, 
	arg_version_num,
	arg_external_ref);
END;
/

CREATE OR REPLACE PROCEDURE sp_update_quote
	(arg_quote_set_name IN VARCHAR ,
	arg_quote_name IN VARCHAR,
	arg_quote_date IN DATE, 
	arg_bid IN NUMBER,
	arg_ask IN NUMBER,
	arg_open_quote IN NUMBER,
	arg_close_quote IN NUMBER ,
	arg_quote_type IN VARCHAR,
	arg_entered_datetime IN TIMESTAMP,
	arg_version_num IN NUMBER,
	arg_entered_user IN VARCHAR,
	arg_high IN FLOAT,
	arg_low IN FLOAT,
	arg_estimated_b IN INTEGER,
	arg_last_quote IN  NUMBER,
	arg_known_date IN DATE,
	arg_source_name IN VARCHAR
	)
AS 
BEGIN
UPDATE quote_value
SET bid=arg_bid,
ask=arg_ask,
open_quote=arg_open_quote,
close_quote=arg_close_quote,
quote_type=arg_quote_type,
entered_datetime=arg_entered_datetime,
version_num=arg_version_num,
entered_user=arg_entered_user,
high=arg_high,
low=arg_low,
estimated_b=arg_estimated_b,
last_quote=arg_last_quote,
known_date=arg_known_date,
source_name=arg_source_name
WHERE  
	quote_set_name = arg_quote_set_name AND     
	quote_name = arg_quote_name AND
     quote_date = arg_quote_date;
END;
/
CREATE OR REPLACE PROCEDURE sp_save_quote
	(arg_quote_set_name IN VARCHAR ,
	arg_quote_name IN VARCHAR,
	arg_quote_date IN DATE, 
	arg_bid IN NUMBER,
	arg_ask IN NUMBER,
	arg_open_quote IN NUMBER,
	arg_close_quote IN NUMBER ,
	arg_quote_type IN VARCHAR,
	arg_entered_datetime IN TIMESTAMP,
	arg_version_num IN NUMBER,
	arg_entered_user IN VARCHAR,
	arg_high IN FLOAT,
	arg_low IN FLOAT,
	arg_estimated_b IN INTEGER,
	arg_last_quote IN NUMBER,
	arg_known_date IN DATE,
	arg_source_name IN VARCHAR)
IS
BEGIN
INSERT INTO quote_value(quote_set_name,quote_name,quote_date,
	bid,ask,open_quote,close_quote,quote_type,entered_datetime,
	version_num,entered_user,high,low,estimated_b,last_quote,known_date,source_name)
VALUES(arg_quote_set_name,arg_quote_name,arg_quote_date,
	arg_bid,arg_ask,arg_open_quote,arg_close_quote,arg_quote_type,
	arg_entered_datetime,arg_version_num,arg_entered_user,
	arg_high,arg_low,arg_estimated_b,arg_last_quote,arg_known_date,arg_source_name);
END;
/


CREATE OR REPLACE PROCEDURE sp_save_bo_task(
	a_task_id        IN NUMBER ,
	a_event_type     IN VARCHAR,
	a_event_class    IN VARCHAR,
	a_trade_id       IN NUMBER,
	a_product_id	 IN NUMBER,
	a_object_id     IN NUMBER,
	a_book_id        IN NUMBER,
	a_task_status    IN NUMBER,
	a_task_owner     IN VARCHAR,
	a_task_datetime IN TIMESTAMP,
	a_source         IN VARCHAR,
	a_comments       IN VARCHAR,
	a_object_status  IN VARCHAR,
	a_undo_trade_time IN TIMESTAMP,
	a_new_datetime	IN TIMESTAMP,
	a_underproc_time IN TIMESTAMP,
	a_completed_datetime	IN TIMESTAMP,
	a_task_priority	IN NUMBER,
	a_task_wfw_id IN NUMBER,
	a_cutoff IN TIMESTAMP,
	a_settlement_method IN VARCHAR,
	a_legal_entity_id IN NUMBER,
	a_kickoff IN TIMESTAMP,
	a_link_id IN INTEGER,
	a_user_comment IN VARCHAR,
	a_kickoff_id  IN INTEGER,
	a_obj_date  IN DATE,
	a_previous_user IN VARCHAR,
	a_trade_version IN INTEGER,
	a_int_reference IN VARCHAR,
	a_object_classname IN VARCHAR)
AS BEGIN
INSERT INTO bo_task(task_id,event_type ,event_class,trade_id,product_id,object_id,
	book_id ,task_status  ,	task_owner,task_datetime,
	source,	comments ,object_status,
	undo_trade_time ,new_datetime,underproc_datetime ,
	completed_datetime,task_priority,task_wfw_id,cutoff_datetime,settlement_method,legal_entity_id,kickoff_datetime,link_id,user_comment,kickoff_id,
	object_date,previous_user,trade_version,int_reference,object_classname)
VALUES(a_task_id,a_event_type ,a_event_class,a_trade_id,a_product_id,a_object_id,
	a_book_id ,a_task_status  ,a_task_owner,a_task_datetime,
	a_source, a_comments ,a_object_status,
	a_undo_trade_time ,a_new_datetime,
	a_underproc_time ,
	a_completed_datetime,a_task_priority,
	a_task_wfw_id,a_cutoff,a_settlement_method,a_legal_entity_id,
	a_kickoff,a_link_id,a_user_comment,a_kickoff_id,a_obj_date,
	a_previous_user,a_trade_version,a_int_reference,a_object_classname);
END;
/


CREATE OR REPLACE PROCEDURE sp_update_bo_task(
	a_task_id        IN NUMBER ,
	a_task_status    IN NUMBER,
	a_task_owner     IN VARCHAR,
	a_task_datetime IN TIMESTAMP,
	a_new_datetime	IN TIMESTAMP,
	a_underproc_time IN TIMESTAMP,
	a_completed_datetime	IN TIMESTAMP,
	a_task_priority	IN NUMBER,
	a_task_wfw_id IN NUMBER,
	a_cutoff IN TIMESTAMP,
	a_comments IN VARCHAR,
	a_kickoff IN TIMESTAMP,
	a_link_id IN INTEGER,
	a_user_comment IN VARCHAR,
	a_kickoff_id    IN INTEGER,
	a_object_id    IN INTEGER,
	a_obj_date IN DATE,
	a_previous_user IN VARCHAR,
	a_trade_version IN INTEGER,
	a_int_reference IN VARCHAR,
	a_object_classname IN VARCHAR)
AS BEGIN
UPDATE  bo_task
SET     task_status=a_task_status,
	task_owner=a_task_owner,
	task_datetime=a_task_datetime,
	new_datetime	=a_new_datetime	,
	underproc_datetime=a_underproc_time,
	completed_datetime=a_completed_datetime,
	task_priority=a_task_priority,
	task_wfw_id=a_task_wfw_id,
	cutoff_datetime = a_cutoff,
	comments = a_comments,
	kickoff_datetime = a_kickoff,
	link_id=a_link_id,
	user_comment=a_user_comment,
	kickoff_id =a_kickoff_id,
	object_id =a_object_id,
	object_date=a_obj_date,
	previous_user=a_previous_user,
	trade_version=a_trade_version,
	int_reference = a_int_reference,
	object_classname = a_object_classname
WHERE task_id=a_task_id;
END;
/

CREATE OR REPLACE PROCEDURE sp_upd_bo_message(
	arg_message_id         IN NUMBER,
	arg_trade_id           IN NUMBER,
	arg_event_type         IN VARCHAR,
	arg_product_family     IN VARCHAR,
	arg_product_type       IN VARCHAR,
	arg_message_type       IN VARCHAR,
	arg_sender_id             IN NUMBER,
	arg_sender_role         IN VARCHAR ,
	arg_send_contact_type  IN VARCHAR,
	arg_send_address_code  IN VARCHAR, 
	arg_receiver             IN VARCHAR,
	arg_receiver_role        IN VARCHAR,
	arg_rec_contact_type  IN VARCHAR,
	arg_rec_address_code	 IN VARCHAR, 
	arg_address_method       IN VARCHAR,
	arg_language             IN VARCHAR,
	arg_gateway              IN VARCHAR,
	arg_creation_date       IN TIMESTAMP,
	arg_message_status      IN VARCHAR ,
	arg_matching_b           IN CHAR,
	arg_template_name        IN VARCHAR,
	arg_action		 IN VARCHAR,
	arg_linked_id	         IN NUMBER,
	arg_transfer_id 	 IN NUMBER,
	arg_reset_date         IN DATE,
	arg_sub_action	        IN VARCHAR,
	arg_sender_cont_id      IN NUMBER,
	arg_rec_cont_id    IN NUMBER,
	arg_message_class	IN VARCHAR,
	arg_format_type         IN VARCHAR,
	arg_trade_time		IN TIMESTAMP,
	arg_doc_edited_b        IN CHAR,
	arg_advice_cfg_id	IN NUMBER,
	arg_statement_id        IN NUMBER,
	arg_description         IN VARCHAR,
	arg_trade_version       IN INTEGER,
	arg_xfer_version        IN INTEGER,
	arg_external_b		IN CHAR)

AS BEGIN

UPDATE  bo_message SET 
	trade_id =arg_trade_id ,
	event_type =arg_event_type ,
	product_family=arg_product_family,
	product_type  =arg_product_type  ,
	message_type =arg_message_type ,
	sender_id       =arg_sender_id       ,
	sender_role       =arg_sender_role       ,
	send_contact_type =arg_send_contact_type ,
	send_address_code=arg_send_address_code, 
	receiver_id          =arg_receiver          ,
	receiver_role     =arg_receiver_role     ,
	rec_contact_type =arg_rec_contact_type ,
	rec_address_code	=arg_rec_address_code	, 
	address_method   =arg_address_method   ,
	m_language       =arg_language       ,
	gateway        =arg_gateway        ,
	creation_date     =arg_creation_date     ,
	message_status   =arg_message_status   ,
	matching_b     =arg_matching_b     ,
	template_name=arg_template_name,
	m_action	=arg_action	,
	linked_id	=arg_linked_id	,
	transfer_id  =arg_transfer_id  ,
	reset_date=arg_reset_date,
	sub_action=arg_sub_action,
	sender_contact_id=arg_sender_cont_id,
	rec_contact_id=arg_rec_cont_id,
	message_class=arg_message_class,
	format_type=arg_format_type,
	trade_time = arg_trade_time,
	doc_edited_b=arg_doc_edited_b,
	advice_cfg_id = arg_advice_cfg_id,
	statement_id   = arg_statement_id,
	description=arg_description,
	trade_version=arg_trade_version,
	xfer_version=arg_xfer_version,
	external_b=arg_external_b
WHERE message_id = arg_message_id;
END;
/

CREATE OR REPLACE PROCEDURE sp_upd_bo_posting(
	arg_bo_posting_id      IN NUMBER,
	arg_bo_posting_type     IN VARCHAR,
	arg_description       IN VARCHAR,
	arg_amount           IN FLOAT,
	arg_currency_code    IN CHAR,
	arg_trade_id          IN NUMBER,
	arg_product_id        IN NUMBER,
	arg_posting_type      IN VARCHAR,
	arg_debit_acc_id          IN NUMBER,
	arg_credit_acc_id          IN NUMBER,
	arg_linked_id         IN NUMBER,                
	arg_original_event    IN VARCHAR,
	arg_creation_date    IN TIMESTAMP,
	arg_effective_date   IN DATE,
	arg_booking_date     IN DATE,
	arg_acc_rule_id       IN NUMBER,
	arg_sent_date        IN TIMESTAMP,
	arg_sent_status       IN VARCHAR,
	arg_matching         IN CHAR,
	arg_other_amount     IN FLOAT,
	arg_book_id	      IN NUMBER,
	arg_transfer_id	      IN NUMBER,
	arg_sub_id	      IN NUMBER,
	arg_config_id	      IN NUMBER,
	arg_process_flags     IN VARCHAR,
	arg_trade_version     IN INTEGER,
	arg_update_time       IN TIMESTAMP,
	arg_xfer_version      IN INTEGER)

AS BEGIN

UPDATE bo_posting SET
			bo_posting_type=arg_bo_posting_type,
			description=arg_description,
			amount=arg_amount,
			currency_code=arg_currency_code,
			trade_id=arg_trade_id,
			product_id=arg_product_id,
			posting_type=arg_posting_type,
			debit_acc_id=arg_debit_acc_id,
			credit_acc_id=arg_credit_acc_id,
			linked_id=arg_linked_id,                
			original_event=arg_original_event,
			creation_date=arg_creation_date,
			effective_date=arg_effective_date,
			booking_date=arg_booking_date,
			acc_rule_id=arg_acc_rule_id,
			sent_date=arg_sent_date,
			sent_status=arg_sent_status,
			matching=arg_matching,
			other_amount=arg_other_amount,
			book_id=arg_book_id,
			transfer_id=arg_transfer_id,
			sub_id=arg_sub_id,
			config_id=arg_config_id,
			process_flags=arg_process_flags,
			trade_version=arg_trade_version,
			update_time=arg_update_time,
			xfer_version=arg_xfer_version
WHERE  bo_posting_id=arg_bo_posting_id;
END;
/

CREATE OR REPLACE PROCEDURE sp_save_evtrade(
       arg_event_id        IN  INTEGER,
       arg_trade_id        IN  INTEGER  ,
       arg_event_type      IN  VARCHAR,
       arg_action_performed IN VARCHAR ,
       arg_o_trade_date     IN TIMESTAMP ,
       arg_o_settle_date    IN DATE ,
       arg_o_quantity       IN FLOAT,
       arg_o_price          IN FLOAT,
       arg_o_accrual        IN FLOAT,
       arg_o_status         IN VARCHAR ,
       arg_o_action         IN VARCHAR ,
       arg_o_upd_datetime   IN TIMESTAMP ,
       arg_o_book_id        IN INTEGER,
       arg_o_product_id     IN INTEGER,
       arg_o_entered_date   IN TIMESTAMP,
       arg_trade_version   IN INTEGER,
       arg_o_trade_version  IN INTEGER)
IS
BEGIN
INSERT INTO event_trade(event_id,     trade_id,event_type, action_performed,
       o_trade_date, o_settle_date,  o_quantity,    o_price,  o_accrual,
       o_status,  o_action, o_upd_datetime,  o_book_id,   o_product_id ,
       o_entered_date,trade_version, o_trade_version)
VALUES(arg_event_id,arg_trade_id,arg_event_type,arg_action_performed,
       arg_o_trade_date,arg_o_settle_date,arg_o_quantity ,
       arg_o_price ,arg_o_accrual ,arg_o_status ,arg_o_action,
       arg_o_upd_datetime,arg_o_book_id,arg_o_product_id,arg_o_entered_date,
       arg_trade_version,arg_o_trade_version);
END ;
/


CREATE OR REPLACE  PROCEDURE sp_save_evxfer(
        arg_event_id           INTEGER ,
       arg_transfer_id        INTEGER  ,
       arg_trade_id           INTEGER  ,
       arg_event_code         INTEGER,
       arg_event_status       VARCHAR ,
       arg_event_action       VARCHAR ,
       arg_old_status         VARCHAR ,
       arg_old_action         VARCHAR ,
       arg_is_reset_b	      CHAR,
       arg_old_trade_date     DATE,
       arg_old_book_id	      INTEGER,
       arg_old_avail_date     DATE,
       arg_old_settle_date    DATE,
       arg_old_settle_amount  FLOAT,
       arg_old_known_b        CHAR,
       arg_old_cash_amount    FLOAT,
       arg_trade_time         TIMESTAMP,
       arg_xfer_version       INTEGER   )
IS 
BEGIN
INSERT INTO event_transfer(event_id ,transfer_id ,trade_id ,event_code ,
       event_status,event_action,old_status,old_action,is_reset_b,
       old_trade_date,old_book_id,old_avail_date,old_settle_date,
       old_settle_amount,old_known_b,old_cash_amount,trade_time,xfer_version )
VALUES(arg_event_id ,arg_transfer_id ,arg_trade_id ,arg_event_code ,
       arg_event_status,arg_event_action,arg_old_status,arg_old_action,
       arg_is_reset_b,
       arg_old_trade_date,arg_old_book_id,arg_old_avail_date,
       arg_old_settle_date,arg_old_settle_amount,arg_old_known_b,
       arg_old_cash_amount,arg_trade_time,arg_xfer_version);
END ;
/

CREATE OR REPLACE PROCEDURE sp_save_in_message(
	arg_message_id         INTEGER,
	arg_object_id          INTEGER,
	arg_object_type        VARCHAR,
	arg_sender_id          INTEGER,
	arg_receiver_id        INTEGER,
	arg_in_message_type    VARCHAR,
	arg_in_transfer_type   VARCHAR,
	arg_in_status          VARCHAR,
	arg_address_method     VARCHAR,
	arg_role_type          VARCHAR,
	arg_in_comment         VARCHAR,
	arg_creation_date      TIMESTAMP,
	arg_settle_date        DATE,
	arg_cash_amount        FLOAT,
	arg_sec_quantity       FLOAT)
AS BEGIN
INSERT INTO bo_in_message (message_id,
	object_id,
	object_type,
	sender_id,
	receiver_id,
	in_message_type,
	in_transfer_type,
	in_status,
	address_method,
	role_type,
	in_comment,
	creation_date,
	settle_date,
	cash_amount,
	sec_quantity)
VALUES (arg_message_id,
	arg_object_id,
	arg_object_type,
	arg_sender_id,
	arg_receiver_id,
	arg_in_message_type,
	arg_in_transfer_type,
	arg_in_status,
	arg_address_method,
	arg_role_type,
	arg_in_comment,
	arg_creation_date,
	arg_settle_date,
	arg_cash_amount,
	arg_sec_quantity);
END ;
/

CREATE OR REPLACE PROCEDURE sp_upd_in_message(
	arg_message_id         IN INTEGER,
	arg_object_id          IN INTEGER,
	arg_object_type        IN VARCHAR,
	arg_sender_id          IN INTEGER,
	arg_receiver_id        IN INTEGER,
	arg_in_message_type    IN VARCHAR,
	arg_in_transfer_type   IN VARCHAR,
	arg_in_status          IN VARCHAR,
	arg_address_method     IN VARCHAR,
	arg_role_type          IN VARCHAR,
	arg_in_comment         IN VARCHAR,
	arg_creation_date      IN TIMESTAMP,
	arg_settle_date        IN DATE,
	arg_cash_amount        IN FLOAT,
	arg_sec_quantity       IN FLOAT)

AS BEGIN
UPDATE bo_in_message SET
	object_id=arg_object_id,
	object_type=arg_object_type,
	sender_id=arg_sender_id,
	receiver_id=arg_receiver_id,
	in_message_type=arg_in_message_type,
	in_transfer_type=arg_in_transfer_type,
	in_status=arg_in_status,
	address_method=arg_address_method,
	role_type=arg_role_type,
	in_comment=arg_in_comment,
	creation_date=arg_creation_date,
	settle_date=arg_settle_date,
	cash_amount=arg_cash_amount,
	sec_quantity=arg_sec_quantity
WHERE message_id=arg_message_id;

END ;
/

CREATE OR REPLACE PROCEDURE sp_save_bo_cre(
	arg_bo_cre_id      IN NUMBER,
	arg_bo_cre_type     IN VARCHAR,
	arg_description       IN VARCHAR,
	arg_trade_id          IN NUMBER,
	arg_lnk_trd_id        IN NUMBER,
	arg_product_id        IN NUMBER,
	arg_cre_type         IN VARCHAR,
	arg_linked_id         IN NUMBER,                
	arg_original_event    IN VARCHAR,
	arg_creation_date    IN TIMESTAMP,
	arg_effective_date   IN DATE,
	arg_booking_date     IN DATE,
	arg_acc_rule_id       IN NUMBER,
	arg_sent_date        IN TIMESTAMP,
	arg_cre_status       IN VARCHAR,
	arg_sent_status       IN VARCHAR,
	arg_matching         IN CHAR,
	arg_book_id	      IN NUMBER,
	arg_transfer_id	      IN NUMBER,
	arg_net_xfer_id	      IN NUMBER,
	arg_sub_id	      IN NUMBER,
	arg_config_id	      IN NUMBER,
	arg_settlement_date        IN DATE,
	arg_trade_date        IN DATE,
	arg_trade_version     IN INTEGER,
	arg_update_time       IN TIMESTAMP)

AS BEGIN

INSERT INTO bo_cre ( bo_cre_id,
			bo_cre_type,
			description,
			trade_id,
			linked_trade_id,
			product_id,
			cre_type,
			linked_id,                
			original_event,
			creation_date,
			effective_date,
			booking_date,
			acc_rule_id,
			sent_date,
			cre_status,
			sent_status,
			matching,
			book_id,
			transfer_id,
			netted_xfer_id,
			sub_id,
			config_id,
			settlement_date,
			trade_date,
			trade_version,
			update_time)
VALUES (arg_bo_cre_id,
	arg_bo_cre_type,
	arg_description,
	arg_trade_id,
	arg_lnk_trd_id,
	arg_product_id,
	arg_cre_type,
	arg_linked_id,                
	arg_original_event,
	arg_creation_date,
	arg_effective_date,
	arg_booking_date,
	arg_acc_rule_id,
	arg_sent_date,
	arg_cre_status,
	arg_sent_status,
	arg_matching,
	arg_book_id,
	arg_transfer_id,
	arg_net_xfer_id,
	arg_sub_id,
	arg_config_id,
	arg_settlement_date,
	arg_trade_date,
	arg_trade_version,
	arg_update_time);
END;
/

CREATE OR REPLACE PROCEDURE sp_upd_bo_cre(
	arg_bo_cre_id      IN NUMBER,
	arg_bo_cre_type     IN VARCHAR,
	arg_description       IN VARCHAR,
	arg_trade_id          IN NUMBER,
	arg_lnk_trd_id        IN NUMBER,
	arg_product_id        IN NUMBER,
	arg_cre_type         IN VARCHAR,
	arg_linked_id         IN NUMBER,                
	arg_original_event    IN VARCHAR,
	arg_creation_date    IN TIMESTAMP,
	arg_effective_date   IN DATE,
	arg_booking_date     IN DATE,
	arg_acc_rule_id       IN NUMBER,
	arg_sent_date        IN TIMESTAMP,
	arg_cre_status       IN VARCHAR,
	arg_sent_status       IN VARCHAR,
	arg_matching         IN CHAR,
	arg_book_id	      IN NUMBER,
	arg_transfer_id	      IN NUMBER,
	arg_net_xfer_id	      IN NUMBER,
	arg_sub_id	      IN NUMBER,
	arg_config_id	      IN NUMBER,
	arg_settlement_date        IN DATE,
	arg_trade_date        IN DATE,
	arg_trade_version     IN INTEGER,
	arg_update_time       IN TIMESTAMP)

AS BEGIN

UPDATE bo_cre SET
			bo_cre_type=arg_bo_cre_type,
			description=arg_description,
			trade_id=arg_trade_id,
			linked_trade_id=arg_lnk_trd_id,
			product_id=arg_product_id,
			cre_type=arg_cre_type,
			linked_id=arg_linked_id,                
			original_event=arg_original_event,
			creation_date=arg_creation_date,
			effective_date=arg_effective_date,
			booking_date=arg_booking_date,
			acc_rule_id=arg_acc_rule_id,
			sent_date=arg_sent_date,
			cre_status=arg_cre_status,
			sent_status=arg_sent_status,
			matching=arg_matching,
			book_id=arg_book_id,
			transfer_id=arg_transfer_id,
			netted_xfer_id=arg_net_xfer_id,
			sub_id=arg_sub_id,
			config_id=arg_config_id,
			settlement_date=arg_settlement_date,
			trade_date=arg_trade_date,
			trade_version=arg_trade_version,
			update_time=arg_update_time
WHERE  bo_cre_id=arg_bo_cre_id;
END;
/


CREATE OR REPLACE PROCEDURE sp_upd_stat_cre(
	arg_bo_cre_id      IN NUMBER,
	arg_sent_date        IN TIMESTAMP,
	arg_sent_status       IN VARCHAR,
	arg_update_time       IN TIMESTAMP)

AS BEGIN

UPDATE bo_cre SET
			sent_date=arg_sent_date,
			sent_status=arg_sent_status,
			update_time=arg_update_time
WHERE  bo_cre_id=arg_bo_cre_id;
END;
/



CREATE OR REPLACE PROCEDURE sp_cal_upd_proc(
       arg_id IN NUMBER,arg_engine IN VARCHAR,
       arg_engine_id IN NUMBER,
       arg_upd_time IN TIMESTAMP)
IS
BEGIN
UPDATE ps_event
SET    upd_time=arg_upd_time,
       handling=substr(handling,1,arg_engine_id-1) || 'Y' ||
	       substr(handling,arg_engine_id+1)
WHERE event_id=arg_id;
END;
/

/*  Bug 24550 */

ALTER TABLE analysis_output
MODIFY save_date_time TIMESTAMP
;

ALTER TABLE corr_matrix_param
MODIFY matrix_datetime TIMESTAMP
;

ALTER TABLE corr_mat_p_hist
MODIFY matrix_datetime TIMESTAMP
;

ALTER TABLE curve_div_ex_div
MODIFY curve_date TIMESTAMP
;

ALTER TABLE curve_div_ex_hist
MODIFY curve_date TIMESTAMP
;

ALTER TABLE curve_div_hdr
MODIFY curve_date TIMESTAMP
;

ALTER TABLE curve_div_hdr_hist
MODIFY curve_date TIMESTAMP
;

ALTER TABLE CURVE_FXD_HDR_HIST 
MODIFY CURVE_DATE TIMESTAMP
;

ALTER TABLE CURVE_FXD_HDR_HIST
MODIFY FX_CURVE_DT TIMESTAMP
;

ALTER TABLE CURVE_FXD_HDR_HIST
MODIFY ZERO_CURVE_DT TIMESTAMP
;

ALTER TABLE CURVE_FXD_HEADER
MODIFY CURVE_DATE TIMESTAMP
;

ALTER TABLE CURVE_FXD_HEADER
MODIFY FX_CURVE_DT TIMESTAMP
;

ALTER TABLE CURVE_FXD_HEADER
MODIFY ZERO_CURVE_DT TIMESTAMP
;

ALTER TABLE CURVE_TEMP
MODIFY CURVE_DATE TIMESTAMP
;

ALTER TABLE PEND_MODIF_AUDIT
MODIFY AUTH_DATETIME TIMESTAMP
;

ALTER TABLE PEND_MODIF_AUDIT
MODIFY EFF_DATETIME  TIMESTAMP
;

ALTER TABLE PEND_MODIF_AUDIT
MODIFY MODIF_DATE TIMESTAMP
;

ALTER TABLE PL_POSITION
MODIFY LAST_ARCH_DATE TIMESTAMP
;

ALTER TABLE PL_POSITION_HIST
MODIFY LAST_ARCH_DATE TIMESTAMP
;

ALTER TABLE PRODUCT_FX_TTM
MODIFY EXPIRY_DATE TIMESTAMP
;

ALTER TABLE PRODUCT_INTRA_MM
MODIFY END_TIME TIMESTAMP
;

ALTER TABLE PRODUCT_INTRA_MM
MODIFY INTEREST_TIME TIMESTAMP
;

ALTER TABLE PRODUCT_INTRA_MM
MODIFY PRINCIPAL_TIME TIMESTAMP
;

ALTER TABLE PRODUCT_INTRA_MM
MODIFY START_TIME TIMESTAMP
;

ALTER TABLE PRODUCT_LOAN
MODIFY ENTERED_DATE TIMESTAMP
;

ALTER TABLE PR_OTCOPTION_HIST
MODIFY EFFECTIVE_DATETIME TIMESTAMP
;

ALTER TABLE PR_OTCOPTION_HIST
MODIFY MATURITY_DATETIME TIMESTAMP
;

ALTER TABLE QS_REQUEST_LOG
MODIFY UPDATE_DATETIME TIMESTAMP
;

ALTER TABLE QUOTE_VALUE_HIST
MODIFY ENTERED_DATETIME TIMESTAMP
;

ALTER TABLE SCENARIO_REPORT
MODIFY REPORT_DATE TIMESTAMP
;

ALTER TABLE SCHED_TASK_EXEC
MODIFY VAL_TIME TIMESTAMP
;

ALTER TABLE SPECIFIC_FXRATE
MODIFY QUOTE_DATE TIMESTAMP
;

ALTER TABLE TRADE_NOTE
MODIFY CREATION_DATE TIMESTAMP
;

ALTER TABLE trade_note
MODIFY end_date TIMESTAMP
;

ALTER TABLE trade_note
MODIFY process_date TIMESTAMP
;

ALTER TABLE trade_note
MODIFY process_date TIMESTAMP
;
ALTER TABLE vol_quote_adj
modify vol_surface_date TIMESTAMP
;
ALTER TABLE vol_quote_adj_hist
modify vol_surface_date TIMESTAMP
;
