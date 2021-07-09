DELETE FROM pricer_measure WHERE measure_name LIKE '%GENERIC_CASH%'
;
delete from domain_values where name = 'DispatcherParamsSymphony'
;
DELETE FROM domain_values WHERE value = 'CashSettleDefaultsAgreements'
;
DELETE FROM domain_values WHERE name = 'CashSettleDefaultsAgreements'
;



/* BZ 49534 */
delete from domain_values where name = 'liquidationMethod' and value in ('Bond', 'Security')
;

delete from domain_values where name = 'sortMethod' and value in ('TradeId')
;




UPDATE /*+ PARALLEL (  liq_info  )  */ liq_info SET date_rule_id = (SELECT date_rule_id FROM date_rule WHERE date_rule_name = date_rule)
;


/* BZ 55036 */

UPDATE /*+ PARALLEL (  legal_entity )  */ legal_entity 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL (  book )  */ book 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL (  wfw_transition )  */ wfw_transition 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL (  product_desc )  */ product_desc 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL (   ps_event_cfg_name )  */  ps_event_cfg_name 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL (  curve_underlying )  */ curve_underlying 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE  /*+ PARALLEL ( pricer_config )  */  pricer_config 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL ( liq_info ) */  liq_info 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL ( acc_account ) */ acc_account 
SET version_num=0 
WHERE version_num IS NULL
;

UPDATE /*+ PARALLEL ( currency_default ) */  currency_default 
SET version_num=0 
WHERE version_num IS NULL
;

/* end */

insert into domain_values (name, value, description) select 'TerminationAssignee', value, description from domain_values where name = 'terminationAssignee'
;
delete from domain_values where name = 'terminationAssignee'
;
insert into trade_keyword (trade_id, keyword_name, keyword_value) select trade_id, 'TerminationAssignee', keyword_value from trade_keyword where keyword_name = 'terminationAssignee'
;
delete from trade_keyword where keyword_name = 'terminationAssignee'
;
insert into domain_values (name, value, description) select 'TerminationAssignor', value, description from domain_values where name = 'terminationAssignor'
;
delete from domain_values where name = 'terminationAssignor'
;
insert into trade_keyword (trade_id, keyword_name, keyword_value) select trade_id, 'TerminationAssignor', keyword_value from trade_keyword where keyword_name = 'terminationAssignor'
;
delete from trade_keyword where keyword_name = 'terminationAssignor'
;
insert into domain_values (name, value, description) select 'keyword.TerminationReason', value, description from domain_values where name = 'terminationReason'
;
delete from domain_values where name = 'terminationReason'
;
insert into trade_keyword (trade_id, keyword_name, keyword_value) select trade_id, 'TerminationReason', keyword_value from trade_keyword where keyword_name = 'terminationReason'
;
delete from trade_keyword where keyword_name = 'terminationReason'
;
delete from domain_values where name = 'keyword.terminationReason'
;
delete from domain_values where value = 'keyword.terminationReason'
;
delete from domain_values where value = 'terminationReason'
;
delete from domain_values where name = 'terminationAssignee'
;
delete from domain_values where value = 'terminationAssignee'
;
delete from domain_values where name = 'terminationAssignor'
;
delete from domain_values where value = 'terminationAssignor'
;

/* BZ 40050 */
insert into domain_values (name, value, description) values ('AllocationSupported','CancellableSwap','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','CancellableXCCySwap','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','XCCySwap','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','CapFloor','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','CappedSwap','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','ExoticCapFloor','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','ExtendibleSwap','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','FRA','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','SingleSwapLeg','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','Swap','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','Swaption','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','NDS','')
;
insert into domain_values (name, value, description) values ('AllocationSupported','SpreadCapFloor','')
;

/* BZ 40050 end */

update domain_values set description='Price is taken from the first Forward Point date which is greater than the closest upcoming First Delivery Date' where name='commodity.ForwardPriceMethods' and value='NearbyNonDelivered'
;

/* BZ 60936 */
 

begin
add_column_if_not_exists('fee_definition','offset_business_b','number');
end;
;


UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'PREMIUM'
;

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'SPOT_MARGIN'
;

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'FAR_MARGIN'
;

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'UPFRONT_FEE'
;

UPDATE fee_definition
SET is_allocated = 1
WHERE fee_type = 'FXOPT_MARGIN'
;

/* BZ 55036 */
UPDATE /*+ PARALLEL (  book )  */ book SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL (  currency_default )  */ currency_default SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL (  currency_pair )  */ currency_pair SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( curve_underlying )  */ curve_underlying SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( holiday_code )  */ holiday_code SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( le_attribute)  */ le_attribute SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL (  le_contact)  */ le_contact SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( le_settle_delivery )  */ le_settle_delivery SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( legal_entity )  */ legal_entity SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL (  liq_info)  */ liq_info SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( netting_method)  */ netting_method SET version_num=0 WHERE version_num IS NULL
;
UPDATE  /*+ PARALLEL ( pricer_config)  */ pricer_config SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( product_desc)  */ product_desc SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( ps_event_cfg_name)  */ ps_event_cfg_name SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( quote_value)  */ quote_value SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( rate_index)  */ rate_index SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( rate_index_default)  */ rate_index_default SET version_num=0 WHERE version_num IS NULL
;
UPDATE /*+ PARALLEL ( wfw_transition)  */ wfw_transition SET version_num=0 WHERE version_num IS NULL
;

/* BZ 55036 end */
/* BZ 57987 */

update product_els set auto_adj_swp_notional=auto_adj_swp_not_b
;
/*end*/

/*BZ 52825*/
update product_cdsnthloss set amort_type='None'
;
/* end BZ 52825*/

/*BZ 58120*/
CREATE OR REPLACE PROCEDURE add_OPTION_OBSERVE
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
        EXECUTE IMMEDIATE 'create table OPTION_OBSERVATION_METHOD ( product_id  number not null,  usage varchar2(16) not null,  observation_type varchar2(32) not null, version number not null , value  float null ,
multiplier float not null, in_out_processor_type varchar2(16) null,  schedule_id number null, is_ov_basis number null,
 basis float null, CONSTRAINT  PK_OPTION_OBSERVATIO3 primary key  (product_id, usage))';
    END IF;
END add_OPTION_OBSERVE;
;

BEGIN
add_OPTION_OBSERVE('OPTION_OBSERVATION_METHOD');
END;
;

drop PROCEDURE add_OPTION_OBSERVE
;
update OPTION_OBSERVATION_METHOD set OBSERVATION_TYPE='SPOT' where OBSERVATION_TYPE='SpotObservationMethod'
;
update OPTION_OBSERVATION_METHOD set OBSERVATION_TYPE='FWD_START' where OBSERVATION_TYPE='ForwardStartingObservationMethod'
;
update OPTION_OBSERVATION_METHOD set OBSERVATION_TYPE='FORMULA' where OBSERVATION_TYPE='ProcessorObservationMethod'
;
update OPTION_OBSERVATION_METHOD set OBSERVATION_TYPE='CONST' where OBSERVATION_TYPE='ConstantObservationMethod'
;

/*end*/
/*  BZ 37789  */

UPDATE le_settle_delivery SET reference = sdi_id WHERE reference IS NULL
;

UPDATE manual_sdi SET reference = sdi_id WHERE reference IS NULL
;

/*  BZ 56506  */

UPDATE referring_object SET rfg_tbl_join_cols = 'prd_sd_filter_name' WHERE rfg_obj_id = 11
;

INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (601, 1, 'sched_task_attr', 'task_id', '1', 'attr_value', 'attr_name IN (''SD_FILTER'', ''STATIC DATA FILTER'', ''TRANSFER_FILTER'', ''SD Filter'', ''Xfer SD Filter'', ''Msg SD Filter'')', 'ScheduledTask', 'apps.refdata.ScheduledTaskWindow', 'Scheduled Task - Attributes')
;

INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (602, 2, 'sched_task_attr', 'task_id', '1', 'attr_value', 'attr_name IN (''OTC Trade Filter'')', 'ScheduledTask', 'apps.refdata.ScheduledTaskWindow', 'Scheduled Task - Attributes')
;

INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (501, 2, 'entity_attributes', 'entity_id', '1', 'attr_value', 'entity_attributes.attr_name = ''TRADE_FILTER'' AND entity_attributes.entity_type = ''ReportTemplate''', 'ReportTemplate', 'apps.reporting.ReportWindow', 'ReportTemplate attribute')
;

INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (502, 1, 'entity_attributes', 'entity_id', '1', 'attr_value', 'entity_attributes.attr_name = ''SdFilter'' AND entity_attributes.entity_type = ''ReportTemplate''', 'ReportTemplate', 'apps.reporting.ReportWindow', 'ReportTemplate attribute')
;

INSERT INTO referring_object (rfg_obj_id, ref_obj_id, rfg_tbl_name, rfg_tbl_sel_cols, rfg_tbl_sel_types, rfg_tbl_join_cols, extra_where_clause, rfg_obj_class_name, rfg_obj_window, rfg_obj_desc) VALUES (503, 3, 'entity_attributes', 'entity_id', '1', 'attr_value', 'entity_attributes.attr_name = ''FilterSet'' AND entity_attributes.entity_type = ''ReportTemplate''', 'ReportTemplate', 'apps.reporting.ReportWindow', 'ReportTemplate attribute')
;

/*  BZ58682*/

update trade set quantity = 1 where product_id in (select product_id FROM product_pm_depo_lease where deposit_lease_type=1)
;
update trade set quantity = -1 where product_id in (select product_id FROM product_pm_depo_lease where deposit_lease_type=2)
;

/* BZ 55036 - Add classes to classAuditMode */
DELETE FROM domain_values WHERE name = 'classAuditMode' and value IN ('CA', 'CDSABSIndexDefinition', 'CDSIndexDefinition', 'CFD', 'CollateralPool', 'Commodity', 'CommodityCertificate', 'Equity', 'EquityIndex', 'ETO', 'ExoticConfigurableTypeI', 'Future', 'FutureOption', 'FX', 'Holding', 'Issuance', 'Loan', 'MarketIndex', 'MMDiscount', 'MMInterest', 'PositionCash', 'UnitizedFund', 'Warrant')
;
INSERT INTO domain_values VALUES('classAuditMode','CA','')
;
INSERT INTO domain_values VALUES('classAuditMode','CDSABSIndexDefinition','')
;
INSERT INTO domain_values VALUES('classAuditMode','CDSIndexDefinition','')
;
INSERT INTO domain_values VALUES('classAuditMode','CFD','')
;
INSERT INTO domain_values VALUES('classAuditMode','CollateralPool','')
;
INSERT INTO domain_values VALUES('classAuditMode','Commodity','')
;
INSERT INTO domain_values VALUES('classAuditMode','CommodityCertificate','')
;
INSERT INTO domain_values VALUES('classAuditMode','Equity','')
;
INSERT INTO domain_values VALUES('classAuditMode','EquityIndex','')
;
INSERT INTO domain_values VALUES('classAuditMode','ETO','')
;
INSERT INTO domain_values VALUES('classAuditMode','ExoticConfigurableTypeI','')
;
INSERT INTO domain_values VALUES('classAuditMode','Future','')
;
INSERT INTO domain_values VALUES('classAuditMode','FutureOption','')
;
INSERT INTO domain_values VALUES('classAuditMode','FX','')
;
INSERT INTO domain_values VALUES('classAuditMode','Holding','')
;
INSERT INTO domain_values VALUES('classAuditMode','Issuance','')
;
INSERT INTO domain_values VALUES('classAuditMode','Loan','')
;
INSERT INTO domain_values VALUES('classAuditMode','MarketIndex','')
;
INSERT INTO domain_values VALUES('classAuditMode','MMDiscount','')
;
INSERT INTO domain_values VALUES('classAuditMode','MMInterest','')
;
INSERT INTO domain_values VALUES('classAuditMode','PositionCash','')
;
INSERT INTO domain_values VALUES('classAuditMode','UnitizedFund','')
;
INSERT INTO domain_values VALUES('classAuditMode','Warrant','')
;

/*BZ 59278*/
CREATE OR REPLACE PROCEDURE add_cds_addl
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
        EXECUTE IMMEDIATE 'CREATE TABLE cds_addl_provisions (product_id number not null, provision_name varchar2(128) not null , constraint PK_CDSADDL primary key (product_id, provision_name))';
    END IF;
END add_cds_addl;
;

BEGIN
add_cds_addl('cds_addl_provisions');
END;
;

