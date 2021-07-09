create table temp_table_cal_305182 ( old_methodology varchar(64), new_methodology varchar(64)) 
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'ACCRUAL','AmortizedCost')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'AFS','AmortizedValue')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'CASH','Cash')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'CASH_PL','AmortizedCost')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'HEDGING','FairValue')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'HTM','AmortizedCost')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'MTM','FairValue')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'NONE','None')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'TRADING','FairValue')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'TRADING_BY_CCY','FairValue')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'AmortizedCost_1','AmortizedCost')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'AmortizedCost_2','AmortizedCost')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'FairValue_1','FairValue')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'FairValue_2','FairValue')
go
insert into temp_table_cal_305182(old_methodology , new_methodology) values ( 'FairValue_3','FairValue')
go
if not exists (select 1 from sysobjects where name='pl_methodology_config_items' and type='U')
begin
exec('CREATE TABLE pl_methodology_config_items (
         config_name varchar (32) NOT NULL,
         driver varchar (32) NOT NULL,
         book_id numeric  NOT NULL,
         product_type varchar (32) NOT NULL,
         product_sub_type varchar (32) NOT NULL,
         product_extended_type varchar (32)  NOT NULL,
         methodology_name varchar (256) NOT NULL,
         rollup_fees numeric  NULL )')
end
go

update pl_methodology_config_items set methodology_name = temp_table_cal_305182.new_methodology from temp_table_cal_305182 
where pl_methodology_config_items.methodology_name = temp_table_cal_305182.old_methodology
go
if not exists (select 1 from sysobjects where name='official_pl_mark' and type='U')
begin
exec('CREATE TABLE official_pl_mark (
         job_id numeric  DEFAULT 0 NOT NULL,
         mark_id numeric  NOT NULL,
         mark_version_num numeric  NOT NULL,
         trade_id numeric  NOT NULL,
         position_or_trade varchar (128) NOT NULL,
         book_id numeric  NOT NULL,
         valuation_date datetime  NOT NULL,
         last_active_date datetime  NULL,
         pl_type varchar (32)  NOT NULL,
         effective_product_type varchar (32) NOT NULL,
         pl_unit_id numeric  NOT NULL,
         pl_bucket_id numeric  NOT NULL,
         pl_config_id numeric  NOT NULL,
         methodology varchar (32) NOT NULL,
         entered_user varchar (32) NOT NULL,
         entered_datetime datetime  NOT NULL,
         update_datetime datetime  NULL,
         inactive_trade numeric  NOT NULL,
         adj_status varchar (32) NOT NULL,
         unrealized_mtm float  NULL,
         unrealized_accrual float  NULL,
         unrealized_accretion float  NULL,
         unrealized_other float  NULL,
         realized_mtm float  NULL,
         realized_accrual float  NULL,
         realized_accretion float  NULL,
         realized_other float  NULL,
         unrealized_mtm_base float  NULL,
         unrealized_accrual_base float  NULL,
         unrealized_accretion_base float  NULL,
         unrealized_other_base float  NULL,
         realized_mtm_base float  NULL,
         realized_accrual_base float  NULL,
         realized_accretion_base float  NULL,
         realized_other_base float  NULL,
         funding_crystallized float  NULL,
         funding_crystallized_base float  NULL,
         unit_funding_cryst_id numeric  NULL,
         cost_of_funding float  NULL,
         cost_of_funding_base float  NULL,
         ca_notional float  NULL,
         ca_pv float  NULL,
         ca_cost float  NULL,
         cumulative_cash float  NULL,
         settled_proceeds float  NULL,
         unsettled_proceeds float  NULL,
         object_type numeric  DEFAULT 0 NOT NULL,
         strategy_id numeric  NULL,
         unsettled_cash float  NULL,
         asset_value float  NULL,
         funding_balance float  NULL,
         realized_capital_base float  NULL,
         realized_cross_base float  NULL,
         realized_fx_base float  NULL,
         unrealized_capital_base float  NULL,
         unrealized_cross_base float  NULL,
         unrealized_fx_base float  NULL,
         funding_average_fx float  NULL,
         asset_value_base float  NULL,
         cumulative_cash_base float  NULL,
         unsettled_cash_base float  NULL,
         position_average_fx float  NULL,
         settled_cash float  NULL,
         settled_cash_base float  NULL,
         risk_value float  NULL,
         risk_value_base float  NULL,
         transfer_amount float  NULL,
         selloff_currency varchar (3) NULL,
         selloff_unrealized float  NULL,
         selloff_realized float  NULL 
    )')
end
go

