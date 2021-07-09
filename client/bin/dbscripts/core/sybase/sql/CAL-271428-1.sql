 
delete from domain_values where name='riskPresenter' and value in ('CommodityCertificateStock', 'FwdLadder', 'MatrixSheet', 'ReportWrapper' , 'ScenarioFORiskPosition','ScenarioSlide', 'VegaByStrike')
go

/* CAL-77180, CAL-77172 ADR out of date - returning ADR to Equity table*/
IF EXISTS (SELECT 1 FROM syscolumns WHERE name = 'equity_name' and id = object_id('product_adr'))
BEGIN
  /* take care of divdend info first, not stored in product_equity table but in dividend_calc_info table */
  INSERT INTO dividend_calc_info (product_id, dividend_type, b_cumulative, rate_index, rate_index_spread, fixed_rate, frequency, currency, date_roll, ex_dividend_days,  day_count, rolling_day, dividend_decimals, rounding_method, payment_lag, business_b, holidays, payment_rule, date_rule, index_factor, reset_days, resetlag_bus_b, reset_decimals, reset_rounding_method, reset_holidays, record_days, record_days_b, ex_dividend_days_b, stub_start_date, stub_end_date)
  SELECT product_id, 'FIXED_RATE', 0, null, 0, 0, dividend_frequency, dividend_currency, 'NO_CHANGE', 0, '30/360', 0, dividend_decimals, 'NEAREST', 2, 0, null, 'ADJUSTED', 0, 0, 0, 0, 0, 'NEAREST', null, 0, 0, 0, null, null
    FROM product_adr
   WHERE product_adr.pay_dividend = 1
     AND product_id NOT IN (SELECT DISTINCT product_id FROM dividend_calc_info)

  /* move then to product_equity what should have been persisted in product_equity */
  INSERT INTO product_equity (product_id, equity_name, corporate, country, currency, exchange_code, total_issued,  pay_dividend, entered_date, entered_user, comments, trading_size, active_date, inactive_date, sub_type, quote_type,nominal_decimals, equity_status)
  SELECT product_id, equity_name, null, country,currency, exchange_code, total_issued, pay_dividend, entered_date,entered_user, comments,trading_size, null, inactive_date, sub_type, 'Price', 0, null
    FROM product_adr
   WHERE product_id NOT IN (SELECT DISTINCT product_id FROM product_equity)

  /* product_adr.issuer_id col is not necessary as product_desc.issuer_id exists */
  UPDATE product_desc SET product_desc.issuer_id = product_adr.issuer_id
    FROM product_desc, product_adr
   WHERE product_desc.product_id = product_adr.product_id
END
go



/* CAL-82966, CAL-83377 removing dividend_calc_info table which is not used */
/* restoring data belonging to product_equity table */ 
IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'dividend_calc_info' and type = 'U') 
BEGIN
UPDATE product_equity 
SET product_equity.dividend_currency = dividend_calc_info.currency, 
product_equity.dividend_frequency = dividend_calc_info.frequency, 
product_equity.dividend_date_rule = dividend_calc_info.date_rule,
product_equity.dividend_decimals = dividend_calc_info.dividend_decimals 
FROM product_equity, dividend_calc_info 
WHERE product_equity.product_id = dividend_calc_info.product_id 
END 
go

update report_win_def set use_pricing_env=1 where def_name = 'CompositeAnalysis'
go

/*
* BEGIN CAL-70866 - refactor of commodity cash flow generation
*/


add_column_if_not_exists 'commodity_leg2','security_comm_reset_id','numeric null'
go

add_column_if_not_exists 'commodity_leg2','start_date','datetime null'
go

add_column_if_not_exists 'commodity_leg2','end_date','datetime null'
go

add_column_if_not_exists 'cf_sch_gen_params','param_type','varchar(16) default ''COMMODITY'' null'
go

add_column_if_not_exists 'cf_sch_gen_params','fixing_start_lag','numeric default 0 not null'
go

add_column_if_not_exists 'cf_sch_gen_params','fixing_end_lag','numeric default 0 not null'
go

/*
* ensure type is on the cf_sch_gen_params key
*/
update cf_sch_gen_params set param_type='COMMODITY' where param_type is null
go

if exists (select 1 from sysobjects where type='P' and name = 'cf_key_change')
begin
exec ('drop proc cf_key_change')
end
go

create procedure cf_key_change
as
	declare @indId  int
	declare @colName varchar(200)
	declare @objName varchar(200)
	declare @objId int
	declare @colCount int
	declare @found bit
	declare @colNameReq varchar(50)
	declare @indName varchar(50)
        declare @cmd varchar(200)
begin
	select  @objName = 'cf_sch_gen_params',
        	@colName = '',
	        @colCount = 1,
	        @found = 0,
	        @colNameReq = 'param_type'
	select  @objId = object_id(@objName)

	select  @indId = min(indid)
	from    sysindexes
	where   id = @objId
	and     indid > 0

	while (@colName is not null)
	begin
	    select @colName = index_col(@objName, @indId, @colCount)
	    if (@colName is null)
	    begin
        	break
    	    end

    	    if (@colName = @colNameReq)
    	    begin
        	select @found = 1
        	break
    	    end
    	    select @colCount = @colCount + 1
	end

	if (@found = 0)
	begin
	    select @indName = name
	    from   sysindexes  
	    where  id = @objId
	    and    indid = @indId

	    select @cmd = 'alter table ' || @objName || ' drop constraint ' || @indName
	    exec(@cmd)
	    select @cmd = 'alter table ' || @objName || ' add constraint ' || @indName || ' PRIMARY KEY CLUSTERED (product_id, leg_id, param_type)'
	    exec(@cmd)
	end
end
go

begin
	exec cf_key_change
end
go
drop procedure cf_key_change
go

/*
* update start/end dates on the legs
*/
update 	commodity_leg2
set    	security_comm_reset_id = fwd.comm_reset_id,
	start_date = fwd.start_date,
       	end_date = fwd.maturity_date,
    	strike_price_unit = fwd.payment_price_unit
from	prod_comm_fwd fwd,
        commodity_leg2 leg
where   fwd.comm_leg_id = leg.leg_id
and     leg.start_date is null
go


/*
*  define the fixing lags
*/
update 	cf_sch_gen_params
set     fixing_start_lag = abs(datediff(day, param.start_date, leg.start_date)),
        fixing_end_lag = abs(datediff(day, leg.end_date, param.end_date)),
        fixing_calendar = fwd.fixing_holidays,
	payment_calendar = fwd.payment_holidays,
	payment_lag = fwd.payment_offset,
	payment_date_roll = fwd.payment_dateroll,
	payment_day = fwd.payment_day,
	payment_offset_bus_b = case when fwd.payment_offset_bus_b is not null then fwd.payment_offset_bus_b 
else 0 
end,
        fx_reset_id = fwd.fx_reset_id
from    cf_sch_gen_params param,
        commodity_leg2 leg,
	prod_comm_fwd fwd
where  	leg.leg_id = param.leg_id
and	fwd.comm_leg_id = leg.leg_id
and	param.start_date is not null
and     param.end_date is not null
and	leg.start_date is not null
and  	leg.end_date is not null
and 	param.param_type = 'COMMODITY'
go

/*
* insert sec parameters
*/
insert into cf_sch_gen_params
(
	product_id, 
	payment_lag, 
	payment_calendar,
	fixing_calendar,
	payment_offset_bus_b,
	payment_day,
	payment_date_rule,
	payment_date_roll,
	leg_id,
	param_type,
	fixing_start_lag,
	fixing_end_lag,
	fx_reset_id
)
select 	params.product_id,
	fwd.cert_offset,
	fwd.cert_holidays,
	fwd.fixing_holidays,
	fwd.cert_offset_bus_b,
	fwd.cert_day,
	params.payment_date_rule,
	fwd.cert_dateroll,
	params.leg_id,
	'SECURITY',
	params.fixing_start_lag,
	params.fixing_end_lag,
	params.fx_reset_id
from   	prod_comm_fwd fwd,
	cf_sch_gen_params params
where  	fwd.comm_leg_id > 0
and	params.leg_id = fwd.comm_leg_id
and	params.product_id = fwd.product_id
and	params.param_type = 'COMMODITY'
and	not exists ( 	select 	1
			from   	cf_sch_gen_params sec_params
			where  	sec_params.leg_id = fwd.comm_leg_id
			and	sec_params.product_id = fwd.product_id
			and	sec_params.param_type = 'SECURITY')
go
/*
* END CAL-70866 - refactor of commodity cash flow generation
*/
update  commodity_leg2
set     leg.start_date = param.start_date,
        leg.end_date = param.end_date
from    commodity_leg2  leg,
        cf_sch_gen_params  param
where exists (
            	select 1
		from	product_commodity_swap2	swap
       	   	where	(swap.pay_leg_id = leg.leg_id
			or	swap.receive_leg_id = leg.leg_id)
		)					
and	leg.leg_id = param.leg_id
and	leg.start_date is null
go

update  commodity_leg2
set     leg.start_date = param.start_date,
        leg.end_date = param.end_date
from    commodity_leg2  leg,
        cf_sch_gen_params  param
where exists (
            	select 1
		        from	product_commodity_otcoption2 otc
       	   	    where	otc.leg_id = leg.leg_id
		)					
and	leg.leg_id = param.leg_id
and	leg.start_date is null
go
/* end */


update  commodity_leg2 
set leg.leg_type = case 
when leg.leg_type = 0 then 2
when leg.leg_type = 1 then 3
else -1
end
from prod_comm_fwd fwd, commodity_leg2 leg 
where fwd.comm_leg_id = leg.leg_id 
and	leg.leg_type in (0, 1)
go

/* CAL-84756 */
update curve set curve.curve_generator='DividendDiscrete'
from curve_div_hdr
where 
curve.curve_type = 'CurveDividend' AND
curve.curve_generator = null AND
curve.curve_id = curve_div_hdr.curve_id AND
curve.curve_date = curve_div_hdr.curve_date AND
curve_div_hdr.dividend_type='Discrete'
go

update position_spec
set source = 'Risk and PL'
where source = 'Liquidation Engine'
go
update position_spec
set source = 'Spot Blotter'
where source = 'Settle Positions'
go
update position_spec
set source = 'Liquidity'
where source = 'Product Positions'
go
update pricing_param_name set param_domain='Crank-Nicolson,Euler Implicit,Lawson-Morris,Rannacher,Runge-Kutta Implicit' where param_name = 'FD_SCHEME' 
go
update trd_win_cl_config set class_name = 'dealStation.DealStation$FX' where product_type like 'FX%' AND class_name like 'className%'
go
update trd_win_cl_config set class_name = 'dealStation.DealStation$MM' where product_type = 'Cash' AND class_name like 'className%'
go

/* CAL-77093, CAL-8761 Multiple liquidations per book/product */
/* create liq_config_name if not existing */
if not exists (select 1 from sysobjects where sysobjects.name = 'liq_config_name')
BEGIN
    EXEC ('CREATE TABLE liq_config_name (id numeric(18,0) not null, name varchar(32) not null, version numeric(18,0) not null, CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED(id))')
END
go

/* create default entry */
if not exists (SELECT 1 FROM liq_config_name where id = 0)
BEGIN
    INSERT INTO liq_config_name(id, name, version) values (0, 'DEFAULT', 0)
END	
go
DELETE from domain_values where name='CurveUnderlyingCommoditySpreadType' and value='Calendar'
go

update bo_posting set trade_id=position_id 
from pl_position 
where bo_posting.original_event in ('POSITION_VALUATION') 
and pl_position.book_id=bo_posting.book_id and pl_position.product_id=bo_posting.product_id 
and pl_position.liq_agg_id=0 and bo_posting.trade_id=0
go

update bo_posting_hist set trade_id=position_id 
from pl_position 
where bo_posting_hist.original_event in ('POSITION_VALUATION') 
and pl_position.book_id=bo_posting_hist.book_id and pl_position.product_id=bo_posting_hist.product_id 
and pl_position.liq_agg_id=0 and bo_posting_hist.trade_id=0
go

/* CAL-90759 Upgrade script to replace the 6 month Equivalent objectives to Harmonized Risk/Cash Objective*/

create procedure c_param	
as
begin
declare @paramname varchar(255)
declare c_param_crsr cursor
for
select distinct param_name
		from an_param_items
		where attribute_value like '%SixMonthEquivalent%'
open c_param_crsr 
fetch c_param_crsr into @paramname 
while (@@sqlstatus=0)
 begin 
   update an_param_items set attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveHarmonizedRisk' 
   where attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveSixMonthEquivalentRisk' and param_name = @paramname
   update an_param_items set attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveHarmonizedCash' 
   where attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveSixMonthEquivalentCash' and param_name = @paramname
   delete from an_param_items where param_name = @paramname and attribute_name = 'Harmonized_Bucket'
   insert into an_param_items(param_name,class_name,attribute_name,attribute_value) 
   values (@paramname,'com.calypso.tk.risk.ForwardLadderParam','Harmonized_Bucket','182.5')
   fetch c_param_crsr into @paramname 
 End

close c_param_crsr 
deallocate cursor c_param_crsr
end
go

exec c_param
go

drop procedure c_param
go

delete from ps_event_config where engine_name='HedgeRelationshipEngine' 
and not exists ( select * from engine_config where engine_config.engine_name = 'HedgeRelationshipEngine' )
go

update domain_values
set name = 'CommodityLocation'
from domain_values outer
where name = 'CommodityStorageLocation'
and not exists
(
select 1
from domain_values inner
where inner.name = 'CommodityLocation'
and inner.value = outer.value
)
go

insert into delivery_set (set_id , name,currency) select product_id, name, currency from product_basket where basket_type='FutureDeliverySet'
go

insert into delivery_set_futures select product_id,comp_prod_id from basket_comp where product_id in (select product_id from product_basket where basket_type='FutureDeliverySet')
go
delete from basket_comp where product_id in (select product_id from product_basket where basket_type='FutureDeliverySet')
go
delete from product_basket where basket_type='FutureDeliverySet'
go 

DELETE FROM rating_values WHERE rating_type = 'Current' AND order_id = 0 AND agency_name = 'Collateral' AND rating_value = 'Regular'
go
delete from rating_values where rating_type = 'Current' and order_id = 0 AND agency_name = 'Collateral' AND rating_value = 'Whole Loan'
go
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 0, 'Collateral', 'Whole Loan')
go
delete from rating_values where rating_type = 'Current' and order_id = 1 AND agency_name = 'Collateral' AND rating_value = 'SBC-Agency'
go
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 1, 'Collateral', 'SBC-Agency')
go
delete from rating_values where rating_type = 'Current' and order_id = 2 AND agency_name = 'Collateral' AND rating_value = 'SBC-AAA'
go
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 2, 'Collateral', 'SBC-AAA')
go
delete from rating_values where rating_type = 'Current' and order_id = 3 AND agency_name = 'Collateral' AND rating_value = 'SBC-AA'
go
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 3, 'Collateral', 'SBC-AA')
go
delete from domain_values where name='ratingAgency' and value='Collateral'
go
INSERT INTO domain_values(name, value, description) VALUES ('ratingAgency', 'Collateral', 'Collateral value used for Advance and AdvanceLetterCredit products')
go

DELETE FROM referring_object where rfg_obj_id IN (601,602)
go

/* CAL-97462 CAL-71386 Initialize new columns on liq_position and pl_position tables */
/* Update liq_position: all trades must be in trade. */
/* adding the columns before updating*/

add_column_if_not_exists 'liq_position','first_trade_date','datetime null'
go
add_column_if_not_exists 'liq_position','second_trade_date','datetime null'
go
add_column_if_not_exists 'liq_position_hist','first_trade_date','datetime null'
go
add_column_if_not_exists 'liq_position_hist','second_trade_date','datetime null'
go
add_column_if_not_exists 'pl_position','last_trade_date','datetime null'
go
add_column_if_not_exists 'pl_position_hist','last_trade_date','datetime null'
go

