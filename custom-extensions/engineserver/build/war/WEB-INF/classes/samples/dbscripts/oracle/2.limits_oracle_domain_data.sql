
declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='ERSLimitEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'ERSLimitEngine',' ' );
end if;
end;
/

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='ERSCreditEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'ERSCreditEngine',' ' );
end if;
end;
/

DELETE FROM ers_measure_parms
WHERE rowid not in
(SELECT MIN(rowid)
FROM ers_measure_parms
GROUP BY measure, parameter_name, parameter_value)
;

create or replace procedure sp_defaultERSMEASUREPARMS
as
BEGIN
   DECLARE xrowcounter NUMBER := 0;
   BEGIN
      BEGIN
         SELECT COUNT(*) INTO xrowcounter FROM ers_measure_parms WHERE measure = 'Settlement' and parameter_name = 'Flow Types' and parameter_value = 'PRINCIPAL';
      END;
   
      IF xrowcounter = 0 THEN
         BEGIN
            INSERT INTO ers_measure_parms(measure,parameter_name,parameter_value) VALUES ('Settlement', 'Flow Types', 'PRINCIPAL');
            COMMIT;
         END;
      END IF;

      BEGIN
         SELECT COUNT(*) INTO xrowcounter FROM ers_measure_parms WHERE measure = 'Settlement' and parameter_name = 'Ignore CLS' and parameter_value = 'No';
      END;
      
      IF xrowcounter = 0 THEN
         BEGIN
            INSERT INTO ers_measure_parms(measure,parameter_name,parameter_value) VALUES ('Settlement', 'Ignore CLS', 'No');
            COMMIT;
         END;
      END IF;
   END;
END sp_defaultERSMEASUREPARMS;
;

BEGIN
sp_defaultERSMEASUREPARMS;
END;
;
/
DROP PROCEDURE sp_defaultERSMEASUREPARMS
;

