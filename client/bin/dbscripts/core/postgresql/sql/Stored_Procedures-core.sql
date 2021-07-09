create or replace function instr(str text, sub text, startpos int = 1, occurrence int = 1)
returns int language plpgsql
as $BODY$
declare 
    tail text;
    shift int;
    pos int;
    i int;
begin
    shift:= 0;
    if startpos = 0 or occurrence <= 0 then
        return 0;
    end if;
    if startpos < 0 then
        str:= reverse(str);
        sub:= reverse(sub);
        pos:= -startpos;
    else
        pos:= startpos;
    end if;
    for i in 1..occurrence loop
        shift:= shift+ pos;
        tail:= substr(str, shift);
        pos:= strpos(tail, sub);
        if pos = 0 then
            return 0;
        end if;
    end loop;
    if startpos > 0 then
        return pos+ shift- 1;
    else
        return length(str)- pos- shift+ 1;
    end if;
end $BODY$;
;


create or replace view rate_index_string_value as select rate_index_id,
replace(substr(quote_name, instr(quote_name, '.', 1, 1) + 1), '.', '/') string_value
from rate_index
;

CREATE OR REPLACE function sp_analysis_out_permp (p_id IN INT)
RETURNS INT language plpgsql
AS $BODY$
BEGIN
	UPDATE analysis_output_perm_pages p1 
	SET page_number = ( SELECT rnum FROM ( SELECT page_id, row_number() 
			OVER (ORDER BY page_id) -1 rnum 
			FROM analysis_output_perm_pages 
			WHERE id = p_id AND page_number<>-1) 
		p2 WHERE p1.page_id = p2.page_id ) 
	where p1.id = p_id AND p1.page_number <> -1;
RETURN 0;
END;
$BODY$;
;

CREATE OR REPLACE FUNCTION custom_rule_discriminator (name IN varchar) 
RETURNS varchar LANGUAGE plpgsql
AS $BODY$
BEGIN
IF position('MessageRule' in name) <> 1 THEN
RETURN 'MessageRule';
ELSIF position('TradeRule' in name) <> 1 THEN
RETURN 'TradeRule';
ELSIF position(name in 'TransferRule') <> 1 THEN
RETURN 'TransferRule';
ELSIF position(name in 'WorkflowRule') <> 1 THEN
RETURN 'WorkflowRule';
ELSE
RETURN 'error';
END IF;
END;
$BODY$
;

create or replace view rate_index_string_value as select rate_index_id,
replace(substr(quote_name, instr(quote_name, '.', 1, 1) + 1), '.', '/') string_value
from rate_index
;

CREATE OR REPLACE FUNCTION sp_insert_official_pl_bucket
     (  p_PL_BUCKET_ID        IN  INT,
        p_LEG                 IN  varchar,
        p_LOCATION            IN  varchar,
        p_STRIP_DATE          IN  timestamp,
        p_SUBPRODUCT_ID       IN  INT,
        p_SUBPRODUCT_TYPE     IN  varchar,
        p_SUBPRODUCT_SUB_TYPE IN  varchar,
        p_SUBPRODUCT_EXTENDED_TYPE IN  varchar,
        p_EXISTING_PL_BUCKET_ID OUT INT)
RETURNS INT LANGUAGE plpgsql
AS $BODY$
BEGIN
	insert into official_pl_bucket
               (pl_bucket_id, leg, location, strip_date, subproduct_id, subproduct_type,  subproduct_sub_type, subproduct_extended_type)
        values (p_PL_BUCKET_ID, p_LEG, p_LOCATION, p_STRIP_DATE, p_SUBPRODUCT_ID, p_SUBPRODUCT_TYPE,  p_SUBPRODUCT_SUB_TYPE, p_SUBPRODUCT_EXTENDED_TYPE);

	p_EXISTING_PL_BUCKET_ID = p_PL_BUCKET_ID;
	
EXCEPTION 
	WHEN unique_violation THEN
			SELECT  
			      pl_bucket_id
			INTO
			      p_EXISTING_PL_BUCKET_ID
			FROM   	official_pl_bucket
			WHERE (leg = p_LEG OR ((leg IS NULL) AND (p_LEG IS NULL)))
			AND	(location = p_LOCATION OR ((location IS NULL) AND (p_LOCATION IS NULL)))
			AND	(strip_date = p_STRIP_DATE OR ((strip_date IS NULL) AND (p_STRIP_DATE IS NULL)))
			AND	(subproduct_id = p_SUBPRODUCT_ID OR ((subproduct_id IS NULL) AND (p_SUBPRODUCT_ID IS NULL)))
			AND	(subproduct_type = p_SUBPRODUCT_TYPE OR ((subproduct_type IS NULL) AND (p_SUBPRODUCT_TYPE IS NULL)))
			AND	(subproduct_sub_type = p_SUBPRODUCT_SUB_TYPE OR ((subproduct_sub_type IS NULL) AND (p_SUBPRODUCT_SUB_TYPE IS NULL)))
			AND	(subproduct_extended_type = p_SUBPRODUCT_EXTENDED_TYPE OR ((subproduct_extended_type IS NULL) AND (p_SUBPRODUCT_EXTENDED_TYPE IS NULL)));
			p_EXISTING_PL_BUCKET_ID = p_PL_BUCKET_ID;

        WHEN others THEN
			RAISE 'Failed to add bulk_id: %', p_PL_BUCKET_ID;
