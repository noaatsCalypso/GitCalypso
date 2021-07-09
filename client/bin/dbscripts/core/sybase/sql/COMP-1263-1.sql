alter table ersc_job modify id varchar(36)
go

alter table ersc_rule_check modify id varchar(36)
go

alter table ersc_rule_check_join modify rule_id2 varchar(36)
go
alter table ersc_rule_check_join modify rule_check_id3 varchar(36)
go

alter table ersc_rule_check_result modify id varchar(36)
go
alter table ersc_rule_check_result modify check_id varchar(36)
go

alter table ersc_rule_portfolio modify id varchar(36)
go

alter table ersc_rule_portfolio_join modify rule_id0 varchar(36)
go
alter table ersc_rule_portfolio_join modify rule_portfolio_id1 varchar(36)
go

alter table ersc_rule_result modify id varchar(36)
go
alter table ersc_rule_result modify job_id varchar(36)
go
alter table ersc_rule_result modify rule_id varchar(36)
go

alter table ersc_rule_result_check_join modify rule_result_id0 varchar(36)
go
alter table ersc_rule_result_check_join modify rule_check_result_id1 varchar(36)
go

alter table ersc_sanction_item modify id varchar(36)
go

alter table ersc_rule_sanction_join modify rule_id4 varchar(36)
go
alter table ersc_rule_sanction_join modify  sanction_item_id5 varchar(36)
go

alter table ersc_rule_result_trade modify id varchar(36)
go
alter table ersc_rule_result_trade modify rule_id varchar(36)
go
alter table ersc_rule_result_trade modify rule_result_id varchar(36)
go

alter table ersc_rule_group modify id varchar(36)
go
