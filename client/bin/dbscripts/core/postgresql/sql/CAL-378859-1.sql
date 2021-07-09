/*CURVE_POINT_ADJ  & CURVE_QUOTE_ADJ grows with zero values - getPricingEnv() call performance issue*/

create table curve_point_adj_new as (select * from curve_point_adj where adj_value !=0)
;
alter table curve_point_adj rename to curve_point_adj_back
;
alter table curve_point_adj_new rename to curve_point_adj
;
drop table curve_point_adj_back
;

create table curve_quote_adj_new as (select * from curve_quote_adj where adj_value !=0)
;
alter table curve_quote_adj rename to curve_quote_adj_back
;
alter table curve_quote_adj_new rename to curve_quote_adj
;
drop table curve_quote_adj_back
;