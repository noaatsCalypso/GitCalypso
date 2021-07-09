do $$
begin

	create table position_report_temp as (select * from position_report);
	create table tradeopenquantity_report_temp as (select * from tradeopenquantity_report);
	truncate table position_report;
	truncate table tradeopenquantity_report;

	if exists (select 1 from information_schema.columns where table_name='tradeopenquantity_report' AND column_name='decimal_trade_price') then
		alter table tradeopenquantity_report modify decimal_trade_price decimal
	end if;
	
	if exists (select 1 from information_schema.columns where table_name='position_report' AND column_name='futureoption_strike_price') then
		alter table position_report modify futureoption_strike_price decimal
	end if;
	
	if exists (select 1 from information_schema.columns where table_name='tradeopenquantity_report' AND column_name='negotiated_price') then
		alter table tradeopenquantity_report modify negotiated_price decimal
	end if;
	
	if exists (select 1 from information_schema.columns where table_name='tradeopenquantity_report' AND column_name='liquidation_price') then
		alter table tradeopenquantity_report modify liquidation_price decimal
	end if;
	
	insert into position_report select * from position_report_temp;
	insert into tradeopenquantity_report select * from tradeopenquantity_report_temp;
	drop table position_report_temp;
	drop table tradeopenquantity_report_temp;

end;
$$
;