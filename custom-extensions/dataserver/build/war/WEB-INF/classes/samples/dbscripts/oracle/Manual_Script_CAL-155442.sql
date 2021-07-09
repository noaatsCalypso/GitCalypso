CREATE OR REPLACE PROCEDURE add_domain_values (dname IN varchar2, dvalue in varchar2, ddescription in varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM domain_values WHERE name= dname and value= dvalue;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
        if x = 1 then
                execute immediate 'delete from domain_values where name='||chr(39)||dname||chr(39)||' and value ='||chr(39)||dvalue||chr(39);
                execute immediate 'insert into domain_values ( name, value, description )
                VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
        elsif x=0 THEN
	        execute immediate 'insert into domain_values ( name, value, description ) 
                VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
    END IF;
END add_domain_values;
/

begin
add_domain_values('remittanceType','Repayment','');
end;
/
begin
add_domain_values('remittanceType','IntradayRepayment','');
end;
/
begin
add_domain_values('CustomerTransfer.subtype','Repayment','');
end;
/
begin
add_domain_values('CustomerTransfer.subtype','IntradayRepayment','');
end;
/
begin
add_domain_values('systemKeyword','needToDoInterestCleanup','');
end;
/
