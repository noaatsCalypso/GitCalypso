insert into scenario_quoted_product (product_name, pricer_params,pricer_measure) values ('ListedFRA','NPV_FROM_QUOTE','INSTRUMENT_SPREAD') 
;


UPDATE commodity_leg SET cashflow_locks = cashflow_locks + 8725724278030340 WHERE least(bitand(cashflow_locks, power(2,48)),1)=1
;
UPDATE commodity_leg SET cashflow_changed = cashflow_changed + 8725724278030340 WHERE least(bitand(cashflow_changed, power(2,48)),1)=1
;
UPDATE commodity_leg2 SET cashflow_locks = cashflow_locks + 8725724278030340 WHERE least(bitand(cashflow_locks, power(2,48)),1)=1
;
UPDATE commodity_leg2 SET cashflow_changed = cashflow_changed + 8725724278030340 WHERE least(bitand(cashflow_changed, power(2,48)),1)=1
;
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('pk_config_ccypair_exp_owner') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table pk_config_ccypair_exp_owner(
        primary_ccy varchar2(128) not null,
        quoting_ccy varchar2(32) not null,
        exposure_type varchar2(128) not null,
		risk_category varchar2(128) not null,
		operating_zone varchar2(128) not null,
        salience number not null,
        is_exp_owner_book number not null,
        exp_owner_id number not null,
        exp_owner_name varchar2(255) not null)';
 
END IF;
End ;
/

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('pk_config_riskyccy_exp_owner') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table pk_config_riskyccy_exp_owner(risky_ccy  varchar2(128) not null,
exposure_type varchar2(128) not null,
risk_category varchar2(128) not null,
operating_zone varchar2(128) not null,
salience number not null,
is_exp_owner_book number not null ,
exp_owner_id number not null,
exp_owner_name varchar2(255) not null)';
END IF;
End ;
/

declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('pk_config_ccyfunding_exp_owner') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table pk_config_ccyfunding_exp_owner(ccy_ccypair varchar2(128) not null,
exposure_type varchar2(128) not null,
risk_category varchar2(128) not null,
operating_zone varchar2(128) not null,
salience number not null,
is_exp_owner_book number not null,
exp_owner_id number not null,
exp_owner_name varchar2(255) not null)';
END IF;
End ;
/


CREATE OR REPLACE PROCEDURE UPDATE_PK_CONFIGS_OWNER_IDS AS

CURSOR cur_ccypair_book
	IS
		SELECT DISTINCT exp_owner_name from
		PK_CONFIG_CCYPAIR_EXP_OWNER
		where is_exp_owner_book=1
		and exp_owner_id = 0;

CURSOR cur_riskyccy_book
	IS
		SELECT DISTINCT exp_owner_name from
		PK_CONFIG_RISKYCCY_EXP_OWNER
		where is_exp_owner_book=1
		and exp_owner_id = 0;

CURSOR cur_ccyfunding_book
	IS
		SELECT DISTINCT exp_owner_name from
		PK_CONFIG_CCYFUNDING_EXP_OWNER
		where is_exp_owner_book=1
		and exp_owner_id = 0;


CURSOR cur_ccyfunding_ctpty
	IS
		SELECT DISTINCT exp_owner_name from
		PK_CONFIG_CCYFUNDING_EXP_OWNER
		where is_exp_owner_book=0
		and exp_owner_id = 0;


VAR_BOOK_ID int;
VAR_CPTPTY_ID int;

OWNERNAME_IN_CUR varchar2(100);

BEGIN
	
	VAR_BOOK_ID := 0;
	VAR_CPTPTY_ID := 0;
  
	FOR ccypair_book in cur_ccypair_book
		LOOP
			OWNERNAME_IN_CUR:=ccypair_book.exp_owner_name;
	
			BEGIN
				SELECT book_id into VAR_BOOK_ID from book where book_name=OWNERNAME_IN_CUR;
			END;
      
			IF VAR_BOOK_ID > 0 THEN
				BEGIN
					UPDATE PK_CONFIG_CCYPAIR_EXP_OWNER
					set exp_owner_id=VAR_BOOK_ID
					where is_exp_owner_book=1
					and exp_owner_name=OWNERNAME_IN_CUR;
					
					COMMIT;
				END;
			END IF;
		END LOOP;
	
	VAR_BOOK_ID := 0;
	OWNERNAME_IN_CUR := '';
	
	FOR risky_book in cur_riskyccy_book
		LOOP
			OWNERNAME_IN_CUR:=risky_book.exp_owner_name;
	
			BEGIN
				SELECT book_id into VAR_BOOK_ID from book where book_name=OWNERNAME_IN_CUR;
			END;
      
			IF VAR_BOOK_ID > 0 THEN
				BEGIN
					UPDATE PK_CONFIG_RISKYCCY_EXP_OWNER
					set exp_owner_id=VAR_BOOK_ID
					where is_exp_owner_book=1
					and exp_owner_name=OWNERNAME_IN_CUR;
					
					COMMIT;
				END;
			END IF;
		END LOOP;
	
	VAR_BOOK_ID := 0;
	OWNERNAME_IN_CUR := '';

FOR ccyfunding_book in cur_ccyfunding_book
		LOOP
			OWNERNAME_IN_CUR:=ccyfunding_book.exp_owner_name;
	
			BEGIN
				SELECT book_id into VAR_BOOK_ID from book where book_name=OWNERNAME_IN_CUR;
			END;
      
			IF VAR_BOOK_ID > 0 THEN
				BEGIN
					UPDATE PK_CONFIG_CCYFUNDING_EXP_OWNER
					set exp_owner_id=VAR_BOOK_ID
					where is_exp_owner_book=1
					and exp_owner_name=OWNERNAME_IN_CUR;
					
					COMMIT;
				END;
			END IF;
		END LOOP;

	VAR_CPTPTY_ID := 0;
	OWNERNAME_IN_CUR := '';

FOR ccyfunding_ctpty in cur_ccyfunding_ctpty
		LOOP
			OWNERNAME_IN_CUR:=ccyfunding_ctpty.exp_owner_name;
	
			BEGIN
				SELECT LEGAL_ENTITY_ID into VAR_CPTPTY_ID from LEGAL_ENTITY where short_name=OWNERNAME_IN_CUR AND LE_STATUS='Enabled';
			END;
      
			IF VAR_CPTPTY_ID > 0 THEN
				BEGIN
					UPDATE PK_CONFIG_CCYFUNDING_EXP_OWNER
					set exp_owner_id=VAR_CPTPTY_ID
					where is_exp_owner_book=0
					and exp_owner_name=OWNERNAME_IN_CUR;
					
					COMMIT;
				END;
			END IF;
		END LOOP;


		
END UPDATE_PK_CONFIGS_OWNER_IDS;
/
begin
UPDATE_PK_CONFIGS_OWNER_IDS;
end;
/
drop procedure UPDATE_PK_CONFIGS_OWNER_IDS
;
UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='000',
        version_date=TO_DATE('01/07/2016','DD/MM/YYYY')
;
