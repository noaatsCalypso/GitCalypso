CREATE OR REPLACE PROCEDURE add_col_cf_mk_header_jobid  
AS
  x integer := 0;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name='CONVERSION_FACTOR_MARK' and column_name='JOB_ID';
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'alter table CONVERSION_FACTOR_MARK add (JOB_ID NUMBER default 0)' ;
    END IF;
END;
/

begin
add_col_cf_mk_header_jobid;
end;
/

CREATE OR REPLACE PROCEDURE  add_col_cf_mk_header_ts   
AS
 x integer := 0;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name='CONVERSION_FACTOR_MARK' and column_name='ENTERED_DATETIME';
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'alter table CONVERSION_FACTOR_MARK add (ENTERED_DATETIME TIMESTAMP default sysdate)' ;
    END IF;
END;
/

begin
add_col_cf_mk_header_ts;
end;
/
create or replace procedure fill_cfactor_mark_header as
  k integer :=0;
  x integer := 0;
  y integer := 0;
  l_single_quote CHAR(1) := '''';
  sql_stmt  VARCHAR2(10000); 
  USER_NAME  VARCHAR2(100) default 'calypso_user'; 
     begin      
			select count(*) into x from user_tables where table_name='CONVERSION_FACTOR_MARK';
			DBMS_OUTPUT.PUT_LINE('checking the CONVERSION_FACTOR_MARK EXIST. '|| x);
			select count(*) INTO y FROM user_tables WHERE table_name='CONVERSION_FACTOR_MARK_HEADER' ;
			DBMS_OUTPUT.PUT_LINE('checking the CONVERSION_FACTOR_MARK_HEADER EXIST. '|| y );	
	
  IF (y > 0 and x > 0 )
  THEN
  	  select count(*) into k from CONVERSION_FACTOR_MARK;
  	  IF (k!=0 )
  	    THEN
			DBMS_OUTPUT.PUT_LINE('creating CONVERSION_FACTOR_MARK back up table.');
			EXECUTE IMMEDIATE ' create table c_mark_back_up as select * from CONVERSION_FACTOR_MARK ';
	    
			sql_stmt :=' INSERT INTO CONVERSION_FACTOR_MARK_HEADER(VALUATION_DATE,PL_CONFIG_ID,JOB_ID,ENTERED_DATETIME ) SELECT VALUATION_DATE, PL_CONFIG_ID,MAX(JOB_ID),MAX(ENTERED_DATETIME)  FROM CONVERSION_FACTOR_MARK GROUP BY VALUATION_DATE, PL_CONFIG_ID ';	
			DBMS_OUTPUT.PUT_LINE('Copying data from CONVERSION_FACTOR_MARK To CONVERSION_FACTOR_MARK_HEADER .');
			EXECUTE IMMEDIATE sql_stmt ;
	    
			DBMS_OUTPUT.PUT_LINE(' Updating the CONVERSION_FACTOR_MARK_HEADER user name ');
			sql_stmt := 'UPDATE CONVERSION_FACTOR_MARK_HEADER SET USER_NAME = '|| l_single_quote||USER_NAME||l_single_quote ;
			
			EXECUTE IMMEDIATE sql_stmt ;    
	  END IF; 
	  
	 END IF;  
END;
/ 

BEGIN
fill_cfactor_mark_header;
end;
/
drop procedure add_col_cf_mk_header_ts
;

drop procedure add_col_cf_mk_header_jobid
;

drop procedure fill_cfactor_mark_header
;
