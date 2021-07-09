create or replace procedure sp_pl_methodology_driver as
  x integer := 0;
  y integer := 0;
  z integer := 0;
  pl_meth_driver VARCHAR2(32); 
  book_attr_name VARCHAR2(32); 
  begin      
		SELECT COUNT(DISTINCT pl_methodology_driver) INTO x FROM pl_methodology_config;
		DBMS_OUTPUT.PUT_LINE('checking the methodology driver(s) in pl_methodology_config. '|| x);
		SELECT count(*) INTO y FROM book_attribute WHERE is_pl_methodology_driver = 1;
		DBMS_OUTPUT.PUT_LINE('checking pl methodology driver book attribute exist. '|| y );	
	
  IF x > 1 THEN
      DBMS_OUTPUT.PUT_LINE('Error occured - Found multiple methodology drivers in pl_methodology_config table');
  END IF;	
  
  IF y > 1 THEN
        DBMS_OUTPUT.PUT_LINE('Error occured - there should be only one book attribute set to pl methodology driver in book_attribute table');
  END IF;
  
  IF x = 1 THEN
  	SELECT DISTINCT pl_methodology_driver INTO pl_meth_driver FROM pl_methodology_config;
  	DBMS_OUTPUT.PUT_LINE('Methodology driver in pl_methodology_config - '|| pl_meth_driver);
  	
  	IF y = 0 THEN
  		SELECT count(*) INTO z FROM book_attribute WHERE attribute_name = pl_meth_driver;
  		IF z = 0 THEN
  			execute immediate 'INSERT INTO book_attribute(attribute_name,is_pl_methodology_driver) VALUES (' ||chr(39)||pl_meth_driver||chr(39)|| ', 1)';  
  		ELSIF z = 1 THEN
			execute immediate 'UPDATE book_attribute SET is_pl_methodology_driver = 1 WHERE attribute_name = ' ||chr(39)||pl_meth_driver||chr(39);
  		END IF;
  	ELSIF y = 1 THEN
  	  SELECT attribute_name INTO book_attr_name FROM book_attribute WHERE is_pl_methodology_driver = 1;
	  DBMS_OUTPUT.PUT_LINE('Pl methodology driver book attribute - '|| book_attr_name);	
  	
	  IF (pl_meth_driver != book_attr_name) THEN
	  	DBMS_OUTPUT.PUT_LINE('Error occured - Pl methodology driver in pl_methodology_config table do not match Pl methodology driver book attribute');
	  ELSE
	  	DBMS_OUTPUT.PUT_LINE('Pl methodology driver in pl_methodology_config table match Pl methodology driver book attribute');
	  END IF;
  	END IF;  
  END IF;  
END; 
/

begin
sp_pl_methodology_driver;
end;
/

drop procedure sp_pl_methodology_driver
;
