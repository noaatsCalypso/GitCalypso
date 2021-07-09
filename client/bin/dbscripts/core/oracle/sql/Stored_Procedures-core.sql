CREATE OR REPLACE FUNCTION custom_rule_discriminator (name IN varchar2) RETURN varchar2
IS
BEGIN
IF instr(name,'MessageRule') <> 0 THEN
RETURN 'MessageRule';
ELSIF instr(name,'TradeRule') <> 0 THEN
RETURN 'TradeRule';
ELSIF instr(name,'TransferRule') <> 0 THEN
RETURN 'TransferRule';
ELSIF instr(name,'WorkflowRule') <> 0 THEN
RETURN 'WorkflowRule';
ELSE
RETURN 'error';
END IF;
END custom_rule_discriminator;
/

CREATE OR REPLACE PROCEDURE drop_function ( proc_name IN user_tab_columns.table_name%TYPE) AS
 x number;
BEGIN
   BEGIN
   SELECT count(*) into x FROM user_objects WHERE object_name=UPPER(proc_name) and object_type= 'FUNCTION';
   exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x > 0 THEN
       EXECUTE IMMEDIATE 'drop function '|| proc_name;
    END IF;
END drop_function;
/

begin
 drop_function ('rate_index_string_value');
end;
/

create or replace view rate_index_string_value as select rate_index_id,
replace(substr(quote_name, instr(quote_name, '.', 1, 1) + 1), '.', '/') string_value
from rate_index
;

create or replace procedure sp_trunc_temp_tables
as
begin
execute immediate 'truncate table TRADE_FILTER_PAGE' ;
execute immediate 'truncate table TF_TEMP_TABLE' ;
end;
/

CREATE OR REPLACE PROCEDURE sp_analysis_out_permp (arg_id   IN NUMBER )
AS BEGIN
UPDATE analysis_output_perm_pages p1 
SET page_number = ( SELECT rnum FROM ( SELECT page_id, row_number() 
OVER (ORDER BY page_id) -1 rnum 
FROM analysis_output_perm_pages 
WHERE id = arg_id AND page_number<>-1) 
p2 WHERE p1.page_id = p2.page_id ) 
where p1.id = arg_id AND p1.page_number <> -1;
END;
/

CREATE OR REPLACE PROCEDURE SP_INSERT_OFFICIAL_PL_BUCKET
     ( 
        p_PL_BUCKET_ID        IN  OFFICIAL_PL_BUCKET.PL_BUCKET_ID%TYPE,                
        p_LEG                 IN  OFFICIAL_PL_BUCKET.LEG%TYPE,                  
        p_LOCATION            IN  OFFICIAL_PL_BUCKET.LOCATION%TYPE, 
        p_STRIP_DATE          IN  OFFICIAL_PL_BUCKET.STRIP_DATE%TYPE, 
        p_SUBPRODUCT_ID       IN  OFFICIAL_PL_BUCKET.SUBPRODUCT_ID%TYPE, 
        p_SUBPRODUCT_TYPE     IN  OFFICIAL_PL_BUCKET.SUBPRODUCT_TYPE%TYPE,                
        p_SUBPRODUCT_SUB_TYPE IN  OFFICIAL_PL_BUCKET.SUBPRODUCT_SUB_TYPE%TYPE,                
        p_SUBPRODUCT_EXTENDED_TYPE IN  OFFICIAL_PL_BUCKET.SUBPRODUCT_EXTENDED_TYPE%TYPE,
        p_EXISTING_PL_BUCKET_ID OUT OFFICIAL_PL_BUCKET.PL_BUCKET_ID%TYPE
     )
AS 
BEGIN  
	
	INSERT INTO OFFICIAL_PL_BUCKET 
		(PL_BUCKET_ID,LEG,LOCATION,STRIP_DATE,
		SUBPRODUCT_ID,SUBPRODUCT_TYPE,SUBPRODUCT_SUB_TYPE,SUBPRODUCT_EXTENDED_TYPE) 
	VALUES 
		(p_PL_BUCKET_ID,p_LEG,p_LOCATION,p_STRIP_DATE,
		p_SUBPRODUCT_ID,p_SUBPRODUCT_TYPE,p_SUBPRODUCT_SUB_TYPE,p_SUBPRODUCT_EXTENDED_TYPE) ;
	
	COMMIT;
	
	p_EXISTING_PL_BUCKET_ID := p_PL_BUCKET_ID;
	RETURN;
	
