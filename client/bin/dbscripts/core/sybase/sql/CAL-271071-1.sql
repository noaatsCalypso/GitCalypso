 

INSERT INTO pricing_param_name
(param_name, param_type, param_domain, param_comment, is_global_b, default_value) VALUES ('NPV_INCLUDE_SETTLED_CASH', 'java.lang.Boolean', 'true,false', 'Include settled cash in NPV for cash and currency pair positions', 1, 'true')
go

/* Adding column cust_fx_rnd_dig to table commodity_leg2 and 	
populating the column using 3 different tables vcode , vcode2 and vcode3 */

add_column_if_not_exists 'commodity_leg2', 'cust_fx_rnd_dig', 'int default -1 not null'
go

SELECT receive_leg_id=ps.receive_leg_id, code_value=convert( numeric,psc.code_value ) into vcode 
FROM product_sec_code psc, product_desc pd, product_commodity_swap2 ps 
WHERE psc.product_id=pd.product_id 
     AND ps.product_id=psc.product_id 
     AND pd.product_type='CommoditySwap2'
     AND psc.sec_code='Rec.CustomFXRoundingPrecision'
go

SELECT pay_leg_id=ps.pay_leg_id, code_value=convert ( numeric,psc.code_value) into vcode2
FROM product_sec_code psc, product_desc pd, product_commodity_swap2 ps 
WHERE psc.product_id=pd.product_id 
     AND ps.product_id=psc.product_id 
     AND pd.product_type='CommoditySwap2'
                    AND psc.sec_code='Pay.CustomFXRoundingPrecision'
go

SELECT leg_id=po.leg_id,  code_value=convert( numeric,psc.code_value) into vcode3
  FROM product_sec_code psc, product_desc pd, product_commodity_otcoption2 po
 WHERE psc.product_id=pd.product_id
   AND po.product_id=psc.product_id
   AND pd.product_type='CommodityOTCOption2'
   AND psc.sec_code='CustomFXRoundingPrecision'
go

update commodity_leg2 
set commodity_leg2 .cust_fx_rnd_dig  = vcode.code_value  
from commodity_leg2,vcode
where commodity_leg2.leg_id=vcode.receive_leg_id
go

update commodity_leg2 
set commodity_leg2 .cust_fx_rnd_dig  = vcode2.code_value
from commodity_leg2,vcode2
where commodity_leg2.leg_id=vcode2.pay_leg_id
go

update commodity_leg2 
set commodity_leg2 .cust_fx_rnd_dig  = vcode3.code_value
from commodity_leg2,vcode3
where commodity_leg2.leg_id=vcode3.leg_id
go

delete  from product_sec_code where sec_code in ('Rec.CustomFXRoundingPrecision','Pay.CustomFXRoundingPrecision','CustomFXRoundingPrecision')
go

drop table vcode
go
drop table vcode2
go
drop table vcode3
go

/* end */

if not exists (select 1  from sysobjects where
               sysobjects.name = 'fixing_date_policy')
begin
exec ('create table fixing_date_policy (fixing_date_policy_id numeric , short_name varchar(255), fixing_policy_type varchar(255),
                                        int_param_1 numeric null,
                                        int_param_2 numeric null 
,constraint ct_primarykey primary key (fixing_date_policy_id))')
exec('create index idx_fixing on fixing_date_policy(short_name)')
end
go



 
update barrier_parameters
   set rebate_timing = timing_type
 from product_fx_option
 where barrier_parameters.product_id = product_fx_option.product_id 
 and product_fx_option.option_style = 'BARRIER'
go


DROP TABLE trade_filter_page
go

add_domain_values 'REPORT.Types', 'PLMark', 'PLMark Report' 
go

delete from pricing_param_name where param_name='PRICE_INACTIVE_TRADE_FROM_DB' and param_type='java.lang.Boolean' and param_domain= 'true,false' and param_comment = 'Force PricerFromDB to price inactive as well as active trades from  DB' and is_global_b=1 and default_value='false'
go

INSERT INTO pricing_param_name (param_name, param_type, param_domain,  param_comment, is_global_b, default_value) VALUES 
('PRICE_INACTIVE_TRADE_FROM_DB', 'java.lang.Boolean', 'true,false', 'Force PricerFromDB to price inactive as well as active trades from  DB', 1, 'false')
go

