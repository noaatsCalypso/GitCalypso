
/* CAL-77180, CAL-77172 ADR Window out of date - returning ADR to Equity table*/
DECLARE l_exists INTEGER := 0;
BEGIN
	SELECT count(cname) INTO l_exists FROM col WHERE tname = 'PRODUCT_ADR' and cname = 'EQUITY_NAME';
	IF l_exists = 1 THEN
	BEGIN
	  /* take care of divdend info first, not stored in product_equity table but in dividend_calc_info table */
	  INSERT INTO dividend_calc_info (product_id, dividend_type, b_cumulative, rate_index, rate_index_spread, fixed_rate, frequency, currency, date_roll, ex_dividend_days,  day_count, rolling_day, dividend_decimals, rounding_method, payment_lag, business_b, holidays, payment_rule, date_rule, index_factor, reset_days, resetlag_bus_b, reset_decimals, reset_rounding_method, reset_holidays, record_days, record_days_b, ex_dividend_days_b, stub_start_date, stub_end_date)
	  SELECT product_id, 'FIXED_RATE', 0, null, 0, 0, dividend_frequency, dividend_currency, 'NO_CHANGE', 0, '30/360', 0, dividend_decimals, 'NEAREST', 2, 0, null, 'ADJUSTED', 0, 0, 0, 0, 0, 'NEAREST', null, 0, 0, 0, null, null
		FROM product_adr
	   WHERE product_adr.pay_dividend = 1
		 AND product_id NOT IN (SELECT DISTINCT product_id FROM dividend_calc_info);
	
	  /* move then to product_equity what should have been persisted in product_equity */
	  INSERT INTO product_equity (product_id, equity_name, corporate, country, currency, exchange_code, total_issued,  pay_dividend, entered_date, entered_user, comments, trading_size, active_date, inactive_date, sub_type, quote_type,nominal_decimals, equity_status)
	  SELECT product_id, equity_name, null, country,currency, exchange_code, total_issued, pay_dividend, entered_date,entered_user, comments,trading_size, null, inactive_date, sub_type, 'Price', 0, null
		FROM product_adr
	   WHERE product_id NOT IN (SELECT DISTINCT product_id FROM product_equity);
	   
	  /* product_adr.issuer_id col is not necessary as product_desc.issuer_id exists */
      UPDATE /*+ parallel( product_desc ) */ product_desc SET product_desc.issuer_id = (SELECT product_adr.issuer_id FROM product_adr WHERE product_desc.product_id = product_adr.product_id)
	   WHERE EXISTS (SELECT 1 FROM product_adr WHERE product_desc.product_id = product_adr.product_id);
	END;	
	END IF;
END;
;

 


 
/* CAL-82966, CAL-83377 removing dividend_calc_info table which is not used */
/* restoring data belonging to product_equity table */ 

DECLARE l_exists INTEGER := 0; BEGIN
   SELECT count(tname) INTO l_exists FROM tab WHERE tname = 'DIVIDEND_CALC_INFO';
   IF l_exists = 1 THEN
   BEGIN
     UPDATE /*+ parallel( product_equity ) */ product_equity SET product_equity.dividend_currency = (SELECT dividend_calc_info.currency FROM dividend_calc_info WHERE product_equity.product_id = dividend_calc_info.product_id),
                 product_equity.dividend_frequency = (SELECT dividend_calc_info.frequency FROM dividend_calc_info WHERE product_equity.product_id = dividend_calc_info.product_id),
                 product_equity.dividend_date_rule = (SELECT dividend_calc_info.date_rule FROM dividend_calc_info WHERE product_equity.product_id = dividend_calc_info.product_id),
                 product_equity.dividend_decimals = (SELECT dividend_calc_info.dividend_decimals FROM dividend_calc_info WHERE product_equity.product_id = dividend_calc_info.product_id)
     WHERE EXISTS (SELECT 1 FROM dividend_calc_info WHERE product_equity.product_id = dividend_calc_info.product_id);
   END;
   END IF;
END;
;

update /*+ parallel( report_win_def ) */ report_win_def set use_pricing_env=1 where def_name = 'CompositeAnalysis'
;
/*
* BEGIN CAL-70866 - refactor of commodity cash flow generation
*/
 


/*
* start and end date on the commodity leg
* fixing dates on the parameters
*/
begin
  add_column_if_not_exists('commodity_leg2', 'security_comm_reset_id', 'number null');
  add_column_if_not_exists('commodity_leg2','start_date','timestamp null');
  add_column_if_not_exists('commodity_leg2','end_date','timestamp null');
  add_column_if_not_exists('cf_sch_gen_params','fixing_start_lag','number default 0 not null');
  add_column_if_not_exists('cf_sch_gen_params','param_type', 'varchar2(16) default ''COMMODITY'' not null');
  add_column_if_not_exists('cf_sch_gen_params','fixing_end_lag', 'number default 0 not null');
end;
;
DECLARE
    index_name varchar(50);
	idxCount int;
	sqlStr varchar(1000);
BEGIN

	 select count(*)
	 into   idxCount
	 from 	user_constraints     c,
		  	user_indexes		  idx,
			user_ind_columns	  idx_cols
	 where 	c.constraint_type = 'P'
	 and 	 c.table_name = 'CF_SCH_GEN_PARAMS'
     and		 c.table_name = idx.table_name
	 and	  	 idx.table_name = idx_cols.table_name	
	 and		 idx_cols.column_name = 'PARAM_TYPE';
	 
	 IF (idxCount = 0) THEN
	 	 select distinct idx.index_name
		 into 	index_name
		 from 	 user_constraints     c,
		 		 user_indexes		  idx,
		 		 user_ind_columns	  idx_cols
		 where 	 c.constraint_type = 'P'
		 and 	 c.table_name = 'CF_SCH_GEN_PARAMS'
		 and		 c.table_name = idx.table_name
		 and	  	 idx.table_name = idx_cols.table_name;
		 
         sqlStr := 'ALTER TABLE CF_SCH_GEN_PARAMS DROP CONSTRAINT ' || index_name || ' CASCADE DROP INDEX';
         dbms_output.put_line(sqlStr); 
	   EXECUTE IMMEDIATE sqlStr;
		 
         sqlStr := 'ALTER TABLE CF_SCH_GEN_PARAMS ADD CONSTRAINT ' || index_name || ' PRIMARY KEY ( product_id, leg_id, param_type )';
         dbms_output.put_line(sqlStr); 
         EXECUTE IMMEDIATE sqlStr;
	 END IF;
END;
;

/*
*  copy trading dates to the leg
*/
begin
add_column_if_not_exists('prod_comm_fwd','comm_leg_id','number null');
end;
/
update /*+ parallel( commodity_leg2 ) */ commodity_leg2 leg
set    (security_comm_reset_id, start_date, end_date, strike_price_unit) = 
	   (
	      select comm_reset_id, start_date, maturity_date, payment_price_unit
		  from	 prod_comm_fwd fwd
		  where	 fwd.comm_leg_id = leg.leg_id
	   ) 
where  start_date is null
and	exists (	select 	1
			from 		prod_comm_fwd fwd
			where		fwd.comm_leg_id = leg.leg_id
		)
;

/*
*  populate the fixing lags
*/
DECLARE
	   CURSOR p_cursor IS
	   		  select param.start_date 		  param_start_date,
					 param.end_date	  		  param_end_date,
					 leg.start_date	  		  leg_start_date,
					 leg.end_date	  		  leg_end_date,
					 param.fixing_calendar	  param_fixing_cal,
					 fwd.fixing_holidays	  fwd_fixing_hol,
					 param.fixing_start_lag, 
			  		 param.fixing_end_lag,					 
					 fwd.payment_holidays 	  fwd_payment_hol,
					 fwd.payment_offset	      fwd_payment_lag,
					 fwd.payment_dateroll     fwd_dateroll,
					 fwd.payment_day	      fwd_payment_day,
					 fwd.payment_offset_bus_b			  fwd_offset_bus,
					 fwd.fx_reset_id	  fwd_fx_reset_id
              from   cf_sch_gen_params param,
       		  		 commodity_leg2 leg,
	   		 		 prod_comm_fwd fwd
	  		  where  leg.leg_id = param.leg_id
	   		  and	 fwd.comm_leg_id = leg.leg_id
	   		  and	 param.start_date is not null
	   		  and	 leg.start_date is not null
	   		  and  	 leg.end_date is not null
			  and 	 param.param_type = 'COMMODITY'
			  for update of fixing_start_lag, 
			  	  		 	fixing_end_lag, 
							param.fixing_calendar,
					 		param.payment_calendar,
					 		param.payment_lag,
					 		param.payment_date_roll,
					 		param.payment_day,
					 		param.payment_offset_bus_b,
							param.fx_reset_id;
    rowdata	  	  		 p_cursor%ROWTYPE;
	start_lag 			  int;
	end_lag				  int;
BEGIN
	 OPEN p_cursor;
	 
	 LOOP
	 	   FETCH p_cursor INTO rowdata; 
		   EXIT WHEN p_cursor%NOTFOUND;
		   start_lag := trunc(rowdata.param_start_date) - trunc(rowdata.leg_start_date);
		   end_lag := trunc(rowdata.leg_end_date) - trunc(nvl(rowdata.param_end_date, rowdata.param_start_date));
		   
		   update  cf_sch_gen_params
		   set	  fixing_start_lag = start_lag,
		   		  fixing_end_lag = end_lag,
				  fixing_calendar = rowdata.fwd_fixing_hol,
				  payment_calendar = rowdata.fwd_payment_hol,
			      payment_lag = rowdata.fwd_payment_lag,
				  payment_date_roll = rowdata.fwd_dateroll,
				  payment_day = rowdata.fwd_payment_day,
				  payment_offset_bus_b = nvl(rowdata.fwd_offset_bus, 0),
				  fx_reset_id = rowdata.fwd_fx_reset_id
		   where current of p_cursor;
		   
	 	   dbms_output.put_line('leg start=' || rowdata.leg_start_date ||', lag=' || start_lag || ', end lag=' || end_lag);
	 END LOOP;
	 
	 CLOSE p_cursor;
END;
;

/*
* add new parameters security 
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
and	not exists ( 	select 1
			from   	cf_sch_gen_params sec_params
			where  	sec_params.leg_id = fwd.comm_leg_id
			and	sec_params.product_id = fwd.product_id
			and	sec_params.param_type = 'SECURITY')
;
/*
* END CAL-70866 - refactor of commodity cash flow generation
*/
DECLARE
	   CURSOR c_swap_dates IS
	   	   select 	leg.leg_id, 
	   	   			leg.start_date 	  leg_start_date,
					param.start_date    param_start_date,
					leg.end_date 	  leg_end_date,
					param.end_date	  param_end_date
		   from		commodity_leg2 leg,
					cf_sch_gen_params  param
		   where exists (
		   		 		 select 1
						 from	product_commodity_swap2	swap
       	   				 where	(swap.pay_leg_id = leg.leg_id
						 		or	   swap.receive_leg_id = leg.leg_id)
		   		 		)					
           and	    leg.leg_id = param.leg_id
		   and		leg.start_date is null
	   	   for update of  leg.start_date, leg.end_date;
	   
	   rowdata	  c_swap_dates%ROWTYPE;
BEGIN
	 OPEN c_swap_dates;
	 
	 LOOP
	 	 FETCH c_swap_dates INTO rowdata;
		 EXIT WHEN c_swap_dates%NOTFOUND;
		 
		 dbms_output.put_line('leg id=' || rowdata.leg_id || ', start/end date to [' || rowdata.param_start_date || '/' || rowdata.param_end_date);		 
		 update	   commodity_leg2
		 set	   start_date = rowdata.param_start_date,
		 		   end_date = rowdata.param_end_date
         where current of c_swap_dates;
	 
	 END LOOP;
	 
	 CLOSE c_swap_dates;
END;
;

DECLARE
	   CURSOR c_otc_dates IS
	   	   select 	leg.leg_id, 
	   	   			leg.start_date 	  leg_start_date,
					param.start_date    param_start_date,
					leg.end_date 	  leg_end_date,
					param.end_date	  param_end_date
		   from		commodity_leg2 leg,
					cf_sch_gen_params  param
		   where exists (
		   		 		 select 1
						 from	product_commodity_otcoption2	otc
       	   				 where	otc.leg_id = leg.leg_id
		   		 		)					
           and	    leg.leg_id = param.leg_id
		   and		leg.start_date is null
	   	   for update of  leg.start_date, leg.end_date;
	   
	   rowdata	  c_otc_dates%ROWTYPE;
BEGIN
	 OPEN c_otc_dates;
	 
	 LOOP
	 	 FETCH c_otc_dates INTO rowdata;
		 EXIT WHEN c_otc_dates%NOTFOUND;
		 
		 dbms_output.put_line('leg id=' || rowdata.leg_id || ', start/end date to [' || rowdata.param_start_date || '/' || rowdata.param_end_date);		 
		 update	   commodity_leg2
		 set	   start_date = rowdata.param_start_date,
		 		   end_date = rowdata.param_end_date
         where current of c_otc_dates;
	 
	 END LOOP;
	 
	 CLOSE c_otc_dates;
END;
;

DECLARE
	CURSOR c_leg_type IS
		select  fwd.product_id, leg.leg_id, leg.leg_type
		from	prod_comm_fwd fwd,
			commodity_leg2	leg
		where	fwd.comm_leg_id = leg.leg_id
		and	leg.leg_type in (0, 1)
		for update of leg.leg_type;

	rowdata	c_leg_type%ROWTYPE;
	legValue commodity_leg2.leg_id%TYPE;	