EXCEPTION 
        WHEN DUP_VAL_ON_INDEX THEN
			SELECT  
			      PL_BUCKET_ID
			INTO
			      p_EXISTING_PL_BUCKET_ID
			FROM   	OFFICIAL_PL_BUCKET
			WHERE (LEG = p_LEG OR ((LEG IS NULL) AND (p_LEG IS NULL)))
			AND		(LOCATION = p_LOCATION OR ((LOCATION IS NULL) AND (p_LOCATION IS NULL)))
			AND		(STRIP_DATE = p_STRIP_DATE OR ((STRIP_DATE IS NULL) AND (p_STRIP_DATE IS NULL)))
			AND		(SUBPRODUCT_ID = p_SUBPRODUCT_ID OR ((SUBPRODUCT_ID IS NULL) AND (p_SUBPRODUCT_ID IS NULL)))
			AND		(SUBPRODUCT_TYPE = p_SUBPRODUCT_TYPE OR ((SUBPRODUCT_TYPE IS NULL) AND (p_SUBPRODUCT_TYPE IS NULL)))
			AND		(SUBPRODUCT_SUB_TYPE = p_SUBPRODUCT_SUB_TYPE OR ((SUBPRODUCT_SUB_TYPE IS NULL) AND (p_SUBPRODUCT_SUB_TYPE IS NULL)))
			AND		(SUBPRODUCT_EXTENDED_TYPE = p_SUBPRODUCT_EXTENDED_TYPE OR ((SUBPRODUCT_EXTENDED_TYPE IS NULL) AND (p_SUBPRODUCT_EXTENDED_TYPE IS NULL)));
  
			RETURN;
        WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20001, 
                                     'Error while inserting new plBucket.  PL_BUCKET_ID=' 
                                     || p_PL_BUCKET_ID || ':$:' || SQLERRM, TRUE) ; 
END SP_INSERT_OFFICIAL_PL_BUCKET ; 
/

CREATE OR REPLACE PROCEDURE SP_INSERT_OFFICIAL_PL_UNIT
     ( 
        p_PL_UNIT_ID          IN  OFFICIAL_PL_UNIT.PL_UNIT_ID%TYPE,                
        p_BOOK_ID             IN  OFFICIAL_PL_UNIT.BOOK_ID%TYPE,                  
        p_STRATEGY            IN  OFFICIAL_PL_UNIT.STRATEGY%TYPE, 
        p_TRADER              IN  OFFICIAL_PL_UNIT.TRADER%TYPE, 
        p_DESK                IN  OFFICIAL_PL_UNIT.DESK%TYPE, 
        p_CURRENCY            IN  OFFICIAL_PL_UNIT.CURRENCY%TYPE,                
        p_CURRENCY_PAIR       IN  OFFICIAL_PL_UNIT.CURRENCY_PAIR%TYPE,                
        p_PO_ID               IN  OFFICIAL_PL_UNIT.PO_ID%TYPE,                
        p_IS_BY_TRADE         IN  OFFICIAL_PL_UNIT.IS_BY_TRADE%TYPE,
        p_EXISTING_PL_UNIT_ID OUT OFFICIAL_PL_UNIT.PL_UNIT_ID%TYPE
     )
AS 
BEGIN  
	
	INSERT INTO OFFICIAL_PL_UNIT 
		(PL_UNIT_ID,BOOK_ID,STRATEGY,TRADER,DESK,
		CURRENCY,CURRENCY_PAIR,PO_ID,IS_BY_TRADE) 
	VALUES 
		(p_PL_UNIT_ID,p_BOOK_ID,p_STRATEGY,p_TRADER,p_DESK,
		p_CURRENCY,p_CURRENCY_PAIR,p_PO_ID,p_IS_BY_TRADE);
	
	COMMIT;
	
	p_EXISTING_PL_UNIT_ID := p_PL_UNIT_ID;
	RETURN ;
EXCEPTION 
        WHEN DUP_VAL_ON_INDEX THEN
          SELECT  
              PL_UNIT_ID
          INTO
                p_EXISTING_PL_UNIT_ID
          FROM   	OFFICIAL_PL_UNIT
          WHERE 	(BOOK_ID = p_BOOK_ID OR ((BOOK_ID IS NULL) AND (p_BOOK_ID IS NULL)))
          AND		(STRATEGY = p_STRATEGY OR ((STRATEGY IS NULL) AND (p_STRATEGY IS NULL)))
          AND		(TRADER = p_TRADER OR ((TRADER IS NULL) AND (p_TRADER IS NULL)))
          AND		(DESK = p_DESK OR ((DESK IS NULL) AND (p_DESK IS NULL)))
          AND  		CURRENCY = p_CURRENCY
          AND		(CURRENCY_PAIR = p_CURRENCY_PAIR OR ((CURRENCY_PAIR IS NULL) AND (p_CURRENCY_PAIR IS NULL)))
          AND		PO_ID = p_PO_ID
          AND		IS_BY_TRADE = p_IS_BY_TRADE;
          
          RETURN;
        WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20001, 
                                     'Error while inserting new plUnit.  PL_UNIT_ID=' 
                                     || p_PL_UNIT_ID || ':$:' || SQLERRM, TRUE) ; 
