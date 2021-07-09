alter table bo_audit modify new_value varchar2(512)
;
alter table bo_audit modify old_value varchar2(512)
;
alter table bo_audit_hist modify new_value varchar2(512)
;
alter table bo_audit_hist modify old_value varchar2(512)
;

ALTER TABLE swap_leg ADD (
    act_initial_exch_b numeric(1) default 1 null,
    act_final_exch_b numeric(1) default 1 null,
    act_amort_exch_b numeric(1)  default 1 null)
;

create or replace procedure char2int (tab_name IN varchar, col_name IN varchar) as
begin
declare 
v_sql varchar(512);
begin

 v_sql := 'alter table '||tab_name||' add calypso_temp_col int';
 execute immediate v_sql;

 v_sql := 'update '||tab_name||' set calypso_temp_col = to_number('||col_name||')';
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' drop column '||col_name;
 execute immediate v_sql;

 v_sql := 'alter table '||tab_name||' add '||col_name||' int';  
 execute immediate v_sql;

 v_sql := 'update '||tab_name||' set '||col_name||' = calypso_temp_col';
 execute immediate v_sql;
 
 v_sql := 'alter table '||tab_name||' drop column calypso_temp_col';
 execute immediate v_sql;

end;
end char2int;
;


begin
 char2int('CU_SWAP','PRINCIPAL_ACTUAL_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','ADJ_FIRST_FLW_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','DEFAULT_FX_RESET_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','FX_RESET_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','PAY_SIDE_RESET_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','USE_IDX_RST_DATE_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','ACT_INIT_EXCH_B');
end;
;


begin
 char2int('XCCY_SWAP_EXT_INFO','ACT_FINAL_EXCH_B');
end;
;

begin
 char2int('XCCY_SWAP_EXT_INFO','ACT_AMORT_EXCH_B');
end;
;
begin
 char2int('SWAP_LEG','COMPOUND_B');
end;
;

begin
 char2int('SWAP_LEG','CPN_OFF_BUS_DAY_B');
end;
;

begin
 char2int('SWAP_LEG','CPN_PAY_AT_END_B');
end;
;

begin
 char2int('SWAP_LEG','CUSTOM_ROL_DAY_B');
end;
;

begin
 char2int('SWAP_LEG','DEF_RESET_OFF_B');
end;
;

begin
 char2int('SWAP_LEG','FST_STB_INTRP_B');
end;
;

begin
 char2int('SWAP_LEG','INCLUDE_FIRST_B');
end;
;

begin
 char2int('SWAP_LEG','INCLUDE_LAST_B');
end;
;


begin
 char2int('SWAP_LEG','LST_STB_INTRP_B');
end;
;

begin
 char2int('SWAP_LEG','MAN_FIRST_DATE_B');
end;
;

begin
 char2int('SWAP_LEG','MAN_FIRST_RESET_B');
end;
;

begin
 char2int('SWAP_LEG','PRIOR_RESET_B');
end;
;

begin
 char2int('SWAP_LEG','RESETCUTOFFBUSDAYB');
end;
;

begin
 char2int('SWAP_LEG','RESET_AVERAGING_B');
end;
;

begin
 char2int('SWAP_LEG','RESET_OFF_BUSDAY_B');
end;
;

 

UPDATE swap_leg
SET act_initial_exch_b = principal_actual_b,
act_final_exch_b = principal_actual_b,
act_amort_exch_b = principal_actual_b
;

UPDATE swap_leg legs
SET act_initial_exch_b =
	CASE
		WHEN principal_actual_b = 1 
			THEN (SELECT act_init_exch_b FROM xccy_swap_ext_info xccys WHERE xccys.product_id = legs.product_id)
		ELSE 0
	END,
act_final_exch_b = 
	CASE
		WHEN principal_actual_b = 1
			THEN (SELECT act_final_exch_b FROM xccy_swap_ext_info xccys WHERE xccys.product_id = legs.product_id)
		ELSE 0
	END,
act_amort_exch_b =
	CASE
		WHEN principal_actual_b = 1 
			THEN (SELECT act_amort_exch_b FROM xccy_swap_ext_info xccys WHERE xccys.product_id = legs.product_id)
		ELSE 0
	END
