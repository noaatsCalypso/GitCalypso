sp_rename 'kpi_conf_cust_trade_ttp_cp_att.counterPartyAttKey' , 'counterpartyattkey'
go
sp_rename 'kpi_conf_cust_trade_ttp_cp_att.counterPartyAttValue' , 'counterpartyattvalue'
go
drop_pk_if_exists 'kpi_conf_cust_trade_ttp_cp_att'
go
sp_rename 'kpi_conf_cust_xfer_ttp_cp_att.counterPartyAttKey' , 'counterpartyattkey'
go
sp_rename 'kpi_conf_cust_xfer_ttp_cp_att.counterPartyAttValue' , 'counterpartyattvalue'
go
drop_pk_if_exists 'kpi_conf_cust_xfer_ttp_cp_att'
go
sp_rename 'kpi_conf_cust_msg_ttp_rc_att.receiverAttKey','receiverattkey'
go
sp_rename 'kpi_conf_cust_msg_ttp_rc_att.receiverAttKey','receiverattkey'
go
drop_pk_if_exists 'kpi_conf_cust_msg_ttp_rc_att'
go
