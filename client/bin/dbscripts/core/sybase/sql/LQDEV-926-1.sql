update ctxt_pos_bucket_conf set ctxt_pos_type = 'INDEX_LINKED_CASH' where ctxt_pos_type ='RESETTABLE_CASH'
go

create procedure prod_contx_pos
as
begin
declare @cnt int ,
@sql varchar(500)
select @cnt=count(*) from sysobjects where sysobjects.name = 'product_context_position'
if @cnt=1
select @sql = 'update product_context_position set ctxt_pos_type='||char(39)||'INDEX_LINKED_CASH'||char(39)||' where ctxt_pos_type ='||char(39)||'RESETTABLE_CASH'||char(39)
exec (@sql)
end
go

exec prod_contx_pos
go

update context_position_movements set ctxt_pos_type = 'INDEX_LINKED_CASH' where ctxt_pos_type = 'RESETTABLE_CASH'
go
sp_rename 'ctxt_pos_filter.rst_cash_ctxt_pos_config_id', idx_cash_ctxt_pos_config_id
go

select * into ftp_tcc_attr_bk from (select * from ftp_trade_cost_component_attr) a
go
select * into ftp_tcc_bk from (select * from ftp_trade_cost_component) a
go
select * into ftp_tcc_attr_hist_bk from (select * from ftp_trade_cost_comp_attr_hist) a
go
select * into ftp_tcc_hist_bk from (select * from ftp_trade_cost_component_hist) a
go

delete from domain_values where name = 'flowType' and value='FTP_BASIS_RISK_BREAKAGE_COST'
go
delete from domain_values where name = 'flowType' and value='FTP_SWAP_RISK_BREAKAGE_COST'
go
delete from domain_values where name = 'flowType' and value='FTP_LIQUIDITY_PREMIUM_BREAKAGE_COST'
go
delete from domain_values where name = 'FtpCostComponentNames' and value='BASIS_RISK_BREAKAGE_COST'
go
delete from domain_values where name = 'FtpCostComponentNames' and value='SWAP_RISK_BREAKAGE_COST'
go
delete from domain_values where name = 'FtpCostComponentNames' and value='LIQUIDITY_PREMIUM_BREAKAGE_COST'
go

if exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'ftp_trade_cost_component' and syscolumns.name = 'pmt_schedule_id')
begin
declare @sql1 varchar(1000),@sql2 varchar(1000), @sql3 varchar(1000) , @sql4 varchar(1000),@sql5 varchar(1000) , @sql6 varchar(1000)
select @sql1= 'delete from ftp_trade_cost_component_attr where trade_id IN (select DISTINCT trade_id from ftp_trade_cost_component where pmt_schedule_id IS NOT NULL) and attribute_name in ('||char(39)||'ReferenceRate'||char(39)||','||char(39)||'ReferenceTradeId'||char(39)||','||char(39)||'RateRetrievalConfigId'||char(39)||','||char(39)||'PaymentScheduleId'||char(39)||')'
select @sql2= 'UPDATE ftp_trade_cost_component_attr SET user_name = '||char(39)||'system'||char(39)||', cost_comp_ccy = ftp_trade_cost_component.cost_comp_ccy, trade_version = trade.version_num, version = ftp_trade_cost_component.version FROM ftp_trade_cost_component , trade where ftp_trade_cost_component.trade_id = ftp_trade_cost_component_attr.trade_id and ftp_trade_cost_component_attr.cost_comp_name = ftp_trade_cost_component.cost_comp_name and ftp_trade_cost_component.trade_id = trade.trade_id'
select @sql3= 'INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, '||char(39)||'ReferenceRate'||char(39)||', cast(cast(ref_rate as decimal(15,8)) as varchar), trade.version_num, version, '||char(39)||'system'||char(39)||' FROM ftp_trade_cost_component, trade WHERE ftp_trade_cost_component.trade_id = trade.trade_id and ftp_trade_cost_component.pmt_schedule_id IS NOT NULL'
select @sql4= 'INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, '||char(39)||'ReferenceTradeId'||char(39)||', CONVERT(VARCHAR(128),ref_trade_id), trade.version_num, version, '||char(39)||'system'||char(39)||' FROM ftp_trade_cost_component, trade WHERE ftp_trade_cost_component.trade_id = trade.trade_id and ftp_trade_cost_component.pmt_schedule_id IS NOT NULL'
select @sql5= 'INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, '||char(39)||'RateRetrievalConfigId'||char(39)||', CONVERT(VARCHAR(128),rate_retrieval_config_id), trade.version_num, version, '||char(39)||'system'||char(39)||' FROM ftp_trade_cost_component, trade WHERE ftp_trade_cost_component.trade_id = trade.trade_id and ftp_trade_cost_component.pmt_schedule_id IS NOT NULL'
select @sql6= 'INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, '||char(39)||'PaymentScheduleId'||char(39)||', CONVERT(VARCHAR(128),pmt_schedule_id), trade.version_num, version, '||char(39)||'system'||char(39)||' FROM ftp_trade_cost_component, trade WHERE ftp_trade_cost_component.trade_id = trade.trade_id and ftp_trade_cost_component.pmt_schedule_id IS NOT NULL'
exec (@sql1)
exec (@sql2)
exec (@sql3)
exec (@sql4)
exec (@sql5)
exec (@sql6)
end
go

drop procedure prod_contx_pos
go
