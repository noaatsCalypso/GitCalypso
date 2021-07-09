create table position_report_temp as (select * from position_report);
create table tradeopenquantity_report_temp as (select * from tradeopenquantity_report);
truncate table position_report;
truncate table tradeopenquantity_report;

declare
	v_column_exists number := 0;
	
begin
	
	select count(*) into v_column_exists from user_tab_cols where column_name = 'decimal_trade_price' and table_name = 'tradeopenquantity_report';
	
	if (v_column_exists > 0) then 
		execute immediate 'alter table tradeopenquantity_report modify decimal_trade_price float';
	end if;
		
	select count(*) into v_column_exists from user_tab_cols where column_name = 'futureoption_strike_price' and table_name = 'position_report';
	
	if (v_column_exists > 0) then 
		execute immediate 'alter table position_report modify futureoption_strike_price float';
	end if;
		
	select count(*) into v_column_exists from user_tab_cols where column_name = 'negotiated_price' and table_name = 'tradeopenquantity_report';
	
	if (v_column_exists > 0) then 
		execute immediate 'alter table tradeopenquantity_report modify negotiated_price float';
	end if;
	
	select count(*) into v_column_exists from user_tab_cols where column_name = 'liquidation_price' and table_name = 'tradeopenquantity_report';
	
	if (v_column_exists > 0) then 
		execute immediate 'alter table tradeopenquantity_report modify liquidation_price float';
	end if;
	
	insert into position_report select * from position_report_temp;
	insert into tradeopenquantity_report select * from tradeopenquantity_report_temp;
end;

drop position_report_temp;
drop tradeopenquantity_report_temp;
/