update liq_position
set first_trade_date= trade.trade_date_time from trade 
where trade.trade_id=liq_position.first_trade
and liq_position.first_trade_date is null
and liq_position.is_deleted=0
go
update liq_position
set second_trade_date=trade.trade_date_time from trade where trade.trade_id=liq_position.second_trade
and liq_position.second_trade_date is null
and liq_position.is_deleted=0
go

/* Update liq_position_hist: trades may be either in trade or trade_hist. */
select * into #all_trade 
from (select trade_id, trade_date_time from trade union all
select trade_id, trade_date_time from trade_hist) all_trade
go
update liq_position_hist
set first_trade_date=#all_trade.trade_date_time from #all_trade 
where #all_trade.trade_id=liq_position_hist.first_trade and liq_position_hist.first_trade_date is null
and liq_position_hist.is_deleted=0
go
update liq_position_hist
set second_trade_date=#all_trade.trade_date_time from #all_trade 
where #all_trade.trade_id=liq_position_hist.second_trade and liq_position_hist.second_trade_date is null
and liq_position_hist.is_deleted=0
go
DROP TABLE #all_trade
go

/* Update pl_position: join from both liq_position and liq_position_hist (pl_position_hist not used). */
update pl_position 
set last_trade_date= case 
     when liq_position.first_trade_date > liq_position.second_trade_date then liq_position.first_trade_date 
     when liq_position.second_trade_date > liq_position.first_trade_date then liq_position.second_trade_date 
	 when liq_position.first_trade_date=null then liq_position.second_trade_date
	 when liq_position.second_trade_date=null then liq_position.first_trade_date
	 end
from liq_position 
where liq_position.is_deleted=0
and pl_position.last_trade_date is null 
and liq_position.position_id=pl_position.position_id
go

update pl_position 
set last_trade_date= case 
     when liq_position_hist.first_trade_date > liq_position_hist.second_trade_date then liq_position_hist.first_trade_date
     when liq_position_hist.second_trade_date > liq_position_hist.first_trade_date then liq_position_hist.second_trade_date 
	 when liq_position_hist.first_trade_date=null then liq_position_hist.second_trade_date
	 when liq_position_hist.second_trade_date=null then liq_position_hist.first_trade_date
end
from liq_position_hist,pl_position_hist 
where liq_position_hist.is_deleted=0
and pl_position_hist.last_trade_date is null 
and liq_position_hist.position_id=pl_position.position_id
go


/* CAL-101234 */
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ACTUAL-SETTLE'
go
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ACTUAL-TRADE'
go
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-FAILED-TRADE'
go
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-FAILED-SETTLE'
go
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-THEORETICAL-SETTLE'
go
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-THEORETICAL-TRADE'
go
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ROLLED_INTEREST-SETTLE'
go
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ROLLED_INTEREST-TRADE'
go



exec add_column_if_not_exists 'product_swap','opt_expiry_hol','varchar(128) null'
go
exec add_column_if_not_exists 'product_swaption','opt_expiry_hol','varchar(128) null'
go

UPDATE product_swap SET opt_expiry_hol = opt_cal_hol
go
UPDATE product_swaption SET opt_expiry_hol = opt_cal_hol
go

UPDATE report_win_def SET use_pricing_env=1 WHERE def_name='Account'
go

/* CAL-104839 */

add_domain_values 'domainName','UnitizedFund.subtype','Types of Unitized Fund'
go
add_domain_values 'UnitizedFund.subtype','Fixed Income','Fixed Income'
go
add_domain_values 'UnitizedFund.subtype','Equity','Equity'
go
add_domain_values 'UnitizedFund.subtype','Money Market','Money Market'
go
add_domain_values 'UnitizedFund.subtype','Commodity','Commodity'
go
add_domain_values 'UnitizedFund.subtype','FX','FX'
go
add_domain_values 'UnitizedFund.subtype','Mixed','Mixed'
go

/* end */ 
add_column_if_not_exists 'cu_swap','fixed_currency','varchar(3) null'
go

UPDATE cu_swap SET fixed_currency = substring(rate_index,1,3) WHERE fixed_currency IS NULL
go
update hs_header set blob_data = null
go

/* CAL-106419 */
add_column_if_not_exists 'cu_basis_swap','base_cmp_method','varchar(32) null'
go
add_column_if_not_exists 'cu_basis_swap','basis_cmp_method','varchar(32) null'
go
UPDATE cu_basis_swap SET base_cmp_method = 'NoCompound' WHERE base_compound_b = 0
go
UPDATE cu_basis_swap SET basis_cmp_method = 'NoCompound' WHERE basis_compound_b = 0
go

UPDATE cu_basis_swap SET base_cmp_method = 'Spread' WHERE base_cmp_spread_b = 1 AND base_compound_b = 1 AND base_cmp_method IS NULL
go
UPDATE cu_basis_swap SET basis_cmp_method = 'Spread' WHERE basis_cmp_spread_b = 1 AND basis_compound_b = 1 AND basis_cmp_method IS NULL
go
UPDATE cu_basis_swap SET base_cmp_method = 'NoSpread' WHERE base_cmp_spread_b = 0 AND base_compound_b = 1 AND base_cmp_method IS NULL
go
UPDATE cu_basis_swap SET basis_cmp_method = 'NoSpread' WHERE basis_cmp_spread_b = 0 AND basis_compound_b = 1 AND basis_cmp_method IS NULL
go
add_column_if_not_exists 'cu_basis_swap','base_cmp_method','varchar(32) not null'
go
add_column_if_not_exists 'cu_basis_swap','basis_cmp_method','varchar(32) not null'
go

/* end */

/* CAL-108250 */
if not exists(select 1 from sysobjects where type='U' and name='mrgcall_template_ids')
begin
exec ('create table mrgcall_template_ids (mrg_call_def numeric not null, template_id numeric not null, position numeric null, CONSTRAINT mti_primarykey PRIMARY KEY CLUSTERED (mrg_call_def, template_id))')
exec ('insert into mrgcall_template_ids SELECT mc.mrg_call_def, t.template_id, 0 FROM report_template t, report_browser_tree_node tn, mrgcall_config mc WHERE t.template_name = tn.report_template_name and t.report_type=tn.report_template_type and mc.rept_browser_config_id =  tn.rept_browser_config_id')
end
go


/* end */

/* CAL-109653 */
 
/* end */
update comp_config set is_editable = 1
go

/* CAL-110899 */
delete from domain_values where name = 'PositionBasedProducts' and value = 'CommoditySwap2'
go
/* end */

/* CAL-111354 */
UPDATE trade_keyword
   SET keyword_value='Y' WHERE keyword_value LIKE 'true'
   AND keyword_name IN ('TerminationPayIntFlow', 'TransferPayIntFlow', 'TerminationFullFirstCalculationPeriod', 'TerminationPrincipalExchange')
go

UPDATE trade_keyword
   SET keyword_value='N' WHERE keyword_value LIKE 'false'
   AND keyword_name IN ('TerminationPayIntFlow', 'TransferPayIntFlow', 'TerminationFullFirstCalculationPeriod', 'TerminationPrincipalExchange')
go
/* end */
 
/*CAL-110908 */
add_column_if_not_exists 'product_market_index','quote_type','varchar(32) null'
go

INSERT INTO product_market_index (product_id,name,currency,market_place_id,issuer_id,issue_pay_agent_id,country,publish_holiday,publish_frequency,publish_dayofweek,publish_date_rule,publish_time,publish_timezone,basket_id,index_type,external_ref,description,quote_type)
SELECT product_equity_idx.product_id,product_equity_idx.name,product_equity_idx.currency,product_equity_idx.market_place_id,product_equity_idx.issuer_id,product_equity_idx.issue_pay_agent_id,product_equity_idx.country,product_equity_idx.publish_holiday,product_equity_idx.publish_frequency,product_equity_idx.publish_dayofweek,product_equity_idx.publish_date_rule,product_equity_idx.publish_time,product_equity_idx.publish_timezone,product_equity_idx.basket_id,product_equity_idx.index_type,product_equity_idx.external_ref,product_equity_idx.description,product_equity_idx.quote_type
FROM product_equity_idx
WHERE product_equity_idx.product_id not in (select product_id from product_market_index)
go

/* CAL-111784 */
add_domain_values 'scheduledTask','EOD_CAPLMARKING_OLD',null 
go

add_domain_values 'scheduledTask','EOD_SYSTEM_PLMARKING_OLD',null 
go

delete from domain_values where value in('EOD_PLMARKING_FULL','EOD_SYSTEM_PLMARKING')
go

update sched_task
set task_type = 'EOD_CAPLMARKING'
where task_type = 'EOD_PLMARKING_FULL'
go

/*end*/

/* CAL - 103670 */


add_column_if_not_exists 'cash_settle_dflt','currency_code2' ,'varchar(4) default ''NONE'' not null'
go

add_column_if_not_exists 'cash_settle_dflt','rate_index_code2', 'varchar(3) default ''NONE'' not null'
go

update cash_settle_dflt set currency_code2='NONE' where currency_code2 is null
go

update cash_settle_dflt set rate_index_code2='NONE' where rate_index_code2 is null
go



/* CAL-98976 */

add_domain_values 'marketDataUsage', 'TIME_HORIZON_FUNDING', 'Zero curves for calculating funding cost in horizon simulation'
go
add_domain_values 'domainName', 'horizonFundingPolicy', 'List of funding policy names used in horizon simulation'
go
add_domain_values 'horizonFundingPolicy', 'Daily', 'Daily funding policy used in horizon simulation'
go
add_domain_values 'horizonFundingPolicy', 'Horizon', 'Horizon funding policy used in horizon simulation'
go
/* end */


/* CAL-110908 */
if not exists (select 1 from sysobjects where type='U' and name='basket_info')
begin
exec ('CREATE TABLE basket_info ( product_id numeric NOT NULL, basket_id numeric NOT NULL, effective_date datetime NOT NULL )')
end
go


INSERT INTO basket_info (product_id, basket_id, effective_date)
SELECT product_id, basket_id, convert(datetime, '01/01/1970', 101)
FROM product_market_index
WHERE basket_id <>0
go

update product_market_index set basket_id = 0
go

INSERT INTO basket_info (product_id, basket_id, effective_date)
SELECT product_id, basket_id, convert(datetime, '01/01/1970', 101)
FROM product_equity_idx
WHERE basket_id <>0
go
update product_equity_idx set basket_id = 0
go

UPDATE domain_values SET value='DisableCheckLERelation' WHERE name='function' AND value='DesableCheckLERelation'
go

UPDATE group_access SET access_value='DisableCheckLERelation' WHERE access_value='DesableCheckLERelation'
go

sp_rename 'calibration.dsecription', description
go

/* CAL-60273: adding column book_id to tables BO_MESSAGE and BO_MESSAGE_HIST */

add_column_if_not_exists 'bo_message','book_id', 'numeric DEFAULT 0 NOT NULL'
go
add_column_if_not_exists 'bo_message_hist','book_id', 'numeric DEFAULT 0 NOT NULL'
go
 

UPDATE bo_message
    SET book_id = bo_transfer.book_id from bo_transfer 
	WHERE bo_transfer.transfer_id = bo_message.transfer_id AND bo_transfer.book_id is not null and
      bo_message.book_id = 0 AND bo_message.transfer_id != 0
go


UPDATE bo_message
    SET book_id = trade.book_id from trade WHERE trade.trade_id = bo_message.trade_id AND trade.book_id is not null
    and bo_message.book_id = 0 AND bo_message.transfer_id = 0 AND bo_message.trade_id != 0
go



UPDATE bo_message_hist
    SET book_id = bo_transfer_hist.book_id from bo_transfer_hist WHERE bo_transfer_hist.transfer_id = bo_message_hist.transfer_id 
	AND bo_transfer_hist.book_id is not null
    and  bo_message_hist.book_id = 0 AND bo_message_hist.transfer_id != 0
go

 

UPDATE bo_message_hist
    SET book_id = trade_hist.book_id from trade_hist WHERE trade_hist.trade_id = bo_message_hist.trade_id AND trade_hist.book_id is not null
	and bo_message_hist.book_id = 0 AND bo_message_hist.transfer_id = 0 AND bo_message_hist.trade_id != 0
go
/* CAL-114862 */
select pl_mark_value.* into pl_mark_value_tmp from pl_mark, pl_mark_value, pl_position
where pl_mark.trade_id = pl_position.position_id
and pl_mark_value.mark_id = pl_mark.mark_id
and pl_mark_value.mark_name in ('NPV', 'NPV_NET')
go
update pl_mark_value_tmp set mark_name='NPV_WITH_COST' where mark_name='NPV'
go
update pl_mark_value_tmp set mark_name='NPV_NET_WITH_COST' where mark_name='NPV_NET'
go
insert into pl_mark_value select * from pl_mark_value_tmp
go
drop table pl_mark_value_tmp
go


/* CAL-111601 */
DELETE FROM market_data_item  WHERE NOT EXISTS 
(SELECT * FROM hs_header, market_data_item WHERE  market_data_item.mdata_name = hs_header.name) AND mdata_type = 'HyperSurfaceImpl'
go

/* end */ 

select * into fee_grid_bak from fee_grid
go

if not exists(select 1 from sysobjects where name='fee_grid_product')
begin
exec('create table fee_grid_product (fee_grid_id numeric not null,
									 product_sequence numeric not null,
									 product_name varchar(255) null)')
end
go

if exists(select 1 from sysobjects where name='reparse_table' and type ='P')
begin
exec('drop proc reparse_table')
end
go

create procedure reparse_table
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(255),
      @parse_out_val    varchar(255),
      @myid int,
	  @prd_seq numeric	
declare cur_main cursor for
  select fee_grid_id, product_list from fee_grid where product_list != 'NONE' AND product_list is not null
open cur_main
  fetch cur_main into @myid, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @prd_seq = 0
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			select @prd_seq= @prd_seq + 1 
			insert into fee_grid_product (fee_grid_id,product_sequence,product_name) values (@myid,@prd_seq,@parseval)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 select @prd_seq = @prd_seq + 1
		     insert into fee_grid_product (fee_grid_id,product_sequence,product_name) values (@myid,@prd_seq,@parse_out_val)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	select @prd_seq= @prd_seq + 1 
			 	insert into fee_grid_product (fee_grid_id,product_sequence,product_name) values (@myid,@prd_seq,@parseval)
			end
		  end
		  
		 
     fetch cur_main into @myid, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec reparse_table
go
drop procedure reparse_table
go

/* end */
select * into an_param_items_bak from an_param_items
go

update an_param_items set attribute_value= str_replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%/Horizon' and class_name = 'com.calypso.tk.risk.SimulationParam'
go
update an_param_items set attribute_value= str_replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like 'Horizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%,Horizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like 'Horizon/%' and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%/Horizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%,Horizon%' and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value = 'Horizon' and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like '%/FXHorizon' and class_name = 'com.calypso.tk.risk.SimulationParam'
go
update an_param_items set attribute_value= str_replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value = 'FXHorizon'  and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like  'FXHorizon,%'  and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like  '%,FXHorizon,%'  and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like  'FXHorizon/%'  and class_name = 'com.calypso.tk.risk.SimulationParam'
go

update an_param_items set attribute_value= str_replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like '%/FXHorizon,%'  and class_name = 'com.calypso.tk.risk.SimulationParam'
go
update an_param_items set attribute_value= str_replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like  '%,FXHorizon%'  and class_name = 'com.calypso.tk.risk.SimulationParam'
go


