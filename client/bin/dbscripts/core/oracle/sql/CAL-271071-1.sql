INSERT INTO pricing_param_name
(param_name, param_type, param_domain, param_comment, is_global_b, default_value) VALUES ('NPV_INCLUDE_SETTLED_CASH', 'java.lang.Boolean', 'true,false', 'Include settled cash in NPV for cash and currency pair positions', 1, 'true')
;

/* Adding column cust_fx_rnd_dig to table commodity_leg2 and 
populating the column using 3 different tables vcode , vcode2 and vcode3 */
 

CREATE OR REPLACE PROCEDURE add_fixdatepolicy_if_not_exist
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
        EXECUTE IMMEDIATE 'CREATE TABLE fixing_date_policy  (fixing_date_policy_id NUMBER,  short_name VARCHAR2(255),fixing_policy_type VARCHAR2(255), int_param_1 NUMBER null, int_param_2 NUMBER null)';
        EXECUTE IMMEDIATE 'ALTER TABLE fixing_date_policy  add CONSTRAINT ct_primarykey PRIMARY KEY (fixing_date_policy_id)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_fixing ON fixing_date_policy (short_name)';
    END IF;
END add_fixdatepolicy_if_not_exist;
;

BEGIN
add_fixdatepolicy_if_not_exist('fixing_date_policy');
END;
;

drop PROCEDURE add_fixdatepolicy_if_not_exist
;

 
BEGIN
  add_column_if_not_exists('commodity_leg2','cust_fx_rnd_dig','int');
END;
;

create table vcode as (
SELECT ps.receive_leg_id as receive_leg_id, to_number( psc.code_value ) as code_value
FROM product_sec_code psc, product_desc pd, product_commodity_swap2 ps 
WHERE psc.product_id=pd.product_id 
     AND ps.product_id=psc.product_id 
     AND pd.product_type='CommoditySwap2'
     AND psc.sec_code='Rec.CustomFXRoundingPrecision')
;

create table vcode2 as (
SELECT  ps.pay_leg_id as pay_leg_id, to_number (psc.code_value ) as code_value
FROM product_sec_code psc, product_desc pd, product_commodity_swap2 ps 
WHERE psc.product_id=pd.product_id 
     AND ps.product_id=psc.product_id 
     AND pd.product_type='CommoditySwap2'
     AND psc.sec_code='Pay.CustomFXRoundingPrecision')
;

create table vcode3 as(
SELECT  po.leg_id as leg_id , to_number (psc.code_value) as code_value
FROM product_sec_code psc, product_desc pd, product_commodity_otcoption2 po 
WHERE psc.product_id=pd.product_id
   AND po.product_id=psc.product_id
   AND pd.product_type='CommodityOTCOption2'
   AND psc.sec_code='CustomFXRoundingPrecision')
;

update commodity_leg2 
set cust_fx_rnd_dig =
       (select code_value from vcode where commodity_leg2.leg_id=vcode.receive_leg_id ) 
where exists 
       (select 'x' from vcode where commodity_leg2.leg_id=vcode.receive_leg_id)
;

update commodity_leg2 
set cust_fx_rnd_dig  = 
       (select code_value from vcode2 where commodity_leg2.leg_id=vcode2.pay_leg_id)
where exists 
       (select 'x' from vcode2 where commodity_leg2.leg_id=vcode2.pay_leg_id)
;

update commodity_leg2 
set cust_fx_rnd_dig  = 
       (select code_value from vcode3 where commodity_leg2.leg_id=vcode3.leg_id)
where exists 
       (select 'x' from vcode3 where commodity_leg2.leg_id=vcode3.leg_id)
;

delete  from product_sec_code where sec_code in ('Rec.CustomFXRoundingPrecision','Pay.CustomFXRoundingPrecision','CustomFXRoundingPrecision')
;
drop table vcode
;
drop table vcode2
;
drop table vcode3
;

/* *******end************* */

update barrier_parameters
   set rebate_timing = timing_type
 where product_id = (select product_id 
                       from product_fx_option p 
                      where p.product_id = barrier_parameters.product_id 
                        and p.option_style = 'BARRIER')
;

INSERT INTO domain_values (name, value, description) VALUES ('REPORT.Types', 'PLMark', 'PLMark Report')
;

