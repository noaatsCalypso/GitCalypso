/* RPM-2857 - Support OPL and other position valuation after position archiving */
/* FutureOption and ETO trades will have a TOQ per EXERCISE_FEE linked to the product position. */
/* We want to start tracking the total fees amount separately from total position realized, in the "total_interest" column. */
/* This update statement intializes total_interest for existing positions using an "updatable view". */
/* The updatable view query must unambiguously return each row of the modified table (pl_position) only one time, and it must also be
/* “key preserved” - i.e. Oracle must be able to use a primary key or unique constraint to ensure that each row is only modified once. */
/* This is assured with a primary key constraint on position_id in both pl_position table and the temp table. */

/* Update 1 : initialize fee total from primary TOQ table */
create table temp_total_fee as
select position_id, sum(price) as totalfee 
from trade_open_qty 
where product_family='REALIZED' and (product_type like 'FutureOption%' or product_type like 'ETO%')
group by position_id
;
alter table temp_total_fee add constraint pk_temp_total_fee primary key (position_id)
;
update 
(select pl_position.total_interest, temp_total_fee.totalfee 
from pl_position inner join temp_total_fee on 
temp_total_fee.position_id = pl_position.position_id
) pl_position_view 
set pl_position_view.total_interest = pl_position_view.totalfee
;
drop table temp_total_fee
;

/* Update 2 : update fee total from TOQ history in case archiving has already been done (note pl_position_hist table is not used!) */
create table temp_total_fee_hist as
select position_id, sum(price) as totalfee 
from trade_openqty_hist 
where product_family='REALIZED' and (product_type like 'FutureOption%' or product_type like 'ETO%')
group by position_id
;
alter table temp_total_fee_hist add constraint pk_temp_total_fee_hist primary key (position_id)
;
update 
(select pl_position.total_interest, temp_total_fee_hist.totalfee 
from pl_position inner join temp_total_fee_hist on 
temp_total_fee_hist.position_id = pl_position.position_id
) pl_position_view 
set pl_position_view.total_interest = pl_position_view.total_interest + pl_position_view.totalfee
;
drop table temp_total_fee_hist
;

