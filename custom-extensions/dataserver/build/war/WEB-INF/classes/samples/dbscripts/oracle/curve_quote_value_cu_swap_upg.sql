set serveroutput on size 1000000
spool outputFile.sql


DECLARE 

CURSOR  curve_quote_crsr IS
SELECT  quote_name,curve_id
FROM curve_quote_value
WHERE quote_name like 'Swap%'  
FOR UPDATE OF quote_name
;


curveQuoteName VARCHAR(255);
tmpCurveQuoteName VARCHAR(255);
tmp_basis_swap_search VARCHAR(255);
tmp_maturity_tenorstr VARCHAR(255);
tmp_maturity_tenor int;
countvar int;
tmp_currency VARCHAR(255);
tmp_rate_index VARCHAR(255);
tmp_tenor VARCHAR(255);
tmp_second_tenor VARCHAR(255);
fixed_cpn_freq VARCHAR(255);
source_name VARCHAR(255);
curve_idVar int;
newCurveQuoteName VARCHAR(255);
swapRateIndex VARCHAR(255);
curvestr VARCHAR(255);
rate_indexvar VARCHAR(255);
str1 VARCHAR(2000);

BEGIN

DBMS_OUTPUT.PUT_LINE('came here');

FOR tab_rec in curve_quote_crsr LOOP
Begin
curveQuoteName:=tab_rec.quote_name;
curve_idVar:=tab_rec.curve_id;
		 tmpCurveQuoteName:=curveQuoteName;
		

		 tmp_basis_swap_search:=SUBSTR(curveQuoteName,INSTR(curveQuoteName,'/')+1 ,LENGTH(curveQuoteName)-INSTR(curveQuoteName,'/') );

		

	IF (INSTR(tmp_basis_swap_search,'.') > 0 ) THEN 
	

	
		 tmp_basis_swap_search:=SUBSTR(curveQuoteName,INSTR('/',curveQuoteName)+1 ,LENGTH(curveQuoteName)-INSTR('/',curveQuoteName) );
	end	IF	;
	
		SELECT rate_index_code into rate_indexvar from rate_index where rate_index_code=tmp_basis_swap_search;
		EXCEPTION
		WHEN NO_DATA_FOUND THEN
			tmpCurveQuoteName:=SUBSTR(tmpCurveQuoteName,INSTR(tmpCurveQuoteName,'.')+1 ,LENGTH(tmpCurveQuoteName)-INSTR(tmpCurveQuoteName,'.') );			
			tmp_maturity_tenorstr:=SUBSTR(tmpCurveQuoteName,1 ,INSTR(tmpCurveQuoteName,'.')-1);
			IF ((INSTR(tmp_maturity_tenorstr,'Y')-1) > 0 ) THEN
			tmp_maturity_tenor:=TO_NUMBER(SUBSTR(tmp_maturity_tenorstr,1,INSTR(tmp_maturity_tenorstr,'Y')-1)) * 360;
			END IF;
			IF ((INSTR(tmp_maturity_tenorstr,'M')-1) > 0 ) THEN
			tmp_maturity_tenor:=TO_NUMBER(SUBSTR(tmp_maturity_tenorstr,1,INSTR(tmp_maturity_tenorstr,'M')-1)) * 30;
			END IF;					
			IF ((INSTR(tmp_maturity_tenorstr,'W')-1) > 0 ) THEN
			tmp_maturity_tenor:=TO_NUMBER(SUBSTR(tmp_maturity_tenorstr,1,INSTR(tmp_maturity_tenorstr,'W')-1)) * 7;			
			END IF;

			/*DBMS_OUTPUT.PUT_LINE( tmp_maturity_tenor*/
			/*********************/
			/* get the currency  */
			/*********************/	
			
			
			tmpCurveQuoteName:=SUBSTR(tmpCurveQuoteName,INSTR(tmpCurveQuoteName,'.')+1 ,LENGTH(tmpCurveQuoteName)-INSTR(tmpCurveQuoteName,'.') ) ;							
			
					
			tmp_currency:=SUBSTR(tmpCurveQuoteName,1,INSTR(tmpCurveQuoteName,'.')-1);/* remove the currency  */			

			/*********************/
			/* get the rate index  */
			/*********************/
			tmpCurveQuoteName:=SUBSTR(tmpCurveQuoteName,INSTR(tmpCurveQuoteName,'.')+1 ,LENGTH(tmpCurveQuoteName)-INSTR(tmpCurveQuoteName,'.') ); /* get the rate index  */
			tmp_rate_index:=SUBSTR(tmpCurveQuoteName,1,INSTR(tmpCurveQuoteName,'.')-1);		/* remove the rate index  */


			/*********************/
			/* get the tenor  */
			/*********************/			
			tmpCurveQuoteName:=SUBSTR(tmpCurveQuoteName,INSTR(tmpCurveQuoteName,'.')+1 ,LENGTH(tmpCurveQuoteName)-INSTR(tmpCurveQuoteName,'.') ); 			
					
			if (INSTR(tmpCurveQuoteName,'.') <=0 ) THEN 
			tmp_tenor:=tmpCurveQuoteName;
			End if ;
					 
			if (INSTR(tmpCurveQuoteName,'.') > 0 )THEN 
			tmp_tenor:=SUBSTR(tmpCurveQuoteName,1,INSTR(tmpCurveQuoteName,'.'));
			End if ;

			/*********************/
			/* get the fixed cpn freq  */
			/*********************/			
			tmp_second_tenor:=SUBSTR(tmp_tenor,INSTR(tmp_tenor,'/')+1 ,LENGTH(tmp_tenor)-INSTR(tmp_tenor,'/') );


			/* remove the second tenor from tmp_tenor*/
			tmp_tenor:=SUBSTR(tmp_tenor,1,INSTR(tmpCurveQuoteName,'/')-1);

						
						
			fixed_cpn_freq:=SUBSTR(tmp_second_tenor,1,2); 				
					
					
			/*********************/
			/**tmp_cu_swap operations */
			/* Generate the Rate index compatible with tmp_cu_swap   */
			/*********************/
			/* convert the fixed coupon frequency compatible with curve quote value */
			if (fixed_cpn_freq='1W') THEN 			
			fixed_cpn_freq:='WK';
			End if; 
			if (fixed_cpn_freq='15D') THEN 			
			fixed_cpn_freq:='BIWK' ;
			End if; 	    	  
			if (fixed_cpn_freq='1M' )   THEN 			
			fixed_cpn_freq:='MTH' ;
			End if;  	    	  
			if (fixed_cpn_freq='2M')   THEN 			 
			fixed_cpn_freq:='BIM' ;
			End if;  	    	  
			if (fixed_cpn_freq='3M')   THEN 			 
			fixed_cpn_freq:='QTR' ;
			End if;  	    	  
			if (fixed_cpn_freq='6M')   THEN 			 
			fixed_cpn_freq:='SA' ;
			End if ;
			if (fixed_cpn_freq='1Y' )   THEN 			
			fixed_cpn_freq:='PA' ;
			End if; 	    	  
			/* Get the Source Name   */
			/* Generate the Rate Index Name   */	
			swapRateIndex:=tmp_currency||'/'||tmp_rate_index||'/'|| tmp_tenor;
						
						
			swapRateIndex:=swapRateIndex || '%';
			

			
			
			SELECT distinct rate_index into source_name  from cu_swap,curve_member,curve_quote_value WHERE 		
			curve_member.curve_id=curve_quote_value.curve_id
			AND curve_quote_value.curve_id=curve_idVar
			AND	curve_member.cu_id=cu_swap.cu_id 
			AND rate_index like swapRateIndex
			AND cu_swap.fixed_cpn_freq=fixed_cpn_freq
			AND maturity_tenor=tmp_maturity_tenor;

						 
						
			source_name:=SUBSTR(source_name,INSTR(source_name,'/')+1 ,LENGTH(source_name)-INSTR(source_name,'/') ) ;
			source_name:=SUBSTR(source_name,INSTR(source_name,'/')+1 ,LENGTH(source_name)-INSTR(source_name,'/') ) ;		
			source_name:=SUBSTR(source_name,INSTR(source_name,'/')+1 ,LENGTH(source_name)-INSTR(source_name,'/') ) ;

			if (INSTR(tmpCurveQuoteName,'.') <= 0 ) then
				 newCurveQuoteName:=curveQuoteName||'.'||source_name;
				/* COMMENTED FOR NOW   */		
				/* Update the New Curve Quote Name   */		
				UPDATE curve_quote_value 
				SET quote_name=newCurveQuoteName
				WHERE CURRENT OF curve_quote_crsr ;
			end If;
END;

		
		
		
		
		
		

		 countvar:=countvar+1;
	
		
END LOOP;


END;
/
commit;
spool off 