BEGIN
	OPEN c_leg_type;

	LOOP
		FETCH c_leg_type INTO rowdata;
		EXIT WHEN c_leg_type%NOTFOUND;

		select decode(rowdata.leg_type, 0, 2,
						1, 3,
						-1)
		into legValue
		from dual;

		dbms_output.put_line('fwd id=' || rowdata.product_id || ', leg_id=' || rowdata.leg_id || 'changing leg_type [' || rowdata.leg_type || '] to [' || legValue || ']');

		update 	/*+ parallel( commodity_leg2 ) */ commodity_leg2
		set	leg_type = legValue
         	where 	current of c_leg_type;

	END LOOP;

	CLOSE c_leg_type;
END;
;

/* CAL-84756 */
update
(select c.CURVE_GENERATOR generator 
from CURVE c, CURVE_DIV_HDR cd 
where c.CURVE_TYPE = 'CurveDividend' AND 
c.CURVE_GENERATOR is null AND 
c.CURVE_ID = cd.CURVE_ID AND 
c.CURVE_DATE = cd.CURVE_DATE AND 
cd.DIVIDEND_TYPE='Discrete' )
set generator = 'DividendDiscrete'
;

update /*+ parallel( position_spec ) */ position_spec
set source = 'Risk and PL'
where source = 'Liquidation Engine'
;
update /*+ parallel( position_spec ) */ position_spec
set source = 'Spot Blotter'
where source = 'Settle Positions'
;
update /*+ parallel(position_spec ) */ position_spec
set source = 'Liquidity'
where source = 'Product Positions'
;
update /*+ parallel( pricing_param_name ) */ pricing_param_name set param_domain='Crank-Nicolson,Euler Implicit,Lawson-Morris,Rannacher,Runge-Kutta Implicit' where param_name = 'FD_SCHEME' 
;

update /*+ parallel( trd_win_cl_config ) */ trd_win_cl_config set class_name = 'dealStation.DealStation$FX' where product_type like 'FX%' AND class_name like 'className%'
;
update /*+ parallel( trd_win_cl_config ) */ trd_win_cl_config set class_name = 'dealStation.DealStation$MM' where product_type = 'Cash' AND class_name like 'className%'
; 

/* CAL-90759 Upgrade script to replace the 6 month Equivalent objectives to Harmonized Risk/Cash Objective*/
DECLARE
	CURSOR c_param_name IS
		select distinct param_name
		from	an_param_items
		where attribute_value like '%SixMonthEquivalent%';

	rowdata	c_param_name%ROWTYPE;
BEGIN
	OPEN c_param_name;

	LOOP
		FETCH c_param_name INTO rowdata;
		EXIT WHEN c_param_name%NOTFOUND;
			
		update an_param_items set attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveHarmonizedRisk'
		where attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveSixMonthEquivalentRisk' and param_name = rowdata.param_name;

		update an_param_items set attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveHarmonizedCash'
		where attribute_value = 'com.calypso.tk.risk.forwardladder.objective.ForwardLadderObjectiveSixMonthEquivalentCash' and param_name = rowdata.param_name;

                delete from an_param_items where param_name = rowdata.param_name and attribute_name = 'Harmonized_Bucket';                
		insert into an_param_items(param_name,class_name,attribute_name,attribute_value) 
		values (rowdata.param_name,'com.calypso.tk.risk.ForwardLadderParam','Harmonized_Bucket','182.5');

	END LOOP;

	CLOSE c_param_name;
END;
;

delete from ps_event_config where engine_name='HedgeRelationshipEngine'
and not exists ( select * from engine_config where engine_config.engine_name = 'HedgeRelationshipEngine' )
;

update domain_values outer
set name = 'CommodityLocation'
where name = 'CommodityStorageLocation'
and not exists
(
select 1
from domain_values inner
where inner.name = 'CommodityLocation'
and inner.value = outer.value
)
;

insert into delivery_set(set_id , name,currency)select product_id set_id, name, currency from product_basket where basket_type='FutureDeliverySet'
;

insert into delivery_set_futures  select product_id set_id, comp_prod_id future_id from basket_comp where product_id in (select product_id from product_basket where basket_type='FutureDeliverySet')
;
delete from basket_comp where product_id in (select product_id from product_basket where basket_type='FutureDeliverySet')
;
delete from product_basket where basket_type='FutureDeliverySet'
;

DELETE FROM rating_values WHERE rating_type = 'Current' AND order_id = 0 AND agency_name = 'Collateral' AND rating_value = 'Regular'
;
delete from rating_values where rating_type = 'Current' and order_id = 0 AND agency_name = 'Collateral' AND rating_value = 'Whole Loan'
;
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 0, 'Collateral', 'Whole Loan')
;
delete from rating_values where rating_type = 'Current' and order_id = 1 AND agency_name = 'Collateral' AND rating_value = 'SBC-Agency'
;
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 1, 'Collateral', 'SBC-Agency')
;
delete from rating_values where rating_type = 'Current' and order_id = 2 AND agency_name = 'Collateral' AND rating_value = 'SBC-AAA'
;
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 2, 'Collateral', 'SBC-AAA')
;
delete from rating_values where rating_type = 'Current' and order_id = 3 AND agency_name = 'Collateral' AND rating_value = 'SBC-AA'
;
INSERT INTO rating_values(rating_type, order_id, agency_name, rating_value) VALUES ('Current', 3, 'Collateral', 'SBC-AA')
;
delete from domain_values where name = 'ratingAgency' and value = 'Collateral' AND description = 'Collateral value used for Advance and AdvanceLetterCredit products'
;
INSERT INTO domain_values(name, value, description) VALUES ('ratingAgency', 'Collateral', 'Collateral value used for Advance and AdvanceLetterCredit products')
;

DELETE FROM referring_object where rfg_obj_id IN (601,602)
;


/* CAL-101234 */

DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ACTUAL-SETTLE'
;
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ACTUAL-TRADE'
;
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-FAILED-TRADE'
;
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-FAILED-SETTLE'
;
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-THEORETICAL-SETTLE'
;
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-THEORETICAL-TRADE'
;
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ROLLED_INTEREST-SETTLE'
;
DELETE FROM domain_values where name='InventoryPositions' AND value='MARGIN_CALL-ROLLED_INTEREST-TRADE'
;

begin
add_column_if_not_exists('product_swap','opt_expiry_hol', 'varchar2(128) null');
add_column_if_not_exists('product_swaption','opt_expiry_hol','varchar2(128) null');
end;
;

UPDATE /*+ parallel( product_swap ) */ product_swap SET opt_expiry_hol = opt_cal_hol
;
UPDATE /*+ parallel( product_swaption ) */ product_swaption SET opt_expiry_hol = opt_cal_hol
;
 

UPDATE  /*+ parallel( report_win_def ) */  report_win_def SET use_pricing_env=1 WHERE def_name='Account'
;


/* CAL-104839 */

insert into domain_values (name , value, description) values ('domainName','UnitizedFund.subtype','Types of Unitized Fund')
;
insert into domain_values (name , value, description) values ('UnitizedFund.subtype','Fixed Income','Fixed Income')
;
insert into domain_values (name , value, description) values ('UnitizedFund.subtype','Equity','Equity')
;
insert into domain_values (name , value, description) values ('UnitizedFund.subtype','Money Market','Money Market')
;
insert into domain_values (name , value, description) values ('UnitizedFund.subtype','Commodity','Commodity')
;
insert into domain_values (name , value, description) values ('UnitizedFund.subtype','FX','FX')
;
insert into domain_values (name , value, description) values ('UnitizedFund.subtype','Mixed','Mixed')
;
/* end */ 

UPDATE /*+ parallel( cu_swap ) */  cu_swap SET fixed_currency = substr(rate_index,1,3) WHERE fixed_currency is NULL
;


/* CAL-106419 */
begin
add_column_if_not_exists('cu_basis_swap','base_cmp_method', 'varchar(32) null');
add_column_if_not_exists('cu_basis_swap','basis_cmp_method','varchar(32) null');
end;
;
UPDATE /*+ parallel( cu_basis_swap ) */ cu_basis_swap SET base_cmp_method = 'NoCompound' WHERE base_compound_b = 0
;
UPDATE /*+ parallel( cu_basis_swap ) */ cu_basis_swap SET basis_cmp_method = 'NoCompound' WHERE basis_compound_b = 0
;
/*  CAL-106419 */
UPDATE /*+ parallel( cu_basis_swap ) */ cu_basis_swap SET base_cmp_method = 'Spread' WHERE base_cmp_spread_b = 1 AND base_compound_b = 1 AND base_cmp_method IS NULL
;
UPDATE /*+ parallel( cu_basis_swap ) */ cu_basis_swap SET basis_cmp_method = 'Spread' WHERE basis_cmp_spread_b = 1 AND basis_compound_b = 1 AND basis_cmp_method IS NULL
;
UPDATE /*+ parallel( cu_basis_swap ) */ cu_basis_swap SET base_cmp_method = 'NoSpread' WHERE base_cmp_spread_b = 0 AND base_compound_b = 1 AND base_cmp_method IS NULL
;
UPDATE /*+ parallel( cu_basis_swap ) */ cu_basis_swap SET basis_cmp_method = 'NoSpread' WHERE basis_cmp_spread_b = 0 AND basis_compound_b = 1 AND basis_cmp_method IS NULL
; 

/* end */


/* CAL-108747   this would be done by executeSQL, but for really large DBs we need to do it in parallel */

/* removed for now as it causes a problem */

/* end */
/* CAL-108748 */

DECLARE v_nullable varchar2(1);
begin
select nullable into v_nullable from user_tab_cols where table_name='BO_MESSAGE' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+ parallel (bo_message) */ bo_message set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_MESSAGE MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_MESSAGE_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+ parallel( bo_message_hist) */ bo_message_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_MESSAGE_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_TRANSFER' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel  (bo_transfer)  */ bo_transfer set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_TRANSFER MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_TRANSFER_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+parallel(bo_transfer_hist)*/ bo_transfer_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_TRANSFER_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_POSTING' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+ parallel (bo_posting) */ bo_posting set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_POSTING MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_POSTING_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+ parallel (bo_posting_hist) */ bo_posting_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_POSTING_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_CRE' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+ parallel (bo_cre) */ bo_cre set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_CRE MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_CRE_HIST' and column_name = 'VERSION_NUM';
if v_nullable = 'Y' then
  BEGIN
  update /*+ parallel (bo_cre_hist)  */ bo_cre_hist set version_num = 0 where version_num is null;
  execute immediate 'ALTER TABLE BO_CRE_HIST MODIFY VERSION_NUM NOT NULL ' ;
  END;
end if;

select nullable into v_nullable from user_tab_cols where table_name='BO_TASK_HIST' and column_name = 'TASK_VERSION';
if v_nullable = 'Y' then
  BEGIN
  update  /*+ PARALLEL (  bo_task_hist  )  */  bo_task_hist set task_version = 0 where task_version is null;
  execute immediate 'ALTER TABLE BO_TASK_HIST MODIFY TASK_VERSION NOT NULL ' ;
  END;
end if;
end;
; 

/* CAL-108250 */

insert into mrgcall_template_ids (SELECT mc.mrg_call_def, t.template_id, 0 FROM report_template t, report_browser_tree_node tn, mrgcall_config mc WHERE t.template_name = tn.report_template_name and t.report_type=tn.report_template_type and mc.rept_browser_config_id =  tn.rept_browser_config_id)
;
/* end */

/* CAL-109653 */
 
 
/* end */
update /*+ PARALLEL (  comp_config  )  */ comp_config set is_editable = 1
;
/* CAL-110899 */
delete from domain_values where name = 'PositionBasedProducts' and value = 'CommoditySwap2'
;
/* end */
/* CAL-111354 */
UPDATE  /*+ PARALLEL (  trade_keyword  )  */  trade_keyword
   SET keyword_value='Y' WHERE keyword_value LIKE 'true'
   AND keyword_name IN ('TerminationPayIntFlow', 'TransferPayIntFlow', 'TerminationFullFirstCalculationPeriod', 'TerminationPrincipalExchange')
;

UPDATE  /*+ PARALLEL (  trade_keyword  )  */  trade_keyword
   SET keyword_value='N' WHERE keyword_value LIKE 'false'
   AND keyword_name IN ('TerminationPayIntFlow', 'TransferPayIntFlow', 'TerminationFullFirstCalculationPeriod', 'TerminationPrincipalExchange')
;
/* end */
 

/* CAL-95160 */

begin
  add_column_if_not_exists('trade','archive_date','timestamp');
end;
;

begin
  add_column_if_not_exists('trade_hist','archive_date','timestamp');
end;
;

/* set the archive date for some frequent product types
   (SQL is faster than the Java migration code)
  For equity, it can run in <1.5h for 274m trades */
  
update  /*+ PARALLEL (  trade  )  */ trade set archive_date = settlement_date
where archive_date is null and product_id in  
   (select product_id from product_desc 
    where product_type in ('Equity'))
;

update  /*+ PARALLEL (  trade  )  */ trade set archive_date = settlement_date
where archive_date is null and product_id in  
   (select product_id from product_desc 
    where product_type 
in ('FX', 'FXForward', 'FXTTM', 'FXSpotReserve'))
;


update /*+ PARALLEL (  trade  )  */ trade t set archive_date = (select p.forward_date
from product_fx_swap p
where t.product_id = p.product_id)
where archive_date is null
and exists (select 1
from product_fx_swap p
where t.product_id = p.product_id)
;

/* end */        

/* CAL-110908 */
begin
  add_column_if_not_exists('product_market_index','quote_type','varchar2(64)');
end;
;
INSERT INTO product_market_index (product_id,name,currency,market_place_id,issuer_id,issue_pay_agent_id,country,publish_holiday,publish_frequency,publish_dayofweek,publish_date_rule,publish_time,publish_timezone,basket_id,index_type,external_ref,description,quote_type)
SELECT product_equity_idx.product_id,product_equity_idx.name,product_equity_idx.currency,product_equity_idx.market_place_id,product_equity_idx.issuer_id,product_equity_idx.issue_pay_agent_id,product_equity_idx.country,product_equity_idx.publish_holiday,product_equity_idx.publish_frequency,product_equity_idx.publish_dayofweek,product_equity_idx.publish_date_rule,product_equity_idx.publish_time,product_equity_idx.publish_timezone,product_equity_idx.basket_id,product_equity_idx.index_type,product_equity_idx.external_ref,product_equity_idx.description,product_equity_idx.quote_type
FROM product_equity_idx
WHERE product_equity_idx.product_id not in (select product_id from product_market_index)
;