drop PROCEDURE add_cds_addl
;
CREATE OR REPLACE PROCEDURE add_matrix_addl
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
        EXECUTE IMMEDIATE 'create table matrix_addl_provisions (matrix_id number not null, provision_name varchar2(128) not null , constraint PK_MATRIXADDL primary key (matrix_id))';
    END IF;
END add_matrix_addl;
;

BEGIN
add_matrix_addl('matrix_addl_provisions');
END;
;

drop PROCEDURE add_matrix_addl
;
 

begin
add_column_if_not_exists('product_cds','matrix_id','number');
end;
;

insert into cds_addl_provisions(product_id, provision_name)
select product_cds.product_id, matrix_addl_provisions.provision_name
from matrix_addl_provisions, product_cds
where product_cds.matrix_id=matrix_addl_provisions.matrix_id
;



update  /*+ PARALLEL ( product_cds)  */ product_cds set market_standard_b=1 where product_cds.matrix_id > 0
;
declare
x number :=0 ;
begin
	SELECT count(*) INTO x from user_tab_columns where table_name=upper('option_formula') and column_name=upper('formula_id');
	IF x=1 THEN
	EXECUTE IMMEDIATE 'create table option_formula_back10 as select * from option_formula';
	Execute Immediate 'update option_formula set product_id = (select product_id from product_eq_struct_option 
where payoff_formula_id=option_formula.formula_id)';
END IF;
end;
;


CREATE OR REPLACE PROCEDURE add_option_formula
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
        EXECUTE IMMEDIATE 'create table option_formula (product_id number not null, formula_type varchar2(32) not null, version number not null , is_call number null , 
	nparameter float null , sparameter varchar2(32) null, constraint PK_OPTION_FORMULA primary key (product_id))';
    END IF;
END add_option_formula;
;

BEGIN
add_option_formula('option_formula');
END;
;

drop PROCEDURE add_option_formula
;

UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'VANILLA' WHERE formula_type='VanillaFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'VANILLA_BASKET' WHERE formula_type='VanillaBasketPayoffFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'CASH_OR_NOTHING' WHERE formula_type='CashOrNothingFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'ASSET_OR_NOTHING' WHERE formula_type='AssetOrNothingFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'RAINBOW' WHERE formula_type='RainbowPayoffFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'CLIQUET' WHERE formula_type='CliquetPayoffFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'EXSP' WHERE formula_type='EXSPOptionFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'COMPOUND' WHERE formula_type='CompoundFormula'
;
UPDATE /*+ PARALLEL ( option_formula)  */ option_formula SET formula_type = 'CHOOSER' WHERE formula_type='ChooserFormula'
;



update rate_index set rate_index_id=(rownum + 1000)
;
DELETE FROM calypso_seed WHERE seed_name = 'RATE_INDEX'
;
create or replace procedure calypso_seed_proc
as
begin
declare max_id int ;
begin
select nvl(max(rate_index_id),0) into max_id from rate_index;
delete from calypso_seed where last_id=max_id and seed_name='RATE_INDEX' and seed_alloc_size=100;
insert into calypso_seed (last_id,seed_name,seed_alloc_size) values (max_id ,'RATE_INDEX',100);
end;
end;
;
begin
calypso_seed_proc;
end;
;
begin
drop_pk_if_exists('rate_index');
end;
;



CREATE OR REPLACE PROCEDURE add_task_priority
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
        EXECUTE IMMEDIATE 'create table task_priority_time ( task_priority_id  number not null ,  priority number not null, time  varchar2(64) not null, 
	holidays  varchar2(128) null, timezone varchar2(128) null , absolute_b number default 0 not null, dateroll varchar2(16) not null , check_holiday_b number null)';
    END IF;
END add_task_priority ;
;

BEGIN
add_task_priority('task_priority_time');
END;
;

drop PROCEDURE add_task_priority
;


update task_priority_time set task_priority_time_id=(rownum + 1000)
;
DELETE FROM calypso_seed WHERE seed_name = 'TaskPriorityTime'
;
create or replace procedure calypso_seed_proc
as
begin
declare max_id int;
begin
select nvl(max(task_priority_time_id),0) into max_id from task_priority_time;
insert into calypso_seed (last_id,seed_name,seed_alloc_size) values (max_id ,'TaskPriorityTime',100);
end;
end;
;
begin
calypso_seed_proc;
end;
;
begin
 drop_pk_if_exists('task_priority_time');
end;
;




UPDATE product_bond
SET rate_index_id = (SELECT rate_index_id FROM rate_index R
                     WHERE product_bond.rate_index =  (R.currency_code || '/' || R.rate_index_code || '/' || R.rate_index_tenor || '/' || R.rate_index_source)
					 )
;

UPDATE product_bond
SET notional_index_id = (SELECT rate_index_id FROM rate_index R
                      	 WHERE product_bond.notional_index =  (R.currency_code || '/' || R.rate_index_code || '/' || R.rate_index_tenor || '/' || R.rate_index_source)
					 	 )
;

insert into date_rule_in_seq (date_rule_id,seq_number,num,tenor_type,orig_date_rule,is_date) (
select date_rule_id, 
       rownum,
   	   substr (date_rules_in_seq, instr(date_rules_in_seq,  '-', 1, 1) + 1,  instr(date_rules_in_seq, '-', 1, 2) - instr(date_rules_in_seq,  '-', 1, 1) -1 ) num,
	   substr (date_rules_in_seq, instr(date_rules_in_seq,  '-', 1, 2) + 1) tenor_type,
	   substr (date_rules_in_seq, 0, instr(date_rules_in_seq,  '-', 1, 1) - 1) orig_date_rule,
	   0 is_date
       from (select date_rule_id,
                   substr (date_rules_in_seq,
                           instr (date_rules_in_seq, ',', 1, rr.r) + 1,
                             instr (date_rules_in_seq, ',', 1, rr.r + 1)
                           - instr (date_rules_in_seq, ',', 1, rr.r)
                           - 1
                          ) date_rules_in_seq
              from (select date_rule_id, ',' || date_rules_in_seq || ',' date_rules_in_seq,
                             length (date_rules_in_seq)
                           - length (replace (date_rules_in_seq, ',', ''))
                           + 1 cnt
                      from date_rule
                     where date_rules_in_seq is not null and date_rules_in_seq <> 'NONE') date_rule,
                   (select rownum r
                      from all_objects
                     where rownum <= 100) rr
             where rr.r <= date_rule.cnt order by rr.r)
     where date_rules_in_seq is not null and date_rules_in_seq <> 'NONE')
;

/* Correct is_date */
update date_rule_in_seq
set is_date = decode(tenor_type, '[Dates]', 1, 0)
;

/* Correct seq_number */
update date_rule_in_seq
set seq_number = (select seqs.rank
                 from (select date_rule_id, seq_number, rank() over (partition by date_rule_id order by seq_number) rank
                       from date_rule_in_seq) seqs
                 where seqs.date_rule_id = date_rule_in_seq.date_rule_id and seqs.seq_number = date_rule_in_seq.seq_number)
;

/* backup the date_rule table before we drop he column containing the old date_rules format */
create table date_rule_bak_r11 as select * from date_rule
;


/* BZ 59774 */
begin
 drop_pk_if_exists('acc_statement_cfg');
end;
;

delete from acc_limit_cfg where rowid not in (select max(rowid) from acc_limit_cfg group by ACCOUNT_ID, ACTIVE_FROM, ACTIVE_TO,MINIMUM,MAXIMUM)
;


update acc_limit_cfg set acc_limit_cfg_id=(rownum + 1000)
;
DELETE FROM calypso_seed WHERE seed_name = 'accountLimit'
;
create or replace procedure calypso_seed_proc
as
begin
declare max_id int ;
begin
select nvl(max(acc_limit_cfg_id),0) into max_id from acc_limit_cfg;
insert into calypso_seed (last_id,seed_name,seed_alloc_size) values (max_id ,'accountLimit',100);
end;
end;
;
begin
calypso_seed_proc;
end;
;


/*end*/

/* BZ 59375 */
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureFXRate' WHERE measure_id = 339 
;


CREATE OR REPLACE PROCEDURE add_product_struct
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
        EXECUTE IMMEDIATE 'create table product_structured_option_bc (id number  not null,
amount float default 0 not null ,asset_id number not null,basket_id number not null ,basis float null,
fixedfxrate float null,fxrate_fixed number default 0 not null, fxreset_id number null,fxtype varchar2(16) null , CONSTRAINT PK_PROD_STRU_OPT_BC primary key (id))';
END IF;
END add_product_struct;
;

BEGIN
add_product_struct('product_structured_option_bc');
END;
;

drop PROCEDURE add_product_struct
;



/* drop primary key and unique key for table */

UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureCumulativeCash' WHERE measure_name = 'CUMULATIVE_CASH'
;

/* BZ 59777 */
UPDATE /*+ PARALLEL ( product_bond)  */ product_bond
SET rate_index_id = (SELECT rate_index_id FROM rate_index R
                     WHERE product_bond.rate_index =  replace(substr(R.quote_name, instr(R.quote_name, '.', 1, 1) + 1), '.', '/')
					 )
;

UPDATE /*+ PARALLEL ( product_bond)  */  product_bond
SET notional_index_id = (SELECT rate_index_id FROM rate_index R
                      	 WHERE product_bond.notional_index =  replace(substr(R.quote_name, instr(R.quote_name, '.', 1, 1) + 1), '.', '/')
					 	 )
;


/* BZ 59781 */

/* BZ 59769 */


update recon_inven_row set recon_inven_row_id=(rownum + 1000)
;
DELETE FROM calypso_seed WHERE seed_name = 'BOInventoryReconciliation'
;
create or replace procedure calypso_seed_proc
as
begin
declare max_id int ;
begin
select nvl(max(recon_inven_row_id),0) into max_id from recon_inven_row;
insert into calypso_seed (last_id,seed_name,seed_alloc_size) values (max_id ,'BOInventoryReconciliation',100);
end;
end;
;
begin
calypso_seed_proc;
end;
;
begin
 drop_pk_if_exists('recon_inven_row');
end;
;

/* BZ 59837 */
/* Correct is_date */
update date_rule_in_seq
set is_date = decode(tenor_type, '[Dates]', 1, 0)
;

/* Correct seq_number */
update date_rule_in_seq
set seq_number = (select seqs.rank
                 from (select date_rule_id, seq_number, rank() over (partition by date_rule_id order by seq_number) rank
                       from date_rule_in_seq) seqs
                 where seqs.date_rule_id = date_rule_in_seq.date_rule_id and seqs.seq_number = date_rule_in_seq.seq_number)
;

/* BZ 56506 */

UPDATE referring_object SET rfg_tbl_join_cols = 'prd_sd_filter_name' WHERE rfg_obj_id = 11
;
/* BZ 59767 */
CREATE  OR REPLACE PROCEDURE sp_upd_balpos(

		arg_account_id          IN NUMBER,

        arg_currency_code       IN varchar,

        arg_date_type           IN varchar,

        arg_position_date       IN TIMESTAMP,

        arg_total_amount        IN FLOAT,

        arg_change              IN FLOAT,

        arg_security_id         IN NUMBER)

IS BEGIN

UPDATE balance_position

SET total_amount = arg_total_amount,

    change = arg_change

WHERE position_date = arg_position_date AND

        account_id = arg_account_id AND

        date_type= arg_date_type AND

        currency_code = arg_currency_code;

IF SQL%ROWCOUNT = 0 THEN

    INSERT INTO  balance_position(account_id ,date_type,position_date,

        currency_code,total_amount,change,security_id )

    VALUES(arg_account_id ,arg_date_type,arg_position_date,

        arg_currency_code,arg_total_amount,arg_change,arg_security_id);

END IF;

END ;
;
/* 60269 */


/* BZ 60050 */
UPDATE /*+ PARALLEL ( product_ps)  */ product_ps
SET primary_leg_id = (SELECT MAX(product_id) FROM perf_swap_leg WHERE perf_swap_id = product_ps.product_id AND leg_id = 1)
;
UPDATE /*+ PARALLEL ( product_ps)  */ product_ps
SET secondary_leg_id = (SELECT MAX(product_id) FROM perf_swap_leg WHERE perf_swap_id = product_ps.product_id AND leg_id = 2)
;
/* 59709 */

/* BZ 60723 */
 


UPDATE calypso_cache SET eviction = 'LRU' WHERE eviction = 'PerishableLRU'
;