END; 
$BODY$
;

CREATE OR REPLACE FUNCTION SP_INSERT_OFFICIAL_PL_UNIT
     ( 
        p_PL_UNIT_ID          IN  INT,                
        p_BOOK_ID             IN  INT,                  
        p_STRATEGY            IN  VARCHAR, 
        p_TRADER              IN  VARCHAR, 
        p_DESK                IN  VARCHAR, 
        p_CURRENCY            IN  VARCHAR,                
        p_CURRENCY_PAIR       IN  VARCHAR,                
        p_PO_ID               IN  INT,                
        p_IS_BY_TRADE         IN  INT,
        p_EXISTING_PL_UNIT_ID OUT INT
     )  
RETURNS INT LANGUAGE plpgsql
AS $BODY$
BEGIN  
	
	INSERT INTO OFFICIAL_PL_UNIT 
		(PL_UNIT_ID,BOOK_ID,STRATEGY,TRADER,DESK,
		CURRENCY,CURRENCY_PAIR,PO_ID,IS_BY_TRADE) 
	VALUES 
		(p_PL_UNIT_ID,p_BOOK_ID,p_STRATEGY,p_TRADER,p_DESK,
		p_CURRENCY,p_CURRENCY_PAIR,p_PO_ID,p_IS_BY_TRADE);
		
	p_EXISTING_PL_UNIT_ID = p_PL_UNIT_ID;
EXCEPTION 
        WHEN unique_violation THEN
          SELECT  
              PL_UNIT_ID
          INTO
                p_PL_UNIT_ID
          FROM   	OFFICIAL_PL_UNIT
          WHERE 	(BOOK_ID = p_BOOK_ID OR ((BOOK_ID IS NULL) AND (p_BOOK_ID IS NULL)))
          AND		(STRATEGY = p_STRATEGY OR ((STRATEGY IS NULL) AND (p_STRATEGY IS NULL)))
          AND		(TRADER = p_TRADER OR ((TRADER IS NULL) AND (p_TRADER IS NULL)))
          AND		(DESK = p_DESK OR ((DESK IS NULL) AND (p_DESK IS NULL)))
          AND  		CURRENCY = p_CURRENCY
          AND		(CURRENCY_PAIR = p_CURRENCY_PAIR OR ((CURRENCY_PAIR IS NULL) AND (p_CURRENCY_PAIR IS NULL)))
          AND		PO_ID = p_PO_ID
          AND		IS_BY_TRADE = p_IS_BY_TRADE;
          
        p_EXISTING_PL_UNIT_ID = p_PL_UNIT_ID;
          
        WHEN OTHERS THEN
        	RAISE 'Error while inserting new plUnit.  PL_UNIT_ID=%', p_PL_UNIT_ID;
        	
END;																					  
$BODY$
;

DROP FUNCTION IF EXISTS SP_INS_OFFICIAL_PL_AGGREGATE
;

CREATE FUNCTION SP_INS_OFFICIAL_PL_AGGREGATE
     ( 
        p_AGG_ID              IN  BIGINT,                
        p_PL_CONFIG_ID        IN  INT, 
        p_BOOK_ID             IN  INT,                  
        p_PL_UNIT_ID          IN  INT, 
        p_ACTION_DATETIME     IN  timestamp without time zone, 
        p_EFFECTIVE_PRODUCT_TYPE  IN  VARCHAR,
		p_STRATEGY_ID         IN  INT,
        pEXISTING__AGG_ID 	  OUT BIGINT )
RETURNS BIGINT LANGUAGE plpgsql
AS $BODY$
BEGIN  
	
	INSERT INTO OFFICIAL_PL_AGGREGATE 
		(AGG_ID,PL_CONFIG_ID,BOOK_ID,PL_UNIT_ID,ACTION_DATETIME,
		EFFECTIVE_PRODUCT_TYPE,STRATEGY_ID) 
	VALUES 
		(p_AGG_ID,p_PL_CONFIG_ID,p_BOOK_ID,p_PL_UNIT_ID,p_ACTION_DATETIME,
		p_EFFECTIVE_PRODUCT_TYPE,p_STRATEGY_ID);
	
	pEXISTING__AGG_ID = p_AGG_ID;
	
EXCEPTION 
        WHEN unique_violation THEN
          SELECT  
              AGG_ID
          INTO
                p_AGG_ID
          FROM   	OFFICIAL_PL_AGGREGATE
          WHERE PL_CONFIG_ID = p_PL_CONFIG_ID 	
          AND   BOOK_ID = p_BOOK_ID
          AND   PL_UNIT_ID = p_PL_UNIT_ID
          AND  	EFFECTIVE_PRODUCT_TYPE = p_EFFECTIVE_PRODUCT_TYPE
          AND   STRATEGY_ID = p_STRATEGY_ID;
          
          pEXISTING__AGG_ID = p_AGG_ID;
        WHEN OTHERS THEN
             RAISE 'Error while inserting new opl aggregate.  AGG_ID=%', p_AGG_ID;  
END ; 
$BODY$
;

