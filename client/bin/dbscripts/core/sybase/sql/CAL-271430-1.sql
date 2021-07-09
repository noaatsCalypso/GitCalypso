begin
declare @today datetime
declare @day varchar(20)
declare @businessday datetime
 begin
	select @today=maturity_date from swap_leg 
    select @day = datename(dw,convert(varchar(10),dateadd(dd,-1,dateadd(mm,1,dateadd(dd,-(day(@today)-1),@today))),101)) from swap_leg 
	select @day 
	if @day = ('Saturday')
	begin
		select 2
		select @businessday = convert(varchar(10),dateadd(dd,-2,dateadd(mm,1,dateadd(dd,-(day(@today)-1),@today))),101) from swap_leg 
		update swap_leg set rolling_day=31,custom_rol_day_b=1 where coupon_stub_rule='SPECIFIC FIRST' and first_stub_date is not null and rolling_day=0 
		and  maturity_date = @businessday
	end
	else if @day =('Sunday')
	begin
		select 3
		select @businessday = convert(varchar(10),dateadd(dd,-3,dateadd(mm,1,dateadd(dd,-(day(@today)-1),@today))),101) from swap_leg 
		update swap_leg set rolling_day=31,custom_rol_day_b=1 where coupon_stub_rule='SPECIFIC FIRST' and first_stub_date is not null and rolling_day=0 
		and  maturity_date = @businessday
	end
	else if @day != 'Saturday' or @day != 'Sunday'
	begin
		update swap_leg set rolling_day=31,custom_rol_day_b=1 where coupon_stub_rule='SPECIFIC FIRST' and first_stub_date is not null and rolling_day=0 
		and  maturity_date = convert(varchar(10),dateadd(dd,-1,dateadd(mm,1,dateadd(dd,-(day(@today)-1),@today))),101) 
	end
  end
 end
go

/* all sqls should go between these comments */

/* Data Model Changes BEGIN */



if not exists (select 1 from sysobjects where name='collateral_context' and type='U')
begin
	exec ('create table collateral_context (id numeric not null ,
version numeric not null ,
name varchar(128),
is_default numeric not null ,
description varchar(256),
currency varchar(3),
attributes image,
value_date_days numeric not null ,
underlying_template_id numeric not null ,
interest_template_id numeric not null ,
position_template_id numeric not null ,
allocation_template_id numeric not null ,
position_aggregation varchar(64))
')
end 
go

add_column_if_not_exists 'cu_swap','fx_reset_b','numeric null'
go
add_column_if_not_exists 'cu_swap','fx_reset_id','numeric null'
go
add_column_if_not_exists 'cu_swap','fx_reset_leg_id','numeric  null'
go
add_column_if_not_exists 'cu_basis_swap','fx_reset_b','numeric  null'
go
add_column_if_not_exists 'cu_basis_swap','fx_reset_id','numeric  null'
go
add_column_if_not_exists 'cu_basis_swap','fx_reset_leg_id','numeric  null'
go
add_column_if_not_exists 'cu_basis_swap','spread_on_leg_id','numeric  null'
go

update cu_swap set fx_reset_b=0 where fx_reset_b is null
go
update cu_swap set fx_reset_id=0 where fx_reset_id is null
go
update cu_swap set fx_reset_leg_id=0 where fx_reset_leg_id is null
go
update cu_basis_swap set fx_reset_b=0 where fx_reset_b is null
go
update cu_basis_swap set fx_reset_id=0 where fx_reset_id is null
go
update cu_basis_swap set fx_reset_leg_id=0 where fx_reset_leg_id is null
go
update cu_basis_swap set spread_on_leg_id=0 where spread_on_leg_id is null
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
UPDATE psheet_pricer_measure_prop SET display_currency = ' '
go
DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'Fader'
go

DELETE FROM user_viewer_column WHERE uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' AND column_name = 'European Range Binary'
go
add_column_if_not_exists 'commodity_reset','quote_type','varchar(63) null'
go
UPDATE commodity_reset SET quote_type='Price' where quote_type is null
go

add_domain_values 'function','AuthorizeConfirmMessage','Access permission to authorize a Trade Confirmation'
go



/* CAL-122375 */
add_column_if_not_exists 'fund','benchmark_type','varchar(15) null'
go
add_column_if_not_exists 'fund','benchmark_ref_id','numeric null'
go
add_column_if_not_exists 'fund','benchmark_spread','float default 0.0 not null'
go

create procedure FundBenchmark
as
begin
declare @entityid numeric 
declare @benchmarkId numeric 
declare @benchmarkSpread float 
declare entityCur cursor
for
select entity_id from entity_attributes where entity_type = 'Fund' and attr_value = 'MarketIndex' or attr_value = 'Market_Index'
open entityCur
fetch entityCur into @entityid 
while (@@sqlstatus=0)
begin 
	select @benchmarkId=convert(numeric,attr_value) FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = @entityid and attr_name = 'Benchmark_Id'
	
	SELECT @benchmarkSpread=convert(numeric,attr_value) FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = @entityid and attr_name = 'Benchmark Spread'
	
	UPDATE fund SET fund.benchmark_type = 'MarketIndex' WHERE @entityid = fund.fund_id
	UPDATE fund SET fund.benchmark_ref_id = @benchmarkId WHERE @entityid = fund.fund_id
	UPDATE fund SET fund.benchmark_spread = @benchmarkSpread WHERE @entityid = fund.fund_id
fetch entityCur into @entityid
End
close entityCur 
deallocate cursor entityCur

declare entityCur1 cursor
for 
select entity_id from entity_attributes where entity_type = 'Fund' and attr_value = 'Carve-out'
open entityCur1
fetch entityCur1 into @entityid 
while (@@sqlstatus=0)
begin 
	SELECT @benchmarkId=convert(numeric,attr_value) FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = @entityid and attr_name = 'Benchmark_Id'

	SELECT @benchmarkSpread=convert(numeric,attr_value) FROM entity_attributes 
	WHERE entity_type = 'Fund' and entity_id = @entityid and attr_name = 'Benchmark Spread'

	UPDATE fund SET fund.benchmark_type = 'Carve-out' WHERE @entityid = fund.fund_id
	UPDATE fund SET fund.benchmark_ref_id = @benchmarkId where @entityid = fund.fund_id
	UPDATE fund SET fund.benchmark_spread = @benchmarkSpread where @entityid = fund.fund_id
	
fetch entityCur1 into @entityid
End
close entityCur1 
deallocate cursor entityCur1

declare entityCur2 cursor
for
select entity_id  from entity_attributes where entity_type = 'Fund' and attr_value = 'Rate_Index' or attr_value = 'RateIndex'
declare @rateIndex varchar(255)
declare @quoteName varchar(255)
open entityCur2
fetch entityCur2 into @entityid 
while (@@sqlstatus=0)
begin
	SELECT @rateIndex=entity_attributes.attr_value FROM entity_attributes 
	WHERE entity_attributes.entity_type = 'Fund' and entity_attributes.entity_id = @entityid and entity_attributes.attr_name = 'Benchmark_Id'

	select @quoteName = 'MM.'+ STR_REPLACE(@rateIndex, '/', '.')

	SELECT @benchmarkId=rate_index.rate_index_id  from rate_index WHERE rate_index.quote_name = @quoteName

	SELECT @benchmarkSpread=convert(numeric,entity_attributes.attr_value) FROM entity_attributes
	WHERE entity_type = 'Fund' AND entity_id = @entityid and entity_attributes.attr_name = 'Benchmark Spread'
	UPDATE fund SET fund.benchmark_type = 'RateIndex' WHERE @entityid = fund.fund_id
	UPDATE fund SET fund.benchmark_ref_id = @benchmarkId WHERE @entityid = fund.fund_id
	UPDATE fund SET fund.benchmark_spread = @benchmarkSpread WHERE @entityid = fund.fund_id
	fetch entityCur2 into @entityid
End
close entityCur2 
deallocate cursor entityCur2

end
go

exec FundBenchmark
go
drop procedure FundBenchmark
go

/* end */
/* Histo measure computation was refactored and some classes are deprecated*/

update pricer_measure set measure_class_name='tk.core.PricerMeasure' where measure_class_name IN ('tk.pricer.PricerMeasureHistoricalCumulativeCash','tk.pricer.PricerMeasureHistoricalAccrualBO','tk.pricer.PricerMeasureHistoricalCumulativeCash','tk.pricer.PricerMeasureHistoBS','tk.pricer.PricerMeasureHistoricalCumulativeCash')
go

update pricer_measure set measure_class_name='tk.core.PricerMeasure' where measure_name='HISTO_UNSETTLED_FEES' and measure_class_name='tk.pricer.PricerMeasureUnsettledFees'
go

update pricer_measure set measure_class_name='tk.core.PricerMeasure' where measure_name='HISTO_UNSETTLED_CASH' and measure_class_name='tk.pricer.PricerMeasureUnsettledCash'
go
/* end */

/* CAL-125732  */
DELETE FROM domain_values WHERE value ='HISTO_CUMULATIVE_CASH_INTEREST'
go

/* CAL-123006 */
add_domain_values 'domainName','CreditDefaultSwapCoupon.BulletLCDS','Fixed coupons (bps) for standard LCDS'
go
add_domain_values 'CreditDefaultSwapCoupon.BulletLCDS','0',''
go
add_domain_values 'CreditDefaultSwapCoupon.BulletLCDS','100',''
go
add_domain_values 'CreditDefaultSwapCoupon.BulletLCDS','250',''
go
add_domain_values 'CreditDefaultSwapCoupon.BulletLCDS','500',''
go

update main_entry_prop
set property_value='tws.CalypsoWorkstation'
where property_value like 'tws.TraderWorkstation'
go

select * into pc_discount_bak from pc_discount
go

create table t1 (desc_name varchar(255) null, product_type varchar(255)  null, sub_type varchar(255)  null, ext_type varchar(255)  null, rate_idx_name varchar(255)  null,rate_index_tenor varchar(255)  null )
go


update pc_discount set domiciliation='ANY'
go


if exists (select 1 from sysobjects where name ='reparse_table' and type='P')
begin
exec ('drop procedure reparse_table')
end
go

create procedure reparse_table
as
declare @col1 varchar(255), @i int,@parseval varchar(255),@col2 varchar(255), @j int, @parseval1 varchar(255),@k int ,@parseval2 varchar(225) ,@col3 varchar(255), 
@h int , @col4 varchar(255) ,@parseval3 varchar(255),
@col5 varchar(255), @n int , @parseval4 varchar(255)

declare cur_main cursor for
select desc_name from pc_discount
open cur_main
fetch cur_main into @parseval
while (@@sqlstatus = 0)
begin
	select @i = charindex('.',@parseval) 
	if @i > 1
    begin 
	select @i = charindex('.',@parseval)
	select @col1 = substring(@parseval,1,@i-1)
	end
	
	select @parseval1 = substring (@parseval,@i+1,len(@parseval))
	select @j = charindex('.',@parseval1)
	
	if @j > 1 
	begin
	select @col2 = substring(@parseval1,1,@j-1)
	end
	
	select @parseval2 = substring (@parseval1, @j+1 , len(@parseval1))
	select @k = charindex('.',@parseval2)
	
	if @k > 1 
	begin
	select @col3 = substring(@parseval2,1,@k-1)
	end
	select @parseval3 = substring (@parseval2, @k+1 , len(@parseval2))
	select @h = charindex('.',@parseval3)
	if @h > 1
	begin
	select @col4 = substring (@parseval3,1,@h-1)
	end
    
	select @parseval4 = substring (@parseval3, @h+1 , len(@parseval3))
	select @n = charindex('.',@parseval4)
	select @n
	if @n = 0 
	begin
	select @col5 = @parseval4
	end 

	insert into t1 values (@parseval,@col1,@col3,@col2,@col4,@col5)
fetch cur_main into @parseval
end
close cur_main
deallocate cursor cur_main
go

exec reparse_table
go

drop procedure reparse_table
go

UPDATE pc_discount
SET p.product_type = t.product_type
FROM pc_discount p,t1 t
WHERE p.desc_name = t.desc_name
go

UPDATE pc_discount
SET p.sub_type = t.sub_type
FROM pc_discount p,t1 t
WHERE p.desc_name = t.desc_name
go

UPDATE pc_discount
SET p.ext_type = t.ext_type
FROM pc_discount p,t1 t
WHERE p.desc_name = t.desc_name
go

UPDATE pc_discount
SET p.rate_idx_name = t.rate_idx_name
FROM pc_discount p,t1 t
WHERE p.desc_name = t.desc_name
go

UPDATE pc_discount
SET p.rate_index_tenor = t.rate_index_tenor
FROM pc_discount p,t1 t
WHERE p.desc_name = t.desc_name
go

/* CAL-126435 */
add_column_if_not_exists 'mrgcall_config' ,'discount_currency','varchar(32) null'
go

UPDATE mrgcall_config SET mrgcall_config.discount_currency =
(SELECT currency_code FROM mrgcall_config_currency WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def AND mrgcall_config_currency.mrg_call_def in 
(select mrgcall_config.mrg_call_def FROM mrgcall_config, mrgcall_config_currency WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def 
GROUP BY mrgcall_config.mrg_call_def
HAVING count(mrgcall_config.mrg_call_def) = 1  )) WHERE mrgcall_config.discount_currency is NULL 
go

delete from domain_values where name='horizonFundingPolicy' and value='Daily'
go

INSERT INTO pricing_param_name(param_name, param_type, param_domain, param_comment, is_global_b, default_value) 
VALUES ('FORMULA_MIXING_METHOD','java.lang.String','STATIC_MIXING,SPREAD_MIXING,EXP_LOSS_MIXING,NAME_MIXING',
'Specifies the correlation formula mixing method',1,'STATIC_MIXING' )
go

add_domain_values 'leAttributeType','INDEX_FAMILY',''
go

INSERT INTO product_code (product_code,code_type,unique_b,searchable_b,mandatory_b,product_list,version_num)
VALUES ('INDEX_FAMILY','string',0,0,0,'CDSIndex',0)
go

/* Changes to PLMark and Associated Functionality */
add_column_if_not_exists 'pl_mark','mark_type' ,'varchar(32) null'
go
update pl_mark set mark_type='WAC' where mark_id in (select mark_id from pl_mark_value 
where mark_name in ('PREM_DISC_FACTOR','PREM_DISC_YIELD_FACTOR'))
go

update pl_mark set mark_type='FX' where mark_id in(select mark_id from pl_mark_value where mark_name in ('PriIntAccrual','SecIntAccrual','PriClosingPosition','SecClosingPosition','FXAllInRate','FXRateToBaseCcy','ClosingPosition'))
go
/* end */ 

update an_viewer_config set viewer_class_name='apps.risk.ScenarioRiskAnalysisViewer' where analysis_name='Scenario'
go

update main_entry_prop set property_value = 'risk.RiskDesignerParamViewer' where property_value = 'risk.ScenarioRiskDesigner'
go

UPDATE product_basket SET multiply_traded_b=0
WHERE product_basket.product_id in
(
SELECT product_basket.product_id FROM product_basket
INNER JOIN basket_info
ON product_basket.product_id = basket_info.basket_id
) 
go

if not exists (select 1 from sysobjects where name ='report_template_bk')
begin
exec ('select * into report_template_bk from report_template')
end
go
DELETE from report_template WHERE report_type = 'RiskAggregation' and is_hidden = 1 and template_id NOT IN (SELECT report_template_id from tws_risk_aggregation_node)
go 

UPDATE group_access SET access_id=37, access_value='BookBundle.'+access_value WHERE access_id=21
go
UPDATE perm_book_currency SET book_bundle='BookBundle.'+book_bundle WHERE book_bundle NOT LIKE '%.%'
go
UPDATE perm_book_cur_pair SET book_bundle='BookBundle.'+book_bundle WHERE book_bundle NOT LIKE '%.%'
go
UPDATE perm_book_product SET book_bundle='BookBundle.'+book_bundle WHERE book_bundle NOT LIKE '%.%'
go


/* CAL-130455 set standard_contract_type to FUNDED for funded CDSNthLoss */
add_column_if_not_exists 'product_cds','standard_contract_type','varchar(32) null'
go

update product_cds set standard_contract_type = 'FUNDED'
where standard_contract_type is null and product_id in
(select pd.product_id from product_desc pd, swap_leg sl
where pd.product_type='CDSNthLoss' and pd.product_id = sl.product_id
and (sl.act_final_exch_b = 1 or sl.act_initial_exch_b = 1))
go

/* set standard_contract_type to UNFUNDED for any other remaining CDSNthLoss */
update product_cds set standard_contract_type = 'UNFUNDED'
where standard_contract_type is null and product_id in
(select pd.product_id from product_desc pd where pd.product_type='CDSNthLoss')
go

update group_access set access_id = access_id - 1 where access_id >  41 
go


UPDATE product_equity SET exchange_id = legal_entity.legal_entity_id FROM legal_entity WHERE legal_entity.short_name = product_equity.exchange_code AND product_equity.exchange_id = 0
go


/* CAL-138503 From now mark_procedure AUTO requires a not null auto_mark_type */
update product_seclending set auto_mark_type = 'Internal' where mark_procedure='AUTO' and auto_mark_type is null
go

/* CAL-130257 */

/* step 0 */ 
if not exists (select 1 from sysobjects where name='trfilter_minmax_dtbak')
begin
exec('select * into trfilter_minmax_dtbak from trfilter_minmax_dt')
end
go

if not exists (select 1 from sysobjects where name='trfilter_minmax_dtbak')
begin
exec('select * into trade_filter_critbak  from trade_filter_crit')
end
go

add_column_if_not_exists 'trfilter_minmax_dt','date_operator','varchar(128) null'
go

if exists ( select 1 from sysobjects where name='trade_filter_to_dt')
begin
exec('drop procedure trade_filter_to_dt')
end
go

create procedure trade_filter_to_dt
as
	begin
		declare @trade_filter_name  varchar(255)
		declare @settle_date_min datetime, 
		@settle_date_max datetime ,  
		@setledt_tenor_max numeric , 
		@setledt_tenor_min numeric 
		declare cur_main cursor 
		for
			select trade_filter_name,settle_date_min,settle_date_max, setledt_tenor_max,setledt_tenor_min from trade_filter where settle_date_min is not null or settle_date_max is not null or (setledt_tenor_max is not null and setledt_tenor_max <> 360000)
			or (setledt_tenor_min is not null and setledt_tenor_min <> 360000)
		open cur_main
		fetch cur_main into @trade_filter_name , @settle_date_min , @settle_date_max ,@setledt_tenor_max, @setledt_tenor_min 
			while (@@sqlstatus = 0)
			begin
				insert into trfilter_minmax_dt (criterion_name,trade_filter_name,date_min,date_max,tenor_max,tenor_min, time_min, time_max) 
				values ('SettleDate', @trade_filter_name , @settle_date_min , @settle_date_max ,@setledt_tenor_max, @setledt_tenor_min , -1, -1)
		fetch cur_main into @trade_filter_name , @settle_date_min , @settle_date_max ,@setledt_tenor_max, @setledt_tenor_min 
	end	
	close cur_main
	deallocate cursor cur_main
end
go


if exists ( select 1 from sysobjects where name='trade_filter_to_dt1')
begin
exec('drop procedure trade_filter_to_dt1')
end
go
create procedure trade_filter_to_dt1
as
	begin
	declare @settle_date_max datetime ,
	@trade_filter_name  varchar(255), 
	@mat_date_min datetime , @mat_date_max datetime , @matdt_tenor_max numeric , 
	@matdt_tenor_min numeric  
	declare cur_main1 cursor 
	for
		select trade_filter_name, mat_date_min , mat_date_max ,matdt_tenor_max,matdt_tenor_min 
		from trade_filter where mat_date_min is not null 
		or mat_date_max is not null 
		or (matdt_tenor_max is not null and matdt_tenor_max <> 360000)
		or (matdt_tenor_min is not null and matdt_tenor_min <> 360000)
	open cur_main1
	fetch cur_main1 into @trade_filter_name , @mat_date_min  , @mat_date_max  , @matdt_tenor_max , @matdt_tenor_min 
		while (@@sqlstatus = 0)
	begin
		insert into trfilter_minmax_dt (criterion_name,trade_filter_name,date_min,date_max, tenor_max, tenor_min, time_min, time_max) 
		values ('MaturityDate',@trade_filter_name , @mat_date_min , @mat_date_max ,@matdt_tenor_max, @matdt_tenor_min , -1, -1)
		fetch cur_main1 into @trade_filter_name , @mat_date_min  , @mat_date_max  , @matdt_tenor_max , @matdt_tenor_min 
	end	
	close cur_main1
	deallocate cursor cur_main1
end
go

/* step 3 */
/* 
is not required in the dbscripts remove the columns from the schemaBase.xml and the executesql synchronise will take care of the rest
*/
if exists ( select 1 from sysobjects where name='trade_filter_to_dt2')
begin
exec('drop procedure trade_filter_to_dt2')
end
go
create procedure trade_filter_to_dt2
as
begin
	declare @trade_filter_name  varchar(255), @x numeric 
	declare cur_main cursor 
	for
select distinct trade_filter_name from trade_filter 
	open cur_main
	fetch cur_main into @trade_filter_name 
	while (@@sqlstatus=0)
		begin
			select @x = count(*) from trfilter_minmax_dt where criterion_name='TradeDate' and trade_filter_name=@trade_filter_name
			if @x=0  
			begin
			insert into trfilter_minmax_dt (trade_filter_name, criterion_name , date_operator, time_min, time_max, tenor_min, tenor_max) values (@trade_filter_name ,'TradeDate','Is On Or Before',-1,-1,360000,360000)
			end
			fetch cur_main into @trade_filter_name
		end	
	close cur_main
	deallocate cursor cur_main