delete from domain_values
where (name='function' and value in ('ModifyGroupTradeFilter','ModifyUserTradeFilter'))
or (name='restriction' and value in ('ModifyGroupTradeFilter','ModifyUserTradeFilter'))
go
add_domain_values 'function',   'ModifyGroupTradeFilter','Restriction to allow user to modify only the filter belong to users of that user groups'
go 
add_domain_values 'restriction','ModifyGroupTradeFilter','' 
go

add_domain_values 'function',   'ModifyUserTradeFilter','Restriction to allow user to modify only filters created by him/herself'
go

add_domain_values 'restriction','ModifyUserTradeFilter', ''
go

update bo_audit set entity_class_name = 'PLMark' where entity_class_name = 'com.calypso.tk.marketdata.PLMark'
go

/* bz55866 */
if exists (select 1  from sysobjects 
           where sysobjects.name = 'tmp')        
begin
exec ('drop table tmp')
end
go

select t.trade_id, t.product_id, 
       p.expiry_date, p.option_style,
       tf.fee_id, tf.fee_type, tf.fee_date, tf.amount, tf.currency_code
  into tmp
  from trade t, product_fx_option p, trade_fee tf
 where t.product_id = p.product_id
   and t.trade_id = tf.trade_id
   and p.option_style = 'BARRIER'
   and p.expiry_date >= GETDATE()
   and tf.fee_type = 'PREMIUM'
 order by t.trade_id
go

CREATE PROCEDURE update_rebate_tmp 
AS
BEGIN
  declare @_trade_id         int
  declare @_product_id       int
  declare @_amount           double precision

  declare c1 cursor for select product_id, amount from tmp


  open c1

  fetch c1 into @_product_id, @_amount
  while (@@sqlstatus = 0)
    begin
      update barrier_parameters
         set rebate = abs(@_amount)
       where product_id = @_product_id
         and rebate = 100

      fetch c1 into @_product_id, @_amount
    end

  commit
  close c1
  deallocate cursor c1
END
go

exec sp_procxmode 'update_rebate_tmp','anymode'
go

exec update_rebate_tmp
go

drop procedure update_rebate_tmp
go


/* BZ 55904 */
IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'sp_chngpriority' AND type = 'P')
   BEGIN
     DROP PROCEDURE sp_chngpriority
   END
GO

create proc sp_chngpriority (@leRole varchar(255))
as
declare @bene_le int , @sdid_id int
declare sdid_crsr cursor
for
SELECT bene_le, sdi_id  FROM le_settle_delivery where method='COMMODITY' and le_role=@leRole  and priority=0
open sdid_crsr
fetch sdid_crsr into @bene_le ,  @sdid_id 
 while (@@sqlstatus=0)
   begin
 update le_settle_delivery set priority= 1+(select max(priority) from le_settle_delivery where le_role=@leRole and bene_le= @bene_le)  where sdi_id= @sdid_id
 fetch sdid_crsr into @bene_le ,  @sdid_id 
 end
 close sdid_crsr
 deallocate cursor sdid_crsr
return
go

EXEC sp_chngpriority 'CounterParty'
go

EXEC sp_chngpriority 'ProcessingOrg'
go

DROP PROCEDURE sp_chngpriority
go

/*END*/

/* BZ 40068 */
delete from domain_values where name = 'function' and value = 'ModifyIssuerTemplateLink'
go

delete from group_access where access_value='ModifyIssuerTemplateLink'
go

/* end BZ 40068 */

add_column_if_not_exists 'prod_comm_fwd','cert_holidays','varchar(32) null'
go
add_column_if_not_exists 'prod_comm_fwd ',' cert_offset','numeric null'
go
add_column_if_not_exists 'prod_comm_fwd ',' cert_offset_bus_b','numeric null'
go
add_column_if_not_exists 'prod_comm_fwd ',' cert_dateroll','varchar(32) null'
go
add_column_if_not_exists 'prod_comm_fwd ',' cert_day','numeric null'
go 
	 
UPDATE prod_comm_fwd
  SET cert_offset = payment_offset,
      cert_offset_bus_b = payment_offset_bus_b,
      cert_dateroll = payment_dateroll,
      cert_holidays = payment_holidays,
      cert_day = payment_day
go

UPDATE bo_ts_book SET book_bundle = 'BookBundle.' || book_bundle WHERE book_bundle NOT LIKE 'NONE' AND book_bundle NOT LIKE '%.%'
go
UPDATE task_book_config SET book_bundle = 'BookBundle.' || book_bundle WHERE book_bundle NOT LIKE 'NONE' AND book_bundle NOT LIKE '__ANY__' AND book_bundle NOT LIKE '%.%'
go


