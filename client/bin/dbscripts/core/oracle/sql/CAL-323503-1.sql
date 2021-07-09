create or replace procedure lpl_greeks_curve_migrate as
 maxCount integer := 0;
begin  
  SELECT nvl(max(length(DATA_KEY)),0) into maxCount  FROM live_pl_greeks_curve;
 
  IF (maxCount <=300 ) 
  THEN
   EXECUTE IMMEDIATE  'ALTER TABLE live_pl_greeks_curve MODIFY data_key VARCHAR2(300)';  
  END IF;    
END; 
/ 
BEGIN
   lpl_greeks_curve_migrate;
  END;
/ 


create or replace procedure lpl_greeks_recovery_migrate as
 maxCount integer := 0;
begin  
  SELECT nvl(max(length(DATA_KEY)),0) into maxCount  FROM live_pl_greeks_recovery;
 
  IF (maxCount <=300 ) 
  THEN
   EXECUTE IMMEDIATE  'ALTER TABLE live_pl_greeks_recovery MODIFY data_key VARCHAR2(300)';
   END IF;    
END; 
/ 
BEGIN
   lpl_greeks_recovery_migrate;
 END;
/ 

create or replace procedure lpl_greeks_vol_migrate as
 maxCount integer := 0;
begin  
  SELECT nvl(max(length(DATA_KEY)),0) into maxCount  FROM live_pl_greeks_vol; 

  IF (maxCount <=300 ) 
  THEN
   EXECUTE IMMEDIATE  'ALTER TABLE live_pl_greeks_vol MODIFY data_key VARCHAR2(300)';
   END IF;    
 
END; 

/
 BEGIN
   lpl_greeks_vol_migrate;
  END;
/    


create or replace procedure lpl_greeks_vol_ul_migrate as
 maxCount integer := 0;
begin  
  SELECT nvl(max(length(DATA_KEY)),0) into maxCount  FROM live_pl_greeks_vol_underlying;
 
  IF (maxCount <=300 ) 
  THEN
   EXECUTE IMMEDIATE  'ALTER TABLE live_pl_greeks_vol_underlying MODIFY data_key VARCHAR2(300)';
   END IF;
END; 

/
 BEGIN
   lpl_greeks_vol_ul_migrate;
  END;
/    


create or replace procedure lpl_greeks_quote_migrate as
 maxCount integer := 0;
begin  
  SELECT nvl(max(length(DATA_KEY)),0) into maxCount  FROM live_pl_greeks_quote;
 
 
  IF (maxCount <=300 ) 
  THEN
   EXECUTE IMMEDIATE  'ALTER table live_pl_greeks_quote MODIFY data_key VARCHAR2(300)';
   END IF;    
END;

/ 
BEGIN
   lpl_greeks_quote_migrate;
 END;
/    