end
go

if exists ( select 1 from sysobjects where name='trade_filter_to_dt3')
begin
exec('drop procedure trade_filter_to_dt3')
end
go
create procedure trade_filter_to_dt3
as
begin	
declare @trade_filter_name  varchar(255),@x numeric
declare cur_main1 cursor 
	for
select trade_filter.trade_filter_name from trade_filter , trade_filter_crit where trade_filter.trade_filter_name=trade_filter_crit.trade_filter_name and
trade_filter_crit.criterion_name ='CURRENTMONTH_CRITERIA' and trade_filter_crit.criterion_value='MATURITY_DATE'and
trade_filter_crit.is_in_b=1 
		open cur_main1
		fetch cur_main1 into @trade_filter_name 
	while (@@sqlstatus = 0)
		begin
		select @x= count(*) from trfilter_minmax_dt where trade_filter_name=@trade_filter_name and (criterion_name='MaturityDateOrNone' or criterion_name='MaturityDate')
			if @x=0  
			begin
			insert into trfilter_minmax_dt (trade_filter_name, criterion_name , date_operator, time_min, time_max, tenor_min, tenor_max) values (@trade_filter_name ,'FinalValuationDate','Within current month',-1,-1,360000,360000)
			end
			fetch cur_main1 into @trade_filter_name
		end	
	close cur_main1
	deallocate cursor cur_main1
end
go

if exists ( select 1 from sysobjects where name='trade_filter_to_dt4')
begin
exec('drop procedure trade_filter_to_dt4')
end
go
create procedure trade_filter_to_dt4
as
begin	
	declare @trade_filter_name  varchar(255),@x numeric
	declare cur_main2 cursor 
	for
select trade_filter.trade_filter_name from trade_filter , trade_filter_crit where trade_filter.trade_filter_name=trade_filter_crit.trade_filter_name and
trade_filter_crit.criterion_name ='NULL_MATURITY_CRITERIA' and trade_filter_crit.criterion_value='NO' and
trade_filter_crit.is_in_b=1
		open cur_main2
		fetch cur_main2 into @trade_filter_name 
	while (@@sqlstatus = 0)
		begin
		select @x=count(*) from trfilter_minmax_dt where trade_filter_name=@trade_filter_name and (criterion_name='MaturityDateOrNone' or criterion_name='MaturityDate')
			IF @x=0 
			begin
	insert into trfilter_minmax_dt (trade_filter_name, criterion_name , date_operator, time_min, time_max, tenor_min, tenor_max) values (@trade_filter_name ,'FinalValuationDate','Is not null',-1,-1,360000,360000)
			end
			fetch cur_main2 into @trade_filter_name
		end	
end
go

if exists ( select 1 from sysobjects where name='trade_filter_to_dt5')
begin
exec('drop procedure trade_filter_to_dt5')
end
go
create procedure trade_filter_to_dt5
as
begin	
	declare @trade_filter_name  varchar(255),@x numeric
	declare cur_main2 cursor 
	for
	select trade_filter_name from trfilter_minmax_dt where criterion_name='MaturityDateOrNone'
		open cur_main2
		fetch cur_main2 into @trade_filter_name 
	while (@@sqlstatus = 0)
		begin
		select @x=count(*) from trade_filter_crit where criterion_name='includeNull' and trade_filter_name=@trade_filter_name and criterion_value='FinalValuationDate'
			IF @x=0 
			begin
			insert into trade_filter_crit (trade_filter_name , criterion_name, criterion_value, is_in_b ) values (@trade_filter_name,'includeNull','FinalValuationDate',1)
			end
			fetch cur_main2 into @trade_filter_name
		end	
end
go

if exists ( select 1 from sysobjects where name='trade_filter_to_dt6')
begin
exec('drop procedure trade_filter_to_dt6')
end
go

create procedure trade_filter_to_dt6
as
begin
declare cur_main1 cursor 
for
select date_min , tenor_min ,trade_filter_name from trfilter_minmax_dt where criterion_name='PositionSettleDate' 
declare @date_min datetime, @tenor_min numeric, @trade_filter_name  varchar(255)
open cur_main1
fetch cur_main1 into @date_min , @tenor_min ,@trade_filter_name 
while (@@sqlstatus=0)
begin
	update trfilter_minmax_dt set date_max=@date_min , tenor_max=@tenor_min , date_min=null , tenor_min=null , date_operator='Is After' where criterion_name='PositionSettleDate' and  trade_filter_name=@trade_filter_name
fetch cur_main1 into @date_min , @tenor_min ,@trade_filter_name 
end	
close cur_main1
deallocate cursor cur_main1
end
go

add_column_if_not_exists 'product_desc','final_valuation_date','datetime null'
go


if exists (select 1 from sysobjects o , syscolumns c where o.name ='trfilter_minmax_dt' and c.name='date_operator')
begin 
declare @x   numeric
select @x= count(date_operator) from trfilter_minmax_dt
if @x = 0 
begin 
update trfilter_minmax_dt set date_operator = 'Is On Or Before'  where criterion_name in ('UpdateDate','TradeDate','EnteredDate','MaturityDateOrNone') 
and ((date_max is not null) or (tenor_max is not null and tenor_max <> 360000))

update trfilter_minmax_dt set date_operator = 'Is On Or After'  where criterion_name in ('UpdateDate','TradeDate','EnteredDate','MaturityDateOrNone')  
and ((date_min is not null) or (tenor_min is not null and tenor_min <> 360000))

update trfilter_minmax_dt set date_operator = 'Is Between' where criterion_name in ('UpdateDate','TradeDate','EnteredDate','MaturityDateOrNone') 
and ((date_max is not null and date_min is not null ) or (
(tenor_min is not null and tenor_min <> 360000)and (tenor_max is not null and tenor_max <> 360000)))

update trfilter_minmax_dt set date_operator = 'Is On Or Before' 
where criterion_name in ('TransferDate','TerminationDate','EXERCISED_DATETIME','TransferEffectiveDate','TerminationEffectiveDate')
and ((date_max is not null) or (tenor_max is not null and tenor_max <> 360000))

update trfilter_minmax_dt set date_operator = 'Is On Or After' 
where criterion_name in ('TransferDate','TerminationDate','EXERCISED_DATETIME','TransferEffectiveDate','TerminationEffectiveDate')
and ((date_min is not null) or (tenor_min is not null and tenor_min <> 360000))

update trfilter_minmax_dt set date_operator = 'Is Between' where criterion_name in ('TransferDate','TerminationDate','EXERCISED_DATETIME','TransferEffectiveDate','TerminationEffectiveDate')
and ((date_max is not null and date_min is not null ) or (
(tenor_min is not null and tenor_min <> 360000)and (tenor_max is not null and tenor_max <> 360000)))

exec trade_filter_to_dt
exec trade_filter_to_dt1

update trfilter_minmax_dt set date_operator ='Is On Or Before'
where trade_filter_name in  (select t.trade_filter_name  
from  trfilter_minmax_dt t , trade_filter tf 
where (tf.settle_date_max is not null 
or (tf.setledt_tenor_max is not null and tf.setledt_tenor_max <> 360000))
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='SettleDate'
) 
and criterion_name='SettleDate'


update trfilter_minmax_dt set date_operator ='Is On Or After'
where trade_filter_name in  (select t.trade_filter_name  from trade_filter tf , trfilter_minmax_dt t 
where (tf.settle_date_min is not null 
or (tf.setledt_tenor_min is not null and tf.setledt_tenor_min <> 360000))
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='SettleDate')   
and criterion_name='SettleDate'

update trfilter_minmax_dt set date_operator ='Is Between' 
where trade_filter_name in  (select t.trade_filter_name from trade_filter tf, trfilter_minmax_dt t 
where t.criterion_name='SettleDate' and t.trade_filter_name = tf.trade_filter_name and ( (tf.settle_date_min is not null and tf.settle_date_max is not null) 
or ( ( tf.setledt_tenor_min is not null and tf.setledt_tenor_min <> 360000) and (tf.setledt_tenor_max is not null and tf.setledt_tenor_max <> 360000) )
))
and criterion_name='SettleDate'


update  trfilter_minmax_dt set date_operator ='Is On Or Before' where trade_filter_name in  (select t.trade_filter_name from trade_filter tf , trfilter_minmax_dt t where (tf.mat_date_max is not null 
or (tf.matdt_tenor_max is not null and tf.matdt_tenor_max <> 360000)) 
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='MaturityDate'
)  
and criterion_name='MaturityDate'

update trfilter_minmax_dt set date_operator ='Is On Or After' where trade_filter_name in  (select t.trade_filter_name from
trfilter_minmax_dt t, trade_filter tf where  (tf.mat_date_min is not null 
or (tf.matdt_tenor_min is not null and tf.matdt_tenor_min <> 360000))
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='MaturityDate'
)
and criterion_name='MaturityDate'


update trfilter_minmax_dt set date_operator ='Is Between' where trade_filter_name in  (select t.trade_filter_name from trade_filter tf, trfilter_minmax_dt t 
where (
(tf.mat_date_min is not null and tf.mat_date_max is not null) 
or (tf.matdt_tenor_min is not null and tf.matdt_tenor_max is not null and tf.matdt_tenor_min <> 360000 and tf.matdt_tenor_max <> 360000)) 
and t.trade_filter_name = tf.trade_filter_name
and t.criterion_name='MaturityDate'
)
and criterion_name='MaturityDate'

exec trade_filter_to_dt2
exec trade_filter_to_dt3
exec trade_filter_to_dt4
exec trade_filter_to_dt5
exec trade_filter_to_dt6

update product_desc set final_valuation_date=maturity_date
update trfilter_minmax_dt set criterion_name='FinalValuationDate' where criterion_name='MaturityDateOrNone' or criterion_name='MaturityDate'
update trfilter_minmax_dt set date_min= date_max, tenor_min=tenor_max, time_min=time_max where date_operator = 'Is On Or Before'
update trfilter_minmax_dt set date_max=null, tenor_max=360000, time_max=-1 where date_operator = 'Is On Or Before'
update trfilter_minmax_dt set date_max= date_min, tenor_max=tenor_min, time_max=time_min where date_operator = 'Is On Or After'
update trfilter_minmax_dt set date_min=null, tenor_min=360000, time_min=-1 where date_operator = 'Is On Or After'
update trade_filter_crit set criterion_value='TransferTradeDate' where criterion_value='TransferDate' and criterion_name='haskeyword.Has'
update trade_filter_crit set criterion_value='TransferDate' where criterion_value='TransferEffectiveDate' and criterion_name='haskeyword.Has'
update trade_filter_crit set criterion_value='TerminationTradeDate' where criterion_value='TerminationDate' and criterion_name='haskeyword.Has'
update trade_filter_crit set criterion_value='TerminationDate' where criterion_value='TerminationEffectiveDate' and criterion_name='haskeyword.Has'
UPDATE trfilter_minmax_dt SET time_max = 2359 WHERE criterion_name IN ('EXERCISED_DATETIME', 'TransferDate', 'UpdateDate','TradeDate','EnteredDate','TerminationDate') AND time_max = -1
UPDATE trfilter_minmax_dt SET  time_min = 0000 WHERE criterion_name IN ('EXERCISED_DATETIME', 'TransferDate','UpdateDate','TradeDate','EnteredDate','TerminationDate') AND time_min = -1
end 
end
go

drop procedure trade_filter_to_dt
go
drop procedure trade_filter_to_dt1
go
drop procedure trade_filter_to_dt2
go
drop procedure trade_filter_to_dt3
go
drop procedure trade_filter_to_dt4
go
drop procedure trade_filter_to_dt5
go
drop procedure trade_filter_to_dt6
go

/* step 1 */ 

add_column_if_not_exists 'psheet_pricer_measure_prop','display_group','varchar(128) null'
go
update psheet_pricer_measure_prop set display_group = 'Favorite' where display_group is null or display_group=' '
go
update swap_leg set reset_off_busday_b = 1,reset_offset=0,reset_holidays='' where def_reset_off_b=1
go
update swap_leg_hist set reset_off_busday_b = 1,reset_offset=0,reset_holidays='' where def_reset_off_b=1
go

add_column_if_not_exists 'acc_account','trade_id','numeric default 0 not null'
go
add_column_if_not_exists 'acc_account','call_account_b','numeric default 0 not null'
go
update acc_account set trade_id=acc_account_id where trade_id=0 and call_account_b=1
go
add_column_if_not_exists 'product_future','ccp_date','datetime null'
go
update product_future set ccp_date = expiration_date where ccp_date is null
go

if exists (select 1 from sysobjects where name = 'sp_updateQuoteName' and type = 'P')
begin
    exec ('drop procedure sp_updateQuoteName')
end
go

CREATE PROCEDURE sp_updateQuoteName
AS
BEGIN
declare c2 cursor 
for 
Select
a.quote_name,right(rate_index,charindex('/',reverse(rate_index))-1) 
sourcename,a.cu_id
FROM curve_underlying a, cu_fra b where a.cu_id=b.cu_id and a.cu_type = 'CurveUnderlyingFRA'
DECLARE @qtname VARCHAR(500)
DECLARE @sourcename VARCHAR(500)
DECLARE @cu_id  NUMERIC
Declare @v_sql VARCHAR(1255)
Declare @vi_sql VARCHAR(1255)

open c2
FETCH c2 INTO @qtname, @sourcename, @cu_id
WHILE  (@@sqlstatus=0)
BEGIN
    print @qtname
    print @sourcename  
    SELECT @v_sql = 'Update quote_value set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+ ' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)
    SELECT @v_sql = 'Update curve_quote_value set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update curve_quote_adj set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update feed_address set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)   
    SELECT @v_sql = 'Update curve_qt_adj_hist set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update curve_qt_val_hist set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update product_desc set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update product_desc_hist set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update product_reset set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update quote_name set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql) 
    SELECT @v_sql = 'Update quote_value_hist set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update specific_fxrate set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update trade_diary_hist set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update trade_diary set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update trade_diary_hist set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update hs_context_qv set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update hs_context_qv_hist set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update pl_risk_factor set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)
    exec(@v_sql)     
    SELECT @v_sql = 'Update curve_underlying set quote_name='+char(39)+@qtname+'.'+ @sourcename +char(39)+' where quote_name='+char(39)+@qtname+char(39)+' and quote_name not like '+char(39)+'%'+ @sourcename +char(39)+' and cu_id = '+convert(varchar(25),@cu_id)    
    exec(@v_sql)  
    FETCH c2 INTO @qtname, @sourcename , @cu_id
END
CLOSE c2
DEALLOCATE CURSOR c2
END 

exec sp_procxmode 'sp_updateQuoteName', 'anymode'
go

exec sp_updateQuoteName
go
  
UPDATE main_entry_prop
SET property_value = 'cws.LaunchCWS'
WHERE property_name LIKE '%Action'
AND (property_value = 'tws.CalypsoWorkstation' OR property_value = 'tws.TraderWorkstation')
go

delete from pricing_param_items where attribute_name = 'BETA_REFERENCE_INDEX'
go
update pricing_param_name set param_name = 'BETA_REFERENCE_NAME', param_comment = 'Reference Matrix for Beta' where param_name = 'BETA_REFERENCE_INDEX'
go
select * into scenario_items_back from scenario_items
go

add_column_if_not_exists 'scenario_items','attribute_value1','varchar(255) null'
go

update scenario_items set attribute_value1=(
select substring(i2.attribute_value,1,len(i2.attribute_value)-len(substring(i2.attribute_value,charindex(' Beta',i2.attribute_value),len(i2.attribute_value))))
from scenario_items i2 where i2.class_name = 'com.calypso.tk.risk.ScenarioRuleQuotes' and scenario_items.class_name = i2.class_name and scenario_items.scenario_name = i2.scenario_name
and i2.attribute_name = 'SPECIFIC' and scenario_items.attribute_name = i2.attribute_name and scenario_items.item_seq=i2.item_seq and i2.attribute_value like '% Beta%') 
where scenario_items.class_name = 'com.calypso.tk.risk.ScenarioRuleQuotes' 
and scenario_items.attribute_name = 'SPECIFIC' and scenario_items.attribute_value like '% Beta%'
go

update scenario_items set attribute_value=attribute_value1 where class_name = 'com.calypso.tk.risk.ScenarioRuleQuotes' 
and attribute_name = 'SPECIFIC' and attribute_value like '%Beta%'
go

update an_param_items set attribute_value ='NONE' where class_name='com.calypso.tk.risk.SimulationParam' and attribute_name like '%BetaReferenceIndex%'
go
update an_param_items set attribute_value =null where class_name='com.calypso.tk.risk.SimulationParam' and attribute_name = 'EqBetaRefIndex'
go

alter table scenario_items drop attribute_value1
go

select * into an_param_items_back from an_param_items
go

delete from an_param_items 
where class_name = 'com.calypso.tk.risk.SensitivityParam'
and attribute_name = 'BetaReferenceIndex'
go

update an_param_items  
set  attribute_value = 'None'
where  class_name = 'com.calypso.tk.risk.SimulationParam'
and  attribute_name like 'CcyFamily%'
go

delete from termination_events where event_type ='BASKET RESTRUCTURING'
go

/* CAL-140998 */
update swap_leg set compound_freq_style = 'Original' where compound_freq='NON' 
and product_id in (select product_id from product_desc 
where product_type in ('Swap', 'XCCySwap', 'Swaption', 'CappedSwap', 'NDS', 'SingleSwapLeg', 'SpreadSwap','AssetSwap', 'CDSIndexDefinition', 'CDSNthDefault', 'CDSNthLoss', 'CreditDefaultSwap', 'PerformanceSwap', 'TotalReturnSwap'))
go


/* CAL-138780 */
/* accretion value field is converted from number to string " */
add_column_if_not_exists 'accretion_schedule','column_strg_value', 'VARCHAR(128) NULL'
go
add_column_if_not_exists 'accretion_schedule_hist','column_strg_value', 'VARCHAR(128) NULL'
go

UPDATE accretion_schedule SET column_strg_value = CONVERT(VARCHAR(128),column_value)
go
UPDATE accretion_schedule_hist SET column_strg_value = CONVERT(VARCHAR(128),column_value)
go



/* CAL-138780 */
/* Inflation swap leg has to set Fixed rate to 1 */
select * into tempInflRateIndex  
from rate_index_default
where index_type = 'Inflation'
go

UPDATE swap_leg
SET fixed_rate = 0.01
where EXISTS(
select swap_leg.product_id
from tempInflRateIndex
where swap_leg.leg_type = 'Float'
and swap_leg.rate_index like '%'+tempInflRateIndex.rate_index_code+'%'
and swap_leg.fixed_rate = 0
)
go

DROP TABLE tempInflRateIndex
go
/* CAL-141672 */
/* PositionInventory support */
add_domain_values 'PositionBasedProducts','PositionInventory','PositionInventory out of box position based product'
go
add_column_if_not_exists 'pl_mark_value','adj_comment','varchar(512) null'
go
add_column_if_not_exists 'pl_mark_value','adj_type','varchar(512) null'
go
add_column_if_not_exists 'pl_mark_value','adj_value','float null'
go
add_column_if_not_exists 'pl_mark_value','is_adjusted','numeric null'
go
create procedure insert_mark_ca_cost_ca_pv
as
begin
declare @markid numeric , @markvalue float,
@currency varchar(3), @displayclass varchar(128) ,
@displaydigits numeric, @adjvalue float ,@isadjusted numeric,
@adjtype varchar(512),@adjcomment varchar(512)
declare select_mark_npv_cur1 cursor
for
	select pl_mark.mark_id,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment
	from pl_mark,pl_mark_value
	where
	pl_mark.mark_id=pl_mark_value.mark_id
	and pl_mark.mark_id not in(
		select mark_id
		from pl_mark_value
		where mark_name IN ('CA_PV','CA_COST')
	)
	and mark_name='NPV'
open select_mark_npv_cur1 
fetch select_mark_npv_cur1 into @markid,@markvalue , @currency , @displayclass ,@displaydigits , @adjvalue ,@isadjusted ,@adjtype ,@adjcomment
while (@@sqlstatus=0)
 begin       
  	insert into pl_mark_value(mark_id,mark_name,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment)
values(@markid,'CA_PV',@markvalue , @currency , @displayclass ,@displaydigits , @adjvalue ,@isadjusted ,@adjtype ,@adjcomment)
		insert into pl_mark_value(mark_id,mark_name,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment)
values(@markid,'CA_COST',0,@currency , @displayclass ,@displaydigits ,0,0,'','')
  fetch select_mark_npv_cur1 into @markid,@markvalue , @currency , @displayclass ,@displaydigits , @adjvalue ,@isadjusted ,@adjtype ,@adjcomment
 End
close select_mark_npv_cur1 
deallocate cursor select_mark_npv_cur1
end
go

exec insert_mark_ca_cost_ca_pv
go
drop procedure insert_mark_ca_cost_ca_pv
go

select * into cds_matrix_cfg_bak from cds_settlement_matrix_config
go

