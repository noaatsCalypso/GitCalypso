/* Run this script when we are upgrading from V12 or Liquidity 1.0.0.0 to 1.1.0.0 or higher versions  */
create table ba_expression_back as select * from ba_expression
;
create table ba_expr_variable_back as select * from ba_expr_variable
;
create table ba_expr_variable_params_back as select * from ba_expr_variable_params
;

CREATE OR REPLACE PROCEDURE rename_table_if_exists
    (tab_name IN varchar2 , new_tab_name IN varchar2)
AS
    x number :=0 ;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER(tab_name) ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x > 0 THEN
EXECUTE IMMEDIATE 'alter table ' ||tab_name || ' rename to '|| new_tab_name;
END IF;
END rename_table_if_exists;
/

begin 
rename_table_if_exists('ba_expression','liq_expression');
rename_table_if_exists('ba_expr_variable','liq_expr_variable');
rename_table_if_exists('ba_expr_variable_params','liq_expr_variable_params');
end;
/
