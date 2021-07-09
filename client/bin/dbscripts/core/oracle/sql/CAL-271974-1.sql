begin
  add_column_if_not_exists('future_contract', 'und_rel_product_name', 'varchar2(128)');
end;
/
begin
  add_column_if_not_exists('future_contract', 'und_rel_product_type', 'varchar2(128)');
end;
/

update future_contract set und_rel_product_name = 'FutureRelativeProduct_'||currency_code||'_'||exchange_code||'_'||contract_name
where future_type in ('Swap','MM','StructuredFlows')
;

update future_contract set und_rel_product_name = null where  future_type not in ('Swap','MM','StructuredFlows')
;

update future_contract set und_rel_product_type ='Swap' where future_type ='Swap'
;
update future_contract set und_rel_product_type ='Cash' where future_type ='MM'
;
update future_contract set und_rel_product_type ='StructuredFlows' where future_type ='StructuredFlows'
;
update future_contract set und_rel_product_type = null where  future_type not in ('Swap','MM','StructuredFlows')
;
update trade_keyword set keyword_name= 'TerminationPrincipalExchange' , keyword_value='N' 
where trade_keyword.trade_id in 
(select trade_id  from trade where trade_keyword.keyword_name='PrincipalExchange' 
	and trade_keyword.keyword_value='false' 
	and trade.trade_id=trade_keyword.trade_id and  trade.trade_status='TERMINATED')
;
update trade_keyword set keyword_name= 'TerminationPrincipalExchange' , keyword_value='Y' 
where trade_keyword.trade_id in 
(select trade_id  from trade where trade_keyword.keyword_name='PrincipalExchange' 
	and trade_keyword.keyword_value='true' 
	and trade.trade_id=trade_keyword.trade_id and  trade.trade_status='TERMINATED')
;

declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tables WHERE table_name='SALES_MARGIN_RULE' ;
  IF x=0 THEN
    execute immediate 'create table sales_margin_rule 
   (	rule_id number(*,0) not null enable, 
	processingorg_id number(*,0), 
	counterparty_or_group number(*,0), 
	counterparty_or_group_value varchar2(512 byte), 
	product_or_group number(*,0), 
	product_or_group_value varchar2(4000 byte), 
	product_subtypes varchar2(2048 byte), 
	trade_side varchar2(32 byte), 
	currency_or_pair varchar2(4000 byte), 
	amount_quantity float(126), 
	channel varchar2(32 byte), 
	margin_type varchar2(32 byte) not null enable, 
	margin_price_format varchar2(32 byte) not null enable, 
	margin_price float(126) not null enable, 
	margin_rounding_method varchar2(32 byte) not null enable, 
	description varchar2(2000 byte), 
	effective_start timestamp (6) not null enable, 
	effective_end timestamp (6) not null enable, 
	created_by varchar2(128 byte) not null enable, 
	created_datetime timestamp (6) not null enable, 
	version_num number(*,0) not null enable, 
	constraint pk_sales_margin_rule1 primary key (rule_id))';
 	END IF;
end;
/

create table sales_margin_rule_back_14_2 as (select * from sales_margin_rule)
;
begin
add_column_if_not_exists ('sales_margin_rule','counterparty_or_group_value','varchar2(512) null');
end;
/
begin
add_column_if_not_exists ('sales_margin_rule','currency_or_pair','varchar2(1000) null'); 
end;
/
begin
add_column_if_not_exists ('sales_margin_rule','product_or_group_value','varchar2(1000) null');
end;
/
begin
add_column_if_not_exists ('sales_margin_rule','product_subtypes','varchar2(2048) null');
end;
/
create index idx_margin_rule on sales_margin_rule_group(rule_id,group_type,group_value)
;
create or replace procedure update_margin_rule1
is 
begin
declare 
cursor c1 is 
SELECT rule_id , 'COUNTERPARTY' as col_key, counterparty_or_group_value  from sales_margin_rule where counterparty_or_group_value is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      rule_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into rule_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parse_out_val);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
			end if;
			end loop;
			fetch c1 into rule_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_margin_rule1;
end;
/

drop procedure update_margin_rule1
;

create or replace procedure update_margin_rule2
is 
begin
declare 
cursor c1 is 
SELECT rule_id , 'PRODUCTGROUP' as col_key, product_or_group_value  from sales_margin_rule where product_or_group_value is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      rule_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into rule_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parse_out_val);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
			end if;
			end loop;
			fetch c1 into rule_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_margin_rule2;
end;
/
drop procedure update_margin_rule2
;
create or replace procedure update_margin_rule3
is 
begin
declare 
cursor c1 is 
SELECT rule_id , 'PRODUCTSUBTYPE' as col_key, product_subtypes  from sales_margin_rule where product_subtypes is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      rule_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into rule_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parse_out_val);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
			end if;
			end loop;
			fetch c1 into rule_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_margin_rule3;
end;
/
drop procedure update_margin_rule3
;

create or replace procedure update_margin_rule4
is 
begin
declare 
cursor c1 is 
SELECT rule_id , 'CURRENCY' as col_key, currency_or_pair  from sales_margin_rule where currency_or_pair is not null;
      parse_char   varchar2(1);
      parse_index    int;
      parseval   varchar2(4000);
      parse_out_val  varchar2(4000);
      rule_id int;
	  col_key varchar2(255);
	  