update cds_settlement_matrix_config set red_jurisdiction = 'ANY' where red_jurisdiction is null
go
update cds_settlement_matrix_config set red_sector = 'ANY' where red_sector is null
go
update cds_settlement_matrix_config set rating = 'ANY' where rating is null
go
update cds_settlement_matrix_config set standard = 'ANY' where standard is null
go
update cds_settlement_matrix_config set usage = 'MATRIX' where usage is null
go
update cds_settlement_matrix_config set product_type = 'CreditDefaultSwap' where product_type is null
go
update cds_settlement_matrix_config set effective_date = (select period_start from cds_settlement_matrix c where c.matrix_id=cds_settlement_matrix_config.matrix_id) where effective_date is null
go
update cds_settlement_matrix_config set data_value = convert(varchar(64), matrix_id)
go 
create table t11 (usage_key varchar(255) null, red_region varchar(255) null, red_type varchar(255)  null, seniority varchar(64)  null )
go

if exists (select 1 from sysobjects where name='reparse_cfg' and type='P')
begin
exec ('drop procedure reparse_cfg')
end
go

create procedure reparse_cfg
as
declare @i int, @col1 varchar(255), @parseval varchar(255),
@j int, @col2 varchar(255), @parseval1 varchar(255),
@k int, @col3 varchar(255), @parseval2 varchar(225)

declare cur_main cursor for
select usage_key from cds_settlement_matrix_config
open cur_main
fetch cur_main into @parseval
while (@@sqlstatus = 0)
begin
	select @i = charindex('|',@parseval) 
	if @i > 1
	begin 
		select @col1 = substring(@parseval,1,@i-1)
	end
	select @parseval1 = substring (@parseval,@i+1,len(@parseval))

	select @j = charindex('|',@parseval1)
	if @j > 1 
	begin
		select @col2 = substring(@parseval1,1,@j-1)
		select @parseval2 = substring (@parseval1, @j+1 , len(@parseval1))
		select @k = len(@parseval2)
		if @k > 0 
		begin
			select @col3 = @parseval2
		end
		else 
		begin
			select @col3 = 'ANY'
		end
	end
	if @j = 0
	begin
		select @col2 = @parseval1
		select @col3 = 'ANY'
	end	
	
	insert into t11 values (@parseval,@col1,@col2,@col3)
	fetch cur_main into @parseval
end
close cur_main
deallocate cursor cur_main
go

exec reparse_cfg
go

drop procedure reparse_cfg
go

update cds_settlement_matrix_config set p.red_region = t.red_region
FROM cds_settlement_matrix_config p,t11 t
WHERE p.usage_key = t.usage_key
go

update cds_settlement_matrix_config set p.red_type = t.red_type
FROM cds_settlement_matrix_config p,t11 t
WHERE p.usage_key = t.usage_key
go

update cds_settlement_matrix_config set p.seniority = t.seniority
FROM cds_settlement_matrix_config p,t11 t
WHERE p.usage_key = t.usage_key
go

update cds_settlement_matrix_config set seniority = 'ANY' where seniority is NULL
go

if exists (select 1 from sysobjects where name='drop_matrix_cfg_idxs' and type='P')
begin
exec ('drop procedure drop_matrix_cfg_idxs')
end
go

create procedure drop_matrix_cfg_idxs 
as
begin
    declare @indexName varchar(255)
    declare drop_idxs_crsr cursor
    FOR SELECT sysindexes.name FROM sysindexes, sysobjects
        WHERE sysobjects.id=sysindexes.id AND sysobjects.name='cds_settlement_matrix_config' AND sysindexes.indid!=0
    OPEN drop_idxs_crsr
    FETCH drop_idxs_crsr INTO @indexName
    WHILE (@@sqlstatus=0)
    begin
        IF @indexName='ct_primarykey'
            begin
                EXECUTE ('ALTER TABLE cds_settlement_matrix_config DROP CONSTRAINT '+ @indexName)
            end
        ELSE
            begin
                EXECUTE ('DROP INDEX cds_settlement_matrix_config.'+ @indexName)
            end
        FETCH drop_idxs_crsr INTO @indexName
    end
    CLOSE drop_idxs_crsr
    DEALLOCATE cursor drop_idxs_crsr
end
go

exec drop_matrix_cfg_idxs
go

drop procedure drop_matrix_cfg_idxs
go


if not exists (select 1 from sysobjects where name='trade_diary' and type='U')
begin
	exec ('create table trade_diary(diary_id numeric not null
,trade_id numeric not null
,event_type varchar(128) not  null
,event_date datetime not null 
,event_info  varchar(256)  null
,event_amount float null  
,start_date  datetime  null 
,end_date  datetime  null 
,processed numeric not null
,product_id numeric not null
,collateral_id numeric not null
,security_id numeric not null
,trade_version numeric not null
,is_canceled numeric not null
,cancel_date  datetime  null 
,cancel_version numeric not null
,creation_date  datetime  null 
,action_id numeric not null
,quote_name  varchar(256)  null
,sub_id numeric not null
,linked_diary_id numeric not null
,activity  varchar(128)   null
,holidays  varchar(128)   null )')
end 
go

begin
declare @v varchar(200) , @a varchar(200), @b varchar(200), @c varchar(200),@d varchar(200),@cnt int , 
@l int,@ci int ,@final varchar(200),@x int
select @v= quote_name from product_desc where product_id in (select product_id from product_future where contract_id in (Select contract_id from future_contract where settlement_type = 'Spot Deferred'))
if @v != null  
print @v
begin
select @cnt = 0
select @l=char_length(@v)
begin
select @ci= charindex('.',@v)
select @a=substring(@v,1,charindex('.',@v))
select @cnt=1
select @v=substring(@v,@ci+1,@l-@ci+1)    
select @ci=charindex('.',@v)
select @b=substring(@v,1,charindex('.',@v))
select @cnt=2
select @v=substring(@v,@ci+1,@l-@ci+1)
select @ci=charindex('.',@v)
select @c=substring(@v,1,charindex('.',@v))
select @cnt=3
select @v=substring(@v,@ci+1,@l-@ci+1)
select @ci=charindex('.',@v)

if(@ci >0)
begin
    select @d=substring(@v,1,charindex('.',@v)-1)
    select @cnt=4
    select @final = @a+@b+@c+@d
end

if (@ci > 0 )
begin
update feed_address set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))


update quote_name set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))


update quote_value set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))

update quote_value_hist set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))

update trade_diary set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))

update trade_diary_hist set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))

update product_desc_hist set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))

update product_desc set quote_name= @final where quote_name in (select quote_name from product_desc 
where product_id in (select product_id from product_future where contract_id 
in (Select contract_id from future_contract where settlement_type = 'Spot Deferred')))

end
end
end
end
go

delete from domain_values where name = 'plAttribute'
go
    /* populate domain_values */ 
add_domain_values 'plAttribute','Adjusted',null
go
add_domain_values 'plAttribute','Mark Status',null
go
add_domain_values 'plAttribute','Bucket',null
go
add_domain_values 'plAttribute','Bucket Date',null
go
add_domain_values 'plAttribute','PL Maturity Date',null
go
add_domain_values 'plAttribute','PL State',null
go
add_domain_values 'plAttribute','PL Status',null
go

create procedure add_pl_attribute_data
as
begin
declare cur_main1 cursor 
for
select param_name from analysis_param where class_name='com.calypso.tk.risk.CrossAssetPLParam'
declare @v_attrib_cnt numeric(6) , @param_name varchar(255)

    
	delete from an_param_items where class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_ATTRIBUTES'
    and attribute_value = 'PL End Date,PL Maturity Date,Adjusted,Bucket,Bucket Date,Mark Status,PL State,PL Status'

open cur_main1
fetch cur_main1 into @param_name
select @v_attrib_cnt = 0
while (@@sqlstatus=0)
begin
	select @v_attrib_cnt = count(*) from an_param_items where param_name = @param_name and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_ATTRIBUTES'
	IF (@v_attrib_cnt = 0)
	begin
          insert into an_param_items ( param_name, class_name, attribute_name, attribute_value) 
		  values ( @param_name,'com.calypso.tk.risk.CrossAssetPLParam','PL_ATTRIBUTES','PL End Date,PL Maturity Date,Adjusted,Bucket,Bucket Date,Mark Status,PL State,PL Status')
    END  
fetch cur_main1 into @param_name
end	
close cur_main1
deallocate cursor cur_main1
end
go

exec add_pl_attribute_data
go
drop procedure add_pl_attribute_data
go

/* CAL- 125793 */


update ps_event set create_timestamp=getdate()
go

UPDATE pl_mark_value SET mark_name = 'HISTO_FEES_UNSETTLED' WHERE mark_name = 'HISTO_UNSETTLED_FEES'
go
UPDATE pl_mark_value SET mark_name = 'HISTO_CUMULATIVE_CASH' WHERE mark_name = 'HISTO_CUMUL_CASH'
go
UPDATE pl_mark_value SET mark_name = 'HISTO_CUMULATIVE_CASH_INTEREST' WHERE mark_name = 'HISTO_CUMUL_CASH_INTEREST'
go
UPDATE pl_mark_value SET mark_name = 'HISTO_POSITION_CASH' WHERE mark_name = 'HISTO_POS_CASH'
go
UPDATE pl_mark_value SET mark_name = 'HISTO_CUMULATIVE_CASH_FEES' WHERE mark_name = 'HISTO_CUMUL_CASH_FEES'
go
create index idx_temp1 on product_desc(product_family)
go

UPDATE pl_mark_value set mark_name = 'HISTO_CUMULATIVE_CASH_PRINCIPAL'
from pl_mark B, trade C, product_desc D 
WHERE pl_mark_value.mark_id = B.mark_id AND C.trade_id=B.trade_id AND D.product_id = C.product_id 
AND B.position_or_trade = 'com.calypso.tk.core.Trade' AND pl_mark_value.mark_name = 'HISTO_BS' AND D.product_type = 'PreciousMetalDepositLease'
go

UPDATE pl_mark_value set mark_name = 'HISTO_CUMULATIVE_CASH_PRINCIPAL'
from pl_mark B, trade C, product_desc D 
WHERE pl_mark_value.mark_id = B.mark_id AND C.trade_id=B.trade_id  AND D.product_id = C.product_id 
AND B.position_or_trade = 'com.calypso.tk.core.Trade' AND pl_mark_value.mark_name = 'HISTO_BS' AND D.product_family 
IN ('Cash', 'Repo' ,'SecurityLending')
go

UPDATE pl_mark_value set mark_name = 'HISTO_BOOK_VALUE' from pl_mark B, pl_position C, product_desc D
WHERE pl_mark_value.mark_id = B.mark_id AND B.trade_id = C.position_id AND D.product_id = C.product_id 
AND B.position_or_trade = 'com.calypso.tk.mo.PLPosition' AND pl_mark_value.mark_name = 'HISTO_BS' AND D.product_family IN ('Equity', 'CFD')
go

UPDATE pl_mark_value set mark_name = 'HISTO_CLEAN_BOOK_VALUE' from pl_mark B, pl_position C, product_desc D
WHERE pl_mark_value.mark_id = B.mark_id AND pl_mark_value.mark_name = 'HISTO_BS' AND B.trade_id = C.position_id AND C.product_id = D.product_id 
AND B.position_or_trade = 'com.calypso.tk.mo.PLPosition' AND D.product_family IN ('Bond','Loan','Issuance')
go

UPDATE pl_mark_value set mark_name = 'HISTO_CLEAN_REALIZED' from pl_mark B, pl_position C, product_desc D 
WHERE pl_mark_value.mark_id = B.mark_id AND pl_mark_value.mark_name = 'HISTO_REALIZED' AND B.trade_id = C.position_id 
AND C.product_id = D.product_id AND B.position_or_trade = 'com.calypso.tk.mo.PLPosition' AND D.product_family IN ('Bond','Loan','Issuance')
go

drop index product_desc.idx_temp1
go

DELETE FROM domain_values WHERE value LIKE 'HISTO_CUMUL_CASH%'
go
DELETE FROM domain_values WHERE value LIKE 'HISTO_POS_CASH%'
go
DELETE FROM domain_values WHERE value LIKE 'HISTO_UNSETTLED_FEES%'
go
DELETE FROM domain_values WHERE value LIKE 'HISTO_BS%'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlBondsEOD' AND value = 'HISTO_REALIZED'
go

UPDATE an_param_items SET attribute_value = str_replace(attribute_value, 'HISTO_CUMUL_CASH', 'HISTO_CUMULATIVE_CASH') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_CUMUL_CASH%'
go
UPDATE an_param_items SET attribute_value = str_replace(attribute_value, 'HISTO_POS_CASH', 'HISTO_POSITION_CASH') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_POS_CASH%'
go
UPDATE an_param_items SET attribute_value = str_replace(attribute_value, 'HISTO_UNSETTLED_FEES', 'HISTO_FEES_UNSETTLED') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_UNSETTLED_FEES%'
go
UPDATE an_param_items SET attribute_value = str_replace(attribute_value, 'HISTO_BS', 'HISTO_CUMULATIVE_CASH_PRINCIPAL,HISTO_BOOK_VALUE,HISTO_CLEAN_BOOK_VALUE') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_PRICER_MEASURES' AND attribute_value LIKE '%HISTO_BS%'
go

add_column_if_not_exists 'product_variance_option','vol_reference','float null'
go
add_column_if_not_exists 'product_variance_swap','vol_reference','float null'
go
if exists (select 1 from sysobjects where name='product_variance_option' and type='U')
begin
exec ('update product_variance_option set vol_reference = strike')
end
go

update product_variance_swap set vol_reference = strike
go
/* CAL-139498 recreate token store */
if exists (select 1 from sysobjects where name ='tokenstore' and type='U')
begin
drop table tokenstore
end
go
delete from domain_values where value ='TD_ACRUAL_BS'
go
DELETE FROM domain_values WHERE name = 'NamesForPNL' AND value = 'PNLMTMAndAccruals'
go
DELETE FROM domain_values WHERE name = 'NamesForPNL' AND value = 'PNLTradeDateCash'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Cost_Of_Carry_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Cost_Of_Carry_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Realized_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Realized_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Total_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Trade_Full_Base_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Trade_Translation_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Unrealized_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLMTMAndAccruals' AND value = 'Unrealized_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Accrual_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Accrual_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Accrued_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Accrued_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Cash_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Cash_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Cost_Of_Carry_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Cost_Of_Carry_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Cost_Of_Funding_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Funding_Cost_FX_Reval'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Paydown_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Paydown_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Interests_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Interests_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Realized_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Price_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Realized_Price_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Sale_Realized_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Sale_Realized_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Total_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Cash_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Cash_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Fees_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Fees_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Interests_Full'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Interests'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Net_Full_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Net_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTradeDateCash' AND value = 'Unrealized_Translation_PnL'
go
DELETE FROM domain_values WHERE name = 'PNLTrader' AND value = 'Cost_Of_Carry_PnL'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_DISC_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_NET_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_NET'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlAllEOD' AND value = 'NPV_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlBondsEOD' AND value = 'NPV_DISC_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlEquitiesEOD' AND value = 'NPV_NET_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlEquitiesEOD' AND value = 'NPV_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlETOEOD' AND value = 'NPV_NET_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlETOEOD' AND value = 'NPV_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlFuturesEOD' AND value = 'NPV_NET_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlFuturesEOD' AND value = 'NPV_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlMMEOD' AND value = 'NPV_NET'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlOTCEOD' AND value = 'ACCUMULATED_ACCRUAL'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlOTCEOD' AND value = 'NPV_NET'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlPhysComEOD' AND value = 'NPV_NET_WITH_COST'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlPhysComEOD' AND value = 'NPV_NET'
go
DELETE FROM domain_values WHERE name = 'PricerMeasurePnlPhysComEOD' AND value = 'NPV_WITH_COST'
go
DELETE FROM domain_values WHERE value = 'Intraday_Cost_Of_Funding_FX_Reval'
go
DELETE FROM domain_values WHERE value = 'Intraday_Trade_Cash_FX_Reval'
go
UPDATE an_param_items SET attribute_value = str_replace(attribute_value, 'Intraday_Cost_Of_Funding_FX_Reval', '') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_MEASURES_LIST' AND attribute_value LIKE '%Intraday_Cost_Of_Funding_FX_Reval%'
go
UPDATE an_param_items SET attribute_value = str_replace(attribute_value, 'Intraday_Trade_Cash_FX_Reval', '') WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_MEASURES_LIST' AND attribute_value LIKE '%Intraday_Trade_Cash_FX_Reval%'
go
begin
declare @i int
select @i=1
while @i<=10
	begin
		UPDATE an_param_items SET attribute_value = str_replace(attribute_value, ',,', ',') 
		WHERE class_name = 'com.calypso.tk.risk.CrossAssetPLParam' AND attribute_name = 'PL_MEASURES_LIST' AND attribute_value LIKE '%,,%'
		select @i=@i+1
	end
end
go

UPDATE mrgcall_config SET mrgcall_config.discount_currency =
(SELECT currency_code FROM mrgcall_config_currency
WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def AND mrgcall_config_currency.mrg_call_def in (select mrgcall_config.mrg_call_def
FROM mrgcall_config, mrgcall_config_currency
WHERE mrgcall_config_currency.mrg_call_def=mrgcall_config.mrg_call_def
GROUP BY mrgcall_config.mrg_call_def
HAVING count(mrgcall_config.mrg_call_def) = 1))
WHERE mrgcall_config.discount_currency is NULL 
go

delete from pc_param
where pricer_name = 'PricerSwaptionOneFactorModel'
go

delete from pc_param
where pricer_name = 'PricerSwaptionMultiFactorModel'
go

delete from pc_param
where pricer_name = 'PricerCapFloorMultiFactorModel'
go

delete from pc_param
where pricer_name = 'PricerSpreadCapFloor'
go

delete from pc_param
where pricer_name = 'PricerSingleSwapLegExotic'
go
update pc_pricer
set product_pricer = 'PricerSwaptionLGMM1F'
where product_pricer = 'PricerSwaptionLGMM'
go

delete from domain_values
where name = 'Swaption.Pricer'
and value = 'PricerSwaptionLGMM'
go

delete from pc_param
where pricer_name = 'PricerSwaptionLGMM'
go

update pc_pricer
set product_pricer = 'PricerSwapLGMM1F'
where product_pricer = 'PricerSwapLGM'
go

delete from domain_values
where name = 'Swap.Pricer'
and value = 'PricerSwapLGM'
go

delete from pc_param
where pricer_name = 'PricerSwapLGM'
go

if exists (select 1 from sysobjects where name ='add_histo_unsettled_cash_fees' and type='P')
begin
exec ('drop procedure add_histo_unsettled_cash_fees')
end
go
create procedure add_histo_unsettled_cash_fees
as
begin
declare @markid numeric ,
@currency varchar(3), @displayclass varchar(128) ,
@displaydigits numeric, @x numeric
declare select_unsettled_cash_cur cursor
for
    select mark_id,currency,display_class,display_digits
    from pl_mark_value
    where mark_name='HISTO_UNSETTLED_CASH'
open select_unsettled_cash_cur 
fetch select_unsettled_cash_cur into @markid, @currency , @displayclass ,@displaydigits
while (@@sqlstatus=0)
 begin      
      select @x=count(*) from pl_mark_value where mark_name='HISTO_UNSETTLED_CASH_FEES' and mark_id = @markid and currency = @currency
      IF @x=0 
      begin
      	insert into pl_mark_value(mark_id,mark_name,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment)
      	values(@markid,'HISTO_UNSETTLED_CASH_FEES',0 , @currency , @displayclass ,@displaydigits , 0 , 0 ,'' ,'')
      end
      fetch select_unsettled_cash_cur into @markid, @currency , @displayclass ,@displaydigits  
 End
close select_unsettled_cash_cur 
deallocate cursor select_unsettled_cash_cur
end
go

exec add_histo_unsettled_cash_fees
go

drop procedure add_histo_unsettled_cash_fees
go

if exists (select 1 from sysobjects where name ='add_unsettled_cash_fees' and type='P')
begin
exec ('drop procedure add_unsettled_cash_fees')
end
go

create procedure add_unsettled_cash_fees
as
begin
declare @markid numeric ,
@currency varchar(3), @displayclass varchar(128) ,
@displaydigits numeric, @x numeric
declare select_mark_unsettled_cash_cur cursor
for
    select mark_id,currency,display_class,display_digits
    from pl_mark_value
    where mark_name='UNSETTLED_CASH'
open select_mark_unsettled_cash_cur 
fetch select_mark_unsettled_cash_cur into @markid, @currency , @displayclass ,@displaydigits
while (@@sqlstatus=0)
 begin      
      select @x=count(*) from pl_mark_value where mark_name='UNSETTLED_CASH_FEES' and mark_id = @markid and currency = @currency
      IF @x=0 
      begin
      	insert into pl_mark_value(mark_id,mark_name,mark_value,currency,display_class,display_digits,adj_value,is_adjusted,adj_type,adj_comment)
      	values(@markid,'UNSETTLED_CASH_FEES',0 , @currency , @displayclass ,@displaydigits , 0 , 0 ,'' ,'')
      end
      fetch select_mark_unsettled_cash_cur into @markid, @currency , @displayclass ,@displaydigits
      	
 End
close select_mark_unsettled_cash_cur 
deallocate cursor select_mark_unsettled_cash_cur
end
go

exec add_unsettled_cash_fees
go
drop procedure add_unsettled_cash_fees
go
create index idx_attr on rate_attributes(attr_name)
go

CREATE procedure rate_attr
as 
begin
declare 
     c1 cursor for
      select currency_code,rate_index_code
      from rate_attributes
      where attr_name='ROUND_FINAL_RATE_ONLY' and (upper(attr_value) = 'TRUE' or upper(attr_value)='Y' or upper(attr_value)='YES' or upper(attr_value)='T')
	  declare  @currency_code varchar(50),	  @rate_index_code varchar(50)
    open c1
	fetch c1 into @currency_code , @rate_index_code
    while (@@sqlstatus = 0)
	begin
	insert into rate_attributes ( currency_code, rate_index_code, attr_name, attr_value)
          values (  @currency_code , @rate_index_code, 'ROUND_FINAL_RATE','True')
    END
