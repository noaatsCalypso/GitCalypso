sp_rename  date_rule_to_date_rule , date_rule_to_date_rule_back
go
create table date_rule_to_date_rule(dr_owner numeric not null , dr_owned numeric not null )
go
insert into date_rule_to_date_rule select owner as dr_owner , owned as dr_owned  from date_rule_to_date_rule_back
go
