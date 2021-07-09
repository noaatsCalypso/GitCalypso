alter table cls_message rename column ack_identifier to acknowledger;

alter table cls_message drop column settlement_session;

alter table cls_message add (cls_key varchar2(16));
update cls_message set cls_key = clsb_reference;

alter table cls_message add (type varchar2(32));
update cls_message set cls_message.type = cls_message.sub_message_id;

commit;