fetch c1 into @currency_code , @rate_index_code
close c1 
deallocate cursor c1

END
go

exec rate_attr
go
drop index rate_attributes.idx_attr
go

drop procedure rate_attr
go

update rate_attributes set attr_name='ROUND_FINAL_RATE_ISDA', attr_value ='True' where attr_name='ROUND_FINAL_RATE_ONLY' and
(upper(attr_value) = 'TRUE' or upper(attr_value)='Y' or upper(attr_value)='YES' or upper(attr_value)='T')
go

DELETE FROM domain_values WHERE value = 'Unrealized_FX_Base'
go

create procedure updateunrealizedfx as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Unrealized_FX_Base,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Unrealized_FX_Base,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Unrealized_FX_Base,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateunrealizedfx
go
drop proc updateunrealizedfx
go

create procedure updateunrealizedfx_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Unrealized_FX_Base' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Unrealized_FX_Base' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateunrealizedfx_1
go
drop proc updateunrealizedfx_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Unrealized_FX_Base',null) where  attribute_value like '%,Unrealized_FX_Base' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Unrealized_FX_Base,',',') where  attribute_value like '%,Unrealized_FX_Base,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value = 'Trade_Date_Cash_Full_PnL'
go

create procedure updatetradefullpnl as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Trade_Date_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Trade_Date_Cash_Full_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Trade_Date_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradefullpnl
go
drop proc updatetradefullpnl
go

create procedure updatetradefullpnl_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Trade_Date_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Trade_Date_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradefullpnl_1
go
drop proc updatetradefullpnl_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Trade_Date_Cash_Full_PnL',null) where  attribute_value like '%,Trade_Date_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Trade_Date_Cash_Full_PnL,',',') where  attribute_value like '%,Trade_Date_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go



DELETE FROM domain_values WHERE value = 'Total_Accrual_PnL'
go

create procedure updatetotalaccrual as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Total_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Total_Accrual_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Total_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetotalaccrual
go
drop proc updatetotalaccrual
go

create procedure updatetotalaccrual_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Total_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Total_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetotalaccrual_1
go
drop proc updatetotalaccrual_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Total_Accrual_PnL',null) where  attribute_value like '%,Total_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Total_Accrual_PnL,',',') where  attribute_value like '%,Total_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value = 'Trade_Full_Accrual_PnL'
go

create procedure updatetradeaccrualpnl as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Trade_Full_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Trade_Full_Accrual_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Trade_Full_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradeaccrualpnl
go
drop proc updatetradeaccrualpnl
go
create procedure updatetradeaccrualpnl_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Trade_Full_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Trade_Full_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradeaccrualpnl_1
go
drop proc updatetradeaccrualpnl_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Trade_Full_Accrual_PnL',null) where  attribute_value like '%,Trade_Full_Accrual_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Trade_Full_Accrual_PnL,',',') where  attribute_value like '%,Trade_Full_Accrual_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value = 'Trade_Date_Full_Base_PnL'
go

create procedure updatetradedatefullpnl as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Trade_Date_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Trade_Date_Full_Base_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Trade_Date_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradedatefullpnl
go
drop proc updatetradedatefullpnl
go

create procedure updatetradedatefullpnl_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Trade_Date_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Trade_Date_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradedatefullpnl_1
go
drop proc updatetradedatefullpnl_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Trade_Date_Full_Base_PnL',null) where  attribute_value like '%,Trade_Date_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Trade_Date_Full_Base_PnL,',',') where  attribute_value like '%,Trade_Date_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value = 'Trade_Date_Cash_FX_Reval'
go

create procedure updatetradedatecashreval as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Trade_Date_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Trade_Date_Cash_FX_Reval,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Trade_Date_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradedatecashreval
go
drop proc updatetradedatecashreval
go

create procedure updatetradedatecashreval_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Trade_Date_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Trade_Date_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradedatecashreval_1
go
drop proc updatetradedatecashreval_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Trade_Date_Cash_FX_Reval',null) where  attribute_value like '%,Trade_Date_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Trade_Date_Cash_FX_Reval,',',') where  attribute_value like '%,Trade_Date_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value = 'Trade_date_Unrealized_FX_Reval'
go

create procedure updatetradedateunrealized as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Trade_date_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Trade_date_Unrealized_FX_Reval,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Trade_date_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradedateunrealized
go
drop proc updatetradedateunrealized
go

create procedure updatetradedateunrealized_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Trade_date_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Trade_date_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradedateunrealized_1
go
drop proc updatetradedateunrealized_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Trade_date_Unrealized_FX_Reval',null) where  attribute_value like '%,Trade_date_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Trade_date_Unrealized_FX_Reval,',',') where  attribute_value like '%,Trade_date_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value = 'Trade_Date_Cash_Unrealized_FX_Reval'
go

create procedure updatetradeunrealizedfx as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Trade_Date_Cash_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Trade_Date_Cash_Unrealized_FX_Reval,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Trade_Date_Cash_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradeunrealizedfx
go
drop proc updatetradeunrealizedfx
go

create procedure updatetradeunrealizedfx_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Trade_Date_Cash_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Trade_Date_Cash_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatetradeunrealizedfx_1
go
drop proc  updatetradeunrealizedfx_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Trade_Date_Cash_Unrealized_FX_Reval',null) where  attribute_value like '%,Trade_Date_Cash_Unrealized_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Trade_Date_Cash_Unrealized_FX_Reval,',',') where  attribute_value like '%,Trade_Date_Cash_Unrealized_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

DELETE FROM domain_values WHERE value = 'SL_Fees_PnL'
go

create procedure updateslfeespnl as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'SL_Fees_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='SL_Fees_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'SL_Fees_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateslfeespnl
go
drop proc updateslfeespnl
go

create procedure updateslfeespnl_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'SL_Fees_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'SL_Fees_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateslfeespnl_1
go
drop proc updateslfeespnl_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',SL_Fees_PnL',null) where  attribute_value like '%,SL_Fees_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',SL_Fees_PnL,',',') where  attribute_value like '%,SL_Fees_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value LIKE '%Intraday%PnL'
go

create procedure updateintraday_1 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Accrual_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Accrual_Full_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Accrual_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_1
go
drop proc updateintraday_1
go

create procedure updateintraday_2 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Accrual_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Accrual_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_2
go
drop proc updateintraday_2
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Accrual_Full_PnL',null) where  attribute_value like '%,Intraday_Accrual_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Accrual_Full_PnL,',',') where  attribute_value like '%,Intraday_Accrual_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_3 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Cash_Full_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_3
go
drop proc updateintraday_3
go

create procedure updateintraday_4 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_4
go
drop proc updateintraday_4
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Cash_Full_PnL',null) where  attribute_value like '%,Intraday_Cash_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Cash_Full_PnL,',',') where  attribute_value like '%,Intraday_Cash_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_5 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Realized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Realized_Full_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Realized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_5
go
drop proc updateintraday_5
go

create procedure updateintraday_6 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Realized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Realized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_6
go
drop proc updateintraday_6
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Realized_Full_PnL',null) where  attribute_value like '%,Intraday_Realized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Realized_Full_PnL,',',') where  attribute_value like '%,Intraday_Realized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_7 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Translation_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_7
go
drop proc updateintraday_7
go

create procedure updateintraday_8 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_8
go
drop proc updateintraday_8
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Translation_PnL',null) where  attribute_value like '%,Intraday_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Translation_PnL,',',') where  attribute_value like '%,Intraday_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_9 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Unrealized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Unrealized_Full_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Unrealized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_9
go
drop proc updateintraday_9
go

create procedure updateintraday_10 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Unrealized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Unrealized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_10
go
drop proc updateintraday_10
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Unrealized_Full_PnL',null) where  attribute_value like '%,Intraday_Unrealized_Full_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Unrealized_Full_PnL,',',') where  attribute_value like '%,Intraday_Unrealized_Full_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

create procedure updateintraday_11 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Trade_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Trade_Full_Base_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Trade_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_11
go
drop proc updateintraday_11
go

create procedure updateintraday_12 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Trade_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Trade_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_12
go
drop proc updateintraday_12
go
update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Trade_Full_Base_PnL',null) where  attribute_value like '%,Intraday_Trade_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Trade_Full_Base_PnL,',',') where  attribute_value like '%,Intraday_Trade_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_13 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Cost_Of_Funding_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Cost_Of_Funding_FX_Reval,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Cost_Of_Funding_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_13
go
drop proc updateintraday_13
go

create procedure updateintraday_14 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Cost_Of_Funding_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Cost_Of_Funding_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_14
go
drop proc updateintraday_14
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Cost_Of_Funding_FX_Reval',null) where  attribute_value like '%,Intraday_Cost_Of_Funding_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Cost_Of_Funding_FX_Reval,',',') where  attribute_value like '%,Intraday_Cost_Of_Funding_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_15 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Cost_Of_Funding_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Cost_Of_Funding_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Cost_Of_Funding_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_15
go
drop proc updateintraday_15
go


create procedure updateintraday_16 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Cost_Of_Funding_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Cost_Of_Funding_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_16
go
drop proc updateintraday_16
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Cost_Of_Funding_PnL',null) where  attribute_value like '%,Intraday_Cost_Of_Funding_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Cost_Of_Funding_PnL,',',') where  attribute_value like '%,Intraday_Cost_Of_Funding_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_17 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Full_Base_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_17
go
drop proc updateintraday_17
go

create procedure updateintraday_18 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_18
go
drop proc updateintraday_18
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Full_Base_PnL',null) where  attribute_value like '%,Intraday_Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Full_Base_PnL,',',') where  attribute_value like '%,Intraday_Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

create procedure updateintraday_19 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Trade_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Trade_Cash_FX_Reval,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Trade_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_19
go
drop proc updateintraday_19
go

create procedure updateintraday_20 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Trade_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Trade_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_20
go
drop proc updateintraday_20
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Trade_Cash_FX_Reval',null) where  attribute_value like '%,Intraday_Trade_Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Trade_Cash_FX_Reval,',',') where  attribute_value like '%,Intraday_Trade_Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


create procedure updateintraday_21 as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Intraday_Trade_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Intraday_Trade_Translation_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Intraday_Trade_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_21
go
drop proc updateintraday_21
go

create procedure updateintraday_22 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Intraday_Trade_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Intraday_Trade_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updateintraday_22
go
drop proc updateintraday_22
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Intraday_Trade_Translation_PnL',null) where  attribute_value like '%,Intraday_Trade_Translation_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Intraday_Trade_Translation_PnL,',',') where  attribute_value like '%,Intraday_Trade_Translation_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go


DELETE FROM domain_values WHERE value = 'Cash_FX_Reval'
go

create procedure updatecashfxreval as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Cash_FX_Reval,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatecashfxreval
go
drop proc updatecashfxreval
go

create procedure updatecashfxreval_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatecashfxreval_1
go
drop proc updatecashfxreval_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Cash_FX_Reval',null) where  attribute_value like '%,Cash_FX_Reval' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Cash_FX_Reval,',',') where  attribute_value like '%,Cash_FX_Reval,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

DELETE FROM domain_values WHERE value = 'Full_Base_PnL'
go

create procedure updatefullbasepnl as 
begin
declare @parseval   varchar(255),@parse_char     char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value like 'Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_index = charindex(@parse_char,@parseval)
		select @parse_char = ','
		select @v1 = substring(@parseval, 1, @parse_index)
		if @v1 ='Full_Base_PnL,'
			begin
			select @parseval=substring(@parseval, @parse_index +1 , len(@parseval))
			update an_param_items  set attribute_value=@parseval where attribute_value like 'Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam'
			end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatefullbasepnl
go
drop proc updatefullbasepnl
go
create procedure updatefullbasepnl_1 as 
begin
declare @parseval   varchar(255),@parse_char  char(1), @parse_index    int , @v1 varchar(255)
declare cur_main4 cursor for
select attribute_value from an_param_items  where attribute_value = 'Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
open cur_main4
fetch cur_main4 into @parseval
while (@@sqlstatus = 0)
	begin
	    select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		select @parse_index 
		if (@parse_index = 0) 
		begin
		update an_param_items set attribute_value='' where attribute_value = 'Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
		end
		fetch cur_main4 into @parseval
	end
close cur_main4
deallocate cursor cur_main4
end 
go
exec updatefullbasepnl_1
go
drop proc updatefullbasepnl_1
go

update an_param_items  set attribute_value= str_replace(attribute_value,',Full_Base_PnL',null) where  attribute_value like '%,Full_Base_PnL' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

update an_param_items  set attribute_value=str_replace(attribute_value,',Full_Base_PnL,',',') where  attribute_value like '%,Full_Base_PnL,%' and class_name = 'com.calypso.tk.risk.CrossAssetPLParam' and attribute_name = 'PL_MEASURES_LIST' 
go

/* Data Model Changes END */

/* Domain Value Changes BEGIN */

