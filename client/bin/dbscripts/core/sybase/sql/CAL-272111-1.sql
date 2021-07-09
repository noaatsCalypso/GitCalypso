select * into aux0 from (
  select position_id,
         max(entered_date) as max_entered_date,
         min(case when is_liquidable = 0 then settle_date else null end) as min_nonliq_settle_date
  from trade_open_qty group by position_id
  union all
  select position_id,
         max(entered_date) as max_entered_date,
         min(case when is_liquidable = 0 then settle_date else null end) as min_nonliq_settle_date
  from trade_openqty_hist group by position_id
) a
go

select * into aux from (
  select position_id,
         max(max_entered_date) as max_entered_date,
         min(min_nonliq_settle_date) as min_nonliq_settle_date
  from aux0 group by position_id
) a
go

create index aux_i on aux(position_id, max_entered_date)
go

add_column_if_not_exists 'pl_position','last_updated_time','datetime null'
go

add_column_if_not_exists 'pl_position','last_batch_liq_time','datetime null'
go

add_column_if_not_exists 'pl_position','next_liquidation_time','datetime null'
go

update pl_position
set last_updated_time = (select max_entered_date from aux where aux.position_id = pl_position.position_id)
where last_updated_time is null
go

update pl_position
set last_batch_liq_time = dateadd(ss, -1, last_updated_time) 
where last_batch_liq_time is null
go

update pl_position
set next_liquidation_time = getutcdate()
where next_liquidation_time is null and exists (select 1 from aux where aux.position_id = pl_position.position_id and min_nonliq_settle_date is not null)
go

drop table aux0
go

drop table aux
go 



update an_param_items set attribute_value='Weight' where attribute_value='Beta' and param_name 
in (select param_name from an_param_items where attribute_value='Beta' AND param_name 
in(SELECT param_name FROM an_param_items where attribute_name='MktType' AND attribute_value='Commodity'))
go

if exists (select 1 from sysobjects where name ='add_scnro_qtd_prd' and type='P')
begin
exec ('drop procedure add_scnro_qtd_prd')
end
go
create proc add_scnro_qtd_prd(@name varchar(64),@params varchar(128),@pmeasure varchar(128))
as
begin
	declare @cnt int
	select @cnt=count(*) from scenario_quoted_product where product_name=@name and pricer_params=@params 
	select @cnt 
	if  (@cnt=0) 
	insert into scenario_quoted_product (product_name,pricer_params,pricer_measure) values (@name,@params,@pmeasure)
	end
go
 

add_scnro_qtd_prd 'Bond', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'BondAssetBacked', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'BondBrady', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'BondFRN', 'BOND_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'BondMMDiscount', 'MMKT_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'BondMMDiscountAUD', 'MMKT_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'BondMMInterest', 'MMKT_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'FutureBond', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'FutureMM', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'FutureCommodity', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'FutureEquityIndex', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'FutureEquity', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'FutureOptionMM', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD'
go
add_scnro_qtd_prd 'FutureOptionBond', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD'
go
add_scnro_qtd_prd 'FutureOptionEquityIndex', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD'
go
add_scnro_qtd_prd 'FutureOptionEquity', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD'
go
add_scnro_qtd_prd 'FutureOptionDividend', 'NPV_FROM_QUOTE' ,'IMPLIEDVOLATILITY'
go
add_scnro_qtd_prd 'FutureDividend', 'FUTURE_FROM_QUOTE' ,'INSTRUMENT_SPREAD'
go
add_scnro_qtd_prd 'Warrant', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD'
go
add_scnro_qtd_prd 'ETOEquity', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD'
go
add_scnro_qtd_prd 'ETOEquityIndex', 'NPV_FROM_QUOTE' ,'VOLATILITY_SPREAD'
go
add_scnro_qtd_prd 'BondOption', 'BOND_FROM_QUOTE' ,'PLXG'
go
add_scnro_qtd_prd 'PerformanceSwap', 'BOND_FROM_QUOTE' ,'PLXG'
go

update product_cap_floor set init_fixing_type ='NONE' where man_first_reset_b=0
go

update liq_info set sort_method='SettleDate' where sort_method='LongSettleDate'
go


add_column_if_not_exists 'reconvention','reference_timezone','varchar(128)null'
go

if exists (select 1 from sysobjects where type='U' and name='reconvention')
begin
exec ('UPDATE reconvention SET reference_timezone = (SELECT location FROM book, trade WHERE trade.book_id = book.book_id AND trade.product_id = reconvention.product_id) 
WHERE reconvention.reference_timezone IS NULL')
end
go


UPDATE calypso_info
    SET major_version=14,
        minor_version=4,
        sub_version=0,
        patch_version='000',
        version_date='20150930'
go