delete from pricing_param_name where param_name='PRICE_INACTIVE_TRADE_FROM_DB' and param_type='java.lang.Boolean' and param_domain= 'true,false' and param_comment = 'Force PricerFromDB to price inactive as well as active trades from  DB' and is_global_b=1 and default_value='false'
;

INSERT INTO pricing_param_name (param_name, param_type, param_domain,  param_comment, is_global_b, default_value) VALUES 
('PRICE_INACTIVE_TRADE_FROM_DB', 'java.lang.Boolean', 'true,false', 'Force PricerFromDB to price inactive as well as active trades from  DB', 1, 'false')
;

delete from domain_values
where (name='function' and value in ('ModifyGroupTradeFilter','ModifyUserTradeFilter'))
or (name='restriction' and value in ('ModifyGroupTradeFilter','ModifyUserTradeFilter'))
;
insert into domain_values (name,value,description)
values ('function',   'ModifyGroupTradeFilter',
'Restriction to allow user to modify only the filter belong to users of that user groups')
; 
insert into domain_values (name,value,description) values ('restriction','ModifyGroupTradeFilter','')
;
insert into domain_values (name,value,description)
values ('function',   'ModifyUserTradeFilter',
'Restriction to allow user to modify only filters created by him/herself') 
; 
insert into domain_values (name,value,description) values ('restriction','ModifyUserTradeFilter', '') 
;

update bo_audit set entity_class_name = 'PLMark' where entity_class_name = 'com.calypso.tk.marketdata.PLMark'
;

/* bz55866 */




CREATE TABLE tmp as
select t.trade_id, t.product_id, 
       p.expiry_date, p.option_style,
       tf.fee_id, tf.fee_type, tf.fee_date, tf.amount, tf.currency_code
  from trade t, product_fx_option p, trade_fee tf
 where t.product_id = p.product_id
   and t.trade_id = tf.trade_id
   and p.option_style = 'BARRIER'
   and p.expiry_date >= CURRENT_DATE
   and tf.fee_type = 'PREMIUM'
 order by t.trade_id
;


CREATE OR REPLACE PROCEDURE update_rebate_tmp
AS
BEGIN
declare
  cursor c1 is select product_id, amount from tmp;

begin
  for c1_rec in c1 LOOP
      update barrier_parameters
         set rebate = abs(c1_rec.amount)
       where product_id = c1_rec.product_id
         and rebate = 100;
  END LOOP;
end;
END update_rebate_tmp;
;

begin
  update_rebate_tmp;
end;
;

DROP PROCEDURE update_rebate_tmp
;

DROP TABLE tmp
;