/* CAL-111784 */
insert into domain_values(name,value,description)
values ('scheduledTask','EOD_CAPLMARKING_OLD',null)
;

insert into domain_values(name,value,description)
values ('scheduledTask','EOD_SYSTEM_PLMARKING_OLD',null)
;

delete from domain_values where value in('EOD_PLMARKING_FULL','EOD_SYSTEM_PLMARKING')
;

update /*+ PARALLEL (  SCHED_TASK  )  */  SCHED_TASK 
set task_type = 'EOD_CAPLMARKING'
where task_type = 'EOD_PLMARKING_FULL'
;
/*end*/

/* CAL-103670 */
 

begin
  add_column_if_not_exists('cash_settle_dflt','currency_code2', 'varchar(4) default ''NONE'' not null');
  add_column_if_not_exists('cash_settle_dflt','rate_index_code2','varchar(32) default ''NONE'' not null');
end;
;

update /*+ PARALLEL (  cash_settle_dflt  )  */ cash_settle_dflt set currency_code2='NONE' where currency_code2 is null
;

update /*+ PARALLEL (  cash_settle_dflt  )  */  cash_settle_dflt set rate_index_code2='NONE' where rate_index_code2 is null
;

/* CAL-98976 */

INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataUsage', 'TIME_HORIZON_FUNDING', 'Zero curves for calculating funding cost in horizon simulation')
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'horizonFundingPolicy', 'List of funding policy names used in horizon simulation')
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'horizonFundingPolicy', 'Daily', 'Daily funding policy used in horizon simulation')
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'horizonFundingPolicy', 'Horizon', 'Horizon funding policy used in horizon simulation')
;
/* end */ 

update /*+ PARALLEL (  swap_leg  )  */ swap_leg set compound_freq_style='Original' where compound_freq='NON' and compound_freq_style='Regular' and product_id in (select product_id from product_desc where product_type= 'EquityLinkedSwap')
;

/* CAL-110908 */
 
INSERT INTO basket_info (product_id, basket_id, effective_date)
SELECT product_id, basket_id, TO_DATE('01/01/1970', 'DD/MM/RRRR')
FROM product_market_index
WHERE basket_id <>0
;
update product_market_index set basket_id = 0
;
INSERT INTO basket_info (product_id, basket_id, effective_date)
SELECT product_id, basket_id, TO_DATE('01/01/1970', 'DD/MM/RRRR')
FROM product_equity_idx
WHERE basket_id <>0
;
update /*+ PARALLEL (  product_equity_idx  )  */  product_equity_idx set basket_id = 0
;
UPDATE domain_values SET value='DisableCheckLERelation' WHERE name='function' AND value='DesableCheckLERelation'
;
UPDATE group_access SET access_value='DisableCheckLERelation' WHERE access_value='DesableCheckLERelation'
;


/* CAL-60273: adding column book_id to tables BO_MESSAGE and BO_MESSAGE_HIST */

create index awo1 on bo_transfer(transfer_id, book_id) parallel nologging
;

begin
  add_column_if_not_exists ('bo_transfer', 'book_id', 'number null');
  add_column_if_not_exists ('bo_transfer_hist', 'book_id', 'number null');
 
end;
/

UPDATE  /*+ PARALLEL (  bo_message  )  */ bo_message SET book_id = (select book_id from bo_transfer WHERE bo_transfer.transfer_id = bo_message.transfer_id AND bo_transfer.book_id is not null) WHERE book_id = 0 AND transfer_id != 0
;
UPDATE  /*+ PARALLEL (  bo_message  )  */  bo_message SET book_id = (select book_id from trade WHERE trade.trade_id = bo_message.trade_id AND trade.book_id is not null) WHERE book_id = 0 AND transfer_id = 0 AND trade_id != 0
; 
UPDATE  /*+ PARALLEL (  bo_message_hist  )  */  bo_message_hist SET book_id = (select book_id from bo_transfer_hist WHERE bo_transfer_hist.transfer_id = bo_message_hist.transfer_id AND bo_transfer_hist.book_id is not null) WHERE book_id = 0 AND transfer_id != 0
;
UPDATE  /*+ PARALLEL (  BO_MESSAGE_HIST  )  */  BO_MESSAGE_HIST SET book_id = (select book_id from trade_hist WHERE trade_hist.trade_id = bo_message_hist.trade_id AND trade_hist.book_id is not null) WHERE book_id = 0 AND transfer_id = 0 AND trade_id != 0
;
drop index awo1
;

/* CAL-114862 */
create table pl_mark_value_tmp as select pl_mark_value.* from pl_mark, pl_mark_value, pl_position
where pl_mark.trade_id = pl_position.position_id
and pl_mark_value.mark_id = pl_mark.mark_id
and pl_mark_value.mark_name in ('NPV', 'NPV_NET')
;
update /*+ PARALLEL (  pl_mark_value_tmp  )  */ pl_mark_value_tmp set mark_name='NPV_WITH_COST' where mark_name='NPV'
;
update /*+ PARALLEL (  pl_mark_value_tmp  )  */ pl_mark_value_tmp set mark_name='NPV_NET_WITH_COST' where mark_name='NPV_NET'
;
insert into pl_mark_value select * from pl_mark_value_tmp
;
drop table pl_mark_value_tmp
;
/* end  */ 

/* CAL-111601 */
DELETE FROM market_data_item mdi WHERE mdata_type = 'HyperSurfaceImpl' AND NOT EXISTS 
(SELECT * FROM hs_header WHERE mdi.mdata_name = hs_header.name) 
;
/* end */

create table fee_grid_bak as select * from fee_grid
;
CREATE OR REPLACE PROCEDURE add_feegridprod_if_not_exist (tab_name IN varchar2)
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER(tab_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        execute immediate 'create table '|| tab_name ||'(
                        fee_grid_id number not null,
		product_sequence number not null,
		 product_name  varchar2(255) null)';
   END IF;
END;
;

begin
  add_feegridprod_if_not_exist('fee_grid_product');
end;
;	


create or replace procedure reparse_table
is 
begin
declare 
cursor c1 is 
select fee_grid_id, product_list from fee_grid where product_list is NOT NULL and product_list != 'NONE';
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(255);
      parse_out_val  varchar2(255);
      prd_seq number;
	  myid number;
	  
begin 
open c1; 
fetch c1 into myid , parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		prd_seq := 0;
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  prd_seq := 1;
			 insert into fee_grid_product (fee_grid_id,product_sequence,product_name) values (myid,prd_seq,parseval);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  prd_seq := prd_seq + 1;
			  insert into fee_grid_product (Fee_grid_id,product_sequence,product_name) values (myid,prd_seq,parse_out_val);
			  parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  prd_seq:= prd_seq + 1 ;
			 insert into fee_grid_product (fee_grid_id,product_sequence,product_name) values (myid,prd_seq,parseval);
			end if;
			end loop;
			fetch c1 into myid , parseval;
end loop;
end;
end;
;
begin
reparse_table;
end;
;
drop procedure reparse_table
;
/* end */ 
 
update  an_param_items set attribute_value= replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%/Horizon' and class_name = 'com.calypso.tk.risk.SimulationParam'
;
update  an_param_items set attribute_value= replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like 'Horizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;
update  an_param_items set attribute_value= replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%,Horizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;
update  an_param_items set attribute_value= replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like 'Horizon/%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;
update  an_param_items set attribute_value= replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%,Horizon%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;
update an_param_items set attribute_value= replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value like '%/Horizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

update an_param_items set attribute_value= replace(attribute_value,'Horizon','SimpleHorizon') 
where attribute_value = 'Horizon' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

update an_param_items set attribute_value= replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like '%/FXHorizon' and class_name = 'com.calypso.tk.risk.SimulationParam'
;
	
update an_param_items set attribute_value= replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value = 'FXHorizon' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

update an_param_items set attribute_value= replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like '%,FXHorizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

update an_param_items set attribute_value= replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like 'FXHorizon/%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

update an_param_items set attribute_value= replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like '%/FXHorizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

update an_param_items set attribute_value= replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like '%,FXHorizon%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

update an_param_items set attribute_value= replace(attribute_value,'FXHorizon','TimeHorizon') 
where attribute_value like 'FXHorizon,%' and class_name = 'com.calypso.tk.risk.SimulationParam'
;

/* end */ 

delete from DOMAIN_VALUES where name='scheduledTask' and value in('EOD_CAPLMARKING_OLD','EOD_SYSTEM_PLMARKING','EOD_SYSTEM_PLMARKING_OLD')
; 
/* END */

delete from domain_values where name='domain' and value ='ForwardLadderProduct' and  description='Products that are supported in Forward Ladder Analysis'
;
delete from domain_values where name='ForwardLadderProduct' and value='FX'
;
delete from domain_values where name='ForwardLadderProduct' and  value ='FXForward'
;
delete from domain_values where name='ForwardLadderProduct' and value ='FXSwap'
;
delete from domain_values where name='ForwardLadderProduct' and value ='FXNDFSwap'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FXNDF'	
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FXTTM'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FXSpotReserve'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FXOptionForward'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FXOption'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FutureFX'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FutureMM'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FutureBond'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'Cash'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'SimpleMM'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'CallNotice'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'FRA'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'SimpleTransfer'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'Swap'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'PositionCash'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'CommoditySwap2'
;
delete from domain_values where name='ForwardLadderProduct' and value = 'CommodityOTCOption2'
;
delete from domain_values where name='ForwardLadderProduct' and value ='PreciousMetalDepositLease'
;
delete from domain_values where name='ForwardLadderProduct' and value ='PreciousMetalLeaseRateSwap'
;
delete from domain_values where name='riskAnalysis' and value='FwdLadder'
;
delete from domain_values where name='domain' and value= 'FwdLadderPVDisplayCcy' and description='FwdLadder PV Display Currency'
;
delete from domain_values where name='FwdLadderPVDisplayCcy' and value ='USD' and description='Default PV Display Currency for FwdLadder'
;
/* CAL-112768 */
INSERT INTO product_sec_code (product_id, sec_code, code_value, code_value_ucase)
SELECT product_id, 'USE_LOCAL_MAPPINGS', 'true', 'TRUE'
FROM product_cdsnthdflt  
WHERE product_id NOT IN
(SELECT psc.product_id FROM product_sec_code psc   WHERE psc.sec_code = 'USE_LOCAL_MAPPINGS')
;

INSERT INTO product_sec_code (product_id, sec_code, code_value, code_value_ucase)
SELECT product_id, 'USE_LOCAL_MAPPINGS', 'true', 'TRUE'
FROM product_cdsnthloss  
WHERE product_id NOT IN
(SELECT psc.product_id FROM product_sec_code psc  WHERE psc.sec_code = 'USE_LOCAL_MAPPINGS')
;
 
/* CAL-102083 */
INSERT INTO trade_keyword (trade_id, keyword_name, keyword_value) SELECT trade_id, 'SettledCreditEventIds', keyword_value 
FROM trade_keyword WHERE keyword_name = 'CreditEventIds' AND trade_id NOT IN 
(SELECT trade_id FROM trade_keyword WHERE keyword_name = 'SettledCreditEventIds')
;
/* end */ 
 
