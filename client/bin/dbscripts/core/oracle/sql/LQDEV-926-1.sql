update ctxt_pos_bucket_conf set ctxt_pos_type = 'INDEX_LINKED_CASH' where ctxt_pos_type ='RESETTABLE_CASH'
;

CREATE OR REPLACE PROCEDURE update_if_prod_cont_pos_exists
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER('product_context_position');
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 1 THEN
    	EXECUTE IMMEDIATE 'update product_context_position set ctxt_pos_type = ''INDEX_LINKED_CASH'' where ctxt_pos_type = ''RESETTABLE_CASH''';
       	COMMIT;
    END IF;
END update_if_prod_cont_pos_exists;
/

begin
update_if_prod_cont_pos_exists;
end;
/ 

update context_position_movements set ctxt_pos_type = 'INDEX_LINKED_CASH' where ctxt_pos_type = 'RESETTABLE_CASH'
;
alter table ctxt_pos_filter rename column rst_cash_ctxt_pos_config_id to idx_cash_ctxt_pos_config_id
;

create table ftp_tcc_attr_bk as select * from ftp_trade_cost_component_attr
;
create table ftp_tcc_bk as select * from ftp_trade_cost_component
;
create table ftp_tcc_attr_hist_bk as select * from ftp_trade_cost_comp_attr_hist
;
create table ftp_tcc_hist_bk as select * from ftp_trade_cost_component_hist
;

delete from domain_values where name = 'flowType' and value='FTP_BASIS_RISK_BREAKAGE_COST'
;
delete from domain_values where name = 'flowType' and value='FTP_SWAP_RISK_BREAKAGE_COST'
;
delete from domain_values where name = 'flowType' and value='FTP_LIQUIDITY_PREMIUM_BREAKAGE_COST'
;
delete from domain_values where name = 'FtpCostComponentNames' and value='BASIS_RISK_BREAKAGE_COST'
;
delete from domain_values where name = 'FtpCostComponentNames' and value='SWAP_RISK_BREAKAGE_COST'
;
delete from domain_values where name = 'FtpCostComponentNames' and value='LIQUIDITY_PREMIUM_BREAKAGE_COST'
;

begin
DECLARE colnum number;
  BEGIN
    select count(*) INTO colnum FROM user_tab_columns WHERE table_name=UPPER('ftp_trade_cost_component') and column_name=upper('pmt_schedule_id');
    if(colnum > 0) then
        execute immediate ('delete from ftp_trade_cost_component_attr where trade_id IN (select DISTINCT trade_id from ftp_trade_cost_component where pmt_schedule_id IS NOT NULL)
        and attribute_name in ('||chr(39)||'ReferenceRate'||chr(39)||','||chr(39)||'ReferenceTradeId'||chr(39)||','||chr(39)||'RateRetrievalConfigId'||chr(39)||','||chr(39)||'PaymentScheduleId'||chr(39)||')');
        commit;
        
        execute immediate ('UPDATE ftp_trade_cost_component_attr SET (cost_comp_ccy, trade_version, version, user_name) = (SELECT cost_comp_ccy, version_num, version, '||chr(39)||'system'||chr(39)||' FROM trade, ftp_trade_cost_component WHERE trade.trade_id = ftp_trade_cost_component.trade_id AND ftp_trade_cost_component.trade_id = ftp_trade_cost_component_attr.trade_id AND ftp_trade_cost_component.cost_comp_name = ftp_trade_cost_component_attr.cost_comp_name)
            WHERE EXISTS (SELECT cost_comp_ccy, version_num, version, '||chr(39)||'system'||chr(39)||' FROM trade, ftp_trade_cost_component WHERE trade.trade_id = ftp_trade_cost_component.trade_id AND ftp_trade_cost_component.trade_id = ftp_trade_cost_component_attr.trade_id AND ftp_trade_cost_component.cost_comp_name = ftp_trade_cost_component_attr.cost_comp_name)');
        commit;

        execute immediate ('INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, 
			'||chr(39)||'ReferenceRate'||chr(39)||', TO_CHAR(ref_rate), version_num, version, '||chr(39)||'system'||chr(39)||' FROM trade, ftp_trade_cost_component WHERE trade.trade_id = ftp_trade_cost_component.trade_id AND ftp_trade_cost_component.pmt_schedule_id IS NOT NULL');
        commit;

        execute immediate ('INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, 
			'||chr(39)||'ReferenceTradeId'||chr(39)||', TO_CHAR(ref_trade_id), version_num, version, '||chr(39)||'system'||chr(39)||' FROM trade, ftp_trade_cost_component WHERE trade.trade_id = ftp_trade_cost_component.trade_id AND ftp_trade_cost_component.pmt_schedule_id IS NOT NULL');
        commit;
        
        execute immediate ('INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, 
			'||chr(39)||'RateRetrievalConfigId'||chr(39)||', TO_CHAR(rate_retrieval_config_id), version_num, version, '||chr(39)||'system'||chr(39)||' FROM trade, ftp_trade_cost_component WHERE trade.trade_id = ftp_trade_cost_component.trade_id AND ftp_trade_cost_component.pmt_schedule_id IS NOT NULL');
        commit;

        execute immediate ('INSERT INTO ftp_trade_cost_component_attr (trade_id, cost_comp_name, cost_comp_ccy, attribute_name, attribute_value, trade_version, version, user_name) SELECT ftp_trade_cost_component.trade_id, cost_comp_name, cost_comp_ccy, 
			'||chr(39)||'PaymentScheduleId'||chr(39)||', TO_CHAR(pmt_schedule_id), version_num, version, '||chr(39)||'system'||chr(39)||' FROM trade, ftp_trade_cost_component WHERE trade.trade_id = ftp_trade_cost_component.trade_id AND ftp_trade_cost_component.pmt_schedule_id IS NOT NULL');
        commit;

        execute immediate ('delete from ftp_trade_cost_component_attr where trade_id IN (select DISTINCT trade_id from ftp_trade_cost_component where pmt_schedule_id IS NOT NULL) and attribute_name like '||chr(39)||'RECONVENTION%'||chr(39)||'');
        commit;
       
    end if;
  END;
end;
/

drop procedure update_if_prod_cont_pos_exists
;