WHERE EXISTS (SELECT xccy_table.product_id FROM xccy_swap_ext_info xccy_table WHERE xccy_table.product_id = legs.product_id)
;

UPDATE swap_leg SET act_initial_exch_b = 1 WHERE act_initial_exch_b is null
;
UPDATE swap_leg SET act_final_exch_b = 1 WHERE act_final_exch_b is null
;
UPDATE swap_leg SET act_amort_exch_b = 1 WHERE act_amort_exch_b is null
;

ALTER table swap_leg modify act_initial_exch_b not null
;
ALTER table swap_leg modify act_final_exch_b not null
;
ALTER table swap_leg modify act_amort_exch_b not null
;

ALTER TABLE swap_leg ADD reset_dateroll VARCHAR2(16) default 'PRECEDING'
;

UPDATE swap_leg set reset_dateroll = 'PRECEDING'
;

alter table product_fra add (pmt_begin_date_roll varchar2(16) null,
  pmt_begin_holidays varchar2(128) null,
  pmt_end_date_roll varchar2(16) null,
  pmt_end_holidays varchar2(128) null)
;

UPDATE product_fra
  SET pmt_begin_date_roll = 'NO_CHANGE',
      pmt_end_date_roll = 'NO_CHANGE',
      pmt_begin_holidays = holidays,
      pmt_end_holidays = holidays
;

create or replace procedure fbi as
begin
declare
  v_idx_name varchar(28);
  v_sql      varchar(256);
  x          number := 0;
  y          number := 0;
begin
      select count(*) into x from user_ind_columns where table_name = 'PRODUCT_DESC' and column_name = 'DESCRIPTION';
      select count(*) into y from user_ind_columns where table_name = 'PRODUCT_DESC' and column_name like 'SYS%';
  if x = 1 then
     select index_name into v_idx_name from user_ind_columns where table_name = 'PRODUCT_DESC' and column_name = 'DESCRIPTION';
     v_sql := 'drop index '||v_idx_name;
     execute immediate v_sql;
  elsif y = 1 then
     select index_name into v_idx_name from user_ind_expressions where table_name = 'PRODUCT_DESC';
     v_sql := 'drop index '||v_idx_name;
     execute immediate v_sql;
  elsif
       (x = 0 or y = 0) then
     v_sql := 'create index idx_prd_desc_desc_fb on product_desc (lower(description))';
     execute immediate v_sql;
  end if;
end;
end fbi;
;

begin
fbi;
end;
;

drop procedure fbi
;


begin 
  add_column_if_not_exists('eq_link_leg_hist', 'div_pay_ccy', 'varchar2(3)');
end;
;

begin
  add_column_if_not_exists('eq_linked_leg', 'div_pay_ccy', 'varchar2(3)');
end;
;


UPDATE eq_linked_leg SET div_pay_ccy = 
(SELECT performance_leg.currency FROM performance_leg 
WHERE eq_linked_leg.product_id = performance_leg.product_id)
WHERE (div_pay_ccy IS NULL OR div_pay_ccy = '')
;

INSERT INTO quote_name (quote_name, quote_type, decimals)
SELECT domain_values.value , 'NONE' , -1
FROM domain_values
WHERE domain_values.name = 'quoteName'
AND domain_values.value NOT IN (SELECT quote_name FROM quote_name)
and domain_values.value LIKE '%.WAL'
;

INSERT INTO quote_name (quote_name, quote_type, decimals)
SELECT domain_values.value , 'Price' , -1
FROM domain_values
WHERE domain_values.name = 'quoteName'
AND domain_values.value NOT IN (SELECT quote_name FROM quote_name)
and domain_values.value LIKE '%.IndexFactor'
;

INSERT INTO quote_name (quote_name, quote_type, decimals)
SELECT domain_values.value , 'CleanPrice' , -1
FROM domain_values WHERE domain_values.name = 'quoteName'
AND domain_values.value NOT IN (SELECT quote_name FROM quote_name)
and domain_values.value NOT LIKE '%.WAL' and domain_values.value NOT LIKE '%.IndexFactor'
;

delete from domain_values where name like 'quoteName' and value in (select quote_name from quote_name)
;
delete from domain_values where name like 'domainName' and value like 'quoteName'
;