/* Update FX Keywords */
DECLARE  @find      varchar(255),
         @replace   varchar(255),
         @patfind   varchar(255)
SELECT   @find            = ',',
         @replace             = ';'

SELECT   @patfind = '%' + @find + '%'

UPDATE   trade_keyword
SET      keyword_value = STUFF(keyword_value,PATINDEX(@patfind,keyword_value),DATALENGTH(@find),@replace )
WHERE    keyword_value like @patfind
AND      keyword_name in ('XCcySplitRates', 'XccySptMismatchRates')
go

/*46187*/

add_column_if_not_exists 'bo_message','legal_entity_id', 'INT DEFAULT 0 not null'
go


add_column_if_not_exists 'bo_message_hist', 'legal_entity_id', 'INT DEFAULT 0 null'
go

update bo_message set bo_message.legal_entity_id = bo_transfer.orig_cpty_id  from bo_transfer where 
bo_message.transfer_id=bo_transfer.transfer_id and bo_message.legal_entity_id=0 and 
bo_message.transfer_id != 0
go

UPDATE bo_message SET bo_message.legal_entity_id = trade.cpty_id 
FROM trade WHERE bo_message.trade_id = trade.trade_id 
and  bo_message.legal_entity_id = 0 AND 
bo_message.trade_id != 0
go
/*end*/


/* BZ 54870 */
DELETE FROM domain_values WHERE name = 'productType' AND value = 'PLPositionProduct'
go

/* BZ 54870 end */


/* BZ 49920 */

INSERT INTO pricing_param_name(param_name, param_type, param_domain, param_comment, is_global_b, default_value) VALUES ('RECOVERY_MODEL','java.lang.String','Fixed,Random,As_Corr_Surface','Recovery rate model for CDO Gaussian copula', 1, 'As_Corr_Surface')
go
/* BZ 49920 end */

/* BZ 53196 */

add_domain_values 'AllocationSupported','CDSNthLoss','' 
go
add_domain_values 'AllocationSupported','CDSNthDefault',''
go
add_domain_values 'AllocationSupported','CreditDefaultSwaption',''
go
add_domain_values 'AllocationSupported','CMCDS',''
go
add_domain_values 'AllocationSupported','CancellableCDS',''
go
add_domain_values 'AllocationSupported','CancellableCDSNthLoss',''
go
add_domain_values 'AllocationSupported','CancellableCDSNthDefault',''
go
add_domain_values 'AllocationSupported','ExtendibleCDS',''
go
add_domain_values 'AllocationSupported','ExtendibleCDSNthLoss',''
go
add_domain_values 'AllocationSupported','ExtendibleCDSNthDefault',''
go

/* BZ 53196 end */

INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'product_fx_opt_fwd', 'product_fx_opt_fwd_hist', 0 )
go
INSERT INTO calypso_table_ext ( name, history_name, is_static_data ) VALUES ( 'product_fx_takeup', 'product_fx_takeup_hist', 0 )
go
add_domain_values   'eco_pl_column', 'MARKET_PARAMETER_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'VOLATILITY_EFFECT_FX', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'D0_S1_FP1_FS1_V1_T1', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'D0_S0_FP0F_FS0F_VA0_T1', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'D0_S0_FP1_FS1_VA1_T1', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'D0_S1_FP0F_FS1_V1_T1', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'D0_S1_FP1_FS0F_V1_T1', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'D0_S1_FP1_FS1_VA0_T1', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'DEAL_AMEND_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'D1_S1_FP1_FS1_V1_T1', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'TIME_EFFECT_FX', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'FX_EFFECT_D0', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'IR_EFFECT_D0', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CREDIT_EFFECT_D0', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'CORR_EFFECT_D0', 'Column implemented by PLCalculator' 
go
add_domain_values   'eco_pl_column', 'RATE_EFFECT_D0', 'Column implemented by PLCalculator' 
go
add_domain_values   'function', 'CreatePublicProductTemplates', 'Allow User to add public templates' 
go
add_domain_values   'function', 'CreatePrivateProductTemplates', 'Allow User to add private templates' 
go
add_domain_values   'commodity.ForwardPriceMethods', 'NearbyThirdWednesday', 'Price is taken from the third wednesday from the fixing date.' 
go
add_domain_values   'domainName', 'genericCusip', 'Generic Cusip for GCF Repo Trades' 
go
add_domain_values   'tradeKeyword', 'Desk', '' 
go
add_domain_values   'domainName', 'cdsAdditionalProvisions', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'U.S. Municipal Entity as Reference Entity', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'STMicroelectronics NV', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'LPN Reference Entities', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'Ref Entities with Delivery Restrictions', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'Secured Deliverable Obligation Characteristic', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'Argentine Republic', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'Republic of Hungary', '' 
go
add_domain_values   'cdsAdditionalProvisions', 'Russian Federation', '' 
go
add_domain_values   'classAuthMode', 'CreditRating', '' 
go
add_domain_values   'function', 'AuthorizeCreditRating', '' 
go
add_domain_values   'domainName', 'measuresForAdjustment', 'List of favorite measures used for PLMark adjustment' 
go
add_domain_values   'measuresForAdjustment', 'ACCRUAL_BO', '' 
go
add_domain_values   'measuresForAdjustment', 'NPV', '' 
go
add_domain_values   'measuresForAdjustment', 'FEES_NPV', '' 
go
add_domain_values   'measuresForAdjustment', 'ACCRUAL', '' 
go
add_domain_values   'measuresForAdjustment', 'CUMULATIVE_CASH', '' 
go
add_domain_values   'measuresForAdjustment', 'PV', '' 
go
add_domain_values   'domainName', 'markAdjustmentReasonOTC', 'Mark Adjustment reasons for OTC products' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Model', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Market data', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Trade economics', ''
go
add_domain_values   'markAdjustmentReasonOTC', 'Val feed failed', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Quantity amendment', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'No NPV feed set up', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Fee', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Coupon', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Div', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Close out', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Funding', '' 
go
add_domain_values   'markAdjustmentReasonOTC', 'Premium', ''
go
add_domain_values   'markAdjustmentReasonOTC', 'Other', '' 
go
add_domain_values   'domainName', 'markAdjustmentReasonPosition', 'Mark Adjustment reasons for position based products' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Market data', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Trade economics', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Val feed failed', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Quantity amendment', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Fee', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Funding', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Coupon', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Divs', '' 
go
add_domain_values   'markAdjustmentReasonPosition', 'Close out', '' 
go
add_domain_values   'domainName', 'CorrelationSwap.Pricer', 'Pricer correlationSwap' 
go
add_domain_values   'domainName', 'CurveCDSBasisAdjustment.gen', 'CDS Basis Adjustment curve generators' 
go
add_domain_values   'domainName', 'CorrelationSwap.subtype', 'CorrelationSwap subtypes' 
go
add_domain_values   'PositionBasedProducts', 'UnitizedFund', 'Unitized Fund product' 
go
add_domain_values   'keyword.terminationReason', 'NotionalIncrease', '' 
go
add_domain_values   'systemKeyword', 'FinalMatDate', '' 
go
add_domain_values   'creditMktDataUsage', 'CDS_BASIS_ADJ', '' 
go
add_domain_values   'domainName', 'creditMktDataUsage.CDS_BASIS_ADJ', '' 
go
add_domain_values   'creditMktDataUsage.CDS_BASIS_ADJ', 'CurveCDSBasisAdjustment', '' 
go
add_domain_values   'domainName', 'delayedSettleFeeType', '' 
go
add_domain_values   'loanType', 'Term Loan C', '' 
go
add_domain_values   'loanType', 'Term Loan D', '' 
go
add_domain_values   'scheduledTask', 'PLMARK_TRANSFER', 'PL Marks transfer.' 
go
add_domain_values   'scheduledTask', 'PL_LOCKDOWN', 'PL Marks lock down.' 
go
add_domain_values   'productType', 'EquityStructuredOption', 'EquityStructuredOption' 
go
add_domain_values   'domainName', 'EquityStructuredOption.extendedType', 'EquityStructuredOption.extendedType domain name' 
go
add_domain_values   'EquityStructuredOption.extendedType', 'Basket', 'when option underlying is a basket' 
go
add_domain_values   'domainName', 'EquityStructuredOption.subtype', 'EquityStructuredOption.subtype domain name' 
go
add_domain_values   'EquityStructuredOption.subtype', 'European', 'VANILLA European option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'American', 'VANILLA American option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'Bermudan', 'VANILLA Bermudan option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'ASIAN', 'ASIAN option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'LOOKBACK', 'LOOKBACK option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'BARRIER', 'BARRIER option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'DIGITAL', 'DIGITAL option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'BEST_OF', 'BEST_OF performance payoff basket option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'WORST_OF', 'WORST_OF performance payoff basket option Product subtype' 
go
add_domain_values   'EquityStructuredOption.subtype', 'RAINBOW', 'RAINBOW performance payoff basket option Product subtype' 
go
add_domain_values   'productType', 'CorrelationSwap', 'CorrelationSwap' 
go
add_domain_values   'domainName', 'keyword.Desk', '' 
go
add_domain_values   'domainName', 'FeeBillingRuleAttributes', '' 
go
add_domain_values   'FeeBillingRuleAttributes', 'DefaultBook', '' 
go
add_domain_values   'CurveCDSBasisAdjustment.gen', 'CDSBasisAdjustment', '' 
go
add_domain_values   'CreditDefaultSwap.Pricer', 'PricerCreditDefaultSwapQuote', '' 
go
add_domain_values   'PLPositionProduct.Pricer', 'PricerPLPositionProduct', 'PLPositionProduct Pricer' 
go
add_domain_values   'domainName', 'PLPositionProduct.Pricer', 'Pricers for PLPositionProduct' 
go
add_domain_values   'eventClass', 'PSEventCreditRating', '' 
go
add_domain_values   'eventFilter', 'TransferBatchNettingEventFilter', 'Transfer Batch Netting Event Filter' 
go
add_domain_values   'exceptionType', 'PRICE_FIXING', '' 
go
add_domain_values   'function', 'CreateMarketDataGroup', 'Access permission to Create Market Data Group' 
go
add_domain_values   'function', 'ModifyMarketDataGroup', 'Access permission to Modify Market Data Group' 
go
add_domain_values   'function', 'RemoveMarketDataGroup', 'Access permission to Remove Market Data Group' 
go
add_domain_values   'function', 'ModifyMyUserDefaultsOnly', 'Access permission to create/modify/delete the currently logged on User Defaults.' 
go
add_domain_values   'function', 'ModifyB2BLinkedTrade', 'Access permission to Modify B2B Linked Trades' 
go
add_domain_values   'marketDataType', 'CurveCDSBasisAdjustment', '' 
go
add_domain_values   'scheduledTask', 'UPDATE_MATCHINGPROCESS', '' 
go
add_domain_values   'tradeKeyword', 'FinalMatDate', '' 
go
add_domain_values   'MESSAGE.Templates', 'CorrelationSwapConfirmation.html', '' 
go
add_domain_values   'riskPresenter', 'ScenarioCommodity', 'ScenarioCommodity' 
go
add_domain_values   'FutureContractAttributes', 'CommodityReset', 'Commodity Reset association for asian pricing of the futures.' 
go
add_domain_values   'productTypeReportStyle', 'InterestBearing', 'InterestBearing ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'CorrelationSwap', 'CorrelationSwap ReportStyle' 
go
add_domain_values   'productTypeReportStyle', 'UnitizedFund', 'Unitized Fund ReportStyle' 
go
add_domain_values   'CommodityPaymentFrequency', 'PeriodicIRConvention', 'Periodic: IR Convention' 
go
add_domain_values   'CommodityPaymentFrequency.Periodic', 'THIRD_WEDNESDAY', '' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency.PeriodicIRConvention', 'Fixing Date Policy for Payment Frequency Following the Interest Rates Convention' 
go
add_domain_values   'CommodityPaymentFrequency.PeriodicIRConvention', 'WHOLE_PERIOD', '' 
go
add_domain_values   'CommodityPaymentFrequency.PeriodicIRConvention', 'FIRST_DAY', '' 
go
add_domain_values   'CommodityPaymentFrequency.PeriodicIRConvention', 'LAST_DAY', '' 
go
add_domain_values   'domainName', 'FwdLadderPVDisplayCcy', 'FwdLadder PV Display Currency' 
go
add_domain_values   'FwdLadderPVDisplayCcy', 'USD', 'Default PV Display Currency for FwdLadder' 
go
add_domain_values   'domainName', 'EquityStructuredOption.Pricer', 'Pricers for EquityStructuredOption' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerEquityStructuredOption', 'Default Pricer for single asset Equity OTC structured option' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerAnalyticBasketStructuredOption', 'analytic Pricer for Equity basket option - using Ju 2002 basket approximation' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerMonteCarloBasketStructuredOption', 'MonteCarlo Pricer for Equity basket option, vanilla and performance payoffs' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerAnalyticBarrierStructuredOption', 'analytic Pricer for single asset option with barriers' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerAnalyticDigitalStructuredOption', 'analytic Pricer for single asset digital option' 
go
add_domain_values   'EquityStructuredOption.Pricer', 'PricerMonteCarloAsianStructuredOption', 'MonteCarlo Pricer for single asset asian or lookback option' 
go
add_domain_values   'domainName', 'BankingPriority', 'Swift priority by message type' 
go
add_domain_values   'plMeasure', 'Cash_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Cash_PnL', '' 
go
add_domain_values   'plMeasure', 'Cash_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Full_Base_PnL', '' 
go
add_domain_values   'plMeasure', 'Total_PnL', '' 
go
add_domain_values   'plMeasure', 'Total_PnL_Base', '' 
go
add_domain_values   'plMeasure', 'Translation_Risk', '' 
go
add_domain_values   'plMeasure', 'Unrealized_Full_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_PnL', '' 
go
add_domain_values   'plMeasure', 'Unrealized_PnL_Base', '' 
go
add_domain_values   'domainName', 'positionProductType', 'Position based product types' 
go
add_domain_values   'positionProductType', 'PLPositionProduct', 'Position based product' 
go
add_domain_values   'domainName', 'EnableExoticBaskets', '' 
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'MARKET_PARAMETER_EFFECT', '', 67, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'VOLATILITY_EFFECT_FX', '', 68, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP1_FS1_V1_T1', '', 69, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S0_FP0F_FS0F_VA0_T1', '', 70, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S0_FP1_FS1_VA1_T1', '', 71, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP0F_FS1_V1_T1', '', 72, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP1_FS0F_V1_T1', '', 73, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D0_S1_FP1_FS1_VA0_T1', '', 74, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'DEAL_AMEND_EFFECT', '', 75, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'D1_S1_FP1_FS1_V1_T1', '', 76, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'TIME_EFFECT_FX', '', 77, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'FX_EFFECT_D0', 'FX_EFFECT, but with D0', 78, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'IR_EFFECT_D0', 'IR_EFFECT, but with D0', 79, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CREDIT_EFFECT_D0', 'CREDIT_EFFECT, but with D0', 80, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CORR_EFFECT_D0', 'CORR_EFFECT, but with D0', 81, 'NPV', 0 )
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'RATE_EFFECT_D0', 'RATE_EFFECT, but with D0', 82, 'NPV', 0 )
go
INSERT INTO fixing_date_policy ( fixing_date_policy_id, short_name, fixing_policy_type ) VALUES ( 8, 'Third Wednesday', 'THIRD_WEDNESDAY' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.ANY', 'PricerEquityStructuredOption' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.European', 'PricerAnalyticBasketStructuredOption' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.Basket.ANY', 'PricerMonteCarloBasketStructuredOption' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.BARRIER', 'PricerAnalyticBarrierStructuredOption' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.DIGITAL', 'PricerAnalyticDigitalStructuredOption' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.ASIAN', 'PricerMonteCarloAsianStructuredOption' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.LOOKBACK', 'PricerMonteCarloAsianStructuredOption' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PERIOD_KNOWN_PRICE', 'tk.core.PricerMeasure', 341 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PERIOD_UNKNOWN_PRICE', 'tk.core.PricerMeasure', 342 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CORRELATION_01', 'tk.core.PricerMeasure', 347 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REALIZED_CORRELATION', 'tk.core.PricerMeasure', 348 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NET_CORRELATION', 'tk.core.PricerMeasure', 349 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CONVERSION_FACTOR', 'tk.pricer.PricerMeasureConversionFactor', 350 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'POSITION_CASH', 'tk.core.PricerMeasure', 351 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'VALUE_INTRADAY_OPTIONS', 'java.lang.Boolean', 'true,false', 'Use this pricing parameter to add special valuation formulae for option on the day of expiry before expiry time.', 1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'VALUE_NON_STD_DBL_BARRIER', 'java.lang.Boolean', 'true,false', 'Values non-standard double barriers in PricerFXOptionBarrier', 0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'SUPPRESS_AMT_RND_ON_CCY_CONVERT', 'java.lang.Boolean', 'true,false', 'Indicates whether the a during pricing context, final currency converted amount rounding should be suppressed', 0 )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 129, 'PLMark', 0, 0, 0 )
go

UPDATE calypso_info
    SET major_version=10,
        minor_version=0,
        sub_version=0,
        patch_version='003',
        version_date='20080925'
go
