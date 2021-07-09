
CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE  product_structured_flows ( product_id number NOT NULL,
                open_term_b number NOT NULL,
                notice_days  number NOT NULL,
                sales_margin float,
                roll_over_b  number NOT NULL,
                interest_rule varchar2(255) NOT NULL,
                roll_over_amount float,
                capitalize_int_b  number NOT NULL,
                custom_flows_b  number NOT NULL,
                roll_over_date timestamp,
                amortizing_b  number NOT NULL,
                cf_generation_locks  number NOT NULL,
                cf_custom_changes  number NOT NULL,
                with_holding_tax_rate float,
                mandatory_termination_b  number NOT NULL,
                is_pay_b  number NOT NULL)';

	EXECUTE IMMEDIATE 'ALTER TABLE product_structured_flows add constraint pk_product_str_flows  
	primary key (product_id)';
EXECUTE IMMEDIATE 'INSERT INTO product_structured_flows select * from product_cash_flow_leg';
    
    END IF;
END add_table;
;

BEGIN
add_table('product_structured_flows');
END;
;

declare x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME in (UPPER('product_structured_flows') ,UPPER('product_cash_flow_leg'));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 2 THEN
      execute immediate 'drop table product_cash_flow_leg';
	end if;
end;
;


update product_desc
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update bo_audit_fld_map 
set product_type='StructuredFlows'
where product_type='CashFlowLeg'
;

update bo_message
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update bo_message_hist
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update bo_transfer
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update bo_transfer_hist
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update pricing_sheet_cfg
set product_type='StructuredFlows'
where product_type='CashFlowLeg'
;

update main_entry_prop
set property_value='tws.CalypsoWorkstation'
where property_value like 'tws.TraderWorkstation'
;
 
delete from domain_values where name='horizonFundingPolicy' and value='Daily'
;
delete from domain_values where name='domainName' and value='autoFeedInternalRefTerminationType'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','autoFeedInternalRefTerminationType','' )
;
delete from domain_values where name='autoFeedInternalRefTerminationType' and value='Novation'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('autoFeedInternalRefTerminationType','Novation','' )
;
delete from domain_values where name='domainName' and value='autoFeedExternalRefTerminationType'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','autoFeedExternalRefTerminationType','' )
;
delete from domain_values where name='autoFeedExternalRefTerminationType' and value='Novation'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('autoFeedExternalRefTerminationType','Novation','' )
;
delete from domain_values where name='domainName' and value='StructuredFlows.subtype' and description='Types of StructuredFlows'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StructuredFlows.subtype','Types of StructuredFlows' )
;
delete from domain_values where name='productType' and value='StructuredFlows'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','StructuredFlows','' )
;
delete from domain_values where name='productTypeReportStyle' and value='StructuredFlows' and description='StructuredFlows ReportStyle'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','StructuredFlows','StructuredFlows ReportStyle' )
;
delete from domain_values where name='domainName' and value='StructuredFlows.Pricer' and description='Pricers for StructuredFlows'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StructuredFlows.Pricer','Pricers for StructuredFlows' )
;
delete from domain_values where name='StructuredFlows.Pricer' and value='PricerStructuredFlows' 
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StructuredFlows.Pricer','PricerStructuredFlows','' )
;
delete from domain_values where name='measuresForAdjustment' and value='TD_ACCRUAL_BS' 
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','TD_ACCRUAL_BS','' )
;
delete from referring_object where rfg_obj_id=50 and ref_obj_id=1 and rfg_tbl_name='hedge_relationship_config'
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (50,1,'hedge_relationship_config','hedge_relationship_config_id','1','hedged_sd_filter','HedgeRelationshipConfig','apps.refdata.HedgeRelationshipConfigWindow','Hedge Relationship Configuration' )
;
delete from referring_object where rfg_obj_id=51 and ref_obj_id=1 and rfg_tbl_name='hedge_relationship_config' 
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (51,1,'hedge_relationship_config','hedge_relationship_config_id','1','hedge_sd_filter','HedgeRelationshipConfig','apps.refdata.HedgeRelationshipConfigWindow','Hedge Relationship Configuration' )
;
CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 
'create table report_template_bk as select * from report_template';
    END IF;
END add_table;
;
BEGIN
add_table('report_template_bk');
END;
;

delete from report_template WHERE report_type = 'RiskAggregation' and is_hidden = 1 and template_id NOT IN (SELECT report_template_id from tws_risk_aggregation_node)
;
CREATE OR REPLACE PROCEDURE add_column_if_not_exists
    (tab_name IN user_tab_columns.table_name%TYPE,
     col_name IN user_tab_columns.column_name%TYPE,
     data_type_and_defaults IN varchar2)
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER(tab_name) and column_name=upper(col_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'alter table ' || tab_name || ' add '||col_name||' '||data_type_and_defaults;
    END IF;
END;
;
begin
add_column_if_not_exists  ('ref_basket_credit_evnt_map','multiple_holder_b', 'number default 0 not null');
end;
;