delete from calypso_cache where limit=1 and app_name='DefaultServer'and limit_name='SystemSettings'
;
INSERT INTO calypso_cache (limit,app_name,limit_name,expiration,implementation,eviction) VALUES(1,'DefaultServer','SystemSettings', 0,'Calypso','LRU')
;
delete from domain_values where name='classAuthMode'and value='SystemSettings'
;
INSERT INTO domain_values(name,value) values ('classAuthMode','SystemSettings')
;
delete from domain_values where name='function'and value='AuthorizeSystemSettings'
;
INSERT INTO domain_values(name,value) values ('function','AuthorizeSystemSettings')
;


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
;  

CREATE TABLE system_settings(
name VARCHAR(32) not null,
value VARCHAR(32) not null,
constraint pk_system_settings primary key (name)
)
;

INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('AUTHORIZATION_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='AUTHORIZATION_FLAG' )  
;  
INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('ACCESS_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='ACCESS_FLAG' )  
;  
INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('WORKFLOW_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='WORKFLOW_FLAG' )  
;  
INSERT INTO system_settings(name,value)  
SELECT distinct property_name,property_value FROM user_viewer_prop WHERE property_name in  
('AUDIT_FLAG')  
and NOT Exists  
(SELECT 1 FROM system_settings WHERE name='AUDIT_FLAG' )  
;  


INSERT INTO domain_values(name,value,description) values
('function','ModifyMarketConformityDetail','Access permission to modify Market Conformity details')
;

INSERT INTO domain_values(name,value,description) values
('function','ViewMarketConformity','Access permission to view the Market Conformity window')
;

INSERT INTO domain_values(name,value,description) values
('function','ViewMarketConformityDetail','Access permission to view Market Conformity details in the Market Conformity window')
;

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
;
 

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
;


UPDATE curve SET curve_generator = 'InflationDefault' where curve_generator = 'Inflation'
;
 
INSERT INTO domain_values (name, value, description) values ('CurveInflation.gensimple','InflationBasis','')
;

ALTER TABLE cu_future ADD serial_b numeric(1) Default -1
;

create or replace procedure cu_future_tmp

AS



CURSOR c1 IS 

select cu.contract_id, contract_rank, cunder.cu_currency, cunder.quote_name, cunder.user_name

from future_contract fu, cu_future cu, curve_underlying cunder

where cu.contract_id = fu.contract_id

and instr(fu.relative_months,cu.contract_rank-1)>0

and cunder.cu_id = cu.cu_id;



CURSOR last_id IS 

select last_id from calypso_seed where seed_name = 'refdata';



CURSOR serialB IS 

select count(*) from cu_future where serial_b=-1;


trade_seed_id NUMBER :=0;
contract_id   NUMBER :=0;
contract_rank NUMBER :=0;
isSerialB     NUMBER :=0;
currency      varchar(3);
quote_name     varchar(255);
user_name     varchar(32);

BEGIN

open serialB;

fetch  serialB into isSerialB;

close serialB;

IF isSerialB is not null THEN

  execute immediate 'UPDATE cu_future SET serial_b = 0';

  execute immediate 'UPDATE cu_future SET serial_b = 1 
		     where exists(
				  select distinct cu_future.cu_id 
				  from future_contract fu 
				  where cu_future.contract_id = fu.contract_id and instr(fu.relative_months,cu_future.contract_rank-1)>0)';

  open last_id;

  FETCH last_id into trade_seed_id;

  close last_id;

  open c1;

    LOOP

    FETCH c1 into contract_id, contract_rank, currency, quote_name, user_name;

    EXIT WHEN c1%NOTFOUND;
       IF user_name is null THEN
       user_name := 'calypso_user';
       END IF;

       trade_seed_id := trade_seed_id + 1;

       execute immediate 'INSERT INTO cu_future (cu_id, contract_id, contract_rank, serial_b)

       values('||trade_seed_id||','||contract_id||','||contract_rank||',0)';       

       execute immediate 'INSERT INTO curve_underlying (cu_id, cu_type, cu_currency, quote_name, user_name, version_num)

       values('||trade_seed_id||','||chr(39)||'CurveUnderlyingFuture'||chr(39)||','||chr(39)||currency||chr(39)||','||chr(39)||quote_name||chr(39)||','||chr(39)||user_name||chr(39)||',0)';

    END LOOP;

    trade_seed_id := trade_seed_id + 1;

    execute immediate 'update calypso_seed set last_id ='||trade_seed_id||' where seed_name =' ||chr(39)||'refdata' ||chr(39);

  close c1;

  commit;

END IF;  

END cu_future_tmp;
;


begin
  cu_future_tmp;
end;
;

drop procedure cu_future_tmp
;


/* script to remove entries relating to the obsolete 'FOPositionWindow' */
/* from the main_entry_prop table                                       */
/* the PK is over 'USER_NAME' & 'PROPERTY_NAME'                         */
 
/* notes on the functions used :                                        */
/* 
/* instr (string_to_be_searched, what_im_looking_for, start_pos, nth appearance) */
/* substr (string_to_be_searched, start_pos, no_of_chars_after_start_pos)  */

/* lets take a backup first */


create table main_entry_prop_bak as select * from main_entry_prop 
;

create table fopos_tmp (prefix_code varchar2(32))
;

create or replace procedure fo as 
begin
declare
  v_prefix_code varchar(16);
  v_sql varchar(512);
  v_prop_value varchar(256);
  x varchar(128);
  v_str1 varchar(255);
  v_str2 varchar(255);
  v_start_pos number;
  n number; 
  v_user_name varchar(255);
  v_property_name varchar(255);
  cursor c1 is select property_name, user_name, substr(property_name,1,instr(property_name, 'Action')-1) AS a_prefix_code, 
                      property_value from main_entry_prop
                      where property_value = 'reporting.FOPositionWindow';
 
  cursor c2 is select prefix_code from fopos_tmp;
  cursor c3 is select user_name, property_name, property_value from main_entry_prop;
begin
  for c1_rec in c1 LOOP 
      v_prefix_code := substr(c1_rec.property_name,1,instr(c1_rec.property_name, 'Action')-1);
                  v_sql := 'insert into fopos_tmp values ('||chr(39)||v_prefix_code||chr(39)||')';
      execute immediate v_sql;
       v_sql := 'delete from main_entry_prop where user_name='||chr(39)||c1_rec.user_name||chr(39)||' and property_name IN ('
        ||chr(39)||v_prefix_code||'Action'||chr(39)||','||
          chr(39)||v_prefix_code||'Image'||chr(39)||','||
          chr(39)||v_prefix_code||'Label'||chr(39)||','||
          chr(39)||v_prefix_code||'Accelerator'||chr(39)||','||
          chr(39)||v_prefix_code||'Mnemonic'||chr(39)||','||
          chr(39)||v_prefix_code||'Tooltip'||chr(39)||') '; 
execute immediate v_sql;
END LOOP;
open c2 ; loop
  fetch c2 into v_prefix_code; 
   exit when c2%NOTFOUND;
   x := chr(37)||v_prefix_code||chr(37);
   open c3; loop
    fetch c3 into v_user_name, v_property_name, v_prop_value;
   exit when c3%NOTFOUND;
   if v_prop_value like x then 
       v_str1 := substr(v_prop_value,1,(instr(v_prop_value,v_prefix_code)-1));
       v_start_pos := instr(v_prop_value,v_prefix_code); 
       v_str2 := substr(v_prop_value,v_start_pos+length(v_prefix_code)+1);
   v_sql := 'update main_entry_prop set property_value = '||chr(39)||v_str1||v_str2||chr(39)||
		' where property_value = '||chr(39)||v_prop_value||chr(39)||
		' and user_name = '||chr(39)||v_user_name||chr(39)||
		' and property_name = '||chr(39)||v_property_name||chr(39);
   execute immediate v_sql;
   end if; 
   END LOOP;
   CLOSE c3;            
 END LOOP;
close c2;
end;
 execute immediate 'drop table fopos_tmp'; 
end fo;

;

begin
 fo;
end;
;

drop procedure fo
;



create or replace procedure dropaddfk as

begin

declare
  v_sql varchar(1000);
  cursor c1 is select table_name,constraint_name from user_constraints
        where constraint_type = 'R';
  cursor c2 is select table_name, constraint_name from user_constraints
        where constraint_type = 'P'
        and table_name in ('CALYPSO_TREE','CALYPSO_TREE_NODE','TWS_NODE',
                                'TWS_RISK_NODE','TWS_BLOTTER_NODE');

begin

for c1_rec in c1 LOOP
  v_sql := 'alter table '||c1_rec.table_name||' drop constraint '||c1_rec.constraint_name;
  execute immediate v_sql;
end loop;

for c2_rec in c2 LOOP
  v_sql := 'alter table '||c2_rec.table_name||' drop constraint '||c2_rec.constraint_name||' drop index';
  execute immediate v_sql;
end loop;


execute immediate 'alter table CALYPSO_TREE ADD CONSTRAINT pk_calypso_tree_id PRIMARY KEY (tree_id)';

execute immediate 'alter table CALYPSO_TREE_NODE ADD CONSTRAINT pk_calypso_tree_node_id PRIMARY KEY (tree_node_id)';

execute immediate 'alter table TWS_NODE ADD CONSTRAINT pk_tws_node_id PRIMARY KEY (tree_node_id)';

execute immediate 'alter table TWS_RISK_NODE ADD CONSTRAINT pk_tws_risk_node_id PRIMARY KEY (tree_node_id)';

execute immediate 'alter table TWS_BLOTTER_NODE ADD CONSTRAINT pk_tws_blotter_node_id PRIMARY KEY (tree_node_id)';

 execute immediate 'alter table calypso_tree_node add constraint fk_calypso_tree_node FOREIGN KEY
  (tree_node_id) REFERENCES calypso_tree (tree_id) initially deferred deferrable';

 execute immediate 'alter table tws_node add constraint fk_tws_node FOREIGN KEY
  (tree_node_id) REFERENCES calypso_tree (tree_id) initially deferred deferrable';

 execute immediate 'alter table tws_risk_node add constraint fk_tws_risk_node FOREIGN KEY
  (tree_node_id) REFERENCES calypso_tree (tree_id) initially deferred deferrable';

 execute immediate 'alter table tws_blotter_node add constraint fk_tws_blotter_node FOREIGN KEY
  (tree_node_id) REFERENCES calypso_tree (tree_id) initially deferred deferrable';


 exception when others then null;

end;

end dropaddfk;
;

begin
 dropaddfk;
end;
;

drop procedure dropaddfk
;


INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'AccReversalRule', 'For Supporting Accounting Set Up' )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'AccDateRule', 'For Supporting Accounting Set Up' )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'AccAdjustmentDays', 'For Supporting Accounting Set Up' )
;
delete from country where country_id=241 and iso_code='EU' and name='EURO' and active_from=to_date('1970-01-01','YYYY-MM-DD')
  and active_to=to_date('2100-01-01','YYYY-MM-DD') and default_holidays = 'EUR' and time_zone='Europe/Berlin' and  enabled_b=1
