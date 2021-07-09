/*CURVE_POINT_ADJ  & CURVE_QUOTE_ADJ grows with zero values - getPricingEnv() call performance issue*/

select * INTO curve_point_adj_new from curve_point_adj where adj_value !=0
go
sp_rename curve_point_adj,curve_point_adj_back
go
sp_rename curve_point_adj_new,curve_point_adj
go
drop table curve_point_adj_back
go

select * INTO curve_quote_adj_new from curve_quote_adj where adj_value !=0
go
sp_rename curve_quote_adj,curve_quote_adj_back
go
sp_rename curve_quote_adj_new,curve_quote_adj
go
drop table curve_quote_adj_back
go