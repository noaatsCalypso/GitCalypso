 

alter table bo_audit modify new_value varchar(512)
go
alter table bo_audit modify old_value varchar(512)
go

alter table bo_audit_hist modify new_value varchar(512)
go
alter table bo_audit_hist modify old_value varchar(512)
go

add_column_if_not_exists 'swap_leg','act_initial_exch_b', 'int default 1 null'
go
add_column_if_not_exists 'swap_leg','act_final_exch_b' ,'int default 1 null'
go
add_column_if_not_exists 'swap_leg','act_amort_exch_b' ,'int  default 1 null'
go

UPDATE swap_leg
SET act_initial_exch_b = principal_actual_b,
act_final_exch_b = principal_actual_b,
act_amort_exch_b = principal_actual_b
go

UPDATE swap_leg
SET act_initial_exch_b = 
	CASE
		WHEN legs.principal_actual_b = 1 THEN xccys.act_init_exch_b
		ELSE 0
	END,
act_final_exch_b = 
	CASE
		WHEN legs.principal_actual_b = 1 THEN xccys.act_final_exch_b
		ELSE 0
	END,
act_amort_exch_b = 
	CASE
		WHEN legs.principal_actual_b = 1 THEN xccys.act_amort_exch_b
		ELSE 0
	END
FROM xccy_swap_ext_info xccys, swap_leg legs
WHERE xccys.product_id = legs.product_id
go

UPDATE swap_leg SET act_initial_exch_b = 1 WHERE act_initial_exch_b is null
go
UPDATE swap_leg SET act_final_exch_b = 1 WHERE act_final_exch_b is null
go
UPDATE swap_leg SET act_amort_exch_b = 1 WHERE act_amort_exch_b is null
go

ALTER table swap_leg modify act_initial_exch_b not null
go
ALTER table swap_leg modify act_final_exch_b not null
go
ALTER table swap_leg modify act_amort_exch_b not null
go

add_column_if_not_exists 'swap_leg', 'reset_dateroll', 'VARCHAR(16) null'
go

UPDATE swap_leg set reset_dateroll = 'PRECEDING'
go

add_column_if_not_exists 'product_fra','pmt_begin_date_roll', 'varchar(16) null'
go
add_column_if_not_exists 'product_fra','pmt_begin_holidays', 'varchar(128) null'
go
add_column_if_not_exists 'product_fra','pmt_end_date_roll', 'varchar(16) null'
go
add_column_if_not_exists 'product_fra','pmt_end_holidays', 'varchar(128) null'
go

UPDATE product_fra
  SET pmt_begin_date_roll = 'NO_CHANGE',
      pmt_end_date_roll = 'NO_CHANGE',
      pmt_begin_holidays = holidays,
      pmt_end_holidays = holidays
go

add_column_if_not_exists 'eq_link_leg_hist','div_pay_ccy', 'varchar(3) null'
go

add_column_if_not_exists 'eq_linked_leg', 'div_pay_ccy', 'varchar(3) null'
go


UPDATE eq_linked_leg SET div_pay_ccy = performance_leg.currency
FROM eq_linked_leg,performance_leg 
WHERE eq_linked_leg.product_id = performance_leg.product_id
AND (div_pay_ccy IS NULL OR div_pay_ccy = '')
go

add_domain_values 'classAuthMode','SystemSettings',''
go

add_domain_values 'function','AuthorizeSystemSettings',''
go

delete from calypso_cache where limit=1 and app_name='DefaultServer' and limit_name='SystemSettings'
go
INSERT INTO calypso_cache (limit,app_name,limit_name,expiration,implementation,eviction) VALUES(1,'DefaultServer','SystemSettings',          0,'Calypso','LRU')
go

if not exists  (select 1  from sysobjects 
        where name='system_settings')
begin

exec ('CREATE TABLE system_settings (
        name                VARCHAR(32) NOT NULL,
	value               VARCHAR(32) NOT NULL,
        CONSTRAINT ct_primarykey PRIMARY KEY (name))')
end
go