;
INSERT INTO country ( country_id, iso_code, name, active_from, active_to, default_holidays, time_zone, enabled_b ) VALUES 
  ( 241, 'EU', 'EURO', to_date('1970-01-01','YYYY-MM-DD'), to_date('2100-01-01','YYYY-MM-DD'), 'EUR', 'Europe/Berlin', 1 )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'DIVIDEND_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'BORROW_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'TS_CHANGE_DATE_TYPE', 'Allow User to Change the Date Type in TaskStation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'TS_INCREASE_DATE_RANGE', 'Allow User to Change the Date Range in TaskStation' )
;
delete from domain_values where name='function' and value='ModifyTargetDirectory'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyTargetDirectory', 'Allow User to Change Entry in Target Directory' )
;
INSERT INTO domain_values ( name, value, description ) VALUES 
  ( 'VolSurface.gensimple', 'GBM2FSpreadCorrelation', 
    'Generator adds an additional point adjustment surface to store a matrix of (skew)spread correlations for the GBM2F model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineParam', 'VERSION_CHECK', 'do not handle obviously out-of-date events' )
;
INSERT INTO domain_values ( name, value, description ) VALUES 
  ( 'SingleSwapLeg.Pricer', 'PricerSingleSwapLegExotic', 'Pricer for Single Swap Leg for a class of exsp based legs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'DividendType', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DividendType', 'Regular', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DividendType', 'Special', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DividendType', 'Final', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DividendType', 'Interim', '' )
;
delete from domain_values where name= 'volatilityType' and value='MMFUTURE'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volatilityType', 'MMFUTURE', '' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'domainName', 'calendarIsoCodes' )
;
delete from domain_values where name= 'settlementMethod' and value='TARGET2'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'settlementMethod', 'TARGET2', 'TARGET2' )
;
delete from domain_values where name='exceptionType' and value='TARGET2'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'TARGET2', '' )
;
delete from domain_values where name= 'role' and value='Addressee'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'role', 'Addressee', 'Addressee Role' )
;
delete from domain_values where name = 'scheduledTask' and value = 'ROLL_ACCENGINEDAY' and description = 'Roll the Accounting Engine Business Date'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'ROLL_ACCENGINEDAY', 'Roll the Accounting Engine Business Date' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'LOAD_TARGET2_DIRECTORY', 'Load Target2 Directory' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'Pricing', '' )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'DIVIDEND_EFFECT', 'Dividend Effect', 63, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'BORROW_EFFECT', 'Borrow Effect', 64, 'NPV', 0 )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSingleSwapLegExotic', 'RISK_OPTIMISE', 'true' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES 
  ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'STRIKE_SPREAD_EPSILON', '10.0' )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES 
  ( 'default', 'PricerSpreadCapFloorGBM2FHagan', 'DIGITAL_VALUATION_METHOD', 'CENTRAL_REPLICATE' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES 
  ( 'COUPON_PAYOFFS', 'tk.core.PricerMeasure', 242, 'records the coupon payoff graph in the client data' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DETAILED_DATA', 'tk.core.TabularPricerMeasure', 250 )
;
delete from pricing_param_name where param_name='BORROW_SPREAD' and param_type='com.calypso.tk.core.Spread'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES 
  ( 'BORROW_SPREAD', 'com.calypso.tk.core.Spread', '', 'Borrow spread for option pricing', 0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES 
  ( 'DIGITAL_VALUATION_METHOD', 'java.lang.String', 'THEORETICAL,CENTRAL_REPLICATE,SUB_REPLICATE,SUPER_REPLICATE', '', 1,
    'DIGITAL_VALUATION_METHOD', 'CENTRAL_REPLICATE' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES
  ( 'RISK_OPTIMISE', 'java.lang.Boolean', 'true,false', 
    'Flag controls whether or not the pricer makes any attempt to optimise in the getRiskExposure method', 1, 'RISK_OPTIMISE', 'true' )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 122, 'RiskAggregation', 1, 0, 1 )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 123, 'CompositeAnalysis', 1, 0, 1 )
;

create or replace procedure dropuc as
begin
declare v_sql varchar(500);
cursor c1 is select table_name, constraint_name from user_constraints where constraint_type = 'U';
begin
for c1_rec in c1 LOOP
v_sql := 'alter table '||c1_rec.table_name||' drop constraint '||c1_rec.constraint_name;
execute immediate v_sql;
end loop;
end;
end dropuc;
;

begin
  dropuc;
end;
;



begin
 add_column_if_not_exists('CALYPSO_SEED','SEED_ALLOC_SIZE','INT');
end;
;

begin
 add_column_if_not_exists('CALYPSO_SEED','SEED_OFFSET','INT');
end;
;

delete from calypso_seed where last_id = 1000 and seed_name = 'temp' and seed_alloc_size = 500 and seed_offset = 1
;
delete from calypso_seed where last_id = 1000 and seed_name = 'pos_agg' and seed_offset = 1
;

INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size, seed_offset ) VALUES ( 1000, 'temp', 500, 1 )
; 
INSERT INTO calypso_seed ( last_id, seed_name , seed_offset) VALUES ( 1000, 'pos_agg',1 )
;

/* Update Patch Version */
UPDATE calypso_info
       SET patch_version='001',	
	   patch_date=TO_DATE('15/05/2007 12:00:00','DD/MM/YYYY HH-MI-SS')
;
