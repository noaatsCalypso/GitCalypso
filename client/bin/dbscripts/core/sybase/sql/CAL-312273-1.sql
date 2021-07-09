if exists (select 1 from sysobjects where name='lifecycle_trigger_rule' and type='U')
begin
exec ('sp_rename lifecycle_trigger_rule, lifecycle_trigger_rule_tmp')
end
go

create table lifecycle_trigger_rule (rule_id numeric default 0 not null , version numeric default 0 not null , username varchar(128) not null, last_modified datetime not null , enabled int default 0 not null, event varchar(128) not null, product_type varchar(128) not null, payoff varchar(255) not null, trigger_name text )
go

insert into lifecycle_trigger_rule (rule_id, version, username, last_modified, enabled, event, product_type, payoff, trigger_name) (select rule_id, version, username, last_modified, enabled, event, product_type, payoff, trigger_name from lifecycle_trigger_rule_tmp)
go

if exists (select 1 from sysobjects where name='lifecycle_processor_rule' and type='U')
begin
exec ('sp_rename lifecycle_processor_rule, lifecycle_processor_rule_tmp')
end
go

create table lifecycle_processor_rule (rule_id numeric default 0 not null , version numeric default 0 not null , username varchar(128) not null, last_modified datetime not null , enabled int default 0 not null, event varchar(128) not null, product_type varchar(128) not null, payoff varchar(255) not null, processor text)
go

insert into lifecycle_processor_rule (rule_id, version, username, last_modified, enabled, event, product_type, payoff, processor) (select rule_id, version, username, last_modified, enabled, event, product_type, payoff, processor from lifecycle_processor_rule_tmp)
go
