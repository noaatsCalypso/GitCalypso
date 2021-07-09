update ctxt_pos_bucket_conf set name = '[System] Custodian Securities' where config_id = -1
go
update ctxt_pos_bucket_conf set name = '[System] Custodian Fixed Cash' where config_id = -2
go
update ctxt_pos_bucket_conf set name = '[System] Custodian Index Linked Cash' where config_id = -7
go
update ctxt_pos_bucket_conf set name = '[System] Cash Liquidity Manager Fixed Cash' where config_id = -8
go
update ctxt_pos_bucket_conf set name = '[System] Cash Liquidity Manager Index Linked Cash' where config_id = -9
go
update ctxt_pos_bucket_conf set name = '[System] Cash Liquidity Manager Securities' where config_id = -10
go




update ctxt_pos_bucket_conf set data_bkt_5_key = -3 where config_id = -1
go

update ctxt_pos_bucket_conf set data_bkt_3_key = -3 where config_id = -10
go

update ctxt_pos_bucket_conf set data_bkt_4_key = -6 where config_id = -7
go

update ctxt_pos_bucket_conf set data_bkt_5_key = -5 where config_id = -7
go