/* BZ 59997 */

DELETE FROM DOMAIN_VALUES WHERE NAME = 'plMeasure' AND VALUE = 'Translation_PL'
;
DELETE FROM DOMAIN_VALUES WHERE NAME = 'plMeasure' AND VALUE = 'Translation_Risk'
;


/* BZ 60723 */

create table trigger_info_bak as select * from trigger_info
;


UPDATE trigger_info
SET trigger_index_id = (SELECT rate_index_id FROM rate_index R
                     WHERE trigger_info.trigger_index =  replace(substr(R.quote_name, instr(R.quote_name, '.', 1, 1) + 1), '.', '/')
					 )
WHERE trigger_index IS NOT NULL
;



/* BZ 61223 */ 


/* BZ 60723 */

CREATE TABLE product_fx_order_bak AS SELECT * FROM product_fx_order
;


UPDATE /*+ PARALLEL ( product_fx_order)  */ product_fx_order P
SET 	P.base_currency = substr(P.currency_pair, 1, instr(P.currency_pair, '/', 1, 1) - 1), 
		P.quote_currency = substr(P.currency_pair, instr(P.currency_pair, '/', 1, 1) + 1)								
WHERE P.currency_pair IS NOT NULL
;



/* BZ 60723 */

begin
 drop_pk_if_exists('fxorder_ex_entry');
end;
;


/* end */

 

begin
  add_column_if_not_exists('master_confirmation','type','varchar2(255)');
end;
;

update /*+ PARALLEL ( master_confirmation)  */  master_confirmation set type='ANY' where type is null
;

 

update basic_prod_keyword set basic_product_id=product_id
;
CREATE TABLE basic_prod_keyword_bak AS SELECT * FROM basic_prod_keyword
;
begin
 drop_pk_if_exists('basic_prod_keyword');
end;
;
DELETE FROM basic_prod_keyword  WHERE product_id is NULL AND sub_id is NULL
;


INSERT INTO basic_prod_keyword (basic_product_id, keyword_name, keyword_value, product_id, sub_id)
	(SELECT p.basic_product_id, k.keyword_name, k.keyword_value, p.product_id, p.sub_id 
	 FROM basic_product p INNER JOIN basic_prod_keyword_bak k ON p.basic_product_id = k.basic_product_id)
;

/* end */


/*BZ 62766 */ 

UPDATE observable SET rel_exch = substr(rel_exch,2, length(rel_exch) - 2)
;
/*end*/

/*BZ 63194 */

begin
drop_unique_if_exists('credit_event');
end;
;
 


update /*+ PARALLEL ( credit_event)  */ credit_event set PROTOCOL_TYPE='Calypso' where PROTOCOL_TYPE is null
;


/*end*/

/*BZ 62734 */
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name='tk.core.PricerMeasure' WHERE measure_class_name='tk.pricer.PricerMeasure'
;
/*end*/

/*BZ 63022*/

delete from pricer_measure where measure_name='UPFRONT_PCT' and measure_class_name='tk.core.PricerMeasure' and measure_id=386
;

INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('UPFRONT_PCT','tk.core.PricerMeasure',386)
;

delete from pricing_param_name where param_name='UPFRONT_PCT_FIX_CPN' and param_type='com.calypso.tk.core.Spread'
;

INSERT INTO pricing_param_name (param_name, param_type, param_domain, param_comment, is_global_b, default_value)
VALUES ('UPFRONT_PCT_FIX_CPN', 'com.calypso.tk.core.Spread', '', 'Fixed Coupon Spread for calculating Upfront Rate', 1, '500')
;

/*end*/

/* BZ 63654 */
UPDATE /*+ PARALLEL ( ADVICE_CONFIG)  */ ADVICE_CONFIG
  SET TEMPLATE_NAME=REPLACE(TEMPLATE_NAME, '_Submit', '')
  WHERE ADDRESS_METHOD='DTCC'
;

UPDATE  /*+ PARALLEL ( ADVICE_DOCUMENT)  */ ADVICE_DOCUMENT
  SET TEMPLATE_NAME=REPLACE(TEMPLATE_NAME, '_Submit', '')
  WHERE ADDRESS_METHOD='DTCC'
;
UPDATE DOMAIN_VALUES
  SET VALUE=REPLACE(VALUE, '_Submit', '')
  WHERE NAME='DTCC.Templates'
;

UPDATE /*+ PARALLEL ( BO_MESSAGE)  */ BO_MESSAGE
  SET TEMPLATE_NAME=REPLACE(TEMPLATE_NAME, '_Submit', '')
  WHERE ADDRESS_METHOD='DTCC'
;

UPDATE /*+ PARALLEL ( BO_MESSAGE_HIST)  */ BO_MESSAGE_HIST
  SET TEMPLATE_NAME=REPLACE(TEMPLATE_NAME, '_Submit', '')
  WHERE ADDRESS_METHOD='DTCC'
;

UPDATE /*+ PARALLEL ( ADVICE_DOC_HIST)  */ ADVICE_DOC_HIST
  SET TEMPLATE_NAME=REPLACE(TEMPLATE_NAME, '_Submit', '')
  WHERE ADDRESS_METHOD='DTCC'
;
/*end*/

UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure set measure_class_name = 'tk.pricer.PricerMeasureHistoBS' where measure_name = 'HISTO_BS' and measure_id = 374
;
/* BZ 63374 */
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_id = 316 WHERE measure_name = 'ACCRUAL_BS'
;
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_id = 313 WHERE measure_name = 'LIQUIDATION_EFFECT'
;
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_id = 309 WHERE measure_name = 'CUMULATIVE_CASH'
;
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_id = 311 WHERE measure_name = 'CUMULATIVE_CASH_INTEREST'
;
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_id = 312 WHERE measure_name = 'CUMULATIVE_CASH_FEES'
;
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_id = 315 WHERE measure_name = 'IMPLIED_IN_RANGE'
;

UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureHistoricalAccrualBO' WHERE measure_name = 'HISTO_ACCRUAL_BO'
;

UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledCash'
WHERE measure_name='HISTO_UNSETTLED_CASH'
;

UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureHistoricalCumulativeCash'
WHERE measure_name='HISTO_CUMUL_CASH_INTEREST'
;

/* BZ63843 */
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledCash' WHERE measure_name = 'HISTO_UNSETTLED_FEES'
;

UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledCash' WHERE measure_name = 'FEES_UNSETTLED'
;

DELETE domain_values WHERE name = 'plMeasure' AND value = 'Accrual_FX_Reeval'
;
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Cash_FX_Reeval'
;
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Clean_Realized_FX_Reeval'
;
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Paydown_FX_Reeval'
;
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Realized_Accrual_FX_Reeval'
;
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Realized_FX_Reeval'
;
DELETE domain_values WHERE name = 'plMeasure' AND value = 'Unrealized_FX_Reeval'
;
DELETE domain_values WHERE name = 'plMeasure' AND value = 'UnsettledCash_FX_Reeval'
;
/* end */

/* BZ:63397 */


update /*+ PARALLEL ( option_deliverable)  */ option_deliverable
set option_deliverable.eto_contract_id = option_deliverable.calc_offset where option_deliverable.deliverable_type = 'CONTRACT ADJUSTMENT' and exists (select 1 from eto_contract where eto_contract.contract_id =
option_deliverable.calc_offset)
;

update /*+ PARALLEL ( option_deliverable)  */ option_deliverable set calc_offset=0 where eto_contract_id is not null 
;
/* end */

/* BZ 64724 */

UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledFees' WHERE measure_name = 'HISTO_UNSETTLED_FEES'
;
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledFees' WHERE measure_name = 'FEES_UNSETTLED'
;
UPDATE /*+ PARALLEL ( pricer_measure)  */ pricer_measure SET measure_class_name = 'tk.pricer.PricerMeasureUnsettledFees' WHERE measure_name = 'FEES_UNSETTLED_SD'
;
/* end */


/* BZ 56618 Add sales_margin to the Cash products */
/* scripts to move the keywords into the product and fix audit etries */
/* for SimpleMM, Cash, CallNotice,  live and history tables */  

create or replace FUNCTION "UNLOCALIZE" ( str IN VARCHAR2 ) return varchar2
/* normalies number-like strings to have "." as decimal separator and no grouping.
effect on other strings may be desctructive
*/
deterministic as
last_sep_char_pos number := regexp_instr(str, '[,\.][^,\.]*$');
begin
if last_sep_char_pos = 0
then
return str;
else
declare sep_char char(1) := substr(str, last_sep_char_pos, 1);
begin
if sep_char = '.' THEN
/* it was a "us-like" string, verify this */
if regexp_instr(substr(str, 1, last_sep_char_pos-1), '^[0-9 ,]*$') = 0
or regexp_instr(substr(str, last_sep_char_pos+1), '^[0-9]*$') =0
then
return str;
end if;
/* remove leading "," grouping chars */
return replace(substr(str, 1, last_sep_char_pos-1), ',', '') || substr(str,last_sep_char_pos) ;
else
/* it was a "non-us" string, , verify this */
if regexp_instr(substr(str, 1, last_sep_char_pos-1), '^[0-9 .]*$') = 0
or regexp_instr(substr(str, last_sep_char_pos+1), '^[0-9]*$') = 0
then
return replace(str, ',', '.');
end if;
/* remove leading "." grouping chars */
return replace(substr(str, 1, last_sep_char_pos-1), '.', '') || '.' || substr(str,last_sep_char_pos+1);
end if;
end;
end if;
end;
;
create or replace FUNCTION "STRING_TO_SPREAD" ( str IN VARCHAR2 ) RETURN VARCHAR2 AS
/* parse a string ("US" locale) and convert to spread
 used e.g. to fill the sales_margin column in the product */ 
BEGIN
  RETURN to_number(unlocalize(str), '999999999999999.999999999999999')/10000.0;
END STRING_TO_SPREAD;
;
  
create or replace FUNCTION "NUMBER_TO_STRING" (num in number) RETURN VARCHAR2 AS
/* convert a number into a string. used when updating audit entries */
BEGIN
  RETURN trim(to_char(num, '999999999999999D999999999999999', 'NLS_NUMERIC_CHARACTERS = ''.,'''));
END NUMBER_TO_STRING;
;

begin
  declare x number :=0 ;
  begin 
  select count(*) into x from user_tables where table_name = 'TRADE_KEYWORD_BAK_BZ56618';
  if x = 0 then
    execute immediate 'create table TRADE_KEYWORD_BAK_BZ56618 as select * from trade_keyword where keyword_name = ''SalesMargin''';
  end if;
  end;
end;
;

begin
  declare x number :=0 ;
  begin 
  select count(*) into x from user_tables where table_name = 'TRADE_KEYWORD_HIST_BAK_BZ56618';
  if x = 0 then
    execute immediate 'create table TRADE_KEYWORD_HIST_BAK_BZ56618 as select * from trade_keyword_hist where keyword_name = ''SalesMargin''';
  end if;
  end;
end;
;