begin 
open c1; 
fetch c1 into rule_id , col_key ,parseval;
while c1%FOUND 
loop 
	
		parse_char := ',';
		
		parse_index := instr(parseval,parse_char);
		if  parse_index = 0 then
			 parseval := substr(parseval, 1, length(parseval));
			  INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
		end if;
		while (instr(parseval,parse_char) > 1)
			loop 
			  parse_index := instr(parseval,parse_char);
              parse_out_val := substr(parseval, 1, parse_index - 1);
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parse_out_val);
			 parseval := substr(parseval, parse_index + 1, length(parseval));
			  parse_index := instr(parseval,parse_char);
			 if parse_index = 0 then
			  parseval := substr(parseval, 1, length(parseval));
			  
			 	INSERT INTO sales_margin_rule_group(rule_id, group_type,group_value ) VALUES (rule_id, col_key, parseval);
			end if;
			end loop;
			fetch c1 into rule_id , col_key ,parseval;
end loop;
end;
end;
/
begin
update_margin_rule4;
end;
/
drop procedure update_margin_rule4
;
alter table sales_margin_rule drop column counterparty_or_group_value
;
alter table sales_margin_rule drop column currency_or_pair  
;
alter table sales_margin_rule drop column  product_or_group_value
;
alter table sales_margin_rule drop column product_subtypes
;
update acc_account set call_acc_subtype = 'Security' where call_acc_subtype is null
and acc_account_id in (select account_id from account_trans where attribute = 'SecuritySettle' and value='true')
;
update group_access set access_value='CalypsoScheduler' where access_value='SchedulingEngine'
;
update group_access set access_value='QuartzTaskRunner' where access_value='TaskRunner'
;

declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tables WHERE table_name=upper('fee_config') ;
  IF x=0 THEN
    execute immediate 'create table fee_config (config_id number(*,0) not null,  version_num number(*,0) not null,  
	config_name varchar2(64), description varchar2(256), config_type varchar2(32), rule_type varchar2(32), 
	is_tiered_b number(*,0) not null,  active_from timestamp (6), active_to timestamp (6), 
	po_id number(*,0) not null , le_id number(*,0) not null , le_role varchar2(32), 
	fee_type_list varchar2(256), event_type varchar2(64), fee_date_rule_id number(*,0) not null , 
	sd_filter_name varchar2(64), daycount varchar2(32), has_rebate_b number(*,0) not null , 
	rebate_type varchar2(32), fixed_rebate float(126), book_list varchar2(1024), 
	book_attribute_list varchar2(1024), currency_list varchar2(256), product_list varchar2(1024), 
	account_list varchar2(1024), exchange_list varchar2(256), security_list varchar2(1024), 
	fee_currency varchar2(4), scale_by varchar2(32), cap float(126), floor float(126), 
	rebate_currency varchar2(4), rebate_sub_type varchar2(32), range_by_tenor number(*,0) not null ) ';
  END IF;
end;
/
rename fee_config to fee_config_back142
;
create table fee_config as select * from  fee_config_back142 where 1=2
;
alter table fee_config modify (fee_type_list varchar2(256))
;
alter table fee_config modify (exchange_list varchar2(256))
;
insert into fee_config select * from fee_config_back142
;
 

begin
add_column_if_not_exists ('swap_leg','capitalize_int_b','number default 0 null');
end;
/

DECLARE
CURSOR C1 is SELECT * from trade_diary a
WHERE exists 
(select product_id from product_cap_floor where a.product_id=product_cap_floor.product_id)
and exists
(select * from trade_diary b where a.trade_id = b.trade_id and a.product_id = b.product_id and a.event_date = b.event_date and b.event_type = 'Spread RateReset')
and a.event_type='RateReset' 
and a.start_date=a.end_date;

v_max_trade_version int;

BEGIN
FOR C1_REC in C1
LOOP

select max(trade_version) into v_max_trade_version 
from trade_diary
where trade_id=C1_REC.trade_id
and product_id=C1_REC.product_id
and event_date=C1_REC.event_date
and event_type='Spread RateReset'
and is_canceled=0;

update trade_diary b set b.start_date= (select start_date from trade_diary
where trade_id=C1_REC.trade_id
  and product_id=C1_REC.product_id
  and event_date=C1_REC.event_date
  and is_canceled=0 
  and trade_version = v_max_trade_version
  and event_type='Spread RateReset')
  where b.diary_id=C1_REC.diary_id;
  
update trade_diary b set b.end_date= (select end_date from trade_diary 
where trade_id=C1_REC.trade_id
  and product_id=C1_REC.product_id
  and event_date=C1_REC.event_date
  and is_canceled=0 
  and trade_version = v_max_trade_version
  and event_type='Spread RateReset')
  where b.diary_id=C1_REC.diary_id;
  
  COMMIT;
END LOOP;
exception
  when NO_DATA_FOUND THEN null;
END;
/

declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tables WHERE table_name='MULTI_CURVE_MAPPING_INFO' ;
  IF x=0 THEN
    execute immediate 'CREATE TABLE MULTI_CURVE_MAPPING_INFO (	CURVE_ID NUMBER(*,0) NOT NULL, 
	RELATED_CURVE_ID NUMBER(*,0) NOT NULL, USAGE VARCHAR2(255 BYTE) NOT NULL)';
 	END IF;
end;
/

update curve 
set curve_generator='DoubleGlobalSingle' 
where curve_generator='DoubleGlobal' 
and curve_id not in (select curve_id from multi_curve_mapping_info)
;

update main_entry_prop set property_value = 'marketdata.MultiCurvePackageGenerationWindow' where property_value = 'marketdata.mdirelation.MulticurveGenerationWindow'
; 

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='013',
        version_date=TO_DATE('21/10/2014','DD/MM/YYYY') 
;