INSERT INTO acc_event_config ( acc_event_cfg_id, acc_event_type, product_type, description, retro_activity, acc_event_class, booking_type, event_property, pricing_measures, is_fee ) VALUES (16562,'CVA_EXPOSURE','ALL','CVA Allocated per Trade','FULL','INVENTORY','N/A','NONE','CVA_ALLOCATION,CVA_CREDITSIM',0 )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (13918,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16551,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16552,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16553,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16554,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16555,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16556,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16557,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16558,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16559,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16560,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16561,'REMOVE_HEDGE_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16562,'MATURED_TRADE' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16562,'TRADE_VALUATION' )
go
INSERT INTO acc_trig_event ( acc_event_cfg_id, trig_event_type ) VALUES (16562,'CANCELED_TRADE' )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('MultiSensitivity','apps.risk.MultiSensitivityJideViewer',0 )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('HedgeEffectivenessProspective','apps.risk.HedgeEffectivenessProspectiveViewer',0 )
go
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ('Rebalancing','apps.risk.RebalancingAnalysisReportFrameworkViewer',0 )
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('PositionTransferPrice','To specify the type of pricing to use during transfer' )
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('Can Take Positions','Indicates if the book can take positions' )
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ('Domiciliation','Indicates if the book is for onshore or offshore trades.  Blank for not applicable.' )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'BetaMatrix',500 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'CARules',500 )
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES (0,'CWSDocument',500 )
go
begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='LifeCycleEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'LifeCycleEngine','' )
end
end
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','RISK_OPTIMISE','true' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_CALIBRATION_INSTRUMENTS','CORE_SWAPTION' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_CALIBRATION_SCHEME','EXACT_STEP_SIGMA' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_CONTROL_VARIATE','true' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_LATTICE_NODES','35' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_QUAD_ORDER','20' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ('default','PricerSwaptionLGMM1F','LGMM_LATTICE_CUTOFF','6.0' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ('default','ANY','USE_NATIVE_CURRENCY','false' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ('default','MBSFixedRate','USE_PROJ_FOR_HIST_CF','true' )
go
INSERT INTO pricing_param_items ( pricing_param_name, product_type, attribute_name, attribute_value ) VALUES ('default','MBSArm','USE_ARM_COMPONENTS','true' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','BondExoticNote.ANY.ANY','PricerBlackNFMonteCarloExotic' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Bond.ANY.BondExoticNote','PricerBondExoticNote' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.American.TradingWarrant','PricerBlack1FFiniteDifference' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.European.TradingWarrant','PricerBlack1FAnalyticVanilla' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.American.IndexWarrant','PricerBlack1FFiniteDifference' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','Warrant.European.IndexWarrant','PricerBlack1FAnalyticVanilla' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquity.ANY.American','PricerBlack1FFiniteDifference' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquityIndex.ANY.American','PricerBlack1FFiniteDifference' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquity.ANY.European','PricerBlack1FAnalyticDiscreteVanilla' )
go
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ('default','ETOEquityIndex.ANY.European','PricerBlack1PricerBlack1FAnalyticDiscreteVanilla' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_SECURITY_ACCRUAL','tk.core.PricerMeasure',418,'' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_SECURITY_VALUE','tk.core.PricerMeasure',419,'' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_SECURITY_CLEAN_VALUE','tk.core.PricerMeasure',420,'' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SEC_FIN_LIABILITY','tk.core.PricerMeasure',421,'' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRICE_NOTE','tk.core.PricerMeasure',424,'' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRICE_NOTE_ACCRUAL_ADJ','tk.core.PricerMeasure',425,'' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('DV01_SPREAD','tk.core.PricerMeasure',426,'Change in NPV by change in SPREAD on Floating Leg' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PV_OPEN','tk.core.PricerMeasure',427,'NPV previous day + Accrual' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('SUM_FUT_FLOWS','tk.core.PricerMeasure',428,'Sum of the future flows' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_NOTIONAL','tk.pricer.PricerMeasureCANotional',429,'Cross Asset Notional' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('NPV_BASE','tk.core.PricerMeasure',432,'NPV base currency' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRIMARY_NPV_BASE','tk.core.PricerMeasure',433,'NPV primary base currency' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('QUOTING_NPV_BASE','tk.core.PricerMeasure',434,'NPV quoting base currency' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CVA_ALLOCATION','tk.pricer.PricerMeasureCVAFromDB',435,'PL Mark; CVA from BO' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CVA_CREDITSIM','tk.pricer.PricerMeasureCVAFromDB',436,'PL Mark; CVA from ERS' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_COST','tk.pricer.PricerMeasureCACost',437,'Corss Asset COST' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_PV','tk.pricer.PricerMeasureCA_PV',438,'Corss Asset PV' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CA_MARKET_PRICE','tk.pricer.PricerMeasureCAMarketPrice',439,'Corss Asset Market Price' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR_PAR','tk.pricer.PricerMeasureChilean',440,'Chilean Bond Valor Par Measure' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('PRECIO','tk.pricer.PricerMeasureChilean',441,'Chilean Bond Precio Measure' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR_ACTUAL','tk.pricer.PricerMeasureChilean',442,'Chilean Bond Valor Actual Measure' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR','tk.pricer.PricerMeasureChilean',443,'Chilean Bond Valor Measure' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('VALOR_MERCADO','tk.pricer.PricerMeasureChilean',444,'Chilean Bond Valor Mercado Measure' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ('CUMULATIVE_MARGIN','tk.core.PricerMeasure',445,'Sum of all the margin payments made on the trade' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventHedgeValuation','CreEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventLifeCycle','MessageEngine' )
go
INSERT INTO ps_event_config ( event_config_name, event_class, engine_name ) VALUES ('Back-Office','PSEventArray','InventoryEngine' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','LifeCycleEngine','LifeCycleEngineEventFilter' )
go
INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES ('Back-Office','MessageEngine','MessageEngineEntityObjectEventFilter' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','AAA',0,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','AA',1,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','A',2,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','BBB',3,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','BB',4,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','B',5,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','CCC',6,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','CC',7,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','C',8,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','DDD',9,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','DD',10,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Markit','D',11,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','AA+',1,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','AA-',1,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BBB+',3,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BBB-',3,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BB+',4,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','BB-',4,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','B+',5,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','B-',5,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','CCC+',6,'Current' )
go
INSERT INTO rating_values ( agency_name, rating_value, order_id, rating_type ) VALUES ('Fitch','CCC-',6,'Current' )
go
INSERT INTO table_comment ( table_name, table_comment ) VALUES ('bond_exotic_note','Table for Product BondExoticNote' )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('Swap','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CapFloor','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('Swaption','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CancellableSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CancellableXCCySwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('CappedSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('ExtendibleSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('NDS','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SpreadCapFloor','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SpreadSwap','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SpreadLock','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('StructuredProduct','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('FRA','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('Cash','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('SimpleMM','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
INSERT INTO custom_tab_trade_config ( product_type, full_class_name, tab_order ) VALUES ('DualCcyMM','com.calypso.apps.trading.CSATabTradeWindow',0 )
go
add_column_if_not_exists 'entity_attributes','attr_numeric_value','float null'
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2101481,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2142666,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2142762,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2374992,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2514741,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2550812,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2571239,'CASwiftEventCode','CASubjectToScaleBack','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2106933,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2110576,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2110963,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value, attr_numeric_value ) VALUES (2544407,'CASwiftEventCode','SpecialDividend','Boolean','true',1 )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110576,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2544407,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2044628,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CBNS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2551959,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2551971,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2550812,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU,CBNS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111076,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111074,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2106933,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110963,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464424,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CRTS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2142762,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CRTS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2074445,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','CRTS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2571239,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2061013,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2462631,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2514235,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2374992,'CASwiftEventCode','CATradeBasis.CUM','ArrayList','SPCU' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110576,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2544407,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2044628,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XBNS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2550812,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX,XBNS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111076,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2111074,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2106933,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2110963,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XDIV' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2464424,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XRTS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2142762,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XRTS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2074445,'CASwiftEventCode','CATradeBasis.EX','ArrayList','XRTS' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2571239,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2061013,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2514235,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
go
INSERT INTO entity_attributes ( entity_id, entity_type, attr_name, attr_type, attr_value ) VALUES (2374992,'CASwiftEventCode','CATradeBasis.EX','ArrayList','SPEX' )
go
INSERT INTO system_settings ( name, value ) VALUES ('MAIN_ENTRY_STOP_DB_CONNECTIONS','true' )
go
INSERT INTO cds_settlement_matrix_config ( user_name, red_region, red_type, red_jurisdiction, red_sector, seniority, standard, rating, usage, product_type, effective_date, data_value, matrix_id, usage_key ) VALUES ('_ANY_','ANY','ANY','ANY','ANY','ANY','STANDARD','ANY','RECOVERY','CreditDefaultSwap','1970-01-01 00:00:00.0','40',0,'ANY' )
go
INSERT INTO cds_settlement_matrix_config ( user_name, red_region, red_type, red_jurisdiction, red_sector, seniority, standard, rating, usage, product_type, effective_date, data_value, matrix_id, usage_key ) VALUES ('_ANY_','ANY','ANY','ANY','ANY','SUBORDINATE','STANDARD','ANY','RECOVERY','CreditDefaultSwap','1970-01-01 00:00:00.0','20',0,'ANY' )
go
INSERT INTO cds_settlement_matrix_config ( user_name, red_region, red_type, red_jurisdiction, red_sector, seniority, standard, rating, usage, product_type, effective_date, data_value, matrix_id, usage_key ) VALUES ('_ANY_','ANY','ANY','ANY','ANY','ANY','STANDARD','ANY','RECOVERY','CreditDefaultSwapLoan','1970-01-01 00:00:00.0','70',0,'ANY' )
go
add_domain_values 'eventClass','PSEventArray',''
go
add_domain_values 'domainName','AdvanceStandardSingleSwapLegTemplateName','specify the SingleSwapLeg trade template name to be used by hypersurface advance generator' 
go
add_domain_values 'currencyDefaultAttribute','MarginCallAdjLag','DATE_RULE' 
go
add_domain_values 'currencyDefaultAttribute','FundingIndex','Funding Index used in the calculation of Carry Cost on the Liquid Assets Buffer' 
go
add_domain_values 'currencyDefaultAttribute','FundingIndexTenor','Funding Index Tenor in the calculation of Carry Cost on the Liquid Assets Buffer' 
go
add_domain_values 'workflowRuleMessage','AddTransferBusinessReference','' 
go
add_domain_values 'currencyPairAttribute','RegulatoryValidationSource','Name of the FX Rate index which would provide the regulatory FX rate' 
go
add_domain_values 'currencyPairAttribute','RegulatoryTolerance','Regulatory Tolerance percentage' 
go
add_domain_values 'FutureEquity.subtype','ES','Extended settlement based FutureEquity' 
go
add_domain_values 'productType','IOPOIndex','IOPOIndex' 
go
add_domain_values 'productType','MBSFixedRate','MBSFixedRate' 
go
add_domain_values 'productType','MBSArm','MBSArm' 
go
add_domain_values 'productType','SpotPLSweep','SpotPLSweep' 
go
add_domain_values 'domainName','FutureEquity.subtype','FutureEquity product subtypes' 
go
add_domain_values 'CapFloor.subtype','Inflation','' 
go
add_domain_values 'domainName','BillingFeeType','Billing Fee Types'  
go
add_domain_values 'domainName','CurveDividend.gensimple','Simple Curve Dividend generators'  
go
add_domain_values 'CurveDividend.gensimple','DividendDiscrete',''  
go
add_domain_values 'domainName','CurveDividend.gen','Curve Dividend generators'  
go
add_domain_values 'CurveDividend.gen','DividendImplied',''  
go
add_domain_values 'volSurfaceGenerator','Spline',''  
go
add_domain_values 'domainName','AccountSweepingRuleType','Used in acc_sweep_cfg to indicate the rule type.' 
go
add_domain_values 'sdiAttribute','AccountMapping',''  
go
add_domain_values 'tradeKeyword','PositionTransferPrice',''  
go
add_domain_values 'tradeKeyword','PosTransferId','Id of the associated position transfer'  
go
add_domain_values 'tradeKeyword','PosTransferDst','This is the destination trade in a pos transfer' 
go
add_domain_values 'tradeKeyword','HedgeType','Keyword to classify whether a trade is used to hedge an asset or a liability.Values expected are ''Asset'' or ''Liability''.Used in forward ladder analysis' 
go
add_domain_values 'leAttributeType','RequireTripartyRepoAgreement','' 
go
add_domain_values 'domainName','leAttributeType.RequireTripartyRepoAgreement','' 
go
add_domain_values 'leAttributeType.RequireTripartyRepoAgreement','false','' 
go
add_domain_values 'leAttributeType.RequireTripartyRepoAgreement','true','' 
go
add_domain_values 'leAttributeType','RegulatoryRateQuoteSource','Quote Source name for retrieving the regulatory FX Rate' 
go
add_domain_values 'domainName','CountryAttributes','Country attributes' 
go
add_domain_values 'CountryAttributes','CATradeBasis','If true, it means trades have to manage CUM or EX cases.' 
go
add_domain_values 'CountryAttributes','AutoCompensation','If true, process is driven by the fact that the trade deal was executed prior to the ex-date of the CA event and that the delayed settlement after record date appears like a fail. The market attempts to correct itself.' 
go
add_domain_values 'CountryAttributes','ReverseMarketClaim','If true, the market is attempting to correct the dividend flow and in the context of a SBL trade this results in the beneficial owner actually receiving the dividend through the Agent rather than needing to get it back from the counterparty.' 
go
add_domain_values 'function','CreateAnalyticsMeasure','' 
go
add_domain_values 'function','ModifyAnalyticsMeasure','' 
go
add_domain_values 'function','RemoveAnalyticsMeasure','' 
go
add_domain_values 'function','CreateCarveOut','' 
go
add_domain_values 'function','ModifyCarveOut','' 
go
add_domain_values 'function','RemoveCarveOut','' 
go
add_domain_values 'engineEventPoolPolicyAliases','LiquidationEvent','tk.util.TradeLiquidationEventSequencePolicy' 
go
add_domain_values 'engineEventPoolPolicyAliases','PositionEngine','tk.util.PositionEngineSequencePolicy' 
go
add_domain_values 'engineEventPoolPolicies','tk.util.TradeLiquidationSequencePolicy','Sequence Policy for the LiquidationEngine (optional)' 
go
add_domain_values 'engineEventPoolPolicies','tk.util.TradeLiquidationEventSequencePolicy','Sequence Policy of Liquidation Events for the TransferEngine (optional)' 
go
add_domain_values 'engineEventPoolPolicies','tk.util.PositionEngineSequencePolicy','Sequence Policy for the events processed by the position engine' 
go
add_domain_values 'classAuditMode','FeeConfig','' 
go
add_domain_values 'classAuditMode','AnalyticsMeasure','' 
go
add_domain_values 'classAuditMode','Basket','' 
go
add_domain_values 'classAuditMode','BetaValue','' 
go
add_domain_values 'classAuditMode','CARules','' 
go
add_domain_values 'domainName','BondMMDiscountWithAI.Pricer','Pricers for MM Discount bonds with AI' 
go
add_domain_values 'domainName','SwapCrossCurrency.Pricer','Pricers for SwapCrossCurrency' 
go
add_domain_values 'domainName','SwapNonDeliverable.Pricer','Pricers for SwapNonDeliverable' 
go
add_domain_values 'domainName','ETOIR.Pricer','Pricers for ETOIR (exchange traded equity option) trades' 
go
add_domain_values 'domainName','FutureStructuredFlows.Pricer','Pricer for StucturedFlow Futures' 
go
add_domain_values 'domainName','ADR.conversionAgentRole','List party possible role on ADR bust or creation' 
go
add_domain_values 'ADR.conversionAgentRole','Issuer','Default party role for ADR bust or creation' 
go
add_domain_values 'function','CAEdition','function name for Corporate Action edition restriction' 
go
add_domain_values 'function','ViewPortfolioSwapContract','function name for Portfolio Swap Contract view restriction' 
go
add_domain_values 'function','ModifyPortfolioSwapContract','function name for Portfolio Swap Contract edition restriction' 
go
add_domain_values 'restriction','CAEdition','function name for Corporate Action edition restriction' 
go
add_domain_values 'CurveZero.gen','BasisGlobal','Generator for yield curves using basis swaps, single currency or cross-currency.' 
go
add_domain_values 'CurveZero.gen','XCCYForwardBootStrap','Generator of forward curve using cross-currency basis swaps.' 
go
add_domain_values 'CurveZero.gen','XCCYForwardGlobal','Generator of forward curve using cross-currency basis swaps.' 
go
add_domain_values 'CurveBasis.gen','BasisGlobal','Generator for yield curves using basis swaps, single currency or cross-currency.' 
go
add_domain_values 'CurveBasis.gen','XCCYForwardBootStrap','Generator of forward curve using cross-currency basis swaps.' 
go
add_domain_values 'CurveBasis.gen','XCCYForwardGlobal','Generator of forward curve using cross-currency basis swaps.' 
go
add_domain_values 'Warrant.subtype','TradingWarrant','TradingWarrant' 
go
add_domain_values 'Warrant.subtype','CurrencyWarrant','CurrencyWarrant' 
go
add_domain_values 'Warrant.subtype','IndexWarrant','IndexWarrant' 
go
add_domain_values 'Warrant.subtype','InstalmentWarrant','InstalmentWarrant' 
go
add_domain_values 'Warrant.subtype','InvestmentWarrant','InvestmentWarrant' 
go
add_domain_values 'Warrant.subtype','InternationalWarrant','InternationalWarrant' 
go
add_domain_values 'Warrant.subtype','MINI','MINI' 
go
add_domain_values 'Warrant.subtype','CBBC','CBBC' 
go
add_domain_values 'domainName','Warrant.Covered','Warrant.Covered' 
go
add_domain_values 'Warrant.Covered','TradingWarrant','TradingWarrant' 
go
add_domain_values 'Warrant.Covered','InvestmentWarrant','InvestmentWarrant' 
go
add_domain_values 'Warrant.Covered','InternationalWarrant','InternationalWarrant' 
go
add_domain_values 'Warrant.Covered','MINI','MINI' 
go
add_domain_values 'Warrant.Covered','CBBC','CBBC' 
go
add_domain_values 'Warrant.Covered','CurrencyWarrant','CurrencyWarrant' 
go
add_domain_values 'Warrant.Covered','IndexWarrant','IndexWarrant' 
go
add_domain_values 'Warrant.Covered','Capped','Capped' 
go
add_domain_values 'domainName','Warrant.BuyBackPeriod','Warrant.BuyBackPeriod' 
go
add_domain_values 'Warrant.BuyBackPeriod','MINI','MINI' 
go
add_domain_values 'domainName','Warrant.SpecialQuote','Warrant.SpecialQuote' 
go
add_domain_values 'Warrant.SpecialQuote','TradingWarrant','TradingWarrant' 
go
add_domain_values 'Warrant.SpecialQuote','IndexWarrant','IndexWarrant' 
go
add_domain_values 'Warrant.SpecialQuote','InvestmentWarrant','InvestmentWarrant' 
go
add_domain_values 'Warrant.SpecialQuote','InstalmentWarrant','InstalmentWarrant' 
go
add_domain_values 'domainName','Warrant.DivPassThrough','Warrant.DivPassThrough' 
go
add_domain_values 'Warrant.DivPassThrough','TradingWarrant','TradingWarrant'  
go
add_domain_values 'Warrant.DivPassThrough','IndexWarrant','IndexWarrant'  
go
add_domain_values 'Warrant.DivPassThrough','InvestmentWarrant','InvestmentWarrant' 
go
add_domain_values 'Warrant.DivPassThrough','InstalmentWarrant','InstalmentWarrant'  
go
add_domain_values 'Warrant.DivPassThrough','InternationalWarrant','InternationalWarrant'  
go
add_domain_values 'Warrant.DivPassThrough','MINI','MINI'  
go
add_domain_values 'Warrant.DivPassThrough','CBBC','CBBC'  
go
add_domain_values 'domainName','Warrant.DeliveryUnderlying','Warrant.DeliveryUnderlying'  
go
add_domain_values 'Warrant.DeliveryUnderlying','InternationalWarrant','InternationalWarrant'  
go
add_domain_values 'domainName','Warrant.FxType','Warrant.FxType'  
go
add_domain_values 'Warrant.FxType','IndexWarrant','IndexWarrant'  
go
add_domain_values 'Warrant.FxType','TradingWarrant','TradingWarrant'  
go
add_domain_values 'Warrant.FxType','InternationalWarrant','InternationalWarrant'  
go
add_domain_values 'Warrant.FxType','CurrencyWarrant','CurrencyWarrant'  
go
add_domain_values 'domainName','Warrant.Barrier','Warrant.Barrier' 
go
add_domain_values 'Warrant.Barrier','TradingWarrant','TradingWarrant'  
go
add_domain_values 'Warrant.Barrier','IndexWarrant','IndexWarrant'  
go
add_domain_values 'Warrant.Barrier','MINI','MINI'  
go
add_domain_values 'Warrant.Barrier','CBBC','CBBC' 
go
add_domain_values 'domainName','Warrant.Attributes','Warrant.Attributes'   
go
add_domain_values 'Warrant.Attributes','TradingWarrant','TradingWarrant'  
go
add_domain_values 'Warrant.Attributes','IndexWarrant','IndexWarrant' 
go
add_domain_values 'Warrant.Attributes','InvestmentWarrant','InvestmentWarrant'  
go
add_domain_values 'Warrant.Attributes','CurrencyWarrant','CurrencyWarrant' 
go
add_domain_values 'Warrant.Attributes','InternationalWarrant','InternationalWarrant'  
go
add_domain_values 'Warrant.Attributes','CBBC','CBBC'  
go
add_domain_values 'Warrant.Attributes','Capped','Capped'  
go
add_domain_values 'Warrant.Attributes','Exotic','Exotic'  
go
add_domain_values 'domainName','Warrant.AveragePrice','Warrant.AveragePrice'  
go
add_domain_values 'Warrant.AveragePrice','TradingWarrant','TradingWarrant'   
go
add_domain_values 'Warrant.AveragePrice','IndexWarrant','IndexWarrant'  
go
add_domain_values 'domainName','tradeBarriersAction','Exercise Action ofa trade'  
go
add_domain_values 'tradeBarriersAction','KNOCK_OUT',''  
go
add_domain_values 'tradeBarriersAction','KNOCK_IN','' 
go
add_domain_values 'hedgeRelationshipAttributes','MaterialThreshold','Material limit for materiality check'  
go
add_domain_values 'hedgeRelationshipAttributes','CVAMeasure','Must contains the name of the CVA pricer measure to use for Hedge Effectiveness'  
go
add_domain_values 'FASEffMethodPro','Simulation','Simulation' 
go
add_domain_values 'tradeKeyword','FRC Far Leg ID',''  
go
add_domain_values 'tradeKeyword','FRC Near Leg ID',''  
go
add_domain_values 'domainName','BondExoticNote.subtype','Types of bond exotic note'  
go
add_domain_values 'domainName','BondMMDiscountWithAI.subtype','Types of MM Discount bonds with AI'  
go
add_domain_values 'domainName','ETOIR.subtype',''  
go
add_domain_values 'domainName','IRStructuredOption.subtype','IRStructuredOption.subtype domain name' 
go
add_domain_values 'domainName','StaticPricingScriptDefinitionSuites','Names of static pricing script definition suites'  
go
add_domain_values 'StaticPricingScriptDefinitionSuites','alpha','' 
go
add_domain_values 'StaticPricingScriptDefinitionSuites','examples','' 
go
add_domain_values 'StaticPricingScriptDefinitionSuites','gamma','' 
go
add_domain_values 'classAuthMode','FeeConfig','' 
go
add_domain_values 'classAuditMode','BookSubsitutionRequest','' 
go
add_domain_values 'StructuredFlows.subtype','OpenTerm','' 
go
add_domain_values 'StructuredFlows.subtype','RollOver','' 
go
add_domain_values 'StructuredFlows.subtype','Discount','' 
go
add_domain_values 'StructuredFlows.subtype','Standard','' 
go
add_domain_values 'StructuredFlows.subtype','Exotic','' 
go
add_domain_values 'classAuditMode','IOPOIndex','' 
go
add_domain_values 'PositionBasedProducts','FutureEquity','FutureEquity out of box position based product' 
go
add_domain_values 'PositionBasedProducts','BondExoticNote','BondExoticNote out of box position based product' 
go
add_domain_values 'PositionBasedProducts','ETOIR','ETOIR out of box position based product' 
go
add_domain_values 'PositionBasedProducts','PortfolioSwapPosition','' 
go
add_domain_values 'PositionBasedProducts','SpotPLSweep','' 
go
add_domain_values'domainName','bookAttribute.Domiciliation' ,''
go
add_domain_values 'XferAttributes','CATradeBasis',''
go
add_domain_values 'XferAttributes','CATradeBasisOverride','This attribute is used to override CATradeBasis attribute.' 
go
add_domain_values 'XferAttributes','SwapNDNativeCurrency','' 
go
add_domain_values 'XferAttributes','SwapNDNativeInterestAmt',''
go
add_domain_values 'XferAttributes','SwapNDIntermediateCurrency','' 
go
add_domain_values 'XferAttributes','SwapNDIntermediateResetDate','' 
go
add_domain_values 'XferAttributes','SwapNDIntermediateResetRate','' 
go
add_domain_values 'XferAttributes','SwapNDIntermediateFXDescription','' 
go
add_domain_values 'XferAttributes','SwapNDSettlementResetDate','' 
go
add_domain_values 'XferAttributes','SwapNDSettlementResetRate','' 
go
add_domain_values 'XferAttributes','SwapNDSettlementFXDescription','' 
go
add_domain_values 'domainName','ProductUseTermFrame','list of products using the new Termination Window' 
go
add_domain_values 'ProductUseTermFrame','CreditDefaultSwap','' 
go
add_domain_values 'ProductUseTermFrame','EquityLinkedSwap','' 
go
add_domain_values 'keyword.TerminationReason.Advance','Prepayment','' 
go
add_domain_values 'keyword.TerminationReason.Advance','NotionalIncrease','' 
go
add_domain_values 'keyword.TerminationReason.Advance','Manual','' 
go
add_domain_values 'keyword.TerminationReason.Advance','BoughtBack','' 
go
add_domain_values 'keyword.TerminationReason.Advance','BookTransfer','' 
go
add_domain_values 'systemKeyword','TransferPayIntFlow',''  
go
add_domain_values 'systemKeyword','TransferReason','' 
go
add_domain_values 'domainName','simulationCustomVolatilityType',''  
go
add_domain_values 'futureUnderType','StructuredFlows',''  
go
add_domain_values 'ETOUnderlyingType','IR',''  
go
add_domain_values 'feeCalculator','FeeConfig',''  
go
add_domain_values 'scheduledTask','TENOR_RANGE_EXECUTOR','This schedule task execute other schedule task recursively over a time interval defined by tenor range'  
go
add_domain_values 'scheduledTask','IMPORT_INDUSTRY_HIERARCHY','Load an industry hierarchy from file' 
go
add_domain_values 'scheduledTask','IMPORT_MARKET_INDEX_CONSTITUENTS','Import a market index''s constituents from file'  
go
add_domain_values 'scheduledTask','IMPORT_MARKET_INDEX_DEFINITIONS','Import market index definitions from file' 
go
add_domain_values 'scheduledTask','IMPORT_ANALYTICS','Import analytics from file'  
go
add_domain_values 'scheduledTask','IMPORT_ANALYTICS_CREDIT_RATING','Import analytics credit rating from file'  
go
add_domain_values 'scheduledTask','PROCESS_ADJUSTMENTS','process generate/update/cancel adjustements'  
go
add_domain_values 'scheduledTask','EOD_SPOT_PLSWEEP','Spot PL Sweep'  
go
add_domain_values 'workflowRuleTrade','CheckFXSpotRateTolerance','The rule checks if the spot rate for the FX trade falls within the regulatory tolerance specified for the currency pair' 
go
add_domain_values 'userAttributes','FX Default Trade Role','' 
go
add_domain_values 'userAttributes','FX Default Rollover Type','Default FX rollover type selection on opening the FX rollover window' 
go
add_domain_values 'userAttributes','Default Pricing Grid Auto Update Dispatcher','Default dispatcher configuration for Pricing Grid auto recalculation' 
go
add_domain_values 'productType','IRStructuredOption','IRStructuredOption' 
go
add_domain_values 'CommodityUnit','MT','Metric Tonnes' 
go
add_domain_values 'productType','PortfolioSwap','' 
go
add_domain_values 'productType','PortfolioSwapPosition','' 
go
add_domain_values 'domainName','issuerSector','Domain to hold list of available sectors' 
go
add_domain_values'bookAttribute.Domiciliation','Onshore','' 
go
add_domain_values'bookAttribute.Domiciliation','Offshore',''  
go
add_domain_values 'tradeAction','LATE_CANCEL','Late cancellation of a trade.' 
go
add_domain_values 'transferAction','LATE_CANCEL','Late cancellation of a trade'  
go
add_domain_values 'messageAction','LATE_CANCEL','Late cancellation of a trade'  
go
add_domain_values 'ScenarioViewerClassNames','apps.risk.ScenarioAnalysisViewer','the old default scenario risk viewer, replaced by ScenarioRiskAnalysisViewer'  
go
add_domain_values 'creditRatingSource','Markit','Rating Agency which would configured in pricer config as well in probability curve creation'
go
add_domain_values 'PCCreditRatingLEAttributesOrder','RED_SECTOR,RED_REGION','Comma seperated legal entity attribute names' 
go
add_domain_values 'issuerSector','Basic materials','Sector Basic materials' 
go
add_domain_values 'issuerSector','Consumer goods','Sector Consumer goods' 
go
add_domain_values 'issuerSector','Consumer services','Sector Consumer services' 
go
add_domain_values 'issuerSector','Industrials','Sector Industrials' 
go
add_domain_values 'issuerSector','Healthcare','Sector Healthcare' 
go
add_domain_values 'issuerSector','Oil and Gas','Sector Oil and Gas' 
go
add_domain_values 'issuerSector','Technology','Sector Technology' 
go
add_domain_values 'issuerSector','Telecommunications','Sector Telecommunications' 
go
add_domain_values 'issuerSector','Utilities','Sector Utilities' 
go
add_domain_values 'issuerSector','Financials','Sector Financials' 
go
add_domain_values 'issuerSector','Government','Sector Government' 
go
add_domain_values 'AccountSetup','ACCOUNT_TRADE_SEED','false' 
go
add_domain_values 'AccountSetup','CALL_ACCOUNT_INTERNAL_VIEW','false' 
go
add_domain_values 'AccountSetup','ACCOUNT_SHARE_TRADE_SEED','false' 
go
add_domain_values 'AccountSetup','CALL_ACCOUNT_NAME_EQUALS_ID','false' 
go
add_domain_values 'AccountSetup','ACCESS_PERCENTAGE','false' 
go
add_domain_values 'BondAssetBacked.collateralType','IOS Index','' 
go
add_domain_values 'BondAssetBacked.collateralType','POS Index','' 
go
add_domain_values 'BondAssetBacked.collateralType','Fannie Agency Pools','' 
go
add_domain_values 'FeeBillingRuleAttributes','MatchBook','' 
go
add_domain_values 'FeeBillingRuleAttributes','BillingOnly','' 
go
add_domain_values 'FeeBillingRuleAttributes','EntryType','' 
go
add_domain_values 'FeeBillingRuleAttributes','XferByBook','' 
go
add_domain_values 'corporateActionType','ACCRUAL.BONUS','' 
go
add_domain_values 'corporateActionType','ACCRUAL.EQUITYOFFERING',''  
go
add_domain_values 'corporateActionType','ACCRUAL.REINVEST',''  
go
add_domain_values 'corporateActionType','ACCRUAL.RIGHTS_CPN',''  
go
add_domain_values 'corporateActionType','ACCRUAL.STOCK_DIV',''  
go
add_domain_values 'corporateActionType','ACCRUAL.TAX',''  
go
add_domain_values 'corporateActionType','ACQUISITION.CASH_OFFER',''  
go
add_domain_values 'corporateActionType','ACQUISITION.OPA',''  
go
add_domain_values 'corporateActionType','ACQUISITION.OPE',''  
go
add_domain_values 'corporateActionType','ACQUISITION.STOCK_OFFER',''  
go
add_domain_values 'corporateActionType','ADR.ADR',''  
go
add_domain_values 'corporateActionType','AMORTIZATION.AMORTIZATION',''  
go
add_domain_values 'corporateActionType','AMORTIZATION.PIK_INTEREST',''  
go
add_domain_values 'corporateActionType','CASH.ADJUSTMENT',''  
go
add_domain_values 'corporateActionType','CASH.BIDS',''  
go
add_domain_values 'corporateActionType','CASH.CAPITALRETURN',''  
go
add_domain_values 'corporateActionType','CASH.DIVIDEND',''   
go
add_domain_values 'corporateActionType','CASH.INSTALLMENT_CALL',''  
go
add_domain_values 'corporateActionType','CASH.INTEREST',''  
go
add_domain_values 'corporateActionType','CASH.ODD_LOT',''  
go
add_domain_values 'corporateActionType','CASH.REBATE',''  
go
add_domain_values 'corporateActionType','CASH.RIGHT_ISSUE',''   
go
add_domain_values 'corporateActionType','EXERCISE.ASSIGNMENT','' 
go
add_domain_values 'corporateActionType','EXERCISE.EXERCISE','' 
go
add_domain_values 'corporateActionType','EXPIRY.BARRIER_DEACTIVATION','' 
go
add_domain_values 'corporateActionType','EXPIRY.EXPIRY','' 
go
add_domain_values 'corporateActionType','EXPIRY.MARK_DOWN','' 
go
add_domain_values 'corporateActionType','EXPIRY.MDE',''
go
add_domain_values 'corporateActionType','FUTURE.FUTURE','' 
go
add_domain_values 'corporateActionType','MERGER.MERGER',''
go
add_domain_values 'corporateActionType','MERGER.RIGHTS_CALL','' 
go
add_domain_values 'corporateActionType','PAYDOWN.PAYDOWN',''
go
add_domain_values 'corporateActionType','REDEMPTION.BUYBACK','' 
go
add_domain_values 'corporateActionType','REDEMPTION.CALL_REDEMPTION',''
go
add_domain_values 'corporateActionType','REDEMPTION.DELISTING','' 
go
add_domain_values 'corporateActionType','REDEMPTION.DRAWING','' 
go
add_domain_values 'corporateActionType','REDEMPTION.LOTTERY_WINNER','' 
go
add_domain_values 'corporateActionType','REDEMPTION.PRINCIPAL','' 
go
add_domain_values 'corporateActionType','REDEMPTION.REDEMPTION','' 
go
add_domain_values 'corporateActionType','REFERENTIAL.CALL_REDEMPTION',''  
go
add_domain_values 'corporateActionType','REFERENTIAL.REFERENTIAL',''  
go
add_domain_values 'corporateActionType','RESET.RESET','' 
go
add_domain_values 'corporateActionType','SPINOFF.SPINOFF',''  
go
add_domain_values 'corporateActionType','TRANSFORMATION.ASSIMILATION',''  
go
add_domain_values 'corporateActionType','TRANSFORMATION.CONVERTIBLE',''  
go
add_domain_values 'corporateActionType','TRANSFORMATION.IMPAIRMENT','' 
go
add_domain_values 'corporateActionType','TRANSFORMATION.SPLIT','' 
go
add_domain_values 'corporateActionType','UNMAPPED.UNMAPPED','' 
go
add_domain_values 'domainName','CASwiftEventCodeAttributes','Attributes qualifying Swift event code and interprted to process CorporateAction' 
go
add_domain_values 'CASwiftEventCodeAttributes','CATradeBasis.CUM','Trade attribute indicating operation CUM dividend' 
go
add_domain_values 'CASwiftEventCodeAttributes','CATradeBasis.EX','Trade attribute indicating operation EX dividend' 
go
add_domain_values 'CASwiftEventCodeAttributes','CASubjectToScaleBack','Boolean value indicating if Corporate Action is subject to scale back' 
go
add_domain_values 'CASwiftEventCodeAttributes','SpecialDividend','Boolean value indicating if Corporate Action can be marked as a special dividend'  
go
add_domain_values 'CASwiftEventCodeAttributes','CAModelSubtype','an ordered List of model.subtype.CAOP assigned to CA EVent' 
go
add_domain_values 'CASwiftEventCodeAttributes','CASwiftEventChoice','MAND CHOS or VOLU event choice' 
go
add_domain_values 'CASwiftEventCodeAttributes','CASwiftEventProcess','Enum of Distribution(DISN), Reorganisation(REOR) or General(GENL)'  
go
add_domain_values 'classAuthMode','CASwiftEventCodeAttributes','tk.product.corporateaction' 
go
add_domain_values 'domainName','lifeCycleEntityObject','Simple name of EntityObject for which exists a LifyCycleHandler' 
go
add_domain_values 'bondType','BondMMDiscountWithAI','' 
go
add_domain_values 'bondType','BondExoticNote','bondtype domain' 
go
add_domain_values 'bondType','MBSFixedRate','bondType Domain' 
go
add_domain_values 'bondType','MBSArm','bondType Domain' 
go
add_domain_values 'BondExoticNote.Pricer','PricerBlackNFMonteCarloExotic','Pricer for BondExoticNote' 
go
add_domain_values 'BondMMDiscountWithAI.Pricer','PricerBondMMDiscount','MM Discount bond With AI Pricer' 
go
add_domain_values 'Bond.Pricer','PricerLGMM1FSaliTree','LGMM1F Sali Tree Pricer' 
go
add_domain_values 'CapFloor.Pricer','PricerCapFloorInflationBlack','Pricer Cap Floor Inflation Black' 
go
add_domain_values 'ETOIR.Pricer','PricerETOIR','' 
go
add_domain_values 'Swap.Pricer','PricerSwapLGMM1F','Pricer for a Swap with a Bermudan cancellable schedule.' 
go
add_domain_values 'SwapCrossCurrency.Pricer','PricerSwap','' 
go
add_domain_values 'SwapCrossCurrency.Pricer','PricerExoticSwap','' 
go
add_domain_values 'SwapNonDeliverable.Pricer','PricerSwap','' 
go
add_domain_values 'Bond.Pricer','PricerBondChilean','Pricer for Chilean Bonds.' 
go
add_domain_values 'Swaption.Pricer','PricerSwaptionLGMM1F','' 
go
add_domain_values 'ETOEquityIndex.Pricer','PricerBlack1FAnalyticDiscreteVanilla','Analytic Black-Scholes pricer for european options using discrete (escrowed) dividend or continuous yield' 
go
add_domain_values 'ETOEquityIndex.Pricer','PricerBlack1FFiniteDifference','Finite difference pricer for american or european options' 
go
add_domain_values 'FutureStructuredFlows.Pricer','PricerFutureStructuredFlows','' 
go
add_domain_values 'ETOEquity.Pricer','PricerBlack1FAnalyticDiscreteVanilla','European Analytic Pricer following the Black-Scholes model' 
go
add_domain_values 'ETOEquity.Pricer','PricerBlack1FFiniteDifference','Finite Difference Pricer for single asset european or american or bermudan option' 
go
add_domain_values 'Bond.subtype','BondExoticNote','subtype for bond exotic note' 
go
add_domain_values 'Warrant.extendedType','European','' 
go
add_domain_values 'Warrant.extendedType','American','' 
go
add_domain_values 'FutureEquity.extendedType','FutureEquity','' 
go
add_domain_values 'FutureEquity.extendedType','FutureEquityES','' 
go
add_domain_values 'BondExoticNote.subtype','Standard','BondExoticNote subtype' 
go
add_domain_values 'BondMMDiscountWithAI.subtype','Discount','' 
go
add_domain_values 'CA.subtype','ADJUSTMENT','' 
go
add_domain_values 'CA.subtype','ADR','' 
go
add_domain_values 'CA.subtype','BIDS','' 
go
add_domain_values 'CA.subtype','BONUS',''
go
add_domain_values 'CA.subtype','BUYBACK','' 
go
add_domain_values 'CA.subtype','CAPITALRETURN','' 
go
add_domain_values 'CA.subtype','CASH_OFFER','' 
go
add_domain_values 'CA.subtype','CONVERTIBLE','' 
go
add_domain_values 'CA.subtype','DELISTING','' 
go
add_domain_values 'CA.subtype','EQUITYOFFERING','' 
go
add_domain_values 'CA.subtype','FUTURE','' 
go
add_domain_values 'CA.subtype','INSTALLMENT_CALL','' 
go
add_domain_values 'CA.subtype','LOTTERY_WINNER','' 
go
add_domain_values 'CA.subtype','MDE','' 
go
add_domain_values 'CA.subtype','MERGER','' 
go
add_domain_values 'CA.subtype','ODD_LOT','' 
go
add_domain_values 'CA.subtype','OPA','' 
go
add_domain_values 'CA.subtype','OPE','' 
go
add_domain_values 'CA.subtype','PAYDOWN','' 
go
add_domain_values 'CA.subtype','PIK_INTEREST','' 
go
add_domain_values 'CA.subtype','PRINCIPAL','' 
go
add_domain_values 'CA.subtype','REFERENTIAL','' 
go
add_domain_values 'CA.subtype','REINVEST','' 
go
add_domain_values 'CA.subtype','RESET','' 
go
add_domain_values 'CA.subtype','RIGHTS_CALL','' 
go
add_domain_values 'CA.subtype','RIGHTS_CPN','' 
go
add_domain_values 'CA.subtype','RIGHT_ISSUE','' 
go
add_domain_values 'CA.subtype','SPINOFF','' 
go
add_domain_values 'CA.subtype','STOCK_DIV','' 
go
add_domain_values 'CA.subtype','TAX','' 
go
add_domain_values 'CA.subtype','STOCK_OFFER','' 
go
add_domain_values 'CA.subtype','UNMAPPED','' 
go
add_domain_values 'domainName','CA.Status','All possible Corporate Action Status' 
go
add_domain_values 'domainName','CA.ApplicableStatus','Corporate Action Status allowing CA application' 
go
add_domain_values 'domainName','CA.CanceledStatus','Corporate Action Status resulting in cancellation of previously created CA Trade' 
go
add_domain_values 'CA.Status','NOT_APPLICABLE','Default Non Applicable Event Status - no application of CA occurs, no CA Trade is created' 
go
add_domain_values 'CA.Status','APPLICABLE','' 
go
add_domain_values 'CA.Status','CANCELED','' 
go
add_domain_values 'CA.Status','REMOVED','' 
go
add_domain_values 'CA.ApplicableStatus','APPLICABLE','Default Applicable Event Status - CA application results in created CA Trade' 
go
add_domain_values 'CA.CanceledStatus','CANCELED','Default Canceled Event Status - CA application results in cancellation of any of previously created CA Trade' 
go
add_domain_values 'CA.CanceledStatus','REMOVED','' 
go
add_domain_values 'engineName','LifeCycleEngine','' 
go
add_domain_values 'ETOIR.subtype','European','' 
go
add_domain_values 'ETOIR.subtype','American','' 
go
add_domain_values 'IRStructuredOption.subtype','European','' 
go
add_domain_values 'IRStructuredOption.subtype','American','' 
go
add_domain_values 'interpolator','InterpolatorLogSpline','Cubic spline interpolator on logarithms.' 
go
add_domain_values 'eventClass','PSEventCalculationServerJobStatus','PSEvent indicating the Calculation Server run status for MarketData update cycle' 
go
add_domain_values 'eventClass','PSEventScheduledTaskExec','' 
go
add_domain_values 'eventClass','PSEventMktDataServerAdmin','' 
go
add_domain_values 'eventFilter','FutureAndCfdLiquidationEventFilter','Future and Cfd Liquidation Event Filter' 
go
add_domain_values 'eventClass','PSEventLifeCycle','' 
go
add_domain_values 'eventClass','PSEventEntityObject',''
go
add_domain_values 'eventFilter','LifeCycleEngineEventFilter','Filter to select only PSEvent applicable for LifeCycleHandler' 
go
add_domain_values 'eventFilter','MessageEngineEntityObjectEventFilter','Filter to select only PSEventEntityObject for which exists a BOMessageHandler' 
go
add_domain_values 'eventType','REMOVE_HEDGE_TRADE','' 
go
add_domain_values 'eventType','EX_CA_INFORMATION','Indicates an information published by the ScheduledTaskCORPORATE_ACTON concerning its execution.' 
go
add_domain_values 'eventType','EX_EOD_SPOT_PLSWEEP_SUCCESS','' 
go
add_domain_values 'eventType','EX_EOD_SPOT_PLSWEEP_FAILURE','' 
go
add_domain_values 'exceptionType','EOD_SPOT_PLSWEEP_SUCCESS','' 
go
add_domain_values 'exceptionType','EOD_SPOT_PLSWEEP_FAILURE','' 
go
add_domain_values 'eventType','EX_CREATE_POSITION_SNAPSHOT_SUCCESS','The position snapshot creation scheduled task was successful.' 
go
add_domain_values 'exceptionType','CREATE_POSITION_SNAPSHOT_SUCCESS','' 
go
add_domain_values 'eventType','EX_CREATE_POSITION_SNAPSHOT_FAILURE','The position snapshot creation scheduled task was not successful.' 
go
add_domain_values 'exceptionType','CREATE_POSITION_SNAPSHOT_FAILURE','' 
go
add_domain_values 'eventType','EX_CREATE_POSITION_SNAPSHOT_INFORMATION','The position snapshot creation scheduled task generated extra information.' 
go
add_domain_values 'exceptionType','CREATE_POSITION_SNAPSHOT_INFORMATION',''
go
add_domain_values 'feeCalculator','PortfolioSwapCommission','fee calculator for Portfolio Swap' 
go
add_domain_values 'exceptionType','CA_INFORMATION','' 
go
add_domain_values 'flowType','SECLENDING_FEE','' 
go
add_domain_values 'function','ApplyCA','Access permission to apply a CA' 
go
add_domain_values 'function','ModifyCA','Access permission to modify CA product' 
go
add_domain_values 'function','AddRemoveCAToProduct','Access permission to add/remove a CA to product' 
go
add_domain_values 'function','AddRemoveCAOption','Access permission to add/remove a CA option' 
go
add_domain_values 'function','OnDemandMktDataRefresh','Access permission to perform on demand market data refresh in CWS' 
go
add_domain_values 'function','ModifyStressParametersTables','Access permission to create/modify/delete stress tables.' 
go
add_domain_values 'function','ViewStressParametersTables','Access permission to view stress tables.' 
go
add_domain_values 'function','AuthorizeLegalEntityDisabled','Access permission to Authorize Legal Entities in Disabled status' 
go
add_domain_values 'function','AuthorizeLegalEntityEnabled','Access permission to Authorize Legal Entities in Enabled status' 
go
add_domain_values 'function','AuthorizeLegalEntityPending','Access permission to Authorize Legal Entities in Pending status' 
go
add_domain_values 'function','ReadPriceFromTradePriceReport','Permission to allow user to read price from trade price report' 
go
add_domain_values 'function','SavePriceFromTradePriceReport','Permission to allow user to save price from trade price report' 
go
add_domain_values 'function','DeletePriceFromTradePriceReport','Permission to allow user to delete price from trade price report'
go
add_domain_values 'function','CreateHedgeRelationshipConfiguration','Access permission to create Hedge Relationship Config' 
go
add_domain_values 'function','ModifyHedgeRelationshipConfiguration','Access permission to modify Hedge Relationship Config' 
go
add_domain_values 'function','RemoveHedgeRelationshipConfiguration','Access permission to remove Hedge Relationship Config' 
go
add_domain_values 'billingEvents','BillingTradeEvent',''
go
add_domain_values 'billingEvents','BillingMaintenanceTradeEvent' ,''
go
add_domain_values 'function','ViewBetaMatrix','Access Permission to allow selection of multiple Market Data Server configurations'  
go
add_domain_values 'function','ModifyBetaMatrix','Access Permission to allow selection of multiple Market Data Server configurations'  
go
add_domain_values 'function','ViewCARules','Access Permission to allow selection of multiple Market Data Server configurations' 
go
add_domain_values 'function','ModifyCARules','Access Permission to allow selection of multiple Market Data Server configurations'  
go
add_domain_values 'liquidationMethod','HIFO',''  
go
add_domain_values 'billingCalculators','BillingFeeConfigCalculator' ,'' 
go
add_domain_values 'billingCalculators','BillingTradeFeeRebateCalculator','' 
go
add_domain_values 'productType','BondExoticNote','produttype domain'  
go
add_domain_values 'productType','SwapCrossCurrency','' 
go
add_domain_values 'productType','SwapNonDeliverable','' 
go
add_domain_values 'productType','FutureStructuredFlows','' 
go
add_domain_values 'productType','BondMMDiscountWithAI','' 
go
add_domain_values 'productType','ETOIR','' 
go
add_domain_values 'productType','CallAccount','' 
go
add_domain_values 'StructuredFlows.Pricer','PricerExoticStructuredFlows','Pricer to pricer exotic StructuredFlows product' 
go
add_domain_values 'quoteType','WS','WorldScale' 
go
add_domain_values 'quoteType','UnitaryPrice','' 
go
add_domain_values 'quoteType','GrossUnitaryPrice','' 
go
add_domain_values 'role','Remitter','' 
go
add_domain_values 'riskAnalysis','HedgeEffectivenessProspective','' 
go
add_domain_values 'role','Seller','Seller' 
go
add_domain_values 'role','Servicer','Servicer' 
go
add_domain_values 'scheduledTask','GENERATE_EQUITY_VOL_INSTRUMENTS','' 
go
add_domain_values 'scheduledTask','SECFINANCE_AUTOMARK','' 
go
add_domain_values 'scheduledTask','SECFINANCE_UPDATE_SETTLEMENTDATE','' 
go
add_domain_values 'scheduledTask','FUTURE_VARIATION_MARGIN','EOD Future Variation Margin' 
go
add_domain_values 'scheduledTask','WARRANT_PROCESSING','Process Warrant Corporate Actions (exercice, expiry) and upgrades floating strikes' 
go
add_domain_values 'yieldMethod','ThaiBMA','' 
go
add_domain_values 'riskPresenter','Rebalancing','' 
go
add_domain_values 'FutureContractAttributes','UseMarginCallAdjLag','Use date rule attached to currency definition' 
go
add_domain_values 'FutureContractAttributes.UseMarginCallAdjLag','Yes','' 
go
add_domain_values 'FutureContractAttributes.UseMarginCallAdjLag','No','' 
go
add_domain_values 'FutureContractAttributes','DaylightSavingTime','Daylight Saving Time to apply associated with electricity contract.' 
go
add_domain_values 'productInterfaceReportStyle','CorporateActionBased','CorporateActionBased ReportStyle' 
go
add_domain_values 'productTypeReportStyle','BondExoticNote','BondExoticNote ReportStyle' 
go
add_domain_values 'productTypeReportStyle','ETOIR','ETOIR ReportStyle' 
go
add_domain_values 'productTypeReportStyle','IRStructuredOption','IRStructured Option ReportStyle' 
go
add_domain_values 'CommodityType','Freight','Freight' 
go
add_domain_values 'domainName','volSurfaceGenerator.equity','Equity derived volatility surface generators' 
go
add_domain_values 'volSurfaceGenerator.equity','ETO','ETO' 
go
add_domain_values 'volSurfaceGenerator.equity','OTCEquityOption','OTCEquityOption' 
go
add_domain_values 'volSurfaceGenerator.equity','Heston','Heston' 
go
add_domain_values 'volSurfaceGenerator.equity','Spline','Volatility surface by spline interpolation' 
go
add_domain_values 'volSurfaceGenerator.equity','SVI','SVI' 
go
add_domain_values 'domainName','volSurfaceGenSimple.equity','Equity non-derived volatility surface generators' 
go
add_domain_values 'volSurfaceGenSimple.equity','SVISimple','SVISimple' 
go
add_domain_values 'volSurfaceGenSimple.equity','SABRSimple','SABRSimple' 
go
add_domain_values 'volSurfaceGenSimple.equity','Default','Default' 
go
add_domain_values 'tradeKeyword','CAManualAmend','YES or NO: a CA Trade that will be excluded from automated CA Application' 
go
add_domain_values 'domainName','keyword.CAManualAmend','' 
go
add_domain_values 'keyword.CAManualAmend','YES',''
go
add_domain_values 'keyword.CAManualAmend','NO' ,''
go
add_domain_values 'tradeKeyword','ContractDivRate','SBL Contract Div Rate'  
go
add_domain_values 'tradeKeyword','CATradeBasis','Trade was executed CUM or EX (MT540-43 :22F::TTCO//4!c)' 
go
add_domain_values 'XferAttributesForMatching','CATradeBasis',''  
go
add_domain_values 'tradeKeyword','BasisOfQuote','Agent codification matching CATradeBasis, indicated if Trade was executed CUM or EX' 
go
add_domain_values 'XferAttributesForMatching','BasisOfQuote','' 
go
add_domain_values 'domainName','keyword.CATradeBasis','MultipleSelection of keyword value allowed. Trade was executed CUM or EX (MT540-43 :22F::TTCO//4!c)' 
go
add_domain_values 'keyword.CATradeBasis','CBNS','Cum Bonus - Trade was executed cum bonus. ' 
go
add_domain_values 'keyword.CATradeBasis','CDIV','Cum Dividend - Trade was executed cum dividend. ' 
go
add_domain_values 'keyword.CATradeBasis','CRTS','Cum Rights - Trade was executed cum rights. ' 
go
add_domain_values 'keyword.CATradeBasis','XBNS','Ex Bonus - Trade was executed ex bonus. ' 
go
add_domain_values 'keyword.CATradeBasis','XDIV','Ex Dividend - Trade was executed ex dividend. ' 
go
add_domain_values 'keyword.CATradeBasis','XRTS','Ex Rights - Trade was executed ex rights. ' 
go
add_domain_values 'keyword.CATradeBasis','SPCU','Special Cum - Trade was executed with a special cum condition' 
go
add_domain_values 'keyword.CATradeBasis','SPEX','Special Ex - Trade was executed with a special ex condition' 
go
add_domain_values 'CA.keywords','CAFailedTransfer','transfer id for claim trade' 
go
add_domain_values 'CA.keywords','CAFractionalShares','remaining shares in case of security event' 
go
add_domain_values 'accEventType','CVA_EXPOSURE','CVA Amount' 
go
add_domain_values 'domainName','cvaExposureBookName','Default Book to Import CVA per Counterparty' 
go
add_domain_values 'domainName','CVAExposure.Pricer','Pricer for CVA Exposure product' 
go
add_domain_values 'CVAExposure.Pricer','PricerSimpleTransfer','Pricer for CVA Exposure product' 
go
add_domain_values 'productType','CVAExposure','' 
go
add_domain_values 'flowType','CVA_PLMARKING','' 
go
add_domain_values 'scheduledTask','EOD_CVAALLOCATION','' 
go
add_domain_values 'scheduledTask','EOD_CVAPLMARKING','' 
go
add_domain_values 'measuresForAdjustment','CVA_ALLOCATION','' 
go
add_domain_values 'domainName','IRStructuredOption.Pricer','Pricers for IRStructuredOption' 
go
add_domain_values 'systemKeyword','ReportingCcyData','Internal keyword to carry over reporting currency data for the trade' 
go
add_domain_values 'systemKeyword','ReportingCcyDataFarLeg','Internal keyword to carry over reporting currency data for the trade' 
go
add_domain_values 'tradeKeyword','ReportingCcyData','Internal keyword to carry over reporting currency data for the trade' 
go
add_domain_values 'tradeKeyword','ReportingCcyDataFarLeg','Internal keyword to carry over reporting currency data for the trade' 
go
add_domain_values 'workflowRuleTrade','EsoKnockIn','Knock-In Rule for EquityStructuredOption' 
go
add_domain_values 'domainName','EsoKnockInTradeRule.PricingEnvName','Default PricingEnvName for EsoKnockInTradeRule' 
go
add_domain_values 'domainName','Swift.UserHeader.Service Identifier.EUR','Swift Header''s Block 3 values expected in tag103' 
go
add_domain_values 'Swift.UserHeader.Service Identifier.EUR','TGT',''
go
add_domain_values 'accountProperty','Platform.TGT','Specify is this is the account for Platform TGT' 
go
add_domain_values 'domainName','accountProperty.Platform.TGT','' 
go
add_domain_values 'accountProperty.Platform.TGT','False','' 
go
add_domain_values 'accountProperty.Platform.TGT','True','' 
go
add_domain_values 'Swift.UserHeader.Service Identifier.EUR','EBA',''
go
add_domain_values 'accountProperty','Platform.EBA','Specify is this is the account for Platform EBA' 
go
add_domain_values 'domainName','accountProperty.Platform.EBA','' 
go
add_domain_values 'accountProperty.Platform.EBA','False','' 
go
add_domain_values 'accountProperty.Platform.EBA','True','' 
go
add_domain_values 'Swift.UserHeader.Service Identifier.EUR','STC','' 
go
add_domain_values 'accountProperty','Platform.STC','Specify is this is the account for Platform STC' 
go
add_domain_values 'domainName','accountProperty.Platform.STC','' 
go
add_domain_values 'accountProperty.Platform.STC','False','' 
go
add_domain_values 'accountProperty.Platform.STC','True','' 
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_POSITION_CASH','' 
go
add_domain_values 'plMeasure','Cost_Of_Funding_Full_PnL','' 
go
add_domain_values 'plMeasure','Cost_Of_Opportunity_Full_PnL','' 
go
add_domain_values 'plMeasure','Cost_Of_Opportunity_PnL','' 
go
add_domain_values 'plMeasure','Realized_Fees_Full_PnL','' 
go
add_domain_values 'plMeasure','Realized_Fees_PnL','' 
go
add_domain_values 'plMeasure','Total_Fees_Full_PnL','' 
go
add_domain_values 'plMeasure','Total_Fees_PnL','' 
go
add_domain_values 'plMeasure','Settlement_Date_PnL_Base','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','UNSETTLED_CASH','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_UNSETTLED_CASH','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','CA_PV','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','CA_COST','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_FEES_UNSETTLED','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH','' 
go
add_domain_values 'PricerMeasurePnlOTCEOD','HISTO_CUMULATIVE_CASH_INTEREST','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','CA_PV','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','CA_COST','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_FEES_UNSETTLED','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_CUMULATIVE_CASH','' 
go
add_domain_values 'PricerMeasurePnlEquitiesEOD','HISTO_BOOK_VALUE','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','ACCUMULATED_ACCRUAL','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_ACCUMULATED_ACCRUAL','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','CA_COST','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','CA_PV','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_FEES_UNSETTLED','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH_INTEREST','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH','' 
go
add_domain_values 'PricerMeasurePnlMMEOD','HISTO_CUMULATIVE_CASH_PRINCIPAL','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','CA_PV','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','CA_COST','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_FEES_UNSETTLED','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_INTEREST','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH','' 
go
add_domain_values 'PricerMeasurePnlRepoEOD','HISTO_CUMULATIVE_CASH_PRINCIPAL','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','CUMULATIVE_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','FEES_UNSETTLED','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','FEES_UNSETTLED_SD','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_FEES_UNSETTLED','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_UNSETTLED_CASH_FEES','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','CA_COST','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','CA_PV','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_CLEAN_BOOK_VALUE','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_CUMULATIVE_CASH','' 
go
add_domain_values 'PricerMeasurePnlBondsEOD','HISTO_CLEAN_REALIZED','' 
go
add_domain_values 'PricerMeasurePnlFXEOD','CA_PV','' 
go
add_domain_values 'PricerMeasurePnlFXEOD','CA_COST','' 
go
add_domain_values 'PricerMeasurePnlFuturesEOD','UNSETTLED_CASH_FEES',''  
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_UNSETTLED_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','CA_PV',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','CA_COST',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_CUMULATIVE_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlFuturesEOD','HISTO_FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlETOEOD','UNSETTLED_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_UNSETTLED_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlETOEOD','CA_PV',''
go
add_domain_values 'PricerMeasurePnlETOEOD','CA_COST',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlETOEOD','HISTO_FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','ACCUMULATED_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CA_MARKET_PRICE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CA_NOTIONAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CA_QUANTITY',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CLEAN_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_BOOK_VALUE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_PRINCIPAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CLEAN_REALIZED',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_UNSETTLED_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CA_PV',''
go
add_domain_values 'PricerMeasurePnlBondsEOD','ACCRUAL_SETTLE_DATE',''
go
add_domain_values 'PricerMeasurePnlAllEOD','CA_COST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_FEES',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_ACCUMULATED_ACCRUAL',''
go
add_domain_values 'PricerMeasurePnlAllEOD','HISTO_FEES_UNSETTLED',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMULATIVE_CASH',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMULATIVE_CASH_FEES',''
go
add_domain_values 'measuresForAdjustment','HISTO_CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'measuresForAdjustment','HISTO_POSITION_CASH',''
go
add_domain_values 'measuresForAdjustment','HISTO_FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlPhysComEOD','HISTO_CUMULATIVE_CASH',''
go
add_domain_values 'PricerMeasurePnlPhysComEOD','HISTO_CUMULATIVE_CASH_INTEREST',''
go
add_domain_values 'PricerMeasurePnlPhysComEOD','HISTO_FEES_UNSETTLED',''
go
add_domain_values 'PricerMeasurePnlPhysComEOD','CA_PV',''
go
add_domain_values 'PricerMeasurePnlPhysComEOD','CA_COST',''
go
add_domain_values 'PNLWithDetails','Accretion_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Accretion_PnL',''
go
add_domain_values 'PNLWithDetails','Cost_Of_Funding_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Realized_Fees_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Realized_Fees_PnL',''
go
add_domain_values 'PNLWithDetails','Total_Fees_Full_PnL',''
go
add_domain_values 'PNLWithDetails','Total_Fees_PnL',''
go
add_domain_values 'function','AllowUpdateTagsWithManualSdi',''
go
add_domain_values 'pricingScriptReportVariables','ObservationDates.ReferenceDateArray',''
go
add_domain_values 'pricingScriptReportVariables','CouponPayment.AccrualPeriodArray',''
go
add_domain_values 'pricingScriptReportVariables','Coupon_NFixed',''
go
add_domain_values 'pricingScriptReportVariables','CouponRate_Above',''
go
add_domain_values 'pricingScriptReportVariables','CouponRate_Below',''
go
add_domain_values 'pricingScriptReportVariables','CouponStrikePct',''
go
add_domain_values 'pricingScriptReportVariables','IR_CouponPayment.AccrualPeriodArray',''
go
add_domain_values 'pricingScriptReportVariables','IR_curr',''
go
add_domain_values 'pricingScriptReportVariables','IR_FloatRateRef',''
go
add_domain_values 'pricingScriptReportVariables','IR_KO_RedemptionPct',''
go
add_domain_values 'pricingScriptReportVariables','IR_Notional',''
go
add_domain_values 'pricingScriptReportVariables','IR_RedemptionPct',''
go
add_domain_values 'pricingScriptReportVariables','IR_Spread_BPS',''
go
add_domain_values 'pricingScriptReportVariables','InitialFixing',''
go
add_domain_values 'pricingScriptReportVariables','isPut',''
go
add_domain_values 'pricingScriptReportVariables','LeveragePct',''
go
add_domain_values 'pricingScriptReportVariables','KI.ReferenceDateArray',''
go
add_domain_values 'pricingScriptReportVariables','KI_BarrierPct',''
go
add_domain_values 'pricingScriptReportVariables','KI_Override',''
go
add_domain_values 'pricingScriptReportVariables','KO.PaymentDateArray',''
go
add_domain_values 'pricingScriptReportVariables','KO_BarrierPct',''
go
add_domain_values 'pricingScriptReportVariables','KO_RedemptionCurr',''
go
add_domain_values 'pricingScriptReportVariables','KO_RedemptionFX',''
go
add_domain_values 'pricingScriptReportVariables','KO_RedemptionPct',''
go
add_domain_values 'pricingScriptReportVariables','KO_StepDownAmount',''
go
add_domain_values 'pricingScriptReportVariables','KO_StepDownPct',''
go
add_domain_values 'pricingScriptReportVariables','KO_StepDownUsePct',''
go
add_domain_values 'pricingScriptReportVariables','StrikePct',''
go
add_domain_values 'domainName','pricingScriptReportVariables.ReferenceDateArray',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','STARTDATE',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','ENDDATE',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','FREQUENCY',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','HOLIDAYS',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','DATEROLL',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','PERIODRULE',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','SPECIFYROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','ROLLDAY',''
go
add_domain_values 'pricingScriptReportVariables.ReferenceDateArray','INCLUDESTART',''
go
add_domain_values 'domainName','bookAttribute.PositionTransferPrice','Price type of position transfer' 
go
add_domain_values 'bookAttribute.PositionTransferPrice','Average','Use position average price' 
go
add_domain_values 'bookAttribute.PositionTransferPrice','Closing','Use closing price' 
go
add_domain_values 'domainName','keyword.PositionTransferPrice','Price type of position transfer' 
go
add_domain_values 'keyword.PositionTransferPrice','Average','Use position average price' 
go
add_domain_values 'keyword.PositionTransferPrice','Closing','Use closing price' 
go
add_domain_values 'function','PricingSheetSettingAccess','Give access to the Setting in Pricing Sheet' 
go
add_domain_values 'function','AddCustomEditorWorkflowRule','Access permission to add a new custom workflow rule' 
go
add_domain_values 'function','ModifyCustomEditorWorkflowRule','Access permission to modify an existing custom workflow rule' 
go
add_domain_values 'function','RemoveCustomEditorWorkflowRule','Access permission to remove an existing custom workflow rule'
go
add_domain_values 'domainName','PricingSheetMeasures.CrossAssetSummable','The Pricer Measures that support summing accross assets' 
go
add_domain_values 'PricingSheetMeasures.CrossAssetSummable','NPV',''
go
add_domain_values 'PricingSheetMeasures.CrossAssetSummable','PV' ,''
go
add_domain_values 'domainName','mktDataVisuType','Market Data format by MDI Type' 
go
add_domain_values 'mktDataVisuType','Quotes',''
go
add_domain_values 'domainName','mktDataVisuType.Quotes','' 
go
add_domain_values 'mktDataVisuType.Quotes','Quotes','' 
go
add_domain_values 'mktDataVisuType','CMD','' 
go
add_domain_values 'domainName','mktDataVisuType.CMD','' 
go
add_domain_values 'mktDataVisuType.CMD','CurveCommodity','' 
go
add_domain_values 'mktDataVisuType.CMD','CurveCommoditySpread','' 
go
add_domain_values 'mktDataVisuType.CMD','CurveZeroPreciousMetal','' 
go
add_domain_values 'mktDataVisuType.CMD','CurveConvenienceYield','' 
go
add_domain_values 'mktDataVisuType.CMD','CurveCommoditySeasonality','' 
go
add_domain_values 'mktDataVisuType','Correlation','' 
go
add_domain_values 'domainName','mktDataVisuType.Correlation','' 
go
add_domain_values 'mktDataVisuType.Correlation','CorrelationSurface','' 
go
add_domain_values 'mktDataVisuType.Correlation','CorrelationMatrix','' 
go
add_domain_values 'mktDataVisuType.Correlation','CorrelationFormula','' 
go
add_domain_values 'mktDataVisuType','Credit','' 
go
add_domain_values 'domainName','mktDataVisuType.Credit','' 
go
add_domain_values 'mktDataVisuType.Credit','CurveCDSBasisAdjustment','' 
go
add_domain_values 'mktDataVisuType.Credit','CurveProbability','' 
go
add_domain_values 'mktDataVisuType.Credit','CurveRisky','' 
go
add_domain_values 'mktDataVisuType.Credit','CurveRecovery','' 
go
add_domain_values 'mktDataVisuType','Equity','' 
go
add_domain_values 'domainName','mktDataVisuType.Equity','' 
go
add_domain_values 'mktDataVisuType.Equity','CurveDividend','' 
go
add_domain_values 'mktDataVisuType.Equity','CurveBorrow','' 
go
add_domain_values 'mktDataVisuType','FixedIncome','' 
go
add_domain_values 'domainName','mktDataVisuType.FixedIncome','' 
go
add_domain_values 'mktDataVisuType.FixedIncome','CurveYield','' 
go
add_domain_values 'mktDataVisuType.FixedIncome','CurveRepo','' 
go
add_domain_values 'mktDataVisuType','FX','' 
go
add_domain_values 'domainName','mktDataVisuType.FX','' 
go
add_domain_values 'mktDataVisuType.FX','CurveFX','' 
go
add_domain_values 'mktDataVisuType','Inflation','' 
go
add_domain_values 'domainName','mktDataVisuType.Inflation','' 
go
add_domain_values 'mktDataVisuType.Inflation','CurveInflation','' 
go
add_domain_values 'mktDataVisuType.Inflation','CurveSeasonality','' 
go
add_domain_values 'mktDataVisuType','IRD','' 
go
add_domain_values 'domainName','mktDataVisuType.IRD','' 
go
add_domain_values 'mktDataVisuType.IRD','CurveBasis',''
go
add_domain_values 'mktDataVisuType.IRD','CurveZero','' 
go
add_domain_values 'mktDataVisuType.IRD','CurveZeroFXDerived','' 
go
add_domain_values 'mktDataVisuType.IRD','USDCurveZero','' 
go
add_domain_values 'mktDataVisuType','Volatility','' 
go
add_domain_values 'domainName','mktDataVisuType.Volatility','' 
go
add_domain_values 'mktDataVisuType.Volatility','FXVolatilitySurface','' 
go
add_domain_values 'mktDataVisuType.Volatility','VolatilitySurface3D','' 
go
add_domain_values 'mktDataVisuType','ABS','' 
go
add_domain_values 'domainName','mktDataVisuType.ABS','' 
go
add_domain_values 'mktDataVisuType.ABS','CurveDefault','' 
go
add_domain_values 'mktDataVisuType.ABS','CurveDelinquency','' 
go
add_domain_values 'mktDataVisuType.ABS','CurvePrepay','' 
go
add_domain_values 'mktDataVisuType','Hypersurface','' 
go
add_domain_values 'domainName','mktDataVisuType.Hypersurface','' 
go
add_domain_values 'mktDataVisuType.Hypersurface','HyperSurfaceImpl','' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','NPV','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','PRICE','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','B/E_Rate','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','DURATION','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','CARRY','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','ACCRUAL','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','PV01','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwap.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','NPV','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','PRICE','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','B/E_Rate','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','DURATION','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','CARRY','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','ACCRUAL','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','PV01','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CreditDefaultSwapLoan.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','NPV','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','PRICE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','B/E_Rate','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','DURATION','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','CARRY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','ACCRUAL','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','PV01','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndex.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','NPV','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','PRICE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','B/E_Rate','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','DURATION','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','CARRY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','ACCRUAL','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','PV01','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','EFF_ATT','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','EFF_DET','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','AVG_SPREAD','Default Super User Pricer Measure' 
go
add_domain_values 'CDSIndexTranche.PricerMeasure','PV01_CORRELATION','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','NPV','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','PRICE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','B/E_Rate','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','DURATION','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','CARRY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','ACCRUAL','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','PV01','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthLoss.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthLoss.PricerMeasure','EFF_ATT','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','EFF_DET','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthLoss.PricerMeasure','AVG_SPREAD','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthLoss.PricerMeasure','PV01_CORRELATION','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthDefault.PricerMeasure','NPV','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','PRICE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','B/E_Rate','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','DURATION','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthDefault.PricerMeasure','CARRY','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthDefault.PricerMeasure','ACCRUAL','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthDefault.PricerMeasure','PV01','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','PV01_CREDIT','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthDefault.PricerMeasure','PV01_RECOVERY','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthDefault.PricerMeasure','DEFAULT_EXPOSURE','Default Super User Pricer Measure'
go
add_domain_values 'CDSNthDefault.PricerMeasure','AVG_EXPOSURE','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','IMPLIED_SPREAD','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','EFF_ATT','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','EFF_DET','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','AVG_SPREAD','Default Super User Pricer Measure' 
go
add_domain_values 'CDSNthDefault.PricerMeasure','PV01_CORRELATION','Default Super User Pricer Measure'
go
add_domain_values 'SecurityLending.autoMarkType','Internal','' 
go
add_domain_values 'SecurityLending.autoMarkType','Pirum','' 
go
add_domain_values 'function','ConfigureODAShortcuts','Allows the creation of Trade and Analysis shortcuts in ODA' 
go
add_domain_values 'function','ConfigureODAServers','Allows configuration of CS, PS, MDS and Dispatcher in ODA''s Analysis section' 
go
add_domain_values 'function','ODAAdhocTradeFilter','Allows direct specification of existing trade filter in ODA' 
go
add_domain_values 'function','ODAAdhocAnalysis','Allows the use of the Ad Hoc analysis in ODA' 
go
add_domain_values 'function','DistributeODAShortcuts','' 
go
add_domain_values 'function','DistributeODASpeedButtons','' 
go
add_domain_values 'function','DistributeCWSNodes','' 
go
add_domain_values 'function','DistributeCWSReportPlans',''
go
add_domain_values 'function','DistributeCWSDrillDowns',''
go
add_domain_values 'function','DistributeCWSSpeedButtons','' 
go
add_domain_values 'function','DistributeCWSWindowPlans','' 
go
add_domain_values 'function','DistributeCWSConfigWithGroup','function name for DistributeCWSConfigWithGroup restriction' 
go
add_domain_values 'restriction','DistributeCWSConfigWithGroup','Restrict distribution of accessible CWS items to current user''s groups only' 
go
add_domain_values 'domainName','creditStaticDataUsage','Supported usages' 
go
add_domain_values 'creditStaticDataUsage','MATRIX',''  
go
add_domain_values 'creditStaticDataUsage','RECOVERY',''  
go
add_domain_values 'domainName','creditStaticDataProductTypes','Supported products'  
go
add_domain_values 'creditStaticDataProductTypes','CreditDefaultSwap',''  
go
add_domain_values 'creditStaticDataProductTypes','CreditDefaultSwapLoan',''  
go
add_domain_values 'Access permisssion to create/modify XProd Configuration','CreateXProdConfig','function'  
go
add_domain_values 'Access permission to remove XProd Configuration','RemoveXProdConfig','function' 
go
add_domain_values 'Access permission to access XProd Configuration','XProdConfigAccess','function' 
go
add_domain_values 'Access permission to create/modify/delete XProd Configuration','ModifyXProdConfig','function' 
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('PRICE_FROM_UNDERLYING','java.lang.Boolean','true,false','Forecast Spread from Components',0,'true' )
go
begin
declare @n int
select @n= count(*) from pricing_param_name where param_name='ALLOW_EX_DIVIDEND'
if @n=0
begin
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('ALLOW_EX_DIVIDEND','java.lang.Boolean','true,false','For Bond, allows ex div trading',1,'true' )
end
end
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('FORECAST_USE_SPOT','java.lang.Boolean','true,false','Determine whether spot rate or FXReset rate should be used for forecasting of FX.',1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('FORECAST_INF_ACCRUAL','java.lang.Boolean','true,false','Forecast Inflation Accural',1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MIN_YIELD','java.lang.Double','','Designate minimum limit for yield.',0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MAX_IMPLIED_VOL','java.lang.Double','','Designate maximum limit for implied vol.',0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ('MIN_IMPLIED_VOL','java.lang.Double','','Designate minimum limit for implied vol.',0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_ADJUST_FOR_MIDFLOW_EXERCISE','java.lang.Boolean','true,false','Flag controls whether mid flow exercise should be adjusted.',0,'CALIBRATE_TO_OTM_OPTIONS','false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_CALIB_MIN_CALENDAR_DAYS','java.lang.Integer','','If >0, the lag between the value date and the next exercise date will be at least that number of days.',0,'CALIB_MIN_CALENDAR_DAYS','0' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_CALIBRATE_TO_STD_OPTIONS','java.lang.Boolean','true,false','if set to true, it calibrates to vanilla swaptions as specified by the point underlying swap on the volatility surface used. Note that Bermudan.',0,'CALIBRATE_TO_STD_OPTIONS','false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('LGMM_CALIBRATION_VOL_TYPE','java.lang.String','BLACK_VOL,BP_VOL','Controls how the model is parameterised and the scheme for calibration',0,'CALIBRATION_VOL_TYPE','BLACK_VOL' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('DATES_TO_TENOR_THRESHOLD','java.lang.Double','','The number of days within which a whole year is preserved.',1,'DATES_TO_TENOR_THRESHOLD','7.0' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('SWAP_REPLICATION_METHOD','java.lang.String','swap_rate_offset,overlap_negative_weights','SWAP_REPLICATION_METHOD methodology',1,'SWAP_REPLICATION_METHOD','swap_rate_offset' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('COLLATERALIZED_PRICING','java.lang.String','On,Off','On:Use collateral discounting for fully collatearlized trade. Off:Do not use collateral disc even if trade is fully collateralized.',1,'COLLATERALIZED_PRICING','Off' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('COLLATERAL_POLICY_OVERRIDE','java.lang.String','','Transient param overwriting collateral discount policy defined in CSA',1,'COLLATERAL_POLICY_OVERRIDE','' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('USE_REAL_YIELD','java.lang.Boolean','true,false','Model parameter to control inflation adjustments for price/yield calculations.','false',1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ('USE_NATIVE_CURRENCY','java.lang.Boolean','true,false','Controls whether the npv and accrual will be returned in the native currency or the settlement currency.',0,'USE_NATIVE_CURRENCY','false' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('USE_PROJ_FOR_HIST_CF','java.lang.Boolean','true,false','MBSFixedRate Parameter determines as the historical cashflows to be generated using projections','false',1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, default_value, is_global_b ) VALUES ('USE_ARM_COMPONENTS','java.lang.Boolean','true,false','MBSArm Parameter determines to include ARM Components in CashFlow Generation','false',1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ('HOMOGENEOUS_METHOD','java.lang.String','TRUE,FALSE,As_Assets','Recovery approximation method for small NTD baskets',0,'As_Assets' )
go
INSERT INTO sql_blacklist_properties ( name, value ) VALUES ('gui.exclude','com.calypso.apps.util.SimpleLogWindow' )
go
INSERT INTO plmethodology_info ( book_id, product_type, strategy, cash_type ) VALUES (0,'ANY',0,0 )
go
/* Domain Value Changes END*/
update user_viewer_prop set property_value='FXDetailed' where property_name like 'DealStationPersona_FX_%' and (property_value='FXSalesDetailed' or property_value='FXTraderDetailed')
go

/* all sqls should go between these comments */
delete from pricing_param_name where param_name = 'LGMM_CALIB_MIN_CALENDAR_DAYS'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_MIN_CALENDAR_DAYS','java.lang.Integer','','If >0, the lag between the value date and the next exercise date will be at least that number of days.',0,'CALIB_MIN_CALENDAR_DAYS','0' )
go
delete from pricing_param_name where param_name = 'LGMM_CALIBRATE_TO_STD_OPTIONS'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATE_TO_STD_OPTIONS','java.lang.Boolean','true,false','if set to true, it calibrates to vanilla swaptions as specified by the point underlying swap on the volatility surface used. Note that Bermudan.',0,'CALIBRATE_TO_STD_OPTIONS','false' )
go
delete from pricing_param_name where param_name = 'LGMM_CALIBRATION_VOL_TYPE'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATION_VOL_TYPE','java.lang.String','BLACK_VOL,BP_VOL','Controls how the model is parameterised and the scheme for calibration',0,'CALIBRATION_VOL_TYPE','BLACK_VOL' )
go
delete from pricing_param_name where param_name = 'DATES_TO_TENOR_THRESHOLD'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('DATES_TO_TENOR_THRESHOLD','java.lang.Double','','The number of days within which a whole year is preserved.',1,'DATES_TO_TENOR_THRESHOLD','7.0' )

go
delete from pricing_param_name where param_name = 'SWAP_REPLICATION_METHOD'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('SWAP_REPLICATION_METHOD','java.lang.String','swap_rate_offset,overlap_negative_weights','SWAP_REPLICATION_METHOD methodology',1,'SWAP_REPLICATION_METHOD','swap_rate_offset' )
go

delete from pricing_param_name where param_name = 'MAX_DAY_SPACING'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('MAX_DAY_SPACING','java.lang.Integer','','Maximum number of days between time splices in the lattice',0,'MAX_DAY_SPACING','30' )
go

delete from pricing_param_name where param_name = 'LGMM_CALIB_SWAPTION'
go

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SWAPTION','java.lang.String','','Swaption template used to define calibration instruments',0,'CALIB_SWAPTION','' )
go

delete from pricing_param_name where param_name = 'LGMM_CALIB_SPACING'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SPACING','java.lang.Integer','','Minimum spacing between calibration instruments',0,'CALIB_SPACING','30' )
go

add_domain_values 'CapFloor.Pricer','PricerCapFloorInflationBlack','Pricer Cap Floor Inflation Black' 
go
add_domain_values 'Swap.Pricer','PricerSwapLGMM1F','Cancellable swap pricer using sali tree to price the option and LGMM to calibrate' 
go
add_domain_values 'Swaption.Pricer','PricerSwaptionLGMM1F','LGMM1F pricer' 
go
add_domain_values 'Bond.Pricer','PricerLGMM1FSaliTree','LGMM1F Sali Tree Pricer' 
go

delete from domain_values where value = 'Accretion_PnL_Base'
go
delete from domain_values where value = 'Accrual_PnL_Base'
go
DELETE FROM domain_values where value = 'Accrued_PnL_Base'
go
DELETE FROM domain_values where value = 'Cash_PnL_Base'
go
DELETE FROM domain_values where value = 'Cost_Of_Carry_Base_PnL'
go
DELETE FROM domain_values where value = 'Paydown_PnL_Base'
go
DELETE FROM domain_values where value = 'Realized_Interests_PnL_Base'
go
DELETE FROM domain_values where value = 'Realized_PnL_Base'
go
DELETE FROM domain_values where value = 'Sale_Realized_PnL_Base'
go
DELETE FROM domain_values where value = 'Settlement_Date_PnL_Base'
go
DELETE FROM domain_values where value = 'Total_Accrual_PnL_Base'
go
DELETE FROM domain_values where value = 'Unrealized_Cash_PnL_Base'
go
DELETE FROM domain_values where value = 'Unrealized_Fees_PnL_Base'
go
DELETE FROM domain_values where value = 'Unrealized_Interests_Base'
go
DELETE FROM domain_values where value = 'Unrealized_Net_PnL_Base'
go
DELETE FROM domain_values where value = 'Unrealized_PnL_Base'
go

/* CAL-146327 */
update 	cf_sch_gen_params
set		start_date = leg.start_date,
		end_date = leg.end_date 
from	commodity_leg2 leg,
		cf_sch_gen_params params
where	params.start_date is null
and		params.end_date is null
and 	params.param_type = 'COMMODITY'
and		params.leg_id = leg.leg_id
go
 
update  cf_sch_gen_params 
set     start_date = cash_params.start_date,
        end_date = cash_params.end_date 
from    cf_sch_gen_params       sec_params,
        cf_sch_gen_params       cash_params,
        prod_comm_fwd           fwd,
        commodity_leg2          leg
where   fwd.product_id = sec_params.product_id
and     fwd.comm_leg_id = sec_params.leg_id 
and     sec_params.param_type = 'SECURITY'
and     sec_params.start_date is null
and     sec_params.end_date is null
and     sec_params.leg_id = leg.leg_id
and     leg.leg_type not in (1, 3)
and     sec_params.product_id = cash_params.product_id
and     sec_params.leg_id = cash_params.leg_id
and     cash_params.param_type = 'COMMODITY'
and     cash_params.start_date is not null
and     cash_params.end_date is not null
go

delete from pc_param where pricer_name = 'PricerBondTarnLGMM'
go

if not exists (select 1 from syscolumns c , sysobjects o where c.id=o.id and c.name='leverage_factor' and o.name='product_cap_floor')
begin
exec ('alter table product_cap_floor add leverage_factor float default 1.0 null')
exec ('update product_cap_floor set leverage_factor=1.0 where leverage_factor=null')
end
go
if not exists (select 1 from syscolumns c , sysobjects o where c.id=o.id and c.name='leverage_factor' and o.name='cash_flow_option')
begin
exec ('alter table cash_flow_option add leverage_factor float default 1.0 null')
exec ('update cash_flow_option set leverage_factor=1.0 where leverage_factor=null')
end
go
if not exists (select 1 from syscolumns c , sysobjects o where c.id=o.id and c.name='leverage_factor' and o.name='c_flw_option_hist')
begin
exec ('alter table c_flw_option_hist add leverage_factor float default 1.0 null')
exec ('update c_flw_option_hist set leverage_factor=1.0 where leverage_factor=null')
end
go

/* CAL-190826 */

UPDATE curve SET data_blob = null where curve_id in 
(select distinct curve_id from curve_member where cu_id in (select cu_id from cu_fra))
go

UPDATE curve_def_data set curve_def_blob = null where curve_id in 
(select distinct curve_id from curve_member where cu_id in (select cu_id from cu_fra))
go

if exists (select 1 from sysobjects where name ='unlocalize' and type='P')
begin
exec ('drop procedure unlocalize')
end
go

create procedure unlocalize 
@str varchar(64), @res varchar(64) output
as
begin declare @last_sep_char_pos integer, @i integer, @sep_char char(1)
select @i=0, @last_sep_char_pos = 0
while @i<len(@str)
begin
   select @i = @i+1
   if (substring(@str, @i, 1) = '.') or (substring(@str, @i, 1) = ',')  
       select @last_sep_char_pos = @i
end
if @last_sep_char_pos = 0 
  begin
  select @res = @str
  return
  end

select @sep_char = substring(@str, @last_sep_char_pos, 1)

if (@sep_char = '.') 
  select @res = str_replace(substring(@str, 1, @last_sep_char_pos-1), ',', null) + '.' + substring(@str,@last_sep_char_pos+1, len(@str)-@last_sep_char_pos)
else 
  select @res = str_replace(substring(@str, 1, @last_sep_char_pos-1), '.', null) + '.' + substring(@str,@last_sep_char_pos+1, len(@str)-@last_sep_char_pos)
end
go

exec sp_procxmode 'unlocalize', 'anymode'
go

if exists (select 1 from sysobjects where name ='string_to_spread' and type='P')
begin
exec ('drop procedure string_to_spread')
end
go

create procedure string_to_spread @str VARCHAR(255), @result float output as
BEGIN
  declare @str2 varchar(255)
  exec unlocalize @str, @str2 output
  select @result = convert(float, @str2) / 10000.0
END 
go

exec sp_procxmode 'string_to_spread', 'anymode'
go

add_column_if_not_exists 'product_simple_mm', 'sales_margin', 'float default 0 not null' 
go
add_column_if_not_exists 'product_cash','sales_margin', 'float default 0 not null' 
go
add_column_if_not_exists 'product_call_not','sales_margin',  'float default 0 not null '
go
add_column_if_not_exists 'prd_smp_mm_hist ',' sales_margin','  float default 0 not null' 
go
add_column_if_not_exists 'product_cash_hist ',' sales_margin  ','float default 0 not null' 
go
add_column_if_not_exists 'product_call_not_hist ',' sales_margin ',' float default 0 not null'
go


if exists (select 1 from sysobjects where name ='migrate_simplemm_sales_margin' and type='P')
begin
exec ('drop procedure migrate_simplemm_sales_margin')
end
go

create PROCEDURE migrate_simplemm_sales_margin AS
BEGIN
  DECLARE c1 cursor for  
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_simple_mm, trade , trade_keyword
      WHERE trade.product_id = product_simple_mm.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c2 cursor for  
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_cash, trade , trade_keyword
      WHERE trade.product_id = product_cash.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c3 cursor for  
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_call_not, trade , trade_keyword
      WHERE trade.product_id = product_call_not.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin'
      
      
  DECLARE c1h cursor for  
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM prd_smp_mm_hist, trade_hist, trade_keyword_hist
      WHERE trade_hist.product_id = prd_smp_mm_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c2h cursor for  
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM product_cash_hist, trade_hist , trade_keyword_hist
      WHERE trade_hist.product_id = product_cash_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin'
      
  DECLARE c3h cursor for  
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM product_call_not_hist, trade_hist , trade_keyword_hist
      WHERE trade_hist.product_id = product_call_not_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin'

  declare     @nonlocalized_sales_margin varchar(255)
  declare     @margin float
  declare @product_id int, @trade_id int, @keyword_value varchar(255)
  BEGIN
     /* live tables: move current keyword value into product field */
    open c1
    fetch c1 into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_simple_mm set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c1 into @product_id, @trade_id, @keyword_value
    end
    close c1
    deallocate cursor c1
    
    
    open c2
    fetch c2 into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_cash set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c2 into @product_id, @trade_id, @keyword_value
    end
    close c2
    deallocate cursor c2
    
    
    open c3
    fetch c3 into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_call_not set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c3 into @product_id, @trade_id, @keyword_value
    end
    close c3
    deallocate cursor c3

    /* fix audit entries */


    declare @entity_id int, @version_num int
    declare @entity_class_name varchar(255), @entity_field_name varchar(255)
    declare @modif_date datetime
    declare c1a cursor for
      select  old_value, new_value,
              entity_id, 
              entity_class_name, entity_field_name,
              modif_date, version_num
      from bo_audit 
      where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade t, product_desc pd 
          where t.trade_id = bo_audit.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )

    declare @old varchar(255), @new varchar(255), @entity_field_nam varchar(255)
    declare @tmp_o float, @tmp_n float
    open c1a
    fetch c1a into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    while   (@@sqlstatus=0)
    begin
      exec string_to_spread @old, @tmp_o output
      exec string_to_spread @new, @tmp_n output
      update bo_audit
        /* can't update the entity_field_name here since it would close the cursor... */
        set 
        field_type = 'double',
        old_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_o, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end,
        new_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_n, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end
        where entity_id = @entity_id 
          and entity_class_name = @entity_class_name
          and entity_field_name = @entity_field_name
          and modif_date = @modif_date
          and version_num = @version_num

      fetch c1a into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    end
    close c1a
    deallocate c1a

   /* now update the entity_field_name */
    update bo_audit 
      set  entity_field_name = 'Product._salesMargin'
    where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade t, product_desc pd 
          where t.trade_id = bo_audit.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )
  end
  
  /* and now the same for the history tables */
  
  
    open c1h
    fetch c1h into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update prd_smp_mm_hist set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword_hist where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c1h into @product_id, @trade_id, @keyword_value
    end
    close c1h
    deallocate cursor c1h
    
    
    open c2h
    fetch c2h into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_cash_hist set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword_hist where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c2h into @product_id, @trade_id, @keyword_value
    end
    close c2h
    deallocate cursor c2h
    
    
    open c3h
    fetch c3h into @product_id, @trade_id, @keyword_value
    WHILE  (@@sqlstatus=0)
    begin
         exec string_to_spread @keyword_value, @margin output
         update product_call_not_hist set sales_margin = @margin where product_id = @product_id
         delete from trade_keyword_hist where trade_id = @trade_id and keyword_name = 'SalesMargin'
         fetch c3h into @product_id, @trade_id, @keyword_value
    end
    close c3h
    deallocate cursor c3h

    /* fix audit entries */


    declare c1ah cursor for
      select  old_value, new_value,
              entity_id, 
              entity_class_name, entity_field_name,
              modif_date, version_num
      from bo_audit_hist 
      where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade_hist t, product_desc_hist pd 
          where t.trade_id = bo_audit_hist.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )

    open c1ah
    fetch c1ah into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    while   (@@sqlstatus=0)
    begin
      exec string_to_spread @old, @tmp_o output
      exec string_to_spread @new, @tmp_n output
      update bo_audit_hist
        /* can't update the entity_field_name here since it would close the cursor... */
        set 
        field_type = 'double',
        old_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_o, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end,
        new_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then ltrim(str(@tmp_n, 30, 15))
                         when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                    end
        where entity_id = @entity_id 
          and entity_class_name = @entity_class_name
          and entity_field_name = @entity_field_name
          and modif_date = @modif_date
          and version_num = @version_num

      fetch c1ah into @old, @new, @entity_id, @entity_class_name, @entity_field_name, @modif_date, @version_num 
    end
    close c1ah
    deallocate c1ah

   /* now update the entity_field_name */
    update bo_audit_hist
      set  entity_field_name = 'Product._salesMargin'
    where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade_hist t, product_desc_hist pd 
          where t.trade_id = bo_audit_hist.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      )
  
end
go

exec sp_procxmode 'migrate_simplemm_sales_margin', 'anymode'
go


if not exists (select 1 from sysobjects where name = 'trade_keyword_bak_bz56618' and type='U')
begin
    exec ('select * into trade_keyword_bak_bz56618 from trade_keyword where keyword_name = ''SalesMargin''')
end
go

if not exists (select 1 from sysobjects where name = 'trade_keyword_hist_bak_bz56618' and type='U')
begin
    exec ('select * into trade_keyword_hist_bak_bz56618 from trade_keyword_hist where keyword_name = ''SalesMargin''')
end
go

if not exists (select 1 from sysobjects where name = 'bo_audit_bak_bz56618' and type='U')
begin
    exec ('select * into bo_audit_bak_bz56618 from bo_audit where entity_class_name =''Trade'' and entity_field_name in (''ADDKEY#SalesMargin'', ''DELKEY#SalesMargin'', ''MODKEY#SalesMargin'')')
end
go

if not exists (select 1 from sysobjects where name = 'bo_audit_hist_bak_bz56618' and type='U')
begin
    exec ('select * into bo_audit_hist_bak_bz56618 from bo_audit_hist where entity_class_name =''Trade'' and entity_field_name in (''ADDKEY#SalesMargin'', ''DELKEY#SalesMargin'', ''MODKEY#SalesMargin'')')
end
go


exec migrate_simplemm_sales_margin
go
/*  Update Version */
UPDATE calypso_info
    SET major_version=13,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date='20110428'
go