update official_pl_mark SET methodology = temp_table_cal_305182.new_methodology from temp_table_cal_305182 
where official_pl_mark.methodology = temp_table_cal_305182.old_methodology 
go
if not exists (select 1 from sysobjects where name='official_pl_mark_hist' and type='U')
begin
exec('CREATE TABLE official_pl_mark_hist (
         job_id numeric  DEFAULT 0 NOT NULL,
         mark_id numeric  NOT NULL,
         mark_version_num numeric  NOT NULL,
         trade_id numeric  NOT NULL,
         position_or_trade varchar (128) NOT NULL,
         book_id numeric  NOT NULL,
         valuation_date datetime  NOT NULL,
         last_active_date datetime  NULL,
         pl_type varchar (32)  NOT NULL,
         effective_product_type varchar (32) NOT NULL,
         pl_unit_id numeric  NOT NULL,
         pl_bucket_id numeric  NOT NULL,
         pl_config_id numeric  NOT NULL,
         methodology varchar (32) NOT NULL,
         entered_user varchar (32) NOT NULL,
         entered_datetime datetime  NOT NULL,
         update_datetime datetime  NULL,
         inactive_trade numeric  NOT NULL,
         adj_status varchar (32) NOT NULL,
         unrealized_mtm float  NULL,
         unrealized_accrual float  NULL,
         unrealized_accretion float  NULL,
         unrealized_other float  NULL,
         realized_mtm float  NULL,
         realized_accrual float  NULL,
         realized_accretion float  NULL,
         realized_other float  NULL,
         unrealized_mtm_base float  NULL,
         unrealized_accrual_base float  NULL,
         unrealized_accretion_base float  NULL,
         unrealized_other_base float  NULL,
         realized_mtm_base float  NULL,
         realized_accrual_base float  NULL,
         realized_accretion_base float  NULL,
         realized_other_base float  NULL,
         funding_crystallized float  NULL,
         funding_crystallized_base float  NULL,
         unit_funding_cryst_id numeric  NULL,
         cost_of_funding float  NULL,
         cost_of_funding_base float  NULL,
         ca_notional float  NULL,
         ca_pv float  NULL,
         ca_cost float  NULL,
         cumulative_cash float  NULL,
         settled_proceeds float  NULL,
         unsettled_proceeds float  NULL,
         object_type numeric  DEFAULT 0 NOT NULL,
         strategy_id numeric  NULL,
         unsettled_cash float  NULL,
         asset_value float  NULL,
         funding_balance float  NULL,
         realized_capital_base float  NULL,
         realized_cross_base float  NULL,
         realized_fx_base float  NULL,
         unrealized_capital_base float  NULL,
         unrealized_cross_base float  NULL,
         unrealized_fx_base float  NULL,
         funding_average_fx float  NULL,
         asset_value_base float  NULL,
         cumulative_cash_base float  NULL,
         unsettled_cash_base float  NULL,
         position_average_fx float  NULL,
         settled_cash float  NULL,
         settled_cash_base float  NULL,
         risk_value float  NULL,
         risk_value_base float  NULL,
         transfer_amount float  NULL,
         selloff_currency varchar (3) NULL,
         selloff_unrealized float  NULL,
         selloff_realized float  NULL 
    )')
end
go
update official_pl_mark_hist SET methodology = temp_table_cal_305182.new_methodology from temp_table_cal_305182 
where official_pl_mark_hist.methodology = temp_table_cal_305182.old_methodology 
go
if not exists (select 1 from sysobjects where name='official_pl_aggregate_item' and type='U')
begin
exec('CREATE TABLE official_pl_aggregate_item (agg_txn_id numeric default 0 not null ,
	agg_id numeric default 0 not null ,
	active_status varchar(1) not null,
	action varchar(1) not null,
	action_datetime datetime not null,
         job_id numeric  DEFAULT 0 NOT NULL,
         mark_id numeric  NOT NULL,
         mark_version_num numeric  NOT NULL,
         trade_id numeric  NOT NULL,
         position_or_trade varchar (128) NOT NULL,
         book_id numeric  NOT NULL,
         valuation_date datetime  NOT NULL,
         last_active_date datetime  NULL,
         pl_type varchar (32)  NOT NULL,
         effective_product_type varchar (32) NOT NULL,
         pl_unit_id numeric  NOT NULL,
         pl_bucket_id numeric  NOT NULL,
         pl_config_id numeric  NOT NULL,
         methodology varchar (32) NOT NULL,
         entered_user varchar (32) NOT NULL,
         entered_datetime datetime  NOT NULL,
         update_datetime datetime  NULL,
         inactive_trade numeric  NOT NULL,
         adj_status varchar (32) NOT NULL,
         unrealized_mtm float  NULL,
         unrealized_accrual float  NULL,
         unrealized_accretion float  NULL,
         unrealized_other float  NULL,
         realized_mtm float  NULL,
         realized_accrual float  NULL,
         realized_accretion float  NULL,
         realized_other float  NULL,
         unrealized_mtm_base float  NULL,
         unrealized_accrual_base float  NULL,
         unrealized_accretion_base float  NULL,
         unrealized_other_base float  NULL,
         realized_mtm_base float  NULL,
         realized_accrual_base float  NULL,
         realized_accretion_base float  NULL,
         realized_other_base float  NULL,
         funding_crystallized float  NULL,
         funding_crystallized_base float  NULL,
         unit_funding_cryst_id numeric  NULL,
         cost_of_funding float  NULL,
         cost_of_funding_base float  NULL,
         ca_notional float  NULL,
         ca_pv float  NULL,
         ca_cost float  NULL,
         cumulative_cash float  NULL,
         settled_proceeds float  NULL,
         unsettled_proceeds float  NULL,
         object_type numeric  DEFAULT 0 NOT NULL,
         strategy_id numeric  NULL,
         unsettled_cash float  NULL,
         asset_value float  NULL,
         funding_balance float  NULL,
         realized_capital_base float  NULL,
         realized_cross_base float  NULL,
         realized_fx_base float  NULL,
         unrealized_capital_base float  NULL,
         unrealized_cross_base float  NULL,
         unrealized_fx_base float  NULL,
         funding_average_fx float  NULL,
         asset_value_base float  NULL,
         cumulative_cash_base float  NULL,
         unsettled_cash_base float  NULL,
         position_average_fx float  NULL,
         settled_cash float  NULL,
         settled_cash_base float  NULL,
         risk_value float  NULL,
         risk_value_base float  NULL,
         transfer_amount float  NULL,
         selloff_currency varchar (3) NULL,
         selloff_unrealized float  NULL,
         selloff_realized float  NULL 
    )')
end
go
update official_pl_aggregate_item SET trg.methodology = temp_table_cal_305182.new_methodology from temp_table_cal_305182 
where   official_pl_aggregate_item.methodology = temp_table_cal_305182.old_methodology
go
       
drop table temp_table_cal_305182
go