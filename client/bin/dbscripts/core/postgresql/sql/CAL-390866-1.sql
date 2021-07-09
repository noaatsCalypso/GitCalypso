/* RPM-2857 - Support OPL and other position valuation after position archiving */
/* FutureOption and ETO trades will have a TOQ per EXERCISE_FEE linked to the product position. */
/* We want to start tracking the total fees amount separately from total position realized, in the "total_interest" column. */
create table feetoq_prime
as
select * from (
	select position_id, sum(price) as totalfee
	from trade_open_qty 
	where (
		product_family = 'REALIZED'
		and (
			cast(product_type as varchar) like 'FutureOption%'
			or cast(product_type as varchar) like 'ETO%'
		)
	)
	group by position_id
	union all
	select position_id, sum(price) as totalfee
	from trade_openqty_hist
	where (
		product_family = 'REALIZED'
		and (
			cast(product_type as varchar) like 'FutureOption%'
			or cast(product_type as varchar) like 'ETO%'
		)
	)
	group by position_id
) as a
;

create table feetoq
as
select * from (
	select position_id, sum(totalfee) as totalfee
	from feetoq_prime
	group by position_id
) as a
;

create index feetoq_idx on feetoq(position_id)
;

update pl_position
set total_interest = totalfee
from feetoq
where pl_position.position_id = feetoq.position_id
;

drop table feetoq_prime
;
drop table feetoq
;