begin
  declare x number :=0 ;
  begin 
  select count(*) into x from user_tables where table_name = 'BO_AUDIT_BAK_BZ56618';
  if x = 0 then
    execute immediate 'create table BO_AUDIT_BAK_BZ56618 as select * from bo_audit where entity_class_name =''Trade'' 
      and entity_field_name in (''ADDKEY#SalesMargin'', ''DELKEY#SalesMargin'', ''MODKEY#SalesMargin'')';
  end if;
  end;
end;
;

begin
  declare x number :=0 ;
  begin 
  select count(*) into x from user_tables where table_name = 'BO_AUDIT_HIST_BAK_BZ56618';
  if x = 0 then
    execute immediate 'create table BO_AUDIT_HIST_BAK_BZ56618 as select * from bo_audit_hist where entity_class_name =''Trade'' 
      and entity_field_name in (''ADDKEY#SalesMargin'', ''DELKEY#SalesMargin'', ''MODKEY#SalesMargin'')';
  end if;
  end;
end;
;



create or replace PROCEDURE "MIGRATE_SIMPLEMM_SALES_MARGIN" AS
BEGIN
  DECLARE cursor c1 IS 
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_simple_mm, trade , trade_keyword
      WHERE trade.product_id = product_simple_mm.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin';
      
       cursor c2 IS 
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_cash, trade , trade_keyword
      WHERE trade.product_id = product_cash.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin';
      
       cursor c3 IS 
      SELECT trade.product_id as product_id, trade.trade_id as trade_id, keyword_value 
      FROM product_call_not, trade , trade_keyword
      WHERE trade.product_id = product_call_not.product_id
      AND   trade.trade_id = trade_keyword.trade_id 
      AND keyword_name = 'SalesMargin';
      
      cursor c1h IS 
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM prd_smp_mm_hist, trade_hist , trade_keyword_hist
      WHERE trade_hist.product_id = prd_smp_mm_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin';
      
       cursor c2h IS 
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM product_cash_hist, trade_hist , trade_keyword_hist
      WHERE trade_hist.product_id = product_cash_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin';
      
       cursor c3h IS 
      SELECT trade_hist.product_id as product_id, trade_hist.trade_id as trade_id, keyword_value 
      FROM product_call_not_hist, trade_hist , trade_keyword_hist
      WHERE trade_hist.product_id = product_call_not_hist.product_id
      AND   trade_hist.trade_id = trade_keyword_hist.trade_id 
      AND keyword_name = 'SalesMargin';
      
     nonlocalized_sales_margin varchar2(255);
     margin number;
  BEGIN
      /* live tables:  move current keyword value into product field */
      FOR c1_rec IN c1 LOOP
         margin := string_to_spread(c1_rec.keyword_value);  
         update product_simple_mm set sales_margin = margin where product_id = c1_rec.product_id;
         delete from trade_keyword where trade_id = c1_rec.trade_id and keyword_name = 'SalesMargin';
      END LOOP;
      
      FOR c2_rec IN c2 LOOP
         margin := string_to_spread(c2_rec.keyword_value);  
         update product_cash set sales_margin = margin where product_id = c2_rec.product_id;
         delete from trade_keyword where trade_id = c2_rec.trade_id and keyword_name = 'SalesMargin';
      END LOOP;
      
      FOR c3_rec IN c3 LOOP
         margin := string_to_spread(c3_rec.keyword_value);  
         update product_call_not set sales_margin = margin where product_id = c3_rec.product_id;
         delete from trade_keyword where trade_id = c3_rec.trade_id and keyword_name = 'SalesMargin';
      END LOOP;
      
      /* fix audit entries */
      update /*+ PARALLEL ( bo_audit)  */ bo_audit
      set entity_field_name = 'Product._salesMargin', 
          field_type = 'double',
      old_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then number_to_string(string_to_spread(old_value))
                       when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                  end,
      new_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then number_to_string(string_to_spread(new_value))
                       when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                  end
      where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade t, product_desc pd 
          where t.trade_id = bo_audit.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      );
      
      /* same for history tables */
      FOR c1h_rec IN c1h LOOP
         margin := string_to_spread(c1h_rec.keyword_value);  
         update prd_smp_mm_hist set sales_margin = margin where product_id = c1h_rec.product_id;
         delete from trade_keyword_hist where trade_id = c1h_rec.trade_id and keyword_name = 'SalesMargin';
      END LOOP;
      
      FOR c2h_rec IN c2h LOOP
         margin := string_to_spread(c2h_rec.keyword_value);  
         update product_cash_hist set sales_margin = margin where product_id = c2h_rec.product_id;
         delete from trade_keyword_hist where trade_id = c2h_rec.trade_id and keyword_name = 'SalesMargin';
      END LOOP;
      
      FOR c3h_rec IN c3h LOOP
         margin := string_to_spread(c3h_rec.keyword_value);  
         update product_call_not_hist set sales_margin = margin where product_id = c3h_rec.product_id;
         delete from trade_keyword_hist where trade_id = c3h_rec.trade_id and keyword_name = 'SalesMargin';
      END LOOP;
      
      /* fix audit entries */
      update bo_audit_hist
      set entity_field_name = 'Product._salesMargin', 
          field_type = 'double',
      old_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then number_to_string(string_to_spread(old_value))
                       when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                  end,
      new_value = case when entity_field_name = 'MODKEY#SalesMargin' or entity_field_name = 'DELKEY#SalesMargin' then number_to_string(string_to_spread(new_value))
                       when entity_field_name = 'ADDKEY#SalesMargin' then '0.0000'
                  end
      where entity_class_name ='Trade' 
      and entity_field_name in ('ADDKEY#SalesMargin', 'DELKEY#SalesMargin', 'MODKEY#SalesMargin')
      and exists (select 1 from trade_hist t, product_desc_hist pd 
          where t.trade_id = bo_audit_hist.entity_id
          and t.product_id = pd.product_id
          and pd.product_type in ('SimpleMM', 'Cash', 'DualCcyMM', 'CallNotice')
      );

   END;
END MIGRATE_SIMPLEMM_SALES_MARGIN;
;
begin
  MIGRATE_SIMPLEMM_SALES_MARGIN;
end;
;

/* BZ 56618 end */

/* BZ 58718 */

update /*+ PARALLEL ( trade_open_qty)  */  trade_open_qty 
set return_date = 
(select product_pledge.end_date from product_pledge, trade
where trade_open_qty.product_family='Repo' 
and trade_open_qty.product_type='Pledge' 
and trade_open_qty.return_date is null 
and product_pledge.end_date is not null 
and product_pledge.product_id = trade.product_id 
and trade.trade_id = trade_open_qty.trade_id)
where product_family='Repo' 
and product_type='Pledge' 
and return_date is null
;

/* end */ 
 
/* BZ 64937: Duplicate PLMeasure names for unsettled cash fx reval */ 

DELETE domain_values WHERE name='plMeasure' AND value='UnsettledCash_FX_Reval'
;

/* end */

/* BZ 63506 */

delete from domain_values where name = 'riskAnalysis'
and value in ('Benchmark', 'Comparison', 'DefaultAggregation', 'ExposureWeight', 'FIProfitability', 'HistoricalCrossAsset', 'MTM', 'NetAssetValue', 'PredictPL', 'PredictPLPre', 'WeightedPricing', 'FOPosition')
;

delete from an_viewer_config where analysis_name  in ('Benchmark', 'Comparison', 'DefaultAggregation', 'ExposureWeight', 'FIProfitability', 'HistoricalCrossAsset', 'MTM', 'NetAssetValue', 'PredictPL', 'PredictPLPre', 'WeightedPricing', 'FOPosition')
;


delete from domain_values where name = 'riskPresenter'
and value in ('Benchmark', 'WeightedPricing')
;

/* end */

/* BZ 65204 */
DELETE FROM DOMAIN_VALUES WHERE NAME = 'interpolator3D' AND VALUE = 'FXVolInterpolator'
;
/* end */

/* BZ 62911 */

CREATE OR REPLACE PROCEDURE add_ANALYSIS_OUTPUT_PERM
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
        EXECUTE IMMEDIATE 'CREATE TABLE ANALYSIS_OUTPUT_PERM (ID NUMBER  NOT NULL, CREATED_DATE TIMESTAMP (6), ANALYSIS_TYPE VARCHAR2(64),PARAM_CONFIG_NAME VARCHAR2(32), 	PAGES NUMBER  NOT NULL, COMPLETE NUMBER  NOT NULL  )';
        EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX PK_ANALYSIS_OUTPUT_P11 ON ANALYSIS_OUTPUT_PERM (ID )';
        EXECUTE IMMEDIATE 'ALTER TABLE ANALYSIS_OUTPUT_PERM ADD  CONSTRAINT PK_ANALYSIS_OUTPUT_P11 PRIMARY KEY (ID) USING INDEX';
    END IF;
END add_ANALYSIS_OUTPUT_PERM;
;

BEGIN
add_ANALYSIS_OUTPUT_PERM('ANALYSIS_OUTPUT_PERM');
END;
;

drop PROCEDURE add_ANALYSIS_OUTPUT_PERM
;

CREATE OR REPLACE PROCEDURE add_RISK_PRE_DEF_VIEW_CFG
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
        EXECUTE IMMEDIATE 'CREATE TABLE RISK_PRESENTER_DEF_VIEW_CFG (TEMPLATE_ID NUMBER NOT NULL,ANALYSIS_NAME VARCHAR2(64) NOT NULL ENABLE, PARAM_NAME VARCHAR2(32) NOT NULL, TEMPLATE_ID_DRILL_DOWN NUMBER)';
        EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX PK_RISK_PRESENTER_DE6 ON RISK_PRESENTER_DEF_VIEW_CFG (ANALYSIS_NAME , PARAM_NAME )';
        EXECUTE IMMEDIATE 'ALTER TABLE RISK_PRESENTER_DEF_VIEW_CFG ADD  CONSTRAINT PK_RISK_PRESENTER_DE6 PRIMARY KEY (ANALYSIS_NAME, PARAM_NAME)';
    END IF;
END add_RISK_PRE_DEF_VIEW_CFG;
;

BEGIN
add_RISK_PRE_DEF_VIEW_CFG('RISK_PRESENTER_DEF_VIEW_CFG');
END;
;

drop PROCEDURE add_RISK_PRE_DEF_VIEW_CFG
;
 
update /*+ PARALLEL ( an_service_set_elements)  */ an_service_set_elements set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( an_viewer_config)  */ an_viewer_config set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( analysis_output_perm)  */ analysis_output_perm set analysis_type='Simulation' where analysis_type='ScenarioSlide' 
;
update /*+ PARALLEL ( analysis_output)  */ analysis_output set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( analysis_output_hist)  */  analysis_output_hist set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( analysis_param)  */ analysis_param set class_name='com.calypso.tk.risk.SimulationParam'
where class_name='com.calypso.tk.risk.ScenarioSlideParam'
;
update /*+ PARALLEL ( an_param_item_mul)  */ an_param_item_mul set class_name='com.calypso.tk.risk.SimulationParam'
where class_name='com.calypso.tk.risk.ScenarioSlideParam'
;
update an_param_items set class_name='com.calypso.tk.risk.SimulationParam'
where class_name='com.calypso.tk.risk.ScenarioSlideParam'
;
update /*+ PARALLEL ( risk_config_item)  */ risk_config_item set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( risk_on_demand_item)  */ risk_on_demand_item set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( risk_presenter_item)  */ risk_presenter_item set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( risk_shortcuts)  */ risk_shortcuts set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( tws_risk_node)  */ tws_risk_node set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update /*+ PARALLEL ( risk_presenter_def_view_cfg)  */ risk_presenter_def_view_cfg set analysis_name='Simulation'
where analysis_name='ScenarioSlide'
;
update domain_values set value='Simulation'
where value='ScenarioSlide'
;

update /*+ PARALLEL ( an_service_set_elements)  */ an_service_set_elements set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( an_viewer_config)  */  an_viewer_config set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( analysis_output_perm)  */  analysis_output_perm set analysis_type='Sensitivity'
where analysis_type='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( analysis_output)  */ analysis_output set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( analysis_output_hist)  */ analysis_output_hist set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update  /*+ PARALLEL ( analysis_param)  */ analysis_param set class_name='com.calypso.tk.risk.SensitivityParam'
where class_name='com.calypso.tk.risk.ScenarioFORiskPositionParam'
;
update /*+ PARALLEL ( an_param_item_mul)  */ an_param_item_mul set class_name='com.calypso.tk.risk.SensitivityParam'
where class_name='com.calypso.tk.risk.ScenarioFORiskPositionParam'
;
update /*+ PARALLEL ( an_param_items)  */ an_param_items set class_name='com.calypso.tk.risk.SensitivityParam'
where class_name='com.calypso.tk.risk.ScenarioFORiskPositionParam'
;
update /*+ PARALLEL ( risk_config_item)  */ risk_config_item set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( risk_on_demand_item)  */  risk_on_demand_item set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( risk_presenter_item)  */  risk_presenter_item set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( risk_shortcuts)  */ risk_shortcuts set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( tws_risk_node)  */ tws_risk_node set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update /*+ PARALLEL ( risk_presenter_def_view_cfg)  */ risk_presenter_def_view_cfg set analysis_name='Sensitivity'
where analysis_name='ScenarioFORiskPosition'
;
update domain_values set value='Sensitivity'
where value='ScenarioFORiskPosition'
;
/* end */

/* BZ:65173 */
DELETE FROM PRICING_PARAM_NAME where param_name='INTG_MTHD_CR'
;
INSERT INTO pricing_param_name(param_name,param_type,param_domain,param_comment,is_global_b,display_name,default_value) VALUES('INTG_MTHD_CR','java.lang.String','ANALYTIC_JPM,LINEAR_SINGLE,SIMPSON,EXACT','Credit integration method, specifying the numerical method for summing credit event probability over the course of a cashflow period.',1,'INTG_MTHD_CR','LINEAR_SINGLE')
;
/* end */

/* BZ:64870 */


/* BZ 60536 */

delete from domain_values
where name = 'riskAnalysis'
and value in
('EquityOptGammaSlide',
 'EquityOptOpenPosBlotter',
 'EquityOptSpotSlide',
 'EquityOptTradeBlotter',
 'EquityOptTradeDrillDownBlotter',
 'EquityOptVegaSlide',
 'EquityOptVolatilitySlide',
 'Shift',
 'ScenarioHedge',
 'ScenarioSensitivity',
 'SensitivityHedge',
 'SimpleSensitivity',
 'VARHistoric',
 'VolatilityRisk',
 'XMLReport')
;

delete from an_viewer_config
where analysis_name in
('EquityOptGammaSlide',
 'EquityOptOpenPosBlotter',
 'EquityOptSpotSlide',
 'EquityOptTradeBlotter',
 'EquityOptTradeDrillDownBlotter',
 'EquityOptVegaSlide',
 'EquityOptVolatilitySlide',
 'Shift',
 'ScenarioHedge',
 'ScenarioSensitivity',
 'SensitivityHedge',
 'SimpleSensitivity',
 'VARHistoric',
 'VolatilityRisk',
 'XMLReport')
;

delete from domain_values
where name = 'ScenarioViewerClassNames'
and value in
('ScenarioInflationFixingReportViewer',
 'ScenarioSeasonalityRiskViewer')
;

/* end BZ 60536 */

/* BZ 65305 */

delete from domain_values
where name = 'riskAnalysis'
and value in
('BondHedge',
 'BucketHedge',
 'CommodityHedge',
 'Hedge',
 'ScenarioCommodity',
 'ScenarioRiskPosition',
 'ScenarioTaylorSeriesInput',
 'SyntheticHedge',
 'ValueAdded')
;

delete from domain_values
where name = 'riskPresenter'
and value in
('BondHedge',
 'BucketHedge',
 'CommodityHedge',
 'Hedge',
 'ScenarioCommodity',
 'ScenarioRiskPosition',
 'ScenarioTaylorSeriesInput',
 'SyntheticHedge',
 'ValueAdded')
;
/* end BZ 65305 */

/* BZ 64294 */

update /*+ PARALLEL ( trade)  */ trade t
set trade_currency = settle_currency
where exists (
      select 1 
      from product_pm_depo_lease p 
      where t.product_id = p.product_id
      and t.trade_currency <> t.settle_currency
)
;
/* end */
/* BZ:65474 */
 

create table dts_data_source_bak1 as select * from dts_data_source
;
begin 
drop_table_if_exists('dts_data_source');
end;
;
create table dts_field_mask_bak as select * from dts_field_mask
;
begin 
drop_table_if_exists('dts_field_mask');
end;
;
DECLARE
   x number;
   
 	BEGIN
 	 
	select count(*) into x from user_tables where table_name='DTS_REC_DATA_HIST';

	if x>0  then
	EXECUTE IMMEDIATE 'create table dts_rec_data_hist_bak1 as select * from dts_rec_data_hist';
	ELSE
	x:=0;				
	end if;
	END; 
;
 
begin 
drop_table_if_exists('dts_rec_data_hist');
end;
;
create table dts_field_type_bak as select * from dts_field_type
;
begin 
drop_table_if_exists('dts_field_type');
end;
;
/* create table dts_rec_hist_bak as select * from dts_rec_hist */
;
begin 
drop_table_if_exists('dts_rec_hist');
end;
;
/* create table dts_rec_msgs_hist_bak as select * from dts_rec_msgs_hist */
;
begin 
drop_table_if_exists('dts_rec_msgs_hist');
end;
;
/* create table dts_record_bak as select * from dts_record */
;
begin 
drop_table_if_exists('dts_record');
end;
;
create table dts_record_data_bak as select * from dts_record_data
;
begin 
drop_table_if_exists('dts_record_data');
end;
;
create table dts_record_msgs_bak as select * from dts_record_msgs
;
begin 
drop_table_if_exists('dts_record_msgs');
end;
;
/* BZ:58821  */
Update /*+ PARALLEL ( pricing_param_name)  */ pricing_param_name set default_value = null where param_name = 'HESTON_DRIFT'
;
Update /*+ PARALLEL ( pricing_param_name)  */ pricing_param_name set default_value = null where param_name = 'HESTON_MEAN_VAR'
;
Update /*+ PARALLEL ( pricing_param_name)  */ pricing_param_name set default_value = null where param_name = 'HESTON_VAR_REV_SPEED'
;
Update /*+ PARALLEL ( pricing_param_name)  */ pricing_param_name set default_value = null where param_name = 'HESTON_VOL_VOL'
;
Update /*+ PARALLEL ( pricing_param_name)  */ pricing_param_name set default_value = null where param_name = 'HESTON_CORR'
;
/* end */

/* BZ 65036 */
/* Tables created in calypso version 1010 and deleted in calypso version 1010
* These tables are not used anymore.
*/

begin 
drop_table_if_exists('tws_workspace_tf');
end;
;
begin 
drop_table_if_exists('tws_workspace_tf_crit');
end;
;
begin 
drop_table_if_exists('tws_workspace_an_param');
end;
;
begin 
drop_table_if_exists('tws_workspace_an_param_items');
end;
;

/* end BZ 65036 */


/* BZ:63396 */

update /*+ PARALLEL ( bo_audit)  */ bo_audit 
set old_value = to_char(version_num), 
entity_field_name = concat(concat(entity_field_name, '_'), + to_char(version_num)) 
where entity_class_name = 'LegalEntity' 
and entity_field_name like 'REMOVE_%' 
and old_value is null
;

update /*+ PARALLEL ( bo_audit)  */ bo_audit set version_num =  0
where bo_audit.entity_class_name = 'LegalEntity' 
and bo_audit.entity_field_name like 'REMOVE_%' 
and bo_audit.old_value = to_char(bo_audit.version_num)
and not exists 
(
select * from bo_audit ss 
where ss.entity_class_name =  bo_audit.entity_class_name 
and ss.entity_id = bo_audit.entity_id 
and ss.entity_field_name not like 'REMOVE_%' 
and ss.entity_field_name not like 'CREATE_%' 
and ss.entity_field_name not like 'MODIFY_%' 
and ss.modif_date <= bo_audit.modif_date
)
;

update /*+ PARALLEL ( bo_audit)  */ bo_audit set version_num = 
(
select max(ms.version_num) from bo_audit ms 
where ms.entity_class_name = bo_audit.entity_class_name 
and ms.entity_id = bo_audit.entity_id 
and ms.entity_field_name not like 'REMOVE_%'
and modif_date = 
(
select max(ss.modif_date) from bo_audit ss 
where ss.entity_class_name =  bo_audit.entity_class_name 
and ss.entity_id = bo_audit.entity_id 
and ss.entity_field_name not like 'REMOVE_%' 
and ss.entity_field_name not like 'CREATE_%' 
and ss.entity_field_name not like 'MODIFY_%' 
and ss.modif_date <= bo_audit.modif_date
)
) 
where bo_audit.entity_class_name = 'LegalEntity' 
and bo_audit.entity_field_name like 'REMOVE_%' 
and bo_audit.old_value = to_char(bo_audit.version_num)
;
/*end*/ 


/* BZ 64964, 64199 */
DELETE domain_values WHERE name = 'plMeasure'
;

/* BZ  65466 */ 
delete from domain_values where name = 'riskAnalysis' and value in ('CashFlow', 'CashFlowLadder','CashLiquidity','FXCashPosition', 'FwdLadderRisk','FXMatrix','FXPL','FXSensitivity')
;

delete from an_viewer_config where analysis_name  in ('CashFlow', 'CashFlowLadder', 'CashLiquidity')
;
/* end */ 


/* BZ  64746 */ 
 
create or replace procedure percent_alloc_rule2 as
   x number;
   y varchar2(32);
   z number; 
  plid number;
  elid number;

   CURSOR c1 IS
        SELECT distinct name from fx_trades_alloc ; 
 
 BEGIN
    	FOR I IN C1 LOOP
		select count(*) into z from percent_alloc_rule PAR where PAR.name=I.name;
		if z>0  then
					y:='FX_'||I.name;
					z:=0;
					else
					y:=I.name;
		end if;
				update calypso_seed set LAST_ID=LAST_ID+1 where SEED_NAME='AllocationRule';
		commit;
		select last_id into x from calypso_seed where SEED_NAME='AllocationRule';
		
		if (x is null) then
			select max(rule_id) into plid from percent_alloc_rule;
			select max(rule_id) into elid from percent_alloc_rule_element;
		
		if plid > elid then
			insert into calypso_seed values (plid+1,'AllocationRule',100);
			insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values (plid+1, y,'UpgradeScript',0);
			elsif elid > plid then
			insert into calypso_seed values (elid+1,'AllocationRule',100);
			insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values (elid+1, y,'UpgradeScript',0);
			elsif (elid IS NULL and plid  IS NULL ) then
			insert into calypso_seed values (1000,'AllocationRule',100);
			insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values (1000, y,'UpgradeScript',0);
			commit; 
		END IF;
		else
   		insert into percent_alloc_rule (rule_id, name, user_name, version_num)
		values (x,y,'UpgradeScript',0);
                end if;
 		commit;
    	END LOOP;
	EXCEPTION
        	when others then
                dbms_output.put_line('Error occured ' || sqlerrm); 
	END;
;

begin
percent_alloc_rule2 ;
end;
;


begin
  add_column_if_not_exists('fx_trades_alloc','BOOK_ID','int');
end;
;

create or replace procedure percent_alloc_rule3 as
   x number;
   y number;
   plid number;
   elid number;

   CURSOR c1 IS
  	select name,le_role,le_id,amount,book_id from fx_trades_alloc;
	BEGIN
    	FOR I IN C1 LOOP
				update calypso_seed set LAST_ID=LAST_ID+1 where SEED_NAME='AllocationRule';
				commit;
				select last_id into x from calypso_seed where SEED_NAME='AllocationRule';

                select max(rule_id) into y from percent_alloc_rule where name=I.name or name='FX_'||I.name;
		
		if (x is null) then
			select max(rule_id) into plid from percent_alloc_rule;
			select max(rule_id) into elid from percent_alloc_rule_element;
			
			if plid > elid then
				insert into calypso_seed values (plid+1,'AllocationRule',100);
				insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id,
				percent) values (plid+1, y, I.le_role, I.le_id, I.book_id, I.amount);
				insert into percent_alloc_rule ( rule_id,name,user_name,version_num) values (plid+1, y,'UpgradeScript',0);
			
			elsif elid > plid then
				insert into calypso_seed values (elid+1,'AllocationRule',100);
				insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id, 
				percent) values (elid+1, y, I.le_role, I.le_id, I.book_id, I.amount);

			elsif (elid IS NULL and plid  IS NULL ) then
				insert into calypso_seed values (1000,'AllocationRule',100);
				insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id, 
				percent) values (1000, y, I.le_role, I.le_id, I.book_id, I.amount);

			commit; 
			END IF;
		
		else

		insert into percent_alloc_rule_element (rule_element_id, rule_id, le_role, legal_entity_id, book_id, percent)
                values (x, y, I.le_role, I.le_id, I.book_id, I.amount);
                end if;
 		commit;
    	END LOOP;
	EXCEPTION     
        	when others then
                dbms_output.put_line('Error occured ' || sqlerrm); 
	END;
