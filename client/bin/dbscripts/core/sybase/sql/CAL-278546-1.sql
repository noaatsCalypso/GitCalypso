add_column_if_not_exists 'eto_contract','last_delivery_date','datetime null'
go
add_column_if_not_exists 'eto_contract','last_delivery_rule','numeric null'
go
add_column_if_not_exists 'eto_contract','dateformat','numeric null'
go
add_column_if_not_exists 'eto_contract','first_delivery_rule','numeric null'
go
add_column_if_not_exists 'product_eto','last_delivery_date','datetime null' 
go
add_column_if_not_exists 'product_eto','first_delivery_date','datetime null' 
go
insert into listed_contract (contract_id, contract_name, contract_type, exchange_code, currency_code, future_type, settlement_type, quote_type, tick_size, min_move_in_ticks, tick_value, nb_trade_contract, time_zone, time_minute, trading_rule, trading_end_rule, first_del_rule, last_del_rule, und_product_id, date_format, holidays) 
select contract_id, contract_name, 'FutureContract', exchange_code, currency_code, future_type, settlement_type, quote_type, tick_size, min_move_in_ticks, tick_value, nb_trade_contract, time_zone, time_minute, trading_rule, trading_end_rule, first_del_rule, last_del_rule, und_product_id, dateformat, holidays from future_contract
go
insert into listed_contract (contract_id, contract_name, contract_type, exchange_code, currency_code, future_type, settlement_type, quote_type, tick_size, min_move_in_ticks, tick_value, nb_trade_contract, time_zone, time_minute, trading_rule, trading_end_rule, first_del_rule, last_del_rule, und_product_id, date_format, holidays) 
select contract_id, contract_name, 'FutureOptionContract', exchange_code, currency_code, future_type, settlement_type, quote_type, tick_size, min_move_in_ticks, tick_value, nb_trade_contract, time_zone, time_minute, trading_rule, trading_end_rule, first_del_rule, last_del_rule, underlying_id, dateformat, holidays from option_contract
go
insert into listed_contract (contract_id, contract_name, contract_type, exchange_code, currency_code, future_type, settlement_type, quote_type, tick_size, min_move_in_ticks, tick_value, nb_trade_contract, time_zone, time_minute, trading_rule, trading_end_rule, first_del_rule, last_del_rule, und_product_id, date_format, holidays) 
select etoc.contract_id, etoc.contract_name, 'ETOContract', le.short_name, etoc.currency_code, etoc.under_type, etoc.settlement_type, etoc.quote_type, etoc.tick_size, etoc.min_move_in_ticks, etoc.tick_value, etoc.nb_contract, etoc.time_zone, etoc.time_minute, etoc.expiration_rule, etoc.trading_end_rule, etoc.first_delivery_rule, etoc.last_delivery_rule, etoc.underlying_id, etoc.dateformat, etoc.settle_holidays from eto_contract etoc, legal_entity le where etoc.exchange_id = le.legal_entity_id
go
insert into product_listed(product_id, contract_id, listed_type, under_product_id, trading_start_date, trading_end_date, first_deliv_date, last_delivery_date, expiration_date, entered_date, entered_user) 
select  product_id, contract_id, 'Future', under_product_id, trading_start_date, trading_end_date, first_deliv_date, last_delivery_date, expiration_date, entered_date, entered_user from product_future
go
insert into product_listed (product_id, contract_id, listed_type, under_product_id, trading_start_date, trading_end_date, first_deliv_date, last_delivery_date, expiration_date, entered_date, entered_user) 
select  product_id, contract_id,  'FutureOption', und_product_id, trading_start_date, trading_end_date, first_deliv_date, last_delivery_date, expiration_date, entered_date, entered_user from product_fut_opt
go
add_column_if_not_exists 'product_eto','last_delivery_date','datetime null'
go
 
insert into product_listed (product_id, contract_id, listed_type, under_product_id, trading_start_date, trading_end_date, expiration_date, first_deliv_date, last_delivery_date)
select product_id, contract_id, 'ETO', underlying_id, trading_start_date, trading_end_date, expiration_date, first_delivery_date, last_delivery_date from product_eto
go

update listed_contract set long_name =entity_attributes.attr_value from
		entity_attributes where 
	entity_attributes.entity_id = listed_contract.contract_id 
		and
		(entity_attributes.entity_type='FutureContract' 
			or
		entity_attributes.entity_type='FutureOptionContract'
			or
		entity_attributes.entity_type='ETOContract')
		and
		entity_attributes.attr_name='ContractLongName'
go

update	listed_contract	
set exch_clrg_ticker = entity_attributes.attr_value from 

		entity_attributes
	where
		entity_attributes.entity_id = listed_contract.contract_id 
		and
		(entity_attributes.entity_type='FutureContract' 
			or
		entity_attributes.entity_type='FutureOptionContract'
			or
		entity_attributes.entity_type='ETOContract')
		and
		entity_attributes.attr_name='ClearingExchangeTicker'
go

update  listed_contract	set prem_pmt_conv = entity_attributes.attr_value from entity_attributes 
where  entity_attributes.entity_id = listed_contract.contract_id 
and (entity_attributes.entity_type='FutureContract'  or entity_attributes.entity_type='FutureOptionContract' or entity_attributes.entity_type='ETOContract') 
and entity_attributes.attr_name='PremiumPaymentConvention'
go

update listed_contract	
set exchange_mic=le_attribute.attribute_value
from le_attribute,legal_entity 
	where
		le_attribute.legal_entity_id = legal_entity.legal_entity_id
		and
		legal_entity.short_name = listed_contract.exchange_code
		and
		le_attribute.attribute_type='MIC'
go


update listed_contract set quote_decimals= convert(numeric,attr_value) from entity_attributes 
where entity_attributes.entity_id = listed_contract.contract_id and
(entity_attributes.entity_type='FutureOptionContract' or entity_attributes.entity_type='ETOContract')
and entity_attributes.attr_name='Quote Decimals'
go


update listed_contract set listed_contract.quote_decimals = future_contract.quote_decimals from future_contract where future_contract.contract_id = listed_contract.contract_id
go

alter table	future_contract drop quote_decimals
go

delete from 
	entity_attributes 
where 
	(entity_type='FutureContract' 
		or entity_type='FutureOptionContract' 
		or entity_type='ETOContract') 
	and 
	(attr_name='ClearingExchangeTicker' or 
		attr_name='ContractLongName' or 
		attr_name='PremiumPaymentConvention')
go