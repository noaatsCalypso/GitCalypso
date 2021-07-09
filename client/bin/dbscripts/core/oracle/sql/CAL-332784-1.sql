alter table  date_rule_to_date_rule rename to date_rule_to_date_rule_back
;
create table date_rule_to_date_rule as select owner as dr_owner , owned as dr_owned  from date_rule_to_date_rule_back
/
