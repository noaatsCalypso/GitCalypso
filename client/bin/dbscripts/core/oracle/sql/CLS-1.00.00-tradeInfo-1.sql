alter table cls_trade_info rename column THIRD_PARTY_TEXT to sender_receiver_info
;

/* Change datatype of notif_seq_no */

alter table cls_trade_info add (notif_seq_no_2 varchar2(22))
;
update cls_trade_info set notif_seq_no_2 = 'M'||trim(to_char(notif_seq_no,LPAD('X',LENGTH(notif_seq_no),'X')))
;
alter table cls_trade_info drop column notif_seq_no
;
alter table cls_trade_info rename column notif_seq_no_2 to notif_seq_no
;

alter table cls_trade_info add settlement_session varchar2(16 char)
;
update cls_trade_info set settlement_session='MAIN'
;

/* in theory, we should only encounter final states: Split, Settled, Rejected, Rescinded */

alter table cls_trade_info add(sub_status varchar2(16))
;
alter table cls_trade_info add(is_alleged number(1) DEFAULT 0 NOT NULL)
;

update cls_trade_info set status = 'SMAT', sub_status = '' where status = 'Settlement Mature'
;
update cls_trade_info set status = 'FMTC', sub_status = 'IMAT' where status = 'Matched'
;
update cls_trade_info set status = 'UMTC', sub_status = 'IURT' where status = 'Unmatched'
;
update cls_trade_info set status = 'UMTC', sub_status = 'IURT', is_alleged = 1 where status = 'ALLEGED'
;
update cls_trade_info set status = 'STLD', sub_status = '' where status = 'Settled'
;
update cls_trade_info set status = 'RSCD', sub_status = '' where status = 'Rescinded'
;
update cls_trade_info set status = 'SUSP', sub_status = 'NISP' where status = 'Suspended'
;
update cls_trade_info set status = 'RJCT', sub_status = '' where status = 'Rejected'
;
update cls_trade_info set status = 'SPLI', sub_status = '' where status = 'Split'
;
update cls_trade_info set status = 'INVA', sub_status = '' where status = 'Invalid'
;

commit
;
