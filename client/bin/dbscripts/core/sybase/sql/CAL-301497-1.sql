sp_rename 'order_template','order_template_back151'
go

update entity_state set entity_type = 'AMOrder' where entity_type = 'DecSuppOrder'
go

update entity_state set entity_type = 'AMBlockOrder' where entity_type = 'BlockOrderImpl'
go