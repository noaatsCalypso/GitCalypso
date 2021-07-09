
CREATE OR REPLACE PROCEDURE drop_margin_static_table
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER('margin_concentration_risk');
    
	exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
		EXECUTE IMMEDIATE 'drop table margin_concentration_risk';
		
END IF;
END;
/

begin
drop_margin_static_table;
end;
/
