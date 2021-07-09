DELETE FROM inv_cashposition WHERE internal_external='MARGIN_CALL'
;

INSERT INTO inv_cashposition(
        internal_external,
        position_type,
        agent_id,
        account_id,
        date_type,
        position_date,
        currency_code,
        book_id,
	    config_id,
        total_amount,
        daily_change)
        
SELECT 'MARGIN_CALL',
       'THEORETICAL',
       mrgcall_config.legal_entity_id,
       0,
       'TRADE',
       mrgcall_cashpos.pos_date,
       mrgcall_cashpos.currency_code,
       mrgcall_config.book_id,
       mrgcall_cashpos.mrg_call_def,
       mrgcall_cashpos.pos_amount,
       mrgcall_cashpos.pos_daily
FROM mrgcall_cashpos,mrgcall_config
WHERE mrgcall_cashpos.mrg_call_def=mrgcall_config.mrg_call_def
;
        
DELETE FROM inv_secposition WHERE internal_external='MARGIN_CALL'
;      
  
INSERT INTO inv_secposition(
        internal_external,
        position_type,
        date_type,
        agent_id,
        account_id,
        position_date,
        security_id,
        book_id,
	    config_id,
        total_security,
        daily_security,
        total_borrowed,
        daily_borrowed,
        t_bor_not_avl,
        d_bor_not_avl,
        total_borrowed_ca,
        total_loaned,
        daily_loaned,
        t_loan_not_avl,
        d_loan_not_avl,
        total_loaned_ca,
        total_coll_in,
        daily_coll_in,
        t_coll_in_not_avl,
        d_coll_in_not_avl,
        total_coll_in_ca,
        total_coll_out,
        daily_coll_out,
        t_coll_out_not_avl,
        d_coll_out_not_avl,
        total_coll_out_ca,
        total_pledged_in,
        daily_pledged_in,
        total_pledged_out,
        daily_pledged_out,
        daily_coll_out_ca,
        daily_coll_in_ca)
        
SELECT  'MARGIN_CALL',
        'THEORETICAL',
        'TRADE',
        mrgcall_config.legal_entity_id,
        0,
        mrgcall_secpos.pos_date,
        mrgcall_secpos.security_id,
        mrgcall_config.book_id,
        mrgcall_secpos.mrg_call_def,
        mrgcall_secpos.pos_amount,
        mrgcall_secpos.pos_daily,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0        
FROM mrgcall_secpos,mrgcall_config
WHERE mrgcall_secpos.mrg_call_def=mrgcall_config.mrg_call_def
; 