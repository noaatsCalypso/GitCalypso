/* Bug No 10387 */ 
/* default quote name for ETO needs to include contract name rather then underlying name */
/* This Script has to be Run only once and using SQLPLUS */
/* Also have to make sure there is one ETO Contract per Exchange */
set serveroutput on size 1000000
spool output.sql

DECLARE 

CURSOR  quote_crsr is
	SELECT  quote_name
	FROM quote_value
	WHERE quote_name like 'ETOEquity.%'  
	or quote_name like 'ETOEquityIndex.%'  
	FOR UPDATE OF quote_name
;

 QuoteName VARCHAR(255);
 tmpQuoteName VARCHAR(255);
 tmpQuoteName1 VARCHAR(255);
 exchangeName VARCHAR(255);
 contractName VARCHAR(255);
 remaningPart VARCHAR(255);
 secondPart VARCHAR(255);
 firstPart VARCHAR(255);
 newQuoteName VARCHAR(255);
 countvar int;
 curve_id int;

BEGIN
 countvar:=0;

FOR tab_rec in quote_crsr LOOP

	 QuoteName:=tab_rec.quote_name;
	 tmpQuoteName1:=QuoteName;

	DBMS_OUTPUT.PUT_LINE(  'tmpQuoteName1');
	DBMS_OUTPUT.PUT_LINE(  tmpQuoteName1);

	firstPart:=substr(tmpQuoteName1,1,instr(tmpQuoteName1,'.')-1);

	DBMS_OUTPUT.PUT_LINE(  'firstPart');
	DBMS_OUTPUT.PUT_LINE(  firstPart);


	 tmpQuoteName:=substr(QuoteName,instr(QuoteName,'.')+1 ,length(QuoteName)-instr(QuoteName,'.') );

	DBMS_OUTPUT.PUT_LINE(  'tmpQuoteName');
	DBMS_OUTPUT.PUT_LINE(  tmpQuoteName);


	 tmpQuoteName1:=tmpQuoteName;

	 secondPart:=substr(tmpQuoteName1,1,instr(tmpQuoteName1,'.')-1);

	DBMS_OUTPUT.PUT_LINE(  'secondPart');
	DBMS_OUTPUT.PUT_LINE(  secondPart);


	 remaningPart:=substr(tmpQuoteName1,instr(tmpQuoteName1,'.')+1 ,length(tmpQuoteName1)-instr(tmpQuoteName1,'.') );

	DBMS_OUTPUT.PUT_LINE(  'remaningPart 1');
	DBMS_OUTPUT.PUT_LINE(  remaningPart);


	 remaningPart:=substr(remaningPart,instr(remaningPart,'.')+1 ,length(remaningPart)-instr(remaningPart,'.') );

	DBMS_OUTPUT.PUT_LINE(  'remaningPart 2');
	DBMS_OUTPUT.PUT_LINE(  remaningPart);


	 tmpQuoteName:=substr(tmpQuoteName,instr(tmpQuoteName,'.')+1 ,length(tmpQuoteName)-instr(tmpQuoteName,'.') ); 				

	DBMS_OUTPUT.PUT_LINE(  'tmpQuoteName ');
	DBMS_OUTPUT.PUT_LINE(  tmpQuoteName);

	 exchangeName:=substr(tmpQuoteName,1,instr(tmpQuoteName,'.')-1);

	DBMS_OUTPUT.PUT_LINE(  'exchangeName ');
	DBMS_OUTPUT.PUT_LINE(  exchangeName);


	SELECT  contract_name into contractName From eto_contract,legal_entity  WHERE short_name=exchangeName AND eto_contract.exchange_id=legal_entity.legal_entity_id;

	DBMS_OUTPUT.PUT_LINE(  'contractName');
	DBMS_OUTPUT.PUT_LINE(  contractName);


	newQuoteName:=firstPart||'.'||secondPart||'.'||contractName||'.'||remaningPart;

	DBMS_OUTPUT.PUT_LINE(  'newQuoteName');
	DBMS_OUTPUT.PUT_LINE(  newQuoteName);

	UPDATE quote_value
	SET quote_name=newQuoteName
	WHERE CURRENT OF quote_crsr ;

	UPDATE product_desc
	SET quote_name=newQuoteName
	WHERE quote_name=QuoteName;

END LOOP;


END;
/
spool off 



