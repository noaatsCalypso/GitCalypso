drop index cls_sched_ref;

alter table cls_schedule drop column timing;
alter table cls_schedule drop column sttlm_session;
alter table cls_schedule drop column clsb_reference ;
alter table cls_schedule drop column xml_message ;