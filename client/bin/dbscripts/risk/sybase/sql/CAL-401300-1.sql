select * into position_report_temp from position_report
go
select * into tradeopenquantity_report_temp from tradeopenquantity_report
go
truncate table position_report
go
truncate table tradeopenquantity_report
go
if exists (select 1 from syscolumns where id = object_id("tradeopenquantity_report") and name = "decimal_trade_price")
	begin 
		exec ("alter table tradeopenquantity_report modify decimal_trade_price decimal")
	end
go
if exists (select 1 from syscolumns where id = object_id("position_report") and name = "futureoption_strike_price")
	begin 
		exec ("alter table position_report modify futureoption_strike_price decimal")
	end
go
if exists (select 1 from syscolumns where id = object_id("tradeopenquantity_report") and name = "negotiated_price")
	begin 
		exec ("alter table tradeopenquantity_report modify negotiated_price decimal")
	end
go
if exists (select 1 from syscolumns where id = object_id("tradeopenquantity_report") and name = "liquidation_price")
	begin 
		exec ("alter table tradeopenquantity_report modify liquidation_price decimal")
	end
go
insert into position_report select * from position_report_temp
go
insert into tradeopenquantity_report select * from tradeopenquantity_report_temp
go
drop table position_report_temp
go
drop table tradeopenquantity_report_temp
go