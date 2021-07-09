add_column_if_not_exists 'future_contract','und_rel_product_name','varchar(128) null'
go
add_column_if_not_exists 'future_contract','und_rel_product_type','varchar(128) null'
go

update future_contract set und_rel_product_name = 'FutureRelativeProduct_'||currency_code||'_'||exchange_code||'_'||contract_name
where future_type in ('Swap','MM','StructuredFlows')
go

update future_contract set und_rel_product_name = null where  future_type not in ('Swap','MM','StructuredFlows')
go

update future_contract set und_rel_product_type ='Swap' where future_type ='Swap'
go
update future_contract set und_rel_product_type ='Cash' where future_type ='MM'
go
update future_contract set und_rel_product_type ='StructuredFlows' where future_type ='StructuredFlows'
go
update future_contract set und_rel_product_type = null  where future_type not in ('Swap','MM','StructuredFlows')
go

update trade_keyword set keyword_name='TerminationPrincipalExchange', keyword_value='N'
from trade 
where keyword_name='PrincipalExchange' and keyword_value='false' 
and trade_keyword.trade_id=trade.trade_id and trade.trade_status='TERMINATED'
go

update trade_keyword set  keyword_name='TerminationPrincipalExchange' , keyword_value='Y' 
from trade 
where keyword_name='PrincipalExchange' and trade_keyword.keyword_value='true' 
and trade_keyword.trade_id=trade.trade_id and trade.trade_status='TERMINATED'
go

if not exists (select 1 from sysobjects where name='sales_margin_rule')
begin
exec('create table sales_margin_rule (rule_id numeric not null,
processingorg_id numeric  null,
counterparty_or_group numeric  null,
counterparty_or_group_value varchar(512) null,
product_or_group numeric  null,
product_or_group_value varchar(1000) null,
product_subtypes varchar(2048) null,
trade_side varchar(32) null,
currency_or_pair varchar(1000) null,
amount_quantity float null,
channel varchar(32) null,
margin_type varchar(32) not null,
margin_price_format varchar(32) not null,
margin_price float not null,
margin_rounding_method varchar(32) not null,
description varchar(2000) null,
effective_start datetime not null,
effective_end datetime not null,
created_by varchar(28) not null,
created_datetime datetime not null,
version_num numeric not null)')
end
go
select * into sales_margin_rule_back_14_2 from sales_margin_rule
go

create index idx_margin_rule on sales_margin_rule_group(rule_id,group_type,group_value)
go
add_column_if_not_exists 'sales_margin_rule','counterparty_or_group_value','varchar(512) null'
go
add_column_if_not_exists 'sales_margin_rule','product_or_group_value','varchar(4000) null'
go
add_column_if_not_exists 'sales_margin_rule','product_subtypes','varchar(2048) null'
go
add_column_if_not_exists 'sales_margin_rule','currency_or_pair','varchar(1000) null'
go

create procedure update_margin_rule1
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @rule_id int,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT rule_id , 'COUNTERPARTY' as col_key, counterparty_or_group_value  from sales_margin_rule where counterparty_or_group_value is not null
open cur_main
  fetch cur_main into @rule_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 
		     INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parse_out_val)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
			end
		  end
		  
		 
      fetch cur_main into @rule_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_margin_rule1
go

drop procedure update_margin_rule1
go
create procedure update_margin_rule2
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @rule_id int,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT rule_id , 'PRODUCTGROUP' as col_key, product_or_group_value  from sales_margin_rule where product_or_group_value is not null
open cur_main
  fetch cur_main into @rule_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 
		     INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parse_out_val)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
			end
		  end
		  
		 
      fetch cur_main into @rule_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_margin_rule2
go
drop procedure update_margin_rule2
go

create procedure update_margin_rule3
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @rule_id int,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT rule_id , 'PRODUCTSUBTYPE' as col_key, product_subtypes  from sales_margin_rule where product_subtypes is not null
open cur_main
  fetch cur_main into @rule_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 
		     INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parse_out_val)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
			end
		  end
		  
		 
      fetch cur_main into @rule_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_margin_rule3
go
drop procedure update_margin_rule3
go

create procedure update_margin_rule4
as
declare @parse_char     char(1),
      @parse_index    int,
      @parseval   varchar(4000),
      @parse_out_val    varchar(4000),
      @rule_id int,
	  @col_key varchar(255)
	  
declare cur_main cursor for
 SELECT rule_id , 'CURRENCY' as col_key, currency_or_pair  from sales_margin_rule where currency_or_pair is not null
open cur_main
  fetch cur_main into @rule_id,@col_key, @parseval
  while (@@sqlstatus = 0)
		begin
		select @parse_char = ','
		select @parse_index = charindex(@parse_char,@parseval)
		if  (@parse_index = 0)
		begin
            select @parseval = substring(@parseval, 1, len(@parseval))
			INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
		end
		while (charindex(@parse_char, @parseval) > 1)
           begin
             select @parse_index = charindex(@parse_char, @parseval)
             select @parse_out_val = substring(@parseval, 1, @parse_index - 1)
			 
		     INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parse_out_val)
			 select @parseval = substring(@parseval, @parse_index + 1, len(@parseval))
			 select @parse_index = charindex(@parse_char,@parseval)
			 if  (@parse_index = 0)
			 begin
             	select @parseval = substring(@parseval, 1, len(@parseval))
			 	
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (@rule_id, @col_key, @parseval)
			end
		  end
		  
		 
      fetch cur_main into @rule_id,@col_key, @parseval
   end
 close cur_main
 deallocate cursor cur_main
