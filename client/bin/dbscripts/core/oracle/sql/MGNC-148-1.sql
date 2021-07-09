
CREATE OR REPLACE PROCEDURE drop_margin_static_table
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER('margin_bucket');
    
	exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
		EXECUTE IMMEDIATE 'drop table margin_bucket';
		EXECUTE IMMEDIATE 'drop table margin_ccy_to_level';
		EXECUTE IMMEDIATE 'drop table margin_concentration_risk';
		EXECUTE IMMEDIATE 'drop table margin_correlation';
		EXECUTE IMMEDIATE 'drop table margin_weights';
		EXECUTE IMMEDIATE 'drop table margin_rates';
		
END IF;
END;
/

begin
drop_margin_static_table;
end;
/