;


begin
percent_alloc_rule3 ;
end;
;

DELETE pricer_measure WHERE measure_name = 'HISTO_ACCRUAL'
;
		
/*  JIRA   66971 */
	delete from domain_values where name = 'riskPresenter' and value in ('Benchmark', 'Comparison', 'WeightedPricing')
	;
	
/*  CAL-67116*/

BEGIN
  DECLARE cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO cnt FROM pricer_measure WHERE measure_name = 'TRADING_DAYS' and measure_id=206;
  IF(cnt != 0) THEN
    DELETE FROM pricer_measure WHERE measure_name = 'TRADING_DAYS' and measure_id=206;
   END IF;
 END;
END;
;

/* Add the good one */
BEGIN
  DECLARE cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO cnt FROM pricer_measure WHERE measure_name = 'TRADING_DAYS';
  IF(cnt = 0) THEN
    INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('TRADING_DAYS','tk.core.PricerMeasure',206);
   END IF;
 END;
END;
;

/* CAL-67682 */

UPDATE bo_audit_fld_map  SET field_name='_bookId'  WHERE display_name='Book' and field_name='_book'
;
/* end */


begin
  add_column_if_not_exists('wfw_transition','gen_int_event_b','int');
end;
;

/* diff as of version 1.850.2.5 */

INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Simulation', 'apps.risk.SimulationViewer', 0 )
;
INSERT INTO an_viewer_config ( analysis_name, viewer_class_name, read_viewer_b ) VALUES ( 'Sensitivity', 'apps.risk.SensitivityViewer', 0 )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'CAMoneyDiff Book', 'To create simple transfer trade for CA money diff ' )
;
INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'DayChangeRule', 'For supporting FX day change market convnetion  ' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FXLinked.DoNotPropagateAction', 'This domain name is used in FXLinked workflow' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FXLinked.PropagateAction', 'This domain name is used in FXLinked workflow to indicate actions that need be carried over to the linked trade.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXLinked.PropagateAction', 'CANCEL', 'The CANCEL on the original FX trade will be carried over as CANCEL on the linked FX trade.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXLinked.PropagateAction', 'RATERESET', 'The RATERESET on the original FX trade will be carried over as RATERESET on the linked FX trade.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ForwardLadderProduct', 'FXNDFSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CMD_RESET_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CMD_FWD_CURVE_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CMD_FWD_CURVE_EFFECT_PAY_LEG', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CMD_FWD_CURVE_EFFECT_REC_LEG', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CMD_BASIS_EFFECT', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CMD_BASIS_EFFECT_PAY_LEG', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eco_pl_column', 'CMD_BASIS_EFFECT_REC_LEG', 'Column implemented by PLCalculator' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'HandleCashPooling', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ProductSelectorTypes.Repo', 'This domain contains available product types displayed in the TradeRepoWindow Product chooser' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ProductSelectorTypes.Repo', 'Bond', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ProductSelectorTypes.Repo', 'Equity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'ProductSelectorTypes.MarginCall', 'This domain contains available product types displayed in the MarginCall Product chooser' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ProductSelectorTypes.MarginCall', 'Bond', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ProductSelectorTypes.MarginCall', 'Equity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'riskIssuerAttributes', 'Issuer attributes to be included in sensitivy and simulation analyses' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'commodity.ForwardPriceMethods', 'NearbyNonDelivered', 'Price is taken from the first Forward Point date which is greater than the closest upcoming First Delivery Date' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BOPositionFilter', 'MarginCallIneligibleFilter', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'AccountTransferKeywords', 'Used to copy TradeKeyword from a CustomerTransfer IC Trade.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'sdiAttribute', 'PayOnly', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes', 'LegType', 'For an FXSwap or FXNDFSwap, "Near" or "Far"' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MsgAttributes.LegType', 'List of Leg Types for FXSwap and FXNDFSwap (Near, Far)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.LegType', 'Near', 'Message for near leg' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.LegType', 'Far', 'Message for far leg' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MsgAttributes.CashStatementProcess', 'List of Cash Statement Type' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes', 'CashStatementProcess', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'Statement', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'SubStatement.BankFee', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'SubStatement.CashPooling', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'SubStatement.CashPoolingPF', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'SubStatement.CashSweeping', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'SubStatement.Nostro', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'SubStatement.PivotPoolingPF', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.CashStatementProcess', 'Unknown', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'keyword.CashStatementProcess', 'List of Cash Statement Linked Trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Automatic CashPooling', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Automatic CashPooling PF', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'PivotPooling PF', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Manual CashPooling', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Manual CashPooling PF', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Automatic BankFee', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'Automatic CashSweeping', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'AutoFXConsolidation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.CashStatementProcess', 'AutoZeroDebitBalance', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CashStatement.AgentRegExp.BARCGB22', 'Regexp for BARC' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CashStatement.AgentRegExp.BARCGB22', 'First', '[0-9a-zA-Z -?/:().,''+]*ACCOUNT +([0-9]+)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes', 'ConfType', 'For an FXNDF or FXNDFSwap, "Opening" or "Fixing"' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MsgAttributes.ConfType', 'List of Confirmation Types for FXNDF and FXNDFSwap (Opening, Fixing)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.ConfType', 'Opening', 'Opening Confirmation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes.ConfType', 'Fixing', 'Fixing Confirmation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeTmplKeywords', 'DisplayOptionStyle', 'use for FXOption' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'DEFAULT_BOOK', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'DEFAULT_CPTY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'OptionF_PartyId', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'OptionF_DateOfBirth', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'OptionF_PlaceOfBirth', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'OptionF_CustomerId', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'leAttributeType', 'OptionF_NationalId', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'cdsSettlementConditions', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsSettlementConditions', 'Section 3.9 of the Definitions shall be excluded', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'cdsSettlementConditions', 'Section 3.3 will be amended by replacing "GMT" with "Tokyo time"', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineParam', 'SAVE_SETTLE_POSITION_CHANGES', 'Audit the updates to the settle positions. Position Snapshots rely on the history information captured.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'HedgeRelationship', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuthMode', 'HedgeStrategy', '' )
;
delete from domain_values where name='function' and value='CreateSystemPLMark'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateSystemPLMark', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'StatementType', 'Incoming', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineEventPoolPolicyAliases', 'Inventory', 'tk.util.TransferInventorySequencePolicy' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineEventPoolPolicyAliases', 'Liquidation', 'tk.util.TradeLiquidationSequencePolicy' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineEventPoolPolicies', 'tk.util.TransferInventorySequencePolicy', 'Sequence Policy for the InventoryEngine (optional)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineEventPoolPolicies', 'tk.util.TradeLiquidatoinSequencePolicy', 'Sequence Policy for the LiquidatiinEngine (optional)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'HedgeRelationship', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'HedgeStrategy', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'markAdjustmentReasonPosition', 'Other', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'DividendSwap.Pricer', 'Pricer dividendSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'SkewSwap.Pricer', 'Pricer skewSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FXNDFSwap.Pricer', 'Pricers for FX NDF swaps' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CorrelationSurface.gen', 'BaseCorrelationLPM', 'Base Correlation Surface generator using the Large Homogeneous Pool Model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'correlationType', 'EquityBasket', 'Allow input of Equity/EquityIndex/FX correlation matrix' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'fxRateResetAction', 'Trade Actions available on the FX Rate Reset Window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'fxRateResetAction', 'RATERESET', 'Rate reset action on the FX Rate Reset Window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'SpeedButton.Types', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SpeedButton.Types', 'Risk', 'Risk Analysis Speed Buttons' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SpeedButton.Types', 'Trade', 'Trade Entry Speed Buttons' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'FASAccountingMethod', 'FASAccountingMethod' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'hedgeStrategyAttributes', 'hedgeStrategyAttributes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'hedgeStrategyStandard', 'hedgeStrategyStandard' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'relativeDifferenceMethodCriticalValue', 'relativeDifferenceMethodCriticalValue' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASAccountingMethod', 'Change In Variable Cashflows', 'Change In Variable Cashflows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASAccountingMethod', 'Change In Fair Value', 'Change In Fair Value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASAccountingMethod', 'Hypothetical Derivative', 'Hypothetical Derivative' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASAccountingMethod', 'ShortCut', 'ShortCut' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASAccountingMethod', 'Matched Terms', 'Matched Terms' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyStandard', 'FAS', 'FAS' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyStandard', 'IAS', 'IAS' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyAttributes', 'De-designation Fee', 'De-designation Fee' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hedgeStrategyAttributes', 'Check List Template', 'Check List Template' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASEffMethodPro', 'Matched Terms', 'Matched Terms' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASEffMethodPro', 'ShortCut', 'ShortCut' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASEffMethodRetro', 'Matched Terms', 'Matched Terms' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FASEffMethodRetro', 'ShortCut', 'ShortCut' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'relativeDifferenceMethodCriticalValue', '0.03', 'Relative Difference Method' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'MarginCallConfig', 'MarginCall Config Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'MarginCallPosition', 'MarginCall Position Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'DividendSwap.subtype', 'DividendSwap subtypes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'SkewSwap.subtype', 'SkewSwap subtypes' )
;
delete from domain_values where name= 'SingleSwapLeg.Pricer' and value= 'PricerSingleSwapLegExotic'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SingleSwapLeg.Pricer', 'PricerSingleSwapLegExotic', 'Demo pricer for Single Swap Leg for a class of exsp based legs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'CFDCountryGrid', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'CFDContractDefinition', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'UserWorkflowConfig', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PositionBasedProducts', 'FXNDFSwap', 'FXNDFSwap out of box position based product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'securityCode.ReprocessTrades', 'Security codes requiring to check for trades to be reprocessed when code value changes' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'XferAttributes', 'ExpectedStatus', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'XferAttributes', 'PreciousMetal-location', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'XferAttributes', 'PreciousMetal-allocation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'XferMatchingAttributes', 'Xfer attributes to force full matching' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'keyword.TerminationReason', 'List of termination reason' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'TerminationAssignee', 'list of assignee' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'TerminationAssignor', 'list of assignor' )
;
delete from domain_values where name='keyword.TerminationReason' and value= 'Assigned'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.TerminationReason', 'Assigned', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.TerminationReason', 'BookTransfer', '' )
;
delete from domain_values where name='keyword.TerminationReason' and value= 'Manual'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.TerminationReason', 'Manual', '' )
;
delete from domain_values where name= 'keyword.TerminationReason' and value= 'BoughtBack'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.TerminationReason', 'BoughtBack', '' )
;
delete from domain_values where name='keyword.TerminationReason' and value= 'NotionalIncrease'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.TerminationReason', 'NotionalIncrease', '' )
;
delete from domain_values where name= 'keyword.TerminationReason' and value= 'ContractRevision'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.TerminationReason', 'ContractRevision', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'RolledOverToIncrease', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'RolledOverFromIncrease', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'TerminationFullFirstCalculationPeriod', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'keyword.TerminationReason', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'Hedge', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'IC Trade', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'IC Transaction', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volatilityType', 'Basket', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT940', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT950', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'RolledOverToIncrease', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'RolledOverFromIncrease', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Instruction Code', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'CrossChecked', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'CashStatementProcess', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'FXConsolidation-LinkedTo', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'FXConsolidation-LinkedTo', 'Id of the Cross Consolidation Trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'TradeSource', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'TargetAccountId', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FX.keywords', 'PreciousMetal-location', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXSwap.keywords', 'PreciousMetal-location', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXForward.keywords', 'PreciousMetal-location', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXForward.keywords', 'PreciousMetal-allocation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXSwap.keywords', 'PreciousMetal-allocation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FX.keywords', 'PreciousMetal-allocation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FX.keywords', 'PreciousMetal-deliveryDetails', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXForward.keywords', 'PreciousMetal-deliveryDetails', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXSwap.keywords', 'PreciousMetal-deliveryDetails', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MT101.MAX', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MT101.MIN', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'InventoryPositions', 'List of Positions in the Inv. Engine' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXSwap.keywords', 'PVMultiplier', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXForward.keywords', 'PVMultiplier', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXSpotReserve.keywords', 'PVMultiplier', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXTTM.keywords', 'PVMultiplier', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXNDF.keywords', 'PVMultiplier', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOptionForward.keywords', 'PVMultiplier', '' )
;