/* BZ 55904 */
CREATE OR REPLACE PROCEDURE sp_chngpriority (leRole IN varchar2) AS
BEGIN
   DECLARE cursor sdid_crsr IS
      select  bene_le, sdi_id  FROM le_settle_delivery where method='COMMODITY' and le_role=leRole and priority=0;
   v_sql varchar2(512);
   BEGIN
      FOR sdid_crsr_rec IN sdid_crsr LOOP 
         v_sql := 'update le_settle_delivery set priority=1+(select max(priority) from le_settle_delivery where le_role='''||leRole||''' and bene_le=' ||sdid_crsr_rec.bene_le|| ') where sdi_id=' ||sdid_crsr_rec.sdi_id;
         EXECUTE IMMEDIATE v_sql;
      End LOOP;
   END;
END;
;

begin
 sp_chngpriority('CounterParty');
end;
;

begin
 sp_chngpriority('ProcessingOrg');
end;
;
drop procedure sp_chngpriority
;

/*end*/

/*BZ 40068*/
delete from domain_values where name = 'function' and value = 'ModifyIssuerTemplateLink'
;
delete from group_access where access_value='ModifyIssuerTemplateLink'
;
/*end BZ 40068*/

UPDATE prod_comm_fwd
  SET cert_offset = payment_offset,
	  cert_offset_bus_b = payment_offset_bus_b,
 	  cert_dateroll = payment_dateroll,
 	  cert_holidays = payment_holidays,
 	  cert_day = payment_day
;
UPDATE bo_ts_book SET book_bundle = 'BookBundle.' || book_bundle WHERE book_bundle NOT LIKE 'NONE' AND book_bundle NOT LIKE '%.%'
;
UPDATE task_book_config SET book_bundle = 'BookBundle.' || book_bundle WHERE book_bundle NOT LIKE 'NONE' AND book_bundle NOT LIKE '__ANY__' AND book_bundle NOT LIKE '%.%'
;     

/* Update FX Keywords */
UPDATE trade_keyword
  SET keyword_value=REPLACE (keyword_value,',',';')
  WHERE keyword_value LIKE '%,%'
  AND keyword_name IN ('XCcySplitRates', 'XccySptMismatchRates')
;

/*46187*/



BEGIN
  add_nullcolumn_if_not_exists('bo_message','legal_entity_id','int');
END;
;

begin
  add_nullcolumn_if_not_exists('bo_message_hist','legal_entity_id','int');
end;
;

UPDATE bo_message SET legal_entity_id = (SELECT orig_cpty_id FROM bo_transfer 
WHERE bo_message.transfer_id = bo_transfer.transfer_id) WHERE legal_entity_id 
= 0 AND bo_message.transfer_id != 0
;
UPDATE bo_message SET legal_entity_id = (SELECT cpty_id FROM trade WHERE 
bo_message.trade_id = trade.trade_id) WHERE legal_entity_id = 0 AND 
bo_message.trade_id != 0
;
/*end*/


/* BZ 54870 */
DELETE FROM domain_values WHERE name = 'productType' AND value = 'PLPositionProduct'
;

/* BZ 54870 end */


/* BZ 49920 */

INSERT INTO pricing_param_name(param_name, param_type, param_domain, param_comment, is_global_b, default_value) VALUES ('RECOVERY_MODEL','java.lang.String','Fixed,Random,As_Corr_Surface','Recovery rate model for CDO Gaussian copula', 1, 'As_Corr_Surface')
;
/* BZ 49920 end */

/* BZ 53196 */

INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','CDSNthLoss','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','CDSNthDefault','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','CreditDefaultSwaption','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','CMCDS','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','CancellableCDS','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','CancellableCDSNthLoss','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','CancellableCDSNthDefault','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','ExtendibleCDS','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','ExtendibleCDSNthLoss','')
;
INSERT INTO domain_values(name, value, description) VALUES ('AllocationSupported','ExtendibleCDSNthDefault','')
;

/* BZ 53196 end */

INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'product_fx_opt_fwd', 'product_fx_opt_fwd_hist', 0 )
;
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'product_fx_takeup', 'product_fx_takeup_hist', 0 )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'MARKET_PARAMETER_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'VOLATILITY_EFFECT_FX', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'D0_S1_FP1_FS1_V1_T1', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'D0_S0_FP0F_FS0F_VA0_T1', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'D0_S0_FP1_FS1_VA1_T1', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'D0_S1_FP0F_FS1_V1_T1', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'D0_S1_FP1_FS0F_V1_T1', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'D0_S1_FP1_FS1_VA0_T1', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'DEAL_AMEND_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'D1_S1_FP1_FS1_V1_T1', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'TIME_EFFECT_FX', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'FX_EFFECT_D0', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'IR_EFFECT_D0', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CREDIT_EFFECT_D0', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CORR_EFFECT_D0', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'RATE_EFFECT_D0', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreatePublicProductTemplates', 'Allow User to add public templates' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreatePrivateProductTemplates', 'Allow User to add private templates' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'NearbyThirdWednesday', 'Price is taken from the third wednesday from the fixing date.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'genericCusip', 'Generic Cusip for GCF Repo Trades' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Desk', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'cdsAdditionalProvisions', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'U.S. Municipal Entity as Reference Entity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'STMicroelectronics NV', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'LPN Reference Entities', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'Ref Entities with Delivery Restrictions', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'Secured Deliverable Obligation Characteristic', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'Argentine Republic', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'Republic of Hungary', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsAdditionalProvisions', 'Russian Federation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'CreditRating', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AuthorizeCreditRating', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'measuresForAdjustment', 'List of favorite measures used for PLMark adjustment' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'measuresForAdjustment', 'ACCRUAL_BO', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'measuresForAdjustment', 'NPV', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'measuresForAdjustment', 'FEES_NPV', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'measuresForAdjustment', 'ACCRUAL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'measuresForAdjustment', 'CUMULATIVE_CASH', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'measuresForAdjustment', 'PV', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'markAdjustmentReasonOTC', 'Mark Adjustment reasons for OTC products' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Model', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Market data', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Trade economics', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Val feed failed', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Quantity amendment', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'No NPV feed set up', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Fee', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Coupon', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Div', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Close out', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Funding', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Premium', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonOTC', 'Other', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'markAdjustmentReasonPosition', 'Mark Adjustment reasons for position based products' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Market data', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Trade economics', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Val feed failed', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Quantity amendment', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Fee', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Funding', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Coupon', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Divs', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Close out', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CorrelationSwap.Pricer', 'Pricer correlationSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CurveCDSBasisAdjustment.gen', 'CDS Basis Adjustment curve generators' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CorrelationSwap.subtype', 'CorrelationSwap subtypes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PositionBasedProducts', 'UnitizedFund', 'Unitized Fund product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.terminationReason', 'NotionalIncrease', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'FinalMatDate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditMktDataUsage', 'CDS_BASIS_ADJ', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'creditMktDataUsage.CDS_BASIS_ADJ', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'creditMktDataUsage.CDS_BASIS_ADJ', 'CurveCDSBasisAdjustment', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'delayedSettleFeeType', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'loanType', 'Term Loan C', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'loanType', 'Term Loan D', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'PLMARK_TRANSFER', 'PL Marks transfer.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'PL_LOCKDOWN', 'PL Marks lock down.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'EquityStructuredOption', 'EquityStructuredOption' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EquityStructuredOption.extendedType', 'EquityStructuredOption.extendedType domain name' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.extendedType', 'Basket', 'when option underlying is a basket' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EquityStructuredOption.subtype', 'EquityStructuredOption.subtype domain name' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'European', 'VANILLA European option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'American', 'VANILLA American option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'Bermudan', 'VANILLA Bermudan option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'ASIAN', 'ASIAN option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'LOOKBACK', 'LOOKBACK option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'BARRIER', 'BARRIER option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'DIGITAL', 'DIGITAL option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'BEST_OF', 'BEST_OF performance payoff basket option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'WORST_OF', 'WORST_OF performance payoff basket option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'RAINBOW', 'RAINBOW performance payoff basket option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'CorrelationSwap', 'CorrelationSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'keyword.Desk', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FeeBillingRuleAttributes', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FeeBillingRuleAttributes', 'DefaultBook', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveCDSBasisAdjustment.gen', 'CDSBasisAdjustment', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CreditDefaultSwap.Pricer', 'PricerCreditDefaultSwapQuote', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PLPositionProduct.Pricer', 'PricerPLPositionProduct', 'PLPositionProduct Pricer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'PLPositionProduct.Pricer', 'Pricers for PLPositionProduct' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventClass', 'PSEventCreditRating', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventFilter', 'TransferBatchNettingEventFilter', 'Transfer Batch Netting Event Filter' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'PRICE_FIXING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateMarketDataGroup', 'Access permission to Create Market Data Group' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyMarketDataGroup', 'Access permission to Modify Market Data Group' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveMarketDataGroup', 'Access permission to Remove Market Data Group' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyMyUserDefaultsOnly', 'Access permission to create/modify/delete the currently logged on User Defaults.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyB2BLinkedTrade', 'Access permission to Modify B2B Linked Trades' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataType', 'CurveCDSBasisAdjustment', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'UPDATE_MATCHINGPROCESS', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'FinalMatDate', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'CorrelationSwapConfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'ScenarioCommodity', 'ScenarioCommodity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureContractAttributes', 'CommodityReset', 'Commodity Reset association for asian pricing of the futures.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'InterestBearing', 'InterestBearing ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'CorrelationSwap', 'CorrelationSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'UnitizedFund', 'Unitized Fund ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'PeriodicIRConvention', 'Periodic: IR Convention' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Periodic', 'THIRD_WEDNESDAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency.PeriodicIRConvention', 'Fixing Date Policy for Payment Frequency Following the Interest Rates Convention' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.PeriodicIRConvention', 'WHOLE_PERIOD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.PeriodicIRConvention', 'FIRST_DAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.PeriodicIRConvention', 'LAST_DAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FwdLadderPVDisplayCcy', 'FwdLadder PV Display Currency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FwdLadderPVDisplayCcy', 'USD', 'Default PV Display Currency for FwdLadder' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EquityStructuredOption.Pricer', 'Pricers for EquityStructuredOption' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerEquityStructuredOption', 'Default Pricer for single asset Equity OTC structured option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerAnalyticBasketStructuredOption', 'analytic Pricer for Equity basket option - using Ju 2002 basket approximation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerMonteCarloBasketStructuredOption', 'MonteCarlo Pricer for Equity basket option, vanilla and performance payoffs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerAnalyticBarrierStructuredOption', 'analytic Pricer for single asset option with barriers' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerAnalyticDigitalStructuredOption', 'analytic Pricer for single asset digital option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerMonteCarloAsianStructuredOption', 'MonteCarlo Pricer for single asset asian or lookback option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'BankingPriority', 'Swift priority by message type' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Cash_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Cash_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Cash_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Full_Base_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Total_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Total_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Translation_Risk', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'positionProductType', 'Position based product types' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'positionProductType', 'PLPositionProduct', 'Position based product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'EnableExoticBaskets', '' )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'MARKET_PARAMETER_EFFECT', '', 67, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'VOLATILITY_EFFECT_FX', '', 68, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP1_FS1_V1_T1', '', 69, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S0_FP0F_FS0F_VA0_T1', '', 70, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S0_FP1_FS1_VA1_T1', '', 71, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP0F_FS1_V1_T1', '', 72, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP1_FS0F_V1_T1', '', 73, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP1_FS1_VA0_T1', '', 74, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'DEAL_AMEND_EFFECT', '', 75, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D1_S1_FP1_FS1_V1_T1', '', 76, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'TIME_EFFECT_FX', '', 77, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'FX_EFFECT_D0', 'FX_EFFECT, but with D0', 78, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'IR_EFFECT_D0', 'IR_EFFECT, but with D0', 79, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CREDIT_EFFECT_D0', 'CREDIT_EFFECT, but with D0', 80, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CORR_EFFECT_D0', 'CORR_EFFECT, but with D0', 81, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'RATE_EFFECT_D0', 'RATE_EFFECT, but with D0', 82, 'NPV', 0 )
;
INSERT INTO fixing_date_policy ( fixing_date_policy_id, short_name, fixing_policy_type ) VALUES ( 8, 'Third Wednesday', 'THIRD_WEDNESDAY' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.ANY', 'PricerEquityStructuredOption' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.European', 'PricerAnalyticBasketStructuredOption' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.ANY', 'PricerMonteCarloBasketStructuredOption' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.BARRIER', 'PricerAnalyticBarrierStructuredOption' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.DIGITAL', 'PricerAnalyticDigitalStructuredOption' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.ASIAN', 'PricerMonteCarloAsianStructuredOption' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.LOOKBACK', 'PricerMonteCarloAsianStructuredOption' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PERIOD_KNOWN_PRICE', 'tk.core.PricerMeasure', 341 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PERIOD_UNKNOWN_PRICE', 'tk.core.PricerMeasure', 342 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CORRELATION_01', 'tk.core.PricerMeasure', 347 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REALIZED_CORRELATION', 'tk.core.PricerMeasure', 348 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NET_CORRELATION', 'tk.core.PricerMeasure', 349 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CONVERSION_FACTOR', 'tk.pricer.PricerMeasureConversionFactor', 350 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'POSITION_CASH', 'tk.core.PricerMeasure', 351 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'VALUE_INTRADAY_OPTIONS', 'java.lang.Boolean', 'true,false', 'Use this pricing parameter to add special valuation formulae for option on the day of expiry before expiry time.', 1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'VALUE_NON_STD_DBL_BARRIER', 'java.lang.Boolean', 'true,false', 'Values non-standard double barriers in PricerFXOptionBarrier', 0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'SUPPRESS_AMT_RND_ON_CCY_CONVERT', 'java.lang.Boolean', 'true,false', 'Indicates whether the a during pricing context, final currency converted amount rounding should be suppressed', 0 )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 129, 'PLMark', 0, 0, 0 )
;

UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='003',
        version_date=TO_DATE('25/09/2008','DD/MM/YYYY')
;

