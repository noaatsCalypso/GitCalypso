alter table cls_message rename column  acknowledger to ack_identifier
;
alter table cls_message add settlement_session varchar2(16 char)
;
update cls_message set settlement_session='MAIN'
;

commit
;