INSERT INTO group_access  
SELECT a.group_name,1,'AuthorizeSystemSettings',0  
FROM user_group_name a  
WHERE  NOT EXISTS(  
SELECT 1 from group_access ga  
WHERE a.group_name=ga.group_name and  
ga.access_id=1 and  
(ga.access_value='AuthorizeSystemSettings'  
or  
ga.access_value='__ALL__')  
)  
and is_admin_b=1  
go  
    
    
INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('AUTHORIZATION_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='AUTHORIZATION_FLAG' )  
go  
INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('ACCESS_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='ACCESS_FLAG' )  
go  
INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('WORKFLOW_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='WORKFLOW_FLAG' )  
go  
INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('AUDIT_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='AUDIT_FLAG' )  
go  


INSERT INTO quote_name (quote_name, quote_type, decimals)
SELECT domain_values.value , 'NONE' , -1
FROM domain_values
WHERE domain_values.name = 'quoteName'
AND domain_values.value NOT IN (SELECT quote_name FROM quote_name)
and domain_values.value LIKE '%.WAL'
go

INSERT INTO quote_name (quote_name, quote_type, decimals)
SELECT domain_values.value , 'Price' , -1
FROM domain_values
WHERE domain_values.name = 'quoteName'
AND domain_values.value NOT IN (SELECT quote_name FROM quote_name)
and domain_values.value LIKE '%.IndexFactor'
go

INSERT INTO quote_name (quote_name, quote_type, decimals)
SELECT domain_values.value , 'CleanPrice' , -1
FROM domain_values WHERE domain_values.name = 'quoteName'
AND domain_values.value NOT IN (SELECT quote_name FROM quote_name)
and domain_values.value NOT LIKE '%.WAL' and domain_values.value NOT LIKE '%.IndexFactor'
go

delete from domain_values where name like 'quoteName' and value in (select quote_name from quote_name)
go
delete from domain_values where name like 'domainName' and value like 'quoteName'
go

add_domain_values 'function','ModifyMarketConformityDetail','Access permission to modify Market Conformity details'
go

add_domain_values 'function','ViewMarketConformity','Access permission to view the Market Conformity window' 
go

add_domain_values 'function','ViewMarketConformityDetail','Access permission to view Market Conformity details in the Market Conformity window'
go


INSERT INTO entity_attributes
(entity_id, entity_type, attr_name, attr_type, attr_value)
(SELECT attr1.entity_id,
        'ReportTemplate',
        'LERoleOnly',
        'String',
        attr1.attr_value
 FROM  entity_attributes attr1
 WHERE attr1.entity_type = 'ReportTemplate'
 AND   attr1.attr_name   = 'LERole'
 AND NOT EXISTS  (SELECT *
                  FROM  entity_attributes attr2
                  WHERE attr2.entity_type = 'ReportTemplate'
                  AND   attr2.attr_name   = 'CptyName'
                  AND   attr2.entity_id  = attr1.entity_id
                 )
)
go 

DELETE FROM entity_attributes
WHERE entity_type = 'ReportTemplate'
AND   attr_name   = 'LERole'
AND NOT EXISTS  (SELECT *
                 FROM   entity_attributes attr2
                 WHERE  attr2.entity_type = 'ReportTemplate'
                 AND    attr2.attr_name   = 'CptyName'
                 AND    attr2.entity_id   = entity_attributes.entity_id
                )
AND EXISTS      (SELECT *
                 FROM entity_attributes attr3
                 WHERE  attr3.entity_type = 'ReportTemplate'
                 AND    attr3.attr_name   = 'LERoleOnly'
                 AND    attr3.entity_id   = entity_attributes.entity_id
                )
go

UPDATE curve SET curve_generator = 'InflationDefault' where curve_generator = 'Inflation'
go

add_domain_values 'CurveInflation.gensimple','InflationBasis',''
go

add_column_if_not_exists 'cu_future','serial_b', 'int default -1'
go

create procedure cu_future_tmp as

DECLARE c1 CURSOR FOR select distinct cu.contract_id, contract_rank, cunder.cu_currency, cunder.quote_name, cunder.user_name
from future_contract fu, cu_future cu, curve_underlying cunder
where cu.contract_id = fu.contract_id
and charindex(ltrim(str(cu.contract_rank-1, 5,0)), fu.relative_months) > 0
and cunder.cu_id = cu.cu_id

declare @trade_seed_id int
declare @contract_id        int
declare @contract_rank       int
declare @isserialB int
declare @curreny varchar(3)
declare @quote_name varchar(255)
declare @user_name varchar(32)

select @trade_seed_id = 0  
select @contract_id = 0  
select @contract_rank = 0
select @trade_seed_id = last_id from calypso_seed where seed_name = 'refdata' 
select @isserialB = count(*) from cu_future where serial_b=-1

IF @isserialB > 0
BEGIN
UPDATE cu_future SET serial_b = 0
commit
UPDATE cu_future SET serial_b = 1 where exists(select distinct cu_future.cu_id from future_contract fu where cu_future.contract_id = fu.contract_id and charindex(ltrim(str(cu_future.contract_rank-1, 5,0)), fu.relative_months) > 0)
commit
OPEN c1
fetch c1 into @contract_id, @contract_rank, @curreny, @quote_name, @user_name
  while (@@sqlstatus = 0)
    begin
     select @trade_seed_id = @trade_seed_id + 1
     insert into cu_future (cu_id, contract_id, contract_rank, serial_b)
     values(@trade_seed_id,@contract_id,@contract_rank,0)
     insert into curve_underlying (cu_id, cu_type, cu_currency, quote_name, user_name, version_num)
     values(@trade_seed_id,'CurveUnderlyingFuture', @curreny, @quote_name, @user_name, 0)
     fetch c1 into @contract_id, @contract_rank, @curreny, @quote_name, @user_name
    end
    select @trade_seed_id = @trade_seed_id + 1
    update calypso_seed set last_id = @trade_seed_id where seed_name = 'refdata'
    commit
CLOSE c1
DEALLOCATE  cursor c1
END
go

exec sp_procxmode 'cu_future_tmp', 'anymode'  
go 

exec cu_future_tmp  
go

drop procedure cu_future_tmp
go 


create table fopos_tmp (prefix_code varchar(32))
go

select * into main_entry_prop_bak from main_entry_prop
go

create  procedure fo as 
begin
declare
  c1 cursor for select property_name,
                      substring(property_name,1,charindex('Action',property_name)-1),
                      property_value 
                      from main_entry_prop
                      where property_value = 'reporting.FOPositionWindow'
                      for update of property_value

declare c2 cursor for select prefix_code from fopos_tmp for read only

OPEN c1

declare   @_prefix_code varchar(16)
declare   @_sql varchar(512)
declare   @_prop_value varchar(256)
declare   @_x varchar(256)
declare   @_str1 varchar(256)
declare   @_str2 varchar(256)
declare   @_str3 varchar(256)
declare   @_start_pos int
declare   @_n int
declare   @_user_name varchar(255)
declare   @_property_name varchar(255)

fetch c1 into @_property_name, @_prefix_code, @_prop_value

WHILE (@@sqlstatus = 0)

begin

    select @_prefix_code = substring(@_property_name,1,charindex('Action',@_property_name)-1) 

    insert into fopos_tmp values (@_prefix_code) 
   
    delete from main_entry_prop where property_name IN (   
	@_prefix_code+'Action', 
	@_prefix_code+'Image',   
	@_prefix_code+'Label',    
	@_prefix_code+'Accelerator',   
	@_prefix_code+'Mnemonic',   
	@_prefix_code+'Tooltip') and user_name =@_user_name  

fetch c1 into @_property_name, @_prefix_code, @_prop_value

end

commit
      
CLOSE c1
DEALLOCATE  cursor c1


open c2 

  fetch c2 into @_prefix_code
     WHILE (@@sqlstatus = 0) 
begin 

declare c3 cursor for select user_name, property_name, property_value 
           from main_entry_prop for update of property_value

        open c3   
           fetch c3 into @_user_name, @_property_name, @_prop_value  
               begin
		
        select @_x = '%'+@_prefix_code+'%'  

               WHILE (@@sqlstatus = 0)  
               begin   
               
		
		if @_prop_value like @_x
                 begin
                 
                 select @_str1 = substring(@_prop_value,1,charindex(@_prefix_code,@_prop_value)-1) 
              
                  declare @_a int                 
                  declare @_b int                  
                  declare @_c int               
                  declare @_d int
                  declare @_e int

                 select @_a = char_length(@_prop_value)     /* length of property_value  */
                 select @_b = charindex(@_prefix_code,@_prop_value)-1  /* start position of the prefix code in the property_value  */
                 select @_c = char_length(@_prefix_code)      /* length of the prefix_code  */             
                 select @_d = @_b + @_c       /* the end position of prefix_value  */
                 select @_e = @_a - @_d    /* the remaining length of property_value after the prefix_code  */

                 declare @_aa  varchar(32)
                 select  @_aa = convert(varchar,@_a)
                 print 'value of @_aa (total length of property_value) is : '
                 print @_aa

                 declare @_bb  varchar(32)
                 select  @_bb = convert(varchar,@_b)
                 print 'value of @_bb (start position of the prefix_code) is : '
                 print @_bb

                 declare @_cc  varchar(32)
                 select  @_cc = convert(varchar,@_c)
                 print 'value of @_cc (length of the prefix_code) is : '
                 print @_cc

                 declare @_dd  varchar(32)
                 select  @_dd = convert(varchar,@_d)
                 print 'value of @_dd (the end position of the prefix_value) is : '
                 print @_dd


                 declare @_ee  varchar(32)
                 select  @_ee = convert(varchar,@_e)
                 print 'value of @_ee (remaining length of property_value after the prefix_code) is : '
                 print @_ee

                 declare @_temp_prop_value varchar(64)
                
                 select @_temp_prop_value = substring(@_prop_value,2,char_length(@_prop_value)) 

		 select @_str1 = substring(@_str1,1,char_length(@_str1)-1)

                  select @_str2 = substring(@_prop_value,@_d+1,@_e) 
                  print '@_str2 is : '
                  print @_str2

		   select @_str3 = @_str1 + @_str2
                   print '@_str3 is : '
                  print @_str3


        update main_entry_prop set property_value = @_str3 where  
                     user_name = @_user_name and            
              property_name = @_property_name and      
              property_value = @_prop_value         


                 /*  print @_prop_value   */
                 /*  print '%1!',@_prefix_code  */
               
                 end 
		fetch c3 into @_user_name, @_property_name, @_prop_value  
                end  
              end
          CLOSE c3  
          DEALLOCATE  cursor c3  


     fetch c2 into @_prefix_code 

end  

CLOSE c2
DEALLOCATE  cursor c2


end
go


exec sp_procxmode 'fo', 'anymode'
go

exec fo
go

drop table fopos_tmp
go 

drop procedure fo
go
delete from book_attribute where attribute_name='AccReversalRule' and comments='For Supporting Accounting Set Up'
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'AccReversalRule', 'For Supporting Accounting Set Up' )
go
delete from book_attribute where attribute_name='AccDateRule' and comments='For Supporting Accounting Set Up'
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'AccDateRule', 'For Supporting Accounting Set Up' )
go
delete from book_attribute where attribute_name='AccAdjustmentDays' and comments='For Supporting Accounting Set Up'
go
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'AccAdjustmentDays', 'For Supporting Accounting Set Up' )
go
delete from country where country_id=241 and name='EURO'
go
INSERT INTO country ( country_id, iso_code, name, active_from, active_to, default_holidays, time_zone, enabled_b ) VALUES
  ( 241, 'EU', 'EURO', '19700101','21000101', 'EUR', 'Europe/Berlin', 1 )
go
add_domain_values 'eco_pl_column', 'DIVIDEND_EFFECT', 'Column implemented by PLCalculator' 
go
add_domain_values 'eco_pl_column', 'BORROW_EFFECT', 'Column implemented by PLCalculator'  
go
add_domain_values 'function', 'TS_CHANGE_DATE_TYPE', 'Allow User to Change the Date Type in TaskStation'  
go
add_domain_values 'function', 'TS_INCREASE_DATE_RANGE', 'Allow User to Change the Date Range in TaskStation'  
go
add_domain_values 'function', 'ModifyTargetDirectory', 'Allow User to Change Entry in Target Directory'  
go
add_domain_values  'VolSurface.gensimple', 'GBM2FSpreadCorrelation',
    'Generator adds an additional point adjustment surface to store a matrix of (skew)spread correlations for the GBM2F model' 
go
add_domain_values 'engineParam', 'VERSION_CHECK', 'do not handle obviously out-of-date events'  
go
add_domain_values  'SingleSwapLeg.Pricer', 'PricerSingleSwapLegExotic', 'Pricer for Single Swap Leg for a class of exsp based legs' 
go
add_domain_values 'domainName', 'DividendType', ''  
go
add_domain_values 'DividendType', 'Regular', ''  
go
add_domain_values 'DividendType', 'Special', '' 
go
add_domain_values 'DividendType', 'Final', ''  
go
add_domain_values 'DividendType', 'Interim', '' 
go
add_domain_values 'volatilityType', 'MMFUTURE', ''  
go
add_domain_values 'domainName', 'calendarIsoCodes'  
go
add_domain_values 'settlementMethod', 'TARGET2', 'TARGET2' 
go
add_domain_values 'exceptionType', 'TARGET2', ''  
go
add_domain_values 'role', 'Addressee', 'Addressee Role' 
go
add_domain_values 'scheduledTask', 'ROLL_ACCENGINEDAY', 'Roll the Accounting Engine Business Date'  
go
add_domain_values  'scheduledTask', 'LOAD_TARGET2_DIRECTORY', 'Load Target2 Directory'  
go
add_domain_values  'riskPresenter', 'Pricing', ''  
go
delete from eco_pl_col_name where col_name='DIVIDEND_EFFECT' and col_id=63 and measure='NPV'
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'DIVIDEND_EFFECT', 'Dividend Effect', 63, 'NPV', 0 )
go
delete from eco_pl_col_name where col_name='BORROW_EFFECT' and col_id=64 and measure='NPV'
go
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'BORROW_EFFECT', 'Borrow Effect', 64, 'NPV', 0 )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSingleSwapLegExotic', 'RISK_OPTIMISE', 'true' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES
  ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'STRIKE_SPREAD_EPSILON', '10.0' )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES
  ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'DIGITAL_VALUATION_METHOD', 'CENTRAL_REPLICATE' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES
  ( 'COUPON_PAYOFFS', 'tk.core.PricerMeasure', 242, 'records the coupon payoff graph in the client data' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DETAILED_DATA', 'tk.core.TabularPricerMeasure', 250 )
go
delete from pricing_param_name where param_name='BORROW_SPREAD' and param_type='com.calypso.tk.core.Spread'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES
  ( 'BORROW_SPREAD', 'com.calypso.tk.core.Spread', '', 'Borrow spread for option pricing', 0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES
  ( 'DIGITAL_VALUATION_METHOD', 'java.lang.String', 'THEORETICAL,CENTRAL_REPLICATE,SUB_REPLICATE,SUPER_REPLICATE', '', 1,
    'DIGITAL_VALUATION_METHOD', 'CENTRAL_REPLICATE' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES
  ( 'RISK_OPTIMISE', 'java.lang.Boolean', 'true,false',
    'Flag controls whether or not the pricer makes any attempt to optimise in the getRiskExposure method', 1, 'RISK_OPTIMISE', 'true' )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 122, 'RiskAggregation', 1, 0, 1 )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 123, 'CompositeAnalysis', 1, 0, 1 )
go

if not exists (select 1 from syscolumns,sysobjects where convert(bit, (status &8))=1 and sysobjects.name='recon_inven_run' 
               and sysobjects.id=syscolumns.id and syscolumns.name='base_class')
begin
exec('ALTER TABLE recon_inven_run MODIFY base_class varchar (32) NULL')
end
go
if not exists (select 1 from syscolumns,sysobjects where convert(bit, (status &8))=1 and sysobjects.name='le_attribute' 
               and sysobjects.id=syscolumns.id and syscolumns.name='attribute_value')
begin
exec('ALTER TABLE le_attribute MODIFY attribute_value varchar (255) NULL')
end
go

if not exists (select 1 from syscolumns,sysobjects where convert(bit, (status &8))=1 and sysobjects.name='recon_inven_run' 
               and sysobjects.id=syscolumns.id and syscolumns.name='target_class')
begin
exec('ALTER TABLE recon_inven_run MODIFY target_class varchar (32) NULL')
end
go

if not exists (select 1 from syscolumns,sysobjects where convert(bit, (status &8))=1 and sysobjects.name='unitized_fund' 
               and sysobjects.id=syscolumns.id and syscolumns.name='name')
begin
exec('ALTER TABLE unitized_fund MODIFY name varchar (500) NULL')
end
go


if not exists (select 1 from syscolumns,sysobjects where convert(bit, (status &8))=1 and sysobjects.name='ca_defaults' 
               and sysobjects.id=syscolumns.id and syscolumns.name='add_cash')
begin
exec('ALTER TABLE ca_defaults MODIFY add_cash varchar (32) NULL')
end
go

if not exists (select 1 from syscolumns,sysobjects where convert(bit, (status &8))=1 and sysobjects.name='ca_defaults' 
               and sysobjects.id=syscolumns.id and syscolumns.name='reinvest_dividend')
begin
exec('ALTER TABLE ca_defaults MODIFY reinvest_dividend varchar (32) NULL')
go
add_column_if_not_exists 'calypso_seed','seed_alloc_size', 'int default 1 null'
go
add_column_if_not_exists 'calypso_seed','seed_offset', 'int null'
go

delete from calypso_seed where last_id=1000 and seed_name='temp'
go
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size, seed_offset ) VALUES ( 1000, 'temp', 500, 1 )
go


/* Update Patch Version */
UPDATE calypso_info
       SET  patch_version='001',
	   version_date='20070515'
go

