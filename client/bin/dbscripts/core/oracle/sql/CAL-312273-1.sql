alter table lifecycle_trigger_rule rename to lifecycle_trigger_rule_tmp
;
    
create table
    lifecycle_trigger_rule
    (
        rule_id integer default 0 not null,
        version number(10) default 0 not null,
        username varchar2(128) not null,
        last_modified timestamp(6) not null,
        enabled integer default 0 not null,
        event varchar2(128) not null,
        product_type varchar2(128) not null,
        payoff varchar2(255) not null,
        trigger_name clob,
        constraint pk_lifecycle_trigger2 primary key (rule_id)
    )
;
    
insert into lifecycle_trigger_rule (select * from  lifecycle_trigger_rule_tmp)
;

alter table lifecycle_processor_rule rename to lifecycle_processor_rule_tmp
;
    
create table
    lifecycle_processor_rule
    (
        rule_id integer default 0 not null,
        version number(10) default 0 not null,
        username varchar2(128) not null,
        last_modified timestamp(6) not null,
        enabled integer default 0 not null,
        event varchar2(128) not null,
        product_type varchar2(128) not null,
        payoff varchar2(255) not null,
        processor clob,
        constraint pk_lifecycle_process2 primary key (rule_id)
    )
;
    
insert into lifecycle_processor_rule (select * from  lifecycle_processor_rule_tmp)
;