delete from domain_values where name='scheduledTask' and value='EOD_SYSTEM_PLMARKING'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'EOD_SYSTEM_PLMARKING', 'End of day system PL Marking.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageType', 'SWIFT_TRADE_RECON', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'SubsidiaryICStatement.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'SubsidiaryICInterestAdvice.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FXForward Default Tenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FXNDF Default Tenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FXSwap Default Near Tenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FXSwap Default Far Tenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FXNDFSwap Default Near Tenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAttributes', 'FXNDFSwap Default Far Tenor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'CLIQUET', 'CLIQUET option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'COMPOUND', 'COMPOUND option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.subtype', 'CHOOSER', 'CHOOSER option Product subtype' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'DividendSwap', 'DividendSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'SkewSwap', 'SkewSwap' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'PreciousMetal-location', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'PreciousMetal-allocation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.PreciousMetal-allocation', 'allocated', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.PreciousMetal-allocation', 'unallocated', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'PreciousMetal-deliveryDetails', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.PreciousMetal-deliveryDetails', 'CIF', '' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'domainName', 'transferCanceledStatus' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DispatcherParamsDatasynapse', 'dontUseLocalCache', 'boolean' )
;
delete from domain_values where name= 'keyword.TerminationReason' and value= 'Novation'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'keyword.TerminationReason', 'Novation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'RefEntityObligations', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAccessPermAttributes', 'Max.Account', 'Type to be enforced by reports' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'userAccessPermAttributes', 'Max.PLMark', 'Type to be enforced by reports' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'CheckHedgeRelationship', '' )
;
delete from domain_values where name= 'workflowRuleTrade' and value= 'Reject'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'Reject', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTrade', 'SetKeywords', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'UpdateTrade', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'UpdateMessage', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'SetAttributes', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeRejectAction', 'REJECT', 'to rebuild Previous trade version' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageAction', 'AUTOMATCH', 'AutoMatch' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageAction', 'MANUALMATCH', 'ManualMatch' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ScenarioViewerClassNames', 'apps.risk.ScenarioVolSurfUnderlyingViewer', 'A viewer for perturbations on vol surface underlyings' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'COT_RES_NEAR_LEG', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accEventType', 'COT_RES_FAR_LEG', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty', 'PaymentFactory', 'Boolean representing if account is a PaymentFactory' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty', 'PayInterestOnly', 'False to receive interest' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty', 'DTCPartAccountID', 'DTC Participant Number' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'accountProperty.PayInterestOnly', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty.PayInterestOnly', 'False', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'accountProperty.PayInterestOnly', 'True', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FeeBillingRuleAttributes', 'DefaultTransferType', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FeeBillingRuleAttributes', 'DefaultBundleID', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FeeBillingRuleAttributes', 'DefaultKWDAgent', '' )
;
delete from domain_values where name='CurveProbability.gen' and value= 'ProbabilityIndex'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CurveProbability.gen', 'ProbabilityIndex', 'Probability curve generator for CDSIndex' )
;
delete from domain_values where name= 'Swap.Pricer' and value='PricerExoticSwap'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swap.Pricer', 'PricerExoticSwap', '' )
;
delete from domain_values where name ='Bond.Pricer' and value= 'PricerBondExotic'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Bond.Pricer', 'PricerBondExotic', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXNDFSwap.Pricer', 'PricerFXNDFSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PLPositionProduct.Pricer', 'PricerPLPositionProductBond', 'PLPositionProduct Pricer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PLPositionProduct.Pricer', 'PricerPLPositionProductUnitizedFund', 'PLPositionProduct Pricer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionAccrual', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionVanillaHeston', 'Heston model valuation of vanilla options' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionBarrierHestonMC', 'Heston model valuation of barrier options using Monte Carlo' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.Pricer', 'PricerFXOptionBarrierHestonFD', 'Heston model valuation of barrier options using Finite Differences' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FXOption.subtype', 'ACCRUAL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventClass', 'PSEventProcessMessage', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'EX_SWIFT_BIC_IMPORT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eventType', 'EX_HEDGE_RELATIONSHIP', 'Exception Generated when a trade in hedge strategy is modified' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'HOLIDAYS_CHANGES', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'flowType', 'FORECAST', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'flowType', 'BANKFEE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'flowType', 'CASHPOOLING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateRiskPresenterDefaultViewConfig', 'Access permission to create RiskPresenterDefaultViewConfig' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveRiskPresenterDefaultViewConfig', 'Access permission to remove RiskPresenterDefaultViewConfig' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddVisokioTemplate', 'Access permission to add a Visokio Template' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveVisokioTemplate', 'Access permission to remove a Visokio Template' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'SWIFT_BIC_IMPORT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'exceptionType', 'HEDGE_RELATIONSHIP', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'flowType', 'MT950_ADJUSTMENT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateCallAccount', 'Access permission to Create Call Accounts' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyCallAccount', 'Access permission to Modify Call Accounts' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyPresentationServerConfig', 'Access permission to create/modify/delete PresentationServer Configuration.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreatePresentationServerConfig', 'Function to authorize to create/modify PresentationServer config' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemovePresentationServerConfig', 'Function to authorize to remove PresentationServer config' )
;
delete from domain_values where name='function' and value='UnlockMarks'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'UnlockMarks', 'Unlock P{&}L Marks' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateHedgeRelationship', 'Access permission to create Hedge Relationship' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ModifyHedgeRelationship', 'Access permission to modify Hedge Relationship' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveHedgeRelationship', 'Access permission to remove Hedge Relationship' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'MarginCallUncheckedPositions', 'Access permission to enable or disable the position check when doing margin call' )
;
delete from domain_values where name='marketDataUsage' and value='ISDA_DIS'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'marketDataUsage', 'ISDA_DIS', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productType', 'FXNDFSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'ForwardLadder', 'Cross Asset Forward Ladder Cash Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'OptionLifecycle', 'OptionLifecycle Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'Simulation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'Sensitivity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SWIFT.Templates', 'MT101', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'ADD_BROKERAGE_FEE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'INC_CASH_STATEMENT', '' )
;
delete from domain_values where name= 'scheduledTask' and value= 'PROCESS_EXPIRY'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'PROCESS_EXPIRY', 'Process Trades for expiry' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'ACCOUNT_CONSOLIDATION', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'CREATE_POSITION_SNAPSHOT', 'Creates positions snapshots for the defined snapshot date and time' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'TerminationFullFirstCalculationPeriod', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'CASource', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'CAClosing', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Hedge', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SWIFT.Templates', 'MT300CLSNonMemberPO', 'Foreign Exchange Confirmation for non-member Processing Organizations' )
;
delete from domain_values where name='SWIFT.Templates' and value= 'MT304'
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SWIFT.Templates', 'MT304', 'Advice/Instruction of a Third Party Deal' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SWIFT.Templates', 'MT304CLSNonMemberPO', 'Advice/Instruction of a Third Party Deal for non-member Processing Organizations' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SWIFT.Templates', 'MT600', 'Precious Metal Confirmation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'fxndfconfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'fxndfswapconfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'fxndffixingconfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'fxndfswapfixingconfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'DividendSwapConfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MESSAGE.Templates', 'SkewSwapConfirmation.html', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-ACTUAL-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-ACTUAL-TRADE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-FAILED-TRADE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-FAILED-AVAILABLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-FAILED-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-ACTUAL-AVAILABLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-ACTUAL-VALUE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-THEORETICAL-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'CLIENT-THEORETICAL-TRADE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-ACTUAL-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-ACTUAL-TRADE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-ACTUAL-VALUE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-FAILED-TRADE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-FAILED-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-THEORETICAL-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-THEORETICAL-TRADE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-FORECAST-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'InventoryPositions', 'INTERNAL-EXPECTED-SETTLE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'applicationName', 'PresentationServer', 'PresentationServer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'Simulation', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'Sensitivity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'Comparison', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'ForwardLadder', 'Cross Asset Forward Ladder Cash Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'OptionLifecycle', 'OptionLifecycle Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskOnDemandIncremental', 'ForwardLadder', 'Cross Asset Forward Ladder Cash Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureOptionContractAttributes', 'PremiumPaymentConvention', 'convention for the premium payment' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureOptionContractAttributes.PremiumPaymentConvention', 'Conventional', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'FutureOptionContractAttributes.PremiumPaymentConvention', 'VariationMargined', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CustomBOTradeFrameTab', 'Custom BOTrade Frame Tab Names' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'FutureMM', 'FutureMM ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'FXOrder', 'ADR ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'FXNDF', 'FXNDF ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'DividendSwap', 'DividendSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'EquityStructuredOption', 'EquityStructured Option ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'productTypeReportStyle', 'SkewSwap', 'SkewSwap ReportStyle' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'ThirdWednesday', 'Third Wednesday' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency.ThirdWednesday', 'Fixing Date Policy for Payment Frequency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.ThirdWednesday', 'THIRD_WEDNESDAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'groupStaticDataFilter', 'Names for groups of static data filters' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'ANY', 'group for StaticDataFilters which should be available in any window' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'Accounting', 'group for StaticDataFilters which should be available in Accounting-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'B2B', 'group for StaticDataFilters which should be available in B2B-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'BrokerFee', 'group for StaticDataFilters which should be available in BrokerFee-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'CA', 'group for StaticDataFilters which should be available in CA-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'FeeBillingRule', 'group for StaticDataFilters which should be available in FeeBillingRule-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'FeeGrid', 'group for StaticDataFilters which should be available in FeeGrid-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'FundingRate', 'group for StaticDataFilters which should be available in FundingRate-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'FUND_AM', 'group for StaticDataFilters which should be available in Fund-related windows (CashForwardConfig)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'FXBlotter', 'group for StaticDataFilters which should be available in FXBlotter' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'HairCut', 'group for StaticDataFilters which should be available in HairCut-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'KickoffCutoff', 'group for StaticDataFilters which should be available in KickoffCuttoff windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'LeContact', 'group for StaticDataFilters which should be available in LEContact-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'MappingStatus', 'group for StaticDataFilters which should be available in MappingStatus-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'MasterConfirmation', 'group for StaticDataFilters which should be available in MasterConfirmation-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'MarginCall', 'group for StaticDataFilters which should be available in MarginCall-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'MessageSetup', 'group for StaticDataFilters which should be available in Message-Setup-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'PairOff', 'group for StaticDataFilters which should be available in PairOff-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'PortfolioManager', 'group for StaticDataFilters which should be available in PortfolioManager-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'PositionKeeper', 'group for StaticDataFilters which should be available in PositionKeeper-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'Product', 'group for StaticDataFilters which should be available in Product-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'Reporting', 'group for StaticDataFilters which should be available in Reporting-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'SDI', 'group for StaticDataFilters which should be available in Settlement-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'SenderConfig', 'group for StaticDataFilters which should be available in SenderConfig-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'TaskInternalRefConfig', 'group for StaticDataFilters which should be available in Task Internal Reference configuration-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'TaskPriorityConfig', 'group for StaticDataFilters which should be available in Task Priority configuration-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'TaskStation', 'group for StaticDataFilters which should be available in Task Station configuration-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'TaskStationColor', 'group for StaticDataFilters which should be available in Task Station Color configuration-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'TaskStationDefault', 'group for StaticDataFilters which should be available in Task Station Default configuration-related windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'TWS', 'group for StaticDataFilters which should be available in TraderWorkStation windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'XferReport', 'group for StaticDataFilters which should be available in Transfer Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'WF', 'group for StaticDataFilters which should be available in WF Windows' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'WF_Message', 'group for StaticDataFilters which should be available in WF Windows for Message workflow' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'WF_Trade', 'group for StaticDataFilters which should be available in WF Windows for Trade workflow' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'groupStaticDataFilter', 'WF_Transfer', 'group for StaticDataFilters which should be available in WF Windows for Transfer workflow' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'bulkEntry.productType', 'trade bulk upload supported product types' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'bulkEntry.productType', 'EquityLinkedSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'BONYComparisonThresholdAmount', 'Threshold for BONY' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BONYComparisonThresholdAmount', '10', 'Threshold amount for BONY' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'bulkEntry.productType', 'VarianceSwap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'BulkEntry', 'Trade bulk upload from a CSV file' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'scheduledTask', 'TRADE_BULK_ENTRY', 'Trade bulk upload from a CSV file' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'eligibleToDividend', 'OTC Product Types - without position - eligible to dividends' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'eligibleToDividend', 'EquityLinkedSwap', 'EquityLinkedSwapCorporateActionHandler is responsible of performinf CA dividend releated tasks' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AddDivivdend', 'Allow User to add Dividend to Equity DividendSchedule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveDivivdend', 'Allow User to remove Dividend from Equity DividendSchedule' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'TerminationQuoteFixing', 'For Equity/Rate Swap, store the Termination fixing value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'TerminationFXRateFixing', 'For Equity/Rate Swap, store the Termination fx rate value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'TerminationQuoteFixing', 'For Equity/Rate Swap, store the Termination fixing value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'TerminationFXRateFixing', 'For Equity/Rate Swap, store the Termination fx rate value' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'hyperSurfaceGenerators', 'Heston', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerExoticEquityStructuredOption', 'Default dummy Pricer for exotic OTC structured option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlackNFJuAnalyticVanilla', 'analytic Pricer for Equity basket option - using Ju 2002 basket approximation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlackNFMonteCarlo', 'MonteCarlo Pricer for Equity basket option, vanilla and performance payoffs' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticBarrier', 'analytic Pricer for single asset option with barriers' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FAnalyticDigital', 'analytic Pricer for single asset digital option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FSemiAnalyticChooser', 'analytic Pricer for chooser option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FSemiAnalyticCompound', 'analytic Pricer for compound option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'EquityStructuredOption.Pricer', 'PricerBlack1FMonteCarlo', 'MonteCarlo Pricer for single asset asian or lookback option' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'PVMultiplier', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'PVMultiplier', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'QuantoSource', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'taskStationDates', 'Date Types that are supporter by TaskStation config' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskStationDates', 'START', 'Start date of the config' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskStationDates', 'END', 'End date of the config' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskStationDates', 'TODAY', 'System Date' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskStationDates', 'START(1)', 'Start date + 1 bus day' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskStationDates', 'END(-1)', 'End date -1 bus day' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'taskStationDates', 'TODAY(1)', 'Today +1 bus day' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Accrual_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Accrual_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Accrual_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'BS_FX_Reval', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Cash_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Cash_FX_Reval', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Cash_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Cash_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Full_Base_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Accrual_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Cash_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Full_Base_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Realized_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Intraday_Translation_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Paydown_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Paydown_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Paydown_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Realized_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Realized_Interests_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Realized_Interests_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Realized_Interests_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Realized_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Realized_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Sale_Realized_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Sale_Realized_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Sale_Realized_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Total_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Total_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Translation_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Cash_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Cash_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Cash_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Fees_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Fees_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Fees_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Interests', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Interests_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Interests_Full', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Net_Full_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Net_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_Net_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_PnL', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unrealized_PnL_Base', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'plMeasure', 'Unsettled_Cash_FX_Reval', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'DoNotAllowNettingGroupChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'DoNotAllowNettingMethodChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'DoNotAllowSDIChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'DoNotAllowBeneficiaryChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'DoNotCheckCorporateActions', 'This function will disallow the user to check corporate actions when a bond is changed from the Bond window.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'NettingManagerApply', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'NettingManagerApplyToTrade', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'restriction', 'DoNotAllowNettingGroupChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'restriction', 'DoNotAllowNettingMethodChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'restriction', 'DoNotAllowSDIChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'restriction', 'DoNotAllowBeneficiaryChange', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'restriction', 'DoNotCheckCorporateActions', 'This restriction will disallow the user to check corporate actions when a bond is changed from the Bond window.' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AllowSplitWithoutSDI', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'XferTypeActual', 'Xfer types that update only Actual Position' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'XferTypeActual', 'MT950_ADJUSTMENT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'PropagateTradeKeyword', 'Trade Keyword to be copied to Transfer' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PropagateTradeKeyword', 'Instruction Code', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTransfer', 'PropagateTradeKeyword', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleTransfer', 'CheckCancel', '' )
;
delete from domain_values where name='domainName' and value='CreditDefaultSwapCoupon.SNAC'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CreditDefaultSwapCoupon.SNAC', '' )
;

