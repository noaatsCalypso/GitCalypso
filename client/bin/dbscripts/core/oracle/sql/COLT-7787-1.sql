DECLARE
	v_table_exists number := 0;  
BEGIN
	select count(*) into v_table_exists
	from user_tables 
	where table_name = 'MODULE_UPGRADE_SCRIPTS';
	if (v_table_exists = 0) then
		execute immediate 
			'CREATE TABLE MODULE_UPGRADE_SCRIPTS (name varchar2(128) not null, module_name varchar2(128), user_name varchar2(128), execution_date DATE)';
	end if;
END;
/
BEGIN
	execute immediate 
		'DELETE FROM MODULE_UPGRADE_SCRIPTS WHERE name = :a' using 'schema-synchronization';
	update MODULE_UPGRADE_SCRIPTS set name = 'upgrade_1.06.03_mrgcall_field_SchemaChange.sql' where name = 'upgrade_2.00.00_mrgcall_field_SchemaChange.sql';
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.03.03_WorkflowEntity.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
  v_max_state_id_theoretical number := 0;
  v_max_state_id_actual number := 0;  
BEGIN
  Select nvl(max(state_id),0) into v_max_state_id_actual
    from entity_state;
    
  Select nvl(max(last_id),0) into v_max_state_id_theoretical
    from calypso_seed where seed_name = 'workflow';

  if (v_max_state_id_actual > v_max_state_id_theoretical) then
	UPDATE calypso_seed SET last_id = v_max_state_id_actual where seed_name = 'workflow';
  end if;
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.04.00_TargetConfiguration.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  
	v_column_exists number := 0;  
BEGIN
	select count(*) into v_column_exists
		from USER_TAB_COLS
		where column_name = 'TARGET_ID' and table_name = 'OPTIMIZATION_CONFIGURATION';
	select count(*) into v_table_exists
		from USER_TABLES 
		where table_name = 'TARGET_CONFIGURATION';
	if (v_table_exists != 0) then
		select count(*) into v_table_exists
			from USER_TABLES 
			where table_name = 'OPTIMIZATION_CONFIGURATION';
		if (v_table_exists != 0) then
			if (v_column_exists = 0) then
				execute immediate 
					'ALTER TABLE TARGET_CONFIGURATION
						ADD (id number(22) default 0 not null,
						version number(22) default 0 not null,
						name varchar2(128),
						description varchar2(256))';
				execute immediate 
					'ALTER TABLE OPTIMIZATION_CONFIGURATION ADD target_id number(22) default 0 not null';
				execute immediate 
					'UPDATE TARGET_CONFIGURATION SET id = config_id, name = type';
				execute immediate 
					'UPDATE OPTIMIZATION_CONFIGURATION SET target_id = id';
			end if;
		end if;
	end if;
end;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.05.08_AllocationRuleTarget.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  
	DistributionRule VARCHAR(50) := 'Distribution-rule';
	AllocationRule VARCHAR(50) := 'Allocation-rule';
	CoverDistribution VARCHAR(50) := 'CoverDistribution';
	FinalDistribution VARCHAR(50) := 'FinalDistribution';
