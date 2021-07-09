update acc_rule set version_num = 0 where version_num is NULL
go
update acc_rule set po_id = 0 where po_id is NULL
go
update acc_rule set liq_agg_conf_id = 0 where liq_agg_conf_id is NULL
go