/* RPM-2857 - Support OPL and other position valuation after position archiving */
/* FutureOption and ETO trades will have a TOQ per EXERCISE_FEE linked to the product position. */
/* We want to start tracking the total fees amount separately from total position realized, in the "total_interest" column. */
select * into feetoq_prime from (
	select position_id, sum(price) as totalfee
	from trade_open_qty 
	where product_family='REALIZED' and (product_type like 'FutureOption%' or product_type like 'ETO%')
	group by position_id
	union all
	select position_id, sum(price) as totalfee
	from trade_openqty_hist
	where product_family='REALIZED' and (product_type like 'FutureOption%' or product_type like 'ETO%')
	group by position_id
) a
go

select * into feetoq from (
  select position_id, sum(totalfee) as totalfee
  from feetoq_prime 
  group by position_id
) a
go

create index feetoq_idx on feetoq(position_id)
go

update pl_position 
set total_interest = totalfee 
from feetoq 
where pl_position.position_id = feetoq.position_id 
go

drop table feetoq_prime
go
drop table feetoq
go