BEGIN
	select count(*) into v_table_exists
	from user_tables 
	where table_name = 'TARGET_CONFIGURATION';
	if (v_table_exists != 0) then
		select count(*) into v_table_exists
		from user_tables 
		where table_name = 'OPTIMIZATION_CONFIGURATION';
		if (v_table_exists != 0) then
			BEGIN execute immediate 'ALTER TABLE OPTIMIZATION_CONFIGURATION ADD (optimization_type varchar(64))'; EXCEPTION WHEN OTHERS THEN NULL; END;	
			BEGIN execute immediate 'ALTER TABLE OPTIMIZATION_CONFIGURATION ADD (target_id number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;	
			execute immediate 'UPDATE TARGET_CONFIGURATION SET type = '''||DistributionRule||''' WHERE type = '''||AllocationRule||''' AND id in (SELECT target_id FROM OPTIMIZATION_CONFIGURATION WHERE optimization_type IN ('''||CoverDistribution||''', '''||FinalDistribution||'''))';
		end if;
	end if;
	if (v_table_exists != 0) then
		BEGIN execute immediate 'ALTER TABLE OPTIMIZATION_CONFIGURATION ADD (optimizer varchar(64))'; EXCEPTION WHEN OTHERS THEN NULL; END;
		BEGIN execute immediate 'ALTER TABLE OPTIMIZATION_CONFIGURATION ADD (optimization_type varchar(64))'; EXCEPTION WHEN OTHERS THEN NULL; END;	
		execute immediate 'UPDATE OPTIMIZATION_CONFIGURATION SET optimizer = '''||DistributionRule||''' WHERE optimizer = '''||AllocationRule||''' and optimization_type IN ('''||CoverDistribution||''', '''||FinalDistribution||''')';
	end if;
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.05.10_CollateralConfig_SchemaConflict.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  
	position_type VARCHAR(50) := 'THEORETICAL';
	position_date_type VARCHAR(50) := 'POSITION_DATE_DEFAULT';
	substitution_context VARCHAR(50) := 'Pay Margin';
	substitution_level VARCHAR(50) := 'Inherited from Optimization Configuration';
	substitution_type  VARCHAR(50) := 'Never';
BEGIN
	select count(*) into v_table_exists from user_tables where table_name = 'MRGCALL_CONFIG';
	if (v_table_exists = 0) then
		execute immediate 
		'CREATE TABLE MRGCALL_CONFIG (mrg_call_def number(22))';
	end if;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (account_id number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (additional_fields blob)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (agency_list varchar(255))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (book_list varchar(1024))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (clearing_member_id number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (collateral_dates blob)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (concentration_position varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (concentration_side varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (contract_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (contract_dispute_tol_amount float)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (contract_dispute_tol_perc_b number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (credit_multiplier float)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (eligibility_filters blob)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (exclude_from_optimizer number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (exposure_type_list varchar(1024))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (is_initial_margin number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (le_ia_rating_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (le_mta_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (le_rating_config number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (le_thres_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (notes varchar(1024))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (po_ia_rating_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (po_mta_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (po_rating_config number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (po_thres_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (position_date_type varchar(128) DEFAULT '''||position_date_type||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (position_type varchar(128) DEFAULT '''||position_type||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (rounding_before_mta_b number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (secured_party varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (substitution_context varchar(128) DEFAULT '''||substitution_context||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (substitution_level varchar(128) DEFAULT '''||substitution_level||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (substitution_type varchar(128) DEFAULT '''||substitution_type||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MRGCALL_CONFIG ADD (parent_id number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	select count(*) into v_table_exists
		from user_tables where table_name = 'COLLATERAL_CONFIG';
	if (v_table_exists = 0) then
		execute immediate 
		'CREATE TABLE COLLATERAL_CONFIG (mcc_id number(22))';
	end if;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (wf_product varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (wf_subtype varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (perimeter_type varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (po_ia_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (le_ia_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (settlement_offset number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (settlement_holidays varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	select count(*) into v_table_exists
		from user_tables where table_name = 'COLLATERAL_CONFIG_NEW_MIGRATED';
	if (v_table_exists > 0) then
		execute immediate 
		'DROP TABLE COLLATERAL_CONFIG_NEW_MIGRATED';
	end if;
	execute immediate 
		'CREATE TABLE COLLATERAL_CONFIG_NEW_MIGRATED (mcc_id number(22))';
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (account_id number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (additional_fields blob)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (agency_list varchar(255))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (book_list varchar(1024))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (clearing_member_id number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (collateral_dates blob)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (concentration_position varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (concentration_side varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (contract_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (contract_dispute_tol_amount float)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (contract_dispute_tol_perc_b number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (credit_multiplier float)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (eligibility_filters blob)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (exclude_from_optimizer number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (exposure_type_list varchar(1024))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (is_initial_margin number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (le_ia_rating_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (le_mta_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (le_rating_config number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (le_thres_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (notes varchar(1024))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (po_ia_rating_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (po_mta_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (po_rating_config number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (po_thres_currency varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (position_date_type varchar(128) DEFAULT '''||position_date_type||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (position_type varchar(128) DEFAULT '''||position_type||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (rounding_before_mta_b number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (secured_party varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (substitution_context varchar(128) DEFAULT '''||substitution_context||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (substitution_level varchar(128) DEFAULT '''||substitution_level||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (substitution_type varchar(128) DEFAULT '''||substitution_type||''')'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (wf_product varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (wf_subtype varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (perimeter_type varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (po_ia_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (le_ia_direction varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (settlement_offset number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED ADD (settlement_holidays varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	execute immediate 
		'INSERT into COLLATERAL_CONFIG_NEW_MIGRATED (
				mcc_id,
				account_id,
				additional_fields,
				agency_list,
				book_list,
				clearing_member_id,
				collateral_dates,
				concentration_position,
				concentration_side,
				contract_direction,
				contract_dispute_tol_amount,
				contract_dispute_tol_perc_b,
				credit_multiplier,
				eligibility_filters,
				exclude_from_optimizer,
				exposure_type_list,
				is_initial_margin,
				le_ia_rating_direction,
				le_mta_currency,
				le_rating_config,
				le_thres_currency,
				notes,
				po_ia_rating_direction,
				po_mta_currency,
				po_rating_config,
				po_thres_currency,
				position_date_type,
				position_type,
				rounding_before_mta_b,
				secured_party,
				substitution_context,
				substitution_level,
				substitution_type,
				wf_product,
				wf_subtype,
				perimeter_type,
				po_ia_direction,
				le_ia_direction,
				settlement_offset,			
				settlement_holidays
			) SELECT 
				mcc.mrg_call_def,
				mcc.account_id,
				cc.additional_fields,
				mcc.agency_list,
				mcc.book_list,
				mcc.clearing_member_id,
				cc.collateral_dates,
				mcc.concentration_position,
				mcc.concentration_side,
				mcc.contract_direction,
				mcc.contract_dispute_tol_amount,
				mcc.contract_dispute_tol_perc_b,
				mcc.credit_multiplier,
				cc.eligibility_filters,
				mcc.exclude_from_optimizer,
				mcc.exposure_type_list,
				mcc.is_initial_margin,
				mcc.le_ia_rating_direction,
				mcc.le_mta_currency,
				mcc.le_rating_config,
				mcc.le_thres_currency,
				mcc.notes,
				mcc.po_ia_rating_direction,
				mcc.po_mta_currency,
				mcc.po_rating_config,
				mcc.po_thres_currency,
				mcc.position_date_type,
				mcc.position_type,
				mcc.rounding_before_mta_b,
				mcc.secured_party,
				mcc.substitution_context,
				mcc.substitution_level,
				mcc.substitution_type,
				cc.wf_product,
				cc.wf_subtype,
				cc.perimeter_type,
				cc.po_ia_direction,
				cc.le_ia_direction,
				cc.settlement_offset,			
				cc.settlement_holidays
			FROM MRGCALL_CONFIG mcc, COLLATERAL_CONFIG cc
			WHERE cc.mcc_id = mcc.mrg_call_def';
	execute immediate 
		'INSERT into COLLATERAL_CONFIG_NEW_MIGRATED (
				mcc_id,
				account_id,
				additional_fields,
				agency_list,
				book_list,
				clearing_member_id,
				collateral_dates,
				concentration_position,
				concentration_side,
				contract_direction,
				contract_dispute_tol_amount,
				contract_dispute_tol_perc_b,
				credit_multiplier,
				eligibility_filters,
				exclude_from_optimizer,
				exposure_type_list,
				is_initial_margin,
				le_ia_rating_direction,
				le_mta_currency,
				le_rating_config,
				le_thres_currency,
				notes,
				po_ia_rating_direction,
				po_mta_currency,
				po_rating_config,
				po_thres_currency,
				position_date_type,
				position_type,
				rounding_before_mta_b,
				secured_party,
				substitution_context,
				substitution_level,
				substitution_type
			) SELECT 
				mcc.mrg_call_def,
				mcc.account_id,
				mcc.additional_fields,
				mcc.agency_list,
				mcc.book_list,
				mcc.clearing_member_id,
				mcc.collateral_dates,
				mcc.concentration_position,
				mcc.concentration_side,
				mcc.contract_direction,
				mcc.contract_dispute_tol_amount,
				mcc.contract_dispute_tol_perc_b,
				mcc.credit_multiplier,
				mcc.eligibility_filters,
				mcc.exclude_from_optimizer,
				mcc.exposure_type_list,
				mcc.is_initial_margin,
				mcc.le_ia_rating_direction,
				mcc.le_mta_currency,
				mcc.le_rating_config,
				mcc.le_thres_currency,
				mcc.notes,
				mcc.po_ia_rating_direction,
				mcc.po_mta_currency,
				mcc.po_rating_config,
				mcc.po_thres_currency,
				mcc.position_date_type,
				mcc.position_type,
				mcc.rounding_before_mta_b,
				mcc.secured_party,
				mcc.substitution_context,
				mcc.substitution_level,
				mcc.substitution_type
			FROM MRGCALL_CONFIG mcc
			WHERE NOT EXISTS (SELECT cc.mcc_id 
								FROM COLLATERAL_CONFIG cc 
								WHERE cc.mcc_id = mcc.mrg_call_def)';
	execute immediate 
		'DROP TABLE COLLATERAL_CONFIG';
	execute immediate 
		'ALTER TABLE COLLATERAL_CONFIG_NEW_MIGRATED RENAME TO COLLATERAL_CONFIG';
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.05.10_EligibleBooks.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
declare
my_id mrgcall_config.mrg_call_def%TYPE;
my_parent_id mrgcall_config.parent_id%TYPE;
my_type VARCHAR2(50) := 'Type';
my_type_string VARCHAR2(50) := 'TYPE_STRING';
my_name VARCHAR2(50) := 'Name';
my_book_name VARCHAR2(50) := 'Book name' ;
my_type_enum VARCHAR2(50) := 'TYPE_ENUM';
my_all_books VARCHAR2(50) := 'All Books in perimeter';
my_key_id VARCHAR2(50) := 'Key Id';
my_type_integer VARCHAR2(50) := 'TYPE_INTEGER';
my_legal_entity_type VARCHAR2(50) := 'Legal Entity Books';
my_attribute VARCHAR2(50) := 'Attribute';
my_value VARCHAR2(50) := 'Value';
my_true VARCHAR2(50) := 'true';
my_collateral_holding VARCHAR2(50) := 'CollateralHolding';
my_po_contract VARCHAR2(50) := 'Contract - PO books';
my_parent_po_contract VARCHAR2(50) := 'Contract - Parent LE books';
my_po_parent_contract VARCHAR2(50) := 'Parent contract - PO books';
my_parent_po_parent_contract VARCHAR2(50) := 'Parent contract - Parent LE books';
my_internal_id calypso_seed.last_id%TYPE;
v_table_exists number := 0;  
my_count int;
my_int1 int := 1;
my_int500 int := 500;

cursor cur is select A.mrg_call_def, A.parent_id from mrgcall_config A;

begin

select count(*) into v_table_exists
from user_tables 
where table_name = 'ELIGIBLE_BOOKS_KV';
if (v_table_exists = 0) then
	execute immediate 'create table eligible_books_kv (id number not null, name VARCHAR(255) not null, type VARCHAR(255) not null, value VARCHAR(255) not null, internal_id int not null)';
end if;

select count(*) into my_count from calypso_seed where seed_name = 'collateral-key-value';
if my_count = 0 then 
execute immediate 'insert into calypso_seed (last_id, seed_name, seed_alloc_size) values (:a, :b, :c)' using my_int1, 'collateral-key-value', my_int500;
my_internal_id := 1;
else
execute immediate 'select last_id from calypso_seed where seed_name = :x' into my_internal_id using 'collateral-key-value';
end if;

open cur;

loop
fetch cur into my_id, my_parent_id; 
exit when cur%notfound;

	
if my_parent_id < 0 then

execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_type, my_type_string, my_name, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_book_name, my_type_enum, my_all_books, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_key_id, my_type_integer, my_id, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_legal_entity_type, my_type_enum, my_po_contract, my_internal_id;

my_internal_id := my_internal_id + 1;

execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_type, my_type_string, my_attribute, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_attribute, my_type_string, my_collateral_holding, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_value, my_type_string, my_true, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_key_id, my_type_integer, my_id, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_legal_entity_type, my_type_enum, my_parent_po_contract, my_internal_id;

my_internal_id := my_internal_id + 1;

else

execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_type, my_type_string, my_name, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_book_name, my_type_enum, my_all_books, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_key_id, my_type_integer, my_id, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_legal_entity_type, my_type_enum, my_po_parent_contract, my_internal_id;

my_internal_id := my_internal_id + 1;

execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_type, my_type_string, my_attribute, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_attribute, my_type_string, my_collateral_holding, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_value, my_type_string, my_true, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_key_id, my_type_integer, my_id, my_internal_id;
execute immediate 'insert into eligible_books_kv (id, name, type, value, internal_id) values (:a, :b, :c, :d, :e)' using my_id, my_legal_entity_type, my_type_enum, my_parent_po_parent_contract, my_internal_id;

my_internal_id := my_internal_id + 1;

end if;

end loop;

my_internal_id := my_internal_id + 500;

execute immediate 'update calypso_seed set last_id = :y where seed_name = :x' using my_internal_id, 'collateral-key-value';

close cur; 
end;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.05.11_CollateralConfig_IntradayPricingEnv_v01.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  
BEGIN
	select count(*) into v_table_exists
		from user_tables where table_name = 'CLEARING_MEMBER_CONFIGURATION';
	if (v_table_exists > 0) then
		select count(*) into v_table_exists
			from user_tables where table_name = 'COLLATERAL_CONFIG';
		if (v_table_exists = 0) then
			execute immediate 
			'CREATE TABLE COLLATERAL_CONFIG (mcc_id number(22), intraday_pricing_env_name varchar(128) null)';
		else
			BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (intraday_pricing_env_name varchar(128) null)'; EXCEPTION WHEN OTHERS THEN NULL; END;
		end if;
		execute immediate
			'update COLLATERAL_CONFIG set
				COLLATERAL_CONFIG.intraday_pricing_env_name = 
					(select CLEARING_MEMBER_CONFIGURATION.intraday_pricing_env_name from CLEARING_MEMBER_CONFIGURATION 
							where COLLATERAL_CONFIG.clearing_member_id = CLEARING_MEMBER_CONFIGURATION.id)';
	end if;
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.06.00_CollateralConfig_SettlementOffset.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_column_data_type number := 0;  
BEGIN
	select count(*) into v_column_data_type from user_tab_columns where table_name = 'COLLATERAL_CONFIG' and column_name = 'SETTLEMENT_OFFSET' and data_type = 'VARCHAR2';
	if (v_column_data_type > 0) then
		BEGIN
			BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG DROP COLUMN settlement_offset_migration'; EXCEPTION WHEN OTHERS THEN NULL; END;
			execute immediate 
				'ALTER TABLE COLLATERAL_CONFIG ADD (settlement_offset_migration number(22) null)';
			execute immediate 
				'update COLLATERAL_CONFIG SET settlement_offset_migration = TO_NUMBER(settlement_offset)';
			execute immediate 
				'ALTER TABLE COLLATERAL_CONFIG DROP COLUMN settlement_offset';
			execute immediate 
				'ALTER TABLE COLLATERAL_CONFIG ADD (settlement_offset number(22) null)';
			execute immediate 
				'update COLLATERAL_CONFIG SET settlement_offset = settlement_offset_migration';
			execute immediate 
				'ALTER TABLE COLLATERAL_CONFIG DROP COLUMN settlement_offset_migration';
		END;
	end if;
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.06.00_mrgcall_config_currency_SchemaChange.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  
BEGIN
	select count(*) into v_table_exists
		from user_tables where table_name = 'MRGCALL_CONFIG_CURRENCY';
	if (v_table_exists > 0) then
		select count(*) into v_table_exists
			from user_tables where table_name = 'COLLATERAL_CONFIG_CURRENCY';
		if (v_table_exists > 0) then
			execute immediate 'SELECT count(*) FROM COLLATERAL_CONFIG_CURRENCY' into v_table_exists;
			if (v_table_exists = 0) then
				execute immediate 
					'DROP TABLE COLLATERAL_CONFIG_CURRENCY';
			else
				raise_application_error( -20001, 'collateral_config_currency already exists and contains data. Please merge the data back into mrgcall_config_currency, drop the table collateral_config_currency and re-run this script.' );
			end if;
		end if;	
		execute immediate 
			'ALTER TABLE MRGCALL_CONFIG_CURRENCY RENAME TO COLLATERAL_CONFIG_CURRENCY';
	end if;
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.06.03_mrgcall_field_SchemaChange.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  
BEGIN
	select count(*) into v_table_exists
		from user_tables where table_name = 'MRGCALL_FIELD';
	if (v_table_exists > 0) then
		select count(*) into v_table_exists
			from user_tables where table_name = 'COLLATERAL_CONFIG_FIELD';
		if (v_table_exists > 0) then
			execute immediate 'SELECT count(*) FROM COLLATERAL_CONFIG_FIELD' into v_table_exists;
			if (v_table_exists = 0) then
				execute immediate 
					'DROP TABLE COLLATERAL_CONFIG_FIELD';
			else
				select count(*) into v_table_exists
					from user_tables where table_name = 'MRGCALL_FIELD';
				if (v_table_exists > 0) then
					raise_application_error( -20001, 'collateral_config_field already exists and contains data. Please merge the data back into mrgcall_field, drop the table collateral_config_field and re-run this script.' );
				else 
					execute immediate 
						'DROP TABLE MRGCALL_FIELD';
					execute immediate 
						'ALTER TABLE COLLATERAL_CONFIG_FIELD RENAME TO MRGCALL_FIELD';
				end if;
			end if;
		end if;	
		execute immediate 
			'ALTER TABLE MRGCALL_FIELD RENAME TO COLLATERAL_CONFIG_FIELD';
	end if;
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_1.06.04_percent_basis.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  
	MC_PERCENT VARCHAR2(32) := 'MC_PERCENT';
	DIRTY_PERCENT VARCHAR2(32) := 'DIRTY_PERCENT';
	NOMINAL_PERCENT VARCHAR(32) := 'NOMINAL_PERCENT';
	PERCENT VARCHAR2(32) := 'PERCENT';
	MARGIN_CALL VARCHAR2(32) := 'MARGIN_CALL';
	SEC_FIN_SECURITY_VALUE VARCHAR2(32) := 'SEC_FIN_SECURITY_VALUE';
	NOMINAL VARCHAR(32) := 'NOMINAL';
	PRINCIPAL_AMOUNT VARCHAR(32) := 'PRINCIPAL_AMOUNT';
BEGIN
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (po_mta_perc_basis VARCHAR2(32))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (le_mta_perc_basis VARCHAR2(32))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (po_thresh_perc_basis VARCHAR2(32))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (le_thresh_perc_basis VARCHAR2(32))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	select count(*) into v_table_exists
		from user_tables 
		where table_name = 'COLLATERAL_CONFIG';
	if (v_table_exists != 0) then
		execute immediate 'update collateral_config set po_mta_perc_basis = ''' || MARGIN_CALL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''' || MC_PERCENT || ''')';
		execute immediate 'update collateral_config set po_mta_perc_basis = ''' || SEC_FIN_SECURITY_VALUE || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''' || DIRTY_PERCENT || ''')';
		execute immediate 'update collateral_config set po_mta_perc_basis = ''' || NOMINAL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''' || NOMINAL_PERCENT || ''')';
		execute immediate 'update collateral_config set po_mta_perc_basis = ''' || PRINCIPAL_AMOUNT || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_mta_type = ''' || PERCENT || ''')';
		execute immediate 'update mrgcall_config set po_mta_type = ''' || PERCENT || ''' where po_mta_type in (''' || MC_PERCENT || ''', ''' || DIRTY_PERCENT || ''', ''' || NOMINAL_PERCENT || ''')';
		
		execute immediate 'update collateral_config set le_mta_perc_basis = ''' || MARGIN_CALL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''' || MC_PERCENT || ''')';
		execute immediate 'update collateral_config set le_mta_perc_basis = ''' || SEC_FIN_SECURITY_VALUE || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''' || DIRTY_PERCENT || ''')';
		execute immediate 'update collateral_config set le_mta_perc_basis = ''' || NOMINAL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''' || NOMINAL_PERCENT || ''')';
		execute immediate 'update collateral_config set le_mta_perc_basis = ''' || PRINCIPAL_AMOUNT || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_mta_type = ''' || PERCENT || ''')';
		execute immediate 'update mrgcall_config set le_mta_type = ''' || PERCENT || ''' where le_mta_type in (''' || MC_PERCENT || ''', ''' || DIRTY_PERCENT || ''', ''' || NOMINAL_PERCENT || ''')';
		
		execute immediate 'update collateral_config set po_thresh_perc_basis = ''' || MARGIN_CALL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''' || MC_PERCENT || ''')';
		execute immediate 'update collateral_config set po_thresh_perc_basis = ''' || SEC_FIN_SECURITY_VALUE || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''' || DIRTY_PERCENT || ''')';
		execute immediate 'update collateral_config set po_thresh_perc_basis = ''' || NOMINAL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''' || NOMINAL_PERCENT || ''')';
		execute immediate 'update collateral_config set po_thresh_perc_basis = ''' || PRINCIPAL_AMOUNT || ''' where mcc_id in (select mrg_call_def from mrgcall_config where po_thres_type = ''' || PERCENT || ''')';
		execute immediate 'update mrgcall_config set po_thres_type = ''' || PERCENT || ''' where po_thres_type in (''' || MC_PERCENT || ''', ''' || DIRTY_PERCENT || ''', ''' || NOMINAL_PERCENT || ''')';
		
		execute immediate 'update collateral_config set le_thresh_perc_basis = ''' || MARGIN_CALL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = ''' || MC_PERCENT || ''')';
		execute immediate 'update collateral_config set le_thresh_perc_basis = ''' || SEC_FIN_SECURITY_VALUE || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = ''' || DIRTY_PERCENT || ''')';
		execute immediate 'update collateral_config set le_thresh_perc_basis = ''' || NOMINAL || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = ''' || NOMINAL_PERCENT || ''')';
		execute immediate 'update collateral_config set le_thresh_perc_basis = ''' || PRINCIPAL_AMOUNT || ''' where mcc_id in (select mrg_call_def from mrgcall_config where le_thres_type = ''' || PERCENT || ''')';
		execute immediate 'update mrgcall_config set le_thres_type = ''' || PERCENT || ''' where le_thres_type in (''' || MC_PERCENT || ''', ''' || DIRTY_PERCENT || ''', ''' || NOMINAL_PERCENT ||''')';
	end if;
	BEGIN execute immediate 'ALTER TABLE mrgcall_credit_rating Add (threshold_percent_basis  VARCHAR2(32))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE mrgcall_credit_rating Add (mta_percent_basis  VARCHAR2(32))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE mrgcall_credit_rating Add (ia_percent_basis VARCHAR2(32))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	select count(*) into v_table_exists
		from user_tables 
		where table_name = 'MRGCALL_CREDIT_RATING';
	if (v_table_exists != 0) then
		execute immediate 'update mrgcall_credit_rating set threshold_percent_basis = ''' || MARGIN_CALL || ''' where threshold_type = ''' || MC_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set threshold_percent_basis = ''' || SEC_FIN_SECURITY_VALUE || ''' where threshold_type = ''' || DIRTY_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set threshold_percent_basis = ''' || NOMINAL || ''' where threshold_type = ''' || NOMINAL_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set threshold_percent_basis = ''' || PRINCIPAL_AMOUNT || ''' where threshold_type = ''' || PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set threshold_type = ''' || PERCENT || ''' where threshold_type in (''' || MC_PERCENT || ''', ''' || DIRTY_PERCENT || ''', ''' || NOMINAL_PERCENT || ''')';
		
		execute immediate 'update mrgcall_credit_rating set mta_percent_basis = ''' || MARGIN_CALL || ''' where mta_type = ''' || MC_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set mta_percent_basis = ''' || SEC_FIN_SECURITY_VALUE || ''' where mta_type = ''' || DIRTY_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set mta_percent_basis = ''' || NOMINAL || ''' where mta_type = ''' || NOMINAL_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set mta_percent_basis = ''' || PRINCIPAL_AMOUNT || ''' where mta_type = ''' || PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set mta_type = ''' || PERCENT || ''' where mta_type in (''' || MC_PERCENT || ''', ''' || DIRTY_PERCENT || ''', ''' || NOMINAL_PERCENT || ''')';
		
		execute immediate 'update mrgcall_credit_rating set ia_percent_basis = ''' || MARGIN_CALL || ''' where ia_type = ''' || MC_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set ia_percent_basis = ''' || SEC_FIN_SECURITY_VALUE || ''' where ia_type = ''' || DIRTY_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set ia_percent_basis = ''' || NOMINAL || ''' where ia_type = ''' || NOMINAL_PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set ia_percent_basis = ''' || PRINCIPAL_AMOUNT || ''' where ia_type = ''' || PERCENT || '''';
		execute immediate 'update mrgcall_credit_rating set ia_type = ''' || PERCENT || ''' where ia_type in (''' || MC_PERCENT || ''', ''' || DIRTY_PERCENT || ''', ''' || NOMINAL_PERCENT || ''')';
	end if;
END;


	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE
  v_table_exists number := 0;
    v_default_context_id number := 0;
  v_default_context_name VARCHAR2(50) := 0;
  LC$Requete        VARCHAR2(256);
BEGIN
	select count(*) into v_table_exists
		from user_tables where table_name = 'COLLATERAL_CONTEXT';
	if (v_table_exists > 0) then
	BEGIN execute immediate 'ALTER TABLE MARGIN_CALL_ENTRIES ADD (collateral_context_id number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE MARGIN_CALL_ENTRIES ADD (collateral_context_name VARCHAR2(50))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	end if;

	select count(*) into v_table_exists
		from user_tables where table_name in ('COLLATERAL_CONTEXT', 'MARGIN_CALL_ENTRIES');
	if (v_table_exists = 2) then
   LC$Requete:= 'select count(*) from collateral_context where is_default = 1';
		execute immediate LC$Requete INTO v_table_exists;
		if (v_table_exists = 1) then
        LC$Requete:= 'select id from collateral_context where is_default = 1';
				execute immediate LC$Requete INTO v_default_context_id;
        
        LC$Requete:= 'select name from collateral_context where is_default = 1';
				execute immediate LC$Requete INTO v_default_context_name;
        
        LC$Requete:= 'select count(*) from margin_call_entries where collateral_context_id is null';
				execute immediate LC$Requete INTO v_table_exists;
				
			if (v_table_exists > 0) then
        LC$Requete:= 'select count(*)  from user_tables where table_name = ''MARGIN_CALL_ENTRIES''';
        execute immediate LC$Requete INTO v_table_exists;
          if (v_table_exists > 0) then
				execute immediate 
					'update margin_call_entries set collateral_context_id = :a, collateral_context_name = :b where collateral_context_id IS NULL' 
					using v_default_context_id, v_default_context_name;
				execute immediate
					'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' 
					using 'upgrade_2.00.00_Entry_with_default_context.sql', 'collateral', user, CURRENT_DATE;
			end if;
		end if;
		end if;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_2.00.00_valuation_time.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
declare
my_internal_id calypso_seed.last_id%TYPE;
my_int1 int := 1;
my_int500 int := 500;
my_rule_name VARCHAR2(50) := 'COL_MIGR_DAILY_BUS';
my_val_rule_name VARCHAR2(50) := 'COL_MIGR_VAL_REL';
my_date_roll VARCHAR2(50) := 'FOLLOWING';
my_rel_type VARCHAR2(50) := 'Absolute';
my_date_roll_prec VARCHAR2(50) := 'PRECEDING';
my_offset int := -1;
my_ref_data VARCHAR2(50) := 'refdata';
my_count int;
v_table_exists number := 0;
v_table_cc_exists       NUMBER       := 0;
v_table_optim_exists       NUMBER       := 0;
v_table_dr_exists       NUMBER       := 0;
my_refdata VARCHAR2(50) := 'refdata';
my_relrule int := 1;
my_col_context_count int := 0;
my_valtime VARCHAR2(50) := '2014-01-01 18:00:00';
  LC$Requete        VARCHAR2(256);
begin

select count(*) into v_table_exists
		from user_tables where table_name = 'COLLATERAL_CONTEXT';
 SELECT COUNT(*)
      INTO v_table_dr_exists
      FROM user_tables
      WHERE table_name   = 'DATE_RULE';			

		select count(*) into my_count from calypso_seed where seed_name = 'refdata';
if my_count = 0 then 
execute immediate 'insert into calypso_seed (last_id, seed_name, seed_alloc_size) values (:a, :b, :c)' using my_int1, my_ref_data, my_int500;
my_internal_id := my_int500;
else
execute immediate 'select last_id from calypso_seed where seed_name = :x' into my_internal_id using 'refdata';
end if;

if(v_table_dr_exists > 0) then
execute immediate 'insert into date_rule(date_rule_id, date_rule_name, date_rule_type, date_rule_month, date_rule_day, date_rule_rank, date_rule_weekday,add_days,bus_cal_b,check_holidays,date_roll,add_months,rel_type,version_num,add_bus_days_b) values (:a, :b, 10, 1, 0, 0, 0, 0, 1, 0, :c, 0, :d, 0, 0)' using my_internal_id, my_rule_name, my_date_roll, my_rel_type;
my_relrule := my_internal_id;
my_internal_id := my_internal_id+1;

	if (v_table_exists > 0) then
LC$Requete:='select count(*)  from collateral_context where is_default = 1';
execute immediate LC$Requete INTO my_col_context_count;
if my_col_context_count = 0 then
my_offset := 0;
else
LC$Requete:= 'select value_date_days   from collateral_context where is_default = 1';
execute immediate LC$Requete INTO my_offset;
end if;
my_offset := (-1.)*my_offset;
else 
  my_offset := -1;
end if;

my_offset := (-1.)*my_offset;

execute immediate 'insert into date_rule(date_rule_id, date_rule_name, date_rule_type, date_rule_month, date_rule_day, date_rule_rank, date_rule_weekday, add_days, bus_cal_b, rel_rule, check_holidays, date_roll, add_months, rel_type, version_num, add_bus_days_b) values (:a, :b, 9, 1, 0, 0, 0, :e, 1, :f, 0, :c, 0, :d, 0, 0)' using my_internal_id, my_val_rule_name, my_offset, my_relrule, my_date_roll_prec, my_rel_type;
end if;
SELECT COUNT(*)
INTO v_table_cc_exists
FROM user_tables
WHERE table_name   = 'MRGCALL_CONFIG';
IF (v_table_cc_exists > 0) THEN
my_internal_id := my_internal_id-1;
execute immediate 'update mrgcall_config set date_rule_id = :a where date_rule_id is null or date_rule_id = 0' using my_internal_id;

my_internal_id := my_internal_id+1;

BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (val_time_offset_id number(22) default 0)'; EXCEPTION WHEN OTHERS THEN NULL; END;
execute immediate 'update collateral_config set val_time_offset_id = :a where val_time_offset_id is null or val_time_offset_id = 0' using my_internal_id;

BEGIN execute immediate 'ALTER TABLE mrgcall_config ADD (val_time TIMESTAMP default 0)'; EXCEPTION WHEN OTHERS THEN NULL; END;

end if;

SELECT COUNT(*)
INTO v_table_optim_exists
FROM user_tables
WHERE table_name   = 'OPTIMIZATION_CONFIGURATION';
IF (v_table_optim_exists > 0) THEN

BEGIN execute immediate 'ALTER TABLE optimization_configuration ADD (optimization_date_offset number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
execute immediate 'update optimization_configuration set optimization_date_offset = :a where optimization_date_offset = null' using my_offset;

my_internal_id := my_internal_id+500;
execute immediate 'update calypso_seed set last_id = :y where seed_name = :x' using my_internal_id, my_refdata;
end if;

end;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_2.03.04_collateral_engine.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
declare 
n int ; 
c int;
begin
	select nvl(max(engine_id)+1,0) into n from engine_config;
	select count(*) into c from engine_config where engine_name='CollateralManagementEngine' ;
	if c = 0 then
		INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'CollateralManagementEngine','Collateral Management Engine');
	end if;
end;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_2.04.00_valuation_time_to_seconds.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  

BEGIN
	select count(*) into v_table_exists from user_tables where table_name = 'CONFIG_ADHOC_DETAILS';
	if (v_table_exists = 0) then
		execute immediate 
		'CREATE TABLE CONFIG_ADHOC_DETAILS (id number(22) NOT NULL)';
	end if;
	BEGIN execute immediate 'ALTER TABLE CONFIG_ADHOC_DETAILS ADD (val_time TIMESTAMP(6))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE CONFIG_ADHOC_DETAILS ADD (val_time_zone varchar(128))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE CONFIG_ADHOC_DETAILS ADD (val_time_seconds number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;

	execute immediate 'UPDATE CONFIG_ADHOC_DETAILS SET val_time_seconds = NVL((EXTRACT(SECOND FROM CAST((CAST(val_time AS TIMESTAMP) AT TIME ZONE val_time_zone) as TIMESTAMP )) + 60 * EXTRACT(MINUTE FROM CAST((CAST(val_time AS TIMESTAMP) AT TIME ZONE val_time_zone) as TIMESTAMP )) + 3600 * EXTRACT(HOUR FROM CAST((CAST(val_time AS TIMESTAMP) AT TIME ZONE val_time_zone) as TIMESTAMP ))), 64800)';

	select count(*) into v_table_exists from user_tables where table_name = 'COLLATERAL_CONFIG';
	if (v_table_exists = 0) then
		execute immediate 
		'CREATE TABLE COLLATERAL_CONFIG';
	end if;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (val_time_seconds number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (notification_time_seconds number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG ADD (substitution_time_seconds number(22))'; EXCEPTION WHEN OTHERS THEN NULL; END;

	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Asia/Calcutta'' WHERE val_time_zone=''IST''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Asia/Hong_Kong'' WHERE val_time_zone=''ACT''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''America/Argentina/Buenos_Aires'' WHERE val_time_zone=''ART''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Australia/Sydney'' WHERE val_time_zone=''Aus''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''America/Sao_Paulo'' WHERE val_time_zone=''BET''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Asia/Dhaka'' WHERE val_time_zone=''BST''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Etc/GMT+2'' WHERE val_time_zone=''CAT''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Etc/GMT-4'' WHERE val_time_zone=''CNT''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Etc/GMT+8'' WHERE val_time_zone=''CTT''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Etc/GMT+3'' WHERE val_time_zone=''EAT''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Etc/GMT+1'' WHERE val_time_zone=''ECT''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''America/Indiana/Indianapolis'' WHERE val_time_zone=''IET''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Asia/Tokyo'' WHERE val_time_zone=''JST''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Pacific/Midway'' WHERE val_time_zone=''MIT''';
	execute immediate 'UPDATE MRGCALL_CONFIG SET val_time_zone=''Pacific/Auckland'' WHERE val_time_zone=''NZT''';
	
	execute immediate 'UPDATE COLLATERAL_CONFIG SET val_time_seconds = NVL((SELECT time_value FROM (SELECT collateral_config.mcc_id id, (EXTRACT(SECOND FROM CAST((CAST(val_time AS TIMESTAMP) AT TIME ZONE val_time_zone) as TIMESTAMP )) + 60 * EXTRACT(MINUTE FROM CAST((CAST(val_time AS TIMESTAMP) AT TIME ZONE val_time_zone) as TIMESTAMP )) + 3600 * EXTRACT(HOUR FROM CAST((CAST(val_time AS TIMESTAMP) AT TIME ZONE val_time_zone) as TIMESTAMP ))) time_value FROM mrgcall_config, collateral_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) WHERE id = COLLATERAL_CONFIG.mcc_id), 64800)';

	execute immediate 'UPDATE COLLATERAL_CONFIG SET notification_time_seconds = NVL((SELECT time_value FROM (SELECT collateral_config.mcc_id id, (EXTRACT(SECOND FROM CAST((CAST(not_time AS TIMESTAMP) AT TIME ZONE not_time_zone) as TIMESTAMP )) + 60 * EXTRACT(MINUTE FROM CAST((CAST(not_time AS TIMESTAMP) AT TIME ZONE not_time_zone) as TIMESTAMP )) + 3600 * EXTRACT(HOUR FROM CAST((CAST(not_time AS TIMESTAMP) AT TIME ZONE not_time_zone) as TIMESTAMP ))) time_value FROM mrgcall_config, collateral_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) WHERE id = COLLATERAL_CONFIG.mcc_id), 64800)';

	execute immediate 'UPDATE COLLATERAL_CONFIG SET substitution_time_seconds = NVL((SELECT time_value FROM (SELECT collateral_config.mcc_id id, (EXTRACT(SECOND FROM CAST((CAST(subst_time AS TIMESTAMP) AT TIME ZONE subst_time_zone) as TIMESTAMP )) + 60 * EXTRACT(MINUTE FROM CAST((CAST(subst_time AS TIMESTAMP) AT TIME ZONE subst_time_zone) as TIMESTAMP )) + 3600 * EXTRACT(HOUR FROM CAST((CAST(subst_time AS TIMESTAMP) AT TIME ZONE subst_time_zone) as TIMESTAMP ))) time_value FROM mrgcall_config, collateral_config WHERE collateral_config.mcc_id = mrgcall_config.mrg_call_def) WHERE id = COLLATERAL_CONFIG.mcc_id), 64800)';
END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_2.05.00_multiple_buffers.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then
DECLARE
	v_table_exists number := 0;  

BEGIN
	select count(*) into v_table_exists from user_tables where table_name = 'COLLATERAL_CONFIG_BUFFER';
	if (v_table_exists = 0) then
		execute immediate 
		'CREATE TABLE COLLATERAL_CONFIG_BUFFER (mrg_call_def number(22) NOT NULL)';
	end if;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_BUFFER ADD (type varchar(255) NOT NULL)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_BUFFER ADD (buffer_method varchar(255) NOT NULL)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_BUFFER ADD (value float)'; EXCEPTION WHEN OTHERS THEN NULL; END;
	BEGIN execute immediate 'ALTER TABLE COLLATERAL_CONFIG_BUFFER ADD (currency_code varchar(3))'; EXCEPTION WHEN OTHERS THEN NULL; END;

	execute immediate 'INSERT INTO COLLATERAL_CONFIG_BUFFER (mrg_call_def, type, buffer_method, value, currency_code) SELECT c.mcc_id, ''Contractual'', ''Multiplier'',  c.credit_multiplier, null FROM collateral_config c, mrgcall_config mcc WHERE c.mcc_id=mcc.mrg_call_def AND c.credit_multiplier <> 0';

END;
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/
DECLARE	v_script_filename varchar2(128);	v_script_executed number := 0;  BEGIN	v_script_filename := 'upgrade_2.07.00_rounding_typo.sql';
	select count(*) into v_script_executed
	from MODULE_UPGRADE_SCRIPTS 
	where name = v_script_filename;
	if (v_script_executed = 0) then

UPDATE entity_attributes SET attr_name = 'Discount Currency' WHERE entity_type = 'ReportTemplate' AND attr_name = 'Discount Curency';

UPDATE entity_attributes SET attr_name = 'PO Rounding Delivery Method' WHERE entity_type = 'ReportTemplate' AND attr_name = 'PO Rouding Delivery Method';
UPDATE entity_attributes SET attr_name = 'PO Rounding Delivery Amount' WHERE entity_type = 'ReportTemplate' AND attr_name = 'PO Rouding Delivery Amount';
UPDATE entity_attributes SET attr_name = 'PO Rounding Return Method' WHERE entity_type = 'ReportTemplate' AND attr_name = 'PO Rouding Return Method';
UPDATE entity_attributes SET attr_name = 'PO Rounding Return Amount' WHERE entity_type = 'ReportTemplate' AND attr_name = 'PO Rouding Return Amount';
UPDATE entity_attributes SET attr_name = 'LE Rounding Delivery Method' WHERE entity_type = 'ReportTemplate' AND attr_name = 'LE Rouding Delivery Method';
UPDATE entity_attributes SET attr_name = 'LE Rounding Delivery Amount' WHERE entity_type = 'ReportTemplate' AND attr_name = 'LE Rouding Delivery Amount';
UPDATE entity_attributes SET attr_name = 'LE Rounding Return Method' WHERE entity_type = 'ReportTemplate' AND attr_name = 'LE Rouding Return Method';
UPDATE entity_attributes SET attr_name = 'LE Rounding Return Amount' WHERE entity_type = 'ReportTemplate' AND attr_name = 'LE Rouding Return Amount';

UPDATE sd_filter_element SET element_name = 'PO Rounding Delivery Method' WHERE element_name = 'PO Rouding Delivery Method';
UPDATE sd_filter_element SET element_name = 'PO Rounding Delivery Amount' WHERE element_name = 'PO Rouding Delivery Amount';
UPDATE sd_filter_element SET element_name = 'PO Rounding Return Method' WHERE element_name = 'PO Rouding Return Method';
UPDATE sd_filter_element SET element_name = 'PO Rounding Return Amount' WHERE element_name = 'PO Rouding Return Amount';
UPDATE sd_filter_element SET element_name = 'LE Rounding Delivery Method' WHERE element_name = 'LE Rouding Delivery Method';
UPDATE sd_filter_element SET element_name = 'LE Rounding Delivery Amount' WHERE element_name = 'LE Rouding Delivery Amount';
UPDATE sd_filter_element SET element_name = 'LE Rounding Return Method' WHERE element_name = 'LE Rouding Return Method';
UPDATE sd_filter_element SET element_name = 'LE Rounding Return Amount' WHERE element_name = 'LE Rouding Return Amount';

UPDATE sd_filter_domain SET element_name = 'PO Rounding Delivery Method' WHERE element_name = 'PO Rouding Delivery Method';
UPDATE sd_filter_domain SET element_name = 'PO Rounding Delivery Amount' WHERE element_name = 'PO Rouding Delivery Amount';
UPDATE sd_filter_domain SET element_name = 'PO Rounding Return Method' WHERE element_name = 'PO Rouding Return Method';
UPDATE sd_filter_domain SET element_name = 'PO Rounding Return Amount' WHERE element_name = 'PO Rouding Return Amount';
UPDATE sd_filter_domain SET element_name = 'LE Rounding Delivery Method' WHERE element_name = 'LE Rouding Delivery Method';
UPDATE sd_filter_domain SET element_name = 'LE Rounding Delivery Amount' WHERE element_name = 'LE Rouding Delivery Amount';
UPDATE sd_filter_domain SET element_name = 'LE Rounding Return Method' WHERE element_name = 'LE Rouding Return Method';
UPDATE sd_filter_domain SET element_name = 'LE Rounding Return Amount' WHERE element_name = 'LE Rouding Return Amount';
	execute immediate
		'INSERT into MODULE_UPGRADE_SCRIPTS (name, module_name, user_name, execution_date) VALUES (:a, :b, :c, :d)' using v_script_filename, 'collateral', user, CURRENT_DATE;
	end if;
END;
/