/*end */ 
delete from domain_values where name='scheduledTask' and value in('EOD_CAPLMARKING_OLD','EOD_SYSTEM_PLMARKING','EOD_SYSTEM_PLMARKING_OLD')
go
/* end */ 

delete from domain_values where name='domain' and value ='ForwardLadderProduct' 
go
delete from domain_values where name='ForwardLadderProduct'
go
delete from domain_values where name='riskAnalysis' and value='FwdLadder'  
go
delete from domain_values where name='domain' and value= 'FwdLadderPVDisplayCcy'
go
delete from domain_values where name='domainName' and value ='ForwardLadderProduct'
go
delete from domain_values where name='domainName' and value= 'FwdLadderPVDisplayCcy'
go
delete from domain_values where name='riskPresenter' and value='FwdLadder'
go
delete from domain_values where name='FwdLadderPVDisplayCcy'
go



/* CAL-112768 */
INSERT INTO product_sec_code (product_id, sec_code, code_value, code_value_ucase)
SELECT product_id, 'USE_LOCAL_MAPPINGS', 'true', 'TRUE'
FROM product_cdsnthdflt (parallel 5)
WHERE product_id NOT IN
(SELECT psc.product_id FROM product_sec_code psc (parallel 5) WHERE psc.sec_code = 'USE_LOCAL_MAPPINGS')
go

INSERT INTO product_sec_code (product_id, sec_code, code_value, code_value_ucase)
SELECT product_id, 'USE_LOCAL_MAPPINGS', 'true', 'TRUE'
FROM product_cdsnthloss (parallel 5)
WHERE product_id NOT IN
(SELECT psc.product_id FROM product_sec_code psc (parallel 5) WHERE psc.sec_code = 'USE_LOCAL_MAPPINGS')
go

/* end */
/* CAL-102083 */
INSERT INTO trade_keyword (trade_id, keyword_name, keyword_value) SELECT trade_id, 'SettledCreditEventIds', keyword_value 
FROM trade_keyword WHERE keyword_name = 'CreditEventIds' AND trade_id NOT IN 
(SELECT trade_id FROM trade_keyword WHERE keyword_name = 'SettledCreditEventIds')
go
/* end */ 
/* add the diff from version 11.1.0.4 to 12.0 */

INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (721,'FULL_COUPON','Bond','Coupon payment including Withholding Tax Amount','FULL','REALIZED','N/A','NONE','',0,0 )
go
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (722,'REFUND_COUPON','Bond','Withholding Tax Amount of the coupon to be reclaimed','FULL','REALIZED','N/A','NONE','',0,0 )
go
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (723,'WITHHOLDINGTAX','Bond','Withholding Tax Amount','FULL','BALANCE','N/A','NONE','',0,0 )
go
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (724,'NET_WITHHOLDINGTAX','Bond','Withholding Tax Amount net of TaxAuthority refund','FULL','BALANCE','N/A','NONE','',0,0 )
go
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16558,'HEDGED_MTM_CHG','ALL','Fair Value Change on the Hedged Trade','ClosingPeriod','INVENTORY','Reversal','NONE','NPV_NET',0 )
go
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16559,'HEDGING_MTM_CHG','ALL','Fair Value on the Hedging Trade','ClosingPeriod','INVENTORY','Reversal','NONE','NPV_NET',0 )
go
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16560,'INCEPTION_MTM','ALL','Fair Value At Inception on the Trade Item','FULL','INVENTORY','N/A','NONE','NPV_NET',0 )
go
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16561,'INCEPTION_MTM_REV','ALL','Fair Value At Inception on the Trade Item','FULL','INVENTORY','N/A','NONE','NPV_NET',0 )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16558,'HEDGE_VALUATION' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16559,'HEDGE_VALUATION' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'HEDGE_VALUATION' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'VERIFIED_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'CANCELED_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'HEDGE_VALUATION' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'VERIFIED_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'CANCELED_TRADE' )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('Portfolio','apps.risk.PortfolioAnalysisReportFrameworkViewer',0 )
go
INSERT INTO auth_class_config ( class_name, full_class_name ) VALUES ('BondDanishMortgage','com.calypso.tk.product.BondDanishMortgage' )
go
INSERT INTO auth_class_config ( class_name, full_class_name ) VALUES ('Equity','com.calypso.tk.product.Equity' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (1549,'Reject' )
go
add_domain_values 'Drawn MM Book','Drawn MM Book', ''
go
add_domain_values 'domainName','ReportOutput.ReportViewerRequiringSort','List of ReportViewer requiring sort done in ReportOutput ' 
go
add_domain_values 'ReportOutput.ReportViewerRequiringSort','Simple','' 
go
add_domain_values 'ReportOutput.ReportViewerRequiringSort','Tree','' 
go
add_domain_values 'ReportOutput.ReportViewerRequiringSort','Pivot','Pivot View' 
go
add_domain_values 'domainName','Report.Default.ViewerList','List of ReportViewer requiring sort done in ReportOutput ' 
go
add_domain_values 'Report.Default.ViewerList','Simple','' 
go
add_domain_values 'Report.Default.ViewerList','Tree',''
go
add_domain_values 'Report.Default.ViewerList','Pivot','Pivot View' 
go
add_domain_values 'domainName','PLMktSpread','Products for which PL explained should compute market spread' 
go
add_domain_values 'domainName',' excludeProductTypesGreeksPL ',''
go
add_domain_values 'workflowRuleTransfer','SettleLinkedDDA',''
go
add_domain_values 'workflowRuleTransfer','UnsettleLinkedDDA',''
go
add_domain_values 'workflowRuleMessage','CheckIncomingFormat',''
go
add_domain_values 'workflowRuleMessage','UnprocessSubStatement',''
go
add_domain_values 'workflowRuleTrade','CheckManualCancelAuthorized',''
go
add_domain_values 'commodity.ForwardPriceMethods','InterpolatedPrice','Price on curve date equal to the FixDate, using the Interpolator defined in the curve.' 
go
add_domain_values 'volSurfaceType','VolatilitySurface3DSpread',''
go
delete from domain_values where name='VolSurface.gensimple' and value='SVISimple'
go
add_domain_values 'VolSurface.gensimple','SVISimple',''
go
add_domain_values 'VolSurface.gensimple','SABRLocalVolSimple',''
go
add_domain_values 'volSurfaceGenerator','SVI',''
go
add_domain_values 'volSurfaceGenerator.commodity','CommodityVolatilitySpread','VS Generator for Commodity Spread Options'
go
add_domain_values 'domainName','eXSPReportVariables','Available ArrayVariable for CashFlowGeneratorBased eXSP Product Report' 
go
add_domain_values 'eXSPReportVariables','EXOTIC_COUPONS','Coupon Formula' 
go
add_domain_values 'domainName','AccountHolderSDIContact','Used to indicate the contact type for the sdi of a CallAccount.' 
go
add_domain_values 'domainName','StandardUnderlyingSwapId','The swap underlying id to build a market standard swap' 
go
add_domain_values 'domainName','TransferViewer.XferAttributes.DateAttributesToKeep',''
go
add_domain_values 'leAttributeType','CASH_MANAGEMENT',''
go
add_domain_values 'leAttributeType','CHECK_INCOMING_FORMAT',''
go
add_domain_values 'domainName','leAttributeType.CHECK_INCOMING_FORMAT',''
go
add_domain_values 'leAttributeType.CHECK_INCOMING_FORMAT','NO',''
go
add_domain_values 'leAttributeType.CHECK_INCOMING_FORMAT','YES',''
go
add_domain_values 'leAttributeType','SpotDaysEQ',''
go
add_domain_values 'domainName','MainEntry.CustomEventSubscription','Allow customer to add custom Events to be subscribed to' 
go
add_domain_values 'domainName','MEPreload','Main Entry Preload' 
go
add_domain_values 'MEPreload','BOCashPosition',''
go
add_domain_values 'MEPreload','BOSecurityPosition',''
go
add_domain_values 'MEPreload','BOBrowser',''
go
add_domain_values 'function','UseProcessingOrgHierarchy','AccessPermission for ability to look for the whole tree of children of Processing Orgs' 
go
add_domain_values 'classAuditMode','CarveOut',''
go
add_domain_values 'domainName','BondDanishMortgage.Pricer','Pricers for Danish Mortgage bonds' 
go
add_domain_values 'domainName','FutureSwap.Pricer','Pricers for money market futures' 
go
add_domain_values 'domainName','ETOVolatility.Pricer','Pricers for ETOVolatility (exchange traded equity option) trades' 
go
add_domain_values 'domainName','FutureDividend.Pricer','Pricers for Dividend Futures' 
go
add_domain_values 'domainName','FutureVolatility.Pricer','Pricers for Volatility Futures' 
go
add_domain_values 'CurveZero.gen','Global',''
go
add_domain_values 'tradeTerminationAction','TERMINATE',''
go
add_domain_values 'tradeTerminationAction','CONTINUE',''
go
add_domain_values 'hedgeStrategyAttributes','NumberOfObservations',''
go
add_domain_values 'hedgeStrategyAttributes','PostingsOnlyIfEffective','PostingsOnlyIfEffective' 
go
add_domain_values 'hedgeRelationshipAttributes','ShiftOnDiscountCurve','Shift Amount used to shifted curve' 
go
add_domain_values 'hedgeRelationshipAttributes','LastEffectivenessTest','LastEffectivenessTest' 
go
add_domain_values 'REPORT.Types','LEContact','LEContact Report' 
go
add_domain_values 'domainName','BondDanishMortgage.subtype','Types of Danish Mortgage Bonds' 
go
add_domain_values 'domainName','BondStructuredNote.subtype','Types of ELNs' 
go
add_domain_values 'domainName','MarginCall.DisputeReason','Dispute Reasons of Margin Call' 
go
add_domain_values 'domainName','MarginCall.ContractDisputeReason','Dispute Status of Margin Call Contract' 
go
add_domain_values 'domainName','MarginCall.ContractDisputeStatus','Dispute Status of Margin Call Contract' 
go
add_domain_values 'domainName','StaticPricingScriptDefinitions','Names of static pricing script definitions' 
go
add_domain_values 'StaticPricingScriptDefinitions','Worst Of Digital',''
go
add_domain_values 'StaticPricingScriptDefinitions','Accumulator',''
go
add_domain_values 'StaticPricingScriptDefinitions','Accumulator Tarn',''
go
add_domain_values 'StaticPricingScriptDefinitions','Decumulator',''
go
add_domain_values 'StaticPricingScriptDefinitions','Decumulator Tarn',''
go
add_domain_values 'StaticPricingScriptDefinitions','Vanilla Basket',''
go
add_domain_values 'StaticPricingScriptDefinitions','Vanilla European',''
go
add_domain_values 'StaticPricingScriptDefinitions','Autocall',''
go
add_domain_values 'StaticPricingScriptDefinitions','Multi-defender',''
go
add_domain_values 'StaticPricingScriptDefinitions','Vanilla Variance Swap',''
go
add_domain_values 'StaticPricingScriptDefinitions','Himalaya',''
go
add_domain_values 'StaticPricingScriptDefinitions','Hi Five Basket Bonus',''
go
add_domain_values 'StaticPricingScriptDefinitions','Altiplano',''
go
add_domain_values 'StaticPricingScriptDefinitions','Basket Worst M',''
go
add_domain_values 'StaticPricingScriptDefinitions','Basket Range Accrual',''
go
add_domain_values 'StaticPricingScriptDefinitions','Fixed Dual Currency Note',''
go
add_domain_values 'domainName','CashFlowLeg.subtype','Types of CashFlowLeg' 
go
add_domain_values 'classAuditMode','BondDanishMortgage',''
go
add_domain_values 'classAuditMode','VolatilityIndex',''
go
add_domain_values 'PositionBasedProducts','FutureOptionVolatility','FutureOptionVolatility out of box position based product' 
go
add_domain_values 'PositionBasedProducts','FutureDividend','FutureEquityIndex out of box position based product' 
go
add_domain_values 'PositionBasedProducts','FutureVolatility','FutureVolatility out of box position based product' 
go
add_domain_values 'PositionBasedProducts','BondStructuredNote','BondStructuredNote out of box position based product' 
go
add_domain_values 'PositionBasedProducts','ETOVolatility','ETOVolatility out of box position based product' 
go
add_domain_values 'rateIndexAttributes','GenerateRateChange',''
go
add_domain_values 'systemKeyword','TerminationPrincipalExchange',''
go
add_domain_values 'systemKeyword','TransferType',''
go
add_domain_values 'systemKeyword','MergedFrom',''
go
add_domain_values 'systemKeyword','MergedTo',''
go
add_domain_values 'systemKeyword','SplitFrom',''
go
add_domain_values 'systemKeyword','SplitTo',''
go
add_domain_values 'systemKeyword','ExternalMirrorId',''
go
add_domain_values 'tradeKeyword','ExternalMirrorId',''
go
add_domain_values 'futureUnderType','Volatility',''
go
add_domain_values 'futureUnderType','Dividend',''
go
add_domain_values 'futureOptUnderType','Volatility',''
go
add_domain_values 'ETOUnderlyingType','Volatility',''
go
add_domain_values 'futureUnderType','Swap',''
go
add_domain_values 'futureOptUnderType','Swap',''
go
delete from domain_values where name='feeCalculator' and value='AnnualPercentage'
go
add_domain_values 'feeCalculator','AnnualPercentage',''
go
delete from domain_values where name='domainName' and value='defaultCISManagementFeeType'
go
add_domain_values 'domainName','defaultCISManagementFeeType',''
go
delete from domain_values where name='defaultCISManagementFeeType' and value='MANAGEMENT_FEE'
go
add_domain_values 'defaultCISManagementFeeType','MANAGEMENT_FEE',''
go
add_domain_values 'defaultCISManagementFeeType','PREMIUM',''
go
add_domain_values 'tenor','91D',''
go
add_domain_values 'feeCalculator','None',''
go
add_domain_values 'scheduledTask','GREEKS_INPUT','Greeks for PLE' 
go
add_domain_values 'scheduledTask','BOND_DRAWING',''
go
add_domain_values 'userAttributes','Load Min Product Info','Boolean used by TaskStation' 
go
add_domain_values 'userAttributes','Max Number of Reconnections','Used by TaskStation when reconnecting to ES' 
go
add_domain_values 'userAttributes','Reconnection Timeout','Used by TaskStation when reconnecting to ES' 
go
add_domain_values 'userAttributes','Reverse Margin on HRR','Used to indicate if we need to reverse Margin on HRR trade' 
go
add_domain_values 'EquityStructuredOption.subtype','ASIAN_BARRIER','Asian Barrier option Product subtype' 
go
add_domain_values 'EquityStructuredOption.subtype','eXSP','eXSP option Product subtype' 
go
add_domain_values 'keyword.TerminationPayIntFlow','Y',''
go
add_domain_values 'keyword.TerminationPayIntFlow','N',''
go
add_domain_values 'keyword.TransferPayIntFlow','Y',''
go
add_domain_values 'keyword.TransferPayIntFlow','N',''
go
add_domain_values 'keyword.TerminationFullFirstCalculationPeriod','Y',''
go
add_domain_values 'keyword.TerminationFullFirstCalculationPeriod','N',''
go
add_domain_values 'keyword.TerminationPrincipalExchange','Y',''
go
add_domain_values 'keyword.TerminationPrincipalExchange','N',''
go
add_domain_values 'CurveCommodity.gen','CommoditySwap','Commodity Swap price generator' 
go
add_domain_values 'CurveCommodity.gen','CommodityCumulative',''
go
add_domain_values 'CurveCommodity.gen','ConvenienceYield',''
go
add_domain_values 'domainName','CurveCommoditySpread.gen','Commodity Spread curve generators' 
go
add_domain_values 'CurveCommoditySpread.gen','MonthlyAsianSwapSpread',''
go
add_domain_values 'CurveCommoditySpread.gen','CommoditySpreadAllInPoints',''
go
add_domain_values 'domainName','CommodityOTCOption2.subtype','Subtypes for CommodityOTCOption2' 
go
add_domain_values 'CommodityOTCOption2.subtype','American','American' 
go
add_domain_values 'CommodityOTCOption2.subtype','Asian','Asian' 
go
add_domain_values 'CommodityOTCOption2.subtype','Digital','Digital' 
go
add_domain_values 'CommodityOTCOption2.subtype','European','European' 
go
add_domain_values 'CommodityOTCOption2.subtype','Standard','Standard' 
go
add_domain_values 'productType','VolatilityIndex',''
go
add_domain_values 'userAccessPermAttributes','Max.TradeDiary','Type to be enforced by reports' 
go
add_domain_values 'transferAction','UNSETTLE','Unsettle the transfer.' 
go
add_domain_values 'securityCode','FromBondProduct',''
go
add_domain_values 'securityCode','DMB Serie',''
go
add_domain_values 'accEventType','HEDGED_MTM_CHG',''
go
add_domain_values 'accEventType','HEDGING_MTM_CHG',''
go
add_domain_values 'accEventType','INCEPTION_MTM',''
go
add_domain_values 'accEventType','INCEPTION_MTM_REV',''
go
add_domain_values 'bondType','BondStructuredNote','bondtype ELN domain' 
go
add_domain_values 'bondType','BondDanishMortgage','bondtype domain' 
go
add_domain_values 'BondStructuredNote.Pricer','PricerBondStructuredNote','Pricer for BondStructuredNote' 
go
add_domain_values 'BondDanishMortgage.Pricer','PricerBondDanishMortgage','Pricer for BondDanishMortgage' 
go
add_domain_values 'ETOVolatility.Pricer','PricerETOVolatility',''
go
add_domain_values 'FutureMM.Pricer','PricerFutureMMSpecific','Pricer for Future MM FedFund/Eonia-Sonia' 
go
add_domain_values 'FutureSwap.Pricer','PricerFutureSwap',''
go
add_domain_values 'FutureDividend.Pricer','PricerFutureDividend',''
go
add_domain_values 'FutureVolatility.Pricer','PricerFutureVolatility',''
go
add_domain_values 'VarianceSwap.Pricer','PricerVarianceSwapReplicationFX','Pricer for variance swap by replication on an FX underlying' 
go
add_domain_values 'VarianceSwap.Pricer','PricerVarianceSwapReplication','Pricer for variance swap by replication on an equity/index underlying' 
go
add_domain_values 'Bond.subtype','BondStructuredNote','subtype for structured note' 
go
add_domain_values 'EquityLinkedSwap.Pricer','PricerAmortizingSwap',''
go
add_domain_values 'domainName','EquityLinkedSwap.extendedType',''
go
add_domain_values 'EquityLinkedSwap.extendedType','Amortizing_Swap',''
go
add_domain_values 'domainName','showProductMapper','domain to control if the ProductMapper will be shown on the ExoticType. Enter a YES or Y (any case) as a value' 
go
add_domain_values 'BondStructuredNote.subtype','Standard','BondStructuredNote subtype' 
go
add_domain_values 'BondDanishMortgage.subtype','Standard','Standard Danish Mortgage bond subtype' 
go
add_domain_values 'BondDanishMortgage.subtype','Drawn','Drawn Danish Mortgage bond subtype' 
go
add_domain_values 'CA.subtype','DRAWING','DRAWING' 
go
delete from domain_values where name='engineName' and value='RiskEngineBroker'
go
add_domain_values 'engineName','RiskEngineBroker',''
go
add_domain_values 'interpolator','InterpolatorMonotoneConvex','Interpolator for interest-rate-like curves designed to produce smooth local forward rates.' 
go
add_domain_values 'eventType','EX_EXT_POS_INIT','Indicates an issue with the initialization of the External Position.' 
go
add_domain_values 'exceptionType','EXT_POS_INIT',''
go
add_domain_values 'eventType','EX_BOND_DRAWING','Indicates that a Scheduled Task could not create a Drawn Bond.' 
go
add_domain_values 'feeCalculator','EquityLinkedSwapPercentage','Percentage fee calculator for Equity Linked Swap (holds FX conversion)' 
go
add_domain_values 'flowType','BANK CONFIRMED','External Position' 
go
add_domain_values 'function','CalypsoMLImport','Access permission to import CalypsoML into dataserver. Used by CAM and Configuration Management Tool.' 
go
add_domain_values 'function','CalypsoMLExport','Access permission to export CalypsoML into dataserver. Used by CAM and Configuration Management Tool.' 
go
add_domain_values 'feeCalculator','PhysicalSettlementPct',''
go
add_domain_values 'flowType','ADJUSTMENT',''
go
add_domain_values 'flowType','RATE_CHANGE',''
go
add_domain_values 'function','ProcessStatus.Statement Integration#Process Anyway','Access permission Force Process Statement Integration' 
go
add_domain_values 'function','ProcessStatus.Statement Integration#Ignore','Access permission Ignore Statement Integration' 
go
add_domain_values 'function','ProcessStatus.Statement Integration#Try Again','Access permission Retry Statement Integration' 
go
add_domain_values 'function','ProcessStatus.Master Statements Received#Ignore','Access permission Ignore Master Statement Check' 
go
add_domain_values 'function','ProcessStatus.Master Statements Received#Try Again','Access permission Retry Master Statement Check' 
go
add_domain_values 'function','ProcessStatus.Account Consolidation#Ignore','Access permission Ignore Account Conso' 
go
add_domain_values 'function','ProcessStatus.Account Consolidation#Try Again','Access permission Retry Account Conso' 
go
add_domain_values 'function','ProcessStatus.Statement Generation#Ignore','Access permission Ignore Statement Generation' 
go
add_domain_values 'function','ProcessStatus.Statement Generation#Try Again','Access permission Retry Statement Generation' 
go
add_domain_values 'function','ProcessStatus.Sub Statement Processing#Try Again','Access permission Retry Sub Statement Processing' 
go
add_domain_values 'function','CreateModifyPositionRolloverRule','Permission to Save Position Rollover Rule' 
go
add_domain_values 'function','RemovePositionRolloverRule','Permission to Remove Position Rollover Rule' 
go
add_domain_values 'function','DisableCheckLERelation','Access permission to Disable the Check of Legal Entity Relation' 
go
add_domain_values 'billingEvents','BillingTaskEvent' ,''
go
add_domain_values 'marketDataUsage','DIS_COLLATERAL_SP','usage type for Repo Underlying Curve Mapping' 
go
add_domain_values 'marketDataUsage','DIS_COLLATERAL_GC','usage type for Repo Underlying Curve Mapping' 
go
add_domain_values 'messageType','RATE_CHANGE_ADVICE',''
go
add_domain_values 'productType','BondStructuredNote','produttype domain' 
go
add_domain_values 'productType','BondDanishMortgage','produttype domain' 
go
add_domain_values 'productType','CashFlowLeg',''
go
add_domain_values 'productType','FutureSwap',''
go
add_domain_values 'productType','ETOVolatility',''
go
add_domain_values 'productType','FutureDividend',''
go
add_domain_values 'productType','FutureVolatility',''
go
add_domain_values 'productType','FutureOptionVolatility',''
go
add_domain_values 'riskAnalysis','Portfolio','Portfolio Analysis' 
go
add_domain_values 'role','TaxAuthority','withholding tax management' 
go
add_domain_values 'riskAnalysis','ScenarioGreeksInput',''
go
add_domain_values 'MESSAGE.Templates','CreditFacilityConfirm.html',''
go
add_domain_values 'MESSAGE.Templates','CreditTrancheConfirm.html',''
go
add_domain_values 'scheduledTask','EQD_FWD_SETTLE',''
go
add_domain_values 'scheduledTask','HEDGE_ACCOUNTING',''
go
add_domain_values 'scheduledTask','HEDGE_EFFECTIVENESS',''
go
add_domain_values 'scheduledTask','LOAD_CALCULATIONSERVER','load services on calculation server' 
go
add_domain_values 'scheduledTask','LOAD_SAVED_CALCULATIONSERVER','load pre-saved analysis output on calculation server' 
go
add_domain_values 'scheduledTask','REPO_GC_MD_MAPPINGS','Map Repo Underlying with Zero curves usage DIS_COLLATERAL_GC' 
go
add_domain_values 'tradeKeyword','TransferType',''
go
add_domain_values 'tradeKeyword','TerminationPrincipalExchange',''
go
add_domain_values 'tradeKeyword','SettledCreditEventIds',''
go
add_domain_values 'SWIFT.Templates','MT104','Direct Debit and Request for Debit Transfer Message' 
go
add_domain_values 'SWIFT.Templates','MT204','Request for Debit Of a Third Party Transfer Message' 
go
delete from domain_values where name='SWIFT.Templates' and value='Payment.selector'
go
add_domain_values 'SWIFT.Templates','Payment.selector','PaymentTemplateSelector' 
go
add_domain_values 'SWIFT.Templates','Payment205.selector','Payment205TemplateSelector' 
go
add_domain_values 'SWIFT.Templates','PaymentCOV.selector','PaymentCOVTemplateSelector' 
go
add_domain_values 'SWIFT.Templates','Payment205COV.selector','Payment205COVTemplateSelector' 
go
add_domain_values 'MESSAGE.Templates','rateChangeAdvice.html',''
go
add_domain_values 'InventoryPositions','EXTERNAL-BANK CONFIRMED-SETTLE',''
go
add_domain_values 'applicationName','AuthService',''
go
add_domain_values 'riskPresenter','Portfolio',''
go
add_domain_values 'riskPresenter','Pricing',''
go
add_domain_values 'FutureContractAttributes','CommodityResetForPhysicalDeliveryId','Commodity Reset association for storage based Commodity with future physical delivery' 
go
add_domain_values 'FutureContractAttributesReadOnly','CommodityResetForPhysicalDeliveryId','not editable in AttributableWindow, please consider using underlying reset choice' 
go
add_domain_values 'domainName','ProcessStatusCustomizer','ProcessStatusCustomizer and className in comment' 
go
add_domain_values 'ProcessStatusCustomizer','CashManagement','tk.report.CashManagementProcessStatusCustomizer' 
go
add_domain_values 'domainName','CustomMessageViewerTab','Custom Message Viewer Tab Names' 
go
add_domain_values 'domainName','CustomTransferViewerTab','Custom Transfer Viewer Tab Names' 
go
add_domain_values 'productInterfaceReportStyle','Exotic','Exotic ReportStyle for eXSP ArrayVariable' 
go
add_domain_values 'productTypeReportStyle','BondStructuredNote','BondStructuredNote ReportStyle' 
go
add_domain_values 'productTypeReportStyle','CashFlowLeg','CashFlowLeg  ReportStyle' 
go
add_domain_values 'productTypeReportStyle','ETOVolatility','ETOVolatility ReportStyle' 
go
add_domain_values 'productTypeReportStyle','Future','Future ReportStyle' 
go
add_domain_values 'productTypeReportStyle','FutureDividend','FutureDividend ReportStyle' 
go
add_domain_values 'productTypeReportStyle','FutureVolatility','FutureVolatility ReportStyle' 
go
add_domain_values 'CommodityAveragingPolicy','CoalATC','CoalATC' 
go
add_domain_values 'CommodityAveragingPolicy','CoalCTA','CoalCTA' 
go
add_domain_values 'CommodityAveragingPolicy','CoalCTAWithFXRoll','CoalCTAWithFXRoll' 
go
add_domain_values 'CommodityFXAveragingPolicy','CoalATC','CoalATC' 
go
add_domain_values 'CommodityFXAveragingPolicy','CoalCTA','CoalCTA' 
go
add_domain_values 'CommodityFXAveragingPolicy','CoalCTAWithFXRoll','CoalCTAWithFXRoll' 
go
add_domain_values 'groupStaticDataFilter','Carve-out','group for StaticDataFilters which should be available in Carve-out related windows' 
go
add_domain_values 'function','AddDividend','Allow User to add Dividend to Equity DividendSchedule' 
go
add_domain_values 'function','RemoveDividend','Allow User to remove Dividend from Equity DividendSchedule' 
go
add_domain_values 'domainName','masterConfirmationRelevantDates',''
go
add_domain_values 'masterConfirmationRelevantDates','TerminationTradeDate','{TerminationType=FullTermination|NotionalIncrease|Novation|PartialNovation|PartialTermination}' 
go
add_domain_values 'masterConfirmationRelevantDates','TransferTradeDate','{TransferType=FullTermination|NotionalIncrease|Novation|PartialNovation|PartialTermination}' 
go
add_domain_values 'domainName','fixingType','Future Price Reference on some market place for ETO or Future' 
go
add_domain_values 'fixingType','EDSP','Exchange Delivery Settlement Price' 
go
add_domain_values 'fixingType','VWAP','Volume-Weighted Average Price' 
go
add_domain_values 'fixingType','PDR','Prezzo Di Riferimento' 
go
add_domain_values 'domainName','SimulationCommonMeasures','Defines the contents of the "Commonly Used" option in Simulation Viewer SelectableListChooserWindow popups.' 
go
add_domain_values 'SimulationCommonMeasures','BETA',''
go
add_domain_values 'SimulationCommonMeasures','BETA_ADJUSTED_INDEX',''
go
add_domain_values 'SimulationCommonMeasures','BETA_INDEX',''
go
add_domain_values 'SimulationCommonMeasures','DELTA',''
go
add_domain_values 'SimulationCommonMeasures','DELTA_01',''
go
add_domain_values 'SimulationCommonMeasures','DELTA_IN_UNDERLYING',''
go
add_domain_values 'SimulationCommonMeasures','GAMMA',''
go
add_domain_values 'SimulationCommonMeasures','GAMMA_IN_UNDERLYING',''
go
add_domain_values 'SimulationCommonMeasures','MOD_DELTA',''
go
add_domain_values 'SimulationCommonMeasures','MOD_GAMMA',''
go
add_domain_values 'SimulationCommonMeasures','MOD_VEGA',''
go
add_domain_values 'SimulationCommonMeasures','NDELTA',''
go
add_domain_values 'SimulationCommonMeasures','NGAMMA',''
go
add_domain_values 'SimulationCommonMeasures','NPV',''
go
add_domain_values 'SimulationCommonMeasures','NTHETA',''
go
add_domain_values 'SimulationCommonMeasures','NVEGA',''
go
add_domain_values 'SimulationCommonMeasures','PV01',''
go
add_domain_values 'SimulationCommonMeasures','PV01_CREDIT',''
go
add_domain_values 'SimulationCommonMeasures','RHO',''
go
add_domain_values 'SimulationCommonMeasures','RHO2',''
go
add_domain_values 'SimulationCommonMeasures','SPOT_RATE',''
go
add_domain_values 'SimulationCommonMeasures','THETA',''
go
add_domain_values 'SimulationCommonMeasures','VEGA',''
go
add_domain_values 'domainName','CA.keywords','Types of keywords that can be applied to CA trades' 
go
add_domain_values 'CA.keywords','WithholdingTaxConfigId','The WithholdingTax rate and TaxAuthority reclaim details applied to a CASH CA' 
go
add_domain_values 'classAuthMode','LEUserAccessRelation',''
go
add_domain_values 'classAuditMode','LEUserAccessRelation',''
go
add_domain_values 'function','ModifyAccessPermLEAccess','Change access permissions LE Access Tab' 
go
add_domain_values 'function','AuthorizeLEUserAccessRelation','Access permission to Authorize LEUserAccessRelation' 
go
add_domain_values 'domainName','dataSegregationEnabledApps','Web Apps' 
go
add_domain_values 'dataSegregationEnabledApps','Authorization','Web Module for Authorization' 
go
add_domain_values 'dataSegregationEnabledApps','AccountActivity','Web Module for Account Activity' 
go
add_domain_values 'dataSegregationEnabledApps','InventoryCashPosition','Web Module for Inventory Cash Position' 
go
add_domain_values 'dataSegregationEnabledApps','CashForecast','Web Module for Cash Forecast' 
go
add_domain_values 'dataSegregationEnabledApps','DealRequest','Web Module for Deal Request' 
go
add_domain_values 'dataSegregationEnabledApps','IntercompanySettlement','Web Module for Intercompany Settlement' 
go
add_domain_values 'dataSegregationEnabledApps','Statements','Web Module for Statements' 
go
add_domain_values 'dataSegregationEnabledApps','SDI','Web Module for SDI' 
go
add_domain_values 'dataSegregationEnabledApps','Payments','Web Module for Payments' 
go
add_domain_values 'dataSegregationEnabledApps','Confirmations','Web Module for Confirmations' 
go
add_domain_values 'dataSegregationEnabledApps','TradeBlotter','Web Module for Trade Blotter' 
go
add_domain_values 'dataSegregationEnabledApps','TradeViewer','Web Module for Trade Viewer' 
go
add_domain_values 'dataSegregationEnabledApps','TradeReport','Web Module for Trade Report' 
go
add_domain_values 'dataSegregationEnabledApps','PaymentsReport','Web Module for Payments Report' 
go
add_domain_values 'dataSegregationEnabledApps','ConfirmationsReport','Web Module for Confirmations Report' 
go
add_domain_values 'dataSegregationEnabledApps','__ALL__','ALL Web Modules' 
go
add_domain_values 'marketDataUsage','HyperSurfaceOpen',''
go
add_domain_values 'domainName','hyperSurfaceHyperDataTypeDomain',''
go
add_domain_values 'domainName','CashFlowLeg.Pricer','Pricers for CashFlowLeg' 
go
add_domain_values 'CashFlowLeg.Pricer','PricerCashFlowLeg',''
go
add_domain_values 'Warrant.Pricer','PricerBlack1FAnalyticDiscreteVanilla','analytic Pricer for european vanilla warrant - using Forward based Black Scholes Merton model - can do discrete dividends' 
go
add_domain_values 'Warrant.Pricer','PricerBlack1FFiniteDifference','Pricer for american/bermudan/european vanilla Warrant using Finite Differences on Black Scholes Merton model' 
go
add_domain_values 'EquityStructuredOption.Pricer','PricerBlackNFMonteCarloExotic','MonteCarlo Pricer for eXSP option payoffs' 
go
add_domain_values 'EquityStructuredOption.Pricer','PricerBlack1FFiniteDifference','Finite Difference Pricer for single asset european or american or bermudan option'
go
add_domain_values 'EquityStructuredOption.Pricer','PricerLocalVolatility1FFiniteDifference','Finite Difference Pricer for single asset option' 
go
add_domain_values 'EquityStructuredOption.Pricer','PricerLocalVolatility1FFiniteDifferenceExotic','Finite Difference Pricer for single asset option with eXSP payoff' 
go
add_domain_values 'EquityStructuredOption.Pricer','PricerLocalVolatility1FMonteCarlo','Monte-Carlo Pricer for single asset option' 
go
add_domain_values 'EquityStructuredOption.Pricer','PricerLocalVolatilityNFMonteCarloExotic','Monte Carlo Pricer for single and basket asset option with eXSP payoff' 
go
add_domain_values 'CurveInflation.gen','InflationIndexKerkhof',''
go
add_domain_values 'interpolatorInflation','InterpolatorFlatForward',''
go
add_domain_values 'interpolatorInflation','InterpolatorLinear',''
go
add_domain_values 'interpolatorInflation','InterpolatorLogSpline',''
go
add_domain_values 'interpolatorInflation','InterpolatorLogMonotonicSplineNaturalHyman89',''
go
add_domain_values 'function','ViewAllWHTAttributes','Allow User to See Hidden Entry in WithholdingTaxAttribute' 
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_POS_CASH',''
go
add_domain_values 'plMeasure','Sales_Full_PnL',''
go
add_domain_values 'plMeasure','Sales_PnL',''
go
add_domain_values 'plMeasure','Sales_Realized_Full_PnL',''
go
add_domain_values 'plMeasure','Sales_Realized_PnL',''
go
add_domain_values 'plMeasure','Sales_Unrealized_Full_PnL',''
go
add_domain_values 'plMeasure','Sales_Unrealized_PnL',''
go
add_domain_values 'plMeasure','Trader_Full_PnL',''
go
add_domain_values 'plMeasure','Trader_PnL',''
go
add_domain_values 'plMeasure','Trader_Realized_Full_PnL',''
go
add_domain_values 'plMeasure','Trader_Realized_PnL',''
go
add_domain_values 'plMeasure','Trader_Unrealized_Full_PnL',''
go
add_domain_values 'plMeasure','Trader_Unrealized_PnL',''
go
add_domain_values 'plMeasure','Trade_Date_Cash_Full_PnL',''
go
add_domain_values 'plMeasure','Unrealized_Translation_PnL',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','NPV',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','SALES_NPV',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','FEES_UNSETTLED_SD',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','NPV_NET',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','CUMULATIVE_CASH_MARGIN',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_UNSETTLED_FEES',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH_MARGIN',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_CUMUL_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','REALIZED',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','CUMULATIVE_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','FEES_UNSETTLED_SD',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','TOTAL_INTEREST',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_UNSETTLED_FEES',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_CUMUL_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_TOTAL_INTEREST',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_REALIZED',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_BS',''
go
add_domain_values 'PricerMeasurePnlMMEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlMMEOD','NPV',''
go
add_domain_values 'PricerMeasurePnlMMEOD','CUMULATIVE_CASH_PRINCIPAL',''
go
add_domain_values 'PricerMeasurePnlMMEOD','ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlMMEOD','CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlMMEOD','UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlMMEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlMMEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlMMEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlMMEOD','FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlMMEOD','FEES_UNSETTLED_SD',''
go
add_domain_values 'PricerMeasurePnlMMEOD','NPV_NET',''
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_UNSETTLED_FEES',''
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_CUMUL_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_BS',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','NPV',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_PRINCIPAL',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_SL_FEE',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','INDEMNITY_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','FEES_UNSETTLED_SD',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','NPV_NET',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_UNSETTLED_FEES',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_CUMUL_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_BS',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_SL_FEE',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_INDEMNITY_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','CLEAN_REALIZED',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','NPV_DISC_WITH_COST',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','PREM_DISC',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','PREM_DISC_YIELD',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','REALIZED_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','TD_ACCRUAL_BS',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','TOTAL_PAYDOWN',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','TOTAL_PAYDOWN_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','CLEAN_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_BS',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_REALIZED',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_REALIZED_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_TD_ACCRUAL_BS',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_TOTAL_PAYDOWN',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_TOTAL_PAYDOWN_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlFXEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlFXEOD','NPV',''
go
add_domain_values 'PricerMeasurePnlFXEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlFXEOD','POSITION_CASH',''
go
add_domain_values 'PricerMeasurePnlFXEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','CUMULATIVE_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','FEES_UNSETTLED_SD',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','REALIZED',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_CUMUL_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_REALIZED',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_UNSETTLED_FEES',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlETOEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlETOEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlETOEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlETOEOD','FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlETOEOD','FEES_UNSETTLED_SD',''
go
add_domain_values 'PricerMeasurePnlETOEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlETOEOD','SETTLED_REALIZED',''
go
add_domain_values 'PricerMeasurePnlETOEOD','UNSETTLED_REALIZED',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_SETTLED_REALIZED',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_UNSETTLED_FEES',''
go
add_domain_values 'PricerMeasurePnlETOEOD','UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CONVERSION_FACTOR',''
go
add_domain_values 'PricerMeasurePnlAllEOD','ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlAllEOD','BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CLEAN_REALIZED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CUMULATIVE_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CUMULATIVE_CASH_PRINCIPAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CUMULATIVE_CASH_SL_FEE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','FEES_UNSETTLED_SD',''
go
add_domain_values 'PricerMeasurePnlAllEOD','INDEMNITY_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','NPV',''
go
add_domain_values 'PricerMeasurePnlAllEOD','NPV_DISC_WITH_COST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','POSITION_CASH',''
go
add_domain_values 'PricerMeasurePnlAllEOD','PREM_DISC',''
go
add_domain_values 'PricerMeasurePnlAllEOD','PREM_DISC_YIELD',''
go
add_domain_values 'PricerMeasurePnlAllEOD','REALIZED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','REALIZED_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','SETTLED_REALIZED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','TD_ACCRUAL_BS',''
go
add_domain_values 'PricerMeasurePnlAllEOD','TOTAL_PAYDOWN',''
go
add_domain_values 'PricerMeasurePnlAllEOD','TOTAL_PAYDOWN_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlAllEOD','UNSETTLED_REALIZED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CLEAN_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CUMULATIVE_CASH_MARGIN',''
go
add_domain_values 'PricerMeasurePnlAllEOD','FEES_NPV',''
go
add_domain_values 'PricerMeasurePnlAllEOD','FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_ACCRUAL_BO',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_BS',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMUL_CASH',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMUL_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMUL_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_MARGIN',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_SL_FEE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_INDEMNITY_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_REALIZED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_REALIZED_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_SETTLED_REALIZED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_TD_ACCRUAL_BS',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_TOTAL_INTEREST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_TOTAL_PAYDOWN',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_TOTAL_PAYDOWN_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_UNSETTLED_CASH',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_UNSETTLED_FEES',''
go
add_domain_values 'PricerMeasurePnlAllEOD','NPV_NET',''
go
add_domain_values 'PricerMeasurePnlAllEOD','SALES_NPV',''
go
add_domain_values 'PricerMeasurePnlAllEOD','TOTAL_INTEREST',''
go
add_domain_values 'plMeasure','Trade_Date_Cash_Unrealized_FX_Reval',''
go
add_domain_values 'plMeasure','SL_Fees_PnL',''
go
add_domain_values 'PNLTrader','Realized_Full_PnL',''
go
add_domain_values 'PNLTrader','Unrealized_Full_PnL',''
go
add_domain_values 'PNLTrader','Trade_Full_Base_PnL',''
go
add_domain_values 'PNLTrader','Trade_Translation_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','SL_Fees_PnL',''
go
add_domain_values 'PNLTradeDateCash','Trade_Date_Cash_Unrealized_FX_Reval',''
go
add_domain_values 'PricerMeasurePnlAllEOD','UNSETTLED_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlAllEOD','UNSETTLED_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','UNSETTLED_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlRepoEOD','UNSETTLED_CASH_INTEREST',''
go
add_domain_values 'measuresForAdjustment','BOOK_VALUE',''
go
add_domain_values 'measuresForAdjustment','CASH',''
go
add_domain_values 'measuresForAdjustment','CLEAN_BOOK_VALUE',''
go
add_domain_values 'measuresForAdjustment','CLEAN_REALIZED',''
go
add_domain_values 'measuresForAdjustment','CUMULATIVE_CASH_FEES',''
go
add_domain_values 'measuresForAdjustment','CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'measuresForAdjustment','CUMULATIVE_CASH_MARGIN',''
go
add_domain_values 'measuresForAdjustment','CUMULATIVE_CASH_PRINCIPAL',''
go
add_domain_values 'measuresForAdjustment','CUMULATIVE_CASH_SL_FEE',''
go
add_domain_values 'measuresForAdjustment','FEES_UNSETTLED',''
go
add_domain_values 'measuresForAdjustment','FEES_UNSETTLED_SD',''
go
add_domain_values 'measuresForAdjustment','HISTO_ACCRUAL_BO',''
go
add_domain_values 'measuresForAdjustment','HISTO_BS',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMULATIVE_CASH_MARGIN',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMULATIVE_CASH_SL_FEE',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMUL_CASH',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMUL_CASH_FEES',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMUL_CASH_INTEREST',''
go
add_domain_values 'measuresForAdjustment','HISTO_INDEMNITY_ACCRUAL',''
go
add_domain_values 'measuresForAdjustment','HISTO_PL_FUNDING_COST',''
go
add_domain_values 'measuresForAdjustment','HISTO_POS_CASH',''
go
add_domain_values 'measuresForAdjustment','HISTO_REALIZED',''
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlOTCEOD','OTC' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlEquitiesEOD','Equities' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlMMEOD','MM and Call Notice' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlRepoEOD','Repo' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlBondsEOD','Bonds' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlFXEOD','FX' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlFuturesEOD','Futures' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlETOEOD','ETO' 
go
add_domain_values 'NamesPricerMsrEOD','PricerMeasurePnlAllEOD','All Measures' 
go
add_domain_values 'PNLHighLevel','Unrealized_Full_PnL',''
go
add_domain_values 'PNLHighLevel','Realized_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Cash_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Fees_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Net_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Unsettled_Cash_FX_Reval',''
go
add_domain_values 'PNLWithDetails','Realized_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Accrual_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Accrued_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Cash_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Paydown_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Realized_Interests_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Sale_Realized_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Realized_Price_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Interests_Full',''
go
add_domain_values 'PNLWithDetails','BS_FX_Reval',''
go
add_domain_values 'PNLTradeDateCash','Trade_Date_Cash_FX_Reval',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Cash_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Fees_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Net_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unsettled_Cash_FX_Reval',''
go
add_domain_values 'PNLTradeDateCash','Realized_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Accrual_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Accrued_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Cash_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Paydown_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Realized_Interests_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Sale_Realized_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Realized_Price_Full_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Interests_Full',''
go
add_domain_values 'PNLTradeDateCash','Trade_Cash_FX_Reval',''
go
add_domain_values 'PNLMTMAndAccruals','Trade_Translation_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Trade_Full_Accrual_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Trade_Full_Base_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Unrealized_Full_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Realized_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Sales_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trader_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Sales_Unrealized_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trader_Unrealized_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Sales_Realized_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trader_Realized_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trade_Full_Base_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Sales_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trader_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Unrealized_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Sales_Unrealized_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trader_Unrealized_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Realized_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Sales_Realized_Full_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trader_Realized_Full_PnL',''
go
add_domain_values 'PNLTrader','Total_PnL',''
go
add_domain_values 'PNLTrader','Unrealized_PnL',''
go
add_domain_values 'PNLTrader','Realized_PnL',''
go
add_domain_values 'PNLHighLevel','Total_PnL',''
go
add_domain_values 'PNLHighLevel','Unrealized_PnL',''
go
add_domain_values 'PNLHighLevel','Realized_PnL',''
go
add_domain_values 'PNLHighLevel','Cost_Of_Carry_PnL',''
go
add_domain_values 'PNLHighLevel','Trade_Full_Base_PnL',''
go
add_domain_values 'PNLHighLevel','Trade_Translation_PnL',''
go
add_domain_values 'PNLWithDetails','Total_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Cash_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Fees_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Interests',''
go
add_domain_values 'PNLWithDetails','Unrealized_Net_PnL',''
go
add_domain_values 'PNLWithDetails','Accrual_PnL',''
go
add_domain_values 'PNLWithDetails','Accrued_PnL',''
go
add_domain_values 'PNLWithDetails','Realized_PnL',''
go
add_domain_values 'PNLWithDetails','Realized_Price_PnL',''
go
add_domain_values 'PNLWithDetails','Cash_PnL',''
go
add_domain_values 'PNLWithDetails','Paydown_PnL',''
go
add_domain_values 'PNLWithDetails','Realized_Interests_PnL',''
go
add_domain_values 'PNLWithDetails','Sale_Realized_PnL',''
go
add_domain_values 'PNLWithDetails','Cost_Of_Carry_PnL',''
go
add_domain_values 'PNLWithDetails','Cost_Of_Funding_PnL',''
go
add_domain_values 'PNLWithDetails','Trade_Full_Accrual_PnL',''
go
add_domain_values 'PNLWithDetails','Trade_Full_Base_PnL',''
go
add_domain_values 'PNLWithDetails','Unrealized_Translation_PnL',''
go
add_domain_values 'PNLWithDetails','Trade_Translation_PnL',''
go
add_domain_values 'PNLWithDetails','Funding_Cost_FX_Reval',''
go
add_domain_values 'PNLTradeDateCash','Total_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Cash_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Fees_PnL',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Interests',''
go
add_domain_values 'PNLTradeDateCash','Unrealized_Net_PnL',''
go
add_domain_values 'PNLTradeDateCash','Accrual_PnL',''
go
add_domain_values 'PNLTradeDateCash','Accrued_PnL',''
go
add_domain_values 'PNLTradeDateCash','Realized_PnL',''
go
add_domain_values 'PNLTradeDateCash','Realized_Price_PnL',''
go
add_domain_values 'PNLTradeDateCash','Cash_PnL',''
go
add_domain_values 'PNLTradeDateCash','Paydown_PnL',''
go
add_domain_values 'PNLTradeDateCash','Realized_Interests_PnL',''
go
add_domain_values 'PNLTradeDateCash','Sale_Realized_PnL',''
go
add_domain_values 'PNLTradeDateCash','Total_Accrual_PnL',''
go
add_domain_values 'PNLTradeDateCash','Cost_Of_Carry_PnL',''
go
add_domain_values 'PNLTradeDateCash','Cost_Of_Funding_PnL',''
go
add_domain_values 'PNLTradeDateCash','Funding_Cost_FX_Reval',''
go
add_domain_values 'PNLMTMAndAccruals','Total_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Unrealized_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Realized_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Total_Accrual_PnL',''
go
add_domain_values 'PNLMTMAndAccruals','Cost_Of_Carry_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Total_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Unrealized_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Realized_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Cost_Of_Carry_PnL',''
go
add_domain_values 'PNLSalesAndTraderPnL','Trade_Translation_PnL',''
go
add_domain_values 'PNLWithDetails','Total_Accrual_PnL',''
go
add_domain_values 'NamesForPNL','PNLHighLevel','Official PnL - high Level' 
go
add_domain_values 'NamesForPNL','PNLMTMAndAccruals','Official PnL - MTM and accruals' 
go
add_domain_values 'NamesForPNL','PNLTradeDateCash','Official PnL - trade date cash' 
go
add_domain_values 'NamesForPNL','PNLTrader','Trader PnL' 
go
add_domain_values 'NamesForPNL','PNLWithDetails','Official PnL - with details' 
go
add_domain_values 'NamesForPNL','PNLSalesAndTraderPnL','Official PnL - Sales and Trader PnL' 
go
add_domain_values 'domainName','VolatilityIndex.subtype','VolatilityIndex product subtypes' 
go
add_domain_values 'VolatilityIndex.subtype','Equity','VolatilityIndex based EquityIndex' 
go
add_domain_values 'VolatilityIndex.subtype','Commodity','VolatilityIndex based CommodityIndex' 
go
add_domain_values 'domainName','pricingScriptReportVariables',''
go
add_domain_values 'pricingScriptReportVariables','Knockouts.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables','Payments.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables','PeriodAccruals.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables','AccrualAbove',''
go
add_domain_values 'pricingScriptReportVariables','AccrualBelow',''
go
add_domain_values 'pricingScriptReportVariables','ForwardPrice',''
go
add_domain_values 'pricingScriptReportVariables','KnockOutBarrier',''
go
add_domain_values 'pricingScriptReportVariables','TarnCapped',''
go
add_domain_values 'pricingScriptReportVariables','TarnLevel',''
go
add_domain_values 'pricingScriptReportVariables','BarrierStrike',''
go
add_domain_values 'pricingScriptReportVariables','CouponRate',''
go
add_domain_values 'pricingScriptReportVariables','PaymentCurrency',''
go
add_domain_values 'pricingScriptReportVariables','ObservationDates.ReferenceDate',''
go
add_domain_values 'pricingScriptReportVariables','PaymentDates.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables','EarlyRedemption.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables','BarrierLevel',''
go
add_domain_values 'pricingScriptReportVariables','PayCurrency',''
go
add_domain_values 'pricingScriptReportVariables','Strike',''
go
add_domain_values 'pricingScriptReportVariables','AccrualDates.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables','Maturity.PaymentDate',''
go
add_domain_values 'pricingScriptReportVariables','CouponPeriods.AccrualPeriodArray',''
go
add_domain_values 'pricingScriptReportVariables','FixingDate',''
go
add_domain_values 'pricingScriptReportVariables','BarrierAbove',''
go
add_domain_values 'pricingScriptReportVariables','BarrierBelow',''
go
add_domain_values 'pricingScriptReportVariables','Notional',''
go
add_domain_values 'pricingScriptReportVariables','M	',''
go
add_domain_values 'pricingScriptReportVariables','CouponCurrency',''
go
add_domain_values 'pricingScriptReportVariables','FixedRate',''
go
add_domain_values 'pricingScriptReportVariables','PrincipalAmount',''
go
add_domain_values 'pricingScriptReportVariables','PrincipalCurrency',''
go
add_domain_values 'pricingScriptReportVariables','BarrierPrice',''
go
add_domain_values 'pricingScriptReportVariables','BonusReturn',''
go
add_domain_values 'pricingScriptReportVariables','KnockOutPrice',''
go
add_domain_values 'pricingScriptReportVariables','Performance',''
go
add_domain_values 'pricingScriptReportVariables','YearFrac',''
go
add_domain_values 'pricingScriptReportVariables','PaymentCcy',''
go
add_domain_values 'pricingScriptReportVariables','Factor',''
go
add_domain_values 'pricingScriptReportVariables','BaseCurrency',''
go
add_domain_values 'pricingScriptReportVariables','DaysInYear',''
go
add_domain_values 'pricingScriptReportVariables','VolatilityStrikePrice',''
go
add_domain_values 'pricingScriptReportVariables','AbovePerformance',''
go
add_domain_values 'pricingScriptReportVariables','BelowPerformance',''
go
add_domain_values 'pricingScriptReportVariables','Ccy',''
go
add_domain_values 'pricingScriptReportVariables','Basket',''
go
add_domain_values 'domainName','pricingScriptReportVariables.ReferenceDate',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','STARTDATE',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','ENDDATE',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','FREQUENCY',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','HOLIDAYS',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','DATEROLL',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','PERIODRULE',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','SPECIFYROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','ROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDate','INCLUDESTART',''
go
add_domain_values 'domainName','pricingScriptReportVariables.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','STARTDATE',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','ENDDATE',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','FREQUENCY',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','HOLIDAYS',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','DATEROLL',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','PERIODRULE',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','DATERULE',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','SPECIFYROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','ROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','PAYMENTLAG',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','RESETLAG',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','BUSDAYLAG',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','STUBRULE',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','ROUNDING',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDateArray','INCLUDESTART',''
go
add_domain_values 'domainName','pricingScriptReportVariables.PaymentDate',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDate','REFERENCEDATE',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDate','HOLIDAYS',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDate','DATEROLL',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDate','BUSDAYLAG',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDate','PAYMENTLAG',''
go
add_domain_values 'pricingScriptReportVariables.PaymentDate','RESETLAG',''
go
add_domain_values 'domainName','pricingScriptReportVariables.AccrualPeriodArray',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','STARTDATE',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','ENDDATE',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','FREQUENCY',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','HOLIDAYS',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','DATEROLL',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','PERIODRULE',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','DAYCOUNT',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','PAYMENTARREARS',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','RESETARREARS',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','SPECIFYROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','ROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','PAYMENTLAG',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','BUSDAYLAG',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','STUBRULE',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','FIRSTSTUBDATE',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','LASTSTUBDATE',''
go
add_domain_values 'pricingScriptReportVariables.AccrualPeriodArray','ROUNDING',''
go
add_domain_values 'function','PricingSheetUserPreferencesAccess','Give access to the User Preferences in Pricing Sheet' 
go
add_domain_values 'function','PricingSheetStrategyBuilderAccess','Give access to the Strategy Builder in Pricing Sheet' 
go
add_domain_values 'function','PricingSheetProfilePropertiesConfigAccess','Give access to the Configuration tab in the Profile Configuration window
for the subtabs Properties, Menu, Layout in Pricing Sheet' 
go
add_domain_values 'function','PricingSheetProfileUsersConfigAccess','Give access to the Configuration tab in the Profile Configuration window in Pricing Sheet' 
go
add_domain_values 'function','PricingSheetProfileAdminAccess','Give access to the whole Profile Configuration window in Pricing Sheet' 
go
add_domain_values 'PricingSheetMeasures','ACCRUAL' ,''
go
add_domain_values 'PricingSheetMeasures','ACCRUAL_FIRST' ,''
go
add_domain_values 'PricingSheetMeasures','ACCRUAL_PAYMENT' ,''
go
add_domain_values 'PricingSheetMeasures','ACCRUAL_PAYMENT_FIRST',''
go
add_domain_values 'PricingSheetMeasures','ACCUMULATED_ACCRUAL' ,''
go
add_domain_values 'PricingSheetMeasures','CASH' ,''
go
add_domain_values 'PricingSheetMeasures','DELTA_01',''
go
add_domain_values 'PricingSheetMeasures','NDELTA' ,''
go
add_domain_values 'PricingSheetMeasures','NGAMMA' ,''
go
add_domain_values 'PricingSheetMeasures','NVEGA' ,''
go
add_domain_values 'PricingSheetMeasures','PV01' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Reference' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Entity' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Market Data' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Pricer Data' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Dealt Data','' 
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Solver' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Detail 1' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Detail 2' ,''
go
add_domain_values 'PricingSheetPropertyDisplayGroups','Detail 3' ,''
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','BondStructuredNote.ANY.ANY','PricerBondStructuredNote' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','BondDanishMortgage.ANY.ANY','PricerBondDanishMortgage' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Bond.ANY.BondStructuredNote','PricerBondStructuredNote' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','EquityStructuredOption.ANY.Bermudan','PricerBlack1FFiniteDifference' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','EquityStructuredOption.ANY.ASIAN_BARRIER','PricerBlack1FMonteCarlo' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','EquityLinkedSwap.Amortizing_Swap.ANY','PricerAmortizingSwap' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SHARES_ACCRUED','tk.core.PricerMeasure',412,'Number of shares accrued in the current period. Generally relevant to physical settlement' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_QUANTITY','tk.pricer.PricerMeasureCAQuantity',413,'Cross Asset Quantity' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('B/E_Ratio','tk.core.PricerMeasure',415,'' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PA_YIELD','tk.core.PricerMeasure',416,'The equivalent yield for a PA paying instrument.' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_YIELD','tk.core.PricerMeasure',417,'The equivalent yield for a SA paying instrument.' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('IGNORE_FX_RESET','java.lang.Boolean','true,false','',1,'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('IGNORE_PRICE_FIXING','java.lang.Boolean','true,false','',1,'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('REGEN_MKTDATA_FOR_GREEKS','java.lang.Boolean','true,false','Use this parameter to re-generate market data items that depend on a shift in market data items used to compute numerical measures.  For example, re-generation of volatility surface in calculating Real Rho1/2 for FX options.',1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('VOL_SHIFT_UNDERLYINGS','java.lang.Boolean','true,false','FX/FXOption : Determines whether the surface are shifted by shifting underlyings',1,'VOL_SHIFT_UNDERLYINGS','false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('REPLICATION_STRIKE_SPREAD','java.lang.Double','','',1,'REPLICATION_STRIKE_SPREAD','0.000001' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('SUPPRESS_RISKY_CURVE','java.lang.Boolean','true,false','If true and applicable, suppress loading of risky curve.',1,'false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MARKDOWN_RECOVERY','java.lang.Double','','Lower recovery rate limit for a default',0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('FD_SCHEME','java.lang.String','Crank-Nicolson,Euler Implicit,Rannacher,TR-BDF2','Finite Differences scheme choice',1,'Rannacher' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, default_value ) VALUES ('NUMBER_OF_X_STEPS','java.lang.Integer','Number of steps in the asset price direction',1,'100' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('ACCRUAL_FROM_TD','java.lang.Boolean','true,false','Accrual starts from Trade Date','false',1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('USE_FICTIONAL_CASH','java.lang.Boolean','true,false','',1,'USE_FICTIONAL_CASH','false' )
go
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list ) VALUES ('FromBondProduct','int',0,1,0,'Bond' )
go
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list ) VALUES ('DMB Serie','string',1,1,0,'Bond' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTask','BillingEngine' )
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (601,1,'sched_task_attr','task_id','1','attr_value','sched_task_attr.attr_name IN (''SD_FILTER'', ''STATIC DATA FILTER'', ''TRANSFER_FILTER'', ''SD Filter'', ''Xfer SD Filter'', ''Msg SD Filter'')','ScheduledTask','apps.refdata.ScheduledTaskWindow','Scheduled Task - Attributes' )
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (602,2,'sched_task_attr','task_id','1','attr_value','sched_task_attr.attr_name IN (''OTC Trade Filter'')','ScheduledTask','apps.refdata.ScheduledTaskWindow','Scheduled Task - Attributes' )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (133,'HedgeAccounting',0,1,1 )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('bond_dm','Table for Product BondDanishMortgage' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('bond_struct_note','Table for Product BondStructuredNote' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('drawing_schedule','Drawing Schedule' )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES (1548,'PSEventTrade','TERMINATED','UNTERMINATE','VERIFIED',0,1,'EquityStructuredOption','ALL',0,0,0,'Used for reverting a CA',0,0,0,0,0,0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES (1549,'PSEventTrade','TERMINATED','REJECT','VERIFIED',0,1,'EquityStructuredOption','ALL',0,0,0,'Used for reverting a Termination',0,0,0,0,0,0 )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('010','Status','Opening Ledger' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('011','Status','Average Opening Ledger MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('012','Status','Average Opening Ledger YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('015','Status','Closing Ledger' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('020','Status','Average Closing Ledger MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('021','Status','Average Closing Ledger - Previous Month' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('022','Status','Aggregate Balance Adjustments' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('024','Status','Average Closing Ledger YTD - Previous Month' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('025','Status','Average Closing Ledger YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('030','Status','Current Ledger' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('037','Status','ACH Net Position' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('039','Status','Opening Available + Total Same-Day ACH DTC Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('040','Status','Opening Available' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('041','Status','Average Opening Available MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('042','Status','Average Opening Available YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('043','Status','Average Available - Previous Month' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('044','Status','Disbursing Opening Available Balance' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('045','Status','Closing Available' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('050','Status','Average Closing Available MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('051','Status','Average Closing Available - Last Month' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('054','Status','Average Closing Available YTD - Last Month' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('055','Status','Average Closing Available YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('056','Status','Loan Balance' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('057','Status','Total Investment Position' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('059','Status','Current Available (CRS Suppressed)' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('060','Status','Current Available' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('061','Status','Average Current Available MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('062','Status','Average Current Available YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('063','Status','Total Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('065','Status','Target Balance' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('066','Status','Adjusted Balance' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('067','Status','Adjusted Balance MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('068','Status','Adjusted Balance YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('070','Status','0-Day Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('072','Status','1-Day Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('073','Status','Float Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('074','Status','2 or More Days Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('075','Status','3 or More Days Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('076','Status','Adjustment to Balances' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('077','Status','Average Adjustment to Balances MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('078','Status','Average Adjustment to Balances YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('079','Status','4-Day Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('080','Status','5-Day Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('081','Status','6-Day Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('082','Status','Average 1-Day Float MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('083','Status','Average 1-Day Float YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('084','Status','Average 2-Day Float MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('085','Status','Average 2-Day Float YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('086','Status','Transfer Calculation' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('100','CR','Summary','Total Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('101','CR','Summary','Total Credit Amount MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('105','CR','Summary','Credits Not Detailed' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('106','CR','Summary','Deposits Subject to Float' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('107','CR','Summary','Total Adjustment Credits YTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('108','CR','Detail','Credit (Any Type)' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('109','CR','Summary','Current Day Total Lockbox Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('110','CR','Summary','Total Lockbox Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('115','CR','Detail','Lockbox Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('116','CR','Detail','Item in Lockbox Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('118','CR','Detail','Lockbox Adjustment Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('120','CR','Summary','EDI* Transaction Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('121','CR','Detail','EDI Transaction Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('122','CR','Detail','EDIBANX Credit Received' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('123','CR','Detail','EDIBANX Credit Return' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('130','CR','Summary','Total Concentration Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('131','CR','Summary','Total DTC Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('135','CR','Detail','DTC Concentration Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('136','CR','Detail','Item in DTC Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('140','CR','Summary','Total ACH Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('142','CR','Detail','ACH Credit Received' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('143','CR','Detail','Item in ACH Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('145','CR','Detail','ACH Concentration Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('146','CR','Summary','Total Bank Card Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('147','CR','Detail','Individual Bank Card Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('150','CR','Summary','Total Preauthorized Payment Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('155','CR','Detail','Preauthorized Draft Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('156','CR','Detail','Item in PAC Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('160','CR','Summary','Total ACH Disbursing Funding Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('162','CR','Summary','Corporate Trade Payment Settlement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('163','CR','Summary','Corporate Trade Payment Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('164','CR','Detail','Corporate Trade Payment Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('165','CR','Detail','Preauthorized ACH Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('166','CR','Detail','ACH Settlement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('167','CR','Summary','ACH Settlement Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('168','CR','Detail','ACH Return Item or Adjustment Settlement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('169','CR','Detail','Miscellaneous ACH Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('170','CR','Summary','Total Other Check Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('171','CR','Detail','Individual Loan Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('172','CR','Detail','Deposit Correction' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('173','CR','Detail','Bank-Prepared Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('174','CR','Detail','Other Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('175','CR','Detail','Check Deposit Package' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('176','CR','Detail','Re-presented Check Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('178','CR','Summary','List Post Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('180','CR','Summary','Total Loan Proceeds' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('182','CR','Summary','Total Bank-Prepared Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('184','CR','Detail','Draft Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('185','CR','Summary','Total Miscellaneous Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('186','CR','Summary','Total Cash Letter Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('187','CR','Detail','Cash Letter Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('188','CR','Summary','Total Cash Letter Adjustments' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('189','CR','Detail','Cash Letter Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('190','CR','Summary','Total Incoming Money Transfers' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('191','CR','Detail','Individual Incoming Internal Money Transfer' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('195','CR','Detail','Incoming Money Transfer' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('196','CR','Detail','Money Transfer Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('198','CR','Detail','Compensation' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('200','CR','Summary','Total Automatic Transfer Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('201','CR','Detail','Individual Automatic Transfer Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('202','CR','Detail','Bond Operations Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('205','CR','Summary','Total Book Transfer Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('206','CR','Detail','Book Transfer Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('207','CR','Summary','Total International Money Transfer Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('208','CR','Detail','Individual International Money Transfer Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('210','CR','Summary','Total International Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('212','CR','Detail','Foreign Letter of Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('213','CR','Detail','Letter of Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('214','CR','Detail','Foreign Exchange of Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('215','CR','Summary','Total Letters of Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('216','CR','Detail','Foreign Remittance Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('218','CR','Detail','Foreign Collection Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('221','CR','Detail','Foreign Check Purchase' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('222','CR','Detail','Foreign Checks Deposited' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('224','CR','Detail','Commission' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('226','CR','Detail','International Money Market Trading' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('227','CR','Detail','Standing Order' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('229','CR','Detail','Miscellaneous International Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('230','CR','Summary','Total Security Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('231','CR','Summary','Total Collection Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('232','CR','Detail','Sale of Debt Security' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('233','CR','Detail','Securities Sold' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('234','CR','Detail','Sale of Equity Security' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('235','CR','Detail','Matured Reverse Repurchase Order' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('236','CR','Detail','Maturity of Debt Security' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('237','CR','Detail','Individual Collection Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('238','CR','Detail','Collection of Dividends' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('239','CR','Summary','Total Bankers? Acceptance Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('240','CR','Detail','Coupon Collections - Banks' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('241','CR','Detail','Bankers? Acceptances' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('242','CR','Detail','Collection of Interest Income' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('243','CR','Detail','Matured Fed Funds Purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('244','CR','Detail','Interest/Matured Principal Payment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('245','CR','Summary','Monthly Dividends' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('246','CR','Detail','Commercial Paper' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('247','CR','Detail','Capital Change' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('248','CR','Detail','Savings Bonds Sales Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('249','CR','Detail','Miscellaneous Security Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('250','CR','Summary','Total Checks Posted and Returned' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('251','CR','Summary','Total Debit Reversals' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('252','CR','Detail','Debit Reversal' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('254','CR','Detail','Posting Error Correction Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('255','CR','Detail','Check Posted and Returned' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('256','CR','Summary','Total ACH Return Items' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('257','CR','Detail','Individual ACH Return Item' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('258','CR','Detail','ACH Reversal Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('260','CR','Summary','Total Rejected Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('261','CR','Detail','Individual Rejected Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('263','CR','Detail','Overdraft' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('266','CR','Detail','Return Item' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('268','CR','Detail','Return Item Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('270','CR','Summary','Total ZBA Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('271','CR','Summary','Net Zero-Balance Amount' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('274','CR','Detail','Cumulative** ZBA or Disbursement Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('275','CR','Detail','ZBA Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('276','CR','Detail','ZBA Float Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('277','CR','Detail','ZBA Credit Transfer' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('278','CR','Detail','ZBA Credit Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('280','CR','Summary','Total Controlled Disbursing Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('281','CR','Detail','Individual Controlled Disbursing Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('285','CR','Summary','Total DTC Disbursing Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('286','CR','Detail','Individual DTC Disbursing Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('294','CR','Summary','Total ATM Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('295','CR','Detail','ATM Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('301','CR','Detail','Commercial Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('302','CR','Summary','Correspondent Bank Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('303','CR','Summary','Total Wire Transfers In - FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('304','CR','Summary','Total Wire Transfers In - CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('305','CR','Summary','Total Fed Funds Sold' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('306','CR','Detail','Fed Funds Sold' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('307','CR','Summary','Total Trust Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('308','CR','Detail','Trust Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('309','CR','Summary','Total Value - Dated Funds' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('310','CR','Summary','Total Commercial Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('315','CR','Summary','Total International Credits – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('316','CR','Summary','Total International Credits – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('318','CR','Summary','Total Foreign Check Purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('319','CR','Summary','Late Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('320','CR','Summary','Total Securities Sold – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('321','CR','Summary','Total Securities Sold – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('324','CR','Summary','Total Securities Matured – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('325','CR','Summary','Total Securities Matured – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('326','CR','Summary','Total Securities Interest' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('327','CR','Summary','Total Securities Matured' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('328','CR','Summary','Total Securities Interest – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('329','CR','Summary','Total Securities Interest – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('330','CR','Summary','Total Escrow Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('331','CR','Detail','Individual Escrow Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('332','CR','Summary','Total Miscellaneous Securities Credits – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('336','CR','Summary','Total Miscellaneous Securities Credits – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('338','CR','Summary','Total Securities Sold' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('340','CR','Summary','Total Broker Deposits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('341','CR','Summary','Total Broker Deposits – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('342','CR','Detail','Broker Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('343','CR','Summary','Total Broker Deposits – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('344','CR','Detail','Individual Back Value Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('345','CR','Detail','Item in Brokers Deposit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('346','CR','Detail','Sweep Interest Income' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('347','CR','Detail','Sweep Principal Sell' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('348','CR','Detail','Futures Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('349','CR','Detail','Principal Payments Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('350','CR','Summary','Investment Sold' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('351','CR','Detail','Individual Investment Sold' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('352','CR','Summary','Total Cash Center Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('353','CR','Detail','Cash Center Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('354','CR','Detail','Interest Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('355','CR','Summary','Investment Interest' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('356','CR','Summary','Total Credit Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('357','CR','Detail','Credit Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('358','CR','Detail','YTD Adjustment Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('359','CR','Detail','Interest Adjustment Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('360','CR','Summary','Total Credits Less Wire Transfer and Returned Checks' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('361','CR','Summary','Grand Total Credits Less Grand Total Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('362','CR','Detail','Correspondent Collection' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('363','CR','Detail','Correspondent Collection Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('364','CR','Detail','Loan Participation' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('366','CR','Detail','Currency and Coin Deposited' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('367','CR','Detail','Food Stamp Letter' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('368','CR','Detail','Food Stamp Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('369','CR','Detail','Clearing Settlement Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('370','CR','Summary','Total Back Value Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('372','CR','Detail','Back Value Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('373','CR','Detail','Customer Payroll' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('374','CR','Detail','FRB Statement Recap' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('376','CR','Detail','Savings Bond Letter or Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('377','CR','Detail','Treasury Tax and Loan Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('378','CR','Detail','Transfer of Treasury Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('379','CR','Detail','FRB Government Checks Cash Letter Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('381','CR','Detail','FRB Government Check Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('382','CR','Detail','FRB Postal Money Order Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('383','CR','Detail','FRB Postal Money Order Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('384','CR','Detail','FRB Cash Letter Auto Charge Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('385','CR','Summary','Total Universal Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('386','CR','Detail','FRB Cash Letter Auto Charge Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('387','CR','Detail','FRB Fine-Sort Cash Letter Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('388','CR','Detail','FRB Fine-Sort Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('389','CR','Summary','Total Freight Payment Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('390','CR','Summary','Total Miscellaneous Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('391','CR','Detail','Universal Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('392','CR','Detail','Freight Payment Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('393','CR','Detail','Itemized Credit Over $10,000' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('394','CR','Detail','Cumulative** Credits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('395','CR','Detail','Check Reversal' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('397','CR','Detail','Float Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('398','CR','Detail','Miscellaneous Fee Refund' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('399','CR','Detail','Miscellaneous Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('400','DB','Summary','Total Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('401','DB','Summary','Total Debit Amount MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('403','DB','Summary','Today?s Total Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('405','DB','Summary','Total Debit Less Wire Transfers and Charge- Backs' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('406','DB','Summary','Debits not Detailed' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('408','DB','Detail','Float Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('409','DB','Detail','Debit (Any Type)' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('410','DB','Summary','Total YTD Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('412','DB','Summary','Total Debits (Excluding Returned Items)' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('415','DB','Detail','Lockbox Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('416','DB','Summary','Total Lockbox Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('420','DB','Summary','EDI Transaction Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('421','DB','Detail','EDI Transaction Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('422','DB','Detail','EDIBANX Settlement Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('423','DB','Detail','EDIBANX Return Item Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('430','DB','Summary','Total Payable-Through Drafts' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('435','DB','Detail','Payable-Through Draft' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('445','DB','Detail','ACH Concentration Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('446','DB','Summary','Total ACH Disbursement Funding Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('447','DB','Detail','ACH Disbursement Funding Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('450','DB','Summary','Total ACH Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('451','DB','Detail','ACH Debit Received' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('452','DB','Detail','Item in ACH Disbursement or Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('455','DB','Detail','Preauthorized ACH Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('462','DB','Detail','Account Holder Initiated ACH Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('463','DB','Summary','Corporate Trade Payment Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('464','DB','Detail','Corporate Trade Payment Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('465','DB','Summary','Corporate Trade Payment Settlement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('466','DB','Detail','ACH Settlement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('467','DB','Summary','ACH Settlement Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('468','DB','Detail','ACH Return Item or Adjustment Settlement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('469','DB','Detail','Miscellaneous ACH Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('470','DB','Summary','Total Check Paid' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('471','DB','Summary','Total Check Paid - Cumulative MTD' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('472','DB','Detail','Cumulative** Checks Paid' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('474','DB','Detail','Certified Check Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('475','DB','Detail','Check Paid' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('476','DB','Detail','Federal Reserve Bank Letter Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('477','DB','Detail','Bank Originated Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('478','DB','Summary','List Post Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('479','DB','Detail','List Post Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('480','DB','Summary','Total Loan Payments' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('481','DB','Detail','Individual Loan Payment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('482','DB','Summary','Total Bank-Originated Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('484','DB','Detail','Draft' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('485','DB','Detail','DTC Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('486','DB','Summary','Total Cash Letter Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('487','DB','Detail','Cash Letter Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('489','DB','Detail','Cash Letter Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('490','DB','Summary','Total Outgoing Money Transfers' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('491','DB','Detail','Individual Outgoing Internal Money Transfer' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('493','DB','Detail','Customer Terminal Initiated Money Transfer' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('495','DB','Detail','Outgoing Money Transfer' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('496','DB','Detail','Money Transfer Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('498','DB','Detail','Compensation' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('500','DB','Summary','Total Automatic Transfer Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('501','DB','Detail','Individual Automatic Transfer Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('502','DB','Detail','Bond Operations Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('505','DB','Summary','Total Book Transfer Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('506','DB','Detail','Book Transfer Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('507','DB','Summary','Total International Money Transfer Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('508','DB','Detail','Individual International Money Transfer Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('510','DB','Summary','Total International Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('512','DB','Detail','Letter of Credit Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('513','DB','Detail','Letter of Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('514','DB','Detail','Foreign Exchange Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('515','DB','Summary','Total Letters of Credit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('516','DB','Detail','Foreign Remittance Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('518','DB','Detail','Foreign Collection Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('522','DB','Detail','Foreign Checks Paid' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('524','DB','Detail','Commission' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('526','DB','Detail','International Money Market Trading' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('527','DB','Detail','Standing Order' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('529','DB','Detail','Miscellaneous International Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('530','DB','Summary','Total Security Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('531','DB','Detail','Securities Purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('532','DB','Summary','Total Amount of Securities Purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('533','DB','Detail','Security Collection Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('534','DB','Summary','Total Miscellaneous Securities DB - FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('535','DB','Detail','Purchase of Equity Securities' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('536','DB','Summary','Total Miscellaneous Securities Debit - CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('537','DB','Summary','Total Collection Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('538','DB','Detail','Matured Repurchase Order' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('539','DB','Summary','Total Bankers? Acceptances Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('540','DB','Detail','Coupon Collection Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('541','DB','Detail','Bankers? Acceptances' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('542','DB','Detail','Purchase of Debt Securities' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('543','DB','Detail','Domestic Collection' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('544','DB','Detail','Interest/Matured Principal Payment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('546','DB','Detail','Commercial paper' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('547','DB','Detail','Capital Change' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('548','DB','Detail','Savings Bonds Sales Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('549','DB','Detail','Miscellaneous Security Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('550','DB','Summary','Total Deposited Items Returned' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('551','DB','Summary','Total Credit Reversals' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('552','DB','Detail','Credit Reversal' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('554','DB','Detail','Posting Error Correction Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('555','DB','Detail','Deposited Item Returned' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('556','DB','Summary','Total ACH Return Items' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('557','DB','Detail','Individual ACH Return Item' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('558','DB','Detail','ACH Reversal Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('560','DB','Summary','Total Rejected Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('561','DB','Detail','Individual Rejected Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('563','DB','Detail','Overdraft' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('564','DB','Detail','Overdraft Fee' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('566','DB','Detail','Return Item' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('567','DB','Detail','Return Item Fee' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('568','DB','Detail','Return Item Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('570','DB','Summary','Total ZBA Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('574','DB','Detail','Cumulative ZBA Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('575','DB','Detail','ZBA Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('577','DB','Detail','ZBA Debit Transfer' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('578','DB','Detail','ZBA Debit Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('580','DB','Summary','Total Controlled Disbursing Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('581','DB','Detail','Individual Controlled Disbursing Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('583','DB','Summary','Total Disbursing Checks Paid - Early Amount' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('584','DB','Summary','Total Disbursing Checks Paid - Later Amount' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('585','DB','Summary','Disbursing Funding Requirement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('586','DB','Summary','FRB Presentment Estimate (Fed Estimate)' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('587','DB','Summary','Late Debits (After Notification)' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('588','DB','Summary','Total Disbursing Checks Paid-Last Amount' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('590','DB','Summary','Total DTC Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('594','DB','Summary','Total ATM Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('595','DB','Detail','ATM Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('596','DB','Summary','Total APR Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('597','DB','Detail','ARP Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('601','DB','Summary','Estimated Total Disbursement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('602','DB','Summary','Adjusted Total Disbursement' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('610','DB','Summary','Total Funds Required' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('611','DB','Summary','Total Wire Transfers Out- CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('612','DB','Summary','Total Wire Transfers Out – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('613','DB','Summary','Total International Debit – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('614','DB','Summary','Total International Debit – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('615','DB','Summary','Total Federal Reserve Bank – Commercial Bank Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('616','DB','Detail','Federal Reserve Bank – Commercial Bank Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('617','DB','Summary','Total Securities Purchased – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('618','DB','Summary','Total Securities Purchased – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('621','DB','Summary','Total Broker Debits – CHF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('622','DB','Detail','Broker Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('623','DB','Summary','Total Broker Debits – FF' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('625','DB','Summary','Total Broker Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('626','DB','Summary','Total Fed Funds Purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('627','DB','Detail','Fed Funds Purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('628','DB','Summary','Total Cash Center Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('629','DB','Detail','Cash Center Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('630','DB','Summary','Total Debit Adjustments' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('631','DB','Detail','Debit Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('632','DB','Summary','Total Trust Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('633','DB','Detail','Trust Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('634','DB','Detail','YTD Adjustment Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('640','DB','Summary','Total Escrow Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('641','DB','Detail','Individual Escrow Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('644','DB','Detail','Individual Back Value Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('646','DB','Summary','Transfer Calculation Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('650','DB','Summary','Investments Purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('651','DB','Detail','Individual Investment purchased' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('654','DB','Detail','Interest Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('655','DB','Summary','Total Investment Interest Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('656','DB','Detail','Sweep Principal Buy' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('657','DB','Detail','Futures Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('658','DB','Detail','Principal Payments Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('659','DB','Detail','Interest Adjustment Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('661','DB','Detail','Account Analysis Fee' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('662','DB','Detail','Correspondent Collection Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('663','DB','Detail','Correspondent Collection Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('664','DB','Detail','Loan Participation' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('665','DB','Summary','Intercept Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('666','DB','Detail','Currency and Coin Shipped' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('667','DB','Detail','Food Stamp Letter' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('668','DB','Detail','Food Stamp Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('669','DB','Detail','Clearing Settlement Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('670','DB','Summary','Total Back Value Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('672','DB','Detail','Back Value Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('673','DB','Detail','Customer Payroll' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('674','DB','Detail','FRB Statement Recap' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('676','DB','Detail','Savings Bond Letter or Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('677','DB','Detail','Treasury Tax and Loan Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('678','DB','Detail','Transfer of Treasury Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('679','DB','Detail','FRB Government Checks Cash Letter Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('681','DB','Detail','FRB Government Check Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('682','DB','Detail','FRB Postal Money Order Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('683','DB','Detail','FRB Postal Money Order Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('684','DB','Detail','FRB Cash Letter Auto Charge Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('685','DB','Summary','Total Universal Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('686','DB','Detail','FRB Cash Letter Auto Charge Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('687','DB','Detail','FRB Fine-Sort Cash Letter Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('688','DB','Detail','FRB Fine-Sort Adjustment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('689','DB','Summary','FRB Freight Payment Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('690','DB','Summary','Total Miscellaneous Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('691','DB','Detail','Universal Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('692','DB','Detail','Freight Payment Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('693','DB','Detail','Itemized Debit Over $10,000' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('694','DB','Detail','Deposit Reversal' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('695','DB','Detail','Deposit Correction Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('696','DB','Detail','Regular Collection Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('697','DB','Detail','Cumulative** Debits' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('698','DB','Detail','Miscellaneous Fees' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('699','DB','Detail','Miscellaneous Debit' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('701','Status','Principal Loan Balance' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('703','Status','Available Commitment Amount' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('705','Status','Payment Amount Due' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('707','Status','Principal Amount Past Due' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('709','Status','Interest Amount Past Due' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('720','CR','Summary','Total Loan Payment' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('721','CR','Detail','Amount Applied to Interest' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('722','CR','Detail','Amount Applied to Principal' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('723','CR','Detail','Amount Applied to Escrow' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('724','CR','Detail','Amount Applied to Late Charges' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('725','CR','Detail','Amount Applied to Buydown' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('726','CR','Detail','Amount Applied to Misc. Fees' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('727','CR','Detail','Amount Applied to Deferred Interest Detail' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('728','CR','Detail','Amount Applied to Service Charge' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('760','DB','Summary','Loan Disbursement' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('890','Detail','Contains Non-monetary Information' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('900','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('901','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('902','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('903','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('904','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('905','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('906','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('907','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('908','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('909','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('910','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('911','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('912','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('913','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('914','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('915','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('916','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('917','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('918','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('919','Status','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('920','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('921','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('922','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('923','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('924','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('925','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('926','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('927','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('928','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('929','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('930','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('931','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('932','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('933','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('934','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('935','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('936','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('937','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('938','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('939','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('940','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('941','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('942','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('943','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('944','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('945','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('946','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('947','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('948','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('949','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('950','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('951','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('952','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('953','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('954','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('955','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('956','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('957','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('958','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('959','CR','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('960','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('961','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('962','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('963','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('964','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('965','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('966','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('967','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('968','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('969','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('970','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('971','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('972','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('973','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('974','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('975','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('976','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('977','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('978','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('979','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('980','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('981','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('982','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('983','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('984','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('985','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('986','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('987','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('988','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('989','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('990','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('991','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('992','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('993','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('994','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('995','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('996','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('997','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('998','DB','User Defined' )
go
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('999','DB','User Defined' )
go
insert into domain_values (name, value, description) values ('function','AuthorizeConfirmMessage','Access permission to authorize a Trade Confirmation')
go
/* end */

update calypso_seed set seed_alloc_size=500 where seed_alloc_size <=1
go


update an_param_items
set attribute_value = 'Volatility Strike' where attribute_value in
(select attribute_value from an_param_items (parallel 5) where attribute_value = 'Instrument Strike' and  param_name in(
select param_name from an_param_items (parallel 5) where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam')
)
go

update an_param_items set attribute_value = 'Volatility Tenor' where attribute_value in( select attribute_value from an_param_items 
where attribute_value = 'Instrument Tenor' and param_name in
(select param_name from an_param_items (parallel 5) where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
go

update an_param_items set attribute_value = 'Volatility Expiry Date' where attribute_value in(
select attribute_value from an_param_items (parallel 5) where attribute_value = 'Instrument Expiry Date'
and param_name in
(select param_name from an_param_items (parallel 5) where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
go

update an_param_items set attribute_value = 'Volatility Expiry Tenor' where attribute_value in
(select attribute_value from an_param_items (parallel 5) where attribute_value = 'Instrument Expiry Tenor'
and param_name in ( select param_name from an_param_items (parallel 5) where attribute_name = 'MktType' 
and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
go

update an_param_items set attribute_value = 'Volatility Strike Type' where attribute_value in
(select attribute_value from an_param_items (parallel 5) where attribute_value = 'Instrument Strike Type'
and param_name in ( select param_name from an_param_items (parallel 5)
where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
go
if exists (Select 1 from sysobjects where name ='mainent' and type='P')
begin
exec ('drop proc mainent_cs')
end
go

create procedure mainent_cs as
begin
declare
  c1 cursor for  SELECT property_name, user_name, property_value
        FROM main_entry_prop
       WHERE property_value = 'risk.RiskLauncherWindowShahinTest'
	   
/*    v_menu_id VARCHAR(16);
    v_username VARCHAR(255);
*/ 
   
OPEN c1
declare  @v_menu_id VARCHAR(16)
declare @v_username VARCHAR(255)
declare   @prefix_code varchar(16)
declare   @sql varchar(512)
declare   @prop_value varchar(256)
declare   @x varchar(256)
declare   @str1 varchar(256)
declare   @str2 varchar(256)
declare   @str3 varchar(256)
declare   @start_pos int
declare   @n int
declare   @user_name varchar(255)
declare   @property_name varchar(255)
declare   @property_value varchar(255)

fetch c1 into @property_name, @user_name, @prop_value
WHILE (@@sqlstatus = 0)

begin
    select @v_menu_id = substring(@property_name,3,charindex('Action',@property_name)-3) 
    select @v_username = @user_name
	      delete from main_entry_prop WHERE user_name = @v_username AND (
              @property_name = 'ti'+@v_menu_id+'Image' OR
              @property_name = 'ti'+ @v_menu_id+'Label'  OR
              @property_name = 'ti'+@v_menu_id+'Action' OR
              @property_name = 'ti'+@v_menu_id+'Tooltip' OR
              @property_name = 'ti'+@v_menu_id+'Mnemonic' OR
              @property_name = 'ti'+@v_menu_id+'Accelerator')
 
    /*  -- update the menus refering to this item, this could be in 4 places covered in the cases below */
     /* these can look like _tiXXX, could be at the middle */
      UPDATE main_entry_prop set property_value = str_replace(@property_value, ' ti' + @v_menu_id + ' ', ' ') WHERE user_name = @v_username AND property_value like '% ti' + @v_menu_id + ' %'
     /* -- or in the beginning */
      UPDATE main_entry_prop set property_value = str_replace(@property_value, 'ti' + @v_menu_id + ' ', '') WHERE user_name = @v_username AND property_value like 'ti' + @v_menu_id + ' %'
      /*-- or at the end */
      UPDATE main_entry_prop set property_value = str_replace(@property_value, ' ti' + @v_menu_id, '') WHERE user_name = @v_username AND property_value like '% ti' + @v_menu_id
      /*-- or the only entry */
      UPDATE main_entry_prop set property_value = str_replace(@property_value, 'ti' + @v_menu_id, '') WHERE user_name = @v_username AND property_value = 'ti' + @v_menu_id
	  
    fetch c1 into @property_name, @user_name, @prop_value  
end
close c1
deallocate cursor c1
end
go
exec mainent_cs
go
drop procedure mainent_cs
go

update report_template set private_b=1
where template_id not in
(
select template_id from report_template rt, entity_attributes ea
where rt.template_id = ea.entity_id
and rt.report_type='RiskAggregation'
and ea.entity_type='ReportTemplate'
and ea.attr_name ='IsDrillDownTemplate'
and ea.attr_value='true'
)
and report_type='RiskAggregation'
and is_hidden=1
go


/* CAL-121475 */
if not exists (select 1 from sysobjects where name like 'psheet_pricer_measure_prop')
begin
exec ('create table psheet_pricer_measure_prop (user_name varchar(64) not null,
        name varchar(128) not null ,
        is_display numeric not null,
        display_currency  varchar(512) null,
        display_color varchar(52) not null,
        property_order numeric not null)')
end
go
UPDATE psheet_pricer_measure_prop SET display_currency = ' '
go

DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'Fader'
go

DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'European Range Binary'
go

DELETE FROM domain_values WHERE name = 'plMeasure' AND value IN (
'Full_Base_PnL',
'Intraday_Accrual_Full_PnL',
'Intraday_Cash_Full_PnL',
'Intraday_Cost_Of_Funding_FX_Reval',
'Intraday_Cost_Of_Funding_PnL',
'Intraday_Full_Base_PnL',
'Intraday_Realized_Full_PnL',
'Intraday_Trade_Cash_FX_Reval',
'Intraday_Trade_Full_Base_PnL',
'Intraday_Trade_Translation_PnL',
'Intraday_Translation_PnL',
'Intraday_Unrealized_Full_PnL',
'Accretion_PnL_Base',
'Accrual_PnL_Base',
'Accrued_PnL_Base',
'Cash_PnL_Base',
'Cost_Of_Carry_Base_PnL',
'Paydown_PnL_Base',
'Realized_Interests_PnL_Base',
'Realized_PnL_Base',
'Sale_Realized_PnL_Base',
'Settlement_Date_PnL_Base',
'Total_Accrual_PnL_Base',
'Unrealized_Cash_PnL_Base',
'Unrealized_Fees_PnL_Base',
'Unrealized_Interests_Base',
'Unrealized_Net_PnL_Base',
'Unrealized_PnL_Base',
'Cost_Of_Funding_Full_PnL',
'Unrealized_FX_Base'
)
go

/* CAL-122902 */

create index trade_date_idx on bo_transfer(trade_date)
go

 
/* CAL-123378 */
UPDATE entity_attributes SET attr_value = 'MarketIndex' WHERE entity_type = 'Fund' AND attr_name = 'Benchmark_Type' AND attr_value = 'Market_Index' 
go
UPDATE entity_attributes SET  attr_value = 'RateIndex' WHERE entity_type = 'Fund' AND attr_name = 'Benchmark_Type' AND attr_value = 'Rate_Index'
go

/* CAL-125732  */
delete from domain_values where value ='HISTO_CUMULATIVE_CASH_INTEREST'
go

/* CAL-124201  */


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
end
go

if exists (select 1 from sysobjects where name ='product_structured_flows' and name='product_cash_flow_leg')
begin
exec ('insert into product_structured_flows select * from product_cash_flow_leg')
exec ('sp_rename "product_cash_flow_leg","prod_cash_flow_leg_bak"')
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

add_domain_values 'domainName','autoFeedInternalRefTerminationType',''
go
add_domain_values 'autoFeedInternalRefTerminationType','Novation',''
go
add_domain_values 'domainName','autoFeedExternalRefTerminationType',''
go
add_domain_values 'autoFeedExternalRefTerminationType','Novation',''
go
add_domain_values 'domainName','StructuredFlows.subtype','Types of StructuredFlows' 
go
add_domain_values 'productType','StructuredFlows',''
go
add_domain_values 'productTypeReportStyle','StructuredFlows','StructuredFlows ReportStyle' 
go
add_domain_values 'domainName','StructuredFlows.Pricer','Pricers for StructuredFlows' 
go
add_domain_values 'StructuredFlows.Pricer','PricerStructuredFlows',''
go
add_domain_values 'measuresForAdjustment','TD_ACCRUAL_BS',''
go
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (50,1,'hedge_relationship_config','hedge_relationship_config_id','1','hedged_sd_filter','HedgeRelationshipConfig','apps.refdata.HedgeRelationshipConfigWindow','Hedge Relationship Configuration' )
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
add_domain_values 'domainName','autoFeedInternalRefTerminationType',''
go
add_domain_values 'autoFeedInternalRefTerminationType','Novation',''
go
add_domain_values 'domainName','autoFeedExternalRefTerminationType',''
go
add_domain_values 'autoFeedExternalRefTerminationType','Novation',''
go
add_domain_values 'domainName','StructuredFlows.subtype','Types of StructuredFlows' 
go
add_domain_values 'productType','StructuredFlows',''
go
add_domain_values 'productTypeReportStyle','StructuredFlows','StructuredFlows ReportStyle' 
go
add_domain_values 'domainName','StructuredFlows.Pricer','Pricers for StructuredFlows' 
go
add_domain_values 'StructuredFlows.Pricer','PricerStructuredFlows',''
go
add_domain_values 'measuresForAdjustment','TD_ACCRUAL_BS',''
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
update group_access set access_id = access_id - 1 where access_id >  41 
go

/* end */
/*  Update Version */
UPDATE calypso_info
    SET major_version=12,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date='20110428'
go