END SP_INSERT_OFFICIAL_PL_UNIT ; 
/

CREATE OR REPLACE PROCEDURE SP_INS_OFFICIAL_PL_AGGREGATE
     ( 
        p_AGG_ID              IN  OFFICIAL_PL_AGGREGATE.AGG_ID%TYPE,                
        p_PL_CONFIG_ID        IN  OFFICIAL_PL_AGGREGATE.PL_CONFIG_ID%TYPE, 
        p_BOOK_ID             IN  OFFICIAL_PL_AGGREGATE.BOOK_ID%TYPE,                  
        p_PL_UNIT_ID          IN  OFFICIAL_PL_AGGREGATE.PL_UNIT_ID%TYPE, 
        p_ACTION_DATETIME     IN  OFFICIAL_PL_AGGREGATE.ACTION_DATETIME%TYPE, 
        p_EFFECTIVE_PRODUCT_TYPE  IN  OFFICIAL_PL_AGGREGATE.EFFECTIVE_PRODUCT_TYPE%TYPE,
        p_STRATEGY_ID         IN  OFFICIAL_PL_AGGREGATE.STRATEGY_ID%TYPE, 
        p_EXISTING_AGG_ID OUT OFFICIAL_PL_AGGREGATE.AGG_ID%TYPE
     )
AS 
BEGIN  
	
	INSERT INTO OFFICIAL_PL_AGGREGATE 
		(AGG_ID,PL_CONFIG_ID,BOOK_ID,PL_UNIT_ID,ACTION_DATETIME,
		EFFECTIVE_PRODUCT_TYPE,STRATEGY_ID) 
	VALUES 
		(p_AGG_ID,p_PL_CONFIG_ID,p_BOOK_ID,p_PL_UNIT_ID,p_ACTION_DATETIME,
		p_EFFECTIVE_PRODUCT_TYPE,p_STRATEGY_ID);
	
	COMMIT;
	
	p_EXISTING_AGG_ID := p_AGG_ID;
	RETURN ;
EXCEPTION 
        WHEN DUP_VAL_ON_INDEX THEN
          SELECT  
              AGG_ID
          INTO
                p_EXISTING_AGG_ID
          FROM   	OFFICIAL_PL_AGGREGATE
          WHERE PL_CONFIG_ID = p_PL_CONFIG_ID 	
          AND		BOOK_ID = p_BOOK_ID
          AND		PL_UNIT_ID = p_PL_UNIT_ID
          AND  	EFFECTIVE_PRODUCT_TYPE = p_EFFECTIVE_PRODUCT_TYPE
          AND	STRATEGY_ID = p_STRATEGY_ID;
          
          RETURN;
        WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20001, 
                                     'Error while inserting new opl aggregate.  AGG_ID=' 
                                     || p_AGG_ID || ':$:' || SQLERRM, TRUE) ; 
END SP_INS_OFFICIAL_PL_AGGREGATE ; 
/

/* add all new stored procs above this line. The following will compile all invalid objects */

DECLARE
begin
  FOR c1_rec IN (SELECT 'ALTER ' || decode(a.object_type,   'PACKAGE BODY',   'PACKAGE',   'TYPE BODY',   'TYPE', a.object_type) 
  || ' ' || a.object_name || decode(a.object_type,   'JAVA CLASS',   ' RESOLVE',   ' COMPILE') 
  || decode(a.object_type, 'PACKAGE BODY',' BODY', 'TYPE BODY','BODY') FullSql
          FROM user_objects a,(SELECT MAX(LEVEL) mylevel, object_id
             FROM public_dependency START WITH object_id IN
				(SELECT object_id FROM user_objects WHERE status = 'INVALID' and    object_type <> 'SYNONYM' )
				CONNECT BY object_id = PRIOR referenced_object_id
				GROUP BY object_id)b
			WHERE a.object_id = b.object_id(+) 
			AND a.status = 'INVALID'
			AND object_type <> 'SYNONYM' ORDER BY b.mylevel DESC,a.object_name ASC )
  LOOP
  begin
    execute immediate c1_rec.FullSql;
    exception
		when others then
					null;
  end;    
  end LOOP;
end;
/

begin
   execute immediate 'drop procedure sp_mcc_housekeeping';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/