go

exec update_margin_rule4
go

drop procedure update_margin_rule4
go
alter table sales_margin_rule drop counterparty_or_group_value
go
alter table sales_margin_rule drop  currency_or_pair  
go
alter table sales_margin_rule drop  product_or_group_value
go
alter table sales_margin_rule drop product_subtypes
go
if not exists (select 1 from sysobjects where type='U' and name='fee_config')
begin
exec ('create table fee_config (config_id numeric not null,  version_num numeric not null,  
	config_name varchar(64) null, description varchar(256) null, config_type varchar(32), rule_type varchar(32) null, 
	is_tiered_b numeric not null,  active_from datetime null , active_to datetime null, 
	po_id numeric not null , le_id numeric not null , le_role varchar(32) null, 
	fee_type_list varchar(256) null, event_type varchar(64) null, fee_date_rule_id numeric not null , 
	sd_filter_name varchar(64) null, daycount varchar(32) null, has_rebate_b numeric not null , 
	rebate_type varchar(32) null, fixed_rebate float null, book_list varchar(1024) null, 
	book_attribute_list varchar(1024) null, currency_list varchar(256) null, product_list varchar(1024) null, 
	account_list varchar(1024) null, exchange_list varchar(256) null, security_list varchar(1024) null, 
	fee_currency varchar(4) null, scale_by varchar(32) null,  cap float null, floor float null, 
	rebate_currency varchar(4) null, rebate_sub_type varchar(32) null, range_by_tenor numeric not null )')
end
go

sp_rename fee_config, fee_config_back142
go

select * into fee_config  from fee_config_back142 where 1=2
go
alter table fee_config modify fee_type_list varchar(256) 
go
alter table fee_config modify currency_list varchar(256)
go
alter table fee_config modify exchange_list varchar(256)
go
insert into fee_config select * from fee_config_back142
go

update group_access set access_value='CalypsoScheduler' where access_value='SchedulingEngine'
go

update group_access set access_value='QuartzTaskRunner' where access_value='TaskRunner'
go

create proc add_swapcap_if_not_exists (@table_name varchar(255), @column_name varchar(255) , @datatype varchar(255))
as
begin
declare @cnt int
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
if @cnt=0
exec ('alter table ' + @table_name + ' add '+ @column_name +' ' + @datatype)
exec ('select * into prod_struct_flows_back2 from product_structured_flows')
exec ('update swap_leg set capitalize_int_b = (select capitalize_int_b from product_structured_flows where product_id=swap_leg.product_id')
exec ('alter table product_structured_flows drop capitalize_int_b')
end
go

add_swapcap_if_not_exists 'swap_leg','capitalize_int_b','numeric null'
go

create procedure prodcapcur
as
begin
declare @max_trade_version numeric 
declare @diary_id numeric 
declare @trade_id numeric 
declare @product_id numeric 
declare @event_date date 
declare entityCur cursor
for
SELECT diary_id,trade_id,product_id,event_date from trade_diary a
WHERE exists 
(select product_id from product_cap_floor where a.product_id=product_cap_floor.product_id)
and exists
(select * from trade_diary b where a.trade_id = b.trade_id and a.product_id = b.product_id and a.event_date = b.event_date and b.event_type = 'Spread RateReset')
and event_type='RateReset' and start_date=end_date
open entityCur
fetch entityCur into @diary_id,@trade_id,@product_id,@event_date
while (@@sqlstatus=0)
begin 
select @max_trade_version=max(trade_version)
from trade_diary
where trade_id=@trade_id
  and product_id=@product_id
  and event_date=@event_date
  and event_type='Spread RateReset'
  and is_canceled=0
update trade_diary  set trade_diary.start_date= (select start_date from trade_diary 
where trade_id=@trade_id
  and product_id=@product_id
  and event_date=@event_date
  and trade_version = @max_trade_version
  and is_canceled = 0
  and event_type='Spread RateReset')
where trade_diary.diary_id=@diary_id
update trade_diary  set trade_diary.end_date= (select end_date from trade_diary 
where trade_id=@trade_id
  and product_id=@product_id
  and event_date=@event_date
  and trade_version = @max_trade_version
  and is_canceled = 0
  and event_type='Spread RateReset')
where trade_diary.diary_id=@diary_id		
fetch entityCur into @diary_id,@trade_id,@product_id,@event_date
End
close entityCur 
deallocate cursor entityCur
end
go
exec prodcapcur
go
drop procedure prodcapcur
go

if not exists (select 1 from sysobjects where type='U' and name='multi_curve_mapping_info')
begin
exec ('create table multi_curve_mapping_info (	curve_id numeric not null, related_curve_id numeric not null, usage varchar(255) not null)')
end
go

update curve 
set curve_generator='DoubleGlobalSingle' 
where curve_generator='DoubleGlobal' 
and curve_id not in (select curve_id from multi_curve_mapping_info)
go

update main_entry_prop set property_value = 'marketdata.MultiCurvePackageGenerationWindow' where property_value = 'marketdata.mdirelation.MulticurveGenerationWindow'
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='013',
        version_date='20141021'
go 
