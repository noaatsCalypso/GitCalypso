alter table cls_schedule add timing varchar2(32 char)
;
alter table cls_schedule add sttlm_session varchar2(16 char)
;
alter table cls_schedule add clsb_reference varchar2(22 char)
;
alter table cls_schedule add xml_message clob 
;

create unique index cls_sched_ref on cls_schedule(clsb_reference)
;

update cls_schedule set timing =
   case when to_char(from_tz(timestamp, (select ref_time_zone from calypso_info))  AT time zone 'CET', 'HH24MI') >= '0630'
   then 'RPIS'
   else 'IPIS'
   end
;
update cls_schedule set sttlm_session='MAIN'
;
update cls_schedule set clsb_reference = (select clsb_reference from cls_message m where m.message_id = 'PISR' and m.timestamp= cls_schedule.timestamp)
where clsb_reference is null
;
update cls_schedule set clsb_reference = 'CLSB_I_'||schedule_id where clsb_reference is null and timing='IPIS'
;
update cls_schedule set clsb_reference = 'CLSB_R_'||schedule_id where clsb_reference is null and timing='RPIS'
;
alter table cls_schedule modify (timing not null)
;
alter table cls_schedule modify (sttlm_session not null)
;
alter table cls_schedule modify (clsb_reference not null)
;
commit
;
