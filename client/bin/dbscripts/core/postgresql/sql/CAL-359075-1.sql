CREATE OR REPLACE FUNCTION SP_PL_METHODOLOGY_DRIVER
()
RETURNS void LANGUAGE plpgsql
AS $BODY$
declare
	x   			integer;         
    y      			integer;   
    z               integer;     
    pl_meth_driver  VARCHAR;
    book_attr_name  VARCHAR;
BEGIN        
    SELECT COUNT(DISTINCT pl_methodology_driver) INTO x FROM pl_methodology_config;
    SELECT count(*) INTO y FROM book_attribute WHERE is_pl_methodology_driver = 1;
                
  IF x > 1 THEN
      RAISE Exception 'Error occured - Found multiple methodology drivers in pl_methodology_config table';
  END IF;               
  
  IF y > 1 THEN
        RAISE Exception 'Error occured - Found multiple book attribute set to pl methodology driver in book_attribute table';
  END IF;
  
  IF x = 1 THEN
  		SELECT DISTINCT pl_methodology_driver INTO pl_meth_driver FROM pl_methodology_config;
                
       	IF y = 0 THEN
        	SELECT count(*) INTO z FROM book_attribute WHERE attribute_name = pl_meth_driver;
           	IF z = 0 THEN
            	INSERT INTO book_attribute(attribute_name,is_pl_methodology_driver) VALUES ( pl_meth_driver , 1);  
           	ELSIF z = 1 THEN
          		UPDATE book_attribute SET is_pl_methodology_driver = 1 WHERE attribute_name =  pl_meth_driver;
            END IF;
    	ELSIF y = 1 THEN
        	SELECT attribute_name INTO book_attr_name FROM book_attribute WHERE is_pl_methodology_driver = 1;           
            IF (pl_meth_driver != book_attr_name) THEN
            	RAISE Exception 'Error occured - Pl methodology driver in pl_methodology_config table do not match Pl methodology driver book attribute';
           	ELSE
               RAISE NOTICE 'Pl methodology driver in pl_methodology_config table match Pl methodology driver book attribute';
            END IF;
       	END IF;  
  END IF; 
END;                                                                                                                                                                                                                                                                                                                                        
$BODY$
;

DO $$ begin
    perform SP_PL_METHODOLOGY_DRIVER();
end$$;

drop function SP_PL_METHODOLOGY_DRIVER()
;