delete from domain_values where name= 'CreditDefaultSwapCoupon.SNAC' and value='100'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'CreditDefaultSwapCoupon.SNAC', '100', '' )
;
delete from domain_values where name= 'CreditDefaultSwapCoupon.SNAC' and value='500'
;

INSERT INTO domain_values ( name, value, description ) VALUES ( 'CreditDefaultSwapCoupon.SNAC', '500', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'DayChangeRule', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DayChangeRule', 'TimeZone', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'DayChangeRule', 'FX', '' )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_RESET_EFFECT', 'Impact of Commodity Fixings', 83, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_FWD_CURVE_EFFECT', 'Impact of the Commodity Forward Curve', 84, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_FWD_CURVE_EFFECT_PAY_LEG', 'Impact of the Commodity Forward Curve For the Pay Leg', 85, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_FWD_CURVE_EFFECT_REC_LEG', 'Impact of the Commodity Forward Curve For the Receive Leg', 86, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_BASIS_EFFECT', 'Impact of the Commodity Spread Quotes', 87, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_BASIS_EFFECT_PAY_LEG', 'Impact of the Commodity Spread Quotes For the Pay Leg', 88, 'NPV', 0 )
;
INSERT INTO eco_pl_col_name ( col_name, description, col_id, measure, excl_calc_b ) VALUES ( 'CMD_BASIS_EFFECT_REC_LEG', 'Impact of the Commodity Spread Quotes For the Receive Leg', 89, 'NPV', 0 )
;
delete from group_access where group_name='admin' and access_id=1 and access_value='UnlockMarks' and read_only_b=0
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'UnlockMarks', 0 )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CLIQUET', 'PricerBlack1FMonteCarlo' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.COMPOUND', 'PricerBlack1FSemiAnalyticCompound' )
;
INSERT INTO pc_pricer ( pricer_config_name, product_type, product_pricer ) VALUES ( 'default', 'EquityStructuredOption.ANY.CHOOSER', 'PricerBlack1FSemiAnalyticChooser' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'TV', 'tk.core.PricerMeasure', 380, 'Theoretical Price' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'VANNA_VOLGA_ADJ', 'tk.core.PricerMeasure', 381, 'Vanna Volga Adjustment' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUR_NOTIONAL_PAY', 'tk.core.PricerMeasure', 353 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CUR_NOTIONAL_REC', 'tk.core.PricerMeasure', 354 )
;

delete from pricer_measure where measure_name='CASH_BASE' and  measure_class_name='tk.pricer.PricerMeasureCashBase' and measure_id=361
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CASH_BASE', 'tk.pricer.PricerMeasureCashBase', 361 )
;

delete from pricer_measure where measure_name='HISTO_POS_CASH' and  measure_class_name='tk.core.PricerMeasure' and measure_id=359
;

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_POS_CASH', 'tk.core.PricerMeasure', 359 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'DISCOUNT_FACTOR', 'tk.core.PricerMeasure', 287 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'COMPONENT_MEASURES', 'tk.core.PricerMeasure', 310 )
;

delete from pricer_measure where measure_name='HISTO_CUMUL_CASH' and  measure_class_name='tk.pricer.PricerMeasureHistoricalCumulativeCash' and measure_id=360
;

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_CUMUL_CASH', 'tk.pricer.PricerMeasureHistoricalCumulativeCash', 360 )
;

delete from pricer_measure where measure_name='REALIZED_ACCRUAL' and  measure_class_name='tk.core.PricerMeasure' and measure_id=377
;

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REALIZED_ACCRUAL', 'tk.core.PricerMeasure', 377 )
;

delete from pricer_measure where measure_name='HISTO_ACCRUAL_BO' and  measure_class_name='tk.pricer.PricerMeasureHistoricalAccrualBO' and measure_id=378
;

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_ACCRUAL_BO', 'tk.pricer.PricerMeasureHistoricalAccrualBO', 378 )
;

delete from pricer_measure where measure_name='HISTO_REALIZED_ACCRUAL' and  measure_class_name='tk.core.PricerMeasure' and measure_id=379
;

INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'HISTO_REALIZED_ACCRUAL', 'tk.core.PricerMeasure', 379 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BETA_INDEX', 'tk.core.PricerMeasure', 343 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'PV_COLLAT', 'tk.core.PricerMeasure', 352 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'REPL_SPREAD', 'tk.core.PricerMeasure', 355 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'CARRY', 'tk.core.PricerMeasure', 356 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'SLIDE', 'tk.core.PricerMeasure', 357 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'TIME', 'tk.core.PricerMeasure', 358 )
;

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'USE_VANNA_VOLGA_ADJ', 'java.lang.Boolean', 'true,false', 'Values double and single full-window barriers using vanna-volga pricing in PricerFXOptionBarrier', 0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'ACCURACY_LEVEL', 'java.lang.Integer', '0,1,2,3,4,5,6,7,8,9,10,11', 'Controls the level of accuracy in pricing, 0-lowest accuracy (fastest), 11-highest accuracy (slowest)', 1, 'ACCURACY_LEVEL', '5' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'IGNORE_BASKET_MARKETDATA', 'java.lang.Boolean', 'true,false', 'Allow to price some baskets from either as components or as a single.  If it sets to true then it will ALWAYS price from components.', 1, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'PRICING_MODEL', 'java.lang.String', 'Ju2002,Levy92', 'Basket pricing model choice', 1, 'Ju2002' )
;
delete from pricing_param_name where param_name='RECALC_SYSTEM_PLMARKS' and  param_type='java.lang.Boolean' and  param_domain='true,false'
;

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'RECALC_SYSTEM_PLMARKS', 'java.lang.Boolean', 'true,false', 'Re-calculate system PL marks by brute force', 0, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_DRIFT', 'java.lang.Double', 'Drift parameter in the time-independent Heston model; known also as mu.', 0, 'HESTON_DRIFT' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_MEAN_VAR', 'java.lang.Double', 'Long-term mean of the variance in the time-independent Heston model; known also as theta.', 0, 'HESTON_MEAN_VAR' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_VAR_REV_SPEED', 'java.lang.Double', 'The variance mean-reversion speed in the time-independent Heston model; known also as kappa.', 0, 'HESTON_VAR_REV_SPEED' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_VOL_VOL', 'java.lang.Double', 'The volatility of volatility in the time-independent Heston model; known also as epsilon, sigma or xi.', 0, 'HESTON_VOL_VOL' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name ) VALUES ( 'HESTON_CORR', 'java.lang.Double', 'The correlation of price and variance in the time-independent Heston model; known also as rho.', 0, 'HESTON_CORR' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_comment, is_global_b, display_name, default_value ) VALUES ( 'HESTON_NUM_MC_PATHS', 'java.lang.Integer', 'The number of Monte Carlo simulations to use when calculating with the Heston model.', 0, 'HESTON_NUM_MC_PATHS', '1000' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'PAYOUT_AS_FEE', 'java.lang.Boolean', 'true,false', 'Include Variance Swap payout as a fee', 1, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'USE_UNDERLYING_TRADES_PRICER', 'java.lang.Boolean', 'true,false', 'Price structured product using underlying pricer params.', 0, 'false' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'EQUITY/EQUITY_CORRELATION', 'com.calypso.tk.core.Rate', '', 'Option basket model parameter.', 0, 'EQUITY/EQUITY_CORRELATION' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'EQUITY/EQUITYINDEX_CORRELATION', 'com.calypso.tk.core.Rate', '', 'Option basket model parameter.', 0, 'EQUITY/EQUITYINDEX_CORRELATION' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name ) VALUES ( 'EQUITYINDEX/EQUITYINDEX_CORRELATION', 'com.calypso.tk.core.Rate', '', 'Option basket model parameter.', 0, 'EQUITYINDEX/EQUITYINDEX_CORRELATION' )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 130, 'PLMark', 0, 0, 0 )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 131, 'MarginCallPosition', 0, 1, 1 )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'task_completion', 'Auxiliary table to complete linked tasks at TaskEngine start.' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'speed_button', 'Speed Button information to capture often used trade or risk data, used in CWS' )
;
INSERT INTO table_comment ( table_name, table_comment ) VALUES ( 'arch_cre_tmp', 'Scratch table to store ids of cre to be archived/deleted.' )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES ( 218, 'PSEventTrade', 'ALLOCATED', 'TERMINATE', 'TERMINATED', 0, 1, 'ALL', 0, 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b, product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b, gen_int_event_b ) VALUES ( 219, 'PSEventTrade', 'TERMINATED', 'AMEND', 'TERMINATED', 0, 1, 'ALL', 0, 0, 0, 0, 0 )
;

/* CAL-66546 */

delete from domain_values where name = 'riskPresenter' and value = 'Pricing'
;

/* CAL-67116 */

/* Delete the old PricerMeasure */
BEGIN
  DECLARE cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO cnt FROM pricer_measure WHERE measure_name = 'TRADING_DAYS = 206';
  IF(cnt != 0) THEN
    DELETE FROM pricer_measure WHERE measure_name = 'TRADING_DAYS = 206';
   END IF;
 END;
END;
;

/* Add the good one */
BEGIN
  DECLARE cnt NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO cnt FROM pricer_measure WHERE measure_name = 'TRADING_DAYS';
  IF(cnt = 0) THEN
    INSERT INTO pricer_measure(measure_name,measure_class_name,measure_id) VALUES('TRADING_DAYS','tk.core.PricerMeasure',206);
   END IF;
 END;
END;
;

UPDATE calypso_info
    SET major_version=11,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('02/07/2009','DD/MM/YYYY')
;