/* add the diff from version 11.1.0.4 to 12.0 */
 
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (721,'FULL_COUPON','Bond','Coupon payment including Withholding Tax Amount','FULL','REALIZED','N/A','NONE','',0,0 )
;
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (722,'REFUND_COUPON','Bond','Withholding Tax Amount of the coupon to be reclaimed','FULL','REALIZED','N/A','NONE','',0,0 )
;
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (723,'WITHHOLDINGTAX','Bond','Withholding Tax Amount','FULL','BALANCE','N/A','NONE','',0,0 )
;
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee, version_num ) VALUES (724,'NET_WITHHOLDINGTAX','Bond','Withholding Tax Amount net of TaxAuthority refund','FULL','BALANCE','N/A','NONE','',0,0 )
;
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16558,'HEDGED_MTM_CHG','ALL','Fair Value Change on the Hedged Trade','ClosingPeriod','INVENTORY','Reversal','NONE','NPV_NET',0 )
;
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16559,'HEDGING_MTM_CHG','ALL','Fair Value on the Hedging Trade','ClosingPeriod','INVENTORY','Reversal','NONE','NPV_NET',0 )
;
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16560,'INCEPTION_MTM','ALL','Fair Value At Inception on the Trade Item','FULL','INVENTORY','N/A','NONE','NPV_NET',0 )
;
INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16561,'INCEPTION_MTM_REV','ALL','Fair Value At Inception on the Trade Item','FULL','INVENTORY','N/A','NONE','NPV_NET',0 )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16558,'HEDGE_VALUATION' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16559,'HEDGE_VALUATION' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'HEDGE_VALUATION' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'VERIFIED_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'CANCELED_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'HEDGE_VALUATION' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'VERIFIED_TRADE' )
;
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'CANCELED_TRADE' )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('Portfolio','apps.risk.PortfolioAnalysisReportFrameworkViewer',0 )
;
INSERT INTO auth_class_config ( class_name, full_class_name ) VALUES ('BondDanishMortgage','com.calypso.tk.product.BondDanishMortgage' )
;
INSERT INTO auth_class_config ( class_name, full_class_name ) VALUES ('Equity','com.calypso.tk.product.Equity' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES (1549,'Reject' )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('Drawn MM Book','Drawn MM Book' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','ReportOutput.ReportViewerRequiringSort','List of ReportViewer requiring sort done in ReportOutput ' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('ReportOutput.ReportViewerRequiringSort','Simple','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('ReportOutput.ReportViewerRequiringSort','Tree','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('ReportOutput.ReportViewerRequiringSort','Pivot','Pivot View' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','Report.Default.ViewerList','List of ReportViewer requiring sort done in ReportOutput ' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('Report.Default.ViewerList','Simple','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('Report.Default.ViewerList','Tree','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('Report.Default.ViewerList','Pivot','Pivot View' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','PLMktSpread','Products for which PL explained should compute market spread' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName',' excludeProductTypesGreeksPL ','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('workflowRuleTransfer','SettleLinkedDDA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('workflowRuleTransfer','UnsettleLinkedDDA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('workflowRuleMessage','CheckIncomingFormat','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('workflowRuleMessage','UnprocessSubStatement','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('workflowRuleTrade','CheckManualCancelAuthorized','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('commodity.ForwardPriceMethods','InterpolatedPrice','Price on curve date equal to the FixDate, using the Interpolator defined in the curve.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('volSurfaceType','VolatilitySurface3DSpread','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('VolSurface.gensimple','SABRLocalVolSimple','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('volSurfaceGenerator','SVI','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('volSurfaceGenerator.commodity','CommodityVolatilitySpread','VS Generator for Commodity Spread Options' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','eXSPReportVariables','Available ArrayVariable for CashFlowGeneratorBased eXSP Product Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('eXSPReportVariables','EXOTIC_COUPONS','Coupon Formula' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','AccountHolderSDIContact','Used to indicate the contact type for the sdi of a CallAccount.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StandardUnderlyingSwapId','The swap underlying id to build a market standard swap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','TransferViewer.XferAttributes.DateAttributesToKeep','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('leAttributeType','CASH_MANAGEMENT','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('leAttributeType','CHECK_INCOMING_FORMAT','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','leAttributeType.CHECK_INCOMING_FORMAT','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('leAttributeType.CHECK_INCOMING_FORMAT','NO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('leAttributeType.CHECK_INCOMING_FORMAT','YES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('leAttributeType','SpotDaysEQ','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','MainEntry.CustomEventSubscription','Allow customer to add custom Events to be subscribed to' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','MEPreload','Main Entry Preload' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('MEPreload','BOCashPosition','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('MEPreload','BOSecurityPosition','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('MEPreload','BOBrowser','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','UseProcessin;rgHierarchy','AccessPermission for ability to look for the whole tree of children of Processing Orgs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('classAuditMode','CarveOut','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','BondDanishMortgage.Pricer','Pricers for Danish Mortgage bonds' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','FutureSwap.Pricer','Pricers for money market futures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','ETOVolatility.Pricer','Pricers for ETOVolatility (exchange traded equity option) trades' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','FutureDividend.Pricer','Pricers for Dividend Futures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','FutureVolatility.Pricer','Pricers for Volatility Futures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CurveZero.gen','Global','' )
; 
INSERT INTO domain_values ( name, value, description ) VALUES ('tradeTerminationAction','CONTINUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('hedgeStrategyAttributes','NumberOfObservations','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('hedgeStrategyAttributes','PostingsOnlyIfEffective','PostingsOnlyIfEffective' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('hedgeRelationshipAttributes','ShiftOnDiscountCurve','Shift Amount used to shifted curve' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('hedgeRelationshipAttributes','LastEffectivenessTest','LastEffectivenessTest' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('REPORT.Types','LEContact','LEContact Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','BondDanishMortgage.subtype','Types of Danish Mortgage Bonds' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','BondStructuredNote.subtype','Types of ELNs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','MarginCall.DisputeReason','Dispute Reasons of Margin Call' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','MarginCall.ContractDisputeReason','Dispute Status of Margin Call Contract' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','MarginCall.ContractDisputeStatus','Dispute Status of Margin Call Contract' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StaticPricingScriptDefinitions','Names of static pricing script definitions' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Worst Of Digital','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Accumulator','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Accumulator Tarn','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Decumulator','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Decumulator Tarn','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Vanilla Basket','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Vanilla European','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Autocall','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Multi-defender','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Vanilla Variance Swap','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Himalaya','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Hi Five Basket Bonus','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Altiplano','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Basket Worst M','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Basket Range Accrual','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StaticPricingScriptDefinitions','Fixed Dual Currency Note','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','CashFlowLeg.subtype','Types of CashFlowLeg' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('classAuditMode','BondDanishMortgage','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('classAuditMode','VolatilityIndex','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PositionBasedProducts','FutureOptionVolatility','FutureOptionVolatility out of box position based product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PositionBasedProducts','FutureDividend','FutureEquityIndex out of box position based product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PositionBasedProducts','FutureVolatility','FutureVolatility out of box position based product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PositionBasedProducts','BondStructuredNote','BondStructuredNote out of box position based product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PositionBasedProducts','ETOVolatility','ETOVolatility out of box position based product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('rateIndexAttributes','GenerateRateChange','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('systemKeyword','TerminationPrincipalExchange','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('systemKeyword','TransferType','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('systemKeyword','MergedFrom','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('systemKeyword','MergedTo','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('systemKeyword','SplitFrom','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('systemKeyword','SplitTo','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('systemKeyword','ExternalMirrorId','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('tradeKeyword','ExternalMirrorId','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('futureUnderType','Volatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('futureUnderType','Dividend','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('futureOptUnderType','Volatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('ETOUnderlyingType','Volatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('futureUnderType','Swap','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('futureOptUnderType','Swap','' )
;  
INSERT INTO domain_values ( name, value, description ) VALUES ('feeCalculator','None','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','GREEKS_INPUT','Greeks for PLE' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','BOND_DRAWING','' )
;  
INSERT INTO domain_values ( name, value, description ) VALUES ('userAttributes','Reverse Margin on HRR','Used to indicate if we need to reverse Margin on HRR trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.subtype','ASIAN_BARRIER','Asian Barrier option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.subtype','eXSP','eXSP option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TerminationPayIntFlow','Y','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TerminationPayIntFlow','N','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TransferPayIntFlow','Y','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TransferPayIntFlow','N','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TerminationFullFirstCalculationPeriod','Y','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TerminationFullFirstCalculationPeriod','N','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TerminationPrincipalExchange','Y','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('keyword.TerminationPrincipalExchange','N','' )
;  
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','CurveCommoditySpread.gen','Commodity Spread curve generators' )
; 
INSERT INTO domain_values ( name, value, description ) VALUES ('CurveCommoditySpread.gen','CommoditySpreadAllInPoints','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','CommodityOTCOption2.subtype','Subtypes for CommodityOTCOption2' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityOTCOption2.subtype','American','American' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityOTCOption2.subtype','Asian','Asian' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityOTCOption2.subtype','Digital','Digital' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityOTCOption2.subtype','European','European' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityOTCOption2.subtype','Standard','Standard' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','VolatilityIndex','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('userAccessPermAttributes','Max.TradeDiary','Type to be enforced by reports' )
; 
INSERT INTO domain_values ( name, value, description ) VALUES ('securityCode','FromBondProduct','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('securityCode','DMB Serie','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('accEventType','HEDGED_MTM_CHG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('accEventType','HEDGING_MTM_CHG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('accEventType','INCEPTION_MTM','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('accEventType','INCEPTION_MTM_REV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('bondType','BondStructuredNote','bondtype ELN domain' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('bondType','BondDanishMortgage','bondtype domain' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('BondStructuredNote.Pricer','PricerBondStructuredNote','Pricer for BondStructuredNote' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('BondDanishMortgage.Pricer','PricerBondDanishMortgage','Pricer for BondDanishMortgage' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('ETOVolatility.Pricer','PricerETOVolatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('FutureMM.Pricer','PricerFutureMMSpecific','Pricer for Future MM FedFund/Eonia-Sonia' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('FutureSwap.Pricer','PricerFutureSwap','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('FutureDividend.Pricer','PricerFutureDividend','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('FutureVolatility.Pricer','PricerFutureVolatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('VarianceSwap.Pricer','PricerVarianceSwapReplicationFX','Pricer for variance swap by replication on an FX underlying' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('VarianceSwap.Pricer','PricerVarianceSwapReplication','Pricer for variance swap by replication on an equity/index underlying' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('Bond.subtype','BondStructuredNote','subtype for structured note' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityLinkedSwap.Pricer','PricerAmortizingSwap','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','EquityLinkedSwap.extendedType','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityLinkedSwap.extendedType','Amortizing_Swap','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','showProductMapper','domain to control if the ProductMapper will be shown on the ExoticType. Enter a YES or Y (any case) as a value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('BondStructuredNote.subtype','Standard','BondStructuredNote subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('BondDanishMortgage.subtype','Standard','Standard Danish Mortgage bond subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('BondDanishMortgage.subtype','Drawn','Drawn Danish Mortgage bond subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CA.subtype','DRAWING','DRAWING' )
; 
INSERT INTO domain_values ( name, value, description ) VALUES ('interpolator','InterpolatorMonotoneConvex','Interpolator for interest-rate-like curves designed to produce smooth local forward rates.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('eventType','EX_EXT_POS_INIT','Indicates an issue with the initialization of the External Position.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('exceptionType','EXT_POS_INIT','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('eventType','EX_BOND_DRAWING','Indicates that a Scheduled Task could not create a Drawn Bond.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('feeCalculator','EquityLinkedSwapPercentage','Percentage fee calculator for Equity Linked Swap (holds FX conversion)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('flowType','BANK CONFIRMED','External Position' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','CalypsoMLImport','Access permission to import CalypsoML into dataserver. Used by CAM and Configuration Management Tool.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','CalypsoMLExport','Access permission to export CalypsoML into dataserver. Used by CAM and Configuration Management Tool.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('feeCalculator','PhysicalSettlementPct','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('flowType','ADJUSTMENT','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('flowType','RATE_CHANGE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Statement Integration#Process Anyway','Access permission Force Process Statement Integration' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Statement Integration#Ignore','Access permission Ignore Statement Integration' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Statement Integration#Try Again','Access permission Retry Statement Integration' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Master Statements Received#Ignore','Access permission Ignore Master Statement Check' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Master Statements Received#Try Again','Access permission Retry Master Statement Check' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Account Consolidation#Ignore','Access permission Ignore Account Conso' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Account Consolidation#Try Again','Access permission Retry Account Conso' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Statement Generation#Ignore','Access permission Ignore Statement Generation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Statement Generation#Try Again','Access permission Retry Statement Generation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ProcessStatus.Sub Statement Processing#Try Again','Access permission Retry Sub Statement Processing' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','CreateModifyPositionRolloverRule','Permission to Save Position Rollover Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','RemovePositionRolloverRule','Permission to Remove Position Rollover Rule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','DisableCheckLERelation','Access permission to Disable the Check of Legal Entity Relation' )
;
INSERT INTO domain_values ( name, value ) VALUES ('billingEvents','BillingTaskEvent' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('marketDataUsage','DIS_COLLATERAL_SP','usage type for Repo Underlying Curve Mapping' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('marketDataUsage','DIS_COLLATERAL_GC','usage type for Repo Underlying Curve Mapping' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('messageType','RATE_CHANGE_ADVICE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','BondStructuredNote','produttype domain' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','BondDanishMortgage','produttype domain' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','CashFlowLeg','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','FutureSwap','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','ETOVolatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','FutureDividend','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','FutureVolatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','FutureOptionVolatility','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('riskAnalysis','Portfolio','Portfolio Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('role','TaxAuthority','withholding tax management' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('riskAnalysis','ScenarioGreeksInput','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('MESSAGE.Templates','CreditFacilityConfirm.html','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('MESSAGE.Templates','CreditTrancheConfirm.html','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','EQD_FWD_SETTLE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','HEDGE_ACCOUNTING','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','HEDGE_EFFECTIVENESS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','LOAD_CALCULATIONSERVER','load services on calculation server' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','LOAD_SAVED_CALCULATIONSERVER','load pre-saved analysis output on calculation server' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('scheduledTask','REPO_GC_MD_MAPPINGS','Map Repo Underlying with Zero curves usage DIS_COLLATERAL_GC' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('tradeKeyword','TransferType','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('tradeKeyword','TerminationPrincipalExchange','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('tradeKeyword','SettledCreditEventIds','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SWIFT.Templates','MT104','Direct Debit and Request for Debit Transfer Message' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SWIFT.Templates','MT204','Request for Debit Of a Third Party Transfer Message' )
; 
INSERT INTO domain_values ( name, value, description ) VALUES ('SWIFT.Templates','Payment205.selector','Payment205TemplateSelector' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SWIFT.Templates','PaymentCOV.selector','PaymentCOVTemplateSelector' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SWIFT.Templates','Payment205COV.selector','Payment205COVTemplateSelector' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('MESSAGE.Templates','rateChangeAdvice.html','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('InventoryPositions','EXTERNAL-BANK CONFIRMED-SETTLE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('applicationName','AuthService','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('riskPresenter','Portfolio','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('riskPresenter','Pricing','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('FutureContractAttributes','CommodityResetForPhysicalDeliveryId','Commodity Reset association for storage based Commodity with future physical delivery' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('FutureContractAttributesReadOnly','CommodityResetForPhysicalDeliveryId','not editable in AttributableWindow, please consider using underlying reset choice' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','ProcessStatusCustomizer','ProcessStatusCustomizer and className in comment' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('ProcessStatusCustomizer','CashManagement','tk.report.CashManagementProcessStatusCustomizer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','CustomMessageViewerTab','Custom Message Viewer Tab Names' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','CustomTransferViewerTab','Custom Transfer Viewer Tab Names' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productInterfaceReportStyle','Exotic','Exotic ReportStyle for eXSP ArrayVariable' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','BondStructuredNote','BondStructuredNote ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','CashFlowLeg','CashFlowLeg  ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','ETOVolatility','ETOVolatility ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','Future','Future ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','FutureDividend','FutureDividend ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','FutureVolatility','FutureVolatility ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityAveragingPolicy','CoalATC','CoalATC' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityAveragingPolicy','CoalCTA','CoalCTA' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityAveragingPolicy','CoalCTAWithFXRoll','CoalCTAWithFXRoll' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityFXAveragingPolicy','CoalATC','CoalATC' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityFXAveragingPolicy','CoalCTA','CoalCTA' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CommodityFXAveragingPolicy','CoalCTAWithFXRoll','CoalCTAWithFXRoll' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('groupStaticDataFilter','Carve-out','group for StaticDataFilters which should be available in Carve-out related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','AddDividend','Allow User to add Dividend to Equity DividendSchedule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','RemoveDividend','Allow User to remove Dividend from Equity DividendSchedule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','masterConfirmationRelevantDates','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('masterConfirmationRelevantDates','TerminationTradeDate','{TerminationType=FullTermination|NotionalIncrease|Novation|PartialNovation|PartialTermination}' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('masterConfirmationRelevantDates','TransferTradeDate','{TransferType=FullTermination|NotionalIncrease|Novation|PartialNovation|PartialTermination}' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','fixingType','Future Price Reference on some market place for ETO or Future' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('fixingType','EDSP','Exchange Delivery Settlement Price' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('fixingType','VWAP','Volume-Weighted Average Price' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('fixingType','PDR','Prezzo Di Riferimento' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','SimulationCommonMeasures','Defines the contents of the "Commonly Used" option in Simulation Viewer SelectableListChooserWindow popups.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','BETA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','BETA_ADJUSTED_INDEX','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','BETA_INDEX','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','DELTA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','DELTA_01','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','DELTA_IN_UNDERLYING','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','GAMMA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','GAMMA_IN_UNDERLYING','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','MOD_DELTA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','MOD_GAMMA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','MOD_VEGA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','NDELTA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','NGAMMA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','NTHETA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','NVEGA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','PV01','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','PV01_CREDIT','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','RHO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','RHO2','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','SPOT_RATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','THETA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('SimulationCommonMeasures','VEGA','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','CA.keywords','Types of keywords that can be applied to CA trades' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CA.keywords','WithholdingTaxConfigId','The WithholdingTax rate and TaxAuthority reclaim details applied to a CASH CA' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('classAuthMode','LEUserAccessRelation','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('classAuditMode','LEUserAccessRelation','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ModifyAccessPermLEAccess','Change access permissions LE Access Tab' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','AuthorizeLEUserAccessRelation','Access permission to Authorize LEUserAccessRelation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','dataSegregationEnabledApps','Web Apps' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','Authorization','Web Module for Authorization' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','AccountActivity','Web Module for Account Activity' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','InventoryCashPosition','Web Module for Inventory Cash Position' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','CashForecast','Web Module for Cash Forecast' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','DealRequest','Web Module for Deal Request' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','IntercompanySettlement','Web Module for Intercompany Settlement' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','Statements','Web Module for Statements' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','SDI','Web Module for SDI' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','Payments','Web Module for Payments' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','Confirmations','Web Module for Confirmations' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','TradeBlotter','Web Module for Trade Blotter' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','TradeViewer','Web Module for Trade Viewer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','TradeReport','Web Module for Trade Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','PaymentsReport','Web Module for Payments Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','ConfirmationsReport','Web Module for Confirmations Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('dataSegregationEnabledApps','__ALL__','ALL Web Modules' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('marketDataUsage','HyperSurfaceOpen','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','hyperSurfaceHyperDataTypeDomain','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','CashFlowLeg.Pricer','Pricers for CashFlowLeg' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CashFlowLeg.Pricer','PricerCashFlowLeg','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('Warrant.Pricer','PricerBlack1FAnalyticDiscreteVanilla','analytic Pricer for european vanilla warrant - using Forward based Black Scholes Merton model - can do discrete dividends' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('Warrant.Pricer','PricerBlack1FFiniteDifference','Pricer for american/bermudan/european vanilla Warrant using Finite Differences on Black Scholes Merton model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.Pricer','PricerBlackNFMonteCarloExotic','MonteCarlo Pricer for eXSP option payoffs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.Pricer','PricerBlack1FFiniteDifference','Finite Difference Pricer for single asset european or american or bermudan option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.Pricer','PricerLocalVolatility1FFiniteDifference','Finite Difference Pricer for single asset option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.Pricer','PricerLocalVolatility1FFiniteDifferenceExotic','Finite Difference Pricer for single asset option with eXSP payoff' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.Pricer','PricerLocalVolatility1FMonteCarlo','Monte-Carlo Pricer for single asset option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('EquityStructuredOption.Pricer','PricerLocalVolatilityNFMonteCarloExotic','Monte Carlo Pricer for single and basket asset option with eXSP payoff' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('CurveInflation.gen','InflationIndexKerkhof','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('interpolatorInflation','InterpolatorFlatForward','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('interpolatorInflation','InterpolatorLinear','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('interpolatorInflation','InterpolatorLogSpline','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('interpolatorInflation','InterpolatorLogMonotonicSplineNaturalHyman89','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','ViewAllWHTAttributes','Allow User to See Hidden Entry in WithholdingTaxAttribute' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_POS_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Sales_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Sales_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Sales_Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Sales_Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Sales_Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Sales_Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trader_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trader_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trader_Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trader_Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trader_Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trader_Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trade_Date_Cash_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Unrealized_Translation_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','SALES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','NPV_NET','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','CUMULATIVE_CASH_MARGIN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','CUMULATIVE_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','HISTO_UNSETTLED_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH_MARGIN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','HISTO_ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlOTCEOD','HISTO_CUMUL_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','CUMULATIVE_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','TOTAL_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_UNSETTLED_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_CUMUL_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_TOTAL_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlEquitiesEOD','HISTO_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','CUMULATIVE_CASH_PRINCIPAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','CUMULATIVE_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','NPV_NET','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','HISTO_UNSETTLED_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','HISTO_UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','HISTO_ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','HISTO_CUMUL_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlMMEOD','HISTO_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_PRINCIPAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_SL_FEE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','INDEMNITY_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','NPV_NET','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_UNSETTLED_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_CUMUL_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_SL_FEE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','HISTO_INDEMNITY_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','CLEAN_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','NPV_DISC_WITH_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','PREM_DISC','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','PREM_DISC_YIELD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','REALIZED_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','TD_ACCRUAL_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','TOTAL_PAYDOWN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','TOTAL_PAYDOWN_BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','CLEAN_BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_REALIZED_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_TD_ACCRUAL_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_TOTAL_PAYDOWN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_TOTAL_PAYDOWN_BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','HISTO_UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlBondsEOD','UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFXEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFXEOD','NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFXEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFXEOD','POSITION_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFXEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','CUMULATIVE_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','HISTO_CUMUL_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','HISTO_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','HISTO_UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','HISTO_UNSETTLED_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlFuturesEOD','UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','SETTLED_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','UNSETTLED_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','HISTO_SETTLED_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','HISTO_UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','HISTO_UNSETTLED_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlETOEOD','UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CONVERSION_FACTOR','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CLEAN_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CUMULATIVE_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CUMULATIVE_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CUMULATIVE_CASH_PRINCIPAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CUMULATIVE_CASH_SL_FEE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','INDEMNITY_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','NPV_DISC_WITH_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','POSITION_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','PREM_DISC','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','PREM_DISC_YIELD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','REALIZED_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','SETTLED_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','TD_ACCRUAL_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','TOTAL_PAYDOWN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','TOTAL_PAYDOWN_BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','UNSETTLED_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CLEAN_BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CUMULATIVE_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','CUMULATIVE_CASH_MARGIN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','FEES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_CUMUL_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_CUMUL_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_MARGIN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_SL_FEE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_INDEMNITY_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_REALIZED_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_SETTLED_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_TD_ACCRUAL_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_TOTAL_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_TOTAL_PAYDOWN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_TOTAL_PAYDOWN_BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_UNSETTLED_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','HISTO_UNSETTLED_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','NPV_NET','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','SALES_NPV','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','TOTAL_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','Trade_Date_Cash_Unrealized_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('plMeasure','SL_Fees_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTrader','Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTrader','Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTrader','Trade_Full_Base_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTrader','Trade_Translation_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','SL_Fees_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Trade_Date_Cash_Unrealized_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','UNSETTLED_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlAllEOD','UNSETTLED_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','UNSETTLED_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PricerMeasurePnlRepoEOD','UNSETTLED_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CLEAN_BOOK_VALUE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CLEAN_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CUMULATIVE_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CUMULATIVE_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CUMULATIVE_CASH_MARGIN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CUMULATIVE_CASH_PRINCIPAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','CUMULATIVE_CASH_SL_FEE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','FEES_UNSETTLED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','FEES_UNSETTLED_SD','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_ACCRUAL_BO','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_BS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_CUMULATIVE_CASH_MARGIN','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_CUMULATIVE_CASH_SL_FEE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_CUMUL_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_CUMUL_CASH_FEES','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_CUMUL_CASH_INTEREST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_INDEMNITY_ACCRUAL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_PL_FUNDING_COST','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_POS_CASH','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','HISTO_REALIZED','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlOTCEOD','OTC' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlEquitiesEOD','Equities' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlMMEOD','MM and Call Notice' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlRepoEOD','Repo' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlBondsEOD','Bonds' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlFXEOD','FX' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlFuturesEOD','Futures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlETOEOD','ETO' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesPricerMsrEOD','PricerMeasurePnlAllEOD','All Measures' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Cash_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Fees_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Net_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unsettled_Cash_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Accrual_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Accrued_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Cash_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Paydown_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Realized_Interests_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Sale_Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Realized_Price_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Interests_Full','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','BS_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Trade_Date_Cash_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Cash_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Fees_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Net_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unsettled_Cash_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Accrual_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Accrued_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Cash_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Paydown_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Realized_Interests_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Sale_Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Realized_Price_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Interests_Full','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Trade_Cash_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Trade_Translation_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Trade_Full_Accrual_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Trade_Full_Base_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Sales_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trader_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Sales_Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trader_Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Sales_Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trader_Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trade_Full_Base_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Sales_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trader_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Sales_Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trader_Unrealized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Sales_Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trader_Realized_Full_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTrader','Total_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTrader','Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTrader','Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Total_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Cost_Of_Carry_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Trade_Full_Base_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLHighLevel','Trade_Translation_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Total_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Cash_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Fees_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Interests','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Net_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Accrual_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Accrued_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Realized_Price_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Cash_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Paydown_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Realized_Interests_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Sale_Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Cost_Of_Carry_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Cost_Of_Funding_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Trade_Full_Accrual_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Trade_Full_Base_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Unrealized_Translation_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Trade_Translation_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Funding_Cost_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Total_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Cash_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Fees_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Interests','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Unrealized_Net_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Accrual_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Accrued_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Realized_Price_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Cash_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Paydown_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Realized_Interests_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Sale_Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Total_Accrual_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Cost_Of_Carry_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Cost_Of_Funding_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLTradeDateCash','Funding_Cost_FX_Reval','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Total_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Total_Accrual_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLMTMAndAccruals','Cost_Of_Carry_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Total_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Unrealized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Realized_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Cost_Of_Carry_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLSalesAndTraderPnL','Trade_Translation_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('PNLWithDetails','Total_Accrual_PnL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesForPNL','PNLHighLevel','Official PnL - high Level' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesForPNL','PNLMTMAndAccruals','Official PnL - MTM and accruals' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesForPNL','PNLTradeDateCash','Official PnL - trade date cash' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesForPNL','PNLTrader','Trader PnL' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesForPNL','PNLWithDetails','Official PnL - with details' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('NamesForPNL','PNLSalesAndTraderPnL','Official PnL - Sales and Trader PnL' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','VolatilityIndex.subtype','VolatilityIndex product subtypes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('VolatilityIndex.subtype','Equity','VolatilityIndex based EquityIndex' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('VolatilityIndex.subtype','Commodity','VolatilityIndex based CommodityIndex' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','pricingScriptReportVariables','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Knockouts.PaymentDateArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Payments.PaymentDateArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','PeriodAccruals.PaymentDateArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','AccrualAbove','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','AccrualBelow','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','ForwardPrice','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','KnockOutBarrier','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','TarnCapped','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','TarnLevel','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BarrierStrike','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','CouponRate','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','PaymentCurrency','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','ObservationDates.ReferenceDate','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','PaymentDates.PaymentDateArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','EarlyRedemption.PaymentDateArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BarrierLevel','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','PayCurrency','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Strike','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','AccrualDates.PaymentDateArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Maturity.PaymentDate','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','CouponPeriods.AccrualPeriodArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','FixingDate','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BarrierAbove','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BarrierBelow','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Notional','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','M	','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','CouponCurrency','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','FixedRate','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','PrincipalAmount','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','PrincipalCurrency','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BarrierPrice','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BonusReturn','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','KnockOutPrice','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Performance','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','YearFrac','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','PaymentCcy','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Factor','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BaseCurrency','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','DaysInYear','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','VolatilityStrikePrice','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','AbovePerformance','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','BelowPerformance','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Ccy','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables','Basket','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','pricingScriptReportVariables.ReferenceDate','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','STARTDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','ENDDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','FREQUENCY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','HOLIDAYS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','DATEROLL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','PERIODRULE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','SPECIFYROLLDAY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','ROLLDAY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.ReferenceDate','INCLUDESTART','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','pricingScriptReportVariables.PaymentDateArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','STARTDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','ENDDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','FREQUENCY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','HOLIDAYS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','DATEROLL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','PERIODRULE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','DATERULE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','SPECIFYROLLDAY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','ROLLDAY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','PAYMENTLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','RESETLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','BUSDAYLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','STUBRULE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','ROUNDING','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDateArray','INCLUDESTART','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','pricingScriptReportVariables.PaymentDate','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDate','REFERENCEDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDate','HOLIDAYS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDate','DATEROLL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDate','BUSDAYLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDate','PAYMENTLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.PaymentDate','RESETLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','pricingScriptReportVariables.AccrualPeriodArray','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','STARTDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','ENDDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','FREQUENCY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','HOLIDAYS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','DATEROLL','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','PERIODRULE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','DAYCOUNT','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','PAYMENTARREARS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','RESETARREARS','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','SPECIFYROLLDAY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','ROLLDAY','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','PAYMENTLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','BUSDAYLAG','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','STUBRULE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','FIRSTSTUBDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','LASTSTUBDATE','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('pricingScriptReportVariables.AccrualPeriodArray','ROUNDING','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','PricingSheetUserPreferencesAccess','Give access to the User Preferences in Pricing Sheet' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','PricingSheetStrategyBuilderAccess','Give access to the Strategy Builder in Pricing Sheet' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','PricingSheetProfilePropertiesConfigAccess','Give access to the Configuration tab in the Profile Configuration window
for the subtabs Properties, Menu, Layout in Pricing Sheet' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','PricingSheetProfileUsersConfigAccess','Give access to the Configuration tab in the Profile Configuration window in Pricing Sheet' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('function','PricingSheetProfileAdminAccess','Give access to the whole Profile Configuration window in Pricing Sheet' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','ACCRUAL' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','ACCRUAL_FIRST' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','ACCRUAL_PAYMENT' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','ACCRUAL_PAYMENT_FIRST' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','ACCUMULATED_ACCRUAL' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','CASH' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','DELTA_01' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','NDELTA' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','NGAMMA' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','NVEGA' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetMeasures','PV01' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Reference' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Entity' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Market Data' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Pricer Data' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Dealt Data' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Solver' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Detail 1' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Detail 2' )
;
INSERT INTO domain_values ( name, value ) VALUES ('PricingSheetPropertyDisplayGroups','Detail 3' )
; 
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','BondStructuredNote.ANY.ANY','PricerBondStructuredNote' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','BondDanishMortgage.ANY.ANY','PricerBondDanishMortgage' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Bond.ANY.BondStructuredNote','PricerBondStructuredNote' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','EquityStructuredOption.ANY.Bermudan','PricerBlack1FFiniteDifference' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','EquityStructuredOption.ANY.ASIAN_BARRIER','PricerBlack1FMonteCarlo' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','EquityLinkedSwap.Amortizing_Swap.ANY','PricerAmortizingSwap' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SHARES_ACCRUED','tk.core.PricerMeasure',412,'Number of shares accrued in the current period. Generally relevant to physical settlement' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_QUANTITY','tk.pricer.PricerMeasureCAQuantity',413,'Cross Asset Quantity' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('B/E_Ratio','tk.core.PricerMeasure',415,'' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PA_YIELD','tk.core.PricerMeasure',416,'The equivalent yield for a PA paying instrument.' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SA_YIELD','tk.core.PricerMeasure',417,'The equivalent yield for a SA paying instrument.' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('IGNORE_FX_RESET','java.lang.Boolean','true,false','',1,'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('IGNORE_PRICE_FIXING','java.lang.Boolean','true,false','',1,'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('REGEN_MKTDATA_FOR_GREEKS','java.lang.Boolean','true,false','Use this parameter to re-generate market data items that depend on a shift in market data items used to compute numerical measures.  For example, re-generation of volatility surface in calculating Real Rho1/2 for FX options.',1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('VOL_SHIFT_UNDERLYINGS','java.lang.Boolean','true,false','FX/FXOption : Determines whether the surface are shifted by shifting underlyings',1,'VOL_SHIFT_UNDERLYINGS','false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('REPLICATION_STRIKE_SPREAD','java.lang.Double','','',1,'REPLICATION_STRIKE_SPREAD','0.000001' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('SUPPRESS_RISKY_CURVE','java.lang.Boolean','true,false','If true and applicable, suppress loading of risky curve.',1,'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MARKDOWN_RECOVERY','java.lang.Double','','Lower recovery rate limit for a default',0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('FD_SCHEME','java.lang.String','Crank-Nicolson,Euler Implicit,Rannacher,TR-BDF2','Finite Differences scheme choice',1,'Rannacher' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, default_value ) VALUES ('NUMBER_OF_X_STEPS','java.lang.Integer','Number of steps in the asset price direction',1,'100' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('ACCRUAL_FROM_TD','java.lang.Boolean','true,false','Accrual starts from Trade Date','false',1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('USE_FICTIONAL_CASH','java.lang.Boolean','true,false','',1,'USE_FICTIONAL_CASH','false' )
;

BEGIN
  DECLARE cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO cnt FROM pricing_param_name WHERE param_name = 'ACCRUAL_FROM_TD';
  IF(cnt = 0) THEN
    INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('ACCRUAL_FROM_TD','java.lang.Boolean','true,false','Accrual starts from Trade Date','false',1 );
   END IF;
 END;
END;
;

INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list ) VALUES ('FromBondProduct','int',0,1,0,'Bond' )
;
INSERT INTO product_code ( product_code, code_type, unique_b, searchable_b, mandatory_b, product_list ) VALUES ('DMB Serie','string',1,1,0,'Bond' )
;
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventTask','BillingEngine' )
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (601,1,'sched_task_attr','task_id','1','attr_value','sched_task_attr.attr_name IN (''SD_FILTER'', ''STATIC DATA FILTER'', ''TRANSFER_FILTER'', ''SD Filter'', ''Xfer SD Filter'', ''Msg SD Filter'')','ScheduledTask','apps.refdata.ScheduledTaskWindow','Scheduled Task - Attributes' )
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (602,2,'sched_task_attr','task_id','1','attr_value','sched_task_attr.attr_name IN (''OTC Trade Filter'')','ScheduledTask','apps.refdata.ScheduledTaskWindow','Scheduled Task - Attributes' )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES (133,'HedgeAccounting',0,1,1 )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('bond_dm','Table for Product BondDanishMortgage' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('bond_struct_note','Table for Product BondStructuredNote' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('drawing_schedule','Drawing Schedule' )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES (1548,'PSEventTrade','TERMINATED','UNTERMINATE','VERIFIED',0,1,'EquityStructuredOption','ALL',0,0,0,'Used for reverting a CA',0,0,0,0,0,0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, msg_type, log_completed_b, process_org_id, kick_cutoff_b, comments, create_task_b, version_num, prefered_b, update_only_b, gen_int_event_b, needs_man_auth_b ) VALUES (1549,'PSEventTrade','TERMINATED','REJECT','VERIFIED',0,1,'EquityStructuredOption','ALL',0,0,0,'Used for reverting a Termination',0,0,0,0,0,0 )
;

INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('010','Status','Opening Ledger' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('011','Status','Average Opening Ledger MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('012','Status','Average Opening Ledger YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('015','Status','Closing Ledger' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('020','Status','Average Closing Ledger MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('021','Status','Average Closing Ledger - Previous Month' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('022','Status','Aggregate Balance Adjustments' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('024','Status','Average Closing Ledger YTD - Previous Month' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('025','Status','Average Closing Ledger YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('030','Status','Current Ledger' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('037','Status','ACH Net Position' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('039','Status','Opening Available + Total Same-Day ACH DTC Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('040','Status','Opening Available' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('041','Status','Average Opening Available MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('042','Status','Average Opening Available YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('043','Status','Average Available - Previous Month' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('044','Status','Disbursing Opening Available Balance' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('045','Status','Closing Available' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('050','Status','Average Closing Available MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('051','Status','Average Closing Available - Last Month' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('054','Status','Average Closing Available YTD - Last Month' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('055','Status','Average Closing Available YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('056','Status','Loan Balance' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('057','Status','Total Investment Position' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('059','Status','Current Available (CRS Suppressed)' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('060','Status','Current Available' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('061','Status','Average Current Available MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('062','Status','Average Current Available YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('063','Status','Total Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('065','Status','Target Balance' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('066','Status','Adjusted Balance' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('067','Status','Adjusted Balance MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('068','Status','Adjusted Balance YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('070','Status','0-Day Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('072','Status','1-Day Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('073','Status','Float Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('074','Status','2 or More Days Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('075','Status','3 or More Days Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('076','Status','Adjustment to Balances' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('077','Status','Average Adjustment to Balances MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('078','Status','Average Adjustment to Balances YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('079','Status','4-Day Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('080','Status','5-Day Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('081','Status','6-Day Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('082','Status','Average 1-Day Float MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('083','Status','Average 1-Day Float YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('084','Status','Average 2-Day Float MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('085','Status','Average 2-Day Float YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('086','Status','Transfer Calculation' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('100','CR','Summary','Total Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('101','CR','Summary','Total Credit Amount MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('105','CR','Summary','Credits Not Detailed' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('106','CR','Summary','Deposits Subject to Float' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('107','CR','Summary','Total Adjustment Credits YTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('108','CR','Detail','Credit (Any Type)' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('109','CR','Summary','Current Day Total Lockbox Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('110','CR','Summary','Total Lockbox Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('115','CR','Detail','Lockbox Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('116','CR','Detail','Item in Lockbox Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('118','CR','Detail','Lockbox Adjustment Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('120','CR','Summary','EDI* Transaction Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('121','CR','Detail','EDI Transaction Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('122','CR','Detail','EDIBANX Credit Received' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('123','CR','Detail','EDIBANX Credit Return' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('130','CR','Summary','Total Concentration Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('131','CR','Summary','Total DTC Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('135','CR','Detail','DTC Concentration Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('136','CR','Detail','Item in DTC Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('140','CR','Summary','Total ACH Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('142','CR','Detail','ACH Credit Received' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('143','CR','Detail','Item in ACH Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('145','CR','Detail','ACH Concentration Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('146','CR','Summary','Total Bank Card Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('147','CR','Detail','Individual Bank Card Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('150','CR','Summary','Total Preauthorized Payment Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('155','CR','Detail','Preauthorized Draft Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('156','CR','Detail','Item in PAC Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('160','CR','Summary','Total ACH Disbursing Funding Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('162','CR','Summary','Corporate Trade Payment Settlement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('163','CR','Summary','Corporate Trade Payment Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('164','CR','Detail','Corporate Trade Payment Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('165','CR','Detail','Preauthorized ACH Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('166','CR','Detail','ACH Settlement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('167','CR','Summary','ACH Settlement Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('168','CR','Detail','ACH Return Item or Adjustment Settlement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('169','CR','Detail','Miscellaneous ACH Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('170','CR','Summary','Total Other Check Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('171','CR','Detail','Individual Loan Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('172','CR','Detail','Deposit Correction' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('173','CR','Detail','Bank-Prepared Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('174','CR','Detail','Other Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('175','CR','Detail','Check Deposit Package' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('176','CR','Detail','Re-presented Check Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('178','CR','Summary','List Post Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('180','CR','Summary','Total Loan Proceeds' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('182','CR','Summary','Total Bank-Prepared Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('184','CR','Detail','Draft Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('185','CR','Summary','Total Miscellaneous Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('186','CR','Summary','Total Cash Letter Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('187','CR','Detail','Cash Letter Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('188','CR','Summary','Total Cash Letter Adjustments' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('189','CR','Detail','Cash Letter Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('190','CR','Summary','Total Incoming Money Transfers' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('191','CR','Detail','Individual Incoming Internal Money Transfer' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('195','CR','Detail','Incoming Money Transfer' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('196','CR','Detail','Money Transfer Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('198','CR','Detail','Compensation' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('200','CR','Summary','Total Automatic Transfer Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('201','CR','Detail','Individual Automatic Transfer Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('202','CR','Detail','Bond Operations Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('205','CR','Summary','Total Book Transfer Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('206','CR','Detail','Book Transfer Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('207','CR','Summary','Total International Money Transfer Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('208','CR','Detail','Individual International Money Transfer Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('210','CR','Summary','Total International Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('212','CR','Detail','Foreign Letter of Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('213','CR','Detail','Letter of Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('214','CR','Detail','Foreign Exchange of Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('215','CR','Summary','Total Letters of Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('216','CR','Detail','Foreign Remittance Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('218','CR','Detail','Foreign Collection Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('221','CR','Detail','Foreign Check Purchase' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('222','CR','Detail','Foreign Checks Deposited' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('224','CR','Detail','Commission' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('226','CR','Detail','International Money Market Trading' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('227','CR','Detail','Standing Order' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('229','CR','Detail','Miscellaneous International Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('230','CR','Summary','Total Security Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('231','CR','Summary','Total Collection Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('232','CR','Detail','Sale of Debt Security' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('233','CR','Detail','Securities Sold' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('234','CR','Detail','Sale of Equity Security' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('235','CR','Detail','Matured Reverse Repurchase Order' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('236','CR','Detail','Maturity of Debt Security' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('237','CR','Detail','Individual Collection Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('238','CR','Detail','Collection of Dividends' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('239','CR','Summary','Total Bankers? Acceptance Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('240','CR','Detail','Coupon Collections - Banks' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('241','CR','Detail','Bankers? Acceptances' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('242','CR','Detail','Collection of Interest Income' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('243','CR','Detail','Matured Fed Funds Purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('244','CR','Detail','Interest/Matured Principal Payment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('245','CR','Summary','Monthly Dividends' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('246','CR','Detail','Commercial Paper' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('247','CR','Detail','Capital Change' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('248','CR','Detail','Savings Bonds Sales Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('249','CR','Detail','Miscellaneous Security Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('250','CR','Summary','Total Checks Posted and Returned' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('251','CR','Summary','Total Debit Reversals' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('252','CR','Detail','Debit Reversal' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('254','CR','Detail','Posting Error Correction Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('255','CR','Detail','Check Posted and Returned' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('256','CR','Summary','Total ACH Return Items' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('257','CR','Detail','Individual ACH Return Item' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('258','CR','Detail','ACH Reversal Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('260','CR','Summary','Total Rejected Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('261','CR','Detail','Individual Rejected Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('263','CR','Detail','Overdraft' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('266','CR','Detail','Return Item' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('268','CR','Detail','Return Item Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('270','CR','Summary','Total ZBA Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('271','CR','Summary','Net Zero-Balance Amount' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('274','CR','Detail','Cumulative** ZBA or Disbursement Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('275','CR','Detail','ZBA Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('276','CR','Detail','ZBA Float Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('277','CR','Detail','ZBA Credit Transfer' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('278','CR','Detail','ZBA Credit Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('280','CR','Summary','Total Controlled Disbursing Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('281','CR','Detail','Individual Controlled Disbursing Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('285','CR','Summary','Total DTC Disbursing Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('286','CR','Detail','Individual DTC Disbursing Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('294','CR','Summary','Total ATM Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('295','CR','Detail','ATM Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('301','CR','Detail','Commercial Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('302','CR','Summary','Correspondent Bank Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('303','CR','Summary','Total Wire Transfers In - FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('304','CR','Summary','Total Wire Transfers In - CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('305','CR','Summary','Total Fed Funds Sold' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('306','CR','Detail','Fed Funds Sold' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('307','CR','Summary','Total Trust Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('308','CR','Detail','Trust Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('309','CR','Summary','Total Value - Dated Funds' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('310','CR','Summary','Total Commercial Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('315','CR','Summary','Total International Credits – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('316','CR','Summary','Total International Credits – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('318','CR','Summary','Total Foreign Check Purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('319','CR','Summary','Late Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('320','CR','Summary','Total Securities Sold – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('321','CR','Summary','Total Securities Sold – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('324','CR','Summary','Total Securities Matured – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('325','CR','Summary','Total Securities Matured – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('326','CR','Summary','Total Securities Interest' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('327','CR','Summary','Total Securities Matured' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('328','CR','Summary','Total Securities Interest – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('329','CR','Summary','Total Securities Interest – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('330','CR','Summary','Total Escrow Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('331','CR','Detail','Individual Escrow Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('332','CR','Summary','Total Miscellaneous Securities Credits – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('336','CR','Summary','Total Miscellaneous Securities Credits – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('338','CR','Summary','Total Securities Sold' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('340','CR','Summary','Total Broker Deposits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('341','CR','Summary','Total Broker Deposits – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('342','CR','Detail','Broker Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('343','CR','Summary','Total Broker Deposits – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('344','CR','Detail','Individual Back Value Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('345','CR','Detail','Item in Brokers Deposit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('346','CR','Detail','Sweep Interest Income' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('347','CR','Detail','Sweep Principal Sell' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('348','CR','Detail','Futures Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('349','CR','Detail','Principal Payments Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('350','CR','Summary','Investment Sold' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('351','CR','Detail','Individual Investment Sold' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('352','CR','Summary','Total Cash Center Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('353','CR','Detail','Cash Center Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('354','CR','Detail','Interest Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('355','CR','Summary','Investment Interest' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('356','CR','Summary','Total Credit Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('357','CR','Detail','Credit Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('358','CR','Detail','YTD Adjustment Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('359','CR','Detail','Interest Adjustment Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('360','CR','Summary','Total Credits Less Wire Transfer and Returned Checks' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('361','CR','Summary','Grand Total Credits Less Grand Total Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('362','CR','Detail','Correspondent Collection' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('363','CR','Detail','Correspondent Collection Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('364','CR','Detail','Loan Participation' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('366','CR','Detail','Currency and Coin Deposited' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('367','CR','Detail','Food Stamp Letter' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('368','CR','Detail','Food Stamp Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('369','CR','Detail','Clearing Settlement Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('370','CR','Summary','Total Back Value Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('372','CR','Detail','Back Value Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('373','CR','Detail','Customer Payroll' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('374','CR','Detail','FRB Statement Recap' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('376','CR','Detail','Savings Bond Letter or Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('377','CR','Detail','Treasury Tax and Loan Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('378','CR','Detail','Transfer of Treasury Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('379','CR','Detail','FRB ;vernment Checks Cash Letter Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('381','CR','Detail','FRB ;vernment Check Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('382','CR','Detail','FRB Postal Money Order Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('383','CR','Detail','FRB Postal Money Order Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('384','CR','Detail','FRB Cash Letter Auto Charge Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('385','CR','Summary','Total Universal Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('386','CR','Detail','FRB Cash Letter Auto Charge Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('387','CR','Detail','FRB Fine-Sort Cash Letter Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('388','CR','Detail','FRB Fine-Sort Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('389','CR','Summary','Total Freight Payment Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('390','CR','Summary','Total Miscellaneous Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('391','CR','Detail','Universal Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('392','CR','Detail','Freight Payment Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('393','CR','Detail','Itemized Credit Over $10,000' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('394','CR','Detail','Cumulative** Credits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('395','CR','Detail','Check Reversal' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('397','CR','Detail','Float Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('398','CR','Detail','Miscellaneous Fee Refund' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('399','CR','Detail','Miscellaneous Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('400','DB','Summary','Total Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('401','DB','Summary','Total Debit Amount MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('403','DB','Summary','Today?s Total Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('405','DB','Summary','Total Debit Less Wire Transfers and Charge- Backs' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('406','DB','Summary','Debits not Detailed' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('408','DB','Detail','Float Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('409','DB','Detail','Debit (Any Type)' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('410','DB','Summary','Total YTD Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('412','DB','Summary','Total Debits (Excluding Returned Items)' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('415','DB','Detail','Lockbox Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('416','DB','Summary','Total Lockbox Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('420','DB','Summary','EDI Transaction Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('421','DB','Detail','EDI Transaction Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('422','DB','Detail','EDIBANX Settlement Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('423','DB','Detail','EDIBANX Return Item Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('430','DB','Summary','Total Payable-Through Drafts' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('435','DB','Detail','Payable-Through Draft' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('445','DB','Detail','ACH Concentration Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('446','DB','Summary','Total ACH Disbursement Funding Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('447','DB','Detail','ACH Disbursement Funding Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('450','DB','Summary','Total ACH Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('451','DB','Detail','ACH Debit Received' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('452','DB','Detail','Item in ACH Disbursement or Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('455','DB','Detail','Preauthorized ACH Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('462','DB','Detail','Account Holder Initiated ACH Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('463','DB','Summary','Corporate Trade Payment Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('464','DB','Detail','Corporate Trade Payment Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('465','DB','Summary','Corporate Trade Payment Settlement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('466','DB','Detail','ACH Settlement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('467','DB','Summary','ACH Settlement Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('468','DB','Detail','ACH Return Item or Adjustment Settlement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('469','DB','Detail','Miscellaneous ACH Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('470','DB','Summary','Total Check Paid' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('471','DB','Summary','Total Check Paid - Cumulative MTD' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('472','DB','Detail','Cumulative** Checks Paid' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('474','DB','Detail','Certified Check Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('475','DB','Detail','Check Paid' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('476','DB','Detail','Federal Reserve Bank Letter Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('477','DB','Detail','Bank Originated Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('478','DB','Summary','List Post Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('479','DB','Detail','List Post Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('480','DB','Summary','Total Loan Payments' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('481','DB','Detail','Individual Loan Payment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('482','DB','Summary','Total Bank-Originated Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('484','DB','Detail','Draft' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('485','DB','Detail','DTC Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('486','DB','Summary','Total Cash Letter Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('487','DB','Detail','Cash Letter Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('489','DB','Detail','Cash Letter Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('490','DB','Summary','Total Out;ing Money Transfers' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('491','DB','Detail','Individual Out;ing Internal Money Transfer' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('493','DB','Detail','Customer Terminal Initiated Money Transfer' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('495','DB','Detail','Out;ing Money Transfer' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('496','DB','Detail','Money Transfer Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('498','DB','Detail','Compensation' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('500','DB','Summary','Total Automatic Transfer Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('501','DB','Detail','Individual Automatic Transfer Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('502','DB','Detail','Bond Operations Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('505','DB','Summary','Total Book Transfer Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('506','DB','Detail','Book Transfer Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('507','DB','Summary','Total International Money Transfer Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('508','DB','Detail','Individual International Money Transfer Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('510','DB','Summary','Total International Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('512','DB','Detail','Letter of Credit Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('513','DB','Detail','Letter of Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('514','DB','Detail','Foreign Exchange Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('515','DB','Summary','Total Letters of Credit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('516','DB','Detail','Foreign Remittance Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('518','DB','Detail','Foreign Collection Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('522','DB','Detail','Foreign Checks Paid' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('524','DB','Detail','Commission' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('526','DB','Detail','International Money Market Trading' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('527','DB','Detail','Standing Order' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('529','DB','Detail','Miscellaneous International Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('530','DB','Summary','Total Security Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('531','DB','Detail','Securities Purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('532','DB','Summary','Total Amount of Securities Purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('533','DB','Detail','Security Collection Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('534','DB','Summary','Total Miscellaneous Securities DB - FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('535','DB','Detail','Purchase of Equity Securities' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('536','DB','Summary','Total Miscellaneous Securities Debit - CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('537','DB','Summary','Total Collection Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('538','DB','Detail','Matured Repurchase Order' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('539','DB','Summary','Total Bankers? Acceptances Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('540','DB','Detail','Coupon Collection Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('541','DB','Detail','Bankers? Acceptances' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('542','DB','Detail','Purchase of Debt Securities' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('543','DB','Detail','Domestic Collection' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('544','DB','Detail','Interest/Matured Principal Payment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('546','DB','Detail','Commercial paper' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('547','DB','Detail','Capital Change' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('548','DB','Detail','Savings Bonds Sales Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('549','DB','Detail','Miscellaneous Security Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('550','DB','Summary','Total Deposited Items Returned' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('551','DB','Summary','Total Credit Reversals' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('552','DB','Detail','Credit Reversal' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('554','DB','Detail','Posting Error Correction Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('555','DB','Detail','Deposited Item Returned' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('556','DB','Summary','Total ACH Return Items' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('557','DB','Detail','Individual ACH Return Item' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('558','DB','Detail','ACH Reversal Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('560','DB','Summary','Total Rejected Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('561','DB','Detail','Individual Rejected Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('563','DB','Detail','Overdraft' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('564','DB','Detail','Overdraft Fee' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('566','DB','Detail','Return Item' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('567','DB','Detail','Return Item Fee' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('568','DB','Detail','Return Item Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('570','DB','Summary','Total ZBA Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('574','DB','Detail','Cumulative ZBA Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('575','DB','Detail','ZBA Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('577','DB','Detail','ZBA Debit Transfer' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('578','DB','Detail','ZBA Debit Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('580','DB','Summary','Total Controlled Disbursing Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('581','DB','Detail','Individual Controlled Disbursing Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('583','DB','Summary','Total Disbursing Checks Paid - Early Amount' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('584','DB','Summary','Total Disbursing Checks Paid - Later Amount' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('585','DB','Summary','Disbursing Funding Requirement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('586','DB','Summary','FRB Presentment Estimate (Fed Estimate)' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('587','DB','Summary','Late Debits (After Notification)' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('588','DB','Summary','Total Disbursing Checks Paid-Last Amount' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('590','DB','Summary','Total DTC Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('594','DB','Summary','Total ATM Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('595','DB','Detail','ATM Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('596','DB','Summary','Total APR Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('597','DB','Detail','ARP Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('601','DB','Summary','Estimated Total Disbursement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('602','DB','Summary','Adjusted Total Disbursement' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('610','DB','Summary','Total Funds Required' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('611','DB','Summary','Total Wire Transfers Out- CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('612','DB','Summary','Total Wire Transfers Out – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('613','DB','Summary','Total International Debit – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('614','DB','Summary','Total International Debit – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('615','DB','Summary','Total Federal Reserve Bank – Commercial Bank Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('616','DB','Detail','Federal Reserve Bank – Commercial Bank Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('617','DB','Summary','Total Securities Purchased – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('618','DB','Summary','Total Securities Purchased – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('621','DB','Summary','Total Broker Debits – CHF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('622','DB','Detail','Broker Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('623','DB','Summary','Total Broker Debits – FF' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('625','DB','Summary','Total Broker Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('626','DB','Summary','Total Fed Funds Purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('627','DB','Detail','Fed Funds Purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('628','DB','Summary','Total Cash Center Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('629','DB','Detail','Cash Center Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('630','DB','Summary','Total Debit Adjustments' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('631','DB','Detail','Debit Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('632','DB','Summary','Total Trust Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('633','DB','Detail','Trust Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('634','DB','Detail','YTD Adjustment Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('640','DB','Summary','Total Escrow Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('641','DB','Detail','Individual Escrow Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('644','DB','Detail','Individual Back Value Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('646','DB','Summary','Transfer Calculation Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('650','DB','Summary','Investments Purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('651','DB','Detail','Individual Investment purchased' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('654','DB','Detail','Interest Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('655','DB','Summary','Total Investment Interest Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('656','DB','Detail','Sweep Principal Buy' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('657','DB','Detail','Futures Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('658','DB','Detail','Principal Payments Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('659','DB','Detail','Interest Adjustment Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('661','DB','Detail','Account Analysis Fee' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('662','DB','Detail','Correspondent Collection Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('663','DB','Detail','Correspondent Collection Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('664','DB','Detail','Loan Participation' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('665','DB','Summary','Intercept Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('666','DB','Detail','Currency and Coin Shipped' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('667','DB','Detail','Food Stamp Letter' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('668','DB','Detail','Food Stamp Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('669','DB','Detail','Clearing Settlement Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('670','DB','Summary','Total Back Value Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('672','DB','Detail','Back Value Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('673','DB','Detail','Customer Payroll' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('674','DB','Detail','FRB Statement Recap' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('676','DB','Detail','Savings Bond Letter or Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('677','DB','Detail','Treasury Tax and Loan Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('678','DB','Detail','Transfer of Treasury Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('679','DB','Detail','FRB ;vernment Checks Cash Letter Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('681','DB','Detail','FRB ;vernment Check Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('682','DB','Detail','FRB Postal Money Order Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('683','DB','Detail','FRB Postal Money Order Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('684','DB','Detail','FRB Cash Letter Auto Charge Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('685','DB','Summary','Total Universal Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('686','DB','Detail','FRB Cash Letter Auto Charge Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('687','DB','Detail','FRB Fine-Sort Cash Letter Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('688','DB','Detail','FRB Fine-Sort Adjustment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('689','DB','Summary','FRB Freight Payment Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('690','DB','Summary','Total Miscellaneous Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('691','DB','Detail','Universal Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('692','DB','Detail','Freight Payment Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('693','DB','Detail','Itemized Debit Over $10,000' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('694','DB','Detail','Deposit Reversal' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('695','DB','Detail','Deposit Correction Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('696','DB','Detail','Regular Collection Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('697','DB','Detail','Cumulative** Debits' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('698','DB','Detail','Miscellaneous Fees' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('699','DB','Detail','Miscellaneous Debit' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('701','Status','Principal Loan Balance' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('703','Status','Available Commitment Amount' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('705','Status','Payment Amount Due' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('707','Status','Principal Amount Past Due' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('709','Status','Interest Amount Past Due' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('720','CR','Summary','Total Loan Payment' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('721','CR','Detail','Amount Applied to Interest' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('722','CR','Detail','Amount Applied to Principal' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('723','CR','Detail','Amount Applied to Escrow' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('724','CR','Detail','Amount Applied to Late Charges' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('725','CR','Detail','Amount Applied to Buydown' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('726','CR','Detail','Amount Applied to Misc. Fees' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('727','CR','Detail','Amount Applied to Deferred Interest Detail' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('728','CR','Detail','Amount Applied to Service Charge' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, transaction_level, description ) VALUES ('760','DB','Summary','Loan Disbursement' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('890','Detail','Contains Non-monetary Information' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('900','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('901','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('902','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('903','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('904','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('905','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('906','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('907','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('908','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('909','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('910','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('911','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('912','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('913','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('914','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('915','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('916','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('917','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('918','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_level, description ) VALUES ('919','Status','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('920','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('921','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('922','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('923','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('924','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('925','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('926','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('927','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('928','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('929','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('930','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('931','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('932','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('933','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('934','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('935','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('936','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('937','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('938','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('939','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('940','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('941','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('942','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('943','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('944','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('945','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('946','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('947','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('948','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('949','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('950','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('951','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('952','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('953','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('954','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('955','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('956','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('957','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('958','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('959','CR','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('960','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('961','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('962','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('963','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('964','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('965','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('966','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('967','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('968','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('969','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('970','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('971','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('972','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('973','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('974','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('975','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('976','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('977','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('978','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('979','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('980','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('981','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('982','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('983','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('984','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('985','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('986','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('987','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('988','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('989','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('990','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('991','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('992','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('993','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('994','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('995','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('996','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('997','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('998','DB','User Defined' )
;
INSERT INTO bai_type_code ( type_code, transaction_type, description ) VALUES ('999','DB','User Defined' )
;
insert into domain_values (name, value, description) values ('function','AuthorizeConfirmMessage','Access permission to authorize a Trade Confirmation')
;
 

/* end */

update calypso_seed set seed_alloc_size=500 where seed_alloc_size <=1
;

update an_param_items /*+ PARALLEL (  an_param_items  )  */
set attribute_value = 'Volatility Strike' where attribute_value in
(select attribute_value from an_param_items where attribute_value = 'Instrument Strike' and  param_name in(
select param_name from an_param_items where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam')
)
;

update an_param_items /*+ PARALLEL (  an_param_items  )  */ set attribute_value = 'Volatility Tenor' where attribute_value in( select attribute_value from an_param_items 
where attribute_value = 'Instrument Tenor' and param_name in
(select param_name from an_param_items where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
;

update an_param_items /*+ PARALLEL (  an_param_items  )  */ set attribute_value = 'Volatility Expiry Date' where attribute_value in(
select attribute_value from an_param_items where attribute_value = 'Instrument Expiry Date'
and param_name in
(select param_name from an_param_items where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
;

update an_param_items /*+ PARALLEL (  an_param_items  )  */ set attribute_value = 'Volatility Expiry Tenor' where attribute_value in
(select attribute_value from an_param_items where attribute_value = 'Instrument Expiry Tenor'
and param_name in ( select param_name from an_param_items where attribute_name = 'MktType' 
and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
;

update an_param_items /*+ PARALLEL (  an_param_items  )  */ set attribute_value = 'Volatility Strike Type' where attribute_value in
(select attribute_value from an_param_items where attribute_value = 'Instrument Strike Type'
and param_name in ( select param_name from an_param_items
where attribute_name = 'MktType' and attribute_value = 'Volatility' and class_name = 'com.calypso.tk.risk.SensitivityParam'
))
;

CREATE OR REPLACE PROCEDURE mainent_cs
AS
BEGIN
  DECLARE
    v_menu_id VARCHAR(16);
    v_username VARCHAR(255);
    
    CURSOR c1
    IS
      SELECT property_name, user_name, property_value
        FROM main_entry_prop
       WHERE property_value = 'risk.RiskLauncherWindowShahinTest';
  BEGIN
    FOR c1_rec IN c1
    LOOP

	/* the actual value will be tiXXXAction, we need to find the XXX */

      v_menu_id := SUBSTR(c1_rec.property_name, 3, INSTR(c1_rec.property_name,'Action')-3);
      v_username := c1_rec.user_name;
                  
      /* delete all other related entries */
	  
      DELETE FROM main_entry_prop WHERE user_name = v_username AND (
              property_name = 'ti' || v_menu_id || 'Image' OR
              property_name = 'ti' || v_menu_id || 'Label'  OR
              property_name = 'ti' || v_menu_id || 'Action' OR
              property_name = 'ti' || v_menu_id || 'Tooltip' OR
              property_name = 'ti' || v_menu_id || 'Mnemonic' OR
              property_name = 'ti' || v_menu_id || 'Accelerator' 
      );
      
    /*  -- update the menus refering to this item, this could be in 4 places covered in the cases below */
         
     /* these can look like _tiXXX, could be at the middle */
	 
      UPDATE main_entry_prop set property_value = REPLACE(property_value, ' ti' || v_menu_id || ' ', ' ') WHERE user_name = v_username AND property_value like '% ti' || v_menu_id || ' %';
      
     /* -- or in the beginning */
      UPDATE main_entry_prop set property_value = REPLACE(property_value, 'ti' || v_menu_id || ' ', '') WHERE user_name = v_username AND property_value like 'ti' || v_menu_id || ' %';
      
      /*-- or at the end */
      UPDATE main_entry_prop set property_value = REPLACE(property_value, ' ti' || v_menu_id, '') WHERE user_name = v_username AND property_value like '% ti' || v_menu_id;
      
      /*-- or the only entry */
	  
      UPDATE main_entry_prop set property_value = REPLACE(property_value, 'ti' || v_menu_id, '') WHERE user_name = v_username AND property_value = 'ti' || v_menu_id;
      
    END LOOP;
  END;
END;
/
BEGIN
  mainent_cs;
END;
/

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
;

/* CAL-121475 */


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
        EXECUTE IMMEDIATE 'CREATE TABLE  psheet_pricer_measure_prop ( USER_NAME VARCHAR2(64) NOT NULL,
                NAME VARCHAR2(128) NOT NULL,
                IS_DISPLAY  number NOT NULL,
                DISPLAY_CURRENCY VARCHAR2(32) NOT NULL ,
                DISPLAY_COLOR  VARCHAR2(32) NOT NULL,
                PROPERTY_ORDER NUMBER(38) NOT NULL)';
     
    END IF;
END add_table;
;

BEGIN
add_table('psheet_pricer_measure_prop');
END;
;

UPDATE psheet_pricer_measure_prop SET display_currency = ' '
;
DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'Fader'
;
DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'European Range Binary'
;

/* Fix for oracle bug */



DELETE FROM DOMAIN_VALUES WHERE NAME = 'plMeasure' AND VALUE IN (
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
;
/* CAL-122902 */
create index trade_date_idx on bo_transfer (trade_date)
;

 
/* CAL-122609 */

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
        EXECUTE IMMEDIATE 'CREATE TABLE  prod_xml_dat(	product_id   INTEGER NOT NULL, 
		xprod_conf_id INTEGER NOT NULL, xml_dat    CLOB)';

	EXECUTE IMMEDIATE 'ALTER TABLE prod_xml_dat add CONSTRAINT  pk_prod_xdat PRIMARY KEY (product_id)';
    
    END IF;
END add_table;
;

BEGIN
add_table('prod_xml_dat');
END;
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
        EXECUTE IMMEDIATE 'CREATE TABLE  xprod_config( 	xprod_conf_id 	   INTEGER NOT NULL,
		xprod_conf_name    VARCHAR(64) NOT NULL,
		product_type       VARCHAR(64) NOT NULL,
		ui_xml_defn         CLOB,
		data_xml_defn       CLOB,
		render_main_b	    CHAR(1) NOT NULL,
		version_num        INTEGER NULL)';

	EXECUTE IMMEDIATE 'ALTER TABLE xprod_config add CONSTRAINT pk_xprod_config PRIMARY KEY (xprod_conf_id)';
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX un_xprod_conf_name  ON xprod_config  (xprod_conf_name)';
    
    END IF;
END add_table;
;

BEGIN
add_table('xprod_config');
END;
;
  
INSERT INTO domain_values(name,value,description)
VALUES('function','CreateXProdConfig','Access permisssion to create/modify XProd Configuration')
;

INSERT INTO domain_values(name,value,description)
VALUES('function','RemoveXProdConfig','Access permission to remove XProd Configuration')
;

INSERT INTO  domain_values (name,value,description)
VALUES ('function','XProdConfigAccess','Access permission to access XProd Configuration')
;

INSERT INTO  domain_values (name,value,description)
VALUES ('function','ModifyXProdConfig','Access permission to create/modify/delete XProd Configuration')
;

/* CAL-123378 */
update entity_attributes set attr_value = 'MarketIndex' where entity_type = 'Fund' and attr_name = 'Benchmark_Type' and attr_value = 'Market_Index' 
;
update entity_attributes set attr_value = 'RateIndex' where entity_type = 'Fund' and attr_name = 'Benchmark_Type' and attr_value = 'Rate_Index'
;

/* CAL-125732  */
DELETE FROM DOMAIN_VALUES WHERE value ='HISTO_CUMULATIVE_CASH_INTEREST'
;

/* CAL-124201 */
 
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
        EXECUTE IMMEDIATE 'CREATE TABLE  product_cash_flow_leg ( product_id number NOT NULL,
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
    END IF;
END add_table;
/

BEGIN
add_table('product_cash_flow_leg');
END;
/

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
	execute immediate ' alter table product_cash_flow_leg rename to prod_cash_flow_leg_bak';    
    END IF;
END add_table;
/

BEGIN
add_table('product_structured_flows');
END;
/
 
update /*+ parallel( product_desc ) */ product_desc
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update /*+ parallel( bo_audit_fld_map ) */ bo_audit_fld_map 
set product_type='StructuredFlows'
where product_type='CashFlowLeg'
;

update /*+ parallel( bo_message ) */ bo_message
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update /*+ parallel( bo_message_hist ) */  bo_message_hist
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update /*+ parallel( bo_transfer ) */ bo_transfer
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update /*+ parallel( bo_transfer_hist ) */ bo_transfer_hist
set product_type='StructuredFlows', product_family='StructuredFlows'
where product_type='CashFlowLeg'
;

update /*+ parallel( pricing_sheet_cfg ) */  pricing_sheet_cfg
set product_type='StructuredFlows'
where product_type='CashFlowLeg'
;
 
update main_entry_prop
set property_value='tws.CalypsoWorkstation'
where property_value like 'tws.TraderWorkstation'
;
 
delete from domain_values where name='horizonFundingPolicy' and value='Daily'
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','autoFeedInternalRefTerminationType','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('autoFeedInternalRefTerminationType','Novation','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','autoFeedExternalRefTerminationType','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('autoFeedExternalRefTerminationType','Novation','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StructuredFlows.subtype','Types of StructuredFlows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productType','StructuredFlows','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('productTypeReportStyle','StructuredFlows','StructuredFlows ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('domainName','StructuredFlows.Pricer','Pricers for StructuredFlows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('StructuredFlows.Pricer','PricerStructuredFlows','' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ('measuresForAdjustment','TD_ACCRUAL_BS','' )
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (50,1,'hedge_relationship_config','hedge_relationship_config_id','1','hedged_sd_filter','HedgeRelationshipConfig','apps.refdata.HedgeRelationshipConfigWindow','Hedge Relationship Configuration' )
;
INSERT INTO referring_object ( rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc ) VALUES (51,1,'hedge_relationship_config','hedge_relationship_config_id','1','hedge_sd_filter','HedgeRelationshipConfig','apps.refdata.HedgeRelationshipConfigWindow','Hedge Relationship Configuration' )
;
create table report_template_bk as select * from report_template
;
delete from report_template WHERE report_type = 'RiskAggregation' and is_hidden = 1 and template_id NOT IN (SELECT report_template_id from tws_risk_aggregation_node)
;
/* SP2 scripts */


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
        EXECUTE IMMEDIATE 'create table ref_basket_credit_evnt_map(
         ref_entity_id numeric not null ,
        event_type varchar2(32) not null ,
        event_source varchar2(32) not null ,
        amount float null ,
        currency varchar2(3) null ,
        rating_value varchar2(12) null ,
        ref_asset_id numeric null ,
        additional_info varchar2(128) null ,
        grace_period_b numeric not null ,
        grace_period_days numeric null ,
        grace_period_bus_b numeric not null ,
        grace_period_hol varchar2(128) null )';
     
    END IF;
END add_table;
/

BEGIN
add_table('ref_basket_credit_evnt_map');
END;
/

begin
add_column_if_not_exists  ('ref_basket_credit_evnt_map','multiple_holder_b', 'numeric default 0 not null');
end;
/


update /*+ parallel( group_access ) */  group_access set access_id = access_id - 1 where access_id >  41 
;
/* end */

/*  Update Version */
UPDATE calypso_info
    SET major_version=12,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('2/11/2011','DD/MM/YYYY')
;

 
