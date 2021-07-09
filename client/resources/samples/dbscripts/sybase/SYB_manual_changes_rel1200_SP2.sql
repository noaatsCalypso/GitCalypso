if exists (select 1 from sysobjects where name ='add_column_if_not_exists' and type='P')
begin
exec ('drop procedure add_column_if_not_exists')
end
go

create proc add_column_if_not_exists (@table_name varchar(255), @column_name varchar(255) , @datatype varchar(255))
as
begin
declare @cnt int
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
if @cnt=0
exec ('alter table ' + @table_name + ' add '+ @column_name +' ' + @datatype)
end
go

if not exists (select 1 from sysobjects where name = 'product_structured_flows' and type = 'U')
begin 
exec ('create table  product_structured_flows ( product_id numeric NOT NULL,
	open_term_b numeric NOT NULL,
	notice_days  numeric NOT NULL,
	sales_margin float,
	roll_over_b  numeric  NOT NULL,
	interest_rule varchar(255) NOT NULL,
	roll_over_amount float,
	capitalize_int_b  numeric  NOT NULL,
	custom_flows_b  numeric  NOT NULL,
	roll_over_date datetime,
	amortizing_b  numeric  NOT NULL,
	cf_generation_locks  numeric NOT NULL,
	cf_custom_changes  numeric NOT NULL,
	with_holding_tax_rate float,
	mandatory_termination_b  numeric NOT NULL,
	is_pay_b  numeric NOT NULL, CONSTRAINT
    pk_product_str_flows  PRIMARY KEY CLUSTERED (product_id))')
exec ('insert into product_structured_flows select * from product_cash_flow_leg')
end
go

if exists (select 1 from sysobjects where name ='product_cash_flow_leg' and name='product_cash_flow_leg')
begin
exec ('drop table product_cash_flow_leg')
end
go

update product_desc
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
go

update bo_audit_fld_map 
set product_type='StructuredFlows'
where product_type='CashFlowLeg'
go

update bo_message
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
go

update bo_message_hist
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
go

update bo_transfer
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
go

update bo_transfer_hist
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
go

update pricing_sheet_cfg
set product_type='StructuredFlows'
where product_type='CashFlowLeg'
go

update main_entry_prop
set property_value='tws.CalypsoWorkstation'
where property_value like 'tws.TraderWorkstation'
go

delete from domain_values where name='horizonFundingPolicy' and value='Daily'
go
delete from domain_values where name='domainName' and value='autoFeedInternalRefTerminationType'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','autoFeedInternalRefTerminationType','' )
go
delete from domain_values where name='autoFeedInternalRefTerminationType' and value='Novation'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('autoFeedInternalRefTerminationType','Novation','' )
go
delete from domain_values where name='domainName' and value='autoFeedExternalRefTerminationType'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','autoFeedExternalRefTerminationType','' )
go
delete from domain_values where name='autoFeedExternalRefTerminationType' and value='Novation'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('autoFeedExternalRefTerminationType','Novation','' )
go
delete from domain_values where name='domainName' and value='StructuredFlows.subtype'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StructuredFlows.subtype','Types of StructuredFlows' )
go
delete from domain_values where name='productType' and value='StructuredFlows'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','StructuredFlows','' )
go
delete from domain_values where name='productTypeReportStyle' and value='StructuredFlows'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','StructuredFlows','StructuredFlows ReportStyle' )
go
delete from domain_values where name='domainName' and value='StructuredFlows.Pricer'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StructuredFlows.Pricer','Pricers for StructuredFlows' )
go
delete from domain_values where name='StructuredFlows.Pricer' and value='PricerStructuredFlows'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('StructuredFlows.Pricer','PricerStructuredFlows','' )
go
delete from domain_values where name='measuresForAdjustment' and value='TD_ACCRUAL_BS'
go
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','TD_ACCRUAL_BS','' )
go
delete from referring_object where rfg_obj_id=50 and ref_obj_id=1 and rfg_tbl_name='hedge_relationship_config'
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (50,1,'hedge_relationship_config','hedge_relationship_config_id','1','hedged_sd_filter','HedgeRelationshipConfig','apps.refdata.HedgeRelationshipConfigWindow','Hedge Relationship Configuration' )
go
delete from referring_object where rfg_obj_id=51 and ref_obj_id=1 and rfg_tbl_name='hedge_relationship_config'
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (51,1,'hedge_relationship_config','hedge_relationship_config_id','1','hedge_sd_filter','HedgeRelationshipConfig','apps.refdata.HedgeRelationshipConfigWindow','Hedge Relationship Configuration' )
go
if not exists (select 1 from sysobjects where name ='report_template_bk')
begin
exec ('select * into report_template_bk from report_template')
end
go
delete from report_template WHERE report_type = 'RiskAggregation' and is_hidden = 1 and template_id NOT IN (SELECT report_template_id from tws_risk_aggregation_node)
go
add_column_if_not_exists 'ref_basket_credit_evnt_map','multiple_holder_b','numeric default 0 not null'
go
