alter table cls_trade_info rename column sender_receiver_info to THIRD_PARTY_TEXT;


alter table cls_trade_info add (notif_seq_no_2 number);
update cls_trade_info set notif_seq_no_2 =  to_number(substr(notif_seq_no_2,2), 'XXXXXXXXXXXXXXXXXXXX');
alter table cls_trade_info drop column notif_seq_no;
alter table cls_trade_info rename column notif_seq_no_2 to notif_seq_no;


/* in theory, we should only encounter final states: Split, Settled, Rejected, Rescinded */

update CLS_TRADE_INFO set status = 'Matched' where status = 'FMTC';

update CLS_TRADE_INFO set status = 'Unmatched' where status = 'UMTC' and is_alleged = 0;

update CLS_TRADE_INFO set status = 'ALLEGED' where status = 'UMTC' and is_alleged = 1;

update CLS_TRADE_INFO set status = 'Settlement Mature' where status = 'SMAT';

update CLS_TRADE_INFO set status = 'Settled' where status = 'STLD';

update CLS_TRADE_INFO set status = 'Rescinded' where status = 'RSCD';

update CLS_TRADE_INFO set status = 'Suspended' where status = 'SUSP';

update CLS_TRADE_INFO set status = 'Rejected' where status = 'RJCT';

update CLS_TRADE_INFO set status = 'Split' where status = 'SPLI';

update CLS_TRADE_INFO set status = 'Invalid' where status = 'INVA';


ALTER table CLS_TRADE_INFO drop column settlement_session;
ALTER table CLS_TRADE_INFO drop column sub_